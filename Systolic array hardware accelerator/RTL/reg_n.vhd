library ieee;
use ieee.std_logic_1164.all;

entity reg_n is
    generic (
        word : integer
    );
    port (
        clk   : in std_logic;
        arst_n: in std_logic;
        ce    : in std_logic;
        D     : in std_logic_vector( word-1 downto 0);
        Q     : out std_logic_vector( word-1 downto 0)
            );
end entity;

architecture rtl of reg_n is

begin

    process (arst_n,clk)
        
    begin
        if (arst_n = '0') then
            Q <=(others =>'0');
        elsif (clk ='1' and clk'event) then
            if(ce = '1') then
                Q <= D;
            end if;
        end if;

    end process;

end architecture;