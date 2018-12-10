%####################_CLEANING_#######################
clc
close all
clearvars

%######################_CONST_#######################
maxFileNumber = 3;
windowSize = 10000;

%#######################_MAIN_#######################
% Importazione
% dati(i).meters(1) sono tutti uguali
dati = struct('meters',[],'polarizeP',[],'polarizeS',[],'info',{});
for i = 1:maxFileNumber
    [z, P, S, info] = loadOBR("dataLab1/"+i+".obr");
    dati(i).meters = z;
    dati(i).polarizeP = P;
    dati(i).polarizeS = S;
    dati(i).info = info;
end

% Cross correlazioni
arrayShift = zeros(maxFileNumber, ceil(size(dati(1).polarizeP, 1)/windowSize));
for i = 1:maxFileNumber
    shift = crosscorrelation(dati(1).polarizeP, dati(i).polarizeP, windowSize);
    for j = 1:size(shift, 2)
        arrayShift(i, j) = shift(1, j);
    end
end

% Print vari
%hold on
xAxis = 1 : size(arrayShift, 2);
plot(xAxis, arrayShift);
% hold off
