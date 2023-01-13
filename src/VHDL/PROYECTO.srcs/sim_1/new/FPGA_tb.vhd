library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity FPGA_tb is
end FPGA_tb;

architecture Behavioral of FPGA_tb is

COMPONENT FPGA IS
  PORT(
      clk: in std_logic;
      --LCD
      rw, rs, e : OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      --TECLADO
      Row_Pins: OUT STD_LOGIC_VECTOR(3 DOWNTO 0); 
      Col_Pins : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      --BUZZER
      parlante_left: OUT std_logic;
      parlante_right: OUT std_logic;
            --BLUETOOTH
      bluetooth_reset: in std_logic;
     -- btn_wr: in std_logic;
      rx    : in  std_logic;
     -- w_data  : in  std_logic_vector (7 downto 0);
      tx_full: out std_logic;
      rx_empty : out std_logic;
      tx  : out std_logic;
      --MOTORREDUCTOR
      salida: out std_logic
      ); --data signals for lcd  
END COMPONENT;      
  
--input
signal clk: std_logic;
--output
signal rw,rs,e: std_logic;
signal lcd_data: std_logic_vector(7 downto 0);
signal Row_Pins:STD_LOGIC_VECTOR(3 DOWNTO 0);
signal Col_Pins:STD_LOGIC_VECTOR(3 DOWNTO 0);
signal PARLANTE_left: std_logic;
signal parlante_right: std_logic;
signal tx,rx,tx_full,rx_empty,salida,bluetooth_reset: std_logic;
begin 

uut: FPGA
    port map(
      clk=>clk,
      rw=>rw,
      rs=>rs,       
      e=>e,
      lcd_data=>lcd_data,
      Row_Pins=>Row_Pins,
      Col_Pins=>Col_Pins,
      PARLANTE_left=>PARLANTE_left,
      PARLANTE_right=>PARLANTE_right,
      tx=>tx,
      rx=>rx,
      rx_empty=>rx_empty,
      tx_full=>tx_full,
      bluetooth_reset=>bluetooth_reset
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
    wait for 2ms;
    Col_Pins<="1000";
    wait for 2ms;
    Col_Pins<="0010";
    wait;
    end process;

end Behavioral;