# set the maximum signal transition time to 0.1 ns
set_max_transition 0.100 ${DESIGN_NAME}
set_input_transition 0.080 [all_inputs]
set_max_transition 0.080 [all_outputs]

set clock_period 18
set clock_uncertainty [expr $clock_period * 0.025]
set clock_transition 0.080
set clock_latency 0.1

create_clock -name core_clk -period $clock_period [get_ports clk]
set_clock_uncertainty $clock_uncertainty [get_clocks core_clk]
set_clock_transition $clock_transition [get_clocks core_clk]
set_clock_latency $clock_latency [get_clocks core_clk]

#reduced the load capacitance value, giving us faster cells
set_load 0.10 [all_outputs]
set_driving_cell -no_design_rule -lib_cell NBUFFX4_RVT [all_inputs]

# Need to add own constraints for each top module
# Need to test with these added values now
# 0.05 specifies 5 percent of clock period and so on
set_input_delay -max [expr $clock_period * 0.001] [get_ports -filter "direction == in" clk*] -clock core_clk 
set_input_delay -min [expr $clock_period * 0.010] [get_ports -filter "direction == in" reset*] -clock core_clk
set_input_delay -max [expr $clock_period * 0.020] [get_ports -filter "direction == in" enable*] -clock core_clk
set_input_delay -min [expr $clock_period * 0.010] [get_ports -filter "direction == in" data_in_0*] -clock core_clk
set_input_delay -min [expr $clock_period * 0.010] [get_ports -filter "direction == in" data_in_1*] -clock core_clk
set_output_delay -max [expr $clock_period * 0.030] [get_ports -filter "direction == out" fft_out*] -clock core_clk
set_output_delay -min [expr $clock_period * 0.020] [get_ports -filter "direction == out" output_mode*] -clock core_clk
set_output_delay -max [expr $clock_period * 0.025] [get_ports -filter "direction == out" out_valid*] -clock core_clk
# set_output_delay -min [expr $clock_period * 0.015] [get_ports -filter "direction == out" mo*] -clock core_clk

set_false_path -from [get_ports -filter "direction == in" reset]
