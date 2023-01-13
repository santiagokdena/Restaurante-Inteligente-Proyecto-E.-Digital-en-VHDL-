library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity ejemplo_tb is
end ejemplo_tb;

architecture Behavioral of ejemplo_tb is

COMPONENT PRUEBA IS
  PORT(
      clk: in std_logic;
      rw, rs, e : OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      Col_Pins : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      Row_Pins : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      buzz:OUT std_logic
      ); --data signals for lcd
END COMPONENT;      
  
--input
signal clk: std_logic;
--output
signal rw,rs,e: std_logic;
signal lcd_data: std_logic_vector(7 downto 0);
signal Row_Pins:STD_LOGIC_VECTOR(3 DOWNTO 0);
signal Col_Pins:STD_LOGIC_VECTOR(3 DOWNTO 0);
signal buzz: std_logic;
begin 

uut: PRUEBA
    port map(
      clk=>clk,
      rw=>rw,
      rs=>rs,       
      e=>e,
      lcd_data=>lcd_data,
      Row_Pins=>Row_Pins,
      Col_Pins=>Col_Pins,
      buzz=>buzz
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
    wait for 8ms;
    Col_Pins<="1000";
    wait for 36ms;
    Col_Pins<="0100";
   -- wait for 2ms;
   -- Col_Pins<="1000";
   -- wait for 2ms;
   -- Col_Pins<="0010";
    wait;
    end process;

end Behavioral;

