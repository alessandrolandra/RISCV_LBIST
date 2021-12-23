#!/bin/bash

# @Brief run synthesis scripts, final netlist will include clock gating scan cells
# @See ./syb/bin/syn_nangate.tcl
# @See ./syn/bin/syn_gate_nangate.tcl
# @Warning if there are already sythesized netlists in ./syn/standalone, do not run this script again!!

cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

cd ${root_dir}/syn/run


dc_shell -f ../bin/syn_nangate.tcl | tee ../log/syn_nangate.log
mv command.log ../log/command_syn_nandgate.log
#gating
dc_shell -f ../bin/syn_gate_nangate.tcl | tee ../log/syn_gate_nangate.log
mv command.log ../log/command_syn_gate_nangate.log

#clean run directory
rm -rf *
