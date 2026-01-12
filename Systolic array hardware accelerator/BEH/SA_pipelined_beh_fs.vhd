library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all; 

entity SA_pipelined_beh_fs is 
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
        clk : in  std_logic;
        --Matrices size registers
        N_reg : in integer ;
        M_reg : in integer ;
        P_reg : in integer;
        --Matrices values
        mem_data_a  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        mem_data_b  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        mem_data_out_c : out std_logic_vector(DATA_WIDTH_C-1 downto 0);
        ---interface signals
        start : in std_logic;
        done : out std_logic;
        valid_data : in std_logic
    );
end entity SA_pipelined_beh_fs;

architecture beh of SA_pipelined_beh_fs is

    signal arst_n_sa : std_logic;
    signal arst_n_mem_a : std_logic;
    signal arst_n_mem_b : std_logic;
    signal arst_n_mem_c : std_logic;
    ---A 
    signal mem_addr_a  :  std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal mem_we_a :  std_logic;
    signal bank_addr_a :  std_logic_vector_6_array(0 to N-1);
    signal bank_read_a :  std_logic_vector(N-1 downto 0);
    ---B
    signal mem_addr_b  :  std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal mem_we_b :   std_logic;
    signal bank_addr_b :  std_logic_vector_6_array(P-1 downto 0);
    signal bank_read_b :  std_logic_vector(P-1 downto 0);
    ---C
    signal bank_addr_c :  std_logic_vector_6_array(0 to P-1);
    signal bank_we_c :  std_logic_vector(P-1 downto 0);
    signal read_en_c :  std_logic;
    signal mem_addr_c  :  std_logic_vector(ADDR_WIDTH-1 downto 0);
    --SA signals
    signal sel_mux_acc :  std_logic_matrix(0 to N-1, 0 to P-1);
    signal sel_mux_adder :  std_logic_matrix(0 to N-1, 0 to P-1);
    signal acc_en  :  std_logic_matrix(0 to N-1, 0 to P-1);
    signal a_b_en  :  std_logic_matrix(0 to N-1, 0 to P-1);
    signal delay_en :  std_logic;

begin

    SA_pipelined_inst: SA_pipelined
    generic map (
        --Systolic array size
        N => N,
        P => P,
        --Multibank memory common parameters
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH,
        DATA_WIDTH_C => DATA_WIDTH_C,
        BANK_ADDR_WIDTH => BANK_ADDR_WIDTH
    )
    port map(
        clk=> clk,
        --Reset signals
        arst_n_sa => arst_n_sa,
        arst_n_mem_a => arst_n_mem_a,
        arst_n_mem_b => arst_n_mem_b,
        arst_n_mem_c => arst_n_mem_c,
        --Mem signals
        ---A 
        mem_addr_a  => mem_addr_a  ,
        mem_data_a  => mem_data_a  ,
        mem_we_a => mem_we_a,
        bank_addr_a => bank_addr_a,
        bank_read_a => bank_read_a,
        ---B
        mem_addr_b  => mem_addr_b,
        mem_data_b  => mem_data_b,
        mem_we_b  => mem_we_b,
        bank_addr_b => bank_addr_b,
        bank_read_b => bank_read_b,
        ---C
        bank_addr_c => bank_addr_c,
        bank_we_c => bank_we_c,
        read_en_c => read_en_c,
        mem_addr_c => mem_addr_c,
        mem_data_out_c => mem_data_out_c,
        --SA signals
        sel_mux_acc => sel_mux_acc,     
        sel_mux_adder => sel_mux_adder,   
        acc_en => acc_en,          
        a_b_en => a_b_en,          
        delay_en => delay_en        
    );

    SA_pipelined_beh_inst : SA_pipelined_beh
    generic map (
        --Systolic array size
        N => N,
        P => P,
        --Multibank memory common parameters
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH,
        DATA_WIDTH_C => DATA_WIDTH_C,
        BANK_ADDR_WIDTH => BANK_ADDR_WIDTH
    )
    port map(
        clk=> clk,
        --Reset signals
        arst_n_sa    => arst_n_sa,
        arst_n_mem_a => arst_n_mem_a, 
        arst_n_mem_b => arst_n_mem_b,
        arst_n_mem_c => arst_n_mem_c,
        --Mem signals
        ---A 
        mem_addr_a => mem_addr_a,
        mem_we_a => mem_we_a,   
        bank_addr_a => bank_addr_a,
        bank_read_a => bank_read_a,
        ---B
        mem_addr_b => mem_addr_b, 
        mem_we_b => mem_we_b,
        bank_addr_b => bank_addr_b, 
        bank_read_b => bank_read_b, 
        ---C
        bank_addr_c => bank_addr_c,
        bank_we_c => bank_we_c,
        read_en_c => read_en_c,
        mem_addr_c => mem_addr_c,
        --SA signals
        sel_mux_acc => sel_mux_acc,
        sel_mux_adder => sel_mux_adder,
        acc_en => acc_en,
        a_b_en => a_b_en,
        delay_en => delay_en,
        ---Matrices sizes regiders
        N_reg => N_reg,
        M_reg => M_reg,
        P_reg => P_reg,
        --interface signals
        start => start,
        done => done,
        valid_data => valid_data
    );



    

end architecture;

