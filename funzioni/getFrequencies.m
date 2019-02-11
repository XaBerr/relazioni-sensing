function y = getFrequencies(s2, s1, windowSize, windowStep, lightSpeed, refractiveIndex)
    vMin = 1;
    vMax =  windowSize;
    ustrain = [];
    cont = 0;
    while vMax <= size(s1, 1)
        cont = cont + 1;
        if cont > 4
            break
        end
        S1 = abs(fft(s1(vMin:vMax)));
        S2 = abs(fft(s2(vMin:vMax)));
        figure;
        hold on;
        plot(1:size(S1, 1), S1);
        plot(1:size(S2, 1), S2);
        hold off;
        [max1, p1] = max(S1);
        [max2, p2] = max(S2);
        s = strain(windowSize, lightSpeed, refractiveIndex, p1(1), p2(1));
        ustrain = [ustrain s];
        vMin = vMin + windowStep;
        vMax = vMax + windowStep;
    end
    y = ustrain;
end