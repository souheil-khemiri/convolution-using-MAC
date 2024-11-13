library ieee;
use ieee.std_logic_1164.all;

entity d_ff is
    port (
        clk   : in std_logic;
        rst   : in std_logic;
        D     : in std_logic;
        Q     : out std_logic
            );
end entity;

architecture rtl of d_ff is

begin

    process (rst,clk)
        
    begin
        if (rst = '1') then
            Q <='0';
        elsif (clk ='1' and clk'event) then
            Q <= D;
        end if;

    end process;

end architecture;


