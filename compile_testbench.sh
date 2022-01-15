#!/bin/bash

root_dir=$(pwd)

### GATE LEVEL VERSION #########

vlib work

vlog +define+functional ${root_dir}/syn/techlib/NangateOpenCellLibrary.v
vcom ${root_dir}/bist/constants.vhd
vcom ${root_dir}/bist/COMPONENTS/mux.vhd
vcom ${root_dir}/bist/COMPONENTS/clk_divisor.vhd
vcom ${root_dir}/bist/CONTROLLER/controller.vhd
vcom ${root_dir}/bist/PHSHIFT/xorGrid.vhd
vcom ${root_dir}/bist/LFSR/lfsr.vhd
vcom ${root_dir}/bist/MISR/misr.vhd
vlog ${root_dir}/syn/output/riscv_core_scan64.v
vcom ${root_dir}/bist/riscv_core_bist.vhd
vcom ${root_dir}/bist/riscv_bist_testbench.vhd

vlog -sv +acc=rnbpc -cover t +incdir+${root_dir}/rtl/include  -suppress 2577 -suppress 2583 ${root_dir}/tb/core/fpnew/src/fpnew_pkg.sv \
	${root_dir}/rtl/include/apu_core_package.sv \
	${root_dir}/rtl/include/riscv_defines.sv \
	${root_dir}/rtl/include/riscv_tracer_defines.sv \
	${root_dir}/tb/tb_riscv/include/perturbation_defines.sv \
	${root_dir}/rtl/riscv_if_stage.sv \
	${root_dir}/rtl/riscv_hwloop_controller.sv \
	${root_dir}/rtl/riscv_tracer.sv \
	${root_dir}/rtl/riscv_prefetch_buffer.sv \
	${root_dir}/rtl/riscv_hwloop_regs.sv \
	${root_dir}/rtl/riscv_int_controller.sv \
	${root_dir}/rtl/riscv_cs_registers.sv \
	${root_dir}/rtl/riscv_register_file.sv \
	${root_dir}/rtl/riscv_load_store_unit.sv \
	${root_dir}/rtl/riscv_id_stage.sv \
	${root_dir}/rtl/riscv_core.sv \
	${root_dir}/rtl/riscv_compressed_decoder.sv \
	${root_dir}/rtl/riscv_fetch_fifo.sv \
	${root_dir}/rtl/riscv_alu_div.sv \
	${root_dir}/rtl/riscv_prefetch_L0_buffer.sv \
	${root_dir}/rtl/riscv_decoder.sv \
	${root_dir}/rtl/riscv_mult.sv \
	${root_dir}/rtl/register_file_test_wrap.sv \
	${root_dir}/rtl/riscv_L0_buffer.sv \
	${root_dir}/rtl/riscv_ex_stage.sv \
	${root_dir}/rtl/riscv_alu_basic.sv \
	${root_dir}/rtl/riscv_pmp.sv \
	${root_dir}/rtl/riscv_apu_disp.sv \
	${root_dir}/rtl/riscv_alu.sv \
	${root_dir}/rtl/riscv_controller.sv \
	${root_dir}/tb/tb_riscv/riscv_random_stall.sv \
	${root_dir}/tb/tb_riscv/riscv_random_interrupt_generator.sv \
	${root_dir}/tb/core/riscv_wrapper.sv \
	${root_dir}/tb/core/dp_ram.sv \
	${root_dir}/tb/core/cluster_clock_gating.sv \
	${root_dir}/tb/core/tb_top.sv \
	${root_dir}/tb/core/mm_ram.sv

vopt -debugdb -fsmdebug "+acc=rnbpc" tb_top -o tb_top_vopt