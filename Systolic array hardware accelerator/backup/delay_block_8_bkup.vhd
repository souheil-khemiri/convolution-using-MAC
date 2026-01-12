--This is the initial design whre the first row is a pass through no delay
--this design has been causing asynchronisity in the rows and lines (x,0) and (0,y)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.types_pkg.all;

entity delay_block_8 is
    generic (
        block_size : integer
    );
    port (
        clk    : in std_logic;
        arst_n : in std_logic;
        ce     : in STD_LOGIC;
        D_array      : in  std_logic_vector_8_array(0 to block_size-1);
        Q_array      : out std_logic_vector_8_array(0 to block_size-1)         
    );
end entity;

architecture rtl of delay_block_8 is
    component reg_n is
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
    end component;

    -- Corrected range: Ensuring proper bounds for `shift_regs`
    type shift_reg_array is array (1 to block_size-1, 0 to block_size-2) of STD_LOGIC_VECTOR(7 downto 0);
    signal shift_regs : shift_reg_array;

begin

    -- First row bypass
    Q_array(0) <= D_array(0);     


    

    generate_delay_row : for i in 1 to block_size-1 generate
        generate_delay_column : for j in 0 to i generate
            -- First shift register in the row
            generate_j0 : if (j = 0) generate 
                delay_reg_j0 : entity work.reg_n(rtl)
                generic map (
                    word => 8
                )
                port map (
                    clk    => clk,
                    arst_n => arst_n,
                    ce     => ce,
                    D      => D_array(i),
                    Q      => shift_regs(i, j)
                );
            end generate generate_j0;

            -- Intermediate shift registers
            generate_j : if (j > 0 and j < i) generate
                delay_reg_j : entity work.reg_n(rtl)
                generic map (
                    word => 8
                )
                port map (
                    clk    => clk,
                    arst_n => arst_n,
                    ce     => ce,
                    D      => shift_regs(i, j-1),
                    Q      => shift_regs(i, j)
                );
            end generate generate_j;

            -- Final output assignment for each row
            generate_ji : if (j = i) generate
                delay_reg_ji : entity work.reg_n(rtl)
                generic map (
                    word => 8
                )
                port map (
                    clk    => clk,
                    arst_n => arst_n,
                    ce     => ce,
                    D      => shift_regs(i, j-1), -- Fixed indexing
                    Q      => Q_array(i)
                );
            end generate generate_ji;

        end generate generate_delay_column;
    end generate generate_delay_row;

end architecture;