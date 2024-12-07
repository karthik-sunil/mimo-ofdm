% params
scaling_factor = 2^8; % scaling
% filename = 'a_fft64_verilogout.txt';
% filename = 'a_fft64outputsine16.txt';
% filename = 'a_fft8outputsine64.txt'; % 8 point
% filename = 'a_fft_16outputsine.txt'; % 16 point
% filename = 'a_fft32outputsine.txt'; % 32 point
% filename = 'a_fft64outputsine.txt'; % 64 point
% filename = 'a_fft128outputsine.txt'; % 128 point

filename = 'inputsine_out_0_fft128_rad2.txt';


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
%frequencies = (0:N-1) * (Fs / N)*(2); % Frequency axis in Hz
frequencies = (0:N-1) * (Fs / N);
% fft_magnitude_half = fft_magnitude(1:N/2);

% plot of FFT magnitude
figure;
stem(frequencies, fft_magnitude, 'r', 'LineWidth', 1.5);
%stem(frequencies, suppressed_magnitude, 'b', 'LineWidth', 1.5); % Suppressed plot

grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
% title('FFT Magnitude from Matlab Gen 128 point FFT');
title('FFT Magnitude from our FFT engine for 128 point FFT');
% title('FFT Magnitude from fft\_128\_rad2.sv');
%title('FFT Magnitude supressed from fft\_64\_rad2.sv');
xlim([0 1000]);