-- This is a 16 bit Linear Feedback Shift Register
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity LFSR is 
  port( 
    CLK : in std_logic; 
    RESET : in std_logic; 
    LD : in std_logic; 
    EN : in std_logic; 
    DIN : in std_logic_vector (0 to N_LFSR-1); 
    PRN : out std_logic_vector (0 to N_LFSR-1); 
    ZERO_D : out std_logic);
end LFSR;

architecture RTL of LFSR is 
  signal t_prn : std_logic_vector(0 to N_LFSR-1);
begin
-- Continuous assignments :
  PRN <= t_prn;
  ZERO_D <= '1' when (t_prn = (N_LFSR-1 downto 0 => '0')) else '0';
-- LFSR process : 
  process(CLK,RESET) 
  begin 
    if RESET='1' then 
      t_prn <= std_logic_vector(to_unsigned(1,t_prn'length)); -- load 1 at reset 
    elsif rising_edge (CLK) then 
      if (LD = '1') then -- load a new seed when ld is active 
        t_prn <= DIN; 
      elsif (EN = '1') then -- shift when enabled 
        case N_LFSR is
          when 64 =>
            t_prn(0) <= t_prn(63) xnor t_prn(62) xnor t_prn(60) xnor t_prn(59);
            t_prn(1 to 63) <= t_prn(0 to 62); 
        
          when others => -- 16 bit
            t_prn(0) <= t_prn(15) xor t_prn(4) xor t_prn(2) xor t_prn(1);
            t_prn(1 to 15) <= t_prn(0 to 14); 
        
        end case;
      end if; 
    end if;
  end process;
end RTL;


