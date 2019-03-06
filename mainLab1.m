%####################_CLEANING_#######################
clc
close all
clearvars

%####################_PATHS_#########################
addpath('./funzioni');

%######################_CONST_#######################
startingFile  = 13; % 1
maxFileNumber = 13; %25; % 10
% number of files to process (counting the reference)
filecount = maxFileNumber - startingFile + 1;

lightSpeed    = 3*10^8; % m/s
k_strain      = -0.15; % -0.780;

% choose the portion of the signal to analyze
signalStart   = 6.77; % meters
signalEnd     = 12.1; % meters
fiberLength   = abs(signalEnd - signalStart);
xDifference   = 0:fiberLength/1000:fiberLength;

% MAIN PARAMETERS
windowSizeM   = 0.00999389; % window size in meters
windowStepM   = 0.01001341; % window steps in meters
interpFactor  = -1;   % -1 quadratic fit, 0 nothing, >1 spline
nPadding      = 10;   % moltiplicatore dimension

%######################_DYNAMIC_######################
windowSize = 0;
windowStep = 0;
vectorStart = 0;
vectorEnd = 0;
tick2M = 0;
M2tick = 0;

%#######################_MAIN_#######################
% Calcolo della lunghezza della fibra e il file di riferimento
[z, P, S, info] = loadOBR('./dataLab1/1.obr');
for i = 1:size(z, 2)
    if(z(i) <= signalStart)
        vectorStart = i+1;
    end
    if(z(i) <= signalEnd)
        vectorEnd = i;
    end
end

fiberSamples = vectorEnd - vectorStart + 1;
M2tick = fiberSamples / fiberLength;

% spatial resolution: distance between two consecutive samples in meters
tick2M = 1 / M2tick;

% window size and step in samples
windowSize = ceil(windowSizeM / tick2M);
windowStep = ceil(windowStepM / tick2M);

%% Importazione
riferimento  = struct('meters',[],'polarizeP',[],'polarizeS',[], 'abs', [], ...
    'info',{});
riferimento(1).meters = z(vectorStart:vectorEnd);
riferimento(1).polarizeP = P(vectorStart:vectorEnd);
riferimento(1).polarizeS = S(vectorStart:vectorEnd);
riferimento(1).total = [riferimento(1).polarizeP(:), riferimento(1).polarizeS(:)];
riferimento(1).info = info;
dati = struct('meters',[],'polarizeP',[],'polarizeS',[], 'abs', [], ...
    'info',{});

datiDevice = struct('x',[],'y',[]);
for i = 0 : filecount-1
    % Creo il nome del file
    file_index = startingFile + i;
    filename = sprintf('dataLab1/%d.obr', file_index);
    fprintf('Reading file: %s\n', filename);

    % Importo il file
    [z, P, S, info] = loadOBR(filename);

    % Importo il file da calcolare
    dati(i+1).meters = z(vectorStart:vectorEnd);
    dati(i+1).polarizeP = P(vectorStart:vectorEnd);
    dati(i+1).polarizeS = S(vectorStart:vectorEnd);
    dati(i+1).total = [dati(i+1).polarizeP(:), dati(i+1).polarizeS(:)];
    dati(i+1).info = info;
    
    % Importo il file di referenza
    [x, y] = importFileOfReference(sprintf('dataLab1/%d_Lower.txt', file_index));
    datiDevice(i+1).x = x - x(1);%- signalStart - 0.5;
    datiDevice(i+1).y = y;
end


% return; %% SCOMMENTAMI SE VUOI STOPPARMI

%%
% Cross correlazioni
ustrainPerFile = struct('us',[],'max',[],'variance',[],'mean',[], ...
    'spectral_shift', []);
difference = struct('our',[],'otdr',[],'diff',[],"mean",0,'var',0);

for i = 1:filecount

    fprintf('Elaborating file %d/%d\n', i, filecount);

    % compute the spectral shift in number of samples
    [shift_samples, padding] = crosscorrelation(...
        riferimento(1).total,... % reference trace
        dati(i).total,...
        windowSize,...
        windowStep, ...
        interpFactor,...
        1,...
        nPadding);

    % compute time axis from z axis
    % direct computation gives values in Hertz
    t = 2 * dati(i).meters * dati(i).info.group_indx / lightSpeed; % sec
    dt1 = mean(diff(t));

    % computing from dt given by OBR gives values in GHz
    dt = dati(i).info.dt; % nanosec.

    % frequency spacing: difference in GHz between adjacent values
    % padding: number of samples of each window (W tilde)
    df = 1 / (dt *  padding);

    % compute the spectral shift from the frequency spacing
    spectral_shift = df * shift_samples; % GHz
    ustrainPerFile(i).spectral_shift = spectral_shift;

    % estimate the applied strain from strain constant [GHz/ustrain]
    ustrainPerFile(i).us = spectral_shift ./ k_strain;
    
    %% Analisi della differenza tra i 2 grafici
    xAxis = (0 : length(ustrainPerFile(i).us) - 1) * windowStepM;
    [fitresult1, gof1] = splineFit(xAxis, ustrainPerFile(i).spectral_shift);
    [fitresult2, gof2] = splineFit(datiDevice(i).x, datiDevice(i).y);
    difference(i).our  = feval(fitresult1, xDifference);
    difference(i).otdr = feval(fitresult2, xDifference);
    difference(i).diff = difference(i).our - difference(i).otdr;
    difference(i).mean = mean(difference(i).diff) /  mean(difference(i).our); % high => systematic error
    difference(i).var  = var(difference(i).diff); % high => noise error
end





%% Print vari

% Print micro strain che abbiamo trovato noi
figure(1);
clf;
hold on;
for i = 1:filecount
    windowCount = length(ustrainPerFile(i).us);
    xAxis = (0 : windowCount - 1) * windowStepM; % meters
    plot(xAxis, ustrainPerFile(i).us);
end
legend;
xlabel("Position [m]");
ylabel("Strain [microstrain]");
grid on;
grid minor;
hold off;
title('Strain measurement US');

% Print micro strain del dispositivo
figure(2);
clf;
hold on;
for i = 1:filecount
    plot(datiDevice(i).x, (datiDevice(i).y./ k_strain) );
end
legend;
xlabel("Position [m]");
ylabel("Strain [microstrain]");
grid on;
grid minor;
hold off;
title('Strain measurement OFDR');

% Print micro strain del dispositivo
figure(3);
clf;
hold on;
for i = 1:filecount
    windowCount = length(ustrainPerFile(i).us);
    xAxis = (0 : windowCount - 1) * windowStepM; % meters
    plot(xAxis, ustrainPerFile(i).us);
    plot(datiDevice(i).x, (datiDevice(i).y./ k_strain) );
end
legend;
xlabel("Position [m]");
ylabel("Strain [microstrain]");
grid on;
grid minor;
hold off;
title('Strain measurement US + OFDR');


% Print sovrapposto
figure(4);
clf;
hold on;
for i = 1:filecount
    plot(xDifference, difference(i).diff );
end
legend;
xlabel("Position [m]");
ylabel("Spectral shift [GHz]");
grid on;
grid minor;
hold off;
title('Strain measurement DIFF');
