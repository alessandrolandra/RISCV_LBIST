#!/bin/bash

vlib work

vlog +define+functional ../syn/techlib/NangateOpenCellLibrary.v
vcom ./constants.vhd
vcom ./COMPONENTS/mux.vhd
vcom ./COMPONENTS/clk_divisor.vhd
vcom ./CONTROLLER/controller.vhd
vcom ./PHSHIFT/xorGrid.vhd
vcom ./LFSR/lfsr.vhd
vcom ./MISR/misr.vhd
vlog ./../syn/output/riscv_core_scan64.v
vcom ./riscv_core_bist.vhd
vcom ./riscv_bist_testbench.vhd


