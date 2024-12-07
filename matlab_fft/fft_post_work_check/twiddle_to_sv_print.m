function writeTwiddleFactorAssignments16_8_decimal(N, filename)
    if mod(log2(N), 1) ~= 0
        error('N must be a power of 2.');
    end

    fileID = fopen(filename, 'w');
    if fileID == -1
        error('Unable to open file for writing.');
    end

    stages = log2(N); % no of stages
    twiddle_factors = cell(stages, 1);
    
    % Computation of twiddle factors for each stage
    for P = 1:stages
        numTwiddles = N / (2^P);
        Q = (0:numTwiddles-1) * 2^(P-1); % Q = k•2^(P-1)
        twiddle_factors{P} = exp(-1j * 2 * pi * Q / N);
    end

% Only process the first stage [0]
    stage = 1;
    numTwiddles = N / (2^stage);
    for butterfly = 0:numTwiddles-1
        realPart = real(twiddle_factors{stage}(butterfly+1));
        imagPart = imag(twiddle_factors{stage}(butterfly+1));
        
        fixedReal = floatToFixedDecimal16_8(realPart);
        fixedImag = floatToFixedDecimal16_8(imagPart);

        if fixedReal < 0
        fprintf(fileID, 'assign W_R_STAGE_LUT[%d] = -16''d%d;\n', butterfly, abs(fixedReal));
        else
        fprintf(fileID, 'assign W_R_STAGE_LUT[%d] = 16''d%d;\n', butterfly, fixedReal);
        end
        
        if fixedImag < 0
        fprintf(fileID, 'assign W_I_STAGE_LUT[%d] = -16''d%d;\n', butterfly, abs(fixedImag));
        else
        fprintf(fileID, 'assign W_I_STAGE_LUT[%d] = 16''d%d;\n', butterfly, fixedImag);
        end
    end

    fclose(fileID);
    fprintf('assignments written to "%s".\n', filename);
end

function fixedDecimal = floatToFixedDecimal16_8(value)
    % Convert a floating-point number to fixed-point representation (16,8)
    fracBits = 8;
    scale = 2^fracBits;
    maxVal = 2^(16 - fracBits - 1) - 1 / scale;
    minVal = -2^(16 - fracBits - 1);
    
    % Clamp value to the fixed-point range
    value = min(max(value, minVal), maxVal);
    
    % Scale and round to the nearest integer
    fixedDecimal = round(value * scale);
end

N = 8;
for loop = 1:10
    no = 8*2^(loop-1);
    filename = sprintf('twiddle_%dfixed_sv.txt', no);
    writeTwiddleFactorAssignments16_8_decimal(no, filename);
end
