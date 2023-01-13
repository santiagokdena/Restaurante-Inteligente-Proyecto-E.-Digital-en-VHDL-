library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity buzzer is
    Port ( clk : in  STD_LOGIC;
           enable : in std_logic;
           parlante1 : out  STD_LOGIC;
           parlante2:out std_logic
           );
end buzzer;

architecture Behavioral of buzzer is
signal cont: integer:=0;--contador para el tiempo de espera entre cada tono
constant per: integer:=125000000;
signal cont_frec: std_logic_vector (17 downto 0); --contador para la frecuencia del tono
constant cont_max: std_logic_vector :="10000100011100100100";--"100101000110100111";  -- fecuencia de MI
signal buzz: std_logic;
	begin  
	process (clk)
		begin
		if clk'event and clk= '1' then
            cont<=cont+1;
            if cont<per then
                  cont_frec <= cont_frec+1;
                  if cont_frec= cont_max then
				        cont_frec <=(others=>'0');
			      end if;
            elsif cont<(2*per) then
                 cont_frec<= (others=>'0');
            else
                cont<=0;
            end if;
         end if;
	end process;


	process (clk)
		begin
		if clk'event and clk= '1' then
            if enable= '1' then 
                buzz<= cont_frec(16);
            else 
                buzz <= '0';
            end if;
        end if;
        parlante1<=buzz;
        parlante2<=buzz;       
	end process;
	

end Behavioral;