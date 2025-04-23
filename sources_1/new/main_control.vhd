library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_control is
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
end main_control;

architecture Behavioral of main_control is
begin
    process(opcode)
    begin
        -- Default values
        RegDst    <= '0';
        ExtOp     <= '0';
        ALUSrc    <= '0';
        Branch    <= '0';
        Jump      <= '0';
        ALUOp     <= "000";
        MemWrite  <= '0';
        MemtoReg  <= '0';
        RegWrite  <= '0';

        case opcode is
            when "000" => -- R-type
                RegDst    <= '1';
                ALUSrc    <= '0';
                RegWrite  <= '1';
                ALUOp     <= "010"; 

            when "001" => -- addi
                RegDst    <= '0';
                ALUSrc    <= '1';
                ExtOp     <= '1';
                RegWrite  <= '1';
                ALUOp     <= "000";

            when "010" => -- lw
                RegDst    <= '0';
                ALUSrc    <= '1';
                ExtOp     <= '1';
                RegWrite  <= '1';
                MemtoReg  <= '1';
                ALUOp     <= "000";

            when "011" => -- sw
                ALUSrc    <= '1';
                ExtOp     <= '1';
                MemWrite  <= '1';
                ALUOp     <= "000";

            when "100" => -- beq
                Branch    <= '1';
                ALUOp     <= "001";

            when "101" => -- andi
                RegDst    <= '0';
                ALUSrc    <= '1';
                ExtOp     <= '0';
                RegWrite  <= '1';
                ALUOp     <= "100";

            when "110" => -- ori
                RegDst    <= '0';
                ALUSrc    <= '1';
                ExtOp     <= '0';
                RegWrite  <= '1';
                ALUOp     <= "101";

            when "111" => -- j
                Jump      <= '1';
                ALUOp <= "111";

            when others =>
                null;
        end case;
    end process;
end Behavioral;
