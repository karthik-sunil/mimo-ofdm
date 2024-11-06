function fft_reorder(N)
    % N must be a power of 2
    if mod(log2(N), 1) ~= 0
        error('N must be a power of 2'); % Check
    end

    % input array for testing
    % output series for this is [4, 0, 0, 0, 4, 0, 0, 0]
    x = [1, 1, 1, 1, 0, 0, 0, 0];
    x = x.'; % Convert to column vector for easier manipulation

    % Initializing the top and bottom rows based on N
    top_row = x(1:N/2);
    bottom_row = x(N/2+1:N);

    % Inline function to format a row without cell array markers
    format_row = @(row) strjoin(cellfun(@num2str, num2cell(row), 'UniformOutput', false), ' ');

    % show initial state before we pass it to the piepline
    disp("Initial Top Row:");
    disp(format_row(top_row));
    disp("Initial Bottom Row:");
    disp(format_row(bottom_row));

    % Initial delay for the dc
    delay = N / 4;
    stage = 1;

    while delay >= 1
        fprintf("\n=== Stage %d (Delay = %d) ===\n", stage, delay);
        
        % was using NaN as a valid input to the next stage so had to add
        % this to filter it out
        % Filter out NaNs and take only the first N/2 elements for butterfly operations
        top_row_valid = top_row(~isnan(top_row));
        bottom_row_valid = bottom_row(~isnan(bottom_row));
        top_row_valid = top_row_valid(1:N/2);
        bottom_row_valid = bottom_row_valid(1:N/2);
        
        % Step 1: Perform the butterfly operation on N/2 non-NaN elements
        top_row_butterfly = zeros(1, N/2);
        bottom_row_butterfly = zeros(1, N/2);

        % show butterfly input before computing
        fprintf("Butterfly Input (Stage %d):\n", stage);
        disp("Top Row (X values):");
        disp(format_row(top_row_valid));
        disp("Bottom Row (Y values):");
        disp(format_row(bottom_row_valid));
        
        for i = 1:N/2
            A = top_row_valid(i);
            B = bottom_row_valid(i);
            X = A + B; % top part of butterfly (sum)
            Y = A - B; % bottom part of butterfly (difference)
            top_row_butterfly(i) = X;
            bottom_row_butterfly(i) = Y;
        end

        % Display butterfly output
        fprintf("Butterfly Output (Stage %d):\n", stage);
        disp("Top Row (X values):");
        disp(format_row(top_row_butterfly));
        disp("Bottom Row (Y values):");
        disp(format_row(bottom_row_butterfly));

        % Step 2: delay the bottom row and duplicate if it's the first stage
        % we can print the extra second half but it is usually the same as
        % the bottom row (therefore no need to replicate I think)
        if stage == 1
            % Only in the first stage, repeat the top and bottom rows
            bottom_row_delayed = [repmat(NaN, 1, delay), bottom_row_butterfly, bottom_row_butterfly];
            top_row_repeated = [top_row_butterfly, top_row_butterfly];
            fprintf("Step 2: First stage, repeat top and bottom rows with delay\n");
        else
            % For later stages, just delay
            bottom_row_delayed = [repmat(NaN, 1, delay), bottom_row_butterfly];
            top_row_repeated = top_row_butterfly;
            fprintf("Step 2: Subsequent stage, delay bottom row without repeating\n");
        end

        % show the delayed rows
        disp("Top Row after delay:");
        disp(format_row(top_row_repeated));
        disp("Bottom Row after delay:");
        disp(format_row(bottom_row_delayed));

        % step 3: commutator swap pattern based on delay
        swap_interval = delay;
        top_swapped = top_row_repeated;
        bottom_swapped = bottom_row_delayed;

        for i = swap_interval + 1 : 2 * swap_interval : length(top_swapped)
            % Check indices for valid swapping
            if (i + swap_interval - 1) <= length(top_swapped) && (i + swap_interval - 1) <= length(bottom_swapped)
                top_swapped(i : i + swap_interval - 1) = bottom_row_delayed(i : i + swap_interval - 1);
                bottom_swapped(i : i + swap_interval - 1) = top_row_repeated(i : i + swap_interval - 1);
            end
        end

        fprintf("Step 3: After swapping (skip %d, swap %d)\n", swap_interval, swap_interval);
        disp("Top Row after swap:");
        disp(format_row(top_swapped));
        disp("Bottom Row after swap:");
        disp(format_row(bottom_swapped));

        % step 4: delay the top row by `delay` cycles for alignment in the next stage
        top_row = [repmat(NaN, 1, delay), top_swapped];
        bottom_row = bottom_swapped;

        fprintf("Step 4: Delay top row by %d cycles for alignment\n", delay);
        disp("Top Row for next stage:");
        disp(format_row(top_row));
        disp("Bottom Row for next stage:");
        disp(format_row(bottom_row));

        % setting delay and stage for next stage
        delay = delay / 2;
        stage = stage + 1;
    end

    % Final Butterfly Operation at the end since we have N butterflies for
    % N-1 delay commutators
    fprintf("\n=== Final Butterfly Operation ===\n");
    final_top_row = zeros(1, length(top_row(~isnan(top_row))));
    final_bottom_row = zeros(1, length(bottom_row(~isnan(bottom_row))));
    
    top_row_valid = top_row(~isnan(top_row));
    bottom_row_valid = bottom_row(~isnan(bottom_row));

    for i = 1:length(top_row_valid)
        A = top_row_valid(i);
        B = bottom_row_valid(i);
        X = A + B;
        Y = A - B;
        final_top_row(i) = X;
        final_bottom_row(i) = Y;
    end

    % display final butterfly output
    disp("Final Top Row (X values):");
    disp(format_row(final_top_row));
    disp("Final Bottom Row (Y values):");
    disp(format_row(final_bottom_row));

    fprintf("\nFinal FFT Output:\n");
    disp("Top Row:");
    disp(format_row(final_top_row));
    disp("Bottom Row:");
    disp(format_row(final_bottom_row));

    % Bit reversal part to show correct output in the x[0], x[1], x[2],
    % x[3] ... format
    log2N = log2(N);
    reordered_output = zeros(1, N); % to hold the final output

    %interleaving the outputs - as final_top_row[0], final_bottom_row[0], 
    % final_top_row[1], final_bottom_row[1], final_top_row[2], final_bottom_row[2], ...
    combined_output = zeros(1, N);
    for i = 1:(N/2)
        combined_output(2*i - 1) = final_top_row(i);
        combined_output(2*i) = final_bottom_row(i);
    end

    % bit reversal
    for i = 0:(N-1)
        % bit-reversed function called
        bit_reversed_index = bit_reverse(i, log2N);
        % place it in the correct place based on the bit-reversed index
        reordered_output(bit_reversed_index + 1) = combined_output(i + 1);
    end

    disp('Reordered FFT Output (x[0] to x[N-1]):');
    disp(reordered_output);

    % bit-reversed index calc
    function reversed = bit_reverse(index, num_bits)
        reversed = 0;
        for j = 0:(num_bits - 1)
            if bitand(index, bitshift(1, j))
                reversed = bitor(reversed, bitshift(1, num_bits - 1 - j));
            end
        end
    end

end


% testing the function
fft_reorder(8);
