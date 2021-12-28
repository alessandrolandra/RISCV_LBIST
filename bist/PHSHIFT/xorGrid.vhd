--module: phase shifter

library IEEE;
use IEEE.std_logic_1164.all; 

entity xorGrid is
	GENERIC (
		N: integer := 64
	);
	PORT(
		LFSR_OUT: IN std_logic_vector(N-1 DOWNTO 0);
		PREG_OUT: OUT std_logic_vector(N-1 DOWNTO 0)
	);
end xorGrid;

architecture Beh of xorGrid is
begin
	process(LFSR_OUT)
		begin
			for i in 0 to N-1 loop
				if i = (N-1) then
					PREG_OUT(i) <= LFSR_OUT(i) XOR LFSR_OUT(0);
				else
					PREG_OUT(i) <= LFSR_OUT(i) XOR LFSR_OUT(i+1);
				end if;
			end loop;
	end process;
end Beh;

configuration CFG_xorGrid of xorGrid is
   for Beh
   end for;
end CFG_xorGrid;
