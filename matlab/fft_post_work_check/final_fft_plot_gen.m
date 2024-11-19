% params
scaling_factor = 2^8; % scaling
filename = 'a_outputsine.txt';

data = readmatrix(filename); %readinf data
if size(data, 2) ~= 2
    error('The file format should have exactly two columns: Real and Imaginary.');
end

real_values = data(:, 1);
imag_values = data(:, 2);

real_float = real_values / scaling_factor;
imag_float = imag_values / scaling_factor;

% FFT magnitude
fft_magnitude = sqrt(real_float.^2 + imag_float.^2);

N = length(fft_magnitude); % Number of FFT points
Fs = 1000; % Sampling frequency (arbitrary)
frequencies = (0:N-1) * (Fs / N)*(2); % Frequency axis in Hz
% frequencies = (0:N-1) * (Fs / N);
% fft_magnitude_half = fft_magnitude(1:N/2);

% plot of FFT magnitude
figure;
stem(frequencies, fft_magnitude, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT Magnitude from fft\_N\_rad2.sv');
xlim([0 1000]);