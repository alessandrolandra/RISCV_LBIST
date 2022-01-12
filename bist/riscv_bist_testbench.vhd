
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity riscv_testbench is
end riscv_testbench;


architecture tb of riscv_testbench is
    
	component riscv_core_bist
		generic (SEED: std_logic_vector(64 downto 0) := "10101010101010101010101010101010101010101010101010101010101010101");
		port (
			clk						: in std_logic;
			rst						: in std_logic;
			test_mode				: in std_logic;
			boot_addr_i 			: in std_logic_vector (31 downto 0);
			core_id_i				: in std_logic_vector (3 downto 0);
			cluster_id_i			: in std_logic_vector (5 downto 0);
			instr_rdata_i			: in std_logic_vector (127 downto 0);
			data_rdata_i			: in std_logic_vector (31 downto 0);
			apu_master_result_i		: in std_logic_vector (31 downto 0);
			apu_master_flags_i		: in std_logic_vector (4 downto 0);
			irq_id_i				: in std_logic_vector (4 downto 0);
			ext_perf_counters_i		: in std_logic_vector (1 to 2);

			clock_en_i				: in std_logic;
			test_en_i				: in std_logic;
			fregfile_disable_i		: in std_logic;
			instr_gnt_i				: in std_logic;
			instr_rvalid_i			: in std_logic;
			data_gnt_i				: in std_logic;
			data_rvalid_i			: in std_logic;
			apu_master_gnt_i		: in std_logic;
			apu_master_valid_i		: in std_logic;
			irq_i					: in std_logic;
			irq_sec_i				: in std_logic;
			debug_req_i				: in std_logic;
			fetch_enable_i			: in std_logic;
			instr_addr_o			: out std_logic_vector (31 downto 0);
			data_be_o				: out std_logic_vector (3 downto 0);
			data_addr_o				: out std_logic_vector (31 downto 0);
			data_wdata_o			: out std_logic_vector (31 downto 0);
			apu_master_operands_o 	: out std_logic_vector (95 downto 0);
			apu_master_op_o			: out std_logic_vector (5 downto 0);
			apu_master_type_o		: out std_logic_vector (1 to 2);
			apu_master_flags_o		: out std_logic_vector (14 downto 0);
			irq_id_o				: out std_logic_vector (4 downto 0);
			instr_req_o				: out std_logic;
			data_req_o				: out std_logic;
			data_we_o				: out std_logic;
			apu_master_req_o		: out std_logic;
			apu_master_ready_o		: out std_logic;
			irq_ack_o				: out std_logic;
			sec_lvl_o				: out std_logic;
			core_busy_o				: out std_logic;

			go_nogo					: out std_logic
		);
	end component;

	constant clock_t1      : time := 50 ns;
	constant clock_t2      : time := 30 ns;
	constant clock_t3      : time := 20 ns;
	constant apply_offset  : time := 0 ns;
	constant apply_period  : time := 100 ns;
	constant strobe_offset : time := 40 ns;
	constant strobe_period : time := 100 ns;


	signal tester_clock : std_logic := '0';

    signal dut_clock : std_logic := '0';
    signal dut_reset : std_logic;
	
	-- DUT inputs
	signal dut_test_mode : std_logic := '0';
	signal clock_en_i,test_en_i,fregfile_disable_i,instr_gnt_i,instr_rvalid_i,data_gnt_i,data_rvalid_i,apu_master_gnt_i,apu_master_valid_i,irq_i,irq_sec_i,debug_req_i,fetch_enable_i: std_logic;
	signal boot_addr_i  			: std_logic_vector (31 downto 0);
	signal core_id_i				: std_logic_vector (3 downto 0);
	signal cluster_id_i				: std_logic_vector (5 downto 0);
	signal instr_rdata_i			: std_logic_vector (127 downto 0);
	signal data_rdata_i				: std_logic_vector (31 downto 0);
	signal apu_master_result_i		: std_logic_vector (31 downto 0);
	signal apu_master_flags_i		: std_logic_vector (4 downto 0);
	signal irq_id_i					: std_logic_vector (4 downto 0);
	signal ext_perf_counters_i		: std_logic_vector (1 to 2);

    -- DUT outputs
	signal instr_req_o,data_req_o,data_we_o,apu_master_req_o,apu_master_ready_o,irq_ack_o,sec_lvl_o,core_busy_o : std_logic;
	signal instr_addr_o				: std_logic_vector (31 downto 0);
	signal data_be_o				: std_logic_vector (3 downto 0);
	signal data_addr_o				: std_logic_vector (31 downto 0);
	signal data_wdata_o				: std_logic_vector (31 downto 0);
	signal apu_master_operands_o 	: std_logic_vector (95 downto 0);
	signal apu_master_op_o			: std_logic_vector (5 downto 0);
	signal apu_master_type_o		: std_logic_vector (1 to 2);
	signal apu_master_flags_o 		: std_logic_vector (14 downto 0);
	signal irq_id_o					: std_logic_vector (4 downto 0);
	
    signal dut_go_nogo : std_logic;
	
	constant wait_time: time := strobe_period*300;

begin

    dut : riscv_core_bist
		generic map (SEED => "10101010101010101010101010101010101010101010101010101010101010101")
		port map (clk => dut_clock,
            rst => dut_reset,
			test_mode => dut_test_mode,
			clock_en_i => clock_en_i,
			test_en_i => test_en_i,
			fregfile_disable_i => fregfile_disable_i,
			instr_gnt_i => instr_gnt_i,
			instr_rvalid_i => instr_rvalid_i,
			data_gnt_i => data_gnt_i,
			data_rvalid_i => data_rvalid_i,
			apu_master_gnt_i => apu_master_gnt_i,
			apu_master_valid_i => apu_master_valid_i,
			irq_i => irq_i,
			irq_sec_i => irq_sec_i,
			debug_req_i => debug_req_i,
			fetch_enable_i => fetch_enable_i,
			boot_addr_i => boot_addr_i,
			core_id_i => core_id_i,
			cluster_id_i => cluster_id_i,
			instr_rdata_i => instr_rdata_i,
			data_rdata_i => data_rdata_i,
			apu_master_result_i => apu_master_result_i,
			apu_master_flags_i => apu_master_flags_i,
			irq_id_i => irq_id_i,
			ext_perf_counters_i => ext_perf_counters_i,
			instr_req_o => instr_req_o,
			data_req_o => data_req_o,
			data_we_o => data_we_o,
			apu_master_req_o => apu_master_req_o,
			apu_master_ready_o => apu_master_ready_o,
			irq_ack_o => irq_ack_o,
			sec_lvl_o => sec_lvl_o,
			core_busy_o => core_busy_o,
			instr_addr_o => instr_addr_o,
			data_be_o => data_be_o,
			data_addr_o => data_addr_o,
			data_wdata_o => data_wdata_o,
			apu_master_operands_o => apu_master_operands_o,
			apu_master_op_o => apu_master_op_o,
			apu_master_type_o => apu_master_type_o,
			apu_master_flags_o => apu_master_flags_o,
			irq_id_o =>	irq_id_o,
            go_nogo => dut_go_nogo);

-- ***** CLOCK/RESET ***********************************

	clock_generation : process
	begin
		loop
			wait for clock_t1; tester_clock <= '1';
			wait for clock_t2; tester_clock <= '0';
			wait for clock_t3;
		end loop;
	end process;

-- dut  ___/----\____ ___/----\____ ___/----\____ ___
-- lfsr /----\____ ___/----\____ ___/----\____ ___/--

    dut_clock <= transport tester_clock after apply_period;
    --bist_clock <= transport tester_clock after apply_period - clock_t1 + apply_offset;

    dut_reset <= '0', '1' after clock_t1, '0' after clock_t1 + clock_t2;
    --bist_reset <= '1', '0' after clock_t1 + clock_t2;

	checker: process
	begin
		wait for wait_time;
		assert dut_go_nogo = '1' report "go_nogo wrong value";
		wait;
	end process;

end tb;

configuration cfg_riscv_testbench of riscv_testbench is
    for tb
    end for;
end cfg_riscv_testbench;
