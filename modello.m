%%  funzione modello a 3 parametri
function y = modello(parametri, U, U_prev)
    mu = parametri(1);	    % guadagno
    D = parametri(2);		%ritardo puro
    lambda = parametri(3);	%lambda
    Y_cap = zeros(length(U),1);
    l = length(U_prev)-length(U);
    U_delayed = circshift(U,D+1);
    U_delayed(1:D+1) = U_prev(l-D+1:l+1);
    for t = 1:length(U)
        for k = 1:t-D
            if((t-k)>0)
                Y_cap(t) = Y_cap(t) + (mu*lambda*exp(-lambda*k)*U_delayed(t-k));
            end
        
        end
    end
    y = Y_cap;
end