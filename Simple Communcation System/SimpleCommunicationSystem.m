% Transmitter Part

[signal, fs] = audioread('Kalimba.mp3');

signal = signal(1 : 8*fs, 1); 

sound(signal, fs);

fprintf('The sound file is playing now...\n');

Signal_Length = length(signal);

t = linspace(0, length(signal)./fs,Signal_Length);

figure;

subplot(2, 2, [1 2]);

plot(t, signal);

xlabel('Time', 'Interpreter', 'latex'); 

ylabel('Amplitude', 'Interpreter', 'latex');  

title('Signal in time domain', 'Interpreter', 'latex');

signal_F = fftshift(fft(signal)) ;

signal_amplitude = abs(signal_F) ;

signal_phase = angle(signal_F) ;

f = linspace(-fs/2,fs/2,length(signal_F));

subplot(2,2,3) ;

title('Signal in frequency domain', 'Interpreter', 'latex');

plot(f,signal_amplitude);

xlabel('Frequency');

ylabel('Amplitude'); 

title('Magnitude spectrum', 'Interpreter', 'latex');

subplot(2,2,4)

plot(f,signal_phase);

xlabel('frequency');

ylabel('phase'); 

title('Phase spectrum', 'Interpreter', 'latex');

% Wait for music to finish
pause(8); 

% Channel Part

Option = menu('Select channel: ','Delta function', ...
              'exp(-2pi*5000t)','exp(-2pi*1000t)', ...
              '2*Delta(t)+0.5*Delta(t-1)');

switch Option
    
    case 1
        
        h = Delta(t);
        
    case 2
        
        h = exp(-10000*pi*t);
        
    case 3
        
        h = exp(-2000*pi*t);
        
    case 4
        
        h = 2*Delta(t) + 0.5*Delta(t-1);
       
       
end

ch_signal = conv(h, signal);

t = linspace(0, length(ch_signal)/fs, length(ch_signal));

sound(ch_signal, fs) ;

fprintf('The sound after passing from channel is playing...\n') ;

figure;

plot(t, ch_signal) 

title('the signal after passing in channel in time domain', 'Interpreter', 'latex');

% Wait for music to finish
pause(8); 


% Noise Part

sigma = input('Enter the value of the noise: ');

Z = sigma.*randn(1, length(ch_signal));

signal_noise = ch_signal + Z';

sound(signal_noise, fs);

fprintf('The sound file after adding noise is playing now...\n');

figure;

subplot(2, 2, [1 2]) ;

plot(t, signal_noise);

xlabel('Time', 'Interpreter', 'latex'); 

ylabel('Amplitude', 'Interpreter', 'latex');  

title('Signal with noise in time domain', 'Interpreter', 'latex');

f = linspace(-fs/2, fs/2, length(signal_noise));

signal_noise_f = fftshift(fft(signal_noise));

signal_noise_amplitude = abs(signal_noise_f);

signal_noise_phase = angle(signal_noise_f);

subplot(2, 2, 3);

title('Signal with noise in frequency domain', 'Interpreter', 'latex');

plot(f, signal_noise_amplitude);

xlabel('Frequency', 'Interpreter', 'latex');

ylabel('Amplitude', 'Interpreter', 'latex'); 

title('Magnitude Spectrum', 'Interpreter', 'latex');

subplot(2, 2, 4)

plot(f, signal_noise_phase);

xlabel('Frequency', 'Interpreter', 'latex');

ylabel('Phase', 'Interpreter', 'latex'); 

title('Phase spectrum', 'Interpreter', 'latex');

% Wait for music to finish
pause(8); 

clear sound;

% Receiver Part

L_P_Filter=ones(length(signal_noise_f), 1);
f_cutoff = (length(signal_noise) / fs) * (fs/2 - 3400);
L_P_Filter([1:f_cutoff end:-1:length(signal_noise_f) - f_cutoff + 1]) = 0;

rec_signal_f=signal_noise_f.*L_P_Filter;

rec_signal=real(ifft(ifftshift(rec_signal_f)));

sound(rec_signal, fs);

fprintf('The sound file received is playing now...\n');

figure;

subplot(2,2,[1 2]) ;

plot(t, rec_signal);

xlabel('Time', 'Interpreter', 'latex'); 

ylabel('Amplitude', 'Interpreter', 'latex');  

title('Received Signal in time domain', 'Interpreter', 'latex');

f = linspace(-fs/2,fs/2,length(rec_signal));

rec_signal_amplitude = abs(rec_signal_f);

rec_signal_phase = angle(rec_signal_f);

subplot(2, 2, 3);

title('Received Signal in frequency domain', 'Interpreter', 'latex');

plot(f, rec_signal_amplitude);

xlabel('Frequency', 'Interpreter', 'latex');

ylabel('Amplitude', 'Interpreter', 'latex'); 

title('Magnitude Spectrum', 'Interpreter', 'latex');

subplot(2, 2, 4)

plot(f, rec_signal_phase);

xlabel('Frequency', 'Interpreter', 'latex');

ylabel('Phase', 'Interpreter', 'latex'); 

title('Phase spectrum', 'Interpreter', 'latex');

% Wait for music to finish
pause(8); 

clear sound;

function [Output] = Delta(Input)

zero_Place = Input == 0 ;

Output = zeros(1, length(Input));

Output(zero_Place) = 1;

end