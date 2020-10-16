function f = crash_scalarized(x, w, ideal, nadir)
    f_ = crash(x);
    f = max((((f_ - ideal) ./ (nadir - ideal)) .* w) + ...
        (0.01 .* (f_ ./ (nadir - ideal)) .* w));
    % f = max(w .* (f_ - ideal));
end
