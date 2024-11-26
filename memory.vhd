library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    generic (
        adress_width : natural := 5; -- 2 **5 = 32
        word_width : natural := 8
    );
    port (
        clk  : in std_logic;
        rst  : in std_logic;
        adrs : in std_logic_vector((adress_width-1) downto 0);
        we   : in std_logic;
        D    : in std_logic_vector((word_width-1) downto 0);
        Q    : out std_logic_vector((word_width-1) downto 0)
    );
end entity;

architecture rtl of memory is

    type mem is array (0 to (2**adress_width -1)) of std_logic_vector(word_width-1 downto 0) ; 
    signal mem_block : mem ;
    
begin

    process (clk,rst)
        variable adrs_index : INTEGER;
    begin
        adrs_index := to_integer(unsigned(adrs));
        if (rst = '1') then
            mem_block <= (others => (others => '0'));
        elsif (clk'event and clk = '1' ) then
            if(we ='1') then
                mem_block(adrs_index) <= D;
            else
                Q <= mem_block(adrs_index);  
            end if;   
        end if;
        
    end process;
    
    

end architecture;
