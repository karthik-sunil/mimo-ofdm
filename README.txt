Folder Structure:
-----------------
dat: fft test data
fft_images: fft output images
matlab_fft: matlab file for fft design and verification
matlab_mimo: matlab file for mimo design
out: result for fft test cases
src: verilog files for synthesis
test: testbenches for individual modules
unused: unused files (older files - not in use anymore)
verilog: all of our verilog files

To Run:
-------
FFT: make run_all_fft
QR Decomposition: make run_all_qr
Pre-calculation: make run_all_precalc

FFT Code:
---------
Verilog Files:
verilog/fft_N_rad2.sv
verilog/butterfly.sv
verilog/delay_commutator.sv
verilog/delay.sv
verilog/deserializer.sv
verilog/input_reorder.sv
verilog/input_folding.sv
verilog/twiddle_control_pointer.sv
verilog/interleaver.sv

Testbench:
test/fft_N_rad2_tb.sv

Makefile Configuration:
HEADERS = verilog/headers.svh
TESTBENCH = test/fft_N_rad2_tb.sv
SIMFILES = verilog/fft_N_rad2.sv verilog/butterfly.sv verilog/delay_commutator.sv verilog/delay.sv verilog/deserializer.sv verilog/input_reorder.sv verilog/input_folding.sv verilog/twiddle_control_pointer.sv verilog/interleaver.sv
SYNFILES = src/fft_N_rad2.sv src/butterfly.sv src/delay_commutator.sv src/delay.sv src/deserializer.sv src/input_reorder.sv src/interleaver.sv

Notes:
- Works on both a simple sine wave and a modulated carrier wave simultaneously.
- Input files: dat/inputsine.txt, dat/modulated.txt.
- Outputs:
  - out/fft_out/out_0/inputsine_out_0_fft128_rad2.out
  - out/fft_out/out_1/modulated_out_1_fft128_rad2.out
- Plot first 127 values of the output files.
- (Pick only the first 127 file values to plot for our output (We have done this and put the output file in the folder already with the first 127 values- can be cross verified - The additional peak we may see at the 128th line is the sine wave finishing one loop and coming back to 0, so we are plotting that extra point, which is why you may see an extra peak at the end). Just run the matlab script to see the output.)
- Use matlab_fft/final_fft_plot_gen.m to generate plots.

Example:
For N=64, expect a single large value in the output corresponding to the 128-point FFT peak.

MIMO Equalizer:

Pre-calculation:
----------------
Verilog Files:
verilog/pre_cal.sv
verilog/pre_calfixed.sv
verilog/matmul.sv
verilog/fp_add.sv
verilog/fp_mul.sv

Testbench:
test/precal_tb.sv

Makefile Configuration:
HEADERS = verilog/headers.svh
TESTBENCH = test/precal_tb.sv
SIMFILES = verilog/pre_cal.sv verilog/matmul.sv verilog/fp_mul.sv verilog/fp_add.sv
SYNFILES = src/pre_cal.sv src/matmul.sv src/fp_mul.sv src/fp_add.sv

QR Decomposition:
-----------------
Top-level:
verilog/QR_decomp4.sv

Verilog Files:
verilog/QR_decomp4.sv
verilog/givens_rotation.sv
verilog/givens_matrix.sv
verilog/matmul.sv
verilog/transpose.sv
verilog/fp_mul.sv
verilog/fp_add.sv
verilog/inv_sqrt.sv
verilog/delay.sv

Testbenches:
test/test_qr.sv (QR decomposition)
test/test_givens.sv (Givens rotation)
test/test_matmul.sv (Matrix multiplication)

Makefile Configuration:
HEADERS = verilog/headers.svh
TESTBENCH = test/testbench.sv
SIMFILES = verilog/QR_decomposition.sv verilog/matmul.sv verilog/givens_rotation.sv verilog/givens_matrix.sv verilog/delay.sv verilog/fp_mul.sv verilog/fp_add.sv verilog/transpose.sv verilog/inv_sqrt.sv
SYNFILES = src/QR_decomposition.sv src/matmul.sv src/givens_rotation.sv src/givens_matrix.sv src/delay.sv src/fp_mul.sv src/fp_add.sv src/transpose.sv src/inv_sqrt.sv


MATLAB Stuff:
-----------------
All of the final MATLAB files have been organized into the check_fft_final folder under matlab_fft (i.e in matlab_fft/check_fft_final)

1. twiddle_to_svprint.m

Twiddles to be Printed in files in assign format used in SystemVerilog
This MATLAB file is used to generate all the twiddles to a file in an
assign format like this: assign W_R_STAGE_LUT[0] = 16'd256;
This is then used by the FFT as a twiddle memory header file.

Run using "twiddle_to_svprint" in MATLAB


2. sine_wave128pt_generation.m

Generates an sine wave divided into N different points 
This sine wave is of amplitude 1 and is scaled by the scaling factor used for fixed point representation (16, 8)
This file:
1. plots the sine wave in both original and fixed point format
2. generates the N sine wave values as comma separated (real, imaginary) values to the file called inputsine.txt (which feeds as input to our FFT)
3. plots the FFT of the sine wave which is in original and fixed point format to check if they are the same

Run using "sine_wave128pt_generation" in MATLAB

(we have the inputsine.txt file added in this directory for cross verification)


3. sine_wave_carrier_gen.m

Generate a sine wave divided into N different points 
This sine wave is of amplitude 1 and is scaled by the scaling factor used for fixed point representation (16, 8)
This file:
1. Uses a carrier frequency of 550 Hz and mixes it with the sine wave with a sampling frequency of 1000 Hz 
2. plots the modulated wave in both original and fixed point format
3. generates the N modulated wave values as comma separated (real, imaginary) values to the file called modulated.txt (which feeds as second input to our FFT)
4. plots the FFT of the modulated wave which is in original and fixed point format to check if they are the same

Run using "sine_wave_carrier_gen" in MATLAB

(we have the modulated.txt file added in this directory for cross verification)


4. all_fft_graph_check.m

This MATLAB Script is used to check the graph outputs for all our FFT
outputs and compares it with our ground truths.
It compares the output of our FFT called check128ptfftout.txt and
modulatedout.txt (These files contain the same output as the one generated 
by our FFT - can be cross verified.) with the golden or reference values 
in the files called a_fft128outputsine.txt and modulatedgolden.txt respectively. 

Run using "all_fft_graph_check" in MATLAB

(we have all the required files for easy run to verify it, can be copied over from the fft out folder to cross check)


5. full_check_fft.m

This MATLAB script is used to run the FFT completely and generate outputs
with all the intermediate outputs as well for debugging purposes.
It also takes in the input file just like our Verilog FFT and generates
the output to a file. This script is parameterizable in terms of which
value of N we choose for the N point FFT. This is changed by modifying
the chunk_size variable in this file

1. Generates twiddle factors in both floating and fixed point
2. Generates the output of each butterfly stage
3. Generates the final output in both floating and fixed point

Modify the chunk_size below based on what value FFT you want to compute for

Run using "full_check_fft" in MATLAB


All the other files in the directory were used during our testing and development phase and here is what each of them contain: 
"matlab_fft/fft_post_work_check" - used for one final testing of our fft module with lots of matlab code to plot and verify the outputs and also a stage wise butterfly computation output so we can easily debug by comparing our FFT output.
"matlab_fft/final_fft_matlab_verification" - all the files used to verify our initial FFT stages an design before our checkpoints




