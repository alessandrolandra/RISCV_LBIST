library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is
	generic (
		N	: integer
	);
	port (
		A : in std_logic_vector (N-1 downto 0);
		B : in std_logic_vector (N-1 downto 0);
		S : in std_logic;
		Y : out std_logic_vector (N-1 downto 0)
	);
end mux;

architecture beh of mux is
begin

	Y <= A when (S='0') else B;

end beh;

