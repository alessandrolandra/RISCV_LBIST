library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity controller is
    generic (
        GOLDEN_SIGNATURE : std_logic_vector(N_MISR-1 downto 0)
    );
    port (
        clk, rst, TEST : in std_logic;
        LFSR_SEED: out std_logic_vector(N_LFSR-1 downto 0);
		MISR_OUT: in std_logic_vector(N_MISR-1 downto 0);
        LFSR_LD, TEST_SCAN_EN: out std_logic;
		GO: out std_logic
    );
end entity controller;

architecture rtl of controller is
    type StateType is (S_Wait, S_capture, S_fill, S_Test, S_Reseed, S_Go);
    signal currState, nextState: StateType;
	
	signal cnt,next_cnt: unsigned(15 downto 0);
	signal cnt_reseed,next_cnt_reseed: unsigned(3 downto 0);
	signal cnt_chain,next_cnt_chain: unsigned(5 downto 0);
	constant cnt_max: integer:= 100;
	constant cnt_chain_max: integer:= 48;
	constant cnt_reseed_max: integer:= 11;
begin
    
    regs: process(clk)
    begin
        if (rising_edge(clk)) then
            if rst='1' then
                currState <= S_wait;
				cnt <= (OTHERS=>'0');
				cnt_reseed <= (OTHERS=>'0');
				cnt_chain <= (OTHERS=>'0');
				LFSR_SEED <= x"0123456701234567"; 
            else 
                currState <= nextState;
				cnt <= next_cnt;
				cnt_reseed <= next_cnt_reseed;
				cnt_chain <= next_cnt_chain;
            end if;
        end if;
    end process regs;
    
    comb: process(currState,TEST,MISR_OUT,cnt,cnt_reseed,cnt_chain)
    begin
        GO<='0';
		LFSR_LD<='0';
		TEST_SCAN_EN<='0';
        case currState is
            when S_Wait => 
                if(TEST = '1') then
                    nextState<=S_fill; 
                else
                    nextState<=S_wait;
                end if;
			when S_fill =>
				TEST_SCAN_EN<='1';
				if(to_integer(cnt_chain) < cnt_chain_max) then
					next_cnt_chain <= cnt_chain+1;
                    nextState<=S_fill;
				end if;
				nextState<=S_Test;
			when S_capture =>
				TEST_SCAN_EN<='0';
				nextState<=S_fill;				
            when S_Test =>
                if(TEST = '0') then
                    nextState<=S_wait;
                elsif(to_integer(cnt) < cnt_max) then
					next_cnt <= cnt+1;
                    nextState<=S_capture;
				elsif(to_integer(cnt_reseed) < cnt_reseed_max) then
					next_cnt <= (OTHERS => '0');
					nextState<=S_Reseed;
					next_cnt_reseed <= cnt_reseed+1;
                else 
                    nextState<=S_Go;
                end if;
			when S_Reseed =>
				LFSR_LD<='1';
                if(TEST = '0') then
                    nextState<=S_wait;
                else
					case (to_integer(cnt_reseed)) is
						when 1=>
							LFSR_SEED<=x"89ABCDEF89ABCDEF";
						when 2=>
							LFSR_SEED<=x"4444555566667777";
						when 3=>
							LFSR_SEED<=x"0123456789ABCDEF";
						when 4=>
							LFSR_SEED<=x"CAFFEBADCAFFEBAD";
						when 5=>
							LFSR_SEED<=x"DABEFFACDABEFFAC";
						when 6=>
							LFSR_SEED<=x"FEDCBA9876543210";
						when 7=>
							LFSR_SEED<=x"CAFFEBADDABEFFAC";
						when 8=>
							LFSR_SEED<=x"0171318411CA2201";
						when 9=>
							LFSR_SEED<=x"88889999AAAABBBB";
						when 10=>
							LFSR_SEED<=x"CCCCDDDDDEEEEFFF"; 
						when 11=>
							LFSR_SEED<=x"0000111122223333"; 
						when others=>
							LFSR_SEED<=x"0123456701234567";
					end case;
					nextState<=S_Test;
				end if;
            when S_Go =>                 
                if(MISR_OUT = GOLDEN_SIGNATURE) then
					GO<='1';
                end if;
				nextState<=S_wait;
            when others =>
                nextState<=S_wait;
        end case;
    end process comb;
    
end architecture rtl;
