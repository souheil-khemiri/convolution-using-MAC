library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.types_pkg.all;

entity delay_block_8_tb is
end entity;

architecture tb of delay_block_8_tb is
    component delay_block_8 is
        generic (
            block_size : integer := 4
        );
        port (
            clk    : in std_logic;
            arst_n : in std_logic;
            ce     : in std_logic;
            D_array : in std_logic_vector_8_array(0 to block_size-1);
            Q_array : out std_logic_vector_8_array(0 to block_size-1)
        );
    end component;

    signal clk    : std_logic ;
    signal arst_n : std_logic ;
    signal ce     : std_logic ;
    signal D_array : std_logic_vector_8_array(0 to 3);
    signal Q_array : std_logic_vector_8_array(0 to 3);

    constant clk_period : time := 10 ns;

begin
    -- Instantiate the delay block
    uut: delay_block_8
        generic map (
            block_size => 4
        )
        port map (
            clk => clk,
            arst_n => arst_n,
            ce => ce,
            D_array => D_array,
            Q_array => Q_array
        );

    -- Clock 
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- simproc
    stim_proc : process
    begin
        -- Reset the design
        arst_n <= '0';
        ce <= '0';
        wait for clk_period;



        --Apply test vectors
        arst_n <= '1';
        ce <= '1';
        D_array(0) <= x"01";
        D_array(1) <= x"02";
        D_array(2) <= x"03";
        D_array(3) <= x"04";
        wait for clk_period;

        D_array(0) <= x"05";
        D_array(1) <= x"06";
        D_array(2) <= x"07";
        D_array(3) <= x"08";
        wait for clk_period;

        D_array(0) <= x"09";
        D_array(1) <= x"0A";
        D_array(2) <= x"0B";
        D_array(3) <= x"0C";
        wait for clk_period;

        ce <='0';

        
        wait for 5 * clk_period;

        -- End simulation
        wait;
    end process;

end architecture;