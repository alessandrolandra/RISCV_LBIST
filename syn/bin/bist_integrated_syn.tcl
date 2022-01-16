
source ../bin/NangateOpenCell.dc_setup_scan.tcl

set bist "../../bist"
analyze -library work -format vhdl $bist/constants.vhd
analyze -library work -format vhdl $bist/COMPONENTS/mux.vhd
analyze -library work -format vhdl $bist/CONTROLLER/controller.vhd
analyze -library work -format vhdl $bist/PHSHIFT/xorGrid.vhd
analyze -library work -format vhdl $bist/LFSR/lfsr.vhd
analyze -library work -format vhdl $bist/MISR/misr.vhd
analyze -library work -format verilog ../output/riscv_core_scan64.v
analyze -library work -format vhdl $bist/riscv_core_bist.vhd

elaborate riscv_core_bist -library work

#same clock speed used in preliminary synthesis of the standalone riscv core

create_clock      [get_ports clk] -period 2 -name REF_CLK
set_ideal_network [get_ports clk]

set outputs [all_outputs]
set inputs  [remove_from_collection [all_inputs] [get_ports clk]]
set inputs  [remove_from_collection $inputs [get_ports rst]]

set INPUT_DELAY  [expr 0.4*2]
set OUTPUT_DELAY [expr 0.4*2]

set_input_delay  $INPUT_DELAY  $inputs  -clock [get_clock]
set_output_delay $OUTPUT_DELAY $outputs -clock [get_clock]

compile_ultra -incremental
report_area > $bist/syn/RISCV_BIST_INTEGRATED_AREA.txt
write -hierarchy -format verilog -output $bist/syn/RISCV_BIST_INTEGRATED_SYN.v

