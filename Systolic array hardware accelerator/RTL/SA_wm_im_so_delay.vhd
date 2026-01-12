library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;


entity SA_wm_im_so_delay is
    generic (
        N : integer;  -- Number of rows in matrix A and C
        M : integer;  -- Number of columns in A and number or rows in B
        P : integer   -- Number of columns in matrix B and C
    );
    port (
        clk     : in  std_logic;
        arst_n   : in  std_logic;
        a : in std_logic_vector_8_array(0 to N-1);
        b : in std_logic_vector_8_array(0 to P-1);
        --mux ports
        sel_mux_acc : in std_logic_matrix( 0 to N-1, 0 to P-1);
        sel_mux_adder : in std_logic_matrix( 0 to N-1, 0 to P-1);
        --enable signals
        acc_en : in std_logic_matrix(0 to N-1, 0 to P-1); --array of ( 0 to N-1, 0 to P-1) STD_LOGIC;
        a_b_en : in std_logic_matrix(0 to N-1, 0 to P-1);
        -- delay enable signal
        delay_en : in std_logic;
        --output
        c_array : out std_logic_vector_16_array(0 to P-1)
    );
end entity;

architecture rtl of SA_wm_im_so_delay is
    signal a_delayed : std_logic_vector_8_array(0 to N-1);
    signal b_delayed : std_logic_vector_8_array(0 to P-1);

begin

    --delay_block_8 for a
    delay_a: delay_block_8
        generic map (
            block_size => N
        )
        port map (
            clk => clk,
            arst_n => arst_n,
            ce => delay_en,
            D_array => a,
            Q_array => a_delayed
        );

    --delay_block_8 for b
    delay_b: delay_block_8
        generic map (
            block_size => P
        )
        port map (
            clk => clk,
            arst_n => arst_n,
            ce => delay_en,
            D_array => b,
            Q_array => b_delayed
        );

    --SA_wm_im_so
    systolic_array: SA_wm_im_so
        generic map (
            N => N,
            M => M,
            P => P
        )
        port map (
            clk => clk,
            arst_n => arst_n,
            a => a_delayed,
            b => b_delayed,
            sel_mux_acc => sel_mux_acc,
            sel_mux_adder => sel_mux_adder,
            acc_en => acc_en,
            a_b_en => a_b_en,
            c_array => c_array
        );

    

end architecture;
