
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity riscv_testbench is
end riscv_testbench;


architecture tb of riscv_testbench is
    
	component riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800 
		port (
			boot_addr_i 			: in std_logic_vector (31 downto 0);
			core_id_i				: in std_logic_vector (3 downto 0);
			cluster_id_i			: in std_logic_vector (5 downto 0);
			instr_rdata_i			: in std_logic_vector (127 downto 0);
			data_rdata_i			: in std_logic_vector (31 downto 0);
			apu_master_result_i		: in std_logic_vector (31 downto 0);
			apu_master_flags_i		: in std_logic_vector (4 downto 0);
			irq_id_i				: in std_logic_vector (4 downto 0);
			ext_perf_counters_i		: in std_logic_vector (1 to 2);
			clk_i					: in std_logic;
 			rst_ni					: in std_logic;
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
 			core_busy_o				: out std_logic
		);
	end component;

	component lfsr
	generic (
		SEED 	: std_logic_vector(64 downto 0)
	);
	port (
		clk		: in std_logic;
		reset	: in std_logic;
		en		: in std_logic;
		q		: out std_logic_vector (64 downto 0)
	);
	end component;

	component xorGrid is
	GENERIC (
		N: integer := 64
	);
	PORT(
		LFSR_OUT: IN std_logic_vector(N-1 DOWNTO 0);
		PREG_OUT: OUT std_logic_vector(N-1 DOWNTO 0)
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

    signal dut_clock, lfsr_clock : std_logic := '0';
    signal dut_reset, lfsr_reset: std_logic;
	
	-- LFSR inputs
	signal lfsr_en: std_logic := '1';

    -- LFSR outputs
	signal lfsr_q: std_logic_vector(64 downto 0); 

	-- xorGrid outputs
	signal grid_out: std_logic_vector(64 downto 0);
	
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

begin

    mylfsr : lfsr
		generic map (SEED => "10101010101010101010101010101010101010101010101010101010101010101")
		port map (clk => lfsr_clock,
            reset => lfsr_reset,
			en => lfsr_en,
			q => lfsr_q);
			
	dut: riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800 
		port map (
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
		clk_i=>dut_clock,
		rst_ni=>dut_reset
	);

	myxorGrid : xorGrid
	generic map (N=>64)
	port map (
		LFSR_OUT=>lfsr_q,
		PREG_OUT=>grid_out
	);
		
	boot_addr_i <= grid_out(31 downto 0);
	core_id_i<= grid_out(3 downto 0);
	cluster_id_i <= grid_out(5 downto 0);
	instr_rdata_i <= grid_out(63 downto 0)&grid_out(63 downto 0);
	data_rdata_i <= grid_out(31 downto 0);
	apu_master_result_i <= grid_out(31 downto 0);
	apu_master_flags_i <= grid_out(4 downto 0);
	irq_id_i <= grid_out(4 downto 0);
	ext_perf_counters_i <= grid_out(2 downto 1);
 	clock_en_i <= '1';
 	test_en_i <= '0';
 	fregfile_disable_i <= grid_out(0);
 	instr_gnt_i <= grid_out(1);
	instr_rvalid_i <= grid_out(2);
 	data_gnt_i <= grid_out(3);
 	data_rvalid_i <= grid_out(4);
 	apu_master_gnt_i <= grid_out(5);
	apu_master_valid_i <= grid_out(6);
 	irq_i <= grid_out(7);
 	irq_sec_i <= grid_out(8);
 	debug_req_i <= grid_out(9);
 	fetch_enable_i <= grid_out(10);

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
    lfsr_clock <= transport tester_clock after apply_period - clock_t1 + apply_offset;

    dut_reset <= '0', '1' after clock_t1, '0' after clock_t1 + clock_t2;
    lfsr_reset <= '1', '0' after clock_t1 + clock_t2;

end tb;

configuration cfg_riscv_testbench of riscv_testbench is
    for tb
    end for;
end cfg_riscv_testbench;
