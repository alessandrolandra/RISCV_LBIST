file mkdir fsim_out

#read netlists and libraries
read_netlist syn/techlib/NangateOpenCellLibrary.v
read_netlist syn/output/riscv_core_scan64.v
run_build_model riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800

#read compressed scan chain
run_drc ./syn/output/riscv_core_scan64_cmp320.spf
set_patterns -external ./syn/output/atpg_gen_patt.spf

#run fault simulation with external atpg patterns
run_simulation
set_faults -model stuck
add_faults -all
run_fault_sim
set_faults -fault_coverage

#report detected faults
report_faults -class { DS }
write_faults ./fsim_out/stuck_at_DS_atpg.txt

#remove simulated faults
read_faults ./fsim_out/stuck_at_DS_atpg.txt -delete

##LFSR PATTERNs CYCLE1

#read LFSR's
drc
set_patterns -external run/riscv_core_dumpports.vcd -sensitive -strobe_period {100 ns} -strobe_offset {40 ns} -vcd_clock auto

#run fault simulation
run_simulation -sequential
set_faults -model stuck
add_faults -all
run_fault_sim -sequential
set_faults -fault_coverage

#report detected faults
report_faults -class { DS }
write_faults ./fsim_out/stuck_at_DS_lfsr_P1.txt

#remove simulated faults
read_faults ./fsim_out/stuck_at_DS_atpg.txt -delete

##LFSR PATTERNs CYCLE2 RE-SEEDING 
##...
