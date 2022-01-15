# @Brief scan insertion script
# @Note  original risc-v synthesized netlist is needed or the clock gated one
# @Note clock gating netlist is used
# @Warning this script is executed inside the ../run/ directory, do not change the relative paths!

# setup script
set setupScript "../bin/NangateOpenCell.dc_setup_scan.tcl"
# original netlist wo scan chains
set riscvNetlist "../standalone/riscv_core.v"
# original netlist's entity
set entity "riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800"
# scan chain count
set chains 64
# output netlist name
set coreNetOut "riscv_core_scan$chains.v"
# output stil file name
set coreStilOut "riscv_core_scan$chains.spf"
# output directory
set outDir "../output/"

source $setupScript

if {![file exists $outDir]} {
	file mkdir $outDir
}

read_ddc ../standalone/riscv_core.ddc
report_area > ../log/AREA_ORIGINAL.txt

##test point insertion
create_logic_port -direction in test_mode_tp

compile_ultra -incremental -gate_clock -scan -no_autoungroup
set_dft_configuration -testability enable
set_dft_clock_gating_pin [get_cells * -hierarchical -filter "@ref_name =~ SNPS_CLOCK_GATE*"] -pin_name TE

set test_default_scan_style multiplexed_flip_flop
set_scan_element false NangateOpenCellLibrary/DLH_X1

### Set pins functionality ###
set_dft_signal  -view existing_dft -type ScanEnable -port test_en_i
set_dft_signal  -view spec -type ScanEnable -port test_en_i

##test point pins
set_dft_signal -view existing_dft -type Constant -active_state 1 -port test_mode_tp
set_dft_signal -view spec -type TestMode -active_state 1 -port test_mode_tp


##scan-in scan-out pins in shared mode with PIs and POs
set sdis [list]
set count 1
foreach_in_collection signal [get_ports instr_rdata_i] {
	if {$count == $chains+1} { break } 
	set name [get_attribute $signal full_name]
	set_dft_signal -view spec -type ScanDataIn -port $name
	incr count
	lappend sdis $name
}

set count 1
foreach_in_collection signal [get_ports apu_master_operands_o] {
	if {$count == $chains+1} { break } 
	set name [get_attribute $signal full_name]
	set_dft_signal -view spec -type ScanDataOut -port $name
	set_scan_path "chain$count" -scan_data_in [lindex $sdis $count-1] -scan_data_out $name
	incr count
}

##testability configurations
set_testability_configuration -control_signal test_mode_tp -clock_signal clk_i
set_testability_configuration -target random_resistant -effort high 
set_testability_configuration -target x_blocking

##scan chains insertion
set_scan_configuration -chain_count $chains

##test protocol
create_test_protocol -infer_asynch -infer_clock
dft_drc -coverage_estimate

##test point analisi
run_test_point_analysis
preview_dft -test_points all

##dft insertion
insert_dft


##report
change_names -rules verilog -hierarchy
streaming_dft_planner
report_scan_path -test_mode all > ../log/SCAN_PATH.txt
report_area > ../log/AREA_DFT.txt
write -hierarchy -format verilog -output $outDir$coreNetOut
write_test_protocol -output $outDir$coreStilOut -test_mode Internal_scan
quit
