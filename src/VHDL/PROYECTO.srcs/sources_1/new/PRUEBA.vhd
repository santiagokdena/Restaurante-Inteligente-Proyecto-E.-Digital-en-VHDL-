library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRUEBA is 
  PORT(
      clk: in std_logic;
      rw, rs, e : OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
      Row_Pins: OUT STD_LOGIC_VECTOR(3 DOWNTO 0); 
      Col_Pins : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      parlante_left:OUT std_logic;
      parlante_right:OUT std_logic
      
      
      ); --data signals for lcd  
END entity;   

architecture Behavioral of PRUEBA is
component ejemplo IS
  PORT(
      clk,lcd_busy : IN  STD_LOGIC;  --system clock
      lcd_enable : INOUT STD_LOGIC;  
      lcd_reset: OUT std_logic:='0';
      lcd_bus: OUT std_logic_vector(9 downto 0);
      en_teclado: IN std_logic;
      tecla: IN character;
      buzz1:OUT std_logic;
      buzz2:OUT std_logic
      ); --data signals for lcd
END component ejemplo;
component driver IS
  PORT(
    clk        : IN   STD_LOGIC;                     --system clock
    reset_n    : IN   STD_LOGIC;                     --active low reinitializes lcd
    lcd_enable : IN   STD_LOGIC;                     --latches data into lcd controller
    lcd_bus    : IN   STD_LOGIC_VECTOR(9 DOWNTO 0);  --data and control signals
    busy       : OUT  STD_LOGIC := '1';              --lcd controller busy/idle feedback
    rw, rs, e  : OUT  STD_LOGIC;                     --read/write, setup/data, and enable for lcd
    lcd_data   : OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
END component  driver;
COMPONENT TECLADO_M is
        port ( 
                CLK        : IN  STD_LOGIC; 						  
                COLUMNAS   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); 
                FILAS 	   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); 
                BOTON_PRES : OUT character; 
                IND		   : OUT std_logic 
        );
end component  TECLADO_M;

signal sig_bus: std_logic_vector(9 downto 0);
signal sig_reset: std_logic;
signal sig_en: std_logic:='1';
signal sig_busy: std_logic;
signal sig_tecla:character;
signal sig_en_teclado: std_logic;
begin

lcd_driver: driver
    port map(clk=>clk,reset_n=>sig_reset,lcd_enable=>sig_en,lcd_bus=>sig_bus,rw=>rw,rs=>rs,e=>e,lcd_data=>lcd_data,busy=>sig_busy);
u_logic: ejemplo
    port map(clk=>clk,lcd_busy=>sig_busy,lcd_enable=>sig_en,lcd_bus=>sig_bus,lcd_reset=>sig_reset,en_teclado=>sig_en_teclado,tecla=>sig_tecla,buzz1=>parlante_left,buzz2=>parlante_right);
uut_keypad: teclado_m 
    PORT MAP(CLK=>clk,COLUMNAS=>Col_Pins,FILAS=>Row_Pins,BOTON_PRES=>sig_tecla,IND=>sig_en_teclado);  

end Behavioral;