vcd dumpports /b06_testbench/dut/* -file b06_dumpports.vcd
run 10000000 ns
#run $env(SIM_TIME) ns
quit
