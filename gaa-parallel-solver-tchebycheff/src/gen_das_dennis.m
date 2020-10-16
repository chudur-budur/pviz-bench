% This script generates a a set of reference directions 
% using Das-Dennis's method and save them in a .mat file.

clear;

% 1033 points
% w = gen_refdirs(4, 10, ...
%             [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1],... 
%             [1, 4, 6, 8, 8, 10, 8, 6, 4, 2]);

% 6049 points
% w = gen_refdirs(10, 10, ...
%             [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1],... 
%             [1, 2, 3, 4, 5, 5, 4, 3, 2, 2]);
        
% 3112 points
w = gen_refdirs(10, 10, ...
            [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1],... 
            [1, 2, 3, 3, 5, 3, 3, 2, 2, 2]);

filename = strcat('../data/refs-das-dennis-', num2str(size(w,1)), '.mat');
save(filename, 'w');
