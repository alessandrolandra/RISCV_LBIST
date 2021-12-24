# @Brief scan insertion script
# @Note  original risc-v synthesized netlist is needed or the clock gated one
# @Note clock gating netlist is used
# @Warning this script is executed inside the ../run/ directory, do not change the relative paths!

# setup script
set setupScript "../bin/NangateOpenCell.dc_setup_scan.tcl"
# original netlist wo scan chains
set riscvNetlist "../standalone/riscv_core_gating.v"
# original netlist's entity
set entity "riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800"
# scan chain count
set chains 64
# scan compressed chains count (cmp cannot be < $chains)
set cmp [expr $chains*3]
# output netlist name
set coreNetOut "riscv_core_scan$chains.v"
# output stil file name
set coreStilOut "riscv_core_scan$chains.spf"
# output compressor stil file name
set coreStilComOut "riscv_core_scan${chains}_cmp$cmp.spf"
# output directory
set outDir "../output/"

source $setupScript

if {![file exists $outDir]} {
	file mkdir $outDir
}

read_verilog $riscvNetlist
current_design $entity
check_design
report_area

set_dft_clock_gating_pin [get_cells * -hierarchical -filter "@ref_name =~ SNPS_CLOCK_GATE*"] -pin_name TE
#set_dft_configuration -scan_compression enable
set test_default_scan_style multiplexed_flip_flop

### Set pins functionality ###
set_dft_signal  -view existing_dft -type ScanEnable -port test_en_i
set_dft_signal  -view spec -type ScanEnable -port test_en_i 
set_scan_element false NangateOpenCellLibrary/DLH_X1

set_scan_configuration -chain_count $chains
#set_scan_compression_configuration -chain_count $cmp


create_test_protocol -infer_asynch -infer_clock
dft_drc
#preview_dft
insert_dft

#streaming_dft_planner



report_scan_path -test_mode all

report_area
write -hierarchy -format verilog -output $outDir$coreNetOut
write_test_protocol -output $outDir$coreStilOut -test_mode Internal_scan
#write_test_protocol -output $outDir$coreStilComOut -test_mode ScanCompression_mode

#quit
