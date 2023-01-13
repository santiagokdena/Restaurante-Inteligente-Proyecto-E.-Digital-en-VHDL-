LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
ENTITY ram IS
   PORT
   (
         CLK,w_enable: IN STD_LOGIC;
         in_cant_ham,in_cant_pi,in_cant_per: in integer ;
         out_cant_ham,out_cant_pi,out_cant_per: out character;
         alert: out std_logic;
         turno_in: out character;
         turno_out: out character
   );
--poner el deco aqui para turno y out_cant
END ram;
   ARCHITECTURE behavorial OF ram IS
   TYPE array_food is array(0 to 2) of integer;
   TYPE mem IS ARRAY(0 to 9) OF array_food;
   SIGNAL ram_block : mem:=(others=>(0,0,0));
   signal cont: integer:=0;
   signal busy: std_logic:='0';
   constant t_ham:INTEGER:=1250000000; --10seg
   constant t_per:INTEGER:=625000000;--5seg
   constant t_pi: INTEGER:=375000000;--3 seg
function int_to_char(i: integer range 0 to 9)
return character is
    begin 
        case i is 
        when 0=> return '0';
        when 1=> return '1';
        when 2=> return '2';
        when 3=> return '3';
        when 4=> return '4';
        when 5=> return '5';
        when 6=> return '6';
        when 7=> return '7';
        when 8=> return '8';
        when 9=> return '9';
    end case;
end int_to_char;
BEGIN
   PROCESS (clk)
   variable in_address:INTEGER:=0;
   variable out_address:INTEGER:=0;
   BEGIN
      IF (clk'event AND clk = '1') THEN
         alert<='0';
        IF (w_enable = '1') THEN
            ram_block(in_address) <= (in_cant_ham,in_cant_pi,in_cant_per);
            in_address:=in_address+1;
            turno_in<=int_to_char(in_address);
        END IF;
        IF busy<='0' then
            if ((ram_block(out_address) (0)/=0) or (ram_block(out_address) (1)/=0) or (ram_block(out_address) (2)/=0)) then 
                busy<='1';
            end if;
        else
            if (cont>(ram_block(out_address)(0)*t_ham)) and (cont>(ram_block(out_address)(1)*t_pi)) and (cont>(ram_block(out_address)(2)*t_per)) then
                busy<='0';
                cont<=0;
                turno_out<=int_to_char(out_address);
                out_cant_ham<=int_to_char(ram_block(out_address)(0));
                out_cant_pi<=int_to_char(ram_block(out_address)(1));
                out_cant_per<=int_to_char(ram_block(out_address)(2));
                out_address:=out_address+1;
                alert<='1';
             else 
                cont<=cont+1;
             end if;  
        end if;
        if in_address=10 then 
                in_address:=0;
        end if;
        if out_address=10 then 
            out_address:=0;
        end if;  
      END IF;
END PROCESS;


end behavorial;