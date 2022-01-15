# @Brief tmax script for atpg testing
# @Note this is a tmax script, netlist and stil files are in the ./output directory
# @Warning change the coreNet, according to the nerlist name that y want to analyze
# @Warning, this script is run in the ./run directory, paths are relative to the ./run directory!, do not change them

set library  "../techlib/NangateOpenCellLibrary.v"
set coreNet  "../output/riscv_core_scan64.v"
set entity   "riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800"
set coreStil "../output/riscv_core_scan64.spf"
#output atgp patterns
set outPatterns "../output/atpg_stuck_at_patterns.spf"

read_netlist  $library -library -define functional
read_netlist  $coreNet -master
run_build_model $entity

run_drc $coreStil
report_scan_chains > ../log/SCAN_CHAINS_REPORT.txt
report_nonscan_cells -summary > ../log/NON_SCAN_CELLS_REPORT.txt
report_primitives -summary > ../log/PRIMITIVES_REPORT.txt

set_faults -model stuck
add_faults -all
write_faults "../log/STUCK_LIST_UNCOLLAPSED.txt" -all -replace -uncollapsed

set_patterns -internal

set_atpg -full_seq_atpg
#fast sequential limit (higher = more effort)
set_atpg -abort_limit 200
#full sequential limit (higher = more effort)
set_atpg -full_seq_abort_limit 50
run_atpg -auto_compression
set_faults -summary verbose -fault_coverage
report_summaries > ../log/STUCK_AT_COVERAGE.txt
report_patterns -all > ../log/STUCK_AT_PATTERNS.txt
write_patterns $outPatterns -format stil

#quit
