%% Definir Dominio. Nodos + elementos
fprintf(fopen('nod.txt','wt'),webread('https://pastebin.com/raw/0BLPxUuu'));
fprintf(fopen('ele.txt','wt'),webread('https://pastebin.com/raw/hfcg7wc4'));
fclose('all');
nodosT10 = load('nod.txt');
elementosT10 = load('ele.txt'); % La malla es para elementos T10
%% Post process para convertir malla T10 a T4
elementos = elementosT10(:,2:5); % La primera columna es indice
losNodosT4 = intersect(nodosT10(:,1),elementos(:));
nodos = nodosT10(ismember(nodosT10(:,1),losNodosT4),1:4); %columna1=indice
for en = 1:numel(elementos)
    elementos(en) = find(elementos(en)==nodos(:,1));
end
nodos = nodos(:,2:4); % eliminamos columna indice