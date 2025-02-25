library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity mem_buffer_tb is
end entity;

architecture rtl of mem_buffer_tb is

    component mem_buffer_n_row is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            
        );
    end component;
begin

    

end architecture;