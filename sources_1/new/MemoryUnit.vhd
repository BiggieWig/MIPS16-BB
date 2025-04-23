
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemoryUnit is
Port ( clk:in std_logic;
       MemWrite: in std_logic;
       ALURes,RD2:in std_logic_vector(15 downto 0);
       MemData:out std_logic_vector(15 downto 0)
 );
end MemoryUnit;

architecture Behavioral of MemoryUnit is
type ram_type is array(0 to 255) of std_logic_vector(15 downto 0);
signal ram : ram_type :=(
    16 =>X"0012",
    21 =>X"1234",
    others =>X"0000");
begin
process(clk)
begin
    if rising_edge(clk) then 
        if MemWrite = '1' then 
            ram(to_integer(unsigned(ALURes(7 downto 0)))) <= RD2;
        end if;
    end if;
end process;
MemData <= ram(to_integer(unsigned(ALURes(7 downto 0))));
end Behavioral;
