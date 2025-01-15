library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_tb is
end entity;

architecture rtl of memory_tb is

    component memory is
        
        generic (
            adress_width : natural := 5 ;
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
    end component;
    -- generic values are limited in scope to the component declaration, they are not even accessible
    signal clk : std_logic;
    signal D,Q : std_logic_vector(7 downto 0);
    signal we, rst : std_logic;
    signal adrs : std_logic_vector(4 downto 0);
  

begin

    memory_inst : memory

    -- if you want to use the default generic values, omit the generic map clause

     port map(
        clk => clk,
        rst => rst,
        adrs => adrs,
        we => we,
        D => D,
        Q => Q
    );

    clkproc :process
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;      
    end process;


    simproc :process 
    begin


        rst <= '1';
        we <= '0';
        adrs <= (others => '0');
        D <= (others => '0');
        wait for 10 ns;
        
        rst <= '0';
        wait for 10 ns;
        
        -- Write to memory
        we <= '1';
        adrs <= "00001";
        D <= "00000001";
        wait for 10 ns;
        
        ------we <= '0';
        adrs <= "00010";
        D <= "00000010";
        wait for 10 ns;

        adrs <= "00011";
        D <= "00000011";
        wait for 10 ns;
        
        adrs <= "00100";
        D <= "00000100";
        wait for 10 ns;
        
        adrs <= "00101";
        D <= "00000101";
        wait for 10 ns;
        
        adrs <= "00110";
        D <= "00000110";
        wait for 10 ns;


        
        -- Read from memory
        we <= '0';
        adrs <= "00001";
        wait for 10 ns;

        adrs <= "00000";
        wait for 10 ns ;

        adrs <= "00010"; 
        wait for 10 ns;

        adrs <= "00011"; 
        wait for 5 ns;

        adrs <= "00100";
        --wait for 5 ns;
        
        wait;
    end process;
    

end architecture;
