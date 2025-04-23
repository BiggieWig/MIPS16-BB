
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity instr_dec is
Port ( Instr: in std_logic_vector(15 downto 0);
       WD: in std_logic_vector(15 downto 0);
       clock: in std_logic;
       RegWrite: in std_logic;
       RegDst: in std_logic;
       ExtOP: in std_logic;
       RD1,RD2,Ext_Imm: out std_logic_vector(15 downto 0);
       func:out std_logic_vector(2 downto 0);
       sa: out std_logic
);
end instr_dec;

architecture Behavioral of instr_dec is
component RegisterFile is
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
end component;
signal writeAdr : std_logic_vector(2 downto 0);
begin
writeAdr <= Instr(6 downto 4) when RegDst = '1' else Instr(9 downto 7);
reg_file: RegisterFile port map(clk => clock,
                                regWrite => RegWrite,
                                readReg1 => Instr(12 downto 10),
                                readReg2 => Instr(9 downto 7),
                                writeReg => writeAdr,
                                writeData => WD,
                                readData1 => RD1,
                                readData2 => RD2);
process(Instr, ExtOP)
begin
 func <= Instr(2 downto 0);
 sa <= Instr(3);
 if ExtOP = '1' then
     if Instr(6) = '1' then
        Ext_Imm <="111111111" & Instr(6 downto 0);
     else
        Ext_Imm <="000000000" & Instr(6 downto 0);
     end if;
 else
    Ext_Imm <="000000000" & Instr(6 downto 0);
 end if;
end process;
end Behavioral;
