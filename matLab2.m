%####################_CLEANING_#######################
clc
close all
clearvars

%######################_CONST_#######################
names = [ "SP424102.CSV" "SP453003.CSV" "SP483904.CSV" "SP522905.CSV" "SP550506.CSV" "SP584007.CSV" "SP065108.CSV" "SP104109.CSV" "SP132110.CSV" "SP152511.CSV" "SP183612.CSV" "SP212313.CSV" "SP240814.CSV" ];
files = struct('data',[]);
for i = 1:13
    file = dlmread("dataLab2/"+names(i), ',', 2, 0);
    files(i).data = file(:,1);
end
%#######################_MAIN_#######################

% a = [1 2 3; 4 5 6];
% fit(a(:,:), a(:,:), 'linearinterp')
% fit(1:size(files(1).data,1), files(1).data, 'poly2')
% plot(1:size(temp, 1), temp);


figure;
hold on;
for i = 1:3
    legend('-DynamicLegend');
    plot([1:size(files(i).data,1)]./(310*10^6), files(i).data);
%     title(i);
%     legend(i);
end
hold off;


figure;
hold on;
for i = 4:6
    legend('-DynamicLegend');
    plot([1:size(files(i).data,1)]./(310*10^6), files(i).data);
%     title(i);
%     legend(i);
end
hold off;


figure;
hold on;
for i = 7:13
    legend('-DynamicLegend');
    plot([1:size(files(i).data,1)]./(310*10^6), files(i).data);
%     title(i);
%     legend(i);
end
hold off;