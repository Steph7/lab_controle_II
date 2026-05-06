% Análise dos dados
close all; clear all; clc;

dados = readtable('dados_modelamento.txt');
%disp(dados)
%summary(dados)

% converter para string
tempo_str = string(dados.Var2);
valor_ref_str = string(dados.Var4);
valor_str = string(dados.Var5);

% remover células vazias ou símbolos
valid_idx = ~ismissing(tempo_str) & ~ismissing(valor_ref_str) & ~ismissing(valor_str);

tempo_str = tempo_str(valid_idx);
valor_ref_str = valor_ref_str(valid_idx);
valor_str = valor_str(valid_idx);

tempo = duration(strtrim(tempo_str), 'InputFormat', 'hh:mm:ss');
tempo_segundos = seconds(tempo - tempo(1));

valor_ref = str2double(valor_ref_str);
valor = str2double(strrep(valor_str, ',', '.'));

tempo_segundos = tempo_segundos(:);
valor_ref = valor_ref(:);
valor = valor(:);

dados_organizados = table(tempo_segundos, valor_ref, valor);
%disp(dados_organizados)

plot(tempo_segundos, valor, 'b', 'LineWidth', 1)
hold on
plot(tempo_segundos, valor_ref, 'r--', 'LineWidth', 1.2)
xlabel("Tempo (segundos)")
ylabel("Temperatura (°C)")
legend("Valor Medido", "Referência")
title({"Estufa";"Temperatura x Tempo"})
grid on

% Preparar Dados systemIdentification
novo_idx = valor_ref ~=30;
valor_filtrado = valor(novo_idx);
valor_ref_filtrado = valor_ref(novo_idx);
tempo_filtrado = tempo_segundos(novo_idx);

figure;
plot(tempo_filtrado, valor_filtrado, 'b', 'LineWidth', 1)
hold on
plot(tempo_filtrado, valor_ref_filtrado, 'r--', 'LineWidth', 1.2)
xlabel("Tempo (segundos)")
ylabel("Temperatura (°C)")
legend("Valor Medido", "Referência")
title({"Estufa";"Temperatura x Tempo"})
grid on

% Sem Filtro
y = valor;
u = valor_ref;
Ts = mean(diff(tempo_segundos));
data_id = iddata(y, u, Ts);

% Com Filtro
y2 = valor_filtrado;
u2 = valor_ref_filtrado;
Ts2 = mean(diff(tempo_segundos));
data_id2 = iddata(y2, u2, Ts2);
