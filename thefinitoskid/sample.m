%% Code sections are highlighted.
% System command are supported...
!gzip sample.m
% ... as is line continuation.
A = [1, 2, 3,... % (mimicking the ouput is good)
     4, 5, 6]
fid = fopen('testFile.text', 'w')
for i=1:10
  fprintf(fid,'%6.2f \n', i);
end
x=1; %% this is just a comment, though
% Context-sensitive keywords get highlighted correctly...
p = properties(mydate); %(here, properties is a function)
x = linspace(0,1,101);
y = x(end:-1:1)
% ... even in nonsensical code.
]end()()(((end end)end ))))end (function end
%{
    block comments are supported
%} even
runaway block comments
are
