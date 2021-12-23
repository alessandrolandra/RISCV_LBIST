set GATE_PATH			../standalone
set LOG_PATH			../log

set TECH 			NangateOpenCell
set TOPLEVEL			riscv_core

set search_path [ join "../techlib/ $search_path" ]
set search_path [ join "$GATE_PATH $search_path" ]

source ../bin/$TECH.dc_setup_scan.tcl


read_ddc ../standalone/$TOPLEVEL.ddc
#link
#check_design
compile_ultra -incremental -gate_clock -scan -no_autoungroup

change_names -rules verilog -hierarchy

write -hierarchy -format verilog -output "${GATE_PATH}/${TOPLEVEL}_gating.v"
#write_sdf -version 3.0 "${GATE_PATH}/${TOPLEVEL}_gating.sdf"
write_sdc "${GATE_PATH}/${TOPLEVEL}_gating.sdc"

quit
