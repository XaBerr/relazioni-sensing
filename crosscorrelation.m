function [lagDiff, padding] = crosscorrelation(reference, signal, windowSize, ...
    windowStep, interpFactor, flag)
%CROSSCORRELATION 
%
%   reference: la traccia di riferimento. Vettore [Nx2], N = numero di
%   campioni, 2 = numero di polarizzazioni. 
%
%   signal: traccia di misura. Stesse dimensioni di reference
%
%   windowSize: dimensione della finestra di correlazione in numero di
%   campioni
%
%   windowStep: numero di campioni di cui shifto la finestra di
%   correlazione ad passo
%
%   interpFactor: fattore di interpolazione della correlazione. 

    lagDiff = [];
    
    % indici della finestra
    vMin    = 1;
    vMax    =  windowSize;
    
    % dimensione della trasformata. Aumentando il numero di punti aumenta
    % la risoluzione spettrale
    padding = 3 * windowSize;
    
    % numero di campioni in ogni traccia
    nsamples = size(reference, 1);
    
    i = 1;
    
    while vMax <= nsamples        
        ref = reference(vMin:vMax, :);
        sig = signal(vMin:vMax, :);
       
        ss1 = fft(ref, padding);
        ss2 = fft(sig, padding);
        
        % somma dei moduli delle due polarizzazioni
        refModulo = abs(ss1(:, 1)).^2 + abs(ss1(:, 2)).^2;
        misuraModulo = abs(ss2(:, 1)).^2 + abs(ss2(:, 2)).^2;
        
        refModulo = refModulo - mean(refModulo);
        misuraModulo = misuraModulo - mean(misuraModulo);
        
        % calcolo cross correlazione tra le due finestre
        [yValues, xValues] = xcorr(refModulo, misuraModulo);
        
        
        if (interpFactor > 1)
            % interpolazione spline
            N = length(xValues);
            xInterp = linspace(xValues(1), xValues(end), N * interpFactor);
            yInterp = spline(xValues, yValues, xInterp);
            xValues = xInterp;
            yValues = yInterp;
        end
        
        if flag < 1
            flag = flag + 1;
            figure;
            plot(xValues, yValues,'.r', 'MarkerSize', 10); % stem
            xlabel("Lags");
            ylabel("Cross-correlation");
        end
        
%         yValues = abs(yValues);
        
        [~, idx] = max(yValues);
        xValue = xValues(idx);
        
        lagDiff = [lagDiff xValue];
        vMin = vMin + windowStep;
        vMax = vMax + windowStep;
    
        i= i+1;
    end
end