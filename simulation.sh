#!/bin/sh

# Move to the run directory
mkdir -p run
cd run

# Build the files
vcom -2008 -suppress 1141 ../pdt2002_sim.vhd 
vlog ../b06_scan.v 
vlog ../lfsr.v
vcom -2008 -suppress 1141 ../b06_testbench.vhd 

# Invoke QuestaSim shell and run the TCL script

#for i in 500 1000 2000 10000 20000 50000 100000 1000000 10000000
#do
#	export SIM_TIME=$i
	vsim -c -novopt work.b06_testbench -do ../b06_simulation_script.tcl  -wlf b06_sim.wlf
	cd ..
	tmax b06_fsim_script.tcl -shell
	cd run
#done
