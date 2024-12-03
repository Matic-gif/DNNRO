clc;
clear all;

% Preberemo datoteko: vozlisca_temperature_dn2.txt
fid = fopen('vozlisca_temperature_dn2.txt', 'r'); % Odpremo datoteko

vrstica_1 = fgetl(fid); % Preberemo prvo vrstico
vrstica1_split = split(vrstica_1,','); % Razdelimo vrstico

% Definiramo spremenljivke, ki jih bomo prebrali
spremenljivka_1 = vrstica1_split{1};
spremenljivka_2 = vrstica1_split{2};
spremenljivka_3 = vrstica1_split{3};

% Preberemo število koordinat 
vrstica_2 = fgetl(fid); % 2. vrstica
vrstica2_split = split(vrstica_2,':');
stX = str2double(vrstica2_split{2});

vrstica_3 = fgetl(fid); % 3. vrstica
vrstica3_split = split(vrstica_3,':');
stY = str2double(vrstica3_split{2}); 

vrstica_4 = fgetl(fid); % 4. vrstica
vrstica4_split = split(vrstica_4,':');
st_vozlisc = str2double(vrstica4_split{2}); 

fclose(fid);

% Preberemo podatke 
data = readmatrix('vozlisca_temperature_dn2.txt', 'NumHeaderLines', 4);

x = data(:, 1); % x-koordinate
y = data(:, 2); % y-koordinate
T = data(:, 3); % temperatura

% Preberemo datoteko: celice_dn2.txt

fid2 = fopen('celice_dn2.txt', 'r'); % Odpremo datoteko

vrstica_12 = fgetl(fid2); % Preberemo prvo vrstico


% Preberi število koordinat 

vrstica_22 = fgetl(fid2); % 2. vrstica
vrstica22_split = split(vrstica_22,':');
st_celic = str2double(vrstica22_split{2}); 

celice = readmatrix("celice_dn2.txt",'NumHeaderLines',2);

% Definiramo koordinate v katerih iščemo temperaturo T

X = 0.403;
Y = 0.503;

%Uporaba scatteredInterpolant funkcije

tic
F1 = scatteredInterpolant(x,y,T,'linear','none');
T1 = F1(X,Y);
time1 = toc;
fprintf(['Temperatura v točki (%.3f, %.3f) z uporabo scatteredInterpolant ' ...
    'je %.4f,\n čas te metode je %.6f sekund.\n'], X, Y, T1, time1);

%griddedInterpolant funkcija

xg = unique(x(:)); % Pretvori v vektor in odstrani podvojene vrednosti
yg = unique(y(:));

[Xg, Yg] = ndgrid(xg, yg);  
Tg = reshape(T, stX ,stY);

tic
F2 = griddedInterpolant(Xg,Yg,Tg,'linear','none');
T2 = F2(X, Y);
time2 = toc;
fprintf(['Temperatura v točki (%.3f, %.3f) z uporabo griddedInterpolant ' ...
    'je %.4f,\n čas te metode je %.6f sekund.\n'], X, Y, T2, time2);


% Lastna interpolacija 
tic
cell_found = false;

for i = 1:st_celic
    vozlisca = celice(i, :);
  
    x1 = x(vozlisca(1)); y1 = y(vozlisca(1)); T11 = T(vozlisca(1));
    x2 = x(vozlisca(2)); y2 = y(vozlisca(2)); T21 = T(vozlisca(2));
    x3 = x(vozlisca(3)); y3 = y(vozlisca(3)); T22 = T(vozlisca(3));
    x4 = x(vozlisca(4)); y4 = y(vozlisca(4)); T12 = T(vozlisca(4)); 
  
    x_min = min([x1, x2, x3, x4]);
    x_max = max([x1, x2, x3, x4]);
    y_min = min([y1, y2, y3, y4]);
    y_max = max([y1, y2, y3, y4]);

    if (X >= x_min && X <= x_max && Y >= y_min && Y <= y_max)
        cell_found = true;
        break;
    end

end

K1 = ((x_max - X) / (x_max - x_min)) * T11 + ...
     ((X - x_min) / (x_max - x_min)) * T21;
K2 = ((x_max - X) / (x_max - x_min)) * T12 + ...
     ((X - x_min) / (x_max - x_min)) * T22;
T3 = ((y_max - Y) / (y_max - y_min)) * K1 + ...
            ((Y - y_min) / (y_max - y_min)) * K2;

time3 = toc;
fprintf(['Temperatura v točki (%.3f, %.3f) z uporabo lastne interpolacije ' ...
    'je %.4f,\n čas te metode je %.6f sekund.\n'], X, Y, T3, time3);

% Največja temperatura in njene koordinate
[max_T, max_pozicija] = max(Tg(:));
[vrstica_max, stolpec_max] = ind2sub(size(Tg), max_pozicija);
max_x = Xg(vrstica_max, stolpec_max);
max_y = Yg(vrstica_max, stolpec_max);

fprintf(['Najvišja temperatura je %.4f, nahaja se v točki (%.3f, %.3f).\n'], ...
    max_T, max_x, max_y);