%% Part 0: پاکسازی محیط
close all; 
clc; 
clear; 

%% Part 1
fs = 20; % فرکانس نمونه‌برداری (هرتز)
t_start = 0; % زمان شروع نمونه‌برداری (ثانیه)
t_end = 1; % زمان پایان نمونه‌برداری (ثانیه)
ts = 1/fs; % فاصله زمانی بین دو نمونه (ثانیه)
t = t_start : ts : (t_end - ts); 
N = length(t); % تعداد کل نمونه‌ها

x1 = exp(1i * 2 * pi * 5 * t) + exp(1i * 2 * pi * 8 * t); 
x2 = exp(1i * 2 * pi * 5 * t) + exp(1i * 2 * pi * (5.1) * t); 

y1 = fftshift(fft(x1)); % تبدیل فوریه و جابجایی فرکانس‌ها برای سیگنال اول
y1 = y1 / max(abs(y1)); % نرمال‌سازی دامنه

y2 = fftshift(fft(x2)); % تبدیل فوریه و جابجایی فرکانس‌ها برای سیگنال دوم
y2 = y2 / max(abs(y2)); % نرمال‌سازی دامنه

f = -fs/2 : fs/N : fs/2 - fs/N; % بردار فرکانسی

%% Part 2: رسم نمودارها
figure; 

subplot(1, 2, 1); 
plot(f, abs(y1), 'LineWidth', 1.5); 
title('F[x_1](w)'); 
xlabel('Frequency (Hz)');
ylabel('Magnitude'); 
grid on; 

subplot(1, 2, 2); 
plot(f, abs(y2), 'LineWidth', 1.5);
title('F[x_2](w)'); 
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on; 