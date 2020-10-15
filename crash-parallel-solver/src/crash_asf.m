function f = crash_asf(x, w, ideal, nadir)
    f_ = crash(x);
    % disp(f_)
    % f = sum(((f_ - ideal) ./ (nadir - ideal)) .* w);
    f__ = ((f_ - ideal) ./ (nadir - ideal)) .* w ;
    % disp(f__)
    f = max(f__) + (0.0001 * sum(f__)) ;
end
