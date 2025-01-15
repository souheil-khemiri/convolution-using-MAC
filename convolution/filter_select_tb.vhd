library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_select_tb is
end entity;

architecture rtl of filter_select_tb is
    component filter_select is
        generic (
            val0 : integer ;
            val1 : integer ;
            val2 : integer 
        );
        port (
            sel    : in std_logic_vector(1 downto 0);
            filter : out std_logic_vector(7 downto 0)
        );
    end component;

    signal sel    : std_logic_vector(1 downto 0);
    signal filter : std_logic_vector(7 downto 0);

begin
    
    filter_select_inst: filter_select
     generic map(
        val0 => 1,
        val1 => 0,
        val2 => -1
    )
     port map(
        sel => sel,
        filter => filter
    );

    simproc : process 
    begin
        wait for 5 ns;
        sel <= "10";
        wait for 5 ns;
        sel <= "00";
        wait for 5 ns ;
        sel <= "01";
        wait;
        
    end process;

    

end architecture;