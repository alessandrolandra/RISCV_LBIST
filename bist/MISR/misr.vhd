library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity misr is
    generic (
        N : integer := 64;
        SEED : std_logic_vector(N_MISR downto 0)
    );
    port (
        clk, rst, EN_i : in std_logic;
        DATA_IN: in std_logic_vector(N-1 downto 0);
        SIGNATURE: out std_logic_vector(N-1 downto 0)
    );
end entity misr;

architecture rtl of misr is
    signal xnors, reg_outs: std_logic_vector(N downto 0);

begin
    
    process (clk,rst)
    begin
        if rising_edge(clk) then
            if rst='1' then
                reg_outs<=SEED;
            elsif(EN_i = '1') then
                reg_outs(N downto 1)<=xnors(N-1 downto 0);
            end if;
        end if;
    end process;

    process (DATA_IN, reg_outs)
    begin
        for i in 0 to N-1 loop 
            if(i = 0) then
                xnors(i)<= reg_outs(N) xnor DATA_IN(i);
            else
                xnors(i) <= reg_outs(i) xnor DATA_IN(i);
                case N is
                    when 64 =>
                        if(i = 60 or i = 61 or i = 63) then
                            xnors(i) <= reg_outs(N) xnor DATA_IN(i) xnor reg_outs(i);
                        end if;
                    when others => -- 32 bit
                        if(i = 22 or i = 2 or i = 1) then
                            xnors(i) <= reg_outs(N) xnor DATA_IN(i) xnor reg_outs(i);
                        end if;
                end case;
            end if;
        end loop;
    end process;
    
    SIGNATURE<=reg_outs(N downto 1);

end architecture rtl;