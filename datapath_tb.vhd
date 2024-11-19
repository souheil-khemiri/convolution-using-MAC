library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_tb is
end entity;

architecture rtl of datapath_tb is
    component datapath is
        generic (
            filter0 : integer;
            filter1 : integer;
            filter2 : integer
        );
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            sel      : in std_logic_vector(1 downto 0);
            data_in  : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0) 
        );
    end component;
signal clk : std_logic;
signal rst : std_logic;
signal sel : std_logic_vector(1 downto 0);
signal data_in : std_logic_vector(7 downto 0);
signal data_out :std_logic_vector(7 downto 0);

begin

    datapath_inst: datapath
     generic map(
        filter0 => -1,
        filter1 => 0,
        filter2 => 1
    )
     port map(
        clk => clk,
        rst => rst,
        sel => sel,
        data_in => data_in,
        data_out => data_out
    );

    clk_proc : process 
    begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns ;
    end process;

    simproc : process 
    begin
        rst <= '1';
        wait for 2 ns;
        rst<='0';
        sel<= "00";
        wait for 2 ns ;
        data_in<="00000010"; --input value 2
        wait for 10 ns;
        sel <= "01";
        wait for 10 ns ;
        sel <= "10";
        wait;

        
    end process;

    

end architecture;