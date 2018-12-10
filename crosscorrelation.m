function [lagDiff] = crosscorrelation(s1, s2, windowSize)
    lagDiff = [];
    for i = 1:ceil(size(s1/windowSize, 1))
        vMin = (i-1) * windowSize + 1;
        vMax =  i * windowSize;
        if vMax > size(s1, 1)
            vMax = size(s1, 1); 
        end
        [acor, lag] = xcorr(s1(vMin:vMax), s2(vMin:vMax));
        [~,I] = max(abs(acor));
        lagDiff = [lagDiff lag(I)];
    end
end