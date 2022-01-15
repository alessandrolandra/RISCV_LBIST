#!/bin/bash

cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

run_dir=${root_dir}/run

rm -rvf ${run_dir}

cd ${root_dir}/sbst
make clean


