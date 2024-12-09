#####################################################
#Read design data & technology
#####################################################

set CURRENT_PATH [pwd]
set TOP_DESIGN fft_N_rad2

set search_path [list \
					"$CURRENT_PATH" \
				]

## Add libraries below
## technology .db file, and memory .db files
set target_library "/afs/umich.edu/class/eecs598-002/SAED32/SAED32_EDK/lib/pll/db_ccs/saed32rvt_tt1p05v25c.db"

set LINK_PATH [concat  "*" $target_library]

## Replace with your complete file paths
set SDC_FILE      	$CURRENT_PATH/$TOP_DESIGN.mapped.sdc
set NETLIST_FILE	$CURRENT_PATH/$TOP_DESIGN.mapped.v

## Replace with your instance hierarchy
set STRIP_PATH    ../test/fft_N_rad2_tb.dut

## Replace with your activity file dumped from vcs simulation
set ACTIVITY_FILE 	$CURRENT_PATH/fft_N_rad2_tb.vcd

######## Timing Sections ########
set	START_TIME 50.0
set	END_TIME 1800.0
