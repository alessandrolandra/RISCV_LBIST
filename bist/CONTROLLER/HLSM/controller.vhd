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

    type StateType is (S_wait, S_start, S_cap_idle, S_end);
    signal currState, nextState: StateType;

	--ATPG patterns are for sure less than 512
	signal currCycleCount, nextCycleCount: unsigned(8 downto 0);
	signal currScanCount, nextScanCount: unsigned(3 downto 0);	

	signal address_1: std_logic_vector(A1_SIZE -1 downto 0);
	signal address_2: std_logic_vector(A2_SIZE -1 downto 0);

begin
    
    regs: process(CLOCK, RESET)
    begin
        if RESET='0' then
			currState<=S_wait;
			currScanCount<=(others=>'0');
			currCycleCount<=(others=>'0');
		elsif rising_edge(CLOCK) then
			currState<=nextState;
			currScanCount<=nextScanCount;
			currCycleCount<=nextCycleCount;
		end if;
    end process regs;
    
    comb: process(currState,TEST_START,currCycleCount, currScanCount)
    begin
        RESULT<='0';
		LOAD_CAPTURE<='0';

        case currState is
            when S_wait =>
				address_1<=(others=>'1');
				address_2<=(others=>'1');
				nextScanCount<=(others=>'0');
				nextCycleCount<=(others=>'0');
                if (TEST_START = '1') then
					nextState<=S_start;
				else
					nextState<=S_wait;
				end if;
			when S_start =>
				nextScanCount<=currScanCount+1;
				nextCycleCount<=currCycleCount+1;
				if (currScanCount = MAX_SCAN_SIZE) and (currCycleCount < TEST_CYCLES) and (currCycleCount /= 0)then
					--this is a capture pattern
					address_2<=std_logic_vector(unsigned(address_2)+1);
					--maintain capture pattern for another clock cycle
					nextState<=S_cap_idle;
					LOAD_CAPTURE<='1';
					nextScanCount<=(others=>'0');
				elsif currCycleCount = TEST_CYCLES then
					nextState<=S_end;
				else
					address_1<=std_logic_vector(unsigned(address_1)+1);
					nextState<=S_start;
				end if;

			when S_cap_idle =>
                nextState<=S_start;		
				LOAD_CAPTURE<='1';	
				--block the counters for 1 cycle
				nextScanCount<=currScanCount;
				nextCycleCount<=currCycleCount;

			when S_end =>
				--stopCounters
				nextScanCount<=currScanCount;
				nextCycleCount<=currCycleCount;
                nextState<=S_end;

            when others =>
                nextState<=S_wait;
				nextScanCount<=currScanCount;
				nextCycleCount<=currCycleCount;
        end case;
    end process comb;

	A1<=address_1;
	A2<=address_2;
    
end architecture HLSM;
