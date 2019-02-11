function [reduced, left, right] = cutterScale(s1, cuttingScale)
    if nargin < 2
      cuttingScale = 0.9;
    end
    if size(s1, 1) < size(s1, 2)
        s1 = s1.';
    end
    [minimum] = min(s1);
    [maximum, pos] = max(s1);
    left = pos;
    right = pos;
    while (left ~= 0) && (s1(left) > (maximum - (maximum - minimum) * cuttingScale))
        left = left - 1;
    end
    while (right ~= (size(s1, 1) - 1)) && (s1(right) > (maximum - (maximum - minimum) * cuttingScale))
        right = right + 1;
    end
    reduced = s1(left:right);
end

