file mkdir fsim_out
read_netlist syn/techlib/NangateOpenCellLibrary.v
read_netlist syn/output/riscv_core_scan64.v
run_build_model riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
add_clocks 0 clk
add_clocks 0 rst
run_drc
set_patterns -external run/riscv_core_dumpports.vcd -sensitive -strobe_period {100 ns} -strobe_offset {40 ns} -vcd_clock auto
run_simulation -sequential
set_delay -launch_cycle system_clock
set_faults -model transition
add_faults -all
run_fault_sim -sequential
set_faults -fault_coverage
report_summaries > fsim_out/fsim_transition.txt
