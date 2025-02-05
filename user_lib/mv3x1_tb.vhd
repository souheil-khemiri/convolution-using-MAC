library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library std;
use std.textio.all;
library user_lib;
use user_lib.all;

entity mv3x1_tb is
end entity;

architecture rtl of mv3x1_tb is



    component matrix_x_vector_3x1 is
        port (
            clk   : in std_logic;
            reset_n,start : in std_logic;
            --datapth
            input_1, input_2: in STD_LOGIC_VECTOR(7 downto 0);
            output : out STD_LOGIC_VECTOR(15 downto 0);
            --controlpath
    
            --Matrix memory signals
            m_adrs : out std_logic_vector(4 downto 0);
            m_we : out std_logic;
    
            --Vector memory signals 
            v_in_adrs : out std_logic_vector(4 downto 0);
            v_we : out std_logic;
    
            -- output vector memory signals
            vo_in_adrs : out std_logic_vector(4 downto 0);
            vo_we : out std_logic
            
        );
    end component;

    component memory is
        generic (
            adress_width : natural := 5; -- 2 **5 = 32
            word_width : natural := 8
        );
        port (
            clk  : in std_logic;
            rst  : in std_logic;
            adrs : in std_logic_vector((adress_width-1) downto 0);
            we   : in std_logic;
            D    : in std_logic_vector((word_width-1) downto 0);
            Q    : out std_logic_vector((word_width-1) downto 0)
        );
    end component;
    
    ---signals
    signal clk,reset_n,start : STD_LOGIC;
    --DUT we signals
    signal m_we, v_we, vo_we : STD_LOGIC;
    --testbench we signals
    signal m_we_tb, v_we_tb, vo_we_tb : STD_LOGIC;
    --combined we signals
    signal m_we_comb, v_we_comb, vo_we_comb : STD_LOGIC;
    --DUT adress signal
    signal m_adrs, v_in_adrs, vo_in_adrs: std_logic_vector(4 downto 0);
    --testbench adress signals(for filling and readin mem)
    signal m_adrs_tb, v_in_adrs_tb, vo_in_adrs_tb: std_logic_vector(4 downto 0);
    --combined adress signals
    signal m_adrs_comb, v_in_adrs_comb, vo_in_adrs_comb: std_logic_vector(4 downto 0);
    --memory selector for memory control between DUT and tb
    signal mem_ctrl : STD_LOGIC;
    --memory D(in)
    signal mem_matrix_d, mem_vector_d : STD_LOGIC_VECTOR(7 downto 0);
    signal mem_vector_out_d : STD_LOGIC_VECTOR(15 downto 0);
    --memory Q(out)
    signal mem_matrix_q, mem_vector_q: STD_LOGIC_VECTOR(7 downto 0);
    signal mem_vector_out_q : STD_LOGIC_VECTOR(15 downto 0);


    -- files and variables for reading initialyzing mem
    --file mem_matrix_file : text open read_mode is "mem_matrix_init.txt";
    --file mem_vector_file : text open read_mode is "mem_vector_init.txt";
    --variable line_buf : line;
    --variable data_buf : integer ;
    --variable addr : integer := 0;

    -- clock cycle
    constant clk_period : time := 10 ns;
    

begin

        --system
       matrix_x_vector_3x1_inst: entity user_lib.matrix_x_vector_3x1
        port map(
           clk => clk,
           reset_n => reset_n,
           start =>start,
           input_1 => mem_matrix_q,
           input_2 => mem_vector_q,
           output => mem_vector_out_d,
           m_adrs => m_adrs,
           m_we => m_we,
           v_in_adrs => v_in_adrs,
           v_we => v_we,
           vo_in_adrs => vo_in_adrs,
           vo_we => vo_we
       );
       --mem_matrix
       mem_matrix: entity user_lib.memory
        port map (
            clk  => clk,
            rst  => reset_n,
            adrs => m_adrs_comb,
            we   => m_we_comb,
            D    => mem_matrix_d,
            Q    => mem_matrix_q   
        );
        --mem_vector
       mem_vector: entity user_lib.memory
       port map (
           clk  => clk,
           rst  => reset_n,
           adrs => v_in_adrs_comb,
           we   => v_we_comb,
           D    => mem_vector_d,
           Q    => mem_vector_q   
       );
        --mem_vector_out
        mem_vector_out: entity user_lib.memory
        generic map (
            adress_width => 5, -- 2 **5 = 32
            word_width => 16
        )
        port map (
            clk  => clk,
            rst  => reset_n,
            adrs => vo_in_adrs_comb,
            we   => vo_we_comb,
            D    => mem_vector_out_d,
            Q    => mem_vector_out_q
        );
        
        --mem contrl sig
        mem_ctrl_proc : process(mem_ctrl, m_we, v_we, vo_we, m_adrs, v_in_adrs, vo_in_adrs, m_we_tb, v_we_tb, vo_we_tb, m_adrs_tb, v_in_adrs_tb, vo_in_adrs_tb, m_we_comb, v_we_comb, vo_we_comb, m_adrs_comb, v_in_adrs_comb, vo_in_adrs_comb)
        begin
            if(mem_ctrl ='0') then --DUT control
                m_we_comb <= m_we;
                v_we_comb <= v_we;
                vo_we_comb <= vo_we;
                m_adrs_comb <= m_adrs;
                v_in_adrs_comb <= v_in_adrs;
                vo_in_adrs_comb <= vo_in_adrs;
            elsif(mem_ctrl ='1') then --tb control
                m_we_comb <= m_we_tb;
                v_we_comb <= v_we_tb;
                vo_we_comb <= vo_we_tb;
                m_adrs_comb <= m_adrs_tb;
                v_in_adrs_comb <= v_in_adrs_tb;
                vo_in_adrs_comb <= vo_in_adrs_tb;
            end if;
        end process;
            

        clkproc : process
        begin
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end process;

        simproc : process
            variable line_buf : line;
            variable data_buf : integer ;
            variable addr : integer := 0;
            file mem_matrix_file : text open read_mode is "mem_matrix_init.txt";
            file mem_vector_file : text open read_mode is "mem_vector_init.txt";
            variable i : INTEGER :=0;

        begin

            -- Initialize signals
            reset_n <= '0';
            start <= '0';
            m_we_tb <= '0';
            v_we_tb <= '0';
            vo_we_tb <= '0';
            m_adrs_tb <= (others => '0');
            v_in_adrs_tb <= (others => '0');
            vo_in_adrs_tb <= (others => '0');
            mem_ctrl <= '1';
            mem_matrix_d <= (others => '0');
            mem_vector_d <= (others => '0');
            -- Wait for some time before starting the test
            wait for 2 * clk_period;

            --Initialyzing mem_m(matrix) from txt file 
            reset_n <= '1';
            wait for clk_period;
            mem_ctrl <= '1';
            while not endfile(mem_matrix_file) loop
                readline(mem_matrix_file, line_buf);
                read(line_buf, data_buf);
                mem_matrix_d <= std_logic_vector(to_unsigned(data_buf, 8));
                m_adrs_tb <= std_logic_vector(to_unsigned(addr, 5));
                m_we_tb <= '1';
                wait for clk_period;
                m_we_tb <= '0';
                addr := addr + 1;
            end loop;
            
            --Initialyzing mem_v(matrix) from txt file 
            i := 0;
            addr :=0;
            while not endfile(mem_vector_file) loop
                readline(mem_vector_file, line_buf);
                read(line_buf, data_buf);
                mem_vector_d <= std_logic_vector(to_unsigned(data_buf, 8));
                v_in_adrs_tb <= std_logic_vector(to_unsigned(addr, 5));
                v_we_tb <= '1';
                wait for clk_period;
                v_we_tb <= '0';
                addr := addr + 1;
            end loop;

            --checking memory values
            wait for 3*clk_period;
            for 
            i in 0 to 31 loop
                m_adrs_tb <= std_logic_vector(to_unsigned(i, 5));
                v_in_adrs_tb <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
                wait for clk_period;
                report "Memory value at address " & integer'image(i) & " is " & integer'image(to_integer(unsigned(mem_matrix_q)));
                report "Memory value at address " & integer'image(i) & " is " & integer'image(to_integer(unsigned(mem_vector_q)));
            end loop;
            wait for 3*clk_period;
            
            --system test
            mem_ctrl <= '0';
            start <='1';
            wait for clk_period;
            start <= '0';
            wait for 20*clk_period;

            -- read values form mem_v_out
            mem_ctrl <= '1';
            for i in 0 to 31 loop
                vo_in_adrs_tb <= std_logic_vector(to_unsigned(i, 5));
                wait for clk_period;
                report "Output memory value at address " & integer'image(i) & " is " & integer'image(to_integer(unsigned(mem_vector_out_q)));
            end loop;
                
            wait;

            
            
            
        end process;



end architecture;