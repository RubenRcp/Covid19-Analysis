%% funzione che calcola il FIT
function f=FIT(Y,yStimato)
    e = Y - yStimato;
    SSR = e' * e;
    e_tss = Y - mean(Y);
    TSS = e_tss' * e_tss;

    f = (1-sqrt(SSR/TSS))*100;

end