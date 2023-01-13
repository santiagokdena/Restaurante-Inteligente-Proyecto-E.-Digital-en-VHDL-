LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ejemplo IS
  PORT(
      clk       : IN  STD_LOGIC;  --system clock
      lcd_busy : IN STD_LOGIC;
      lcd_enable : INOUT STD_LOGIC:='0';  
      lcd_reset: OUT std_logic:='1'; --activo en bajo
      lcd_bus: OUT std_logic_vector(9 downto 0);
      en_teclado: IN std_logic;
      tecla: IN character;
      buzz1:OUT std_logic;
      buzz2:OUT std_logic
      ); --data signals for lcd
END ejemplo;

ARCHITECTURE behavior OF ejemplo IS
    
COMPONENT divisor is
    port ( clk,rst:  in std_logic;
           T: in std_logic_vector(27 downto 0);
           q: out std_logic --1Hz pulse
           );
end component  divisor;

COMPONENT RAM is 
   PORT
   (
         CLK,w_enable: IN STD_LOGIC;
         in_cant_ham,in_cant_pi,in_cant_per: in integer ;
         out_cant_ham,out_cant_pi,out_cant_per: out character;
         alert: out std_logic;
         turno_in: out character;
         turno_out: out character
   );
end component RAM;
COMPONENT buzzer is
port ( clk : in std_logic;
       enable: in std_logic;
       parlante1     : out std_logic;
       parlante2     : out std_logic
		 );
END COMPONENT buzzer;

  type op is array (0 to 2) of integer;
  signal opciones: op:=(0, 0, 0); 
  signal op_food: INTEGER;
  signal clkdiv,w_enable,alert: std_logic;
  type states is (s0,s1,s2,s3,s4);
  signal state: states:=s0;
 -- signal signumchar:integer;
  signal turno_in,turno_out,out_cant_ham,out_cant_per,out_cant_pi: character;
  signal alert_buzz: std_logic:='0';
  type tstring is array(natural range<>) of character;
  constant Nmsj1: natural:=29;
  constant msj1: tstring(0 to Nmsj1-1):= "Bienvenido al restaurante H&S";
  constant Nmsj12:natural:=15;
  constant msj12: tstring(0 to Nmsj12-1):= "Haz tu pedido! ";
  constant Nfood:natural:=17;
  constant msj21: tstring(0 to Nfood-1):= "Elige la comida: ";
  constant msj22: tstring(0 to Nfood-1):= "1)Hamburguesa    ";
  constant msj23: tstring(0 to Nfood-1):= "2)Pizza          ";
  constant msj24: tstring(0 to Nfood-1):= "3)Perro Caliente "; 
  constant msj25: tstring(0 to Nfood-1):= "4)Enviar         "; 
  constant msj26: tstring(0 to Nfood-1):= "5)Salir          ";
  constant Nfood2:natural:=14;
  constant msj27: tstring(0 to Nfood2-1):= "Hamburguesas: "; 
  constant msj28: tstring(0 to Nfood2-1):= "   Perros:    ";
  constant msj29: tstring(0 to Nfood2-1):= "   Pizzas:    "; 
  
  constant Ncant:natural:=10;
  constant Nturn:natural:=6;
  constant msj31: tstring(0 to Ncant-1):= " Cantidad:";
  constant msj32: tstring(0 to Nturn-1):= "turno ";
  constant msj34: tstring(0 to Nfood-1):= "Recoge tu pedido!";
BEGIN
uut_RAM: RAM 
PORT MAP(clk=>clk,w_enable=>w_enable,in_cant_ham=>opciones(0),in_cant_per=>opciones(1),in_cant_pi=>opciones(2),alert=>alert,out_cant_ham=>out_cant_ham,out_cant_per=>out_cant_per,out_cant_pi=>out_cant_pi,turno_in=>turno_in,turno_out=>turno_out);
uut_buzz: buzzer
PORT MAP(clk=>clk,enable=>alert_buzz,parlante1=>buzz1,parlante2=>buzz2);

process(clk)
  VARIABLE numchar: INTEGER:= -2; --Nmsj2 es la cadena más larga
  variable dig: std_logic:='0';   
  --variable op_food: INTEGER range 0 to 2; ---variables con señales no se pueden juntar
  VARIABLE cant: INTEGER;
  constant per: integer:=200;--125000000; --tiempo de espera para el estado s2
  Variable pressed: std_logic:='0';
  begin
  if (clk'event and clk='1') then
       --AVISO
        w_enable<='0';
        case state is 
            when s0=>--opciones
                state<=s0;   
                lcd_reset<='1';
                if (lcd_busy='0' and lcd_enable='0') then     --se necesita obligatoriamente realimentación con lcd_enable para poder seguir enviando caracteres
                            lcd_enable<='1';
                            if  numchar=-2 then --limpia
                                lcd_bus<="0000000001";
                            elsif numchar=-1 then --reseta
                                lcd_reset<='0';
                            elsif numchar<Nfood then --mensaje parte superior
                                lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj21(numchar)),8));
                            elsif numchar=Nfood then 
                                lcd_bus<="0011000000"; --posiciona en la 2 linea, 1 columna
                            elsif numchar<(2*Nfood) then --hamburguesa
                                lcd_bus<="10"&std_logic_vector(to_unsigned(character'pos(msj22(numchar-(Nfood+1))),8));
                            elsif numchar<per then --espera
                                lcd_enable<='0';
                            elsif numchar=per then --posiciona
                                lcd_bus<="0011000000";
                            elsif numchar<(Nfood+per) then --pizza
                                lcd_bus<="10"&std_logic_vector(to_unsigned(character'pos(msj23(numchar-(per+1))),8));
                            elsif numchar<2*per then
                                lcd_enable<='0';
                            elsif numchar=2*per then --posiciona
                                lcd_bus<="0011000000";
                            elsif numchar<(Nfood+2*per) then --perro
                                lcd_bus<="10"&std_logic_vector(to_unsigned(character'pos(msj24(numchar-(2*per+1))),8)); 
                            elsif numchar<3*per then --espera
                                lcd_enable<='0';
                            elsif numchar=3*per then --posiciona
                                lcd_bus<="0011000000";
                            elsif numchar<(Nfood+3*per) then --enviar
                                lcd_bus<="10"&std_logic_vector(to_unsigned(character'pos(msj25(numchar-(3*per+1))),8)); 
                            elsif numchar<4*per then --espera
                                lcd_enable<='0';
                            elsif numchar=4*per then --posiciona
                                lcd_bus<="0011000000";
                            elsif numchar<(Nfood+4*per) then --salir
                                lcd_bus<="10"&std_logic_vector(to_unsigned(character'pos(msj26(numchar-(4*per+1))),8));     
                            elsif numchar<(5*per) then --espera
                                lcd_enable<='0'; 
                            else
                                numchar:=Nfood-1;   
                                lcd_enable<='0';
                            end if;
                            numchar:=numchar+1;
                else
                    lcd_enable<='0';
                end if;
                --if tecla_bluetooth....
                if tecla='1' or tecla='2' or tecla='3' then --si se escoge una opcion, se limpia pantalla
                    lcd_enable<='0';
                    numchar:=-2; 
                    state<=s1;
                    op_food<=(character'pos(tecla)); --arreglar!!!- para tecla=2,op_food=49.
                elsif tecla='5' then --salir
                    lcd_enable<='0';
                    state<=s2;
                elsif tecla='4' then --enviar
                    if opciones/=(0,0,0) then --diferente de
                        numchar:=-2;
                        state<=s3;
                    end if;
                end if;
                if alert='1' then 
                        state<=s4;
                        numchar:=-2;
                end if;
            when s1=>
                    state<=s1;   
                    lcd_reset<='1';
                    opciones(op_food)<=0;--default
                    --opciones : entradas del teclado
                    if (lcd_busy='0' and lcd_enable='0') then     
                            lcd_enable<='1';
                            if numchar=-2 then --limpia pantalla
                                lcd_bus<="0000000001";
                                numchar:=-1;
                            elsif numchar=-1 then --resetea
                                lcd_reset<='0';   
                                numchar:=0;                      
                            elsif (numchar<Ncant) then --"cantidad:"
                                lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj31(numchar)),8));
                                numchar:=numchar+1;
                            else
                                if dig='1' then  --mover cursor izquierda(corregir número)
                                    lcd_bus<="0010001010";
                                    dig:='0';
                                elsif en_teclado='1' then
                                    if tecla='E' then --enter(E)
                                        numchar:=-2;
                                        opciones(op_food)<=cant;
                                        lcd_enable<='0';
                                        state<=s0;
                                    else --digita numeros
                                        lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(tecla),8));
                                        cant:=character'pos(tecla);
                                        dig:='1';
                                    end if;
                                else
                                    lcd_enable<='0';
                                end if;
                            end if;
                    else
                        lcd_enable<='0';
                    end if;
                    if alert='1' then 
                        state<=s4;
                        numchar:=-2;
                    end if;
            when s2=>
                lcd_enable<='0';   
            when s3=>
             state<=s3;   
             lcd_reset<='1';
             if (lcd_busy='0' and lcd_enable='0') then     --se necesita obligatoriamente realimentación con lcd_enable para poder seguir enviando caracteres
                            lcd_enable<='1';
                            if  numchar=-2 then --limpia
                                lcd_bus<="0000000001";
                            elsif numchar=-1 then --reseta
                                lcd_reset<='0';
                            elsif numchar<Nturn then --turno; 
                                lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj32(numchar)),8));
                            elsif numchar=Nturn then 
                                lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(turno_in),8));
                            elsif numchar<(3*per) then
                                lcd_enable<='0';
                            elsif numchar=3*per then 
                                lcd_enable<='0';
                                w_enable<='1'; --enable de la ram
                            else 
                                lcd_enable<='0';
                                state<=s0; 
                                numchar:=-3; 
                                opciones<=(0,0,0); --se resetean las opciones
                            end if;
                            numchar:=numchar+1;
             else
                lcd_enable<='0';
             end if;
                if  alert='1' then 
                    state<=s4;
                    numchar:=-2;
                end if;
            when s4=>
                state<=s4; 
                lcd_reset<='1';
                alert_buzz<='1';
                    if (lcd_busy='0' and lcd_enable='0') then     --se necesita obligatoriamente retrialimentación con lcd_enable para poder seguir enviando caracteres
                             lcd_enable<='1';
                              if pressed<='0' then
                                  if  numchar =-2 then --limpia
                                     lcd_bus<="0000000001";
                                    elsif numchar=-1 then --reseta
                                         lcd_reset<='0';
                                    elsif numchar<Nfood then --mensaje parte superior
                                        lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj34(numchar)),8));
                                    elsif numchar=Nfood then --posiciona en la 2 linea, 1 columna
                                        lcd_bus<="0011000000"; 
                                    elsif numchar<(Nfood+Nturn) then --turno
                                            lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj32(numchar-(Nfood+1))),8)); 
                                    elsif numchar=(Nfood+Nturn) then --n
                                        lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(turno_out),8));    
                                    elsif numchar<(10*per) then --espera 7 seg
                                        lcd_enable<='0';
                                        if en_teclado='1' then 
                                            pressed:='1';
                                            numchar:=-3; 
                                            lcd_enable<='0';
                                        end if;
                                    else 
                                        alert_buzz<='0';
                                        numchar:=-3; --borra pantalla para el estado actual
                                        state<=s0;
                                        lcd_enable<='0';
                                    end if;
                              else
                                    alert_buzz<='0';
                                    if  numchar =-2 then --limpia
                                        lcd_bus<="0000000001";
                                    elsif numchar=-1 then --reseta
                                         lcd_reset<='0';
                                    elsif numchar<Nfood then --mensaje parte superior
                                        lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj34(numchar)),8));
                                    elsif numchar=Nfood then --posiciona en la 2 linea, 1 columna
                                        lcd_bus<="0011000000"; 
                                    elsif numchar<(Nfood+Nfood2) then --Hamburguesas
                                        lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj27(numchar-(Nfood+1))),8));
                                    elsif numchar=(Nfood+Nfood2) then --cantidad
                                        lcd_bus<= "10"&std_logic_vector(to_unsigned(character'pos(out_cant_ham),8));
                                    elsif numchar<(2*per) then --espera
                                        lcd_enable<='0';
                                    elsif numchar=2*per then --posiciona
                                        lcd_bus<="0011000000";
                                    elsif numchar<(2*per+Nfood2) then --Perros
                                        lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj28(numchar-(2*per+1))),8)); 
                                    elsif numchar=(2*per+Nfood2) then --cantidad
                                        lcd_bus<= "10"&std_logic_vector(to_unsigned(character'pos(out_cant_per),8));
                                    elsif numchar<(4*per) then --espera
                                        lcd_enable<='0';
                                    elsif numchar=(4*per) then --posiciona
                                        lcd_bus<="0011000000";
                                    elsif numchar<(4*per+Nfood2) then --Pizzas
                                        lcd_bus <= "10"&std_logic_vector(to_unsigned(character'pos(msj29(numchar-(4*per+1))),8)); 
                                    elsif numchar=(4*per+Nfood2) then --cantidad
                                        lcd_bus<= "10"&std_logic_vector(to_unsigned(character'pos(out_cant_pi),8));
                                    elsif numchar<(6*per) then --espera
                                        lcd_enable<='0';
                                    else
                                        lcd_enable<='0';
                                        state<=s0;
                                        numchar:=-3;   
                                        pressed:='0';                             
                                    end if;
                             end if;
                             numchar:=numchar+1;
                    else    
                        lcd_enable<='0';
                    end if;
          end case;
       --  signumchar<=numchar;
       end if;
       
end process; 
END behavior;