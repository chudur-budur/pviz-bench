function [X, F, W] = crash_parallel_solver(refs_file, N, mode)
%%CRASH_SOLVER This function solves the gaa problem on each of the 
% reference directions found from LHS. The directionsa are read from 
% refs_file file. The number of parallel pool is given in N.
    
    % Load the reference directions
    W = csvread(refs_file);
    % [number of reference directions, number of objectives]
    [wn, m] = size(W);
    
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
    % sideal = zeros(1, size(F_,2)); 
    nadir = max(F_);
    
    % find an initial solution that is closest to W(i,:)
    % and use that as the starting point.
    Wc = zeros(wn, m);
    for i = 1:size(Wc,1)
        [~,j] = min(vecnorm(F_ - W(i,:), 2, 2));
         Wc(i,:) = W(j,:);
    end

    % wn = 500;
    F = zeros(wn, m);
    X = zeros(wn, n);
    
    % N : number of workers
    if ischar(N)
        N = int64(str2double(N));
    end
    
    if N > 0
        % Clean up the environment and start a new local parpool
        pool = gcp('nocreate');
        if ~isempty(pool)
            delete(pool);
        end
        pool = parpool(N);
        tic
        parfor i = 1:wn
            % size(Wc,1)
            fprintf("Solving reference direction: %d\n", i);
            % Anonymize gaa function so that it can take a reference 
            % direction.
            if strcmp(mode, 'ga')
                crash_func = @(z)crash_scalarized(z, W(i,:), ideal, nadir);
            else
                crash_func = @(z)crash_scalarized(z, Wc(i,:), ideal, nadir);
            end
            
            if strcmp(mode, 'fmincon')
                % Solve with fmincon
                [x, ~, ~, ~, ~, ~, ~] = ...
                    fmincon(crash_func, X_(i,:), [], [], [], [], ...
                    LB, UB, [], fmcopt);
            elseif strcmp(mode, 'patternsearch')
                % Solve with patternsearch
                [x, ~, ~, ~] = ...
                    patternsearch(crash_func, X_(i,:), [], [], [], [], ...
                        LB, UB, [], psopt);
            else
                % Solve with ga
                [x, ~, ~, ~] = ...
                    ga(crash_func, n, [], [], [], [], LB, UB, [], gaopt);
            end

            % Now get the original objective values from xval solution.
            f = crash(x);
            % Save them into the arrays
            X(i,:) = x;
            F(i,:) = f;
        end
        toc
    else
        tic
        for i = 1:wn
            % size(Wc,1)
            fprintf("Solving reference direction: %d\n", i);
            % Anonymize gaa function so that it can take a 
            % reference direction.
            if strcmp(mode, 'ga')
                crash_func = @(z)crash_scalarized(z, W(i,:), ideal, nadir);
            else
                crash_func = @(z)crash_scalarized(z, Wc(i,:), ideal, nadir);
            end

            if strcmp(mode, 'fmincon')
                % Solve with fmincon
                [x, ~, ~, ~, ~, ~, ~] = ...
                    fmincon(crash_func, X_(i,:), [], [], [], [], ...
                    LB, UB, [], fmcopt);
            elseif strcmp(mode, 'patternsearch')
                % Solve with patternsearch
                [x, ~, ~, ~] = ...
                    patternsearch(crash_func, X_(i,:), [], [], [], [], ...
                    LB, UB, [], psopt);
            else
                % Solve with ga
                [x, ~, ~, ~] = ...
                    ga(crash_func, n, [], [], [], [], LB, UB, [], gaopt);
            end

            % Now get the original objective values from xval solution.
            f = crash(x);
            % Save them into the arrays
            X(i,:) = x;
            F(i,:) = f;
        end
        toc
    end

    % Now get the first front
    idx = paretofront(F);
    F = F(idx,:);
    X = X(idx,:);
end
