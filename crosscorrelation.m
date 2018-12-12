function [lagDiff] = crosscorrelation(s2, s1, windowSize)
    lagDiff = [];
    for i = 1:ceil(size(s1/windowSize, 1))
        vMin = (i-1) * windowSize + 1;
        vMax =  i * windowSize;
        if vMax > size(s1, 1)
            vMax = size(s1, 1); 
        end
        [acor, lag] = xcorr(abs(fft(s1(vMin:vMax))), abs(fft(s2(vMin:vMax))));
        [~,I] = max(abs(acor));
        lagDiff = [lagDiff lag(I)];
    end
end