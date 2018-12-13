%####################_CLEANING_#######################
clc
close all
clearvars

%######################_CONST_#######################
maxFileNumber = 2;
signalStart = 6.77; 
signalEnd = 12.1;
windowSizeM = 0.03;
windowStepM = 0.01;
lightSpeed = 3*10^8;
refractiveIndex = 1.466;
lambdaSmall = 1545.59 * 10^-9;
lambdaBig = 1588.49 * 10^-9;
lambda0 = (lambdaBig + lambdaSmall) / 2;
deltaFrequency = lightSpeed * ( 1 / lambdaSmall - 1 / lambdaBig );
centerOfFiberM = (signalEnd + signalStart  ) / 2;
centerOfFrequency = lightSpeed * refractiveIndex /  lambda0;

%######################_DYNAMIC_######################
windowSize = 0;
windowStep = 0;
vectorStart = 0;
vectorEnd = 0;
tick2M = 0;
M2tick = 0;

%#######################_MAIN_#######################
% Calcolo della lunghezza della fibra
[z, P, S, info] = loadOBR("dataLab1/1.obr");
for i = 1:size(z, 2)
    if(z(i) <= signalStart)
        vectorStart = i+1;
    end
    if(z(i) <= signalEnd)
        vectorEnd = i;
    end
end
M2tick = (vectorEnd - vectorStart) / (signalEnd - signalStart);
tick2M = 1 / M2tick;
windowSize = ceil(M2tick * windowSizeM);
windowStep = ceil(M2tick * windowStepM);


% Importazione
% dati(i).meters(1) sono tutti uguali
dati = struct('meters',[],'polarizeP',[],'polarizeS',[],'info',{});
for i = 1:maxFileNumber
    [z, P, S, info] = loadOBR("dataLab1/"+i+".obr");
    dati(i).meters = z(vectorStart:vectorEnd);
    dati(i).polarizeP = P(vectorStart:vectorEnd);
    dati(i).polarizeS = S(vectorStart:vectorEnd);
    dati(i).info = info;
end


% Cross correlazioni
arrayShift = zeros(maxFileNumber, ceil(size(dati(1).polarizeP, 1) / windowSize));
for i = 1:maxFileNumber
    shift = crosscorrelation(vectorSum(dati(1).polarizeS, dati(1).polarizeP), vectorSum(dati(i).polarizeS, dati(i).polarizeP), windowSize, windowStep);
    for j = 1:size(shift, 2)
        deltaM = shift(1, j) * tick2M;
        arrayShift(i, j) = deltaM / centerOfFiberM * centerOfFrequency;
    end
end

% Print vari
%hold on
xAxis = 1 : size(arrayShift, 2);
plot(xAxis, arrayShift, 'b--o');
% hold off

% hold on;
% title('|A|, |Z|, |HBPF|');
% plot(f, mag2db(abs(A)));
% plot(f, mag2db(abs(Z)));
% plot(f, mag2db(abs(HBPF)));
% ylim([-45 5]);
% legend('|A|', '|Z|', '|HBPF|');
% xlabel('frequenza[Hz]');
% hold off;