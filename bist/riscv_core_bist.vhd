library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity riscv_core_bist is
	generic (
		SEED : std_logic_vector(64 downto 0):="10101010101010101010101010101010101010101010101010101010101010101"
	);
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
		--clk_i					: in std_logic;
 		--rst_ni					: in std_logic;
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
			-- test_mode				: in std_logic;
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
 			--test_so26				: out std_logic;
      		test_so27				: out std_logic;
 			test_so28				: out std_logic;
 			test_so29				: out std_logic;
 			test_so30				: out std_logic;
 			--test_so31				: out std_logic;
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
		SEED 	: std_logic_vector(64 downto 0)
	);
	port (
		clk		: in std_logic;
		reset	: in std_logic;
		en		: in std_logic;
		q		: out std_logic_vector (64 downto 0)
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
        MISR_OUT		: in std_logic_vector(N_MISR-1 downto 0);
        GO				: out std_logic;
		TPG_ODE_MUX_en	: out std_logic
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

	signal clk_internal : std_logic;
	signal q_internal : std_logic_vector(64 downto 0);

begin

--	clk_divisor : clk_divi
--	generic map (N=64)
--	port map (
--		clk=>clk,				-- clk from riscv_core_bist
--		q=>clk_internal			-- 
--	);
	clk_internal<=clk;			-- clk from riscv_core_bist

	lfsri : lfsr
	generic map (SEED=>SEED)
	port map (
		clk=>clk_internal,
		reset=>rst,
		en=>test_mode,
		q=>q_internal
	);

	q_internal<='0'&q_internal(64 downto 1);	-- right shift of 1 pos
	
	riscvi : riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
	port map (
		test_si1=>q_internal(0),
 		test_si2=>q_internal(1),
 		test_si3=>q_internal(2),
 		test_si4=>q_internal(3),
 		test_si5=>q_internal(4),
 		test_si6=>q_internal(5),				
 		test_si7=>q_internal(6),			
        test_si8=>q_internal(7),				
 		test_si9=>q_internal(8),				
 		test_si10=>q_internal(9),	
 		test_si11=>q_internal(10),				
 		test_si12=>q_internal(11),				
 		test_si13=>q_internal(12),				
        test_si14=>q_internal(13),				
 		test_si15=>q_internal(14),				
 		test_si16=>q_internal(15),			
 		test_si17=>q_internal(16),				
 		test_si18=>q_internal(17),			
 		test_si19=>q_internal(18),				
        test_si20=>q_internal(19),				
 		test_si21=>q_internal(20),				
 		test_si22=>q_internal(21),				
 		test_si23=>q_internal(22),				
 		test_si24=>q_internal(23),				
 		test_si25=>q_internal(24),				
        test_si26=>q_internal(25),			
 		test_si27=>q_internal(26),				
 		test_si28=>q_internal(27),				
		test_si29=>q_internal(28),
 		test_si30=>q_internal(29),				
 		test_si31=>q_internal(30),				
        test_si32=>q_internal(31),				
 		test_si33=>q_internal(32),				
 		test_si34=>q_internal(33),				
 		test_si35=>q_internal(34),				
 		test_si36=>q_internal(35),			
 		test_si37=>q_internal(36),				
        test_si38=>q_internal(37),			
 		test_si39=>q_internal(38),			
 		test_si40=>q_internal(39),				
		test_si41=>q_internal(40),				
		test_si42=>q_internal(41),				
		test_si43=>q_internal(42),				
        test_si44=>q_internal(43),				
 		test_si45=>q_internal(44),				
 		test_si46=>q_internal(45),				
 		test_si47=>q_internal(46),				
 		test_si48=>q_internal(47),				
 		test_si49=>q_internal(48),			
        test_si50=>q_internal(49),				
 		test_si51=>q_internal(50),				
 		test_si52=>q_internal(51),			
 		test_si53=>q_internal(52),			
 		test_si54=>q_internal(53),				
 		test_si55=>q_internal(54),				
        test_si56=>q_internal(55),				
 		test_si57=>q_internal(56),				
		test_si58=>q_internal(57),
		test_si59=>q_internal(58),
		test_si60=>q_internal(59),				
 		test_si61=>q_internal(60),				
        test_si62=>q_internal(61),				
		test_si63=>q_internal(62),				
		test_si64=>q_internal(63),	
	
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
		clk_i=>clk_internal,
		rst_ni=>rst
		-- test_mode=>test_mode
	);

end rtl;
