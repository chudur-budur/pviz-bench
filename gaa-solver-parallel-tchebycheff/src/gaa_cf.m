% The GAA constraint function, we are using this for the fmincon() routine
% We need this because the call back function in fmincon needs this particular
% signature.
function [g, geq] = gaa_cf(x)
		[~, ~, ~, cv] = gaa(x);
        %% in this case, g means cv
        g = cv;
        geq = [];
end
