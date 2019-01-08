function [lagDiff] = crosscorrelation(s1, s2, windowSize, windowStep)
    lagDiff = [];    
    vMin = 1;
    vMax =  windowSize;
    while vMax <= size(s1, 1)
        [acor, lag] = xcorr(abs(fft(s1(vMin:vMax))), abs(fft(s2(vMin:vMax))));
        [~,I] = max(abs(acor));
        lagDiff = [lagDiff lag(I)];
        vMin = vMin + windowStep;
        vMax = vMax + windowStep;
    end
end