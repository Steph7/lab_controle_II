% Preparar Dados systemIdentification

% Primeiro rodar analise_dados.m

% Parte 1
y = tab3.valor;
u = tab3.controle;
t = tab3.tempo_segundos;
Ts = mean(diff(tab3.tempo_segundos));
data_id = iddata(y, u, Ts);

% O que fazer a partir daqui?
% systemIdentification
% Import data --> time domain data
% Data Object (IDDATA) 
% selecionar data_id --> import
% remove means
% estimate Transfer Function Model
% salvar FT como save("FT_tanque.mat","tf1")
% usar load("FT_tanque.mat","tf1")

% ir para o arquivo do controlador

%{
     0.203
  ------------
  s + 0.009315
%}


deltaY = abs(y(42) - y(1));
deltaU = abs(u(42) - u(1));
deltaT = abs(t(42) - t(1));

K = (deltaY/deltaU)/deltaT;

%{
G(s) = 0.2645/s
%}

num = K;
den = [1 0];
tf1 = tf(num, den);

save("FT_final","tf1")
