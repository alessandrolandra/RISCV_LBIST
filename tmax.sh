#!/bin/sh

#@Brief run tmax script in tmax -shell evironment
#@Note the tmax script is run in the ./syn/run directory


cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

cd ${root_dir}/syn/run

# Invoke TetraMAX and run the TCL script, see log file into ./syn/log dir
tmax  ../tmax_analysis.tcl -shell | tee ../log/tmax_log.log 
