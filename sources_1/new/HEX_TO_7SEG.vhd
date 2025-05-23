library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HEX_TO_7SEG is
    Port (
        hex : in STD_LOGIC_VECTOR(15 downto 0);
        clk : in STD_LOGIC;
        cat : out STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0)
    );
end HEX_TO_7SEG;

architecture Behavioral of HEX_TO_7SEG is
    signal counter : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    signal outputMUX1SSD : STD_LOGIC_VECTOR(3 downto 0);
begin
   
    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;
    
   
    process(counter, hex)
    begin
        case counter(15 downto 14) is 
           when "00" => outputMUX1SSD <= hex(3 downto 0);
           when "01" => outputMUX1SSD <= hex(7 downto 4);
           when "10" => outputMUX1SSD <= hex(11 downto 8);
           when "11" => outputMUX1SSD <= hex(15 downto 12);
           when others => outputMUX1SSD <= "0000";  
          
       end case;
   end process;    

   
    process(counter)
    begin
        case counter(15 downto 14) is 
            when "00" => an <= "1110";  
            when "01" => an <= "1101";  
            when "10" => an <= "1011";  
            when "11" => an <= "0111";  
            when others => an <= "1111";  
           
        end case;
    end process;    

    
    with outputMUX1SSD select
        cat <=  "1000000" when "0000", -- 0
                "1111001" when "0001", -- 1
                "0100100" when "0010", -- 2
                "0110000" when "0011", -- 3
                "0011001" when "0100", -- 4
                "0010010" when "0101", -- 5
                "0000010" when "0110", -- 6
                "1111000" when "0111", -- 7
                "0000000" when "1000", -- 8
                "0010000" when "1001", -- 9
                "0001000" when "1010", -- A
                "0000011" when "1011", -- B
                "1000110" when "1100", -- C
                "0100001" when "1101", -- D
                "0000110" when "1110", -- E
                "0001110" when "1111", -- F
                "1111111" when others;  -- Off

end Behavioral;