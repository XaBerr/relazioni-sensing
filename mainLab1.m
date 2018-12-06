%####################_CLEANING_#######################
clc
close all
clearvars

%#######################_MAIN_#######################
file = loadOBR("dataLab1/2.obr");

%meters = file(1);
%polarizeP = file(2);
%polarizeS = file(3);
%subplot(2,1,1)
%plot(meters,polarizeP)
%title('s_1')
%size(file(1))