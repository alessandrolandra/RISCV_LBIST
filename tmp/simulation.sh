#!/bin/sh

cd ../bist


# Build the files
./compile

# Invoke QuestaSim shell and run the TCL script
vsim -t 1ns -c -novopt work.tb_riscv_core_bist -do ../tmp/simulation_script.tcl

tmax ../tmp/fsim_stuck_script.tcl -shell
