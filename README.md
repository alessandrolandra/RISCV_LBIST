#   RISCV_LBIST
HW assignment of Testing and Fault Tolerance course, BIST module for RiscV core.<br>
##  Dirs
[**bist folder**](./bist/)<br>
[core rtl](./rtl/)<br>
[synthesis scripts](./syn/)<br>
[core rtl tbs](./tb/)<br>
[tmp scripts](./tmp/)<br>
##  Usage

[scan chains insertion script](./run_scan_insertion.sh) starting from *synthesized netlist* insert scan chains and generate a [dft netlist](./syn/output/riscv_core_scan64.v) and the relative [STIL procedure](./syn/output/riscv_core_scan64.spf) (for *TMAX script*)<br>
[synthesis script](./run_syn.sh)<br>
[TMAX script](./syn/tmax_analysis.tcl) for fault testing purposes.<br>

### Project description

The purpose of this project is to design a Logic-BIST for testing a RISCV core trough the adoption of some testing techniques presented during the course (Here is presented an example of the Test-per-scan technique, with some differences) and usage of industrial tools (TetraMax, Modelsim, DesignCompiler).
The constraints in terms of test coverage, are at least 70% of coverage for the Stuck-At fault model <br>


### Further information

[REPORT](./assignment_report.pdf) <br>
