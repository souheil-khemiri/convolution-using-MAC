library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.types_pkg.all;

entity matrix_read is
end entity;

architecture rtl of matrix_read is

    --files
    file a_file : text open read_mode is "SIM/a_matrix.txt";
    file b_file : text open read_mode is "SIM/b_matrix.txt";
    file c_file : text open write_mode is "SIM/c_output.txt";

begin

    --simproc
    simproc: process

        variable a_line : line;
        variable b_line : line;
        variable c_line : line;
        type a_matrix_type is array (0 to 4, 0 to 2) of int8;
        type b_matrix_type is array (0 to 4, 0 to 5) of int8;
        type c_matrix_type is array (0 to 2, 0 to 5) of int16;
        variable a_matrix : a_matrix_type;
        variable b_matrix : b_matrix_type;
        variable c_matrix : c_matrix_type; 

    begin
        --Read matrix A from file
        for i in 0 to 2 loop
            readline(a_file, a_line);
            report "Read line from a_file: " & a_line.all;
            for j in 0 to 4 loop
            read(a_line, a_matrix(4-j, i));
            end loop;
        end loop;

        -- Read matrix B from file
        for i in 0 to 4 loop
            readline(b_file, b_line);
            report "Read line from b_file: " & b_line.all;
            for j in 0 to 5 loop
            read(b_line, b_matrix(4-i, j));
            end loop;
        end loop;

        wait ;

    end process;

    

end architecture;