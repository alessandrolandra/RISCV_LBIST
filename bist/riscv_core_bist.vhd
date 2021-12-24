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
 		core_busy_o				: out std_logic;

		go_nogo					: out std_logic
	);
end riscv_core_bist;

architecture rtl of riscv_core_bist is

	-- add components
	-- controller

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
			test_si1				: in std_logic;
 			test_si2				: in std_logic;
 			test_si3				: in std_logic;
 			test_si4				: in std_logic;
 			test_si5				: in std_logic;
 			test_si6				: in std_logic;
 			test_si7				: in std_logic;
        	test_si8				: in std_logic;
 			test_si9				: in std_logic;
 			test_si10				: in std_logic;
 			test_si11				: in std_logic;
 			test_si12				: in std_logic;
 			test_si13				: in std_logic;
        	test_si14				: in std_logic;
 			test_si15				: in std_logic;
 			test_si16				: in std_logic;
 			test_si17				: in std_logic;
 			test_si18				: in std_logic;
 			test_si19				: in std_logic;
        	test_si20				: in std_logic;
 			test_si21				: in std_logic;
 			test_si22				: in std_logic;
 			test_si23				: in std_logic;
 			test_si24				: in std_logic;
 			test_si25				: in std_logic;
        	test_si26				: in std_logic;
 			test_si27				: in std_logic;
 			test_si28				: in std_logic;
			test_si29				: in std_logic;
 			test_si30				: in std_logic;
 			test_si31				: in std_logic;
        	test_si32				: in std_logic;
 			test_si33				: in std_logic;
 			test_si34				: in std_logic;
 			test_si35				: in std_logic;
 			test_si36				: in std_logic;
 			test_si37				: in std_logic;
        	test_si38				: in std_logic;
 			test_si39				: in std_logic;
 			test_si40				: in std_logic;
			test_si41				: in std_logic;
			test_si42				: in std_logic;
			test_si43				: in std_logic;
        	test_si44				: in std_logic;
 			test_si45				: in std_logic;
 			test_si46				: in std_logic;
 			test_si47				: in std_logic;
 			test_si48				: in std_logic;
 			test_si49				: in std_logic;
        	test_si50				: in std_logic;
 			test_si51				: in std_logic;
 			test_si52				: in std_logic;
 			test_si53				: in std_logic;
 			test_si54				: in std_logic;
 			test_si55				: in std_logic;
        	test_si56				: in std_logic;
 			test_si57				: in std_logic;
			test_si58				: in std_logic;
 			test_si59				: in std_logic;
 			test_si60				: in std_logic;
 			test_si61				: in std_logic;
        	test_si62				: in std_logic;
			test_si63				: in std_logic;
			test_si64				: in std_logic;
			test_mode				: in std_logic;
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
 			test_so1				: out std_logic;
         	test_so2				: out std_logic;
 			test_so3				: out std_logic;
 			test_so4				: out std_logic;
 			test_so5				: out std_logic;
 			test_so6				: out std_logic;
 			test_so7				: out std_logic;
 			test_so8				: out std_logic;
        	test_so9				: out std_logic;
 			test_so10				: out std_logic;
 			test_so11				: out std_logic;
 			test_so12				: out std_logic;
			test_so13				: out std_logic;
 			test_so14				: out std_logic;
         	test_so15				: out std_logic;
 			test_so16				: out std_logic;
 			test_so17				: out std_logic;
 			test_so18				: out std_logic;
 			test_so19				: out std_logic;
 			test_so20				: out std_logic;
	        test_so21				: out std_logic;
 			test_so22				: out std_logic;
 			test_so23				: out std_logic;
 			test_so24				: out std_logic;
			test_so25				: out std_logic;
 			test_so26				: out std_logic;
      		test_so27				: out std_logic;
 			test_so28				: out std_logic;
 			test_so29				: out std_logic;
 			test_so30				: out std_logic;
 			test_so31				: out std_logic;
 			test_so32				: out std_logic;
        	test_so33				: out std_logic;
 			test_so34				: out std_logic;
 			test_so35				: out std_logic;
 			test_so36				: out std_logic;
			test_so37				: out std_logic;
 			test_so38				: out std_logic;
        	test_so39				: out std_logic;
			test_so40				: out std_logic;
 			test_so41				: out std_logic;
			test_so42				: out std_logic;
 			test_so43				: out std_logic;
 			test_so44				: out std_logic;
        	test_so45				: out std_logic;
 			test_so46				: out std_logic;
			test_so47				: out std_logic;
 			test_so48				: out std_logic;
 			test_so49				: out std_logic;
 			test_so50				: out std_logic;
      	 	test_so51				: out std_logic;
			test_so52				: out std_logic;
 			test_so53				: out std_logic;
 			test_so54				: out std_logic;
			test_so55				: out std_logic;
			test_so56				: out std_logic;
         	test_so57				: out std_logic;
 			test_so58				: out std_logic;
 			test_so59				: out std_logic;
			test_so60				: out std_logic;
			test_so61				: out std_logic;
 			test_so62				: out std_logic;
        	test_so63				: out std_logic;
 			test_so64				: out std_logic
		);
	end component;

	-- lfsr
	component lfsr
	generic (
		SEED 	: integer
	);
	port (
		clk		: in std_logic;
		reset	: in std_logic;
		en	: in std_logic;
		q		: out std_logic_vector (64 downto 0)
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

	-- misr 
	component misr
	generic (
		N 		: integer := 64;
		SEED 	: std_logic_vector(N_MISR downto 0)
	);
	port (
		clk			: in std_logic;
		rst			: in std_logic;
		en			: in std_logic;
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

begin



end rtl;
