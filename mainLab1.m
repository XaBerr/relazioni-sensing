%####################_CLEANING_#######################
clc
close all
clearvars

%######################_CONST_#######################
maxFileNumber = 2;
windowSize = 5000;
signalStart = 6.7; 
signalEnd = 12.3;
vectorStart= 0;
vectorEnd = 0;

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

% hold on;
% title('|A|, |Z|, |HBPF|');
% plot(f, mag2db(abs(A)));
% plot(f, mag2db(abs(Z)));
% plot(f, mag2db(abs(HBPF)));
% ylim([-45 5]);
% legend('|A|', '|Z|', '|HBPF|');
% xlabel('frequenza[Hz]');
% hold off;