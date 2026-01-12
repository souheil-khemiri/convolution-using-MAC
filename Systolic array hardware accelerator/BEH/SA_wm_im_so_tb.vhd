library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.types_pkg.all;

entity test_SA_wm_im_so is
end entity;

architecture tb of test_SA_wm_im_so is
    constant N : integer := 3;  -- Number of rows in matrix A and C
    constant M : integer := 5;  -- Number of columns in A and number of rows in B
    constant P : integer := 6;  -- Number of columns in matrix B and C

    component SA_wm_im_so is
        generic (
            N : integer;
            M : integer;
            P : integer
        );
        port (
            clk     : in  std_logic;
            arst_n  : in  std_logic;
            a       : in  std_logic_vector_8_array(0 to N-1);
            b       : in  std_logic_vector_8_array(0 to P-1);
            sel_mux_acc : in std_logic_matrix(0 to N-1, 0 to P-1);
            sel_mux_adder : in std_logic_matrix(0 to N-1, 0 to P-1);
            acc_en  : in  std_logic_matrix(0 to N-1, 0 to P-1);
            a_b_en  : in  std_logic_matrix(0 to N-1, 0 to P-1);
            c_array : out std_logic_vector_16_array(0 to P-1)
        );
    end component;

    signal clk     : std_logic := '0';
    signal arst_n  : std_logic := '1';
    signal a       : std_logic_vector_8_array(0 to N-1);
    signal b       : std_logic_vector_8_array(0 to P-1);
    signal sel_mux_acc : std_logic_matrix(0 to N-1, 0 to P-1);
    signal sel_mux_adder : std_logic_matrix(0 to N-1, 0 to P-1);
    signal acc_en  : std_logic_matrix(0 to N-1, 0 to P-1);
    signal a_b_en  : std_logic_matrix(0 to N-1, 0 to P-1);
    signal c_array : std_logic_vector_16_array(0 to P-1);

    constant clk_period : time := 10 ns;

begin
    -- Instantiate the systolic array
    uut: SA_wm_im_so
        generic map (
            N => N,
            M => M,
            P => P
        )
        port map (
            clk => clk,
            arst_n => arst_n,
            a => a,
            b => b,
            sel_mux_acc => sel_mux_acc,
            sel_mux_adder => sel_mux_adder,
            acc_en => acc_en,
            a_b_en => a_b_en,
            c_array => c_array
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset the design
        arst_n <= '0';
        wait for clk_period;
        arst_n <= '1';
        wait for clk_period;

        -- Initialize inputs
        a(0) <= x"01";
        a(1) <= x"02";
        a(2) <= x"03";

        b(0) <= x"01";
        b(1) <= x"02";
        b(2) <= x"03";
        b(3) <= x"04";
        b(4) <= x"05";
        b(5) <= x"06";

        sel_mux_acc <= (others => (others => '0'));
        sel_mux_adder <= (others => (others => '0'));
        acc_en <= (others => (others => '1'));
        a_b_en <= (others => (others => '1'));

        -- Wait for a few clock cycles
        wait for 10 * clk_period;

        -- Apply new inputs
        a(0) <= x"04";
        a(1) <= x"05";
        a(2) <= x"06";

        b(0) <= x"07";
        b(1) <= x"08";
        b(2) <= x"09";
        b(3) <= x"0A";
        b(4) <= x"0B";
        b(5) <= x"0C";

        -- Wait for a few clock cycles
        wait for 10 * clk_period;

        -- End simulation
        wait;
    end process;

end architecture;