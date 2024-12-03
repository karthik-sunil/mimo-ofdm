function fft_file_processor(input_file, output_file)

    % input file
    data = readmatrix(input_file, 'Delimiter', ',', 'OutputType', 'double');
    real_part = data(:, 1)/256; 
    imag_part = data(:, 2)/256; 

    % output file
    file_id = fopen(output_file, 'w');
    if file_id == -1
        error('Could not open the output file.');
    end

    %processing the data in chunks of 8
    chunk_size = 8;
    num_samples = length(real_part);
    num_chunks = ceil(num_samples / chunk_size);

    for chunk = 1:num_chunks
        % getting current chunk of data
        start_idx = (chunk - 1) * chunk_size + 1;
        end_idx = min(chunk * chunk_size, num_samples);

        if end_idx - start_idx + 1 < chunk_size
            % padding with zeros if the chunk is smaller than 8
            real_chunk = [real_part(start_idx:end_idx); zeros(chunk_size - (end_idx - start_idx + 1), 1)];
            imag_chunk = [imag_part(start_idx:end_idx); zeros(chunk_size - (end_idx - start_idx + 1), 1)];
        else
            real_chunk = real_part(start_idx:end_idx);
            imag_chunk = imag_part(start_idx:end_idx);
        end

        % doing FFT for the current chunk
        fft_output = dif_fft_complex_verbose(real_chunk, imag_chunk);

        % Scale FFT output to 16,8 fixed-point representation
        real_scaled = round(real(fft_output) * 256);
        imag_scaled = round(imag(fft_output) * 256);

        % Write the FFT output for this chunk to the file
        for i = 1:chunk_size
            fprintf(file_id, '%d,%d\n', real_scaled(i), imag_scaled(i));
        end
    end

    fclose(file_id);
    fprintf('FFT processing complete. Results written to %s\n', output_file);
end

function X = dif_fft_complex_verbose(real_part, imag_part)

    input_signal = real_part + 1j * imag_part;

    %pow of 2
    N = length(input_signal);
    if mod(N, 2) ~= 0 || log2(N) ~= round(log2(N))
        error('Input length must be a power of 2.');
    end

    %making it a column vector
    input_signal = input_signal(:);
    

    num_stages = log2(N);

    X = input_signal;

    %DIF FFT
    for stage = 1:num_stages
        %step size for stages to pick the butterfly
        step = 2^(num_stages - stage);

        %twiddle computation
        twiddles = exp(-2j * pi * (0:step-1)' / (2*step));
        fprintf('\nStage %d Twiddle Factors:\n', stage);
        print_complex(twiddles);

        for k = 0:(N/(2*step)-1)
            for n = 1:step
                %indices
                idx1 = k * 2 * step + n;
                idx2 = idx1 + step;

                %to display value (intermediate)
                X1_orig = X(idx1);
                X2_orig = X(idx2);
                
                %actual butterfly
                temp = X(idx1) + X(idx2);
                X(idx2) = (X(idx1) - X(idx2)) * twiddles(n);
                X(idx1) = temp;

                % Print intermediate values
                fprintf('  Stage %d: Butterfly (%d, %d)\n', stage, idx1, idx2);
                fprintf('    Input: X[%d] = ', idx1);
                print_complex(X1_orig);
                fprintf(', X[%d] = ', idx2);
                print_complex(X2_orig);
                fprintf('\n');
                fprintf('    Output: X[%d] = ', idx1);
                print_complex(X(idx1));
                fprintf(', X[%d] = ', idx2);
                print_complex(X(idx2));
                fprintf('\n');
            end
        end
    end

    %bit reverser
    X = bitrevorder(X);

    fprintf('\nFinal Output (Normal Order):\n');
    for i = 1:N
        fprintf('X[%d] = ', i-1);
        print_complex(X(i));
        fprintf('\n');
    end
end

function print_complex(z)
    % Helper function to print a complex number in a + bi format
    % with 16,8 fixed-point scaling by multiplying by 256
    
    % Scale real and imaginary parts to 16,8 fixed-point representation
    real_scaled = round(real(z) * 256); % Multiply by 256 and round to nearest integer
    imag_scaled = round(imag(z) * 256); % Multiply by 256 and round to nearest integer

    % Print scaled values as integers
    if imag_scaled >= 0
        fprintf('%0.4f + %0.4fi (16,8 scaled: %d + %di)', ...
                real(z), imag(z), real_scaled, imag_scaled);
    else
        fprintf('%0.4f - %0.4fi (16,8 scaled: %d - %di)', ...
                real(z), abs(imag(z)), real_scaled, abs(imag_scaled));
    end
end

% % writing the output to another file
% function write_fft_output(output_file, real_scaled, imag_scaled)
% 
%     file_id = fopen(output_file, 'w');
%     if file_id == -1
%         error('Could not open the output file.');
%     end
% 
%     num_outputs = length(real_scaled);
%     for i = 1:num_outputs
%         fprintf(file_id, '%d,%d\n', real_scaled(i), imag_scaled(i));
%     end
% 
%     fclose(file_id);
% end


fft_file_processor('inputsine.txt', 'outputsine.txt');
