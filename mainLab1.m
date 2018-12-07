%####################_CLEANING_#######################
clc
close all
clearvars

%#######################_MAIN_#######################
[meters, polarizeP, polarizeS, info] = loadOBR("dataLab1/2.obr");

subplot(2,1,1)
plot(meters,polarizeP)
title('P')

subplot(2,1,2)
plot(meters,polarizeS)
title('S')