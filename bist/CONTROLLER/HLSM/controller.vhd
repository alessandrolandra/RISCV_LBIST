library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controller is
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
		RESULT			: out std_logic; --tests result (0==faulty)
		LOAD_CAPTURE	: out std_logic; --signal used to drive multiplexers that switches between LOAD/UNLOAD pattterns and CAPTURE patterns 
		A1				: out std_logic_vector(A1_SIZE -1 downto 0); --address for the LOAD/UNLOAD memory
		A2				: out std_logic_vector(A2_SIZE -1 downto 0) --address for the LOAD/UNLOAD memory
    );
end entity controller;

architecture HLSM of controller is

    type StateType is (S_wait, S_start, S_end);
    signal currState, nextState: StateType;
	signal counter_start: std_logic;
	signal count: unsigned(3 downto 0);
	signal count2: unsigned(15 downto 0);

	signal address_1: std_logic_vector(A1_SIZE -1 downto 0);
	signal address_2: std_logic_vector(A2_SIZE -1 downto 0);

begin

	counter1: process(CLOCK, RESET, counter_start)
	begin
		if RESET='1' then
			count<=(others=>'0');
		elsif rising_edge(CLOCK) then
			if ( counter_start='1' ) then
				if count=MAX_SCAN_SIZE then
					count<=(others=>'0');
				else
					count<=count+1;
				end if;
			end if;
		end if;
	end process counter1;

	counter2: process(CLOCK, RESET, counter_start)
	begin
		if RESET='1' then
			count2<=(others=>'0');
		elsif rising_edge(CLOCK) then
			if ( counter_start='1' ) then
				count2<=count2+1;
			end if;
		end if;
	end process counter2;

    
    regs: process(CLOCK, RESET)
    begin
        if RESET='1' then
			currState<=S_wait;
		elsif rising_edge(CLOCK) then
			currState<=nextState;
		end if;
    end process regs;
    
    comb: process(currState,TEST_START,count)
    begin
		counter_start<='0';
        RESULT<='0';
		LOAD_CAPTURE<='0';

        case currState is
            when S_wait =>
				address_1<=(others=>'1');
				address_2<=(others=>'1');
                if (TEST_START = '1') then
					nextState<=S_start;
				else
					nextState<=S_wait;
				end if;
			when S_start =>
				counter_start<='1';
				if (count = MAX_SCAN_SIZE) and (count2 < TEST_CYCLES) and (count2 /= 0)then
					address_2<=std_logic_vector(unsigned(address_2)+1);
					nextState<=S_start;
					LOAD_CAPTURE<='1';
				elsif count2 = TEST_CYCLES then
					counter_start<='0';
					nextState<=S_end;
				else
					address_1<=std_logic_vector(unsigned(address_1)+1);
					nextState<=S_start;
				end if;

			when S_end =>
                nextState<=S_end;

            when others =>
                nextState<=S_wait;
        end case;
    end process comb;

	A1<=address_1;
	A2<=address_2;
    
end architecture HLSM;
