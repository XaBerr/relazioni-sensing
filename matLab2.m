%####################_CLEANING_#######################
clc
close all
clearvars

%######################_CONST_#######################
names = [ "SP424102.CSV" "SP453003.CSV" "SP483904.CSV" "SP522905.CSV" "SP550506.CSV" "SP584007.CSV" "SP065108.CSV" "SP104109.CSV" "SP132110.CSV" "SP152511.CSV" "SP183612.CSV" "SP212313.CSV" "SP240814.CSV" ];
spins = [ 14.25 14.5 14.75 14.5 14.25 14 14.1 14.2 14.3 14.4 14.5 14.6 14.7 ];
files = struct('yData',[],'fMinTHz',0,'fStepTHz',0,"frequenciesTHz",[],"lambdasM",[]);
numberOfFiles = 13;
speedOfLight  = 3*10^8;


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
end


pics = [];
for i = 1:numberOfFiles
    myX = fliplr(files(i).lambdasM) .* 10^6;
    myY = fliplr(files(i).yData);
    fitresult = myGaussianFit2(myX, myY);% 
    newX = myX.';
    newY = feval(fitresult, newX);
    [pksA, locA] = findpeaks(newY, newX);
    pics = [pics locA];
end

figure;
plot(spins, pics);

