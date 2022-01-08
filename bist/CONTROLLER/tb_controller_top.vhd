
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_controller_top is
end tb_controller_top;

architecture tb of tb_controller_top is

component controller_top is
    generic (
        SCAN_SIZE			: integer:=8;
		W_SIZE_LD_UNLD		: integer:=12;
		W_ADDR_SIZE_LD_UNLD	: integer:=6;
		M_SIZE_LD_UNLD		: integer:=40;
		W_SIZE_CAP			: integer:=262;
		W_ADDR_SIZE_CAP		: integer:=3;
		M_SIZE_CAP			: integer:=5;
		CORE_FREQ			: integer:=1000000000;
		STUCK_AT_FREQ		: integer:=100000000
    );
    port (
        CORE_CLK			: in std_logic;
		TEST_START			: in std_logic;
		CORE_RST			: in std_logic;
		GO_NOGO				: out std_logic;	
		TEST_PATTERNS		: out std_logic_vector(W_SIZE_CAP-1 downto 0)
    );
end component;

	signal c_clk: std_logic;
	signal t_start: std_logic;
	signal c_rst: std_logic;
	signal res: std_logic;
	signal test_patt: std_logic_vector(261 downto 0);

	signal load_unload_patt: std_logic_vector(11 downto 0);
	signal capture_patt: std_logic_vector(261 downto 0);

	constant period: time:= 10 ns; --core freq is 50 MHz
	
begin

	uut: controller_top
    generic map (
        SCAN_SIZE=>8,
		W_SIZE_LD_UNLD=>12,
		W_ADDR_SIZE_LD_UNLD=>6,
		M_SIZE_LD_UNLD		=>40,
		W_SIZE_CAP			=>262,
		W_ADDR_SIZE_CAP		=>3,
		M_SIZE_CAP			=>5,
		CORE_FREQ				=>100000000,
		STUCK_AT_FREQ		=>10000000
    )
    port map (
        CORE_CLK			=>c_clk,
		TEST_START			=>t_start,
		CORE_RST			=>c_rst,
		GO_NOGO				=>res,
		TEST_PATTERNS		=>test_patt
    );

	process
	begin
		c_clk<='0';
		wait for period;
		c_clk<='1';
		wait for period;
	end process;

	t_start<='1';

	process
	begin
		c_rst<='0';
		wait for 2 ns;
		c_rst<='1';
		wait;
	end process;

	process(test_patt)
	begin
		load_unload_patt<=test_patt(153 downto 146) & test_patt(144 downto 141);
		capture_patt<=test_patt;
	end process;

end tb;
