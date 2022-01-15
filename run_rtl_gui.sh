#!/bin/bash

root_dir=${PWD}

program=${root_dir}/sbst/sbst.hex

run_dir=${root_dir}/run
export TB_DIR=${root_dir}/tb/core

#if [ $# -ne 1 ]; then
#   echo "Usage: $0 path/to/file.hex" >&2
#   exit 1
#fi

if [ ! -e "${program}" ]; then
   echo "Error: ${program} not found." >&2
   exit 1
fi


export RUN_GUI=1
export RUN_GATE=0


./compile_testbench.sh

#cd ${run_dir}

#vsim -gui -t ns -novopt work.riscv_bist_testbench -do dumport_generate.tcl
#quit

#the following has been delayed
vsim -gui -t ns tb_top_vopt "+firmware=${program}" -suppress 3009 +dumpports+nocollapse -do ${root_dir}/vsim.tcl
run 6061250 ns
run 10000 ns
