set GATE_PATH			../output
set LOG_PATH			../log

set TECH 			NangateOpenCell
set TOPLEVEL			riscv_core

set search_path [ join "../techlib/ $search_path" ]
set search_path [ join "$GATE_PATH $search_path" ]

source ../bin/$TECH.dc_setup_scan.tcl


read_ddc $TOPLEVEL.ddc
#link
#check_design
compile_ultra -incremental -gate_clock -scan -no_autoungroup


set_dft_clock_gating_pin [get_cells * -hierarchical -filter "@ref_name =~ SNPS_CLOCK_GATE*"] -pin_name TE


report_area
set_dft_configuration -scan_compression enable

set test_default_scan_style multiplexed_flip_flop

### Set pins functionality ###
set_dft_signal  -view existing_dft -type ScanEnable -port test_en_i
set_dft_signal  -view spec -type ScanEnable -port test_en_i 


set_scan_element false NangateOpenCellLibrary/DLH_X1


set_scan_configuration -chain_count 1
#set_scan_compression_configuration -chain_count 10


create_test_protocol -infer_asynch -infer_clock
dft_drc
preview_dft
insert_dft

streaming_dft_planner

change_names -rules verilog -hierarchy

report_scan_path -test_mode all

report_area

write -hierarchy -format verilog -output "${GATE_PATH}/${TOPLEVEL}_scan.v"
write_sdf -version 3.0 "${GATE_PATH}/${TOPLEVEL}_scan.sdf"
write_sdc "${GATE_PATH}/${TOPLEVEL}_scan.sdc"
write_test_protocol -output "${GATE_PATH}/${TOPLEVEL}_scan.spf" -test_mode Internal_scan
write_test_protocol -output "${GATE_PATH}/${TOPLEVEL}_scancompress.spf" -test_mode ScanCompression_mode

#quit
