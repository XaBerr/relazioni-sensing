function [so] = vectorSum(s1,s2)
    so = s1;
    for i = 1:size(so, 2)
        so(i) = sqrt(so(i)^2 + s2(i)^2);
    end
end

