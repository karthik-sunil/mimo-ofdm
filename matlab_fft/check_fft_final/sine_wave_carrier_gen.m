% Generate a sine wave divided into N different points 
% This sine wave is of amplitude 1 and is scaled by the scaling factor used for fixed point representation (16, 8)
% This file:
% 1. Uses a carrier frequency of 550 Hz and mixes it with the sine wave with a sampling frequency of 1000 Hz 
% 2. plots the modulated wave in both original and fixed point format
% 3. generates the N modulated wave values as comma separated (real, imaginary) values to the file called modulated.txt (which feeds as second input to our FFT)
% 4. plots the FFT of the modulated wave which is in original and fixed point format to check if they are the same


N = 128; % no of values (div by 8)
amplitude = 1; % amplitude of the sine wave
scaling_factor = 2^8; % Scale for fixed-point representation
Fs = 1000; % sampling frequency in Hz (arbitrary for this example)
carrier_freq = 550; 

if mod(N, 8) ~= 0
    error('Total number of values (N) must be divisible by 8.');
end

% gen sine wave
x = linspace(0, 2*pi, N); % generate N points over one sine wave period
sine_wave = amplitude * sin(x); % Sine wave values

carrier_wave = amplitude * cos(2 * pi * carrier_freq * (0:N-1) / Fs);
mixed_signal = sine_wave .* carrier_wave;


scaled_values = round(mixed_signal * scaling_factor); % Fixed-point representation
real_values = scaled_values; % real part
imaginary_values = zeros(size(real_values)); %imaginary part
%output to file
filename = 'modulated.txt';
fileID = fopen(filename, 'w');
% fprintf(fileID, 'Real,Imaginary\n'); 
for i = 1:N
    fprintf(fileID, '%d,%d\n', real_values(i), imaginary_values(i));
end
fclose(fileID);

% FFT of the original sine wave
original_fft = fft(mixed_signal);
% original_fft_magnitude = abs(original_fft(1:N/2)); 
original_fft_magnitude = abs(original_fft); 
% frequencies = (0:N/2-1) * (Fs / N); 
frequencies = (0:N-1) * (Fs / N);

% FFT of the fixed-point sine wave
scaled_fft = fft(scaled_values / scaling_factor); %  back to decimal for FFT
% scaled_fft_magnitude = abs(scaled_fft(1:N/2));
scaled_fft_magnitude = abs(scaled_fft);

% Plot original sine wave and scaled sine wave
figure;
subplot(3, 1, 1);
plot(x, mixed_signal, 'b-', 'LineWidth', 1.5); % Original sine wave
hold on;
plot(x, scaled_values / scaling_factor, 'r--', 'LineWidth', 1.5); % Scaled sine wave
grid on;
xlabel('x (radians)');
ylabel('Amplitude');
legend('Mixed Wave', 'Fixed-Point Wave');
title('Mixed signal Wave: Original vs Fixed-Point Representation');
hold off;

% Plot FFT of original sine wave
subplot(3, 1, 2);
stem(frequencies, original_fft_magnitude, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of Original Mixed Wave');

% Plot FFT of fixed-point sine wave
subplot(3, 1, 3);
stem(frequencies, scaled_fft_magnitude, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of Fixed-Point Mixed Wave');

fprintf('Values written to file "%s".\n', filename);
