%% Load data
conInterp = load('conInterp.mat');
senzaInterp = load('senzaInterp.mat');

%% Interpolazione vs Raw

figure(1);
clf;
hold on;
plot(senzaInterp.xAxis, senzaInterp.ustrainPerFile(2).spectral_shift)
plot(conInterp.xAxis, smooth(conInterp.ustrainPerFile(2).spectral_shift))
hold off;
box on;
legend('Raw', 'Interpolation');
xlabel('Position [m]');
ylabel('Spectral shift [GHz]');


%% Spectral shift con interpolazione
nfiles = length(conInterp.ustrainPerFile);

figure(2);
clf;
hold on;

for i = 1 : nfiles
    plot(conInterp.xAxis, smooth(conInterp.ustrainPerFile(i).spectral_shift))
end
hold off;   
box on;
xlabel('Position [m]');
ylabel('Spectral shift [GHz]');

%% Strain con interpolazione

figure(2);
clf;
hold on;

for i = 1 : nfiles
    plot(conInterp.xAxis, smooth(conInterp.ustrainPerFile(i).us))
end
hold off;
box on;
xlabel('Position [m]');
ylabel('Microstrain');


%% 
conInterp = load('conInterp25.mat');

%%
zPos = 3.43;
nsamp = length(conInterp.xAxis);
posIndex = find(conInterp.xAxis > zPos);
posIndex = posIndex(1);

pesiFwd = [60 120 180 240 300 359 418 476 534 591 686 782];
pesiBwd = [782 686 591 524 476 418 359 301 240 180 120 60];
Nf = length(pesiFwd);
Nb = length(pesiBwd);
indexFwd = 2:(2+Nf-1);
indexBwd = indexFwd(end):(indexFwd(end)+Nb-1);

microStrainF = zeros(Nf, 1);
microStrainB = zeros(Nb, 1);

for i = 1 : Nf
    us = conInterp.ustrainPerFile(indexFwd(i)).us;
    microStrainF(i) = us(posIndex);
    us = conInterp.ustrainPerFile(indexBwd(i)).us;
    microStrainB(i) = us(posIndex);
end


%% Linear fitting

fitF = fit(pesiFwd', microStrainF, 'poly1');
fitB = fit(pesiBwd', microStrainB, 'poly1');

fittedF = fitF.p1 * pesiFwd + fitF.p2;
fittedB = fitB.p1 * pesiBwd + fitB.p2;


%%
figure(3);
clf;
hold on;
plot(pesiFwd, fittedF, 'r');
plot(pesiBwd, fittedB, 'b');
plot(pesiFwd, microStrainF, 'rx');
plot(pesiBwd, microStrainB, 'bo');
hold off;
box on;
xlabel('Weight [g]');
ylabel('Microstrain');
grid on;
grid minor;
legend('Forward, fit', 'Backward, fit', 'Forward, data', 'Backward, data');

