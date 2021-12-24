vcd dumpports /riscv_core_testbench/dut/* -file riscv_core_dumpports.vcd
run $env(SIM_TIME) ns
quit
