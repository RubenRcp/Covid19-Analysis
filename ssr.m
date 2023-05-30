%% funzione che calcola SSR
function s = ssr(parametri, U, U_prev, Y)
    y = modello(parametri, U, U_prev);
    e = Y - y;
    s = e' * e;
end