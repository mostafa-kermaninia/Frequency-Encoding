%% Part 0: پاکسازی محیط
close all;
clc;
clear; 

%% Part 1: الف
fs = 100;
ts = 1 / fs;

t_start = 0; 
t_end = 1; 
t = t_start : ts : (t_end - ts);

x2=cos(30*pi*t + pi/4);

% رسم سیگنال در حوزه زمان
figure;
plot(t, x2, 'b', 'LineWidth', 0.5); 
grid on; 
xlabel('Time (s)'); 
ylabel('Magnitude');
title('سیگنال در حوزه ی زمان', 'FontWeight', 'bold'); 

%% Part 2: ب

y1 = fftshift(fft(x2));
out = y1 / max(abs(y1)); % تبدیل فوریه نرمال‌شده (دامنه مقیاس شده به 1)

N = length(t); % تعداد کل نمونه‌ها
% روش دوم تعریف N
% T = (t_end - t_start);
% N = T/ts;

f = -fs/2 : fs/N : fs/2 - fs/N; % بردار فرکانسی

figure;
plot(f, abs(out), 'r', 'LineWidth', 0.5); 
grid on; 
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('اندازه ی سیگنال در حوزه ی فرکانس', 'FontWeight', 'bold');

%% Part 3: ج
to1=1e-6;
out(abs(out)<to1)=0;
theta=angle(out);
figure
plot(f,theta/pi, 'g', 'LineWidth', 0.5)
grid on; 
xlabel('Frequency(Hz)')
ylabel('Phase / pi')
title('فاز سیگنال در حوزه ی فرکانس', 'FontWeight', 'bold');
