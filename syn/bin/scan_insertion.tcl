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

#read_verilog $riscvNetlist
read_ddc ../standalone/riscv_core.ddc
#current_design ../standalone/riscv_core.ddc:$entity
#check_design > check_design.txt
#report_area

create_logic_port -direction in test_mode_tp

compile_ultra -incremental -gate_clock -scan -no_autoungroup
set_dft_configuration -testability enable
set_dft_clock_gating_pin [get_cells * -hierarchical -filter "@ref_name =~ SNPS_CLOCK_GATE*"] -pin_name TE

#set_dft_configuration -scan_compression enable
set test_default_scan_style multiplexed_flip_flop
set_scan_element false NangateOpenCellLibrary/DLH_X1

### Set pins functionality ###
set_dft_signal  -view existing_dft -type ScanEnable -port test_en_i
set_dft_signal  -view spec -type ScanEnable -port test_en_i
#set_dft_signal  -view existing_dft -type wrp_shift -port test_en_i
#set_dft_signal  -view spec -type wrp_shift -port test_en_i
#
#set_dft_signal  -view existing_dft -type ScanClock -port clk_i -timing [list 45 55]
#set_dft_signal  -view spec -type ScanClock -port clk_i 
#set_dft_signal  -view existing_dft -type wrp_clock -port clk_i -timing [list 45 55]
#set_dft_signal  -view spec -type wrp_clock -port clk_i 
#
set_dft_signal -view existing_dft -type Constant -active_state 1 -port test_mode_tp
set_dft_signal -view spec -type TestMode -active_state 1 -port test_mode_tp
#set_dft_signal -view existing_dft -type lbistEnable -port test_mode_tp
#et_dft_signal -view spec -type lbistEnable -port test_mode_tp

#set count 1
#foreach signal [get_ports instr_rdata_i] {
#	if {$count == $chains} { break } 
#	set name [get_attribute $signal full_name]
#	set_dft_signal -view spec -type ScanDataIn -port $name
#	incr count
#}
#
#set count 1
#foreach signal [get_ports apu_master_operands_o] {
#	if {$count == $chains} { break } 
#	set name [get_attribute $signal full_name]
#	set_dft_signal -view spec -type ScanDataOut -port $name
#	set_scan_path "chain$count" -scan_data_in [get_attribute [lindex [get_ports instr_rdata_i] $count] full_name] -scan_data_out [get_attribute [lindex [get_ports instr_rdata_i] $count]]
#	incr count
#}

	



#set_scan_compression_configuration -chain_count $cmp


set_testability_configuration \
   -control_signal test_mode_tp \
   -clock_signal clk_i \

set_testability_configuration -target random_resistant -effort high 
set_testability_configuration -target x_blocking

set_scan_configuration -chain_count $chains

create_test_protocol -infer_asynch -infer_clock
dft_drc
run_test_point_analysis
preview_dft -test_points all > test_points.txt
insert_dft

streaming_dft_planner > streaming.txt

report_scan_path -test_mode all > scan_path.txt

#report_area
write -hierarchy -format verilog -output $outDir$coreNetOut
write_test_protocol -output $outDir$coreStilOut -test_mode Internal_scan

#write_test_protocol -output $outDir$coreStilComOut -test_mode ScanCompression_mode

#quit
