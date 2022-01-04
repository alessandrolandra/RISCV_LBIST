library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.constants.all;

entity testbench is
--  Port ( );
end testbench;

architecture tb of testbench is
	component ROM is
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
	end component;

	constant W_S: integer:=12;
	constant W_A: integer:=4;
	constant period: time:=10 ns;

	signal address: std_logic_vector(W_A-1 downto 0);
	signal enable,reset: std_logic;
	signal data_out: std_logic_vector(W_S-1 downto 0);

	file VECTOR_SAMPLE : text;

begin

	uut: ROM 
	generic map (
		W_SIZE=>12,
		W_ADDR_SIZE=>4,
		M_SIZE=>40,
		PATT_PATH=>PATT_PATH_LOAD
	)
	port map (
		ADDR=>address,
		ENABLE=>enable,
		RST=>reset,
		DOUT=>data_out
	);

	process
	variable v_ILINE : line;
    variable v_TERM: integer;
	variable data_f: std_logic_vector(W_S-1 downto 0);
	begin
		reset<='1';
		enable<='0';
		address<=(others=>'Z');
		wait for period;
		wait for period;
		wait for period;
		reset<='0';
		wait for period;
		wait for period;
		enable<='1';
		address<=(others=>'1');
		wait for period;
		file_open(VECTOR_SAMPLE, PATT_PATH_LOAD,  read_mode);
		while not endfile(VECTOR_SAMPLE) loop
            readline(VECTOR_SAMPLE, v_ILINE);
            for i in 0 to (v_ILINE'length-1) loop
				case v_ILINE(i+1) is
					when '0'=> data_f(W_S-1-i):='0';
					when '1'=> data_f(W_S-1-i):='1';
					when others=> data_f(W_S-1-i):='0';
				end case;
			end loop;
			--assert data_f /= data_out report "System failure!" severity error;
			address<=std_logic_vector(unsigned(address) + 1);
			wait for period;
        end loop;
        file_close(VECTOR_SAMPLE);
		wait;
	end process;

end tb;
