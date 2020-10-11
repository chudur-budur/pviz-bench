% The GAA constraint function values and CV. We are using this
% for re-evaluation at the end.
function [g, cv] = gaa_cv(x)
		[~, ~, g, cv] = gaa_true(x, 10);
end
