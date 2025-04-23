library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity execution_unit is
  Port ( 
        ALUSrc, sa         : in std_logic;
        pc_incr            : in std_logic_vector(15 downto 0);
        RD1, RD2, Ext_Imm  : in std_logic_vector(15 downto 0);
        func, ALUOp        : in std_logic_vector(2 downto 0);
        BranchAdr          : out std_logic_vector(15 downto 0);
        ALURes             : out std_logic_vector(15 downto 0);
        Zero               : out std_logic
  );
end execution_unit;

architecture Behavioral of execution_unit is
  signal second_operand : std_logic_vector(15 downto 0);
  signal result         : std_logic_vector(15 downto 0);
begin

  -- MUX: Choose between RD2 and Ext_Imm
  process(ALUSrc, RD2, Ext_Imm)
  begin
    if ALUSrc = '0' then
      second_operand <= RD2;
    else
      second_operand <= Ext_Imm;
    end if;
  end process;

  -- ALU Operation
  process(RD1, second_operand, sa, func, ALUOp)
    variable r1, r2 : signed(15 downto 0);
    variable res    : signed(15 downto 0);
  begin
    r1 := signed(RD1);
    r2 := signed(second_operand);
    res := (others => '0');
    Zero <= '0'; 

    case ALUOp is
      when "010" =>  -- R-type
        case func is
          when "000" => res := r1 + r2; -- add
          when "001" => res := r1 and r2; -- and
          when "010" => res := r1 or r2; -- or
          when "011" => res := r1 - r2; -- sub
          when "100" => res := shift_left(r2, 1); -- sll (1-bit shift)
          when "101" => res := shift_right(r2, 1); -- srl
          when "110" => res := r1 xor r2; -- xor
          when "111" => res := signed(not (std_logic_vector(r1) or std_logic_vector(r2))); -- nor
          when others => res := (others => '0');
        end case;

      when "000" => res := r1 + r2; -- addi ; lw ; sw
      when "001" =>              -- beq
        if r1 = r2 then
          Zero <= '1';
        else
          Zero <= '0';
        end if;
        res := r1 - r2;

      when "100" => res := r1 and r2; -- andi
      when "101" => res := r1 or r2;  -- ori
      when "111" => res := signed(Ext_Imm); -- jump 
      when others => res := (others => '0');
    end case;

    result <= std_logic_vector(res);
  end process;

  -- Outputs
  ALURes <= result;
  BranchAdr <= std_logic_vector(signed(pc_incr) + signed(Ext_Imm));

end Behavioral;
