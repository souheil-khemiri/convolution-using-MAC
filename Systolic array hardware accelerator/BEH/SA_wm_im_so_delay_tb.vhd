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
        type a_matrix_type is array (0 to 4, 0 to 2) of INTEGER;--generic (0 to M-1, 0 to N-1)
        type b_matrix_type is array (0 to 4, 0 to 5) of INTEGER;--generic (0 to M-1, 0 to P-1)
        type c_matrix_type is array (0 to 2, 0 to 5) of INTEGER;--generic (0 to N-1, 0 to P-1)
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
        for i in 0 to 2 loop --genetic 0 to N-1 
            if endfile(a_file) then
                report "Error: Attempted to read past end of a_file" severity failure;
            end if;
            readline(a_file, a_line);
            report "Read line from a_file: " & a_line.all;
            for j in 0 to 4 loop-- generic 0 to M-1
            read(a_line, a_matrix(4-j, i));--generic a_matrix(4-M-1, i) 
            end loop;
        end loop;


        -- Read matrix B from file
        for i in 0 to 4 loop --generic 0 to M-1
            readline(b_file, b_line);
            report "Read line from b_file: " & b_line.all;
            for j in 0 to 5 loop --generic 0 to P-1
            read(b_line, b_matrix(4-i, j));--generic b_matrix(M-1-i, j)
            end loop;
        end loop;
        
        -- start
        arst_n <= '1';
        a_b_en <= (others => (others => '1'));
        delay_en <= '1';




        -- Stream inputs and weights
        -- loop until SA processing is done
        -- Processing clk cycles = PE(0,0) process time + card(skewdiags)
                               --= (PE process time(=M) + delay from data input to PE(0,0)) + (m + p - 1)
                               --=  (5+2) +(3+6-1) = 15	
        for i in 0 to 15 loop--generic 0 to M+2+N+P-1= N+M+P+1 
            if (i<5) then--generic (i<M)  
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
            end if;

            --set sel_mux_adder and acc_en so that we start accumulating for skew diagonal PEs
            -- clk 2 start i = 0 end at i = 8
            if(i <8+1) then --generic i<M+3
                for n in 0 to N-1 loop
                    for p in 0 to P-1 loop
                        if (n+p = i) then
                            sel_mux_adder(n,p) <= '1';
                            acc_en(n,p) <= '1';
                            report "sel_mux_adder(" & integer'image(n) & "," & integer'image(p) & ") <= '1'";
                            report "acc_en(" & integer'image(n) & "," & integer'image(p) & ") <= '1'";
                        end if;
                    end loop;
                end loop;
            end if;

            --hold value in acc get ready for shift down

            if(6<i) then --generic M+1<i
                for n in 0 to N-1 loop
                    for p in 0 to P-1 loop
                        if (n+p = i-7) then
                            acc_en(n,p) <= '0';
                            sel_mux_acc(n,p) <= '0'; 
                        end if;
                    end loop;
                end loop;
            end if; 
            wait for clk_period;   
        end loop;
        
        wait for 10*clk_period;

        --shift down results to matrix signal and write output in c_file
        acc_en <= (others => (others => '1'));
        for i in 0 to 2 loop -- generic 0 to N-1
            for j in 0 to 5 loop --generic 0 to P-1
                c_matrix(2-i, j) := to_integer(signed(c_array(j)));
                report  "Matrix C(" & integer'image(i) & "," & integer'image(j) & ") = " & integer'image(c_matrix(i,j)) severity note;
                report "c_array(" & integer'image(j) & ") = " & integer'image(to_integer(signed(c_array(j)))) severity note;
            end loop;
            wait for clk_period;
        end loop;
        

        for i in 0 to 2 loop --generic 0 to N-1
            for j in 0 to 5 loop --generic 0 to P-1
                write(c_line, integer'image(c_matrix(i, j)) & " ");
            end loop;
            writeline(c_file, c_line);
        end loop;  
            


        wait;
      
    end process;

end architecture;