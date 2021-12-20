#!/bin/bash

cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

cd ${root_dir}/syn/run


dc_shell -f ../bin/syn_nangate.tcl | tee ../log/syn_nangate.log
mv command.log ../log
