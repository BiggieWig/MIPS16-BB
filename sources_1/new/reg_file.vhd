
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    Port (
        clk      : in  std_logic;
        regWrite : in  std_logic;
        readReg1 : in  std_logic_vector(2 downto 0);
        readReg2 : in  std_logic_vector(2 downto 0);
        writeReg : in  std_logic_vector(2 downto 0);
        writeData: in  std_logic_vector(15 downto 0);
        readData1: out std_logic_vector(15 downto 0);
        readData2: out std_logic_vector(15 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
    signal registers : reg_array := (
        0 => x"0001",  -- Register 0
        1 => x"0002",  -- Register 1
        2 => x"0003",  -- Register 2
        3 => x"0004",  -- Register 3
        4 => x"0005",  -- Register 4
        5 => x"0006",  -- Register 5
        6 => x"0007",  -- Register 6
        7 => x"0008"   -- Register 7
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if regWrite = '1' then
                registers(to_integer(unsigned(writeReg))) <= writeData;
            end if;
        end if;
    end process;

    readData1 <= registers(to_integer(unsigned(readReg1)));
    readData2 <= registers(to_integer(unsigned(readReg2)));
end Behavioral;