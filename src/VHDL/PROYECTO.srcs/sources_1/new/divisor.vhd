library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all; 

entity divisor is
	port ( clk,rst:  in std_logic;
	       T: in std_logic_vector(27 downto 0);
	       q: out std_logic --1Hz pulse
           );
end divisor;

architecture Behavioral of divisor is

signal ee,qq : std_logic_vector(27 downto 0):=(others=>'0');
signal ovf    : std_logic; --overflow

begin

mux_add: 
  ee <= qq + 1  when ovf='0' else
        (others=>'0'); 
-- 125 [Hz]
ovf_com:				    
  ovf <= '1' when qq = T+1 else -- 125 [M] 7735940 (periodo 1seg)
         '0';   
pulse_com:
    q<= '1' when qq = T else '0'; --3b9aca0 (62.5M)
--registro (asincrono)
process(clk,rst) 
begin
    if rst='1' then
        qq<=(others=>'0'); 
    elsif clk'event and clk='1' then
        qq<=ee;
    else
        qq <= qq;
    end if;
end process;

end Behavioral;