% The GAA objective function, we are using this.
function f = gaa(x, w)
    % If there is no w, just evaluate the function.
    if nargin == 1
        [~, f, ~, ~] = gaa_true(x, 10);
    % If there are weights then evaluate the weighted sum single obj func.
    else
		[~, f_, ~, ~] = gaa_true(x, 10);
        % nadir = [80.0, 2250.0, 100.0, 3.0, 500.0, 45000, -1000, -10.0, -150.0, 3.0];
        % ideal = [70.0, 1500.0, 50.0, 1.0, 300.0, 40000, -3000, -20.0, -200.0, 0.0];
        % This is better ideal and nadir points.
        nadir = [100.0, 3000.0, 100.0, 5.0, 500.0, 50000, -500, 0.0, -100.0, 5.0];
        ideal = [50.0, 1000.0, 50.0, 0.0, 100.0, 30000, -5000, -50.0, -300.0, 0.0];
        f = sum(((f_ - ideal) ./ (nadir - ideal)) .* w);
    end
end
