library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity lcd_example_tb is
end lcd_example_tb;

architecture Behavioral of lcd_example_tb is

COMPONENT LCD IS
  PORT(
      clk,start       : IN  STD_LOGIC;  --system clock
      rw, rs, e : OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
END COMPONENT;      
  
--input
signal clk,start: std_logic;
--output
signal rw,rs,e: std_logic;
signal lcd_data: std_logic_vector(7 downto 0);

begin

uut: LCD
    port map(
      clk=>clk,
      start=>start,
      rw=>rw,
      rs=>rs,       
      e=>e,
      lcd_data=>lcd_data
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
    wait for 200ns;
    start<='1';
    wait for 10ns;
    start<='0';
    wait;
    end process;

end Behavioral;
