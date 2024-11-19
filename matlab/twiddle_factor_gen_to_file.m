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

                % Convert to IEEE754 binary using built-in typecast
                ieeeReal = singleToBinary(realPart);
                ieeeImag = singleToBinary(imagPart);

                % ieeeReal = floatToIEEE754(realPart);
                % ieeeImag = floatToIEEE754(imagPart);

                ieeeRealHex = singleToHex(realPart);
                ieeeImagHex = singleToHex(imagPart);
                
                % Print values and their IEEE754 representations and hex
                % for our rep
                % fprintf('realPart: %.4f, imagPart: %.4f\n', realPart, imagPart);
                % fprintf('IEEE Real: %s, Hex: %s\n', ieeeReal, ieeeRealHex);
                % fprintf('IEEE Imag: %s, Hex: %s\n', ieeeImag, ieeeImagHex);
                
                % Write values and their IEEE754 representation
                % fprintf(fileID, '%f,%f,%s,%s\n', realPart, imagPart, ieeeReal, ieeeImag);
                fprintf(fileID, '%d,%d\n', realPart*2**8, imagPart*2**8);
                
            end
        end
    end
    
    fclose(fileID);
    fprintf('Twiddle factors in IEEE754 representation successfully written to "%s".\n', filename);
end

function binaryStr = singleToBinary(value)
    % Convert a single-precision float to its IEEE754 binary representation
    singleValue = single(value); % Convert to single precision
    binary = typecast(singleValue, 'uint32'); % Interpret as uint32
    binaryStr = dec2bin(binary, 32); % Convert to 32-bit binary string
end

function hexStr = singleToHex(value)
    % Convert a single-precision float to its IEEE754 hexadecimal representation
    singleValue = single(value); % Convert to single precision
    hexValue = typecast(singleValue, 'uint32'); % Interpret as uint32
    hexStr = dec2hex(hexValue, 8); % Convert to 8-character hexadecimal string
end

% function ieee754Str = floatToIEEE754(num)
%     % Convert a floating-point number to its IEEE754 32-bit representation
%     if num == 0
%         ieee754Str = '00000000000000000000000000000000'; % Special case for zero
%         return;
%     end
% 
%     signBit = '0';
%     if num < 0
%         signBit = '1';
%         num = -num;
%     end
% 
%     % Decompose number
%     [frac, exp] = log2(num); % Get fractional and exponent parts
%     frac = frac * 2 - 1; % Normalize fraction (remove leading 1)
%     exp = exp + 127; % Bias exponent for 32-bit IEEE754
% 
%     % Handle special cases
%     if exp <= 0
%         ieee754Str = '00000000000000000000000000000000'; % Underflow
%         return;
%     elseif exp >= 255
%         ieee754Str = [signBit, '11111111', repmat('0', 1, 23)]; % Overflow
%         return;
%     end
% 
%     % Convert fraction to binary (23 bits)
%     fracBits = '';
%     for i = 1:23
%         frac = frac * 2;
%         if frac >= 1
%             fracBits = [fracBits, '1'];
%             frac = frac - 1;
%         else
%             fracBits = [fracBits, '0'];
%         end
%     end
% 
%     % Assemble IEEE754 binary representation
%     expBits = dec2bin(exp, 8);
%     ieee754Str = [signBit, expBits, fracBits];
% end
% 

%paramterizable
N = 32; 
filename = strcat('twiddle_factors_',int2str(N),'.txt'); 
generateTwiddleFactorsToFile(N, filename);
