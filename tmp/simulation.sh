#!/bin/sh

if [ $# -ne 4 ]; then
    echo -e "2 arguments needed; specify:\n-m: fsim mode (stuck at fault (0) or transition fault (1))\n-t: simulation time in ns"
    exit 1
fi

mkdir -p ../run
cd ../run

# Build the files

vlib work

vlog +define+functional ../syn/techlib/NangateOpenCellLibrary.v
vcom ../bist/constants.vhd
#vcom ../bist/COMPONENTS/mux.vhd
#vcom ../bist/COMPONENTS/clk_divisor.vhd
vcom ../bist/LFSR/lfsr.vhd
vcom ../bist/PHSHIFT/xorGrid.vhd
vlog ../syn/output/riscv_core_scan64.v
#vcom ../bist/MISR/misr.vhd
#vcom ../bist/riscv_core_bist.vhd
vcom ../bist/riscv_core_testbench.vhd

# Invoke QuestaSim shell and run the TCL script
vsim -t 1ps -c -novopt work.riscv_testbench -do ../tmp/simulation_script.tcl -wlf riscv_core_sim.wlf
cd ..

while getopts "mt" opt; do
    case $opt in      
      m)
		#if [ $OPTARG -eq 0 ]; then
		if [ $2 -eq 0 ]; then
			p=fsim_stuck_script.tcl
		else
			p=fsim_transition_script.tcl
		fi
        ;;
      t)        
		#export SIM_TIME=$OPTARG
		#export SIM_TIME=$4
        ;;
      \?)
        ;;
    esac
done
  
#export SIM_TIME=1000000
tmax tmp/$p -shell
