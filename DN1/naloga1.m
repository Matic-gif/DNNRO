% Branje datoteke1
filename1 = "naloga1_1.txt";
delimiterIn = '';
hedlinersIn = 2;

podatki = importdata(filename1,delimiterIn,hedlinersIn);
podatki.data;
t = podatki.data;

% Branje datoteka 2
% 1. vektor P
filename2="naloga1_2.txt";
fid = fopen(filename2);
vrstica = fgetl(fid);
vrstica_split = split(vrstica,':');
num_vrstica = str2double(vrstica_split(2));
P = zeros(1,num_vrstica);

for i = 1:num_vrstica
    vrstica = fgetl(fid); 
    P(i) = str2double(vrstica);
end    

% Graf
figure;
plot(t,P);
xlabel('t[s]');
ylabel('P[w]');
title('Graf P(t)');
grid on;

% Izračun integrala
n = length(P);
vsota_P = 0;

for i = 1:n

    if i > 1
        dt = t(i) - t(i - 1);
    else
        dt = t(2) - t(1);  
    end

    if i == 1 || i == n
        vsota_P = vsota_P + P(i);
    else
        vsota_P = vsota_P + 2 * P(i);
    end    

end

ploscina =  dt/2 * (vsota_P);
ploscina_fun = trapz(t,P);
fprintf("Vrednost integrala s for zanko: %f\n", ploscina)
fprintf("Vrednost integrala s trapz: %f\n", ploscina_fun)