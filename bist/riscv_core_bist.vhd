library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity riscv_core_bist is
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
end riscv_core_bist;

architecture rtl of riscv_core_bist is

	-- riscv_core
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
			test_mode_tp			: in std_logic;
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

	-- lfsr
	component LFSR
		port( 
			CLK : in std_logic; 
			RESET : in std_logic; 
			LD : in std_logic; 
			EN : in std_logic; 
			DIN : in std_logic_vector (0 to N_LFSR-1); 
			PRN : out std_logic_vector (0 to N_LFSR-1); 
			ZERO_D : out std_logic
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
	
	-- controller
	component controller
		generic (
			GOLDEN_SIGNATURE : std_logic_vector(N_MISR-1 downto 0)
		);
		port (		
			clk				: in std_logic;
			rst				: in std_logic;
			TEST 			: in std_logic;
			LFSR_SEED		: out std_logic_vector(N_MISR-1 downto 0);
			MISR_OUT		: in std_logic_vector(N_MISR-1 downto 0);
			LFSR_LD			: out std_logic;
			TEST_SCAN_EN	: out std_logic;
			GO				: out std_logic
		);
	end component;
	
	-- mux
	component mux 
		generic (
			N		: integer
		);
		port (
			A		: in std_logic_vector (N-1 downto 0);
			B		: in std_logic_vector (N-1 downto 0);
			S		: in std_logic;
			Y		: out std_logic_vector (N-1 downto 0)
		);
	end component;

	-- misr 
	component misr
		generic (
			N 		: integer := 64;
			SEED : std_logic_vector(N_MISR downto 0):= (OTHERS => '0')
		);
		port (
			clk			: in std_logic;
			rst			: in std_logic;
			EN_i		: in std_logic;
			DATA_IN		: in std_logic_vector (N-1 downto 0);
			SIGNATURE	: out std_logic_vector (N-1 downto 0)
		);
	end component;

	-- clock_divisor
	component clk_divisor
		generic (
			N		: integer
		);
		port (
			clk : in std_logic;
			q	: out std_logic
		);
	end component;

	signal clk_internal,rst_n : std_logic;
	signal lfsr_out,grid_out,lfsr_seed,misr_signature : std_logic_vector(63 downto 0);
	
	signal lfsr_ld,test_scan_en: std_logic;
			
	
	signal instr_rdata_i_s,instr_rdata_comp: std_logic_vector (127 downto 0);
	signal apu_master_operands_o_s: std_logic_vector (95 downto 0);	
	
	constant golden_signature: std_logic_vector(N_MISR-1 downto 0) := x"AA7D1099DA8013BA";

begin

--	clk_divisor : clk_divi
--		generic map (N=64)
--		port map (
--			clk=>clk,				-- clk from riscv_core_bist
--			q=>clk_internal			-- 
--		);
	clk_internal<=clk;			-- clk from riscv_core_bist
	rst_n <= NOT rst;
	
	lfsri : LFSR
		port map (
			CLK => clk_internal,
			RESET => rst,
			EN => test_mode,
			LD => lfsr_ld,
			DIN => lfsr_seed,
			PRN => lfsr_out,
			ZERO_D => open			
		);

	xori : xorGrid
		generic map (N => 64)
		port map(
			LFSR_OUT => lfsr_out,
			PREG_OUT => grid_out
		);
		
	mux_in : mux
		generic map (N => 128)
		port map(
			A => instr_rdata_i,
			B => instr_rdata_comp, --scan chain inputs
			S => test_scan_en,
			Y => instr_rdata_i_s
		);

	instr_rdata_comp <= grid_out(63 downto 0)&instr_rdata_i(63 downto 0);
	
	riscvi : riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
		port map (
			boot_addr_i => boot_addr_i,
			core_id_i => core_id_i,
			cluster_id_i => cluster_id_i,
			
			instr_rdata_i => instr_rdata_i_s,
			
			data_rdata_i => data_rdata_i,
			apu_master_result_i => apu_master_result_i,
			apu_master_flags_i => apu_master_flags_i,
			irq_id_i => irq_id_i,
			ext_perf_counters_i => ext_perf_counters_i,
			
			clk_i => clk_internal,
			rst_ni => rst_n,
			
			clock_en_i => clock_en_i,
			test_en_i => test_scan_en,
			
			test_mode_tp => test_mode,
			
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
			instr_addr_o => instr_addr_o,
			data_be_o => data_be_o,
			data_addr_o => data_addr_o,
			data_wdata_o => data_wdata_o,
			
			apu_master_operands_o => apu_master_operands_o_s,
			
			apu_master_op_o => apu_master_op_o,
			apu_master_type_o => apu_master_type_o,
			apu_master_flags_o => apu_master_flags_o,
			irq_id_o =>	irq_id_o,
			instr_req_o => instr_req_o,
			data_req_o => data_req_o,
			data_we_o => data_we_o,
			apu_master_req_o => apu_master_req_o,
			apu_master_ready_o => apu_master_ready_o,
			irq_ack_o => irq_ack_o,
			sec_lvl_o => sec_lvl_o,
			core_busy_o => core_busy_o
		);
		
	apu_master_operands_o <= apu_master_operands_o_s;
	
	misri : misr
		generic map(N => 64)
		port map(
			clk	=> clk_internal,
			rst	=> rst,
			EN_i => test_mode,
			DATA_IN	=> apu_master_operands_o_s(95 downto 32), --scan chain outputs
			SIGNATURE => misr_signature
		);
		
	controlleri : controller
		generic map(GOLDEN_SIGNATURE => golden_signature)
		port map(
			clk	=> clk_internal,
			rst	=> rst,
			TEST => test_mode,
			MISR_OUT => misr_signature,
			LFSR_LD => lfsr_ld,			
			LFSR_SEED => lfsr_seed,
			TEST_SCAN_EN => test_scan_en,			
			GO => go_nogo
		);

end rtl;
