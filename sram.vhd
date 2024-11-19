library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram is
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

architecture rtl of sram is

    subtype word is std_logic_vector(word_width-1 downto 0); 
    type RAM is array (0 to (2**adress_width -1)) of word ; 
    signal RAM32B : RAM ;
    
begin

    process (clk,rst)
        variable adrs_index : INTEGER;
    begin
        adrs_index := to_integer(unsigned(adrs));
        if (rst = '1') then
            RAM32B <= (others => (others => '0'));
        elsif (clk'event and clk = '1' ) then
            if(we ='1') then
                RAM32B(adrs_index) <= D;
            else
                Q <= RAM32B(adrs_index);  
            end if;   
        end if;
        
    end process;
    
    

end architecture;
