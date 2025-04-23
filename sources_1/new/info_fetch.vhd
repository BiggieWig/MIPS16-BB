
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity info_fetch is
 Port ( 
        Jump:in std_logic;
        PCSrc:in std_logic;
        JumpAdr: in std_logic_vector(15 downto 0);
        BranchAdr:in std_logic_vector(15 downto 0);
        nextAdr: out std_logic_vector(15 downto 0);
        Instruction:out std_logic_vector(15 downto 0);
        clk:in std_logic
 );
end info_fetch;

architecture Behavioral of info_fetch is
signal pc_incr: std_logic_vector(15 downto 0);
signal pc: std_logic_vector(15 downto 0):=(others=>'0');
signal out1: std_logic_vector(15 downto 0);
type instr_array is array(0 to 255) of std_logic_vector(15 downto 0);
signal instr_memory: instr_array:=(
    0=> B"000_001_010_011_0_000", -- add $3, $1, $2
    1=> B"000_100_111_000_0_001", -- and $0, $4, $7
    2=> B"000_010_001_100_0_010", -- or  $4, $2, $1
    3=> B"000_011_101_001_0_011", -- sub $1, $3, $5
    4=> B"000_001_000_010_1_100", -- sll $2, $0, shift=1
    5=> B"000_001_101_111_1_101", -- srl $7, $5, shift=1
    6=> B"000_001_100_010_0_110", -- xor $2, $1, $4
    7=> B"000_111_010_011_0_111", -- nor $3, $7, $2
    8=> B"001_010_011_1010101",   -- addi $3, $2, 0x55
    9=> B"010_001_100_0001111",   -- lw   $4, 15($1)
    10=> B"011_100_101_0010000",  -- sw   $5, 16($4)
    11=> B"100_011_010_0000010",  -- beq  $3, $2, 0x02
    12=> B"101_001_110_0101010",  -- andi $6, $1, 0x2A
    13=> B"110_110_000_1101101",  -- ori  $0, $6, 0x6D
    14=> B"111_0000000000000",    -- j 0x0000
    others=> X"0000"
);
begin
pc_incr <= X"0000" when pc = X"000F" else pc +1;
nextAdr<= pc_incr;
out1 <= JumpAdr when Jump = '1' else
        BranchAdr when PCSrc = '1' else
        pc_incr;
process(clk)
begin
   if rising_edge(clk) then
        pc<= out1;
   end if;
end process;

Instruction <= instr_memory(to_integer(unsigned(pc(7 downto 0))));

end Behavioral;
