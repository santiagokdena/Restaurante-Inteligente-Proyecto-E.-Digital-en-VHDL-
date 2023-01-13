library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FPGA is --cambiarle el nombre
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
END entity;   

architecture Behavioral of FPGA is

signal sig_bus: std_logic_vector(9 downto 0);
signal sig_reset: std_logic;
signal sig_en: std_logic:='1';
signal sig_busy: std_logic;
signal sig_tecla: character;
signal sig_en_teclado: std_logic;
signal sig_alert: std_logic;
signal sig_btn_rd: std_logic;
signal sig_r_data: std_logic_vector(7 downto 0);
signal sig_enable_motor: std_logic:='0'; 
signal sig_state_bluetooth: std_logic;
signal sig_cant_ham,sig_cant_per,sig_cant_pi: integer;
signal w_data:std_logic_vector (7 downto 0);
signal btn_wr: std_logic;
begin

buzz: entity work.buzzer
    port map(clk=>clk,enable=>sig_alert,parlante1=>parlante_left,parlante2=>parlante_right);
lcd_driver: entity work.driver
    port map(clk=>clk,reset_n=>sig_reset,lcd_enable=>sig_en,lcd_bus=>sig_bus,rw=>rw,rs=>rs,e=>e,lcd_data=>lcd_data,busy=>sig_busy);
u_logic: entity work.logic
    port map(clk=>clk,lcd_busy=>sig_busy,lcd_enable=>sig_en,lcd_bus=>sig_bus,lcd_reset=>sig_reset,en_teclado=>sig_en_teclado,tecla=>sig_tecla,alert_buzz=>sig_alert,enable_motor=>sig_enable_motor,state_bluetooth=>sig_state_bluetooth,cant_ham=>sig_cant_ham,cant_per=>sig_cant_per,cant_pi=>sig_cant_pi);   
uut_keypad: entity work.teclado_m 
    PORT MAP(CLK=>clk,COLUMNAS=>Col_Pins,FILAS=>Row_Pins,BOTON_PRES=>sig_tecla,IND=>sig_en_teclado);  

controlador_bluetooth : entity work.bluetooth_controller(Behavioral)
port map (clk=>clk,reset=> bluetooth_reset,btn_rd=>sig_btn_rd,btn_wr=>btn_wr,rx=>rx,w_data=>w_data,tx_full=>tx_full,rx_empty=>rx_empty,tx => tx,r_data=>sig_r_data);          
       
--fsm_bluetooth : entity work.bluetooth_manager(RTL)
--Port map (clk          => clk,rx => rx,r_data=> sig_r_data,          
--          busy         => sig_busy,          
--          lcd_enable   => sig_en,
--          btn_rd       => sig_btn_rd,
--          lcd_bus      => sig_bus,
--          state_bluetooth => sig_state_bluetooth,
--          cant_ham=>sig_cant_ham, 
--          cant_per=>sig_cant_per, 
--          cant_pi=>sig_cant_pi
--          );
uut_motor : entity work.pwm(Behavioral)
Port map (clk=> clk,enable=>sig_enable_motor,salida=>salida); --entrada

end Behavioral;