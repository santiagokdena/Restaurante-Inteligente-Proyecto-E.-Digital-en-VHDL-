library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity memoria is
PORT
   (
         CLK,w_enable: in STD_LOGIC;
         in_cant_ham,in_cant_pi,in_cant_per: in integer ;
         out_cant_ham,out_cant_pi,out_cant_per: out character;
         alert: out std_logic;
         turno_in: out character;
         turno_out: out character
   );
end memoria;


architecture Behavioral of memoria is
signal sig_out_cant_ham:integer; 
signal sig_out_cant_pi:integer; 
signal sig_out_cant_per:integer; 
component  ram IS
   PORT
   (
         CLK,w_enable: IN STD_LOGIC;
         in_cant_ham,in_cant_pi,in_cant_per: in integer ;
         out_cant_ham,out_cant_pi,out_cant_per: out character;
         alert: out std_logic;
         turno_in: out character;
         turno_out: out character
   );
end component;



begin
uut: ram 

port map(CLK=>CLK,w_enable=>w_enable,in_cant_ham=>in_cant_ham,in_cant_pi=>in_cant_pi,in_cant_per=>in_cant_per,out_cant_ham=>out_cant_ham,out_cant_pi=>out_cant_pi,out_cant_per=>out_cant_per,alert=>alert,turno_in=>turno_in,turno_out=>turno_out);

end Behavioral;
