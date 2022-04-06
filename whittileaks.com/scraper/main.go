package main

import (
	"encoding/json"
	"fmt"
	"net/url"
	"os"
	"strings"
	"sync"

	"github.com/gocolly/colly/v2"
)

const (
	// Set at a higher number for faster scraping.
	// Since HTTP requests are limited by I/O you should be able to set this at
	// a value several times higher than number of threads and still
	// get augmenting returns. Setting this at 10 scrapes typical small google site in couple of seconds.
	parallelism    = 10
	mainURL        = "https://sites.google.com/site/whittileak"
	outputJSONFile = "whittileaks.json"
)

type page struct {
	// on visit
	LinkTitle  string `json:"link_title"`
	Href       string `json:"href"`
	IsTopLevel bool   `json:"top_level"`
	// After fulfillment
	Title           string    `json:"title"`
	MainContentHTML string    `json:"content"`
	Cabinets        []cabinet `json:"cabinets"`
}

type cabinet struct {
	Title string `json:"title"`
	Files []file `json:"files"`
}

type file struct {
	// Table column data.
	Data [8]string `json:"data"`
	// Links if any in order of appearance.
	Links []string `json:"links,omitempty"`
}

func main() {
	fp, err := os.Create(outputJSONFile)
	if err != nil {
		panic(err)
	}
	URL, err := url.Parse(mainURL)
	if err != nil {
		panic(err)
	}
	links := getPages(mainURL)
	var wg sync.WaitGroup
	checkin := make(chan struct{}, parallelism)
	for i := range links {
		i := i // escape loop variable.
		wg.Add(1)
		go func() {
			checkin <- struct{}{}
			err := links[i].fulfill("https://" + URL.Host)
			if err != nil {
				fmt.Println(err)
			} else {
				fmt.Println("finished fulfilling", links[i].Title)
			}
			<-checkin
			wg.Done()
		}()
	}
	wg.Wait()
	enc := json.NewEncoder(fp)
	enc.SetIndent("", " ") // uncomment for pretty printing.
	err = enc.Encode(links)
	if err != nil {
		panic(err)
	}
	fmt.Println("finished. Enjoy your day!")
}

func getPages(googleSiteURL string) []page {
	var links []page
	c := colly.NewCollector()
	c.OnHTML("ul.has-expander > li.topLevel", func(h *colly.HTMLElement) {
		if strings.Contains(h.Attr("class"), "parent") {
			h.ForEach("ul > li > div > a", func(i int, h *colly.HTMLElement) {
				links = append(links, page{
					LinkTitle:  h.Text,
					IsTopLevel: true,
					Href:       h.Attr("href"),
				})
			})
		} else {
			links = append(links, page{
				LinkTitle: h.Text,
				Href:      h.ChildAttr("div > a", "href"),
			})
		}
	})
	err := c.Visit(mainURL)
	if err != nil {
		panic(err)
	}
	return links
}

func (l *page) fulfill(siteURL string) error {
	c := colly.NewCollector()
	url := siteURL + l.Href
	c.OnHTML("#sites-canvas", func(h *colly.HTMLElement) {
		l.Title = h.ChildText("#sites-page-title-header")
	})

	c.OnHTML("#sites-canvas-main-content > table > tbody > tr > td > div", func(h *colly.HTMLElement) {
		var err error
		l.MainContentHTML, err = h.DOM.Html()
		if err != nil {
			fmt.Printf("error getting main content %v: %v\n", url, err.Error())
		}
	})

	c.OnHTML("#filecabinet-body", func(h *colly.HTMLElement) {
		var cabs []cabinet
		// Get unfiled documents.
		unfiled := cabinet{Title: "Unfiled"}
		h.ForEach("#JOT_FILECAB_folder__unfiled", func(_ int, h *colly.HTMLElement) {
			h.ForEach("tbody > tr", func(_ int, h *colly.HTMLElement) {
				unfiled.Files = append(unfiled.Files, getFilesFromTR(h))
			})
			cabs = []cabinet{unfiled}
		})

		// First get cabinet header
		h.ForEach("table.filecabinet-header", func(_ int, h *colly.HTMLElement) {
			cabs = append(cabs, cabinet{Title: h.ChildText("tbody > tr > th > span[aria-hidden=true]")})
		})
		// Then populate cabinet files.
		h.ForEach("div.collapsible > table > tbody", func(cabIdx int, h *colly.HTMLElement) {
			if cabIdx == 0 {
				//skip first data, is unfiled cabinet
				return
			}
			if len(unfiled.Files) == 0 {
				cabIdx--
			}
			if cabIdx >= len(cabs) {
				fmt.Println("idx", cabIdx, " exceeds length of cabinet", len(cabs), "so skipping")
				return
			}
			cab := &cabs[cabIdx]
			h.ForEach("tr", func(fileIdx int, h *colly.HTMLElement) {
				cab.Files = append(cab.Files, getFilesFromTR(h))
			})
		})
		l.Cabinets = append(l.Cabinets, cabs...)
	})
	return c.Visit(url)
}

func getFilesFromTR(h *colly.HTMLElement) (f file) {
	h.ForEach("td", func(i int, h *colly.HTMLElement) {
		f.Data[i] = h.Text
		h.ForEach("a", func(i int, h *colly.HTMLElement) {
			f.Links = append(f.Links, h.Attr("href"))
		})
	})
	return f
}
