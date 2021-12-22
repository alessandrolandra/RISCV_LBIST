#!/bin/sh

# Move to the run directory
mkdir -p run
cd run

# Build the files
vcom -2008 -suppress 1141 ../pdt2002_sim.vhd 
vlog ../riscv_core_scan64.v 
vlog ../lfsr.v
vcom -2008 -suppress 1141 ../riscv_core_testbench.vhd 

# Invoke QuestaSim shell and run the TCL script

vsim -c -novopt work.riscv_core_testbench -do ../simulation_script.tcl -wlf riscv_core_sim.wlf
cd ..
tmax fsim_stuck_script.tcl -shell
#tmax fsim_transition_script.tcl -shell
