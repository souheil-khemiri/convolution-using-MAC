library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity accumulator_32_bit_tb is
end entity;

architecture rtl of accumulator_32_bit_tb is
    component accumulator_32_bit is
        port (
            clk   : in std_logic;
            rst   : in std_logic;
            D     : in std_logic_vector(31 downto 0);
            Q     : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
    signal D   : std_logic_vector(31 downto 0);
    signal Q   : std_logic_vector(31 downto 0);

begin
    accumulator_32_bit_inst : accumulator_32_bit
    port map (
        clk  => clk,
        rst  => rst,
        D    => D,
        Q    => Q
    );

    clk_proc : process
    begin
        clk <= '1';
        wait for 5 ns ;
        clk <= '0';
        wait for 5 ns;
    end process;

    simproc : process
    variable int_val : INTEGER ;
    begin
        rst <= '1';
        wait for 1 ns;
        rst <='0';
        wait for 1 ns;
        int_val := (-1) ;
        D <= std_logic_vector(to_signed(int_val,32));
        wait for 11 ns ;
        int_val := (-2147483648);
        D <= std_logic_vector(to_signed(int_val,32));
        wait for 10 ns ;
        rst <= '1';
        wait;
    end process;
end;
