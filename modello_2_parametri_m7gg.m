clc
clear
close all

%% MODELLO A 2 PARAMETRI

positivi = readtable("iss_bydate_italia_positivi.csv", 'Range', "A248:C398");
positivi_dati_precedenti = readtable("iss_bydate_italia_positivi.csv", 'Range', "A21:C398");
positivi = renamevars(positivi,["Var1","Var2","Var3"],["data","casi","casi_media7gg"]);
positivi_dati_precedenti = renamevars(positivi_dati_precedenti,["Var1","Var2","Var3"],["data","casi","casi_media7gg"]);
terapia_intensiva = readtable("iss_bydate_italia_terapia_intensiva.csv", 'Range', "A226:C376");
terapia_intensiva = renamevars(terapia_intensiva,["Var1","Var2","Var3"],["data","casi","casi_media7gg"]);
foglio = readtable("casi.csv", 'Range', "A221:K371");
giorni = positivi.data;


U = positivi.casi;
U_prev = positivi_dati_precedenti.casi_media7gg;
Y = terapia_intensiva.casi;
U_m7gg = positivi.casi_media7gg;
Y_m7gg = terapia_intensiva.casi_media7gg;



figure(1)
subplot(2,1,1);
plot(giorni, U,'LineWidth',2);
hold on
plot(giorni, U_m7gg,'LineWidth',2);
grid on
xlabel("giorni");
ylabel("numero di casi");
legend('casi giorno per giorno','casi media 7 giorni')
title("positivi 01/10/2020 - 28/02/2021");

subplot(2,1,2);
plot(giorni, Y,'LineWidth',2);
hold on
plot(giorni, Y_m7gg,'LineWidth',2);
grid on
xlabel("giorni");
ylabel("numero di pazienti");
legend('terapia intensiva giorno per giorno','terapia intensiva media 7 giorni')
title("terapia intensiva 01/10/2020 - 28/02/2021");


% definisco l'intervallo di valori del ritardo puro, dove ipotizzo ci sia quello ottimo
D = [0:30]';

% cerco il valore di ritardo puro che massimizza la correlazione tra uscita stimata e uscita reale
l = length(U_prev)-length(U_m7gg);
yStimato = circshift(U_m7gg,D(1)+1);
yStimato(1:D(1)+1) = U_prev(l-D(1)+1:l+1);
corr = corrcoef(yStimato,Y_m7gg);
max_corr = corr(1,2);
DStimato = D(1);

for i = 1:30
	yStimato = circshift(U_m7gg,D(i)+1);
	yStimato(1:D(i)+1) = U_prev(l-D(i)+1:l+1);
	corr = corrcoef(yStimato,Y_m7gg);
   	if(corr(1,2) > max_corr)
       	max_corr = corr(1,2);
       	DStimato = D(i);
   	end 
end 

% dopo aver trovato il valore del ritardo puro calcolo il guadagno 
yStimato = circshift(U_m7gg,DStimato+1);
yStimato(1:DStimato+1) = U_prev(l-DStimato+1:l+1);
muStimato = yStimato\Y_m7gg;

% modello a 2 parametri
yStimato = muStimato * yStimato;

figure(2)
plot(giorni,yStimato,'k','LineWidth',2)
hold on 
grid on
plot(giorni,Y_m7gg,'r','LineWidth',2)
legend('andamento stimato','andamento reale')
xlabel("giorni")
ylabel("ricoveri terapia intensiva")
title("stima modello con 2 parametri")



%% FIT
fit = FIT(Y_m7gg,yStimato);

  







