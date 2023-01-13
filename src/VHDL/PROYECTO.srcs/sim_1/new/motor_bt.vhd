
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity motor_bt is
--  Port ( );
end motor_bt;



architecture Behavioral of motor_bt is
component pwm is
    PORT(
        clk    : IN  STD_LOGIC;
        salida : OUT STD_LOGIC;
        enable: IN std_logic
    );
end component pwm;
signal clk,salida,enable : std_logic;

begin

uut: pwm
    port map(
      clk=>clk,
      salida=>salida,
      enable=>enable
      );
stimulus_clk: process
    begin
        clk <= '0';
        wait for 4 ns;
        clk <= '1'; 
        wait for 4 ns;
    end process;      
stimulus: process
    begin   
    enable<='0';
    wait for 500ns;
    enable<='1';    
    wait for 200ns;
    enable<='0';
    wait;
    end process;
end Behavioral;
