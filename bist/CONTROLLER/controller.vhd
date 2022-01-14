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
    type StateType is (S_Wait, S_capture, S_fill, S_Test, S_Reseed, S_Go, S_GoTrue);
    signal currState, nextState: StateType;
	
	signal cnt,next_cnt: unsigned(15 downto 0);
	signal cnt_reseed,next_cnt_reseed: unsigned(3 downto 0);
	signal cnt_chain,next_cnt_chain: unsigned(5 downto 0);
	signal lfsr_seed_i: std_logic_vector(N_LFSR-1 downto 0);
	constant cnt_max: integer:= 100;
	constant cnt_chain_max: integer:= 47;
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
            else 
                currState <= nextState;
				cnt <= next_cnt;
				cnt_reseed <= next_cnt_reseed;
				cnt_chain <= next_cnt_chain;
            end if;
        end if;
    end process regs;

	reseeder: process (cnt_reseed)
	begin
		case (to_integer(cnt_reseed)) is
						when 0=>
							lfsr_seed_i<=x"0123456701234567";
						when 1=>
							lfsr_seed_i<=x"89ABCDEF89ABCDEF";
						when 2=>
							lfsr_seed_i<=x"4444555566667777";
						when 3=>
							lfsr_seed_i<=x"0123456789ABCDEF";
						when 4=>
							lfsr_seed_i<=x"CAFFEBADCAFFEBAD";
						when 5=>
							lfsr_seed_i<=x"DABEFFACDABEFFAC";
						when 6=>
							lfsr_seed_i<=x"FEDCBA9876543210";
						when 7=>
							lfsr_seed_i<=x"CAFFEBADDABEFFAC";
						when 8=>
							lfsr_seed_i<=x"0171318411CA2201";
						when 9=>
							lfsr_seed_i<=x"88889999AAAABBBB";
						when 10=>
							lfsr_seed_i<=x"CCCCDDDDDEEEEFFF"; 
						when 11=>
							lfsr_seed_i<=x"0000111122223333"; 
						when others=>
							lfsr_seed_i<=x"0123456701234567";
					end case;
	end process;

	LFSR_SEED <= lfsr_seed_i;
    
    comb: process(currState,TEST,MISR_OUT,cnt,cnt_reseed,cnt_chain)
    begin
        GO<='0';
		LFSR_LD<='0';
		TEST_SCAN_EN<='0';
        case currState is
            when S_Wait =>
				next_cnt <= cnt;
				next_cnt_reseed <= cnt_reseed;
				next_cnt_chain <= cnt_chain; 
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
				else
					next_cnt_chain <= (OTHERS=>'0');
					nextState<=S_Test;
				end if;
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
					GO<='1';
                    nextState<=S_Go;
                end if;
			when S_Reseed =>
                if(TEST = '0') then
                    nextState<=S_wait;
                else
					LFSR_LD<='1';					
					nextState<=S_capture;
				end if;
            when S_Go =>    
				GO<='1';
                if(MISR_OUT = GOLDEN_SIGNATURE) then
					nextState<=S_GoTrue;
				else
					nextState<=S_wait;
                end if;
            when S_GoTrue =>    
				GO<='1';
				nextState<=S_wait;
            when others =>
                nextState<=S_wait;
        end case;
    end process comb;
    
end architecture rtl;
