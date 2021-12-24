set ROOT_PATH                    ../..
set RISCV_PATH              	$ROOT_PATH
set FPUNEW                      $ROOT_PATH/tb/core/fpnew
set GATE_PATH			../standalone
set LOG_PATH			../log

set TECH NangateOpenCell


set search_path [ join "$RISCV_PATH/rtl/include $search_path" ]
set search_path [ join "/data/libraries/LIB065 $search_path" ]
set search_path [ join "/data/libraries/NangateOpenCellLibrary_PDKv1_3_v2010_12/fix_scan $search_path" ]
set search_path [ join "/data/libraries/pdt2002 $search_path" ]
set search_path [ join "../techlib/ $search_path" ]
#set search_path [ join "[getenv 'SYNOPSYS'] $search_path" ]

set synthetic_library dw_foundation.sldb
source ../bin/$TECH.dc_setup_synthesis.tcl

## if you want to use clock gating
#set_clock_gating_style -sequential_cell latch -positive_edge_logic {and} -negative_edge_logic {or} -control_point before -control_signal scan_enable

analyze -format sverilog  -work work ${FPUNEW}/src/fpnew_pkg.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/include/apu_core_package.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/include/riscv_defines.sv
#analyze -format sverilog  -work work ${RISCV_PATH}/rtl/include/riscv_tracer_defines.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/include/apu_macros.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/include/riscv_config.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_alu.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_alu_basic.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_alu_div.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_apu_disp.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_compressed_decoder.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_controller.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_cs_registers.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_core.sv
#analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_debug_unit.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_decoder.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_int_controller.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_ex_stage.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_hwloop_controller.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_hwloop_regs.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_id_stage.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_if_stage.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_load_store_unit.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_mult.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_prefetch_buffer.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_prefetch_L0_buffer.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_fetch_fifo.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_L0_buffer.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_pmp.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_register_file.sv
#analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_register_file_latch.sv
analyze -format sverilog  -work work ${RISCV_PATH}/rtl/register_file_test_wrap.sv
#analyze -format sverilog  -work work ${RISCV_PATH}/rtl/riscv_tracer.sv
analyze -format sverilog  -work work cluster_clock_gating_nangate.sv

#PARAMETERS
set  N_EXT_PERF_COUNTERS   0
set  INSTR_RDATA_WIDTH    128
set  PULP_SECURE           1
set  N_PMP_ENTRIES        16
set  USE_PMP               1
set  PULP_CLUSTER          1
set  FPU                   0
set  Zfinx                 0
set  FP_DIVSQRT            0
set  SHARED_FP             0
set  SHARED_DSP_MULT       0
set  SHARED_INT_MULT       0
set  SHARED_INT_DIV        0
set  SHARED_FP_DIVSQRT     0
set  WAPUTYPE              0
set  APU_NARGS_CPU         3
set  APU_WOP_CPU           6
set  APU_NDSFLAGS_CPU     15
set  APU_NUSFLAGS_CPU      5
set  DM_HaltAddress       32'h1A110800
#set  N_HWLP                 2
#set  N_HWLP_BITS            1
#set  APU                    0

set TOPLEVEL		riscv_core

set PARAMETERS "N_EXT_PERF_COUNTERS=${N_EXT_PERF_COUNTERS}, INSTR_RDATA_WIDTH=${INSTR_RDATA_WIDTH}, PULP_SECURE=${PULP_SECURE}, N_PMP_ENTRIES=${N_PMP_ENTRIES}, USE_PMP=${USE_PMP}, PULP_CLUSTER=${PULP_CLUSTER}, FPU=${FPU}, Zfinx=${Zfinx}, FP_DIVSQRT=${FP_DIVSQRT}, SHARED_FP=${SHARED_FP}, SHARED_DSP_MULT=${SHARED_DSP_MULT}, SHARED_INT_MULT=${SHARED_INT_MULT}, SHARED_INT_DIV=${SHARED_INT_DIV}, SHARED_FP_DIVSQRT=${SHARED_FP_DIVSQRT}, WAPUTYPE=${WAPUTYPE}, APU_NARGS_CPU=${APU_NARGS_CPU}, APU_WOP_CPU=${APU_WOP_CPU}, APU_NDSFLAGS_CPU=${APU_NDSFLAGS_CPU}, APU_NUSFLAGS_CPU=${APU_NUSFLAGS_CPU}, DM_HaltAddress=${DM_HaltAddress}"

elaborate $TOPLEVEL -work work -parameters $PARAMETERS

link
uniquify
check_design 

set_multicycle_path 2 -setup -through [get_pins id_stage_i/registers_i/riscv_register_file_i/mem_reg*/Q]
set_multicycle_path 1 -hold  -through [get_pins id_stage_i/registers_i/riscv_register_file_i/mem_reg*/Q]

set CLOCK_SPEED 2
create_clock      [get_ports clk_i] -period $CLOCK_SPEED -name REF_CLK
set_ideal_network [get_ports clk_i]

set core_outputs [all_outputs]
set core_inputs  [remove_from_collection [all_inputs] [get_ports clk_i]]
set core_inputs  [remove_from_collection $core_inputs [get_ports rst_ni]]

set INPUT_DELAY  [expr 0.4*$CLOCK_SPEED]
set OUTPUT_DELAY [expr 0.4*$CLOCK_SPEED]

set_input_delay  $INPUT_DELAY  $core_inputs  -clock [get_clock]
set_output_delay $OUTPUT_DELAY [all_outputs] -clock [get_clock]

set_ideal_network       -no_propagate    [all_connected  [get_ports rst_ni]]
set_ideal_network       -no_propagate    [get_nets rst_ni]
set_dont_touch_network  -no_propagate    [get_ports rst_ni]
set_multicycle_path 2   -from            [get_ports   rst_ni]

# If you want to set some pins to a fixed value
#set_case_analysis   0                    [get_ports test_en_i]
#set_case_analysis   1                    [get_ports clock_en_i]

set_operating_conditions $OPER_COND

#compile_ultra -gate_clock -no_autoungroup
compile_ultra -no_autoungroup
change_names -hierarchy -rules verilog
write -hierarchy -format verilog -output "${GATE_PATH}/${TOPLEVEL}.v"
write -hierarchy -format ddc -output "${GATE_PATH}/${TOPLEVEL}.ddc"
#write_sdf -version 3.0 "${GATE_PATH}/${TOPLEVEL}.sdf"
write_sdc "${GATE_PATH}/${TOPLEVEL}.sdc"
#write_test_protocol -output "${GATE_PATH}/${TOPLEVEL}.spf"
write_tmax_library -path "${GATE_PATH}"
quit
