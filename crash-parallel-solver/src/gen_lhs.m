% This script generates a a set of reference directions 
% using LHS method and save them in a .mat file.

clear;

% w = lhsdesign(3112, 10);
% w = lhsdesign(6049, 10);
w = lhsdesign(1960, 3);
filename = strcat('../data/refs-lhs-', num2str(size(w,1)), '.mat');
save(filename, 'w');
