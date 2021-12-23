library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clk_divisor is
	generic (
		N	: integer
	);
	port (
		clk : in std_logic;
		q : out std_logic
	);
end clk_divisor;

architecture beh of clk_divisor is
	signal cnt: unsigned(N-1 downto 0) := 0;
	signal q_s: std_logic:= '0';
begin

	cntUpdater: process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				cnt <= 0;
				q_s <= '0';
			else
				cnt <= cnt+1;
			end if;
		end if;		
	end process;
	
	toggler: process(cnt)
	begin
		-- if (std_logic_vector(cnt) = (OTHERS => '1')) then
		if (cnt = (2^N)-1) then
			q_s <= NOT q_s;
		end if;
	end process;
	
	q <= q_s;

end beh;

