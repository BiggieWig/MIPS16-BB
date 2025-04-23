library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
    Port (
        A    : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input A
        B    : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit input B
        Cin  : in  STD_LOGIC;
        MPG_ENABLE: IN std_logic;                -- MPG button input
        SUM  : out STD_LOGIC_VECTOR(7 downto 0);  -- Output result
        Cout : out STD_LOGIC                      -- Carry-out
    );
end alu;

architecture Behavioral of alu is
    signal temp : STD_LOGIC_VECTOR(8 downto 0); -- 9-bit temp for carry calculation
    signal SEL  : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Default operation
begin
    process(A, B, Cin, MPG_ENABLE)
    begin
        if rising_edge(MPG_enable) then
            SEL <= SEL + 1;  
        end if;

        case SEL is
            when "00" =>  -- Addition (A + B + Cin)
                temp  <= ('0' & A) + ('0' & B) + ("0000000" & Cin);
                SUM   <= temp(7 downto 0);
                Cout  <= temp(8);

            when "01" =>  -- Subtraction (A - B - Cin)
                temp  <= ('0' & A) - ('0' & B) - ("0000000" & Cin);
                SUM   <= temp(7 downto 0);
                Cout  <= temp(8);  -- Borrow flag (if set, subtraction underflow)

            when "10" =>  -- Shift Left 2 bits
                SUM   <= A(5 downto 0) & "00"; -- Shift left by 2, filling LSBs with 0
                Cout  <= '0';

            when others =>  -- Shift Right 2 bits
                SUM   <= "00" & A(7 downto 2); -- Shift right by 2, filling MSBs with 0
                Cout  <= '0';
        end case;
    end process;
end Behavioral;
