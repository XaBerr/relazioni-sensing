function [lagDiff] = crosscorrelation(s1, s2, windowSize, windowStep)
    lagDiff = [];
    vMin    = 1;
    vMax    =  windowSize;
    flag = 0;
    cuttingScale = 0.9;
    while vMax <= size(s1, 1)
        ss1 = abs(fft(s1(vMin:vMax)));
        ss2 = abs(fft(s2(vMin:vMax)));
        ss1 = ss1 - mean(ss1);
        ss2 = ss2 - mean(ss2);
        [yValues, xValues] = xcorr(ss1, ss2);
        yValues = abs(yValues);
        [yValue xValue] = findMaxWithInterp2(yValues, xValues);
%         [val, I] = max(signal2analize);
%         [signal2analize left right] = cutterGrow(signal2analize);
%         reduced = signal2analize;
        
%         [val, I] = max(signal2analize);
%         if flag < 10
%             flag = flag + 1;
%             figure;
%             plot(1:size(signal2analize, 1), signal2analize);
%         end
        lagDiff = [lagDiff xValue];
        vMin = vMin + windowStep;
        vMax = vMax + windowStep;
    end
end