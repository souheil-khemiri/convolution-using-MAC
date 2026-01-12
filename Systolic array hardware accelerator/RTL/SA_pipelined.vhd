library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity SA_pipelined is
    generic (
        --Systolic array size
        constant N : INTEGER := 3;
        constant P : INTEGER := 6;
        --Multibank memory common parameters
        constant ADDR_WIDTH : INTEGER := 10;
        constant DATA_WIDTH : INTEGER := 8;
        constant DATA_WIDTH_C : INTEGER := 16;
        constant BANK_ADDR_WIDTH : INTEGER := 6
    );
    port (
        clk     : in  std_logic;
        --Reset signals
        arst_n_sa : in std_logic;
        arst_n_mem_a : in std_logic;
        arst_n_mem_b : in std_logic;
        arst_n_mem_c : in std_logic;
        --Mem signals
        ---A 
        mem_addr_a  : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        mem_data_a  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        mem_we_a : in std_logic;
        bank_addr_a : in std_logic_vector_6_array(0 to N-1);
        bank_read_a : in std_logic_vector(N-1 downto 0);
        ---B
        mem_addr_b  : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        mem_data_b  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        mem_we_b :  in std_logic;
        bank_addr_b : in std_logic_vector_6_array(P-1 downto 0);
        bank_read_b : in std_logic_vector(P-1 downto 0);
        ---C
        bank_addr_c : in std_logic_vector_6_array(0 to P-1);
        bank_we_c : in std_logic_vector(P-1 downto 0);
        read_en_c : in std_logic;
        mem_addr_c  : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        mem_data_out_c : out std_logic_vector(DATA_WIDTH_C-1 downto 0);
        --SA signals
        sel_mux_acc : in std_logic_matrix(0 to N-1, 0 to P-1);
        sel_mux_adder : in std_logic_matrix(0 to N-1, 0 to P-1);
        acc_en  : in std_logic_matrix(0 to N-1, 0 to P-1);
        a_b_en  : in std_logic_matrix(0 to N-1, 0 to P-1);
        delay_en : in std_logic

        -- --Input registers
        -- N_reg : in integer ;
        -- M_reg : in integer ;
        -- P_reg : in integer 
    );
end entity SA_pipelined;

architecture rtl of SA_pipelined is

    signal a : std_logic_vector_8_array(0 to N-1);
    signal b : std_logic_vector_8_array(0 to P-1);
    signal c_array : std_logic_vector_16_array(0 to P-1);
    

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

    

end architecture;