%% Part 0: پاکسازی محیط
close all;
clc;
clear; 

%% Part 1: الف
fs = 50;
ts = 1 / fs;

t_start = -1; 
t_end = 1; 
t = t_start : ts : (t_end - ts);

x1 = cos(10 * pi * t);

% رسم سیگنال در حوزه زمان
figure;
plot(t, x1, 'b', 'LineWidth', 0.5); 
grid on; 
xlabel('Time (s)'); 
ylabel('Magnitude');
title('سیگنال در حوزه ی زمان', 'FontWeight', 'bold'); 

%% Part 2: ب

y1 = fftshift(fft(x1));
out = y1 / max(abs(y1)); % تبدیل فوریه نرمال‌شده (دامنه مقیاس شده به 1)

N = length(t); % تعداد کل نمونه‌ها

f = -fs/2 : fs/N : fs/2 - fs/N; % بردار فرکانسی

figure;
plot(f, abs(out), 'r', 'LineWidth', 0.5); 
grid on; 
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('نمایش حوزه فرکانس: دامنه نرمال‌شده', 'FontWeight', 'bold');
