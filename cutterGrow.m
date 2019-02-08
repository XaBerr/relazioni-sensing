function [reduced, left, right] = cutterGrow(s1)
    if size(s1, 1) < size(s1, 2)
        s1 = s1.';
    end
    [maximum, pos] = max(s1);
    left = pos;
    right = pos;
    while (left ~= 0) && (s1(left) > s1(left-1))
        left = left - 1;
    end
    while (right ~= (size(s1, 1) - 1)) && (s1(right) > s1(right+1))
        right = right + 1;
    end
    reduced = s1(left:right);
end

