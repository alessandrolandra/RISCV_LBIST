#simulation parameters
##change the number of patterns also in the testbench
set period 10
set patterns 1000

add wave *
run [expr ($period * 2 * $patterns)]
