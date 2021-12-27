
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity riscv_testbench is
end riscv_testbench;


architecture tb of riscv_testbench is
    
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
	signal dut_en: std_logic := '0';

    -- DUT outputs
	signal dut_q: std_logic_vector(64 downto 0);

begin

    dut : lfsr
		generic map (SEED => "10101010101010101010101010101010101010101010101010101010101010101")
		port map (clk => dut_clock,
            reset => dut_reset,
			en => dut_en,
			q => dut_q);

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


-- ***** MONITOR **********

    monitor : process(dut_q)
		function vec2str( input : std_logic_vector ) return string is
			variable rline : line;
		begin
			write( rline, input );
			return rline.all;
		end vec2str;
    begin
        std.textio.write(std.textio.output, 
		"boot_addr_i" 			& vec2str(dut_q(31 downto 0)) &
		"core_id_i"				& vec2str(dut_q(3 downto 0)) &
		"cluster_id_i"			& vec2str(dut_q(5 downto 0)) &
		"instr_rdata_i"			& vec2str(dut_q(63 downto 0)&dut_q(63 downto 0)) &
		"data_rdata_i"			& vec2str(dut_q(31 downto 0)) &
		"apu_master_result_i"	& vec2str(dut_q(31 downto 0)) &
		"apu_master_flags_i"	& vec2str(dut_q(4 downto 0)) &
		"irq_id_i"				& vec2str(dut_q(4 downto 0)) &
		"ext_perf_counters_i"	& vec2str(dut_q(1 to 2)) &
		"clk_i"					& dut_clock &
 		"rst_ni"				& dut_reset &
 		"clock_en_i"			& '1' &
 		"test_en_i"				& '0' &
 		"fregfile_disable_i"	& dut_q(0) &
 		"instr_gnt_i"			& dut_q(1) &
		"instr_rvalid_i"		& dut_q(2) &
 		"data_gnt_i"			& dut_q(3) &
 		"data_rvalid_i"			& dut_q(4) &
 		"apu_master_gnt_i"		& dut_q(5) &
		"apu_master_valid_i"	& dut_q(6) &
 		"irq_i"					& dut_q(7) &
 		"irq_sec_i"				& dut_q(8) &
 		"debug_req_i"			& dut_q(9) &
 		"fetch_enable_i"		& dut_q(10) &
		"test_si1"				& dut_q(0) &
 		"test_si2"				& dut_q(1) &
 		"test_si3"				& dut_q(2) &
 		"test_si4"				& dut_q(3) &
 		"test_si5"				& dut_q(4) &
 		"test_si6"				& dut_q(5) &
 		"test_si7"				& dut_q(6) &
        "test_si8"				& dut_q(7) &
 		"test_si9"				& dut_q(8) &
 		"test_si10"				& dut_q(9) &
 		"test_si11"				& dut_q(10) &
 		"test_si12"				& dut_q(11) &
 		"test_si13"				& dut_q(12) &
        "test_si14"				& dut_q(13) &
 		"test_si15"				& dut_q(14) &
 		"test_si16"				& dut_q(15) &
 		"test_si17"				& dut_q(16) &
 		"test_si18"				& dut_q(17) &
 		"test_si19"				& dut_q(18) &
        "test_si20"				& dut_q(19) &
 		"test_si21"				& dut_q(20) &
 		"test_si22"				& dut_q(21) &
 		"test_si23"				& dut_q(22) &
 		"test_si24"				& dut_q(23) &
 		"test_si25"				& dut_q(24) &
        "test_si26"				& dut_q(25) &
 		"test_si27"				& dut_q(26) &
 		"test_si28"				& dut_q(27) &
		"test_si29"				& dut_q(28) &
 		"test_si30"				& dut_q(29) &
 		"test_si31"				& dut_q(30) &
        "test_si32"				& dut_q(31) &
 		"test_si33"				& dut_q(32) &
 		"test_si34"				& dut_q(33) &
 		"test_si35"				& dut_q(34) &
 		"test_si36"				& dut_q(35) &
 		"test_si37"				& dut_q(36) &
        "test_si38"				& dut_q(37) &
 		"test_si39"				& dut_q(38) &
 		"test_si40"				& dut_q(39) &
		"test_si41"				& dut_q(40) &
		"test_si42"				& dut_q(41) &
		"test_si43"				& dut_q(42) &
        "test_si44"				& dut_q(43) &
 		"test_si45"				& dut_q(44) &
 		"test_si46"				& dut_q(45) &
 		"test_si47"				& dut_q(46) &
 		"test_si48"				& dut_q(47) &
 		"test_si49"				& dut_q(48) &
        "test_si50"				& dut_q(49) &
 		"test_si51"				& dut_q(50) &
 		"test_si52"				& dut_q(51) &
 		"test_si53"				& dut_q(52) &
 		"test_si54"				& dut_q(53) &
 		"test_si55"				& dut_q(54) &
        "test_si56"				& dut_q(55) &
 		"test_si57"				& dut_q(56) &
		"test_si58"				& dut_q(57) &
 		"test_si59"				& dut_q(58) &
 		"test_si60"				& dut_q(59) &
 		"test_si61"				& dut_q(60) &
        "test_si62"				& dut_q(61) &
		"test_si63"				& dut_q(62) &
		"test_si64"				& dut_q(63) & LF);
    end process;

end tb;

configuration cfg_riscv_testbench of riscv_testbench is
    for tb
    end for;
end cfg_riscv_testbench;
