----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2025 12:44:23 PM
-- Design Name: 
-- Module Name: ssd - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssd is
    Port ( CLK : in STD_LOGIC;
           DIGIT0 : in STD_LOGIC_VECTOR (3 downto 0);
           DIGIT1 : in STD_LOGIC_VECTOR (3 downto 0);
           DIGIT2 : in STD_LOGIC_VECTOR (3 downto 0);
           DIGIT3 : in STD_LOGIC_VECTOR (3 downto 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0);
           CAT : out STD_LOGIC_VECTOR (6 downto 0));
end ssd;

architecture Behavioral of ssd is
signal cnt :std_logic_vector(15 downto 0):=(others => '0');
signal sel:std_logic_vector(1 downto 0);
signal digit_selected :std_logic_vector(3 downto 0);
begin
    ---CLK
    process(CLK)
    begin
        if rising_edge(CLK) then
            cnt <= cnt +1;
        end if;
        if cnt = x"ffff" then
            cnt<=x"0000";
        end if;
    end process;
    sel<=cnt(15 downto 14);
    ---MUX DIGITS
    process(SEL,DIGIT0,DIGIT1,DIGIT2,DIGIT3)
    begin
        case SEL is
            when "00"=>digit_selected <=DIGIT0;
            when "01"=>digit_selected <=DIGIT1;
            when "10"=>digit_selected <=DIGIT2;
            when "11"=>digit_selected <=DIGIT3;
            when others => digit_selected <= "0000";
        end case;
    end process;
    
    ---MUX ANOD
    process(SEL)
    begin
        case SEL is
            when "00" => AN <="1110";
            when "01" => AN <="1101";
            when "10" => AN <="1011";
            when "11" => AN <="0111";
            when others => AN <="1111";
        end case;
    end process;
    
    ---HEX TO 7 SEG
    process(DIGIT_SELECTED)
    begin
        case DIGIT_SELECTED is
            when "0000" => CAT <= "0000001"; -- 0
            when "0001" => CAT <= "1001111"; -- 1
            when "0010" => CAT <= "0010010"; -- 2
            when "0011" => CAT <= "0000110"; -- 3
            when "0100" => CAT <= "1001100"; -- 4
            when "0101" => CAT <= "0100100"; -- 5
            when "0110" => CAT <= "0100000"; -- 6
            when "0111" => CAT <= "0001111"; -- 7
            when "1000" => CAT <= "0000000"; -- 8
            when "1001" => CAT <= "0000100"; -- 9
            when "1010" => CAT <= "0001000"; -- A
            when "1011" => CAT <= "1100000"; -- B
            when "1100" => CAT <= "0110001"; -- C
            when "1101" => CAT <= "1000010"; -- D
            when "1110" => CAT <= "0110000"; -- E
            when "1111" => CAT <= "0111000"; -- F
            when others => CAT <= "1111111"; -- Blank display
        end case;
    end process;
end Behavioral;
