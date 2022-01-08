library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clk_divisor is
	generic (
		N			   : integer:=8; --size of the counter
		SCALING_FACTOR : integer:=10 --generated clock frequency = original_freq/scaling_factor
	);
	port (
		clk : in std_logic; --faster clock
		rst : in std_logic; --reset the counter to 0
		q : out std_logic   --genearated clock (slower)
	);
end clk_divisor;

architecture beh of clk_divisor is

	signal cnt: unsigned(N-1 downto 0) := (others=>'0');
	signal q_s: std_logic:= '0';
	signal reset: std_logic;

begin


	process(rst,cnt)
	begin
		if rst='0' then
			reset<='1';
			q_s<='0';
		elsif cnt=SCALING_FACTOR then
			reset<='1';
			q_s<= not q_s;
		else
			reset<='0';
		end if;
	end process;


	cntUpdater: process(clk,reset)
	begin
		if reset='1' then
			cnt <= (others=>'0');
		elsif rising_edge(clk) then
			cnt <= cnt+1;
		end if;
	end process;
	
	q <= q_s;

end beh;

