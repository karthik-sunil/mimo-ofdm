function generateTwiddleFactorsToFile(N, filename)
    % need N is a power of 2 - check
    if mod(log2(N), 1) ~= 0
        error('N must be a power of 2.');
    end
    
    %file stuff
    fileID = fopen(filename, 'w');
    if fileID == -1
        error('Unable to open file for writing.');
    end
    
    % using cell array to hold twiddles
    stages = log2(N); %stages
    twiddle_factors = cell(stages, 1);
    
   % twiddle factors for each stage
    for P = 1:stages
        % no of unique twiddle factors per stage
        numTwiddles = N / (2^P);
        % calculating Q factors for this stage
        Q = (0:numTwiddles-1) * 2^(P-1); % Q = k•2^(P-1)
        % final twiddle factors using Q for this stage
        twiddle_factors{P} = exp(-1j * 2 * pi * Q / N);
    end
    
    fprintf('writing twiddle factors to file "%s"...\n', filename);
    for stage = 1:stages
        numTwiddles = N / (2^stage);
        for replication = 1:(2^(stage-1)) %duplicating for each stage
            for k = 0:numTwiddles-1
                realPart = real(twiddle_factors{stage}(k+1));
                imagPart = imag(twiddle_factors{stage}(k+1));
                % if imagPart >= 0
                %     fprintf(fileID, '%.4f + %.4fi\n', realPart, imagPart);
                % else
                %     fprintf(fileID, '%.4f - %.4fi\n', realPart, abs(imagPart));
                % end
                fprintf(fileID, '%.4f,%.4f\n', realPart, imagPart);
            end
        end
    end
    
    fclose(fileID);
    fprintf('Twiddle factors successfully written to "%s".\n', filename);
end

%paramterizable
N = 16; 
filename = 'twiddle_factors.txt'; 
generateTwiddleFactorsToFile(N, filename);
