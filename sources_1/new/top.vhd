

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    Port ( switch : in STD_LOGIC_VECTOR (15 downto 0);
           btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           led : out STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is
component mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component alu is
    Port (
        A    : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input A
        B    : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input B
        Cin  : in  STD_LOGIC;
        MPG_ENABLE: IN std_logic;                -- MPG button input
        SUM  : out STD_LOGIC_VECTOR(7 downto 0);  -- Output result
        Cout : out STD_LOGIC                      -- Carry-out
    );
end component;

component ssd is
    Port ( CLK : in STD_LOGIC;
           DIGIT0 : in STD_LOGIC_VECTOR (3 downto 0);
           DIGIT1 : in STD_LOGIC_VECTOR (3 downto 0);
           DIGIT2 : in STD_LOGIC_VECTOR (3 downto 0);
           DIGIT3 : in STD_LOGIC_VECTOR (3 downto 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0));
end component;
signal clk_div: std_logic;
signal aluOut : std_logic_vector (15 downto 0);
begin

mpg1:mpg port map(clk =>clk ,btn =>btn,enable =>clk_div);

alu1:alu port map(
        A => switch(7 downto 0),
        B =>switch(15 downto 8),
        Cin => '0',
        MPG_ENABLE => clk_div,
        SUM => aluOut(7 downto 0),
        Cout => led);
aluOut <= "00000000" & aluOut(7 downto 0);
ssd1:ssd port map(CLK => clk,
                  DIGIT0 =>aluOut(3 downto 0),
                  DIGIT1 =>aluOut(7 downto 4),
                  DIGIT2 =>aluOut(11 downto 8),
                  DIGIT3 =>aluOut(15 downto 12),
                  AN => an,
                  CAT =>cat
);
end Behavioral;
