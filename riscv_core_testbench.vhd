
library std;
use std.env.all;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity riscv_testbench is
end riscv_testbench;


architecture tb of riscv_testbench is
    
	component riscv_core_bist
		generic (SEED = 1)
		port();
	end component;

	constant clock_t1      : time := 50 ns;
	constant clock_t2      : time := 30 ns;
	constant clock_t3      : time := 20 ns;
	constant apply_offset  : time := 0 ns;
	constant apply_period  : time := 100 ns;
	constant strobe_offset : time := 40 ns;
	constant strobe_period : time := 100 ns;


	signal tester_clock : std_logic := '0';

    signal dut_clock  : std_logic := '0';
    signal dut_reset  : std_logic;

    -- DUT outputs
    signal cc_mux       : std_logic_vector(2 downto 1);
    signal uscite       : std_logic_vector(2 downto 1);
    signal enable_count : std_logic;
    signal ackout       : std_logic;

begin

    bist : riscv_core_bist
		generic map (SEED => "10101010101010101010101010101010101010101010101010101010101010101")
		port map (clk => bist_clock,
            reset => bist_reset,
            go_nogo => bist_go_nogo);

    dut : riscv_core
		port map (clock    => dut_clock,
            reset    => dut_reset);

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
    bist_clock <= transport tester_clock after apply_period - clock_t1 + apply_offset;

    dut_reset <= '0', '1' after clock_t1, '0' after clock_t1 + clock_t2;
    bist_reset <= '1', '0' after clock_t1 + clock_t2;


-- ***** MONITOR **********

    monitor : process(cc_mux, uscite, enable_count, ackout)
		function vec2str( input : std_logic_vector ) return string is
			variable rline : line;
		begin
			write( rline, input );
			return rline.all;
		end vec2str;
    begin
        std.textio.write(std.textio.output, "cc_mux:" & vec2str(cc_mux) & " uscite:" & vec2str(uscite) & " enable_count:" & std_logic'image(enable_count) & " ackout:" & std_logic'image(ackout) & LF);
    end process;

end tb;

configuration cfg_riscv_testbench of riscv_testbench is
    for tb
    end for;
end cfg_riscv_testbench;
