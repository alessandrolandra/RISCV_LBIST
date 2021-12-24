library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity tb_controller is
end entity tb_controller;

architecture rtl of tb_controller is
    component controller is
        generic (
            GOLDEN_SIGNATURE : std_logic_vector(N_MISR-1 downto 0)
        );
        port (
            clk, rst, TEST : in std_logic;
            MISR_OUT: in std_logic_vector(N_MISR-1 downto 0);
            GO, TPG_ODE_MUX_en: out std_logic
        );
    end component controller;

    signal clk_s,rst_s,TEST_s,GO_s,TPG_ODE_MUX_en_s : std_logic;
    signal MISR_OUT_s : std_logic_vector(N_MISR-1 downto 0);
    constant clkper : time := 20 ns;
begin
    
    uut: controller 
    generic map (
        GOLDEN_SIGNATURE => "0101010100101010101001010101001010101010010101010010011010101010"
    )
    port map (
        clk=>clk_s,
        rst=>rst_s,
        TEST=>TEST_s,
        MISR_OUT=>MISR_OUT_s,
        GO=>GO_s,
        TPG_ODE_MUX_en=>TPG_ODE_MUX_en_s
    );
    
    clkgen: process 
    begin
        clk_s<='0';
        wait for clkper/2;
        clk_s<='1';
        wait for clkper/2;
    end process clkgen;

    testvect: process
    begin
        rst_s<='1'; TEST_s<='0'; 
        MISR_OUT_s<="0100101010011100100010110001010100010010010101001010101001010010";
        wait for clkper;
        rst_s<='0';
        wait for 2*clkper;
        TEST_s<='1';
        wait for clkper;
        MISR_OUT_s<="0100100101010100101010010110010101001010101001010101010000100101";
        wait for clkper;
        MISR_OUT_s<="0100100101010100101010010110010101001010101001010101010000100101";
        wait for clkper;
        MISR_OUT_s<="0101010100101010101001010101001010101010010101010010011010101010";
        wait for clkper;
        TEST_s<='0';
        wait for clkper;
        wait;
    end process;

end architecture rtl;