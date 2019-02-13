%####################_CLEANING_#######################
clc
close all
clearvars

%####################_PATHS_#########################
addpath("funzioni");

%######################_CONST_#######################
names = [ "SP424102.CSV" "SP453003.CSV" "SP483904.CSV" "SP522905.CSV" "SP550506.CSV" "SP584007.CSV" "SP065108.CSV" "SP104109.CSV" "SP132110.CSV" "SP152511.CSV" "SP183612.CSV" "SP212313.CSV" "SP240814.CSV" ];
spins = [ 14.25 14.5 14.75 14.5 14.25 14 14.1 14.2 14.3 14.4 14.5 14.6 14.7 ]; % [cm]
files = struct('yData',[],'fMinTHz',0,'fStepTHz',0,"frequenciesTHz",[],"lambdasM",[]);
numberOfFiles = 13;
speedOfLight  = 3*10^8;
lengthOfFiberMM = 312 - 1.5;
elongationMM = 1.5;

%#######################_MAIN_#######################
for i = 1:numberOfFiles
    file = dlmread("dataLab2/"+names(i), ',', 2, 0);
    frequency = dlmread("dataLab2/"+names(i), ',', [0, 0, 0, 1]);
    files(i).yData = file(:,1);
    files(i).yData = files(i).yData.';
    files(i).fMinTHz = frequency(1);
    files(i).fStepTHz = frequency(2);
    files(i).frequenciesTHz = files(i).fMinTHz : files(i).fStepTHz : (size(files(i).yData, 2)-1)*files(i).fStepTHz+files(i).fMinTHz;
    files(i).lambdasM = speedOfLight ./ (files(i).frequenciesTHz .* 10^12);
    xMax = 1;
end

% figure;
% plot(fliplr(files(1).lambdasM), fliplr(files(1).yData));
% xlabel("wavelength [m]");
% ylabel("power [dB]");

pics = [];
for i = 1:numberOfFiles
    myX = fliplr(files(i).lambdasM) .* 10^6; % [um]
    myY = fliplr(files(i).yData);
    [yValue xValue] = findMaxWithInterp(myY, myX);
    pics = [pics xValue];
end

[fitresult, gof] = myLinearFit((spins-14)./lengthOfFiberMM , pics); % [mm / um] = [mm / (mm * 10^-3)] = [m * 10^3 / €]
angularCoeficient = fitresult.a; % [m / €] = [mm * 10^3 / u€ * 10^6] = [mm * 10^-3 / u€]
errore = gof.rmse / sqrt(13 - 2); % [mm]
sensore = errore  / (angularCoeficient * 10^-6); % [u€]
% sensitivity =  / angularCoeficient; % [mm] / [mm / u€]

% figure;
% plot(spins, pics);

