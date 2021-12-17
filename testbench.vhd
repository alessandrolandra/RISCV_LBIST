
library std;
use std.env.all;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity b06_testbench is
end b06_testbench;


architecture tb of b06_testbench is
    component b06
        port (cc_mux       : out std_logic_vector(2 downto 1);
              eql          : in std_logic;
              uscite       : out std_logic_vector(2 downto 1);
              clock        : in std_logic;
              enable_count : out std_logic;
              ackout       : out std_logic;
              reset        : in std_logic;
              cont_eql     : in std_logic;
              test_si      : in std_logic;
              test_se      : in std_logic);
    end component;

    component lfsr
        generic (N    : integer;
                 SEED : std_logic_vector(N downto 0));
        port (clk   : in std_logic;
              reset : in std_logic;
              q     : out std_logic_vector(N downto 0));
    end component;

	constant clock_t1      : time := 50 ns;
	constant clock_t2      : time := 30 ns;
	constant clock_t3      : time := 20 ns;
	constant apply_offset  : time := 0 ns;
	constant apply_period  : time := 100 ns;
	constant strobe_offset : time := 40 ns;
	constant strobe_period : time := 100 ns;


	signal tester_clock : std_logic := '0';

    signal lfsr_out   : std_logic_vector(16 downto 0);
    signal lfsr_clock : std_logic := '0';
    signal lfsr_reset : std_logic;
    signal dut_clock  : std_logic := '0';
    signal dut_reset  : std_logic;

    -- DUT outputs
    signal cc_mux       : std_logic_vector(2 downto 1);
    signal uscite       : std_logic_vector(2 downto 1);
    signal enable_count : std_logic;
    signal ackout       : std_logic;

begin

    stimuli : lfsr
    generic map (N => 16,
                 SEED => "10101010101010101")
    port map (clk => lfsr_clock,
              reset => lfsr_reset,
              q => lfsr_out);

    dut : b06
    port map (clock    => dut_clock,
              reset    => dut_reset,
              test_si  => '0',
              test_se  => '0',
              eql      => lfsr_out(1),
              cont_eql => lfsr_out(0),
              cc_mux   => cc_mux,
              uscite   => uscite,
              enable_count => enable_count,
              ackout   => ackout);
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

configuration cfg_b06_testbench of b06_testbench is
    for tb
    end for;
end cfg_b06_testbench;
