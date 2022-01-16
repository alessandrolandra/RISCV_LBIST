#!/bin/bash

# @Brief run bist synthesis scripts, final netlist will include riscv core with DFT
# @See ./syb/bin/bist_integrated_syn.tcl
# @Warning this script is synthesizing also the bist (see components list in ./bist/compile.sh)

cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

cd ${root_dir}/syn/run


dc_shell -f ../bin/bist_integrated_syn.tcl | tee ../log/bist_integrated_syn.log
mv command.log ../log/command_bist_integrated_syn.log
rm -rf *
