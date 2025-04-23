library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
    Port (
        BTN    : in  STD_LOGIC;
        CLK    : in  STD_LOGIC;
        ENABLE : out STD_LOGIC
    );
end mpg;

architecture Behavioral of mpg is
    signal CNT : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Q1, Q2, Q3 : STD_LOGIC := '0';
begin

    -- Counter process (runs on every clock cycle)
    process(CLK)
    begin
        if rising_edge(CLK) then
            CNT <= CNT + 1;
        end if;
    end process;

    -- Sampling BTN only when CNT = x"FFFF"
    process(CLK)
    begin
        if rising_edge(CLK) then
            if CNT = x"000F" then
                Q1 <= BTN;
            end if;
        end if;
    end process;

    -- Synchronizing the signal through 2 flip-flops
    process(CLK)
    begin
        if rising_edge(CLK) then
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;

    -- Generate 1-cycle pulse on rising edge of sampled button
    ENABLE <= Q2 and not Q3;

end Behavioral;
