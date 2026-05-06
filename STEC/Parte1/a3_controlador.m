close all; clear all; clc;

load("FT_final.mat","tf1")

G = tf(tf1);
figure;
step(G)
grid on

% Criar esse controlador só para poder abrir o sisotool
% Depois é só alterar os valores pelos que pegar de lá
%Cs = Kp + Ki/s + Kd * s;

% Valores encontrados através do LGR
s = tf('s');
% Versão 1
Kp = 0.282;
Ti = 286;
Ki = Kp / Ti;
Kd = 0;

C1 = Kp * (1 + 1/(Ti*s));

CGs = C1 * G;
T = feedback(CGs, 1);
figure;
step(T);
grid on

% Versão 2
Kp2 = 0.651;
C = Kp2 * (1 + 1/(Ti*s));
CG2s = C * G;
T2 = feedback(CG2s, 1);
figure;
step(T2);
grid on

%{
sisotool(G,C)
%}

t_pico_mf = 53;
tau_mf = t_pico_mf/4;
polo_desejado = 1/tau_mf;

zero_desejado = polo_desejado*5/100;

%pidstd(C);

% O valor de Kp (REAL da planta) tem que multiplicar por 6.5
Kp_real = Kp *6.5;
Kp2_real = Kp2 *6.5;


% Não limpar o workspace e abrir o controlador2.m para visualizar 
% sinal de controle

% Obs.: O controlador que nós testamos na planta é a versão 2.