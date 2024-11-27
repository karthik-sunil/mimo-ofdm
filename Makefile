export MK_COURSE_NAME = EECS598-002
# make          <- runs simv (after compiling simv if needed)
# make simv     <- compiles simv without running
# make dve      <- runs GUI debugger (after compiling it if needed)
# make syn      <- runs syn_simv (after synthesizing if needed then 
#                                 compiling syn_simv if needed)
# make clean    <- remove files created during compilations (but not synthesis)
# make nuke     <- remove all files created during compilation and synthesis
#
# To compile additional files, add them to the TESTBENCH or SIMFILES as needed
# Every .vg file will need its own rule and one or more synthesis scripts
# The information contained here (in the rules for those vg files) will be 
# similar to the information in those scripts but that seems hard to avoid.
#

# this is a global clock period variable used in the tcl script and referenced in testbenches
# export CLOCK_PERIOD = 5.0

# your top-level module name
export MK_DESIGN_NAME = fft_N_rad2

# CPU core usage, capped at 6
export MK_USE_NUM_CORES = 4

# memory library selection
export MK_MEM_SUFFIX = typ_1d05_25

export N = 8

# the Verilog Compiler command and arguments
VCS = SW_VCS=2020.12-SP2-1 vcs -sverilog +vc -Mupdate -line -full64 -kdb -nc -xprop=tmerge -lca \
      -debug_access+all+reverse $(VCS_BAD_WARNINGS) +define+ -timescale=1ns/1ps 
LIB = /afs/umich.edu/class/eecs598-002/SAED32/SAED32_EDK/lib/stdcell_rvt/verilog/saed32nm.v

all:	simv
	./simv | tee program.out

##### 
# Modify starting here
#####

# HEADERS = verilog/headers.svh
# TESTBENCH = test/delay_tb.sv
# SIMFILES = verilog/delay.sv
# SYNFILES = cmul.vg

# HEADERS = verilog/headers.svh
# TESTBENCH = test/dc_top_tb.sv
# SIMFILES = verilog/dc_top.sv verilog/delay_commutator.sv verilog/delay.sv
# SYNFILES = cmul.vg

# HEADERS = verilog/headers.svh
# TESTBENCH = test/butterfly_tb.sv
# SIMFILES = verilog/butterfly.sv 
# SYNFILES = cmul.vg

# HEADERS = verilog/headers.svh
# TESTBENCH = test/fp_mul_tb.sv
# SIMFILES = verilog/fp_mul.sv
# SYNFILES = fp_add.vg

# HEADERS = verilog/headers.svh
# TESTBENCH = test/fp_mul_tb.sv
# SIMFILES = verilog/fp_mul.sv
# SIMFILES = syn/fp_mul.mapped.v

# SYN_TARGET = syn

# HEADERS = verilog/headers.svh
# TESTBENCH = test/fp_add_tb.sv
# SIMFILES = verilog/fp_add.sv
# SYNFILES = fp_add.vg

# HEADERS = verilog/headers.svh
# TESTBENCH = test/delay_tb.sv
# SIMFILES = verilog/delay.sv
# SYNFILES = cmul.vg

# HEADERS = verilog/headers.svh
# TESTBENCH = test/dc_top_tb.sv
# SIMFILES = verilog/dc_top.sv verilog/delay_commutator.sv verilog/delay.sv

# HEADERS = verilog/headers.svh
# TESTBENCH = test/input_reorder_tb.sv
# SIMFILES = verilog/input_reorder.sv

HEADERS = verilog/headers.svh
TESTBENCH = test/fft_8_rad2_tb.sv
SIMFILES = verilog/fft_N_rad2.sv verilog/butterfly.sv  verilog/delay_commutator.sv verilog/delay.sv verilog/deserializer.sv verilog/input_reorder.sv verilog/input_folding.sv
# SYNFILES = src/fft_N_rad2.sv src/butterfly.sv  src/delay_commutator.sv src/delay.sv src/deserializer.sv src/input_reorder.sv

# HEADERS = verilog/headers.svh
# TESTBENCH = test/butterfly_tb.sv
# SIMFILES = verilog/butterfly.sv 

# HEADERS = verilog/headers.svh
# TESTBENCH = test/fp2int_tb.sv
# SIMFILES = verilog/fp2int.sv

# HEADERS = verilog/headers.svh
# TESTBENCH = test/inv_sqrt_tb.sv
# SIMFILES = verilog/inv_sqrt.sv verilog/fp_mul.sv verilog/fp_add.sv verilog/delay_fp.sv 


# HEADERS = verilog/headers.svh
# TESTBENCH = test/deserializer_tb.sv
# SIMFILES = verilog/deserializer.sv

# HEADERS = verilog/headers.svh
# TESTBENCH = test/input_folding_tb.sv
# SIMFILES = verilog/input_folding.sv verilog/delay.sv



#####
# Should be no need to modify after here
#####
# simv:	$(SIMFILES) $(TESTBENCH) $(HEADERS)
# 	$(VCS) $(TESTBENCH) $(SIMFILES) -o simv | tee simv.log

# simv:	$(SIMFILES) $(TESTBENCH) 
# 	$(VCS) $(TESTBENCH) $(SIMFILES) $(LIB) -o simv | tee simv.log

simv:	$(SIMFILES) $(TESTBENCH) 
	$(VCS) $(TESTBENCH) $(SIMFILES) -o simv | tee simv.log


dve:	$(SIMFILES) $(TESTBENCH) 
	$(VCS) $(TESTBENCH) $(SIMFILES) -o dve -R -gui -debug_acccess+all -kdb | tee dve.log

.PHONY: dve

two_bit_pred.vg: tut_mod2.v tut_synth.tcl
	dc_shell-t -f tut_synth.tcl | tee synth.out

syn_simv:	$(SYNFILES) ${SIMFILES} $(TESTBENCH) ${HEADERS}
	$(VCS) $(TESTBENCH) $(SYNFILES) $(LIB) -o syn_simv | tee syn_simv.log

syn: 
	-mkdir -p logs
	dc_shell -f scripts/synth.tcl | tee logs/synth.log
	-mkdir -p temp_files
	-mv alib-52 temp_files/
	-mv *_dclib temp_files/
	-mv command.log temp_files/
	-mv default.svf temp_files/
	-mkdir -p export
	-cp -f memory/db/*_${MK_MEM_SUFFIX}_ccs.db export/ 2>>/dev/null

memgen:
	cd memory; ./memgen.sh

clean:
	rm -rvf simv *.daidir csrc vcs.key program.out \
	syn_simv syn_simv.daidir syn_program.out \
	dve *.vpd *.vcd *.dump ucli.key \
        inter.fsdb novas* verdiLog	

nuke:	clean
	-rm -rvf temp_files
	-rm -rvf alib-52 temp_files/
	-rm -rvf *_dclib temp_files/
	-rm -rvf command.log temp_files/
	-rm -rvf default.svf temp_files/
	-rm -rvf filenames*log 
	-rm -rvf temp_files
	-rm -rvf syn
	
	rm -rvf *.vg *.rep *.db *.chk *.log *.out *.ddc *.svf DVEfiles/

run_all:
	clear
	@echo "Cleaning..."
	@$(MAKE) clean
	@echo "Simulating..."
	@$(MAKE) simv
	@echo "Running simulation..."
	./simv | tee program.out

# TODO: Fix this
gate_sim:
	@echo "Cleaning..."
	@$(MAKE) clean
	@echo "Synthesizing..."
	@$(MAKE) syn
	@echo "Simulating..."
	@$(MAKE) syn_simv
	@echo "Running simulation..."
	./syn_simv | tee syn_program.out