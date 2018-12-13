function [lagDiff] = crosscorrelation(s2, s1, windowSize, windowStep)
    lagDiff = [];
    for i = 1:(ceil(size(s1/windowStep, 1))-1)
        vCenter = round(windowStep * (i - 0.5));
        vDelta = round(windowSize / 2);
        vMin = vCenter - vDelta;
        vMax =  vCenter + vDelta;
        if vMin < 1
            vMin = 1; 
        end
        if vMax > size(s1, 1)
            vMax = size(s1, 1); 
        end
        [acor, lag] = xcorr(abs(fft(s1(vMin:vMax))), abs(fft(s2(vMin:vMax))));
        [~,I] = max(abs(acor));
        lagDiff = [lagDiff lag(I)];
    end
end