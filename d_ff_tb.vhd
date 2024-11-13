library ieee;
use ieee.std_logic_1164.all;

entity d_ff_tb is
end entity d_ff_tb;

architecture rtl of d_ff_tb is
    component d_ff is
        port (
            clk   : in std_logic;
            rst   : in std_logic;
            D     : in std_logic;
            Q     : out std_logic
        );
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
    signal D   : std_logic;
    signal Q   : std_logic;
    
    begin

        d_ff_inst : d_ff
        port map (
            clk => clk,
            rst => rst,
            D => D,
            Q => Q
        );
        clk_proc : process
        begin
            clk <= '1';
            wait for 5 ns ;
            clk <='0';
            wait for 5 ns;
        end process;

        simproc : process
        begin
            D <='1';
            wait for 7 ns ;
            rst <= '1';
            wait for 5 ns ;
            D <='0';
            rst<='0';
            wait for 5 ns ;
            D <='1';
            wait;
        end process;

end architecture;