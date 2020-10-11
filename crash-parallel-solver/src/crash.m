function f = crash(x, w)
    % If there is no w, just evaluate the function.
    if nargin == 1
        f = crash_true(x);
    else
        f_ = crash_true(x);
        nadir = [5000, 100, 10];
        ideal = [1500, 1, 0];
        f = sum(((f_ - ideal) ./ (nadir - ideal)) .* w);
end
