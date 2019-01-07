%####################_CLEANING_#######################
clc
close all
clearvars

%######################_CONST_#######################
names = [ "SP424102.CSV" "SP453003.CSV" "SP483904.CSV" "SP522905.CSV" "SP550506.CSV" "SP584007.CSV" "SP065108.CSV" "SP104109.CSV" "SP132110.CSV" "SP152511.CSV" "SP183612.CSV" "SP212313.CSV" "SP240814.CSV" ];
spins = [ 14 14.05 14.1 14.15 14.2 14.25 14.3 14.35 14.4 14.45 14.5 14.55 14.6 14.65 14.7 14.75 ];
files = struct('yData',[],'frequency',[],"xData",[]);
numberOfFiles = 13;
speedOfLight  = 3*10^8;


%#######################_MAIN_#######################
for i = 1:numberOfFiles
    file = dlmread("dataLab2/"+names(i), ',', 2, 0);
    files(i).frequency = dlmread("dataLab2/"+names(i), ',', [0, 0, 0, 1]);
    files(i).yData = file(:,1);
    files(i).yData = files(i).yData.';
    fMin = files(i).frequency(2);
    fMax = files(i).frequency(1);
    files(i).xData = fMin:((fMax-fMin)/(size(files(i).yData,2)-1)):fMax;
end


pics = [];
for i = 1:numberOfFiles
    fitresult = myGaussianFit(files(i).xData, files(i).yData);
    newX = files(i).xData.';
    newY = feval(fitresult, newX);
    [pksA, locA] = findpeaks(newY, newX);
    pics = [pics locA];
end

figure;
plot(spins, pics);