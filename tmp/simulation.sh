#!/bin/sh

mkdir -p ../run
cd ../run

# Build the files

vlib work

vlog +define+functional ../syn/techlib/NangateOpenCellLibrary.v
vcom ../bist/constants.vhd
vcom ../bist/COMPONENTS/mux.vhd
vcom ../bist/COMPONENTS/clk_divisor.vhd
vcom ../bist/CONTROLLER/controller.vhd
vcom ../bist/LFSR/lfsr.vhd
vcom ../bist/PHSHIFT/xorGrid.vhd
vlog ../syn/output/riscv_core_scan64.v
vcom ../bist/MISR/misr.vhd
vcom ../bist/riscv_core_testbench.vhd

# Invoke QuestaSim shell and run the TCL script
vsim -t 1ps -c -novopt work.riscv_testbench -do ../tmp/simulation_script.tcl
cd ..

tmax tmp/fsim_stuck_script.tcl -shell
