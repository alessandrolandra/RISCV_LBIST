
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_clk_divisor is
end tb_clk_divisor;

architecture tb of tb_clk_divisor is

	component clk_divisor is
	generic (
		N			   : integer:=8;
		SCALING_FACTOR : integer:=10
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		q : out std_logic 
	);
	end component;
	
	signal clk_gold: std_logic;
	signal clk_gen: std_logic;
	constant period: time:=10 ns;
	signal rst: std_logic;

    
begin

	uut: clk_divisor
	generic map(
		N=>8,
		SCALING_FACTOR=>10
	)
	port map(
		clk=>clk_gold,
		rst=>rst,
		q=>clk_gen
	);


	process
	begin
		clk_gold<='0';
		wait for period/2;
		clk_gold<='1';
		wait for period/2;
	end process;

	process
	begin
		rst<='1';
		wait for 2 ns;
		rst<= '0';
		wait for 1 ns;
		wait;
	end process;


end tb;
















