
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
        std.textio.write(std.textio.output, "dut_q:" & vec2str(dut_q) & LF);
    end process;

end tb;

configuration cfg_riscv_testbench of riscv_testbench is
    for tb
    end for;
end cfg_riscv_testbench;
