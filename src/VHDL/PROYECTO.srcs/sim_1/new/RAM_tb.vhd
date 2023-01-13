library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAM_tb is
--  Port ( );
end RAM_tb;

architecture Behavioral of RAM_tb is
COMPONENT ram IS
   PORT
   (
         CLK,w_enable: IN STD_LOGIC;
         in_cant_ham,in_cant_pi,in_cant_per: in integer ;
         alert: out std_logic
   );
END COMPONENT ram;

--input
signal clk,w_enable: std_logic;
signal in_cant_ham,in_cant_pi,in_cant_per:integer;
--output
signal alert: std_logic;


begin
uut: ram
    port map(
      clk=>clk,
      w_enable=>w_enable,
      in_cant_ham=>in_cant_ham,
      in_cant_pi=>in_cant_pi,
      in_cant_per=>in_cant_per,
      alert=>alert
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
    in_cant_ham<=3;
    in_cant_pi<=4;
    in_cant_per<=5; 
    w_enable<='1';
    wait for 8ns;
    w_enable<='0';
    wait;
    end process;
    
end Behavioral;
