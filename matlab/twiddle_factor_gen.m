function twiddle_factors = generateTwiddleFactors(N)
    % need N is a power of 2 - check
    if mod(log2(N), 1) ~= 0
        error('N must be a power of 2.');
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
end

%paramterizable
N = 8;
twiddles = generateTwiddleFactors(N);

%print twiddle factors
% fprintf('\nTwiddle Factors for %d-point DIF FFT:\n', N);
% for stage = 1:log2(N)
%     fprintf('\nStage %d Twiddle Factors:\n', stage);
%     numTwiddles = N / (2^stage);
%     Q = (0:numTwiddles-1) * 2^(stage-1);
%     for k = 0:numTwiddles-1
%         fprintf('W%d(%d) [Q = %d] = %.4f + %.4fi\n', ...
%             N, k, Q(k+1), real(twiddles{stage}(k+1)), imag(twiddles{stage}(k+1)));
%     end
% end

fprintf('\nTwiddle Factors for %d-point DIF FFT:\n', N);
for stage = 1:log2(N)
    fprintf('\nStage %d Twiddle Factors:\n', stage);
    numTwiddles = N / (2^stage);
    Q = (0:numTwiddles-1) * 2^(stage-1);
    for k = 0:numTwiddles-1
        realPart = real(twiddles{stage}(k+1));
        imagPart = imag(twiddles{stage}(k+1));
        % Adjust sign display for imagPart
        if imagPart >= 0
            fprintf('W%d(%d) [Q = %d] = %.4f + %.4fi\n', N, k, Q(k+1), realPart, imagPart);
        else
            fprintf('W%d(%d) [Q = %d] = %.4f - %.4fi\n', N, k, Q(k+1), realPart, abs(imagPart));
        end
    end
end