vcd dumpports /riscv_testbench/dut/* -file riscv_core_dumpports.vcd
#run $env(SIM_TIME) ns
run 10000000 ns
quit
