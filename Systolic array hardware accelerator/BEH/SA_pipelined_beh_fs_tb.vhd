library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;
use std.textio.all;

entity SA_pipelined_beh_fs_tb is
end entity SA_pipelined_beh_fs_tb;

architecture behavioural of SA_pipelined_beh_fs_tb is
    -- Constants
    constant clk_period : time :=  10 ns;
    ---systolic array size
    constant N : INTEGER := 3;
    constant P : INTEGER := 6;
    ---multibank memory common parameters
    constant ADDR_WIDTH : INTEGER := 10;
    constant DATA_WIDTH : INTEGER := 8;
    constant DATA_WIDTH_C : INTEGER := 16;
    constant BANK_ADDR_WIDTH : INTEGER := 6;
    -- Signals
    signal clk : std_logic;
    signal N_reg : integer;
    signal M_reg : integer;
    signal P_reg : integer;
    signal mem_data_a : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mem_data_b : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mem_data_out_c : std_logic_vector(DATA_WIDTH_C-1 downto 0);
    signal start : std_logic;    
    signal done : std_logic;
    signal vaild_data : std_logic;
    --files
    file a_file : text open read_mode is "SIM/a_matrix_row_major.txt";
    file b_file : text open read_mode is "SIM/b_matrix_row_major.txt";

    file ax_file : text open read_mode is "SIM/a_matrix_row_major.txt";
    file bx_file : text open read_mode is "SIM/b_matrix_row_major.txt";
    
begin

    -- Instantiate the Unit Under Test (UUT)
    SA_pipelined_beh_fs_inst:  SA_pipelined_beh_fs
        generic map (
            N => N,
            P => P,
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => DATA_WIDTH,
            DATA_WIDTH_C => DATA_WIDTH_C,
            BANK_ADDR_WIDTH => BANK_ADDR_WIDTH
        )
        port map (
            clk => clk,
            N_reg => N_reg,
            M_reg => M_reg,
            P_reg => P_reg,
            mem_data_a => mem_data_a,
            mem_data_b => mem_data_b,
            mem_data_out_c => mem_data_out_c,
            start => start,
            done => done,
            valid_data => vaild_data
        );

        clk_process: process
        begin
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end process clk_process;

        simulation_process: process
            variable fline : line;
            variable value : integer;
            variable N_reg_var : integer;
            variable M_reg_var : integer;
            variable P_reg_var : integer;

        begin
            -- Initialize inputs
            start <= '0';
            vaild_data <= '0';            
            wait for clk_period;
            
            -- Start the simulation
            start <= '1';
            N_reg <= 3;
            M_reg <= 5;
            P_reg <= 6;
            wait for clk_period;
            N_reg_var := N_reg;
            M_reg_var := M_reg;
            P_reg_var := P_reg;
            report "before start N_reg_var * M_reg_var = " & integer'image(N_reg_var * M_reg_var);
            start <= '0';
            wait for 5*clk_period;
            vaild_data <='1';
            for i in 0 to (N_reg_var * M_reg_var) - 1 loop
                -- Read a matrix from file
                readline(a_file, fline); 
                read(fline, value);
                mem_data_a <= std_logic_vector(to_unsigned(value, DATA_WIDTH));
                wait for clk_period;
                if(i>0)then
                    vaild_data <='0';
                end if;
            end loop;
            wait for clk_period;
            vaild_data <='1';
            for i in 0 to (M_reg_var * P_reg_var) - 1 loop
                -- Read a matrix from file
                readline(b_file, fline); 
                read(fline, value);
                mem_data_b <= std_logic_vector(to_unsigned(value, DATA_WIDTH));
                wait for clk_period;
                if(i>0)then
                    vaild_data <='0';
                end if;
            end loop;
            wait until done = '1';
            wait for clk_period;

            --simulate the second multiplication call
            start <= '1';
            N_reg <= 3;
            M_reg <= 5;
            P_reg <= 6;
            wait for clk_period;
            N_reg_var := N_reg;
            M_reg_var := M_reg;
            P_reg_var := P_reg;
            report "before start N_reg_var * M_reg_var = " & integer'image(N_reg_var * M_reg_var);
            start <= '0';
            wait for 5*clk_period;
            vaild_data <='1';
            for i in 0 to (N_reg_var * M_reg_var) - 1 loop
                -- Read a matrix from file
                readline(ax_file, fline); 
                read(fline, value);
                mem_data_a <= std_logic_vector(to_unsigned(value, DATA_WIDTH));
                wait for clk_period;
                if(i>0)then
                    vaild_data <='0';
                end if;
            end loop;
            wait for clk_period;
            vaild_data <='1';
            for i in 0 to (M_reg_var * P_reg_var) - 1 loop
                -- Read a matrix from file
                readline(bx_file, fline); 
                read(fline, value);
                mem_data_b <= std_logic_vector(to_unsigned(value, DATA_WIDTH));
                wait for clk_period;
                if(i>0)then
                    vaild_data <='0';
                end if;
            end loop;
            wait for clk_period;


            
            -- Finish the simulation
            wait;
        end process simulation_process;
    

end architecture;