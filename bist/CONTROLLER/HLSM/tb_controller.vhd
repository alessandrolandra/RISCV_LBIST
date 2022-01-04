
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_controller is
end tb_controller;

architecture tb of tb_controller is

	component controller is
    generic (
        TEST_CYCLES		: integer:=45;
		A1_SIZE			: integer:=6;
		A2_SIZE			: integer:=3;
		MAX_SCAN_SIZE	: integer:=8
    );
    port (
        CLOCK			: in std_logic;				
		RESET			: in std_logic;
		TEST_START		: in std_logic;
		RESULT			: out std_logic;
		LOAD_CAPTURE	: out std_logic;
		A1				: out std_logic_vector(A1_SIZE -1 downto 0);
		A2				: out std_logic_vector(A2_SIZE -1 downto 0)
    );
	end component;

	signal clk,rst,test_start,result,load_capture: std_Logic;
	signal address_1: std_logic_vector(5 downto 0);
	signal address_2: std_logic_vector(2 downto 0);
	
    constant period: time:= 10 ns;

begin

	uut: controller 
    generic map(
        TEST_CYCLES=>45,
		A1_SIZE=>6,
		A2_SIZE=>3,
		MAX_SCAN_SIZE=>8
    )
    port map (
        CLOCK=>clk,			
		RESET=>rst,
		TEST_START=>test_start,
		RESULT=>result,
		LOAD_CAPTURE=>load_capture,
		A1=>address_1,
		A2=>address_2
    );


	process
	begin
		clk<='0';
		wait for period/2;
		clk<='1';
		wait for period/2;
	end process;

	process
	begin
		rst<='1';
		wait for 2 ns;
		rst<= '0';
		test_start<='1';
		wait for 1 ns;
		wait;
	end process;

	

end tb;

