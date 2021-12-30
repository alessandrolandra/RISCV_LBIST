#simulation parameters
##change the number of patterns also in the testbench
set period 10
set patterns 50000

add wave *

vcd dumpports /lfsr_testbench/uut_lfsr1/* -file ./patterns_out/LFSR_dumpports_p1.vcd
run [expr ($period * 2 * $patterns)]
quit
