#!/bin/bash

# @Brief run scan insertion script on standalone synthesized gate clock netlist
# @See ./syn/bin/scan_insertion.tcl

cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

cd ${root_dir}/syn/run

dc_shell -f ../bin/scan_insertion.tcl | tee ../log/scan_insertion.log
mv command.log ../log/command_scan_insertion.log

#clean run directory
rm -rf *
