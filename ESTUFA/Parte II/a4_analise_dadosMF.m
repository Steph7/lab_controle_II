% Dados Malha Fechada
close all; clear all; clc;

function dados_organizados = processa_dados_estufa(dados, formato)
% formato = 1 (original)
% formato = 2 (invertido)

    % converter para string
    tempo_str = string(dados.Var2);

    c1 = string(dados.Var4);
    c2 = string(dados.Var5);
    c3 = string(dados.Var6);

    % remover vazios
    valid_idx = ~ismissing(tempo_str) & ~ismissing(c1) & ~ismissing(c2) & ~ismissing(c3);

    tempo_str = tempo_str(valid_idx);
    c1 = c1(valid_idx);
    c2 = c2(valid_idx);
    c3 = c3(valid_idx);

    % converter tempo
    tempo = duration(strtrim(tempo_str), 'InputFormat', 'hh:mm:ss');
    tempo_segundos = seconds(tempo - tempo(1));

    % converter números (corrigir vírgula)
    v1 = str2double(strrep(c1, ',', '.'));
    v2 = str2double(strrep(c2, ',', '.'));
    v3 = str2double(strrep(c3, ',', '.'));

    % organizar conforme formato
    if formato == 1
        % data | referencia | controle | saida
        valor_ref = v1;
        controle = v2;
        valor = v3;

    elseif formato == 2
        % data | controle | saida | referencia
        controle = v1;
        valor = v2;
        valor_ref = v3;

    else
        error('Formato inválido. Use 1 ou 2.');
    end

    % garantir vetores coluna
    tempo_segundos = tempo_segundos(:);
    valor_ref = valor_ref(:);
    valor = valor(:);
    controle = controle(:);

    % tabela final
    dados_organizados = table(tempo_segundos, valor_ref, controle, valor);

    % plot saída vs referência
    figure;
    subplot(2,1,1)
    plot(tempo_segundos, valor, 'b', 'LineWidth', 1)
    hold on
    plot(tempo_segundos, valor_ref, 'r--', 'LineWidth', 1.2)
    ylabel("Temperatura (°C)")
    legend("Valor Medido", "Referência")
    title("Temperatura x Tempo")
    grid on

    % plot sinal de controle
    subplot(2,1,2)
    plot(tempo_segundos, controle, 'g--', 'LineWidth', 1)
    xlabel("Tempo (segundos)")
    ylabel("Controle")
    title("Sinal de Controle")
    grid on

end

mf1 = readtable('saidaMalhaFechadaC1.txt');
mf2 = readtable('saidaMalhaFechadaC3.txt');

processa_dados_estufa(mf1,1);
processa_dados_estufa(mf2,2);