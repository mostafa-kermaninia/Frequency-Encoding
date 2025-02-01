%% Part 1
% Define our char array which contains alphabet and additional characters
close all;
clc;
clear;

chars = ['a':'z', ' ', '.', ',', '!', '"', ';'];

% Creating a mapset with 2 rows and columns Row 1 is the characters Row 2
% is the binary coded value of each character
Mapset = cell(2, 32);

% Set the values into Mapset
for i = 1:32
    % Store the character in the first row of Mapset
    Mapset{1, i} = chars(i);
    
    % Add the binary coded value for each character (i-1 in binary)
    Mapset{2, i} = dec2bin(i - 1, 5);
end

%% Part 3
message = 'signal';
coded_signal1 = coding_freq(message, 1, Mapset, 1);
coded_signal2 = coding_freq(message, 5, Mapset, 1);

%% Part 4
msg1 = decoding_freq(coded_signal1, 1, Mapset);
msg2 = decoding_freq(coded_signal2, 5, Mapset);

disp(['decoded msg1 is: ', msg1, ' decoded msg2 is: ', msg2]);

%% Part 5

% speed = 1
message = 'signal';
coded_signal1 = coding_freq(message, 1, Mapset, 0);
coded_signal1 = coded_signal1 + 0.01*randn(1, length(coded_signal1)); % Add noise
x_axis=zeros(1,length(coded_signal1));
for j=1:length(coded_signal1)
    x_axis(j)=j/100;
end
figure;
plot(x_axis,coded_signal1)
title('coded signal with noise for signal1');
decoded_msg1 = decoding_freq(coded_signal1, 1, Mapset);
disp(['decoded message for coded signal with noise is:',decoded_msg1, ' for speed = 1']);

% speed = 5
coded_signal2 = coding_freq(message, 5, Mapset, 0);
coded_signal2 = coded_signal2 + 0.01*randn(1, length(coded_signal2)); % Add noise
x_axis=zeros(1,length(coded_signal2));
for j=1:length(coded_signal2)
    x_axis(j)=j/100;
end
figure;
plot(x_axis,coded_signal2)
title('coded signal with noise for signal2');
decoded_msg2 = decoding_freq(coded_signal1, 1, Mapset);
disp(['decoded message for coded signal with noise is:',decoded_msg2, ' for speed = 5']);


%% Part 6 and 7
message = 'signal';
for Speed=1:4:5
    sum_var = 0;
    max_var = 0;
    for i=1:300
        std = 0.01;
        decoded_message = 'signal';
        while message == decoded_message
            coded_signal = coding_freq(message, Speed, Mapset, 0);
            coded_signal = coded_signal + std*randn(1, length(coded_signal));
            decoded_message=decoding_freq(coded_signal, Speed, Mapset);
            if message == decoded_message
                std = std + 0.01;
            end
        end
        sum_var = sum_var + (std^2);
        if max_var < (std-0.01)^2
            max_var =   (std-0.01)^2;
        end
    end
    x_axis=zeros(1,length(coded_signal));
    for j=1:length(coded_signal)
        x_axis(j)=j/100;
    end
    figure;
    plot(x_axis,coded_signal)
    title(['coded signal with noise with BitRate decoded incorrectly = ', num2str(Speed) ]);
    disp([decoded_message, ' for BitRate = ', num2str(Speed), ' mean noise variance = ', num2str(sum_var/300)]);
    disp(['Max variance for BitRate = ', num2str(Speed), ' decodes correctly is about', num2str(max_var)]);
end

%% Part 2
function Coded_signal = coding_freq(message, speed, mapset, show_plt)
    
    fs = 100;
    % Convert message to binary sequence using mapset
    message_bin = '';
    for k = 1:length(message)
        char_index = find(strcmp(mapset(1,:), message(k)));  % Find the character index in mapset
        if isempty(char_index)
            error(['Character ', message(k), ' not found in mapset.']);
        end
        char_bin = mapset{2, char_index};  % Get binary representation of each character
        message_bin = [message_bin, char_bin];  % Append to the binary message sequence
    end

    ts = 1/fs;
    t = 0 : ts : (1-ts);

    frequency=cell(1,5);
    frequency{1,1}=[12,37];
    frequency{1,2}=[5,16,27,38];
    frequency{1,3}=[4,10,16,22,28,34,40,46];
    frequency{1,4}=[2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47];
    frequency{1,5}=[1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35,37,38,40,41,43,44,46,47];

    f_i = cell2mat(frequency(speed));   
    
    
    % Creating the coded signal by choosing the right frequency
    Coded_signal=[];
    for i=1:speed:length(message_bin)
        code_number = bin2dec(message_bin(i:i+speed-1));
        Coded_signal = [Coded_signal sin(2*pi*f_i(code_number+1)*t)];
    end
    
    % Plot the result if needed
    if (show_plt == 1)
        x_axis=zeros(1,length(message_bin)/speed * 100);
        for i=1:length(message_bin)/speed*100
            x_axis(i)=i/100;
        end
        figure;
        plot(x_axis,Coded_signal)
    end
end
  
%% Part 4
function Decoded_message = decoding_freq(Coded_signal, speed, mapset)
    fs = 100;
    
    frequency=cell(1,5);
    frequency{1,1}=[12,37];
    frequency{1,2}=[5,16,27,38];
    frequency{1,3}=[4,10,16,22,28,34,40,46];
    frequency{1,4}=[2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47];
    frequency{1,5}=[1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35,37,38,40,41,43,44,46,47];

    f_i = cell2mat(frequency(speed));
    
    % Find the frequency of each 1sec in the coded signal
    freq_indexes = [];
    for i = 1:fs:length(Coded_signal)
        X = Coded_signal(i:fs+i-1);
        Y = fftshift(fft(X));
        Y = abs(Y/max(Y));
        vals_selected_f = [];
        for j= 1:length(f_i)
            vals_selected_f = [vals_selected_f Y(51+f_i(j))];
        end
        [val idx] = max(abs(vals_selected_f));
        freq_indexes = [freq_indexes idx];
    end

    % Finding the binary message
    message_bin=[];
    for i = 1 : length(freq_indexes)
        message_bin = [message_bin dec2bin(freq_indexes(i)-1, speed)];
    end
    
    Decoded_message = [];
    for i = 1 : length(message_bin)/5 
        ch = message_bin(5*i-4 : 5*i);
        number = bin2dec(ch); 
        Decoded_message = [Decoded_message mapset{1, number+1}];
    end
end



