onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /riscv_bist_testbench/clk
add wave -noupdate /riscv_bist_testbench/rst
add wave -noupdate /riscv_bist_testbench/test_mode
add wave -noupdate /riscv_bist_testbench/clock_en_i
add wave -noupdate /riscv_bist_testbench/fregfile_disable_i
add wave -noupdate /riscv_bist_testbench/instr_gnt_i
add wave -noupdate /riscv_bist_testbench/instr_rvalid_i
add wave -noupdate /riscv_bist_testbench/data_gnt_i
add wave -noupdate /riscv_bist_testbench/data_rvalid_i
add wave -noupdate /riscv_bist_testbench/apu_master_gnt_i
add wave -noupdate /riscv_bist_testbench/apu_master_valid_i
add wave -noupdate /riscv_bist_testbench/irq_i
add wave -noupdate /riscv_bist_testbench/irq_sec_i
add wave -noupdate /riscv_bist_testbench/debug_req_i
add wave -noupdate /riscv_bist_testbench/fetch_enable_i
add wave -noupdate /riscv_bist_testbench/boot_addr_i
add wave -noupdate /riscv_bist_testbench/core_id_i
add wave -noupdate /riscv_bist_testbench/cluster_id_i
add wave -noupdate /riscv_bist_testbench/instr_rdata_i
add wave -noupdate /riscv_bist_testbench/data_rdata_i
add wave -noupdate /riscv_bist_testbench/apu_master_result_i
add wave -noupdate /riscv_bist_testbench/apu_master_flags_i
add wave -noupdate /riscv_bist_testbench/irq_id_i
add wave -noupdate /riscv_bist_testbench/ext_perf_counters_i
add wave -noupdate /riscv_bist_testbench/instr_req_o
add wave -noupdate /riscv_bist_testbench/data_req_o
add wave -noupdate /riscv_bist_testbench/data_we_o
add wave -noupdate /riscv_bist_testbench/apu_master_req_o
add wave -noupdate /riscv_bist_testbench/apu_master_ready_o
add wave -noupdate /riscv_bist_testbench/irq_ack_o
add wave -noupdate /riscv_bist_testbench/sec_lvl_o
add wave -noupdate /riscv_bist_testbench/core_busy_o
add wave -noupdate /riscv_bist_testbench/instr_addr_o
add wave -noupdate /riscv_bist_testbench/data_be_o
add wave -noupdate /riscv_bist_testbench/data_addr_o
add wave -noupdate /riscv_bist_testbench/data_wdata_o
add wave -noupdate /riscv_bist_testbench/apu_master_operands_o
add wave -noupdate /riscv_bist_testbench/apu_master_op_o
add wave -noupdate /riscv_bist_testbench/apu_master_type_o
add wave -noupdate /riscv_bist_testbench/apu_master_flags_o
add wave -noupdate /riscv_bist_testbench/irq_id_o
add wave -noupdate /riscv_bist_testbench/go_nogo
add wave -noupdate /riscv_bist_testbench/lfsr_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5998559 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 83
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {5998426 ns} {5999147 ns}
