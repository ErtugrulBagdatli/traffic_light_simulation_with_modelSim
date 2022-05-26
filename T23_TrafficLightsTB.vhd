library ieee;
use ieee.std_logic_1164.all;

entity T23_TrafficLightsTB is
end entity;

architecture sim of T23_TrafficLightsTB is
    
    constant clkFreq    : integer   := 100;
    constant clkPeriod  : time      := 1000 ms / clkFreq;
    
    signal clk      : std_logic := '1';
    signal nrst     : std_logic := '0';
    
    signal northRed    : std_logic;
    signal northYellow : std_logic;
    signal northGreen  : std_logic;
    signal westRed     : std_logic;
    signal westYellow  : std_logic;
    signal westGreen   : std_logic;

begin

    i_TrafficLights : entity work.T23_TrafficLights(rtl)
    generic map(clkFreqHz => clkFreq)
    port map(
        clk         => clk,
        nrst        => nrst,
        northRed    => northRed,     
        northYellow => northYellow,
        northGreen  => northGreen, 
        westRed     => westRed,
        westYellow  => westYellow, 
        westGreen   => westGreen);
   
    clk <= not clk after clkPeriod/2;
   
    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        
        nrst <= '1';
        
        wait;
    end process;
    


end architecture;