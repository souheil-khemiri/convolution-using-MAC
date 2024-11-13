library ieee;
use ieee.std_logic_1164.all;

entity accumulator_32_bit is
    generic (
        size_accu: natural := 32
    );
    port (
        clk   : in std_logic;
        rst   : in std_logic;
        D     : in std_logic_vector(31 downto 0);
        Q     : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of accumulator_32_bit is


    component d_ff is
        port (
            clk   : in std_logic;
            rst   : in std_logic;
            D     : in std_logic;
            Q     : out std_logic
        );
    end component;

begin

    gen_accumulator_32 : for i in (size_accu-1) downto 0 generate
        d_ff_n : d_ff
            port map (
                clk =>clk,
                rst =>rst,
                D =>D(i),
                Q =>q(i)
            );
    end generate;
    

end architecture;