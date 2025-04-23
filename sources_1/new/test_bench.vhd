library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_bench is
end test_bench;

architecture behavior of test_bench is

    -- Component Declaration for the Unit Under Test (UUT)
    component test_env is
        Port (
            btn: in STD_LOGIC;
            clk: in STD_LOGIC;
            cat1: out STD_LOGIC_VECTOR(6 downto 0);
            an1: out STD_LOGIC_VECTOR(3 downto 0);
            options : in STD_LOGIC_VECTOR(2 downto 0); 
            leds : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Inputs to the UUT
    signal btn : STD_LOGIC := '0';  -- Button press (active low)
    signal clk : STD_LOGIC := '0';  -- Clock signal
    signal options : STD_LOGIC_VECTOR(2 downto 0) := "000";  -- Options input

    -- Outputs from the UUT
    signal cat1 : STD_LOGIC_VECTOR(6 downto 0);
    signal an1 : STD_LOGIC_VECTOR(3 downto 0);
    signal leds : STD_LOGIC_VECTOR(7 downto 0);
begin
    -- Clock generation process
generator:process
    begin
        -- Generate a clock with a period of 10 ns
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Instantiate the Unit Under Test (UUT)
uut: test_env Port map (
        btn => btn,
        clk => clk,
        cat1 => cat1,
        an1 => an1,
        options => options,
        leds => leds
    );

    -- Stimulus process for changing options and button press
stimulus: process
    begin
        -- Test case 1: Change options to "000", wait, then change to "001", then press button
        options <= "000";  -- Set options to "000"
        wait for 20 ns;
        options <= "001";  -- Set options to "001"
        wait for 20 ns;
        options <= "010";  -- Set options to "010"
        wait for 20 ns;
        options <= "011";  -- Set options to "011"
        wait for 20 ns;
        options <= "100";  -- Set options to "100"
        wait for 20 ns;
        options <= "101";  -- Set options to "101"
        wait for 20 ns;
        options <= "110";  -- Set options to "110"
        wait for 20 ns;
        options <= "111";  -- Set options to "111"
        wait for 20 ns;

        -- Press the button after reaching "111"
        btn <= '1';  -- Press the button
        wait for 20 ns;  -- Hold the button pressed
        btn <= '0';  -- Release the button
        wait for 20 ns;  -- Wait for the system to process

        -- Test case 2: Change options again after first button press, then press the button again
        options <= "000";  -- Set options to "000"
        wait for 20 ns;
        options <= "001";  -- Set options to "001"
        wait for 20 ns;
        options <= "010";  -- Set options to "010"
        wait for 20 ns;
        options <= "011";  -- Set options to "011"
        wait for 20 ns;
        options <= "100";  -- Set options to "100"
        wait for 20 ns;
        options <= "101";  -- Set options to "101"
        wait for 20 ns;
        options <= "110";  -- Set options to "110"
        wait for 20 ns;
        options <= "111";  -- Set options to "111"
        wait for 20 ns;

        -- Press the button again after reaching "111"
        btn <= '1';  -- Press the button
        wait for 20 ns;  -- Hold the button pressed
        btn <= '0';  -- Release the button
        wait for 20 ns;  -- Wait for the system to process

        -- End of test
        wait;
    end process;

end behavior;
