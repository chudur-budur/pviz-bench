function f = crash_scalarized(x, w, ideal, nadir)
    f_ = crash(x);
    
    fn = (f_ - ideal) ./ (nadir - ideal);
    
    f = (0.001 * sum(fn .* w)) + max(fn .* w);
    
    %f = max((abs((f_ - ideal) ./ (nadir - ideal)) .* w) + ...
    %    (0.0001 .* abs(f_ ./ (nadir - ideal)) .* w));
    
    % f = max(w .* ((f_ - ideal) ./ (nadir - ideal)));
    
    % f = max(((f_ - w) ./ (nadir - ideal)) .* w);
end
