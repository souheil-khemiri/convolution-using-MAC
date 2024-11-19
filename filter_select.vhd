library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_select is
    generic (
        val0 : integer ;
        val1 : integer ;
        val2 : integer 
    );
    port (
        sel    : in std_logic_vector(1 downto 0);
        filter : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of filter_select is

    type filters is array (0 to 2) of std_logic_vector(7 downto 0);
    signal filter_values : filters := (
        std_logic_vector(to_signed(val0,8)),
        std_logic_vector(to_signed(val1,8)),
        std_logic_vector(to_signed(val2,8)));
    
    

begin
    process(sel)
    begin
        case sel is
            when "00" =>
            filter <= filter_values(0);
            when "01" =>
            filter <= filter_values(1);
            when "10" =>
            filter <= filter_values(2);
                
            when others =>
                filter <= filter_values(0);
        end case;
    end process;
    

end architecture;
