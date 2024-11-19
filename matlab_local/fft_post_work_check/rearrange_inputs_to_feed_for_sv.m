
filename = 'inputsine.txt';
data = readmatrix(filename, 'Delimiter', ',');

if mod(size(data, 1), 8) ~= 0
    error('The number of real-imaginary pairs in the file is not a multiple of 8.');
end

% no of groupd for 8 length each
num_groups = size(data, 1) / 8;

rearranged_data = [];

%rearrange 8 each
for i = 1:num_groups
    group = data((i-1)*8 + 1:i*8, :);
    
    % rearrange indices as 0,4,1,5,2,6,3,7
    rearranged_indices = [1, 5, 2, 6, 3, 7, 4, 8]; 
    rearranged_group = group(rearranged_indices, :);

    rearranged_data = [rearranged_data; rearranged_group];
end

disp('Rearranged Data:');
for i = 1:size(rearranged_data, 1)
    fprintf('Real: %f, Imaginary: %f\n', rearranged_data(i, 1), rearranged_data(i, 2));
end

output_filename = 'for_verdi_outputsine.txt'; 
writematrix(rearranged_data, output_filename, 'Delimiter', ',');
