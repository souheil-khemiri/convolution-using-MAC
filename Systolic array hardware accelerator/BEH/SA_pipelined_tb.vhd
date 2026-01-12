library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.types_pkg.all;

entity SA_pipelined_tb is
end entity;

architecture rtl of SA_pipelined_tb is
    --Constants
    ----systolic array size
    constant N : INTEGER := 3;
    constant P : INTEGER := 6;
    ----multibank memory common parameters
    constant ADDR_WIDTH : INTEGER := 10;
    constant DATA_WIDTH : INTEGER := 8;
    constant DATA_WIDTH_C : INTEGER := 16;
    constant BANK_ADDR_WIDTH : INTEGER := 6;
    ------BANK_COUNT for multibank_mem_1_to_N_a_inst is N
    ------BANK_COUNT for multibank_mem_1_to_N_b_inst is P
    ------BANK_COUNT for multibank_mem_N_to_1_out_inst is P
    ----testbench config and signals
    constant CLK_PERIOD     : time := 10 ns;
    constant PAUSE_CYCLES   : integer := 5;
    signal sim_done : boolean := false;
    signal N_reg : integer ;
    signal M_reg : integer ;
    signal P_reg : integer ;


    --signals
    signal clk : std_logic;
    signal arst_n_sa : std_logic;
    signal arst_n_mem_a : std_logic;
    signal arst_n_mem_b : std_logic;
    signal arst_n_mem_c : std_logic;
    ----systolic array signals
    signal a : std_logic_vector_8_array(0 to N-1);
    signal b : std_logic_vector_8_array(0 to P-1);
    signal c_array : std_logic_vector_16_array(0 to P-1);
    signal sel_mux_acc : std_logic_matrix( 0 to N-1, 0 to P-1);
    signal sel_mux_adder : std_logic_matrix( 0 to N-1, 0 to P-1);
    signal acc_en : std_logic_matrix(0 to N-1, 0 to P-1);
    signal a_b_en : std_logic_matrix(0 to N-1, 0 to P-1);  
    signal delay_en : std_logic;
    ----multibank memory a signals
    signal mem_addr_a  : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal mem_data_a  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mem_we_a : std_logic;
    signal bank_addr_a : std_logic_vector_6_array(0 to N-1);
    ------bank_data -> a
    signal bank_read_a : std_logic_vector(N-1 downto 0);
    ----multibank memory b signals
    signal mem_addr_b  : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal mem_data_b  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mem_we_b : std_logic;
    signal bank_addr_b : std_logic_vector_6_array(P-1 downto 0);
    ------bank_data -> b
    signal bank_read_b : std_logic_vector(P-1 downto 0);
    ----multibank memory output signals
    signal bank_addr_c : std_logic_vector_6_array(0 to P-1);
    ------bank_data_in -> c_array
    signal bank_we_c : std_logic_vector(P-1 downto 0);
    signal read_en_c : std_logic;
    signal mem_addr_c  : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal mem_data_out_c :  std_logic_vector(DATA_WIDTH_C-1 downto 0);
    --signal mem_data_in_c  : std_logic_vector_16_array(0 to P-1);


    --files
    file a_file : text open read_mode is "SIM/a_matrix_row_major.txt";
    file b_file : text open read_mode is "SIM/b_matrix_row_major.txt";
    file c_file : text open write_mode is "SIM/c_output_row_major.txt";

begin
    --systolic array with delay block
    SA_wm_im_so_delay_inst: entity work.SA_wm_im_so_delay
     generic map(
        N => N,
        M => 0,
        P => P
    )
     port map(
        clk => clk,
        arst_n => arst_n_sa,
        a => a,
        b => b,
        sel_mux_acc => sel_mux_acc,
        sel_mux_adder => sel_mux_adder,
        acc_en => acc_en,
        a_b_en => a_b_en,
        delay_en => delay_en,
        c_array => c_array
    );

    -- multibank_mem_1_to_N for a matrix    
    multibank_mem_1_to_N_a_inst: entity work.multibank_mem_1_to_N
     generic map(
        BANK_COUNT => N,
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH,
        BANK_ADDR_WIDTH => BANK_ADDR_WIDTH
    )
     port map(
        clk => clk,
        arst_n => arst_n_mem_a,
        mem_addr => mem_addr_a,
        mem_data => mem_data_a,
        mem_we => mem_we_a,
        bank_addr => bank_addr_a,
        bank_data => a,
        bank_read => bank_read_a
    );

    -- multibank_mem_1_to_N for b matrix
    multibank_mem_1_to_N_b_inst: entity work.multibank_mem_1_to_N
     generic map(
        BANK_COUNT => P,
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH,
        BANK_ADDR_WIDTH => BANK_ADDR_WIDTH
    )
     port map(
        clk => clk,
        arst_n => arst_n_mem_b,
        mem_addr => mem_addr_b,
        mem_data => mem_data_b,
        mem_we => mem_we_b,
        bank_addr => bank_addr_b,
        bank_data => b,
        bank_read => bank_read_b
    );

    -- multibank_mem_N_to_1 for output matrix
    multibank_mem_N_to_1_out_inst: entity work.multibank_mem_N_to_1
     generic map(
        BANK_COUNT => P,
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH_C,
        BANK_ADDR_WIDTH => BANK_ADDR_WIDTH
    )
     port map(
        clk => clk,
        arst_n => arst_n_mem_c,
        bank_addr => bank_addr_c,
        bank_data_in => c_array,
        bank_we => bank_we_c,
        mem_addr => mem_addr_c,
        mem_data_out => mem_data_out_c,
        read_en => read_en_c
    );

    -- Clock Generation
    clk_process: process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD/2 ;
            clk <= '1';
            wait for CLK_PERIOD/2 ;
        end loop;
        wait;
    end process;

    -- Simulation Process
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
        variable a_line : line;
        variable b_line : line;
        variable c_line : line;
    begin
        sim_done <= false;
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
        N_reg <= 3 ;
        M_reg <= 5 ;
        P_reg <= 6 ;
        wait for CLK_PERIOD ;
        N_reg_var := N_reg;
        M_reg_var := M_reg;
        P_reg_var := P_reg;
        -- Wait for reset
        wait for 2*CLK_PERIOD;
        -- Write matrix A from a file into multibank_mem_1_to_N_a_inst
        arst_n_mem_a <= '1';
        for i in 0 to N_reg_var-1 loop
            for j in 0 to M_reg_var-1 loop
                if endfile(a_file) then
                    report "End of file reached" severity warning;
                    exit;
                end if; 
                mem_addr_a <= create_addr(i, j);
                readline(a_file, a_line);
                read(a_line, mem_val);
                mem_data_a_var := std_logic_vector(to_unsigned(mem_val, DATA_WIDTH));
                mem_data_a <= mem_data_a_var;
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
        arst_n_mem_b <= '1';
        for i in 0 to M_reg_var-1 loop
            for j in 0 to P_reg_var-1 loop
                if endfile(b_file) then
                    report "End of file reached" severity warning;
                    exit;
                end if; 
                mem_addr_b <= create_addr(j,i);
                readline(b_file, b_line);
                read(b_line, mem_val);
                mem_data_b_var := std_logic_vector(to_unsigned(mem_val, DATA_WIDTH));
                mem_data_b <= mem_data_b_var;
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
                mem_data_out_c_var := to_integer(signed(mem_data_out_c));
                write(c_line, mem_data_out_c_var);
                writeline(c_file, c_line);
            end loop; 
        end loop;
        sim_done <= true;
        wait;
    end process;


    

end architecture;