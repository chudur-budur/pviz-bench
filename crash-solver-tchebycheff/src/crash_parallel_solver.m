function [] = crash_lhc_solver(N, refs_file)
%%CRASH_SOLVER This function solves the gaa problem on each of the 
% reference directions found from LHS. The directionsa are read from 
% refs_file file. The number of parallel pool is given in N.

    % Load the reference directions
    W = csvread('../data/refs-lhc.csv');
    % [number of reference directions, number of objectives]
    [wn, m] = size(W);
    
    % N : number of workers
    if ischar(N)
        N = str2num(N);
    end

    % Clean up the environment and start a new local parpool
    pool = gcp('nocreate');
    if ~isempty(pool)
        delete(pool);
    end
    pool = parpool(N);

    rng(123456);

    % Max function eval.
    febound = 100000;

    % fmincon options
    fmcopt = optimoptions('fmincon');
    fmcopt.MaxFunEvals = febound;
    fmcopt.Display = 'off' ;

    % pattern search option
    psopt = optimoptions('patternsearch');
    psopt.MaxFunEvals = febound;
    % psopt.InitialMeshSize = (1.0 / wn);
    % psopt.InitialMeshSize = 1.0;
    psopt.TolX = 1e-7;
    psopt.TolBind = 1e-6;
    psopt.SearchMethod = @MADSPositiveBasis2N;
    % psopt.SearchMethod = @GPSPositiveBasis2N;
    % psopt.SearchMethod = @GSSPositiveBasis2N;
    % psopt.SearchMethod = {@searchneldermead, 10};
    % psopt.SearchMethod = {@searchga,100};
    psopt.CompletePoll = 'on';
    psopt.CompleteSearch = 'on';

    % ga option
    gaopt = optimoptions('ga');
    gaopt.MaxGenerations = febound;

    % Number of variables
    n = 5;

    % Variable bounds
    LB = [1.0, 1.0, 1.0, 1.0, 1.0];
    UB = [3.0, 3.0, 3.0, 3.0, 3.0];

    % Initialize wn number of initial variable vectors
    X_ = zeros(wn, n);
    for i = 1:n
        X_(:,i) = (UB(i) - LB(i)) .* rand(wn, 1) + LB(i);
    end

    % evalue the initial population and estimate bounds
    F_ = crash(X_);
    ideal = min(F_);
    ideal = ideal - (ideal .* 0.5);
    nadir = max(F_);
    
    % find an initial solution that is closest to W(i,:)
    % and use that as the starting point.
    Wc = zeros(size(W));
    for i = 1:size(Id,1)
        [~,j] = min(vecnorm(F_ - W(i,:), 2, 2));
         Wc(i) = j;
    end

    F = zeros(wn, m);
    X = zeros(wn, n);
    tic
    parfor i = 1:size(W,1)
        fprintf("Solving reference direction: %d\n", i);
        % Anonymize gaa function so that it can take a reference direction.
        crash_func = @(z)crash_scalarized(z, Wc(i), ideal, nadir);

        % Solve with fmincon
        % [x, f, exitflag, output, lambda, grad, hessian] = ...
        %    fmincon(crash_func, X_(j,:), [], [], [], [], ...
        %    LB, UB, [], fmcopt);

        % Solve with patternsearch
        % [x, f, exitflag, output] = ...
        %       patternsearch(crash_func, X_(j,:), [], [], [], [], ...
        %       LB, UB, [], psopt);

        [x, ~, ~, ~] = ...
            ga(crash_func, n, [], [], [], [], LB, UB, [], ...
            gaopt);

        % Now get the original objective values from xval solution.
        f = crash(x);
        % Save them into the arrays
        X(i,:) = x;
        F(i,:) = f;
    end
    toc

    % Now get the first front
    idx = paretofront(F);
    F = F(idx,:);
    X = X(idx,:);

    save('../data/lhc-x.mat', 'X');
    save('../data/lhc-f.mat', 'F');

    dlmwrite('../data/lhc-x.csv', X, ...
        'delimiter', ',', 'precision', '%e', 'newline', 'unix');
    dlmwrite('../data/lhc-f.csv', F, ...
        'delimiter', ',', 'precision', '%e', 'newline', 'unix');
end
