
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
Port (
    btn: in STD_LOGIC;
    clk: in STD_LOGIC;
    cat1: out STD_LOGIC_VECTOR(6 downto 0);
    an1: out STD_LOGIC_VECTOR(3 downto 0);
    options : in STD_LOGIC_VECTOR(2 downto 0); 
    leds : out STD_LOGIC_VECTOR(7 downto 0)
);

end test_env;

architecture Behavioral of test_env is

component mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component info_fetch is
 Port ( 
        Jump:in std_logic;
        PCSrc:in std_logic;
        JumpAdr: in std_logic_vector(15 downto 0);
        BranchAdr:in std_logic_vector(15 downto 0);
        nextAdr: out std_logic_vector(15 downto 0);
        Instruction:out std_logic_vector(15 downto 0);
        clk:in std_logic
 );
end component;

component main_control is
    Port (
        opcode    : in std_logic_vector(2 downto 0);
        RegDst    : out std_logic;
        ExtOp     : out std_logic;
        ALUSrc    : out std_logic;
        Branch    : out std_logic;
        Jump      : out std_logic;
        ALUOp     : out std_logic_vector(2 downto 0);
        MemWrite  : out std_logic;
        MemtoReg  : out std_logic;
        RegWrite  : out std_logic
    );
end component;

component instr_dec is
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
end component;
component execution_unit is
  Port ( 
        ALUSrc, sa         : in std_logic;
        pc_incr            : in std_logic_vector(15 downto 0);
        RD1, RD2, Ext_Imm  : in std_logic_vector(15 downto 0);
        func, ALUOp        : in std_logic_vector(2 downto 0);
        BranchAdr          : out std_logic_vector(15 downto 0);
        ALURes             : out std_logic_vector(15 downto 0);
        Zero               : out std_logic
  );
end component;

component MemoryUnit is
Port ( clk:in std_logic;
       MemWrite: in std_logic;
       ALURes,RD2:in std_logic_vector(15 downto 0);
       MemData:out std_logic_vector(15 downto 0)
 );
end component;
component HEX_TO_7SEG is
    Port (
        hex : in STD_LOGIC_VECTOR(15 downto 0);
        clk : in STD_LOGIC;
        cat : out STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;
signal HexTo7seg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal MPG_out : std_logic := '0';

-- IF
signal IF_instruction : std_logic_vector(15 downto 0) := (others => '0');
signal IF_nextAdr : std_logic_vector(15 downto 0):= (others =>'0');
signal IF_JumpAdr : std_logic_vector(15 downto 0) := (others => '0');
signal IF_PCSrc : std_logic := '0';

-- EX
signal EX_BranchAdr : std_logic_vector(15 downto 0) := (others => '0');
signal EX_Zero : std_logic := '0';
signal EX_ALURes : std_logic_vector(15 downto 0) := (others => '0');

-- MC
signal MC_Branch : std_logic := '0';
signal MC_Jump : std_logic := '0';
signal MC_opcode : std_logic_vector(2 downto 0) := (others => '0');
signal MC_RegDst : std_logic := '0';
signal MC_ExtOp : std_logic := '0';
signal MC_ALUSrc : std_logic := '0';
signal MC_ALUOp : std_logic_vector(2 downto 0) := (others => '0');
signal MC_MemWrite : std_logic := '0';
signal MC_MemtoReg : std_logic := '0';
signal MC_RegWrite : std_logic := '0';

-- ID
signal ID_RD1, ID_RD2, ID_Ext_Imm, ID_WD : std_logic_vector(15 downto 0) := (others => '0');
signal ID_func : std_logic_vector(2 downto 0) := (others => '0');
signal ID_sa : std_logic := '0';

-- MEM
signal MEM_MemData : std_logic_vector(15 downto 0) := (others => '0');

begin

Counting:mpg port map(
        clk =>clk,
        btn =>btn,
        enable =>MPG_out
);


IF_JumpAdr <=  IF_nextAdr(15 downto 14) & IF_instruction(12 downto 0) & '0';
IF_PCSrc <= MC_Branch and EX_Zero;
Instruction_Fetch:info_fetch port map(
        Jump =>MC_Jump,
        PCSrc =>IF_PCSrc,
        JumpAdr =>IF_JumpAdr,
        BranchAdr=>EX_BranchAdr,
        nextAdr=> IF_nextAdr,
        Instruction=>IF_instruction,
        clk=>MPG_out
);
MC:main_control port map(
        opcode  =>IF_instruction(15 downto 13),
        RegDst  =>MC_RegDst,
        ExtOp   =>MC_ExtOp,
        ALUSrc  =>MC_ALUSrc,
        Branch  =>MC_Branch,
        Jump    =>MC_Jump, 
        ALUOp   =>MC_ALUOp, 
        MemWrite=>MC_MemWrite, 
        MemtoReg=>MC_MemtoReg,
        RegWrite=>MC_RegWrite
);
ID_WD <= MEM_MemData when MC_MemtoReg = '1' else EX_ALURes;
ID:instr_dec port map(
       Instr =>IF_instruction,
       WD =>ID_WD,
       clock =>MPG_out,
       RegWrite =>MC_RegWrite,
       RegDst =>MC_RegDst,
       ExtOP =>MC_ExtOp,
       RD1 =>ID_RD1,
       RD2 =>ID_RD2,
       Ext_Imm =>ID_Ext_Imm,
       func =>ID_func,
       sa =>ID_sa
);
EX:execution_unit port map(
       ALUSrc =>MC_ALUSrc, 
       sa=>ID_sa,
       pc_incr=>IF_nextAdr,
       RD1=>ID_RD1, 
       RD2=>ID_RD2, 
       Ext_Imm=>ID_Ext_Imm,
       func=>ID_func, 
       ALUOp=>MC_ALUOp,
       BranchAdr=>EX_BranchAdr,
       ALURes=>EX_ALURes,
       Zero=>EX_Zero
);
MEM:MemoryUnit port map(
       clk =>MPG_out,
       MemWrite =>MC_MemWrite,
       ALURes =>EX_ALURes,
       RD2 =>ID_RD2,
       MemData =>MEM_MemData
);

HexTo7seg <=IF_instruction when options = "000" else
            IF_nextAdr when options = "001" else
            ID_RD1 when options = "010" else
            ID_RD2 when options = "011" else
            ID_Ext_Imm when options = "100" else
            EX_ALURes when options = "101" else
            MEM_MemData when options = "110" else
            ID_WD when options = "111";
SSD:HEX_TO_7SEG port map(
            hex => HexTo7seg,
            clk => clk,
            cat => cat1,
            an => an1
);

leds <= (MC_RegDst & MC_ExtOp & MC_ALUSrc & MC_Branch & MC_Jump & MC_MemWrite & MC_MemtoReg & MC_RegWrite) when options(0) = '0' else
        ("00000" & MC_ALUOp);

end Behavioral;
