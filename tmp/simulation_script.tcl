vcd dumpports /riscv_testbench/dut/* -file riscv_core_dumpports.vcd
#run $env(SIM_TIME) ns
run 1000 ns
quit
