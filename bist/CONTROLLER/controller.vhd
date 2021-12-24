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
        MISR_OUT: in std_logic_vector(N_MISR-1 downto 0);
        GO, TPG_ODE_MUX_en: out std_logic
    );
end entity controller;

architecture rtl of controller is
    type StateType is (S_init, S_Wait, S_Test, S_Go);
    signal currState, nextState: StateType;
begin
    
    regs: process(clk)
    begin
        if (rising_edge(clk)) then
            if rst='1' then
                currState<=S_init;
            else 
                currState<=nextState;
            end if;
        end if;
    end process regs;
    
    comb: process(currState,TEST,MISR_OUT)
    begin
        GO<='0';
        TPG_ODE_MUX_en<='0'; -- normal inputs/ LFSR and MISR disabled
        case currState is
            when S_init =>
                nextState<=S_Wait;
            when S_Wait => 
                if(TEST = '1') then
                    nextState<=S_Test; 
                else
                    nextState<=S_wait;
                end if;
            when S_Test =>
                TPG_ODE_MUX_en<='1'; -- test inputs/ LFSR and MISR enabled
                if(TEST = '0') then
                    nextState<=S_wait;
                elsif(TEST = '1' and MISR_OUT = GOLDEN_SIGNATURE) then
                    nextState<=S_Go;
                else 
                    nextState<=S_Test;
                end if;
            when S_Go => 
                GO<='1';
                TPG_ODE_MUX_en<='1'; -- test inputs/ LFSR and MISR enabled
                if(TEST = '0') then
                    nextState<=S_wait;
                elsif(TEST = '1' and MISR_OUT = GOLDEN_SIGNATURE) then
                    nextState<=S_Go;
                else 
                    nextState<=S_Test;
                end if;
            when others =>
                nextState<=S_init;
        end case;
    end process comb;
    
end architecture rtl;