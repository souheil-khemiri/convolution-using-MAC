library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;  

entity SA_pipelined_beh is
    generic (
        --Systolic array size
        N : INTEGER := 3;
        P : INTEGER := 6;
        --Multibank memory common parameters
        ADDR_WIDTH : INTEGER := 10;
        DATA_WIDTH : INTEGER := 8;
        DATA_WIDTH_C : INTEGER := 16;
        BANK_ADDR_WIDTH : INTEGER := 6
    );
    port (
        clk     : in  std_logic;
        --Reset signals
        arst_n_sa : out std_logic;
        arst_n_mem_a : out std_logic;
        arst_n_mem_b : out std_logic;
        arst_n_mem_c : out std_logic;
        --Mem signals
        ---A 
        mem_addr_a  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        --mem_data_a  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        mem_we_a : out std_logic;
        bank_addr_a : out std_logic_vector_6_array(0 to N-1);
        bank_read_a : out std_logic_vector(N-1 downto 0);
        ---B
        mem_addr_b  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        --mem_data_b  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        mem_we_b :  out std_logic;
        bank_addr_b : out std_logic_vector_6_array(P-1 downto 0);
        bank_read_b : out std_logic_vector(P-1 downto 0);
        ---C
        bank_addr_c : out std_logic_vector_6_array(0 to P-1);
        bank_we_c : out std_logic_vector(P-1 downto 0);
        read_en_c : out std_logic;
        mem_addr_c  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        --mem_data_out_c : out std_logic_vector(DATA_WIDTH_C-1 downto 0);
        --SA signals
        sel_mux_acc : out std_logic_matrix(0 to N-1, 0 to P-1);
        sel_mux_adder : out std_logic_matrix(0 to N-1, 0 to P-1);
        acc_en  : out std_logic_matrix(0 to N-1, 0 to P-1);
        a_b_en  : out std_logic_matrix(0 to N-1, 0 to P-1);
        delay_en : out std_logic;
        ---Matrices sizes regiders
        N_reg : in integer ;
        M_reg : in integer ;
        P_reg : in integer;
        ---interface signals
        start : in std_logic;
        done : out std_logic;
        valid_data : in std_logic
    );
end entity SA_pipelined_beh;

architecture beh of SA_pipelined_beh is
    constant CLK_PERIOD     : time := 10 ns;
begin
        
    simprocess: process
        -- Function to create full memory address for bank/addr combination
        function create_addr(bank : integer; addr : integer) return std_logic_vector is
            variable result : std_logic_vector(ADDR_WIDTH-1 downto 0);
        begin
            result := std_logic_vector(to_unsigned(bank, ADDR_WIDTH-BANK_ADDR_WIDTH)) & 
                        std_logic_vector(to_unsigned(addr, BANK_ADDR_WIDTH));
            return result;
        end function;
        -- Variables
        variable N_reg_var : integer;
        variable M_reg_var : integer;
        variable P_reg_var : integer;
        variable mem_val : integer;
        variable mem_data_a_var : std_logic_vector(DATA_WIDTH-1 downto 0);
        variable mem_data_b_var : std_logic_vector(DATA_WIDTH-1 downto 0);
        variable mem_data_out_c_var: integer;
        -- variable a_line : line;
        -- variable b_line : line;
        -- variable c_line : line;
    begin
        wait until start  = '1';
        done <= '0';
        --sim_done <= false;
        -- Reset the DUT
        arst_n_sa <= '0';
        arst_n_mem_a <= '0';
        arst_n_mem_b <= '0';
        arst_n_mem_c <= '0';
        -- Reset  multibank_mem_N_to_1_out_inst
        read_en_c <= '0';
        bank_we_c <= (others => '0');
        -- Reset  multibank_mem_1_to_N_a_inst & multibank_mem_1_to_N_b_inst
        mem_we_a <= '0';
        bank_read_a <= (others => '0');
        mem_we_b <= '0';
        bank_read_b <= (others => '0');
        -- Reset  SA_wm_im_so_delay_inst
        sel_mux_acc <= (others => (others => '1'));
        sel_mux_adder <= (others => (others => '0'));
        a_b_en <= (others => (others => '0'));
        delay_en <= '0'; 
        acc_en <= (others => (others => '0'));
        -- Set A and B matrices to be calculated sizes
        -- N_reg <= 3 ;
        -- M_reg <= 5 ;
        --P_reg <= 6 ;
        wait for CLK_PERIOD ;
        N_reg_var := N_reg;
        M_reg_var := M_reg;
        P_reg_var := P_reg;
        -- Wait for reset
        wait for 2*CLK_PERIOD;
        -- Write matrix A from a file into multibank_mem_1_to_N_a_inst
        wait until valid_data = '1';
        arst_n_mem_a <= '1';
        for i in 0 to N_reg_var-1 loop
            for j in 0 to M_reg_var-1 loop
                -- if endfile(a_file) then
                --     report "End of file reached" severity warning;
                --     exit;
                -- end if; 
                mem_addr_a <= create_addr(i, j);
                -- readline(a_file, a_line);
                -- read(a_line, mem_val);
                -- mem_data_a_var := std_logic_vector(to_unsigned(mem_val, DATA_WIDTH));
                -- mem_data_a <= mem_data_a_var;
                -- report "M_reg_var = " & integer'image(M_reg_var);
                -- report "(i,j) = " & integer'image(i) & "," & integer'image(j);
                -- report "mem_val: " & integer'image(mem_val);
                -- report "mem_addr_a: " & integer'image(to_integer(unsigned(mem_addr_a)));
                -- report "mem_data_a: " & integer'image(to_integer(unsigned(mem_data_a)));
                mem_we_a <= '1';
                wait for CLK_PERIOD;
            end loop;
        end loop;
        mem_we_a <= '0';
        wait for CLK_PERIOD;
        -- Write matrix B from b file into multibank_mem_1_to_N_b_inst
        wait until valid_data = '1';
        arst_n_mem_b <= '1';
        for i in 0 to M_reg_var-1 loop
            for j in 0 to P_reg_var-1 loop
                -- if endfile(b_file) then
                --     report "End of file reached" severity warning;
                --     exit;
                -- end if; 
                mem_addr_b <= create_addr(j,i);
                --readline(b_file, b_line);
                --read(b_line, mem_val);
                --mem_data_b_var := std_logic_vector(to_unsigned(mem_val, DATA_WIDTH));
                --mem_data_b <= mem_data_b_var;
                -- report "P_reg_var = " & integer'image(P_reg_var);
                -- report "(j,i) = " & integer'image(j) & "," & integer'image(i);
                -- report "mem_val: " & integer'image(mem_val);
                -- report "mem_addr_b: " & integer'image(to_integer(unsigned(mem_addr_b)));
                -- report "mem_data_b: " & integer'image(to_integer(unsigned(mem_data_b)));
                mem_we_b <= '1';
                wait for CLK_PERIOD;
            end loop;
        end loop;
        mem_we_b <= '0';
        -- Execute matrix multiplication
        -- start
        -- arst_n_sa <= '1';
        -- a_b_en <= (others => (others => '1'));
        -- delay_en <= '1';




        -- Stream inputs and weights
        -- loop until SA processing is done
        -- Processing clk cycles = PE(0,0) process time + card(skewdiags)
                                --= (PE process time(=M) + delay from data input to PE(0,0)) + (m + p - 1)
                                --=  (5+2) +(3+6-1) = 15	
        for i in 0 to 15 loop--generic 0 to M+2+N+P-1= N+M+P+1 
            bank_read_a <= (others => '1');
            bank_read_b <= (others => '1');
            if (i<5) then--generic (i<M)  
                --fill a
                for bank_idx in 0 to N_reg_var-1 loop
                    bank_addr_a(bank_idx) <= std_logic_vector(to_unsigned(i, BANK_ADDR_WIDTH));
                end loop;
                --fill b
                for bank_idx in 0 to P_reg_var-1 loop
                    bank_addr_b(bank_idx) <= std_logic_vector(to_unsigned(i, BANK_ADDR_WIDTH));
                end loop;
            end if;

            -- set sel_mux_adder and acc_en so that we start accumulating for skew diagonal PEs
            -- clk 2 start i = 0 end at i = 8
            if(i <8+1) then --generic i<M+3
                for n in 0 to N_reg_var-1 loop
                    for p in 0 to P_reg_var-1 loop
                        if (n+p = i) then
                            sel_mux_adder(n,p) <= '1';
                            acc_en(n,p) <= '1';
                            -- report "sel_mux_adder(" & integer'image(n) & "," & integer'image(p) & ") <= '1'";
                            -- report "acc_en(" & integer'image(n) & "," & integer'image(p) & ") <= '1'";
                        end if;
                    end loop;
                end loop;
            end if;

            -- --hold value in acc get ready for shift down

            if(7<i) then --generic was: M+1<i--fix : m+2
                for n in 0 to N_reg_var-1 loop--0->2
                    for p in 0 to P_reg_var-1 loop--0->5
                        if (n+p = i-8) then--was: i-7 fix: 8
                            acc_en(n,p) <= '0';
                            sel_mux_acc(n,p) <= '0'; 
                        end if;
                    end loop;
                end loop;
            end if; 
            wait for clk_period;
            if i=0 then
                arst_n_sa <= '1';
                a_b_en <= (others => (others => '1'));
                delay_en <= '1';
            end if;   
        end loop;
        bank_read_b <= (others => '0');
        bank_read_a <= (others => '0');
        wait for 10*clk_period;
        
        -- -- Write output matrix into multibank_mem_N_to_1_out_inst
        --acc_en <= (others => (others => '1'));
        arst_n_mem_c <= '1';
        acc_en <= (others => (others => '1'));
        for i in 0 to N_reg_var-1 loop -- generic 0 to N-1
            for bank_idx in 0 to P_reg_var-1 loop
                bank_addr_c(bank_idx) <= std_logic_vector(to_unsigned(N_reg_var-1-i, BANK_ADDR_WIDTH));
            end loop;
            bank_we_c <= (others => '1');
            wait for clk_period;
        end loop;
        bank_we_c <= (others => '0');
        wait for 5*clk_period;

        -- -- Write output matrix into c file row major
        read_en_c <= '1';
        for i in 0 to N_reg_var-1 loop--N_reg_var
            for j in 0 to P_reg_var-1 loop--
                mem_addr_c <= create_addr(j,i);
                wait for clk_period;
                --mem_data_out_c_var := to_integer(signed(mem_data_out_c));
                --write(c_line, mem_data_out_c_var);
                --writeline(c_file, c_line);
            end loop; 
        end loop;
        --sim_done <= true;
        done <= '1';
        --wait; because wait in the beginning for start signal 

    end process;
end architecture ;

