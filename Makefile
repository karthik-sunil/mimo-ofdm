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

# the Verilog Compiler command and arguments
VCS = SW_VCS=2020.12-SP2-1 vcs -sverilog +vc -Mupdate -line -full64 -kdb -nc -xprop=tmerge -lca \
      -debug_access+all+reverse $(VCS_BAD_WARNINGS) +define+
LIB = /afs/umich.edu/class/eecs470/lib/verilog/lec25dscc25.v

all:	simv
	./simv | tee program.out

##### 
# Modify starting here
#####

# HEADERS = verilog/headers.svh
# TESTBENCH = test/delay_commutator_tb.sv
# SIMFILES = verilog/delay_commutator.sv verilog/delay.sv
# SYNFILES = cmul.vg

# HEADERS = verilog/headers.svh
# TESTBENCH = test/dc_top_tb.sv
# SIMFILES = verilog/dc_top.sv verilog/delay_commutator.sv verilog/delay.sv
# SYNFILES = cmul.vg

HEADERS = verilog/headers.svh
TESTBENCH = test/fp_add_tb.sv
SIMFILES = verilog/fp_add.sv
SYNFILES = cmul.vg

# HEADERS = verilog/headers.svh
# TESTBENCH = test/delay_tb.sv
# SIMFILES = verilog/delay.sv
# SYNFILES = cmul.vg



#####
# Should be no need to modify after here
#####
simv:	$(SIMFILES) $(TESTBENCH) $(HEADERS)
	$(VCS) $(TESTBENCH) $(SIMFILES) -o simv | tee simv.log

dve:	$(SIMFILES) $(TESTBENCH) 
	$(VCS) $(TESTBENCH) $(SIMFILES) -o dve -R -gui -debug_acccess+all -kdb | tee dve.log

.PHONY: dve

two_bit_pred.vg: tut_mod2.v tut_synth.tcl
	dc_shell-t -f tut_synth.tcl | tee synth.out

syn_simv:	$(SYNFILES) ${SIMFILES} $(TESTBENCH) ${HEADERS}
	$(VCS) $(TESTBENCH) $(SYNFILES) $(LIB) -o syn_simv | tee syn_simv.log

syn:	syn_simv
	./syn_simv | tee syn_program.out | tee syn.log

clean:
	rm -rvf simv *.daidir csrc vcs.key program.out \
	syn_simv syn_simv.daidir syn_program.out \
	dve *.vpd *.vcd *.dump ucli.key \
        inter.fsdb novas* verdiLog	

nuke:	clean
	rm -rvf *.vg *.rep *.db *.chk *.log *.out *.ddc *.svf DVEfiles/

run_all:
	clear
	@echo "Cleaning..."
	@$(MAKE) clean
	@echo "Simulating..."
	@$(MAKE) simv
	@echo "Running simulation..."
	./simv | tee program.out