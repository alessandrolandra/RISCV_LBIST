#!/bin/bash

vlib work

vcom ./constants.vhd
vcom ./COMPONENTS/mux.vhd
vcom ./COMPONENTS/clk_divisor.vhd
vcom ./CONTROLLER/controller.vhd
vlog ./LFSR/lfsr.v
vcom ./MISR/misr.vhd
vlog ./../syn/output/riscv_core_scan64.v
vcom ./riscv_core_bist.vhd
vcom ./riscv_core_testbench.vhd

