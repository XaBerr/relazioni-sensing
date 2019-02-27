%####################_CLEANING_#######################
clc
close all
clearvars

%####################_PATHS_#########################
addpath('./funzioni');

%######################_CONST_#######################
startingFile  = 1; % 1
maxFileNumber = 25; % 10
% number of files to process (counting the reference)
filecount = maxFileNumber - startingFile + 1;

lightSpeed    = 3*10^8; % m/s
k_strain      = -0.15;

% choose the portion of the signal to analyze
signalStart   = 6.77; % meters
signalEnd     = 12.1; % meters
fiberLength   = abs(signalEnd - signalStart);

% MAIN PARAMETERS
windowSizeM   = 0.05; % window size in meters
windowStepM   = 0.01; % window steps in meters

%######################_DYNAMIC_######################
windowSize = 0;
windowStep = 0;
vectorStart = 0;
vectorEnd = 0;
tick2M = 0;
M2tick = 0;

%#######################_MAIN_#######################
% Calcolo della lunghezza della fibra
[z, P, S, info] = loadOBR('./dataLab1/2.obr');
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
dati = struct('meters',[],'polarizeP',[],'polarizeS',[], 'abs', [], ...
    'info',{});

datiDevice = struct('x',[],'y',[]);
for i = 0 : filecount-1
    file_index = startingFile + i;
    filename = sprintf('dataLab1/%d.obr', file_index);
    fprintf('Reading file: %s\n', filename);

    [z, P, S, info] = loadOBR(filename);

    dati(i+1).meters = z(vectorStart:vectorEnd);
    dati(i+1).polarizeP = P(vectorStart:vectorEnd);
    dati(i+1).polarizeS = S(vectorStart:vectorEnd);
    dati(i+1).total = [dati(i+1).polarizeP(:), dati(i+1).polarizeS(:)];
    dati(i+1).info = info;
    
    [x, y] = importFileOfReference(sprintf('dataLab1/%d_Lower.txt', file_index));
    datiDevice(i+1).x = x;
    datiDevice(i+1).y = y;
end


% return; %% SCOMMENTAMI SE VUOI STOPPARMI

%%
% Cross correlazioni
ustrainPerFile = struct('us',[],'max',[],'variance',[],'mean',[], ...
    'spectral_shift', []);
interpFactor = -1;
for i = 1:filecount

    fprintf('Elaborating file %d/%d\n', i, filecount);

    % compute the spectral shift in number of samples
    [shift_samples, padding] = crosscorrelation(...
        dati(1).total,... % reference trace
        dati(i).total,...
        windowSize,...
        windowStep, ...
        interpFactor,...
        1);

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
title('Strain measurement');

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
title('Strain measurement');

% Non lo so
% figure(3);
% clf;
% hold on;
% for i = 2:2
%     windowCount = length(ustrainPerFile(i).spectral_shift);
%     xAxis = (0 : windowCount - 1) * windowStepM; % meters
%     plot(xAxis, ustrainPerFile(i).spectral_shift);
% end
% xlabel("Position [m]");
% ylabel("Spectral shift [GHz]");
% grid on;
% grid minor;
% hold off;
% title('Spectral shift');
