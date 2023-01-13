library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity pwm is
    PORT(
        clk    : IN  STD_LOGIC;
        salida : OUT STD_LOGIC;
        enable: IN std_logic
    );
end pwm;
 
architecture Behavioral of pwm is
--    COMPONENT divisor IS
--	port ( clk,rst:  in std_logic;
--	       T: in std_logic_vector(27 downto 0);
--	       q: out std_logic --1Hz pulse
--           );
--    END COMPONENT;
     
--    COMPONENT motorreductor IS
--        PORT(
--            clk    : IN  STD_LOGIC;
--            reset  : IN  STD_LOGIC;
--            entrada: IN  integer;
--            salida : OUT STD_LOGIC
--        );
--    END COMPONENT;
--    signal clk_out : STD_LOGIC := '0';
begin 
process (clk)
begin
if clk'event and clk= '1' then
    if enable='1' then
         salida<='1';
    else 
          salida<='0';
    end if;
end if;
end process;
end Behavioral;