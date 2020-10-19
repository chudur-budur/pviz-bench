% The GAA objective function, we are using this.
function f = gaa_scalarized(x, w, ideal, nadir)
    [~, f_, ~, ~] = gaa(x);
    % This is better ideal and nadir points.
    fn = (f_ - ideal) ./ (nadir - ideal);
    f = (0.001 * sum(fn .* w)) + max(fn .* w);
end
