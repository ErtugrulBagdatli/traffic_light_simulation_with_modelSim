library ieee;
use ieee.std_logic_1164.all;

entity T23_TrafficLights is
generic(clkFreqHz : integer);
port(
        clk         : in std_logic;
        nrst        : in std_logic;
        northRed    : out std_logic;
        northYellow : out std_logic;
        northGreen  : out std_logic;
        westRed     : out std_logic;
        westYellow  : out std_logic;
        westGreen   : out std_logic);

end entity;

architecture rtl of T23_TrafficLights is
    
    type tState is (NorthNext, StartNorth, North, StopNorth, 
                    WestNext, StartWest, West, StopWest);

    signal state   : tState;
    signal counter : integer range 0 to clkFreqHz * 60;

begin

    process(clk) is
        
        procedure stateChange(toState : tState; minutes : integer:=0; 
                              seconds : integer:=0) is 
        variable totalSeconds : integer;
        variable clkCycles    : integer;
        begin
            totalSeconds := seconds + minutes * 60;
            clkCycles    := totalSeconds * clkFreqHz - 1;
            if counter = clkCycles then
                counter <= 0;
                state   <= toState;
            end if;
            
        end procedure;
        
    begin
    
        if rising_edge(clk) then
            if nrst = '0' then
                state       <= NorthNext;
                counter     <= 0;
                northRed    <= '1';
                northYellow <= '0';
                northGreen  <= '0';
                westRed     <= '1';
                westYellow  <= '0';
                westGreen   <= '0';
            else
                northRed    <= '0';  
                northYellow <= '0';
                northGreen  <= '0';
                westRed     <= '0';
                westYellow  <= '0';
                westGreen   <= '0';
                
                counter <= counter +1;
                
                case state is
                
                    when NorthNext  =>
                        northRed <= '1';
                        westRed  <= '1';
                        stateChange(StartNorth, seconds =>5);
                        
                    when StartNorth =>
                        northRed <= '1';
                        northYellow <= '1';
                        westRed <= '1';
                        stateChange(North, seconds =>5);
                        
                    when North      =>  
                        northGreen <= '1';
                        westRed <= '1';
                        stateChange(StopNorth, minutes =>1);
                        
                    when StopNorth  =>
                        northYellow <= '1';
                        westRed <= '1';
                        stateChange(WestNext, seconds =>5);
                        
                    when WestNext   =>         
                        northRed <= '1';
                        westRed <= '1';
                        stateChange(StartWest, seconds =>5);
                        
                    when StartWest  =>
                        northRed <= '1';
                        westYellow <= '1';
                        westRed <= '1';
                        stateChange(West, seconds =>5);
                        
                    when West       =>
                        northRed <= '1';
                        westGreen <= '1';
                        stateChange(StopWest, minutes =>1);
                        
                    when StopWest  => 
                        northRed <= '1';
                        westYellow <= '1';
                        stateChange(NorthNext, seconds =>5);
                        
                    end case;
            end if;
        
        end if;
    end process;
    


end architecture;