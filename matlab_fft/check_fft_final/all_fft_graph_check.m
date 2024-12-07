% This MATLAB Script is used to check the graph outputs for all our FFT
% outputs and compares it with out ground truths.
% It compares the output of our FFT called check128ptfftout.txt and
% modulatedout.txt (These files contain the same output as the one generated 
% by our FFT - can be cross verified.) with the golden or reference values 
% in the files called a_fft128outputsine.txt and modulatedgolden.txt respectively. 

% params
scaling_factor = 2^8; % scaling
% filename = 'a_fft64_verilogout.txt';
% filename = 'a_fft64outputsine16.txt';
% filename = 'a_fft8outputsine64.txt'; % 8 point
% filename = 'a_fft_16outputsine.txt'; % 16 point
% filename = 'a_fft32outputsine.txt'; % 32 point
% filename = 'a_fft64outputsine.txt'; % 64 point
% filename = 'a_fft128outputsine.txt'; % 128 point

filename1 = 'modulatedgolden.txt';
filename2 = 'modulatedout.txt';

filename3 = 'a_fft128outputsine.txt';
filename4 = 'check128ptfftout.txt';

function plot_fft(filename, subplot_handle, color, linestyle)
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
    stem(subplot_handle, frequencies, fft_magnitude, color, 'LineWidth', 1.5, 'LineStyle', linestyle);
    hold(subplot_handle, 'on');
    grid(subplot_handle, 'on');
    xlabel(subplot_handle, 'Frequency (Hz)');
    ylabel(subplot_handle, 'Magnitude');
    xlim(subplot_handle, [0 1000]);

end

% Create figure
figure;

% First subplot
subplot(2, 1, 1);
plot_fft(filename1, gca, 'r', '-');
plot_fft(filename2, gca, 'b', '--');
title('Comparison of FFT Outputs (Files 1 & 2)');
legend('File 1', 'File 2');

% Second subplot
subplot(2, 1, 2);
plot_fft(filename3, gca, 'g', '-');
plot_fft(filename4, gca, 'm', '--');
title('Comparison of FFT Outputs (Files 3 & 4)');
legend('File 3', 'File 4');

% Adjust layout
sgtitle('Comparison of Four FFT Outputs');

