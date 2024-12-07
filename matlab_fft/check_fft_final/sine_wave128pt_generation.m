% Generate a sine wave divided into N different points 
% This sine wave is of amplitude 1 and is scaled by the scaling factor used for fixed point representation (16, 8)
% This file:
% 1. plots the sine wave in both original and fixed point format
% 2. generates the N sine wave values as comma separated (real, imaginary) values to the file called inputsine.txt (which feeds as input to our FFT)
% 3. plots the FFT of the sine wave which is in original and fixed point format to check if they are the same

N = 128; % no of values (div by 8)
amplitude = 1; % amplitude of the sine wave
scaling_factor = 2^8; % Scale for fixed-point representation
Fs = 1000; % Sampling frequency in Hz (arbitrary for this example)

if mod(N, 8) ~= 0
    error('Total number of values (N) must be divisible by 8.');
end

% gen sine wave
x = linspace(0, 2*pi, N); % Generate N points over one sine wave period
sine_wave = amplitude * sin(x); % Sine wave values

scaled_values = round(sine_wave * scaling_factor); % fixed-point representation
real_values = scaled_values; % real part
imaginary_values = zeros(size(real_values)); %imaginary part
%output to file
filename = 'inputsine.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, 'Real,Imaginary\n'); 
for i = 1:N
    fprintf(fileID, '%d,%d\n', real_values(i), imaginary_values(i));
end
fclose(fileID);

% FFT of the original sine wave
original_fft = fft(sine_wave);
original_fft_magnitude = abs(original_fft(1:N/2)); 
frequencies = (0:N/2-1) * (Fs / N); 

% FFT of the fixed-point sine wave
scaled_fft = fft(scaled_values / scaling_factor); %  back to decimal for FFT
scaled_fft_magnitude = abs(scaled_fft(1:N/2));

% Plot original sine wave and scaled sine wave
figure;
subplot(3, 1, 1);
plot(x, sine_wave, 'b-', 'LineWidth', 1.5); % Original sine wave
hold on;
plot(x, scaled_values / scaling_factor, 'r--', 'LineWidth', 1.5); % Scaled sine wave
grid on;
xlabel('x (radians)');
ylabel('Amplitude');
legend('Original Sine Wave', 'Fixed-Point Sine Wave');
title('Sine Wave: Original vs Fixed-Point Representation');
hold off;

% Plot FFT of original sine wave
subplot(3, 1, 2);
stem(frequencies, original_fft_magnitude, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of Original Sine Wave');

% Plot FFT of fixed-point sine wave
subplot(3, 1, 3);
stem(frequencies, scaled_fft_magnitude, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of Fixed-Point Sine Wave');

fprintf('Values written to file "%s".\n', filename);
