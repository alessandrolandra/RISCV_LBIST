file mkdir fsim_out
read_netlist syn/techlib/NangateOpenCellLibrary.v -library -define functional
read_netlist syn/output/riscv_core_scan64.v -master
run_build_model riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800

add_pi_constraints X -all
remove_pi_constraints clk_i
remove_pi_constraints clock_en_i
remove_pi_constraints rst_ni
remove_pi_constraints test_mode_tp
remove_pi_constraints test_en_i


remove_pi_constraints instr_rdata_i[64]  
remove_pi_constraints instr_rdata_i[65] 
remove_pi_constraints instr_rdata_i[66]  
remove_pi_constraints instr_rdata_i[67]  
remove_pi_constraints instr_rdata_i[68] 
remove_pi_constraints instr_rdata_i[69]  
remove_pi_constraints instr_rdata_i[70]  
remove_pi_constraints instr_rdata_i[71] 
remove_pi_constraints instr_rdata_i[72]  
remove_pi_constraints instr_rdata_i[73]  
remove_pi_constraints instr_rdata_i[74] 
remove_pi_constraints instr_rdata_i[75]  
remove_pi_constraints instr_rdata_i[76]  
remove_pi_constraints instr_rdata_i[77] 
remove_pi_constraints instr_rdata_i[78]  
remove_pi_constraints instr_rdata_i[79]  
remove_pi_constraints instr_rdata_i[80] 
remove_pi_constraints instr_rdata_i[81]  
remove_pi_constraints instr_rdata_i[82]  
remove_pi_constraints instr_rdata_i[83] 
remove_pi_constraints instr_rdata_i[84]  
remove_pi_constraints instr_rdata_i[85]  
remove_pi_constraints instr_rdata_i[86] 
remove_pi_constraints instr_rdata_i[87]  
remove_pi_constraints instr_rdata_i[88]  
remove_pi_constraints instr_rdata_i[89] 
remove_pi_constraints instr_rdata_i[90]  
remove_pi_constraints instr_rdata_i[91]  
remove_pi_constraints instr_rdata_i[92] 
remove_pi_constraints instr_rdata_i[93]  
remove_pi_constraints instr_rdata_i[94]  
remove_pi_constraints instr_rdata_i[95] 
remove_pi_constraints instr_rdata_i[96]  
remove_pi_constraints instr_rdata_i[97]  
remove_pi_constraints instr_rdata_i[98] 
remove_pi_constraints instr_rdata_i[99]
remove_pi_constraints instr_rdata_i[100] 
remove_pi_constraints instr_rdata_i[101] 
remove_pi_constraints instr_rdata_i[102] 
remove_pi_constraints instr_rdata_i[103] 
remove_pi_constraints instr_rdata_i[104] 
remove_pi_constraints instr_rdata_i[105] 
remove_pi_constraints instr_rdata_i[106] 
remove_pi_constraints instr_rdata_i[107] 
remove_pi_constraints instr_rdata_i[108] 
remove_pi_constraints instr_rdata_i[109] 
remove_pi_constraints instr_rdata_i[110] 
remove_pi_constraints instr_rdata_i[111] 
remove_pi_constraints instr_rdata_i[112] 
remove_pi_constraints instr_rdata_i[113] 
remove_pi_constraints instr_rdata_i[114] 
remove_pi_constraints instr_rdata_i[115] 
remove_pi_constraints instr_rdata_i[116] 
remove_pi_constraints instr_rdata_i[117] 
remove_pi_constraints instr_rdata_i[118] 
remove_pi_constraints instr_rdata_i[119] 
remove_pi_constraints instr_rdata_i[120] 
remove_pi_constraints instr_rdata_i[121] 
remove_pi_constraints instr_rdata_i[122] 
remove_pi_constraints instr_rdata_i[123] 
remove_pi_constraints instr_rdata_i[124] 
remove_pi_constraints instr_rdata_i[125] 
remove_pi_constraints instr_rdata_i[126] 
remove_pi_constraints instr_rdata_i[127] 


add_po_masks -all 

remove_po_masks apu_master_operands_o[32] 
remove_po_masks apu_master_operands_o[33] 
remove_po_masks apu_master_operands_o[34] 
remove_po_masks apu_master_operands_o[35] 
remove_po_masks apu_master_operands_o[36] 
remove_po_masks apu_master_operands_o[37] 
remove_po_masks apu_master_operands_o[38] 
remove_po_masks apu_master_operands_o[39] 
remove_po_masks apu_master_operands_o[40] 
remove_po_masks apu_master_operands_o[41] 
remove_po_masks apu_master_operands_o[42] 
remove_po_masks apu_master_operands_o[43] 
remove_po_masks apu_master_operands_o[44] 
remove_po_masks apu_master_operands_o[45] 
remove_po_masks apu_master_operands_o[46] 
remove_po_masks apu_master_operands_o[47] 
remove_po_masks apu_master_operands_o[48] 
remove_po_masks apu_master_operands_o[49] 
remove_po_masks apu_master_operands_o[50] 
remove_po_masks apu_master_operands_o[51] 
remove_po_masks apu_master_operands_o[52] 
remove_po_masks apu_master_operands_o[53] 
remove_po_masks apu_master_operands_o[54] 
remove_po_masks apu_master_operands_o[55] 
remove_po_masks apu_master_operands_o[56] 
remove_po_masks apu_master_operands_o[57] 
remove_po_masks apu_master_operands_o[58] 
remove_po_masks apu_master_operands_o[59] 
remove_po_masks apu_master_operands_o[60] 
remove_po_masks apu_master_operands_o[61] 
remove_po_masks apu_master_operands_o[62] 
remove_po_masks apu_master_operands_o[63] 
remove_po_masks apu_master_operands_o[64] 
remove_po_masks apu_master_operands_o[65] 
remove_po_masks apu_master_operands_o[66] 
remove_po_masks apu_master_operands_o[67] 
remove_po_masks apu_master_operands_o[68] 
remove_po_masks apu_master_operands_o[69] 
remove_po_masks apu_master_operands_o[70] 
remove_po_masks apu_master_operands_o[71] 
remove_po_masks apu_master_operands_o[72] 
remove_po_masks apu_master_operands_o[73] 
remove_po_masks apu_master_operands_o[74] 
remove_po_masks apu_master_operands_o[75] 
remove_po_masks apu_master_operands_o[76] 
remove_po_masks apu_master_operands_o[77] 
remove_po_masks apu_master_operands_o[78] 
remove_po_masks apu_master_operands_o[79] 
remove_po_masks apu_master_operands_o[80] 
remove_po_masks apu_master_operands_o[81] 
remove_po_masks apu_master_operands_o[82] 
remove_po_masks apu_master_operands_o[83] 
remove_po_masks apu_master_operands_o[84] 
remove_po_masks apu_master_operands_o[85] 
remove_po_masks apu_master_operands_o[86] 
remove_po_masks apu_master_operands_o[87] 
remove_po_masks apu_master_operands_o[88] 
remove_po_masks apu_master_operands_o[89] 
remove_po_masks apu_master_operands_o[90] 
remove_po_masks apu_master_operands_o[91] 
remove_po_masks apu_master_operands_o[92] 
remove_po_masks apu_master_operands_o[93] 
remove_po_masks apu_master_operands_o[94] 
remove_po_masks apu_master_operands_o[95]

run_drc ./syn/output/riscv_core_scan64.spf

set_patterns -external run/riscv_dumpports.vcd -sensitive -strobe_period {100 ns} -strobe_offset {40 ns} -vcd_clock auto
report_pi_constraints
report_po_masks


run_simulation -sequential
set_faults -model stuck
add_faults -all
run_fault_sim -sequential
set_faults -fault_coverage
report_summaries > fsim_out/fsim_stuck.txt
