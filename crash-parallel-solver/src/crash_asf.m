function f = crash_asf(x, w, ideal, nadir)
        f_ = crash_true(x);
        f = sum(((f_ - ideal) ./ (nadir - ideal)) .* w);
end
