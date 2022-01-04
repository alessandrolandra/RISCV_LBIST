
#read netlists and libraries
read_netlist ../syn/techlib/NangateOpenCellLibrary.v
read_netlist ../syn/output/riscv_core_scan12.v
run_build_model riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800

#read compressed scan chain
run_drc ../syn/output/riscv_core_scan12_cmp480.spf
set_patterns -external ../syn/output/atpg_gen_patt.spf

#run fault simulation with external atpg patterns
run_simulation
set_faults -model stuck
add_faults -all
run_fault_sim
set_faults -fault_coverage

#report detected faults
#report_faults -class { DS }
##write_faults ./fsim_out/stuck_at_DS_atpg.txt -class { DS }

#remove simulated faults
##read_faults ./fsim_out/stuck_at_DS_atpg.txt -delete

##EXTERNAL PATTERNs
drc
run_drc
set_patterns -external ./core_dumpports.vcd -sensitive -strobe_period {200 ns} -strobe_offset {0 ns} -vcd_clock auto

#run fault simulation
run_simulation
set_faults -model stuck
add_faults -all
run_fault_sim
set_faults -fault_coverage

#report detected faults
#report_faults -class { DS }
##write_faults ./fsim_out/stuck_at_DS_lfsr_P1.txt -class { DS }

#remove simulated faults
##read_faults ./fsim_out/stuck_at_DS_atpg.txt -delete
