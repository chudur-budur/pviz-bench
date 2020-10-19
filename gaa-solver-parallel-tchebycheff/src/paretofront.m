function [indices] = paretofront(F)
%PARETOFRONT Return the indices of the non-dominated points of F
%   This function basically enumerates the non-dominated points
%   of F in O(n^2) time. It only returns the indices of the first
%   front (i.e. Pareto-optimal front).

    flag1 = any(bsxfun(@lt,permute(F,[1 3 2]),permute(F,[3 1 2])),3);
    flag2 = any(bsxfun(@gt,permute(F,[1 3 2]),permute(F,[3 1 2])),3);

    % now build flag2
    flag2 = flag2 & ~flag1 ;

    % next build the dominance flag matrix
    flag = bsxfun(@minus, bsxfun(@and, flag1 == 1, flag2 == 0), ...
        bsxfun(@and, flag1 == 0, flag2 == 1));

    all_indices = 1:size(F,1);
    dom_mat = [all_indices.', flag];

    % get the indices of the current pf
    minus_one_count = [all_indices.', sum(dom_mat == -1,2)] ;
    indices = minus_one_count(minus_one_count(:,2) == 0,1);
end

