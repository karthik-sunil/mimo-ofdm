function fft_reorder(N)
    % N we need as a power of 2
    if mod(log2(N), 1) ~= 0
        error('N must be a power of 2'); %check
    end

    % setting the top n bottom rows based on N
    top_row = 0:(N/2 - 1);
    bottom_row = (N/2):(N - 1);

    % show nitial state
    disp("Initial Top Row: ");
    disp(top_row);
    disp("Initial Bottom Row: ");
    disp(bottom_row);

    % initial formula for delay
    delay = N / 4;
    stage = 1;
    
    while delay >= 1
        fprintf("\n=== Stage %d (Delay = %d) ===\n", stage, delay);
        
        if stage == 1
            % only in the first stage, repeat the top and bottom rows
            bottom_row_delayed = [repmat(-1, 1, delay), bottom_row, bottom_row];
            top_row_repeated = [top_row, top_row];
            fprintf("Step 1: First stage, repeat top and bottom rows\n");
        else
            % For later stages just delay
            bottom_row_delayed = [repmat(-1, 1, delay), bottom_row];
            top_row_repeated = top_row;
            fprintf("Step 1: Subsequent stage, delay bottom row without repeating\n");
        end
        
        disp("Top Row:");
        disp(top_row_repeated);
        disp("Bottom Row:");
        disp(bottom_row_delayed);

        % swap pattern
        swap_interval = delay;
        top_swapped = top_row_repeated;
        bottom_swapped = bottom_row_delayed;

        for i = swap_interval + 1 : 2 * swap_interval : length(top_swapped)
            % ceck indices
            if (i + swap_interval - 1) <= length(top_swapped) && (i + swap_interval - 1) <= length(bottom_swapped)
                top_swapped(i : i + swap_interval - 1) = bottom_row_delayed(i : i + swap_interval - 1);
                bottom_swapped(i : i + swap_interval - 1) = top_row_repeated(i : i + swap_interval - 1);
            end
        end

        fprintf("Step 2: After swapping (skip %d, swap %d)\n", swap_interval, swap_interval);
        disp("Top Row:");
        disp(top_swapped);
        disp("Bottom Row:");
        disp(bottom_swapped);

        % delay the top row by `delay` cycles for alignment in the next stage
        top_row = [repmat(-1, 1, delay), top_swapped];
        bottom_row = bottom_swapped;

        fprintf("Step 3: Delay top row by %d cycles for alignment\n", delay);
        disp("Top Row:");
        disp(top_row);
        disp("Bottom Row:");
        disp(bottom_row);

        % for next stage
        delay = delay / 2;
        stage = stage + 1;
    end

    fprintf("\nFinal Arrangement:\n");
    disp("Top Row:");
    disp(top_row);
    disp("Bottom Row:");
    disp(bottom_row);
end


% fft_reorder(8);
fft_reorder(16);