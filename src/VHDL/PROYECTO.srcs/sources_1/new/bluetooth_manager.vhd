library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bluetooth_manager is
Port (clk        : in    std_logic;
      rx         : in    std_logic;      
      r_data     : in    std_logic_vector(7 downto 0); 
      busy       : in    std_logic;
      lcd_enable : inout std_logic := '0'; 
      btn_rd     : out   std_logic;  
      lcd_bus    : out   std_logic_vector(9 downto 0);
      state_bluetooth: out std_logic;
      cant_ham :out integer;
      cant_per: out integer;
      cant_pi: out integer;
      ok : inout std_logic
      );
end bluetooth_manager;

architecture RTL of bluetooth_manager is
--signals
    signal count    : integer := 0;
    signal one_byte : integer := 117225;
    signal rd       : integer := 13025;
--FSM
    type states is (waiting, receive, read, save,sacar_paralelo);
    signal state: states;
    TYPE b_memory IS ARRAY(natural range<>) of std_logic_vector(7 DOWNTO 0); --memoria para los datos que se reciben del modulo bluetooth
    signal username: b_memory(0 to 20);
    signal ind_ent: integer range 0 to 20;
    signal ind_sal: integer range 0 to 20;
    signal vtemp: states:=save;
    signal cantidades: b_memory(0 to 2); 
    
function bin_to_int(i: std_logic_vector(7 downto 0))
    return integer  is
        begin 
            case i is 
            when "00110000"=> return 0;
            when "00110001"=> return 1;
            when "00110010"=> return 2;
            when "00110011"=> return 3;
            when "00110100"=> return 4;
            when "00110101"=> return 5;
            when "00110110"=> return 6;
            when "00110111"=> return 7;
            when "00111000"=> return 8;
            when "00111001"=> return 9;
            when others=> return 0;
        end case;
end bin_to_int;


begin

FSM: process(clk)
variable cont_ind:integer;
begin
    if clk'event and clk = '1' then
        case state is 
            when waiting =>
                if rx ='0' then
                    state <= receive; 
                    state_bluetooth<='1'; --señal que va a la logica. Bandera para saber el primer bit recibido
                end if;
            when receive =>
                state_bluetooth<='0';
                if count < one_byte then
                    count <= count + 1;
                else
                    count <= 0;
                    state <= read;
                end if;
            when read =>
                count  <= count + 1;
                btn_rd <= '1';
                if count = rd then
                    btn_rd <= '0';
                    count  <= 0;
                    state <= vtemp;
                end if;
            when save =>
                username(ind_ent)<=r_data;
                ind_ent<=ind_ent+1;
            when sacar_paralelo=>
                cantidades(ind_ent)<=r_data;
                ind_ent<=ind_ent+1;
                if ind_ent=3 then 
                    cant_ham<=bin_to_int(cantidades(0));
                    cant_pi<=bin_to_int(cantidades(1));
                    cant_per<=bin_to_int(cantidades(2));
                    cantidades<=(others=>(others=>'0'));
                    vtemp<=save;
                    ind_ent<=0;
                 end if; 
        end case;
    end if;
end process;
--POSIBLE ERROR AQUÍ
imprimir_lcd: process(clk)
begin
if clk'event and clk='1' then
        if ok='1' then 
            lcd_enable<='0';
            if ind_sal<=ind_ent then 
                if busy = '0' and lcd_enable = '0' then
                    lcd_enable <= '1';
                    lcd_bus <="10"&username(ind_sal);
                    ind_sal<=ind_sal+1;
                end if;
            elsif ind_sal=(ind_ent+1) then 
                vtemp<=sacar_paralelo;
                ok<='0';
                username<=(others=>(others=>'0'));--registro de toda la ram se resetea
                ind_ent<=0;
                ind_sal<=0;
            end if;
            
        end if;
end if;
end process;             
end RTL;
--identificar cuando se envía un número, si es así pasa a la RAM