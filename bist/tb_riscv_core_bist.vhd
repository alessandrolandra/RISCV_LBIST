
library std;
--use std.env.all;
--use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_textio.all;

entity tb_riscv_core_bist is
end tb_riscv_core_bist;


architecture tb of tb_riscv_core_bist is
    
	--#####################################################################
	--###################### RISC CORE ####################################
	--#####################################################################

	
	component riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
		port (
			clk_i					: in std_logic;
			rst_ni					: in std_logic;
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
			core_busy_o				: out std_logic
		);
	end component;

	--#####################################################################
	--########################## LBIST ####################################
	--#####################################################################

	component controller_top is
    generic (
        SCAN_SIZE			: integer:=8;
		W_SIZE_LD_UNLD		: integer:=12;
		W_ADDR_SIZE_LD_UNLD	: integer:=6;
		M_SIZE_LD_UNLD		: integer:=40; 
		W_SIZE_CAP			: integer:=262;
		W_ADDR_SIZE_CAP		: integer:=3;
		M_SIZE_CAP			: integer:=5;
		CORE_FREQ			: integer:=100000000;
		STUCK_AT_FREQ		: integer:=10000000
    );
    port (
        CORE_CLK			: in std_logic;
		TEST_START			: in std_logic;
		CORE_RST			: in std_logic;
		GO_NOGO				: out std_logic;	
		TEST_PATTERNS		: out std_logic_vector(W_SIZE_CAP-1 downto 0)
    );
	end component;

	-- CLOCK and RESET (fast) signals

	signal core_clock : std_logic;
    signal core_reset : std_logic;
	constant period: time:=10 ns;
	
	-- CORE inputs
	signal test_mode, clk_i,rst_ni : std_logic;
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

    -- CORE outputs
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
	
	-- BIST inputs (clock and reset are already defined as core_clock, core_reset);
	signal test_start: std_logic;
	
	-- BIST outputs
    signal bist_go_nogo : std_logic;
	signal bist_patterns: std_logic_vector(261 downto 0);

begin

	uut_lbist:  controller_top
    generic map (
        SCAN_SIZE			=>8,
		W_SIZE_LD_UNLD		=>12,
		W_ADDR_SIZE_LD_UNLD =>6,
		M_SIZE_LD_UNLD		=>40,
		W_SIZE_CAP			=>262,
		W_ADDR_SIZE_CAP		=>3,
		M_SIZE_CAP			=>5,
		CORE_FREQ			=>100000000,
		STUCK_AT_FREQ		=>10000000
    )
    port map (
        CORE_CLK=>core_clock,
		TEST_START=>test_start,
		CORE_RST=>core_reset,
		GO_NOGO=>bist_go_nogo,
		TEST_PATTERNS=>bist_patterns
    );   

	clk_i					<=	bist_patterns(71);
	rst_ni					<=	bist_patterns(259);
	test_mode				<=	bist_patterns(261);
	boot_addr_i 			<=	bist_patterns(63) & 
								bist_patterns(62) &
							  	bist_patterns(60 downto 51) & 
							  	bist_patterns(49 downto 40) & 
							  	bist_patterns(70 downto 64) & 
							 	bist_patterns(61) & 
								bist_patterns(50) & 
								bist_patterns(39);							
	core_id_i				<=  bist_patterns(82 downto 79);
	cluster_id_i			<=  bist_patterns(78 downto 73);
	instr_rdata_i			<=  bist_patterns(153 downto 146) & 
								bist_patterns(144 downto 135) & 
								bist_patterns(133 downto 124) & 
								bist_patterns(249 downto 240) & 
								bist_patterns(238 downto 229) & 
								bist_patterns(227 downto 218) & 
								bist_patterns(216 downto 207) & 
								bist_patterns(205 downto 196) & 
								bist_patterns(194 downto 185) & 
								bist_patterns(183 downto 174) & 
								bist_patterns(172 downto 163) & 
								bist_patterns(161 downto 154) & 
								bist_patterns(145) & 
								bist_patterns(134) & 
								bist_patterns(250) & 
								bist_patterns(239) & 
								bist_patterns(228) & 
								bist_patterns(217) & 
								bist_patterns(206) & 
								bist_patterns(195) & 
								bist_patterns(184) & 
								bist_patterns(173) & 
								bist_patterns(162) & 
								bist_patterns(123);
	data_rdata_i			<=  bist_patterns(108) & 
								bist_patterns(107) & 
								bist_patterns(105 downto 96) & 
								bist_patterns(94 downto 85) & 
								bist_patterns(115 downto 109) & 
								bist_patterns(106) & 
								bist_patterns(95) & 
								bist_patterns(84);
	apu_master_result_i		<=  bist_patterns(30) & 
								bist_patterns(29) & 
								bist_patterns(27 downto 18) & 
								bist_patterns(16 downto 7) & 
								bist_patterns(37 downto 31) & 
								bist_patterns(28) & 
								bist_patterns(17) & 
								bist_patterns(6);
	apu_master_flags_i		<=  bist_patterns(4 downto 0);
	irq_id_i				<=  bist_patterns(257 downto 253);
	ext_perf_counters_i		<=  bist_patterns(118) & 
										bist_patterns(119);
	clock_en_i				<=  bist_patterns(72);
	test_en_i				<=  bist_patterns(260);
	fregfile_disable_i		<=  bist_patterns(121);
	instr_gnt_i				<=  bist_patterns(122);
	instr_rvalid_i			<=  bist_patterns(251);
	data_gnt_i				<=  bist_patterns(83);
	data_rvalid_i			<=  bist_patterns(116);
	apu_master_gnt_i		<=  bist_patterns(5);
	apu_master_valid_i		<=  bist_patterns(38);
	irq_i					<=  bist_patterns(252);
	irq_sec_i				<=  bist_patterns(258);
	debug_req_i				<=  bist_patterns(117);
	fetch_enable_i			<=  bist_patterns(120);

	uut_core: riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
		port map (
			clk_i					=>	clk_i,
			rst_ni					=>	rst_ni,
			test_mode				=>	test_mode,
			boot_addr_i 			=>	boot_addr_i,							
			core_id_i				=>  core_id_i,
			cluster_id_i			=>  cluster_id_i,
			instr_rdata_i			=>  instr_rdata_i,
			data_rdata_i			=>  data_rdata_i,
			apu_master_result_i		=>  apu_master_result_i,
			apu_master_flags_i		=>  apu_master_flags_i,
			irq_id_i				=>  irq_id_i,
			ext_perf_counters_i		=>  ext_perf_counters_i,
			clock_en_i				=>  clock_en_i,
			test_en_i				=>  test_en_i,
			fregfile_disable_i		=>  fregfile_disable_i,
			instr_gnt_i				=>  instr_gnt_i,
			instr_rvalid_i			=>  instr_rvalid_i,
			data_gnt_i				=>  data_gnt_i,
			data_rvalid_i			=>  data_rvalid_i,
			apu_master_gnt_i		=>  apu_master_gnt_i,
			apu_master_valid_i		=>  apu_master_valid_i,
			irq_i					=>  irq_i,
			irq_sec_i				=>  irq_sec_i,
			debug_req_i				=>  debug_req_i,
			fetch_enable_i			=>  fetch_enable_i,
			instr_addr_o			=>  instr_addr_o,
			data_be_o				=>  data_be_o,
			data_addr_o				=>	data_addr_o,
			data_wdata_o			=>	data_wdata_o,
			apu_master_operands_o 	=>	apu_master_operands_o,
			apu_master_op_o			=>	apu_master_op_o,
			apu_master_type_o		=>	apu_master_type_o,
			apu_master_flags_o		=>	apu_master_flags_o,
			irq_id_o				=>	irq_id_o,
			instr_req_o				=>	instr_req_o,
			data_req_o				=>	data_req_o,
			data_we_o				=>	data_we_o,
			apu_master_req_o		=>	apu_master_req_o,
			apu_master_ready_o		=>	apu_master_ready_o,
			irq_ack_o				=>	irq_ack_o,
			sec_lvl_o				=>	sec_lvl_o,
			core_busy_o				=>	core_busy_o
		);

	--CLOCK generator
	process
	begin
		core_clock<='0';
		wait for period/2;
		core_clock<='1';
		wait for period/2;
	end process;

	--RESET and TEST_START
	process
	begin
		core_reset<='0';
		test_start<='1';
		wait for 3 ns;
		core_reset<='1';
		wait;
	end process;


end tb;
