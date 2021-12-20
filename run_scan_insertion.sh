#!/bin/bash

cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

cd ${root_dir}/syn/run

dc_shell -f ../bin/scan_nangate.tcl | tee ../log/scan_nangate.log
mv command.log ../log/command_scan.log
