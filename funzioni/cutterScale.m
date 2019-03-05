function [reduced, left, right] = cutterScale(s1, cuttingScale)
    if nargin < 2
      cuttingScale = 0.9;
    end
    if size(s1, 1) < size(s1, 2)
        s1 = s1.';
    end
    [minimum] = min(s1);
    s2 = s1 - minimum;
    [maximum, pos] = max(s2);
    left = pos;
    right = pos;
    while (left ~= 0) && (s2(left) > (maximum * cuttingScale))
        left = left - 1;
    end
    while (right ~= (size(s2, 1) - 1)) && (s2(right) > (maximum * cuttingScale))
        right = right + 1;
    end
    reduced = s1(left:right);
end

