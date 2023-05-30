clc
clear 
close all

%% MODELLO A TRE PARAMETRI

positivi = readtable("iss_bydate_italia_positivi.csv", 'Range', "A248:C398");
positivi_dati_precedenti = readtable("iss_bydate_italia_positivi.csv", 'Range', "A244:C398");
positivi = renamevars(positivi,["Var1","Var2","Var3"],["data","casi","casi_media7gg"]);
positivi_dati_precedenti = renamevars(positivi_dati_precedenti,["Var1","Var2","Var3"],["data","casi","casi_media7gg"]);
terapia_intensiva = readtable("iss_bydate_italia_terapia_intensiva.csv", 'Range', "A226:C376");
terapia_intensiva = renamevars(terapia_intensiva,["Var1","Var2","Var3"],["data","casi","casi_media7gg"]);
foglio = readtable("casi.csv", 'Range', "A221:K371");
giorni = positivi.data;

U = positivi.casi;
U_prev = positivi_dati_precedenti.casi;
Y = terapia_intensiva.casi;
U_m7gg = positivi.casi_media7gg;
Y_m7gg = terapia_intensiva.casi_media7gg;

% creo la griglia dei valori da stimare mu, D, lambda
mu = linspace(0.01,0.02,100);
D = [0:3]';
lambda = linspace(0.2,0.5,100);
[gridMu, gridD, gridLambda] = meshgrid(mu, D, lambda);
 gridParametri = [gridMu(:), gridD(:), gridLambda(:)];

% calcolo SSR per ogni combinazione di mu, D, lambda su griglia
SSR = zeros(size(gridParametri, 1), 1);
for i = 1:size(gridParametri, 1)
    SSR(i) = ssr(gridParametri(i,:), U, U_prev, Y);
end

% trovo SSR minimo e la combinazione di mu, D, lambda relativa 
[minSSR, indexMinSSR] = min(SSR);
parametriStimati = gridParametri(indexMinSSR,:);
muStimato = parametriStimati(1);
DStimato = parametriStimati(2);
lambdaStimato = parametriStimati(3);


figure(2)
yStimato = modello(parametriStimati, U, U_prev);
plot(giorni, Y,'*-r','LineWidth',2)
grid on
hold on
plot(giorni, yStimato, 'k-*','LineWidth',2)
xlabel('giorni');
ylabel('casi di terapia intensiva')
legend('Uscita osservata', 'Uscita stimata')
title("modello esponenziale a 3 parametri")


%% FIT
fit = FIT(Y,yStimato);

