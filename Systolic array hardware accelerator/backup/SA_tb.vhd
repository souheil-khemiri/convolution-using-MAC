library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.types_pkg.all;

entity SA_wm_im_so_delay_tb is
end entity;

architecture rtl of SA_wm_im_so_delay_tb is

    --systolic array config:
    constant N : integer := 3;  -- Number of rows in matrix A and C
    constant P : integer := 6;  -- Number of columns in matrix B and C
    constant clk_period : time := 10 ns;
    -- tb signals
    signal clk : STD_LOGIC;
    signal arst_n : STD_LOGIC;
    signal a : std_logic_vector_8_array(0 to N-1);
    signal b : std_logic_vector_8_array(0 to P-1);
    signal c_array : std_logic_vector_16_array(0 to P-1);
    --mux sel 
    signal sel_mux_acc :  std_logic_matrix( 0 to N-1, 0 to P-1);
    signal sel_mux_adder :  std_logic_matrix( 0 to N-1, 0 to P-1);
    --enable signals
    signal acc_en : std_logic_matrix(0 to N-1, 0 to P-1);
    signal a_b_en : std_logic_matrix(0 to N-1, 0 to P-1);
    signal delay_en :  std_logic;

    --files
    file a_file : text open read_mode is "SIM/a_matrix.txt";-- "C:/intelFPGA/20.1/convolution/systolic array matrix multiplication/SK_repo/SIM/a_matrix.txt";--"SIM/a_matrix.txt";
    file b_file : text open read_mode is "SIM/b_matrix.txt";--"C:/intelFPGA/20.1/convolution/systolic array matrix multiplication/SK_repo/SIM/a_matrix.txt";--"SIM/b_matrix.txt";
    file c_file : text open write_mode is "SIM/c_output.txt";--"C:/intelFPGA/20.1/convolution/systolic array matrix multiplication/SK_repo/SIM/a_matrix.txt";--

begin
    SA :  SA_wm_im_so_delay--SA_wm_im_so_delay
     generic map(
        N => N,
        M => 0,
        P => P
    )
     port map(
        clk => clk,
        arst_n => arst_n,
        a => a,
        b => b,
        sel_mux_acc => sel_mux_acc,
        sel_mux_adder => sel_mux_adder,
        acc_en => acc_en,
        a_b_en => a_b_en,
        delay_en => delay_en,
        c_array => c_array
    );

    -- Clock 
    clk_process : process
    begin

        clk <= '0';
        wait for clk_period/2 ;
        clk <= '1';
        wait for clk_period/2 ;

    end process;

    --simproc
    simproc: process

        variable a_line : line;
        variable b_line : line;
        variable c_line : line;
        type a_matrix_type is array (0 to 4, 0 to 2) of INTEGER;
        type b_matrix_type is array (0 to 4, 0 to 5) of INTEGER;
        type c_matrix_type is array (0 to 2, 0 to 5) of INTEGER;
        variable a_matrix : a_matrix_type;
        variable b_matrix : b_matrix_type;
        variable c_matrix : c_matrix_type; 

    begin

        --reset
        arst_n <= '0';
        sel_mux_acc <= (others => (others => '1'));
        sel_mux_adder <= (others => (others => '0'));
        a_b_en <= (others => (others => '0'));
        delay_en <= '0'; 
        acc_en <= (others => (others => '0'));
        wait for 2*clk_period;

        --Read matrix A from file
        for i in 0 to 2 loop
            if endfile(a_file) then
                report "Error: Attempted to read past end of a_file" severity failure;
            end if;
            readline(a_file, a_line);
            report "Read line from a_file: " & a_line.all;
            for j in 0 to 4 loop
            read(a_line, a_matrix(4-j, i));
            end loop;
        end loop;


        -- Read matrix B from file
        for i in 0 to 4 loop
            readline(b_file, b_line);
            -- if endfile(b_file) then
            --     report "Error: Attempted to read past end of b_file" severity failure;
            -- end if;
            report "Read line from b_file: " & b_line.all;
            for j in 0 to 5 loop
            read(b_line, b_matrix(4-i, j));
            end loop;
        end loop;
        
        -- start
        arst_n <= '1';
        a_b_en <= (others => (others => '1'));
        delay_en <= '1';
        acc_en(0,0) <= '1' ;
        --wait for clk_period;



        -- Stream inputs and weights
        for i in 0 to 4 loop
            --fill a
           for j in 0 to 2 loop
               a(j) <= STD_LOGIC_VECTOR(to_signed(a_matrix(i,j),8));
               report "a(" & integer'image(j) & ") <= " & integer'image(a_matrix(i,j));
            end loop;
            --fill b
            for k in 0 to 5 loop
               b(k) <= STD_LOGIC_VECTOR(to_signed(b_matrix(i,k),8));
               report "b(" & integer'image(k) & ") <= " & integer'image(b_matrix(i,k));
            end loop;
            wait for clk_period; -- clk 1 end
            --set sel_mux_adder so that we start accumulating for (0,0)
            if(i = 0) then -- clk 2 start
                sel_mux_adder(0,0) <= '1';
            end if;
            --i = 1 clk 3 start
            --i = 2 clk 4 start
            --i = 3 clk 5 : hold value in acc get ready for shift down
            -- if(i = 4) then
            --     acc_en(0,0) <= '0';
            --     sel_mux_acc(0,0) <= '0'; 
            -- end if;       
        end loop;
        
        wait for 2*clk_period;
            acc_en(0,0) <= '0';
            sel_mux_acc(0,0) <= '0'; 
        --sel_mux_acc <= (others => (others => '0'));
        wait for 10*clk_period;
        wait;
      
    end process;

end architecture;