library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_a_adress_X_n_bit is
    generic (
        adress_bits : natural := 5; -- 2 **5 = 32
        word_bits : natural := 8
    );
    port (
        rst  : in std_logic;
        adrs : in std_logic_vector(((2**adress_bits)-1) downto 0);
        we   : in std_logic;
        D    : in std_logic_vector((word_bits-1) downto 0);
        Q    : out std_logic_vector((word_bits-1) downto 0)
    );
end entity;

architecture rtl of ram_a_adress_X_n_bit is

    subtype word is std_logic_vector(word_bits-1 downto 0); 
    type RAM is array (0 to (2** -1)) of word ;
    signal RAM32B : RAM ;
    
begin

    process (rst,adrs,D,we)
        variable adrs_index :=to_integer(unsigned(adrs));
    begin
        if (rst = '0') then
            RAM32B <=((others => "00000000") );
        elsif (we ='1') then
            RAM32B(adrs_index) <=D;
        end if;
        Q <= RAM32B(adrs_index);
            
        
    end process;

    

end architecture;
