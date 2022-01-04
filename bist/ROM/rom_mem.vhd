library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.constants.all;

entity ROM is
	generic (
		W_SIZE			: integer:=12;
		W_ADDR_SIZE		: integer:=4;
		M_SIZE			: integer:=50;
		PATT_PATH		: string:=PATT_PATH_LOAD
	);
	port (
		ADDR: in std_logic_vector(W_ADDR_SIZE-1 downto 0);
		ENABLE: in std_logic;
		RST: in std_logic;
		DOUT:	out std_logic_vector(W_SIZE-1 downto 0)
	);
end ROM;

architecture beh of ROM is

type patterns_array is array(0 to M_SIZE-1) of std_logic_vector(W_SIZE-1 downto 0);
signal MEM: patterns_array;
file VECTOR_SAMPLE : text;

begin

	process(ENABLE, ADDR, RST)
	variable v_ILINE : line;
	variable i: integer:=0;
	variable ret: std_logic_Vector(W_SIZE-1 downto 0);
	begin
		if (RST = '1') then
			--READ FROM FILE
			file_open(VECTOR_SAMPLE, PATT_PATH,  read_mode);
			while not endfile(VECTOR_SAMPLE) loop
            	readline(VECTOR_SAMPLE, v_ILINE);
            	for i in 0 to (v_ILINE'length-1) loop
					case v_ILINE(i+1) is
						when '0'=> ret(W_SIZE-1-i):='0';
						when '1'=> ret(W_SIZE-1-i):='1';
						when others=> ret(W_SIZE-1-i):='0';
					end case;
				end loop;
            	MEM(i)<=ret;
				i:=i+1;
        	end loop;
        	file_close(VECTOR_SAMPLE);
		elsif (ENABLE = '1') then
			if (to_integer(unsigned(ADDR)) < M_SIZE) then
				DOUT<=MEM(to_integer(unsigned(ADDR)));
			else
				DOUT<=MEM(M_SIZE-1);
			end if;
		else
			DOUT<=(others=>'Z');
		end if;
	end process;

end beh;
