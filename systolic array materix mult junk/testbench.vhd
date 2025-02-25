library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.types_pkg.all;

entity testbench is
end entity;

architecture rtl_2 of testbench is

    component SA_wb_ib_os is
        port (
            clk   : in std_logic;
            reset_n : in std_logic;
            a : in pe_input_a;
            b : in pe_input_b;
            sel_mux_acc : in STD_LOGIC;
            sel_mux_adder : in STD_LOGIC;
            c_array : out pe_output_array;
            c1,c2 : out pe_output_array
        );
    end component;

    signal clk, reset_n, sel_mux_acc, sel_mux_adder : STD_LOGIC;
    signal a : pe_input_a;
    signal b : pe_input_b; 
    signal c_array, c1, c2 : pe_output_array;
    constant clk_period : time := 10 ns;

    file a_file : text open read_mode is "a_matrix.txt";
    file b_file : text open read_mode is "b_matrix.txt";
    file c_file : text open write_mode is "c_output.txt";

begin

    -- Instantiate the Systolic Array
    SA_init: SA_wb_ib_os
        port map (
            clk   => clk,
            reset_n => reset_n,
            a => a,
            b => b,
            sel_mux_acc => sel_mux_acc,
            sel_mux_adder => sel_mux_adder,
            c_array => c_array,
            c1 => c1,
            c2 => c2
        );

    -- Clock Process
    clk_proc : process 
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Simulation Process
    simproc: process 

        variable a_line, b_line, c_line : line;
        
        -- **Corrected Matrix Dimensions**
        type a_matrix_type is array (0 to 2, 0 to 4) of int8; -- 3x5
        type b_matrix_type is array (0 to 4, 0 to 5) of int8; -- 5x6
        type c_matrix_type is array (0 to 2, 0 to 5) of int16; -- 3x6

        variable a_matrix : a_matrix_type;
        variable b_matrix : b_matrix_type;
        variable c_matrix : c_matrix_type;

    begin
        -- **Reset the Design Properly**
        reset_n <= '0';
        sel_mux_adder <= '1';
        sel_mux_acc <= '0';
        wait for 5 * clk_period;  -- Hold reset for multiple cycles
        reset_n <= '1';
        wait for clk_period;

        -- **Read Matrix A from File**
        for i in 0 to 2 loop
            readline(a_file, a_line);
            for j in 0 to 4 loop
                read(a_line, a_matrix(i, j));
            end loop;
        end loop;

        -- **Read Matrix B from File**
        for i in 0 to 4 loop
            readline(b_file, b_line);
            for j in 0 to 5 loop
                read(b_line, b_matrix(i, j));
            end loop;
        end loop;

        -- **Stream Data Over Multiple Cycles**
        for t in 0 to 4 loop  -- 5 cycles, one per column of A / row of B
            for j in 0 to 2 loop
                a(j) <= STD_LOGIC_VECTOR(to_signed(a_matrix(j, t), 8));
            end loop;
            for k in 0 to 5 loop
                b(k) <= STD_LOGIC_VECTOR(to_signed(b_matrix(t, k), 8));
            end loop;
            
            -- Allow data to propagate
            wait for clk_period;
            sel_mux_adder <= '0'; -- Enable accumulation after first cycle
        end loop;

        -- **Wait for Computation to Settle**
        wait for 10 * clk_period;

        -- **Read and Store the Output Matrix C**
        sel_mux_acc <= '1'; -- Final accumulation
        wait for clk_period;

        for i in 0 to 2 loop
            for j in 0 to 5 loop
                c_matrix(i, j) := to_integer(signed(c_array(j))); -- Capture output
                
                -- Print Debug Messages
                report "Matrix C(" & integer'image(i) & "," & integer'image(j) & ") = " & 
                    integer'image(c_matrix(i, j)) severity note;
            end loop;
            wait for clk_period;
        end loop;

        -- **Write the Output Matrix to File**
        for i in 0 to 2 loop
            for j in 0 to 5 loop
                write(c_line, c_matrix(i, j));
            end loop;
            writeline(c_file, c_line);
        end loop;  
            
        -- End Simulation
        wait;
    end process;

end architecture;



