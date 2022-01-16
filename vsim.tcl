# Copyright 2018 ETH Zurich and University of Bologna.
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# Author: Robert Balas (balasr@student.ethz.ch)
# Description: TCL scripts to facilitate simulations

set NoQuitOnFinish 1

if { $env(RUN_GUI) == 1 } {
	#source $env(TB_DIR)/software.tcl

	if { $env(RUN_GATE) == 1 } {
		source $env(TB_DIR)/waves_gate.tcl
	} {
		log -r *
		source $env(TB_DIR)/software.tcl
		source $env(TB_DIR)/waves.tcl
	}
}

if { $env(RUN_GATE) == 1 } {
	vcd dumpports -file dumpports_gate.evcd sim:/tb_top/riscv_wrapper_i/riscv_core_bist_i/riscvi/*
}

run -all

if { $env(RUN_GUI) != 1 } {
	quit
}
