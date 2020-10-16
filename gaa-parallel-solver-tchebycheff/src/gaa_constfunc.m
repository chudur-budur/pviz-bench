% The GAA constraint function, we are using this for the fmincon() routine
% We need this because the call back function in fmincon needs this particular
% signature.
function [g, geq] = gaa_constfunc(x)
		[~, ~, g_, cv_] = gaa_true(x, 10);
        %% in this case, g means cv
        g = cv_;
        geq = [];
end
