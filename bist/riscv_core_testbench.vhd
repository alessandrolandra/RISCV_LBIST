
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use work.constants.all;

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
			 --test_so27				: out std_logic;
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
			 test_so64				: out std_logic;
			
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

	component LFSR
		port( 
			CLK : in std_logic; 
			RESET : in std_logic; 
			LD : in std_logic; 
			EN : in std_logic; 
			DIN : in std_logic_vector (0 to N_LFSR-1); 
			PRN : out std_logic_vector (0 to N_LFSR-1); 
			ZERO_D : out std_logic);
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
	signal lfsr_ld: std_logic;
	signal lfsr_seed: std_logic_vector(N_LFSR-1 downto 0);

    -- LFSR outputs
	signal lfsr_q: std_logic_vector(N_LFSR-1 downto 0); 

	-- xorGrid outputs
	signal grid_out: std_logic_vector(N_LFSR-1 downto 0);
	
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

	signal test_si1				: std_logic;
	signal test_si2				: std_logic;
	signal test_si3				: std_logic;
	signal test_si4				: std_logic;
	signal test_si5				: std_logic;
	signal test_si6				: std_logic;
	signal test_si7				: std_logic;
	signal test_si8				: std_logic;
	signal test_si9				: std_logic;
	signal test_si10				: std_logic;
	signal test_si11				: std_logic;
	signal test_si12				: std_logic;
	signal test_si13				: std_logic;
	signal test_si14				: std_logic;
	signal test_si15				: std_logic;
	signal test_si16				: std_logic;
	signal test_si17				: std_logic;
	signal test_si18				: std_logic;
	signal test_si19				: std_logic;
	signal test_si20				: std_logic;
	signal test_si21				: std_logic;
	signal test_si22				: std_logic;
	signal test_si23				: std_logic;
	signal test_si24				: std_logic;
	signal test_si25				: std_logic;
	signal test_si26				: std_logic;
	signal test_si27				: std_logic;
	signal test_si28				: std_logic;
	signal test_si29				: std_logic;
	signal test_si30				: std_logic;
	signal test_si31				: std_logic;
	signal test_si32				: std_logic;
	signal test_si33				: std_logic;
	signal test_si34				: std_logic;
	signal test_si35				: std_logic;
	signal test_si36				: std_logic;
	signal test_si37				: std_logic;
	signal test_si38				: std_logic;
	signal test_si39				: std_logic;
	signal test_si40				: std_logic;
	signal test_si41				: std_logic;
	signal test_si42				: std_logic;
	signal test_si43				: std_logic;
	signal test_si44				: std_logic;
	signal test_si45				: std_logic;
	signal test_si46				: std_logic;
	signal test_si47				: std_logic;
	signal test_si48				: std_logic;
	signal test_si49				: std_logic;
	signal test_si50				: std_logic;
	signal test_si51				: std_logic;
	signal test_si52				: std_logic;
	signal test_si53				: std_logic;
	signal test_si54				: std_logic;
	signal test_si55				: std_logic;
	signal test_si56				: std_logic;
	signal test_si57				: std_logic;
	signal test_si58				: std_logic;
	signal test_si59				: std_logic;
	signal test_si60				: std_logic;
	signal test_si61				: std_logic;
	signal test_si62				: std_logic;
	signal test_si63				: std_logic;
	signal test_si64				: std_logic;
	signal test_so1				: std_logic;
	signal test_so2				: std_logic;
	signal test_so3				: std_logic;
	signal test_so4				: std_logic;
	signal test_so5				: std_logic;
	signal test_so6				: std_logic;
	signal test_so7				: std_logic;
	signal test_so8				: std_logic;
	signal test_so9				: std_logic;
	signal test_so10				:  std_logic;
	signal test_so11				:  std_logic;
	signal test_so12				:  std_logic;
	signal test_so13				:  std_logic;
	signal test_so14				:  std_logic;
	signal test_so15				:  std_logic;
	signal test_so16				:  std_logic;
	signal test_so17				:  std_logic;
	signal test_so18				:  std_logic;
	signal test_so19				:  std_logic;
	signal test_so20				:  std_logic;
	signal test_so21				:  std_logic;
	signal test_so22				:  std_logic;
	signal test_so23				:  std_logic;
	signal test_so24				:  std_logic;
	signal test_so25				:  std_logic;
	signal test_so26				:  std_logic;
	signal test_so27				:  std_logic;
	signal test_so28				:  std_logic;
	signal test_so29				:  std_logic;
	signal test_so30				:  std_logic;
	signal test_so31				:  std_logic;
	signal test_so32				:  std_logic;
	signal test_so33				:  std_logic;
	signal test_so34				:  std_logic;
	signal test_so35				:  std_logic;
	signal test_so36				:  std_logic;
	signal test_so37				:  std_logic;
	signal test_so38				:  std_logic;
	signal test_so39				:  std_logic;
	signal test_so40				:  std_logic;
	signal test_so41				:  std_logic;
	signal test_so42				:  std_logic;
	signal test_so43				:  std_logic;
	signal test_so44				:  std_logic;
	signal test_so45				:  std_logic;
	signal test_so46				:  std_logic;
	signal test_so47				:  std_logic;
	signal test_so48				:  std_logic;
	signal test_so49				:  std_logic;
	signal test_so50				:  std_logic;
	signal test_so51				:  std_logic;
	signal test_so52				:  std_logic;
	signal test_so53				:  std_logic;
	signal test_so54				:  std_logic;
	signal test_so55				:  std_logic;
	signal test_so56				:  std_logic;
	signal test_so57				:  std_logic;
	signal test_so58				:  std_logic;
	signal test_so59				:  std_logic;
	signal test_so60				:  std_logic;
	signal test_so61				:  std_logic;
	signal test_so62				:  std_logic;
	signal test_so63				:  std_logic;
	signal test_so64				:  std_logic;

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

    mylfsr : LFSR
		port map (
			CLK 	=>  lfsr_clock, 
			RESET 	=>  lfsr_reset,
			LD 		=>  lfsr_ld,
			EN 		=>  lfsr_en,
			DIN 	=>  lfsr_seed,
			PRN 	=>  lfsr_q,
			ZERO_D 	=>  open
		);
			
	dut: riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800 
		port map (
			clock_en_i => clock_en_i,
		test_en_i => test_en_i,
		test_mode_tp => '1',
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
		rst_ni=>dut_reset,
		test_si1	=>	test_si1,		
		test_si2	=>	test_si2,		
		test_si3	=>	test_si3,		
		test_si4	=>	test_si4,		
		test_si5	=>	test_si5,		
		test_si6	=>	test_si6,		
		test_si7	=>	test_si7,		
		test_si8	=>	test_si8,		
		test_si9	=>	test_si9,		
		test_si10	=>	test_si10,		
		test_si11	=>	test_si11,		
		test_si12	=>	test_si12,		
		test_si13	=>	test_si13,		
		test_si14	=>	test_si14,		
		test_si15	=>	test_si15,		
		test_si16	=>	test_si16,		
		test_si17	=>	test_si17,		
		test_si18	=>	test_si18,		
		test_si19	=>	test_si19,		
		test_si20	=>	test_si20,		
		test_si21	=>	test_si21,		
		test_si22	=>	test_si22,		
		test_si23	=>	test_si23,		
		test_si24	=>	test_si24,		
		test_si25	=>	test_si25,		
		test_si26	=>	test_si26,		
		test_si27	=>	test_si27,		
		test_si28	=>	test_si28,		
		test_si29	=>	test_si29,		
		test_si30	=>	test_si30,		
		test_si31	=>	test_si31,		
		test_si32	=>	test_si32,		
		test_si33	=>	test_si33,		
		test_si34	=>	test_si34,		
		test_si35	=>	test_si35,		
		test_si36	=>	test_si36,		
		test_si37	=>	test_si37,		
		test_si38	=>	test_si38,		
		test_si39	=>	test_si39,		
		test_si40	=>	test_si40,		
		test_si41	=>	test_si41,		
		test_si42	=>	test_si42,		
		test_si43	=>	test_si43,		
		test_si44	=>	test_si44,		
		test_si45	=>	test_si45,		
		test_si46	=>	test_si46,		
		test_si47	=>	test_si47,		
		test_si48	=>	test_si48,		
		test_si49	=>	test_si49,		
		test_si50	=>	test_si50,		
		test_si51	=>	test_si51,		
		test_si52	=>	test_si52,		
		test_si53	=>	test_si53,		
		test_si54	=>	test_si54,		
		test_si55	=>	test_si55,		
		test_si56	=>	test_si56,		
		test_si57	=>	test_si57,		
		test_si58	=>	test_si58,		
		test_si59	=>	test_si59,		
		test_si60	=>	test_si60,		
		test_si61	=>	test_si61,		
		test_si62	=>	test_si62,		
		test_si63	=>	test_si63,		
		test_si64	=>	test_si64,		
		test_so1	=>	test_so1,		
		test_so2	=>	test_so2,		
		test_so3	=>	test_so3,		
		test_so4	=>	test_so4,		
		test_so5	=>	test_so5,		
		test_so6	=>	test_so6,		
		test_so7	=>	test_so7,		
		test_so8	=>	test_so8,		
		test_so9	=>	test_so9,		
		test_so10	=>	test_so10,		
		test_so11	=>	test_so11,		
		test_so12	=>	test_so12,		
		test_so13	=>	test_so13,		
		test_so14	=>	test_so14,		
		test_so15	=>	test_so15,		
		test_so16	=>	test_so16,		
		test_so17	=>	test_so17,		
		test_so18	=>	test_so18,		
		test_so19	=>	test_so19,		
		test_so20	=>	test_so20,		
		test_so21	=>	test_so21,		
		test_so22	=>	test_so22,		
		test_so23	=>	test_so23,		
		test_so24	=>	test_so24,		
		test_so25	=>	test_so25,		
		test_so26	=>	test_so26,		
		--test_so27	=>	test_so27,		
		test_so28	=>	test_so28,		
		test_so29	=>	test_so29,		
		test_so30	=>	test_so30,		
		--irq_id_o[4]	=>	test_so31,		
		test_so32	=>	test_so32,		
		test_so33	=>	test_so33,		
		test_so34	=>	test_so34,		
		test_so35	=>	test_so35,		
		test_so36	=>	test_so36,		
		test_so37	=>	test_so37,		
		test_so38	=>	test_so38,		
		test_so39	=>	test_so39,		
		test_so40	=>	test_so40,		
		test_so41	=>	test_so41,		
		test_so42	=>	test_so42,		
		test_so43	=>	test_so43,		
		test_so44	=>	test_so44,		
		test_so45	=>	test_so45,		
		test_so46	=>	test_so46,		
		test_so47	=>	test_so47,		
		test_so48	=>	test_so48,		
		test_so49	=>	test_so49,		
		test_so50	=>	test_so50,		
		test_so51	=>	test_so51,		
		test_so52	=>	test_so52,		
		test_so53	=>	test_so53,		
		test_so54	=>	test_so54,		
		test_so55	=>	test_so55,		
		test_so56	=>	test_so56,		
		test_so57	=>	test_so57,		
		test_so58	=>	test_so58,		
		test_so59	=>	test_so59,		
		test_so60	=>	test_so60,		
		test_so61	=>	test_so61,		
		test_so62	=>	test_so62,		
		test_so63	=>	test_so63,		
		test_so64	=>	test_so64		
	);

	myxorGrid : xorGrid
	generic map (N=>64)
	port map (
		LFSR_OUT=>lfsr_q,
		PREG_OUT=>grid_out
	);
		test_so31<=irq_id_o(3);
		test_so27<=data_we_o;
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
 	--test_en_i <= '0';
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
	 test_si1	<=grid_out(1);
	 test_si2	<=grid_out(2);
	 test_si3	<=grid_out(3);
	 test_si4	<=grid_out(4);
	 test_si5	<=grid_out(5);
	 test_si6	<=grid_out(6);
	 test_si7	<=grid_out(7);
	 test_si8	<=grid_out(8);
	 test_si9	<=grid_out(9);
	 test_si10	<=grid_out(10);
	 test_si11	<=grid_out(11);
	 test_si12	<=grid_out(12);
	 test_si13	<=grid_out(13);
	 test_si14	<=grid_out(14);
	 test_si15	<=grid_out(15);
	 test_si16	<=grid_out(16);
	 test_si17	<=grid_out(17);
	 test_si18	<=grid_out(18);
	 test_si19	<=grid_out(19);
	 test_si20	<=grid_out(20);
	 test_si21	<=grid_out(21);
	 test_si22	<=grid_out(22);
	 test_si23	<=grid_out(23);
	 test_si24	<=grid_out(24);
	 test_si25	<=grid_out(25);
	 test_si26	<=grid_out(26);	
	 test_si27	<=grid_out(27);
	 test_si28<=grid_out(28);
	 test_si29<=grid_out(29);
	 test_si30<=grid_out(30);
	 test_si31<=grid_out(31);
	 test_si32<=grid_out(32);
	 test_si33<=grid_out(33);
	 test_si34<=grid_out(34);
	 test_si35<=grid_out(35);
	 test_si36<=grid_out(36);
	 test_si37<=grid_out(37);
	 test_si38<=grid_out(38);
	 test_si39<=grid_out(39);
	 test_si40<=grid_out(40);
	 test_si41<=grid_out(41);
	 test_si42<=grid_out(42);
	 test_si43<=grid_out(43);
	 test_si44<=grid_out(44);
	 test_si45<=grid_out(45);
	 test_si46<=grid_out(46);
	 test_si47<=grid_out(47);
	 test_si48<=grid_out(48);
	 test_si49<=grid_out(49);
	 test_si50<=grid_out(50);
	 test_si51<=grid_out(51);
	 test_si52<=grid_out(52);
	 test_si53<=grid_out(53);
	 test_si54<=grid_out(54);
	 test_si55<=grid_out(55);
	 test_si56<=grid_out(56);
	 test_si57<=grid_out(57);
	 test_si58<=grid_out(58);
	 test_si59<=grid_out(59);
	 test_si60<=grid_out(60);
	 test_si61<=grid_out(61);
	 test_si62<=grid_out(62);
	 test_si63<=grid_out(63);
	 test_si64<=grid_out(0);


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
    lfsr_clock <= transport tester_clock after apply_period - clock_t1;

    --dut_reset <= '1', '0' after apply_period, '1' after apply_period*2;
    --lfsr_reset <= '1', '0' after apply_period;

	sc_mgmt: process
	begin
		lfsr_ld<='0'; test_en_i<='1'; dut_reset<='0'; lfsr_reset <='1';
		lfsr_seed<=x"01234567"; 
		wait for apply_period*2;
		dut_reset<='1'; lfsr_reset <='0';
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period*40;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"89ABCDEF"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"FEDCBA98"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"76543210"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"CAFFEBAD"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"DABEFFAC"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<="01713184"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"11CA2201"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"88889999"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"AAAABBBB"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"CCCCDDDD"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		lfsr_seed<=x"DEEEEFFF"; 
		lfsr_ld<='1';
		wait for apply_period;
		lfsr_ld<='0';
		wait for apply_period;
		for i in 0 to 64 loop 
			test_en_i<='0';
			wait for apply_period;
			test_en_i<='1';
			wait for apply_period*48;
		end loop;
		wait;
	end process;
end tb;

configuration cfg_riscv_testbench of riscv_testbench is
    for tb
    end for;
end cfg_riscv_testbench;
