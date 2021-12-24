library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;

entity tb_misr is
end entity tb_misr;

architecture rtl of tb_misr is
    component misr is
        generic (
            N : integer := 64;
            SEED : std_logic_vector(N_MISR downto 0)
        );
        port (
            clk, rst, EN_i : in std_logic;
            DATA_IN: in std_logic_vector(N-1 downto 0);
            SIGNATURE: out std_logic_vector(N-1 downto 0)
        );
    end component misr;
    signal clk_s, rst_s, EN_i_s : std_logic;
    signal DATA_IN_s, SIGNATURE_s : std_logic_vector(63 downto 0);

    constant clkper : time := 20 ns;
    constant SEED : std_logic_vector(N_MISR downto 0) := "10010010100100101010100100001010010101001011001011110010100101001";
begin
    
    uut: misr
    generic map (
        N=>64,
        SEED=>SEED
    )
    port map (
        clk=>clk_s,
        rst=>rst_s,
        EN_i=>EN_i_s,
        DATA_IN=>DATA_IN_s,
        SIGNATURE=>SIGNATURE_s
    );

    clk_gen: process
    begin
        clk_s<='0';
        wait for clkper/2;
        clk_s<='1';
        wait for clkper/2;
    end process;

    test_vect_gen: process 
    begin
        rst_s<='1';
        wait for clkper;
        rst_s<='0'; 
        EN_i_s<='1';
        DATA_IN_s<="1001010100101001010101010010101010100101010100100101000101010101";
        wait for clkper;
        DATA_IN_s<="1001010100110101010010100101011010100101010100100101001001010001";
        wait for clkper;
        DATA_IN_s<="1001010100101001010101010010101010100101010100100101000101010101";
        wait for clkper;
        DATA_IN_s<="0101001001001010100101010100101010001010101001100101001010010010";
        wait for clkper;
        DATA_IN_s<="1010010101001010101010010010101001010110010100001010010101010100";
        wait for clkper;
        EN_i_s<='0';
        DATA_IN_s<="0110101001010010100101000101010101001010100101010001010010010010";
        wait for clkper;
        EN_i_s<='1';
        DATA_IN_s<="1110010101010111110010101111100100000000111111100100101010100101";
        wait for clkper;
        DATA_IN_s<="0101010100111101010101111100101010000100101111101010100010100100";
        wait for clkper;
        wait;
    end process;
    
end architecture rtl;