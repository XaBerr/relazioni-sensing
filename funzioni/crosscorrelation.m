function [lagDiff] = crosscorrelation(s1, s2, windowSize, windowStep)
    lagDiff = [];
    vMin    = 1;
    vMax    =  windowSize;
    flag = 0;
    cuttingScale = 0.9;
    while vMax <= size(s1, 1)
        % TODO: aggiungere in coda all'array (2 volte la dim di esso) zeri
        % di padding per aumentare il numero di punti che abbiamo nella fft
        % bisogna tenerne conto quando calcoliamo però la finestra
        ss1 = abs(fft(s1(vMin:vMax)));
        ss2 = abs(fft(s2(vMin:vMax)));
        ss1 = ss1 - mean(ss1);
        ss2 = ss2 - mean(ss2);
        [yValues, xValues] = xcorr(ss1, ss2);
        yValues = abs(yValues);
        
        %----------modalità-calcolo-----------
        [yValue xValue] = findMaxWithInterp2(yValues, xValues);
        [yValues left right] = cutterGrow(yValues);
        reduced = yValues;
        %--------------------------------------
        
        %----------modalità-analitica----------
%         [xValue, I] = max(yValues);
%         if flag < 10
%             flag = flag + 1;
%             figure;
%             plot(xValues, yValues);
%         end
        %--------------------------------------
        
        % TODO: Bisogna relazionare xValue con windowSize per ottenersi lo shift
        
        lagDiff = [lagDiff xValue];
        vMin = vMin + windowStep;
        vMax = vMax + windowStep;
    end
end