% This script solves the gaa problem on each of the reference directions found from LHS.
% The directionsa are read from weights-lhs-N.mat file.

clear;
format shortg;
format compact;

% Load the reference directions
load('../data/refs-lhs-1960.mat', 'w');
% [number of reference directions, number of objectives]
[wn, m] = size(w); 

rng(123456);

% Max function eval.
febound = 10000;

% fmincon options
fmcopt = optimoptions('fmincon');
fmcopt.MaxFunEvals = febound;
fmcopt.Display = 'off' ;

% pattern search option
psopt = psoptimset(@patternsearch);
psopt = psoptimset(psopt, 'MaxFunEvals', febound);
% psopt = psoptimset(psopt, 'InitialMeshSize', (1.0 / popsize));
% psopt = psoptimset(psopt, 'InitialMeshSize', 1.0);
psopt = psoptimset(psopt, 'TolX', 1e-7, 'TolBind', 1e-6);
psopt = psoptimset(psopt, 'SearchMethod', @MADSPositiveBasis2N);
% psopt = psoptimset(psopt, 'SearchMethod', @GPSPositiveBasis2N);
% psopt = psoptimset(psopt, 'SearchMethod', @GSSPositiveBasis2N);
% psopt = psoptimset(psopt, 'SearchMethod', {@searchneldermead,10});
% psopt = psoptimset(psopt, 'SearchMethod', {@searchga,100});
psopt = psoptimset(psopt, 'CompletePoll', 'on');
psopt = psoptimset(psopt, 'CompleteSearch', 'on');   

% Number of variables
n = 5;

% Variable bounds
lb = [1.0, 1.0, 1.0, 1.0, 1.0];
ub = [3.0, 3.0, 3.0, 3.0, 3.0];

% Initialize wn number of initial variable vectors
x = zeros(wn, n);
for i = 1:n
    x(:,i) = (ub(i) - lb(i)) .* rand(wn, 1) + lb(i);
end

% fprintf("Initial f:\n");
% f = gaa(x(1,:));
% disp(f)
% [g, cv] = gaa_cv(x(1,:));
% disp(g)
% disp(cv)
% f = gaa(x(1,:), w(1,:));
% disp(f)

F = zeros(wn, m);
X = zeros(wn, n);
tic
for i = 1:size(w,1)
    fprintf("Solving reference direction: %d\n", i);
    % Anonymize gaa function so that it can take a reference direction.
    crash_func = @(z)crash(z, w(i, :));

    % Solve with fmincon 
    [xval, fval, exitflag, output, lambda, grad, hessian] = ...
            fmincon(crash_func, x(i,:), [], [], [], [], lb, ub, [], fmcopt);

    % Solve with patternsearch    
    % [xval, fval, exitflag, output] = ...
    %        patternsearch(gaa_func, x(i,:), [], [], [], [], lb, ub, ...
    %                          @gaa_constfunc, psopt) ;

    % Weighted sum of objective values
    % fprintf("Optimized weighted f: %.4f\n", fval);
    % Actual objective values from the final solution xval.
    % fprintf("Final f:\n")
    
    % Now get the original objective values from xval solution.
    f = crash(xval);
    % Save them into the arrays
    X(i,:) = xval;
    F(i,:) = f;
end
toc

save('../data/crash-lhs-10d-x.mat', 'X');
save('../data/crash-lhs-10d-f.mat', 'F');

dlmwrite('../data/crash-lhs-10d-x.csv', X, ...
    'delimiter', ';', 'precision', '%e', 'newline', 'unix');
dlmwrite('../data/crash-lhs-10d-f.csv', F, ...
    'delimiter', ';', 'precision', '%e', 'newline', 'unix');
