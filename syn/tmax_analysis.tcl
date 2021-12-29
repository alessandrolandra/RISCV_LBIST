# @Brief tmax script for atpg testing
# @Note this is a tmax script, netlist and stil files are in the ./output directory
# @Warning change the coreNet, according to the nerlist name that y want to analyze
# @Warning, this script is run in the ./run directory, paths are relative to the ./run directory!, do not change them

set library  "../techlib/NangateOpenCellLibrary.v"
# netlist
set coreNet  "../output/riscv_core_scan64.v"
set entity   "riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800"
# stil file (compressor: riscv_core_scanXX_cmpYY.spf) (normal: riscv_core_scanXX
set coreStil "../output/riscv_core_scan64_cmp320.spf"
#set coreStil "../output/riscv_core_scan64.spf"
#output atgp patterns
set outPatterns "../output/atpg_gen_patt.spf"

read_netlist  $library -library -insensitive
read_netlist  $coreNet -master -insensitive
run_build_model $entity

	### DRC
	;# before running DRC:
	;# constrain PI (if needed)
	;# mask PO (if needed)

run_drc $coreStil
report_scan_chains
report_scan_cells 1
report_nonscan_cells -summary
report_primitives -summary	;# reports the list of elements present in the circuit
#drc -force ;# brings back from TEST to DRC
	### TEST

set_faults -model stuck
add_faults -all
#write_faults "../output/fault_list_uncollapsed.txt" -all -replace -uncollapsed
#remove_faults -all

	;# external -> simulation 
	;# internal -> ATPG
	;# add -sequential option if the circuit is sequential

set_patterns -internal
#set_patterns -delete
#report_patterns -internal -all

	### ATPG

#set_atpg -full_seq_atpg
#fast sequential limit (higher = more effort)
set_atpg -abort_limit 200
#full sequential limit (higher = more effort)
set_atpg -full_seq_abort_limit 50
run_atpg -auto_compression
set_faults -summary verbose -fault_coverage
report_summaries
#report_patterns -all
write_patterns $outPatterns -replace -format stil -first 0 -last 9 

#quit
