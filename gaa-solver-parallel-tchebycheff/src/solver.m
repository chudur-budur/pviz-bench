refs_file = '../data/refs-das-dennis.csv';

%[X, F, G, W] = gaa_parallel_solver(refs_file, 3, 'ga');

[path,name,~] = fileparts(refs_file);
prefix = split(name, '-');
prefix(1) = [];
if size(prefix,1) > 1
    prefix = strjoin(prefix, '-');
end
x_mat = fullfile(path, strcat(prefix, '-x.mat'));
x_csv = fullfile(path, strcat(prefix, '-x.csv'));
f_mat = fullfile(path, strcat(prefix, '-f.mat'));
f_csv = fullfile(path, strcat(prefix, '-f.csv'));
g_mat = fullfile(path, strcat(prefix, '-g.mat'));
g_csv = fullfile(path, strcat(prefix, '-g.csv'));

save(x_mat, 'X');
save(f_mat, 'F');
save(g_mat, 'G');

dlmwrite(x_csv, X, 'delimiter', ',', 'precision', '%e', ...
    'newline', 'unix');
dlmwrite(f_csv, F, 'delimiter', ',', 'precision', '%e', ...
    'newline', 'unix');
dlmwrite(g_csv, G, 'delimiter', ',', 'precision', '%e', ...
    'newline', 'unix');

% plot
figure;
scatter3(F(:,1), F(:,2), F(:,3));