%% --- Malha fechada ---
T_mf = feedback(C * G, 1);
U_tf = feedback(C, G);


info = stepinfo(T_mf);
t_final = 5 * info.SettlingTime;

%% --- Simulação ---
t = linspace(0, t_final, 5000);
ref = 440;
y0  = 400;
degrau = ref - y0;

[y, t] = step(T_mf * degrau, t);
[u, ~] = step(U_tf * degrau, t);

y_abs = y + y0;
u_abs = u + 30;

%% --- Métricas ---
info = stepinfo(T_mf, 'SettlingTimeThreshold', 0.02);
fprintf('Overshoot:        %.2f%%\n',   info.Overshoot)
fprintf('Tempo de subida:  %.1f s  (%.1f min)\n', info.RiseTime,    info.RiseTime/60)
fprintf('Tempo de acomod.: %.1f s  (%.1f min)\n', info.SettlingTime, info.SettlingTime/60)
fprintf('Pico do controle: %.2f%%PWM\n', max(u_abs))

%% --- Plot ---
figure

subplot(2,1,1)
plot(t/60, y_abs, 'b', 'LineWidth', 2)
yline(440, 'r--', 'T_{ref}', 'LineWidth', 1.5)
yline(400, 'k:',  'T_{inicial}', 'LineWidth', 1)
ylabel('Nível do TP'); xlabel('Tempo (min)')
title(sprintf('PI  |  Kp=%.3f  |  Ti=%.0fs ', Kp, Ti))
grid on

subplot(2,1,2)
plot(t/60, u_abs, 'r', 'LineWidth', 2)
yline(100, 'k--', 'Saturação 100%', 'LineWidth', 1.5)
yline(0,   'k:',  'Mínimo 0%',      'LineWidth', 1)
ylabel('Sinal de controle (%PWM)'); xlabel('Tempo (min)')
title(sprintf('Pico de controle: %.1f%%PWM', max(u_abs)))
grid on; ylim([-5 110])