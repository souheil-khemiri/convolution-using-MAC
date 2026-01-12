library ieee;
use ieee.std_logic_1164.all;

package types_pkg is
    --types
    type std_logic_vector_6_array is array (natural range <>) of STD_LOGIC_VECTOR(5 downto 0);
    type std_logic_vector_8_array is array (natural range <>) of STD_LOGIC_VECTOR(7 downto 0);
    type std_logic_vector_10_array is array (natural range <>) of STD_LOGIC_VECTOR(9 downto 0);
    type std_logic_vector_16_array is array (natural range <>) of STD_LOGIC_VECTOR(15 downto 0);
    type pe_output_array is array (0 to 5) of STD_LOGIC_VECTOR(15 downto 0);
    type pe_input_a is array (0 to 2) of STD_LOGIC_VECTOR(7 downto 0);
    type pe_input_b is array (0 to 5) of STD_LOGIC_VECTOR(7 downto 0);
    subtype int8 is integer range -128 to 127;
    subtype int16 is integer range -32768 to 32767;
    type std_logic_matrix is array (natural range <>, natural range <>) of std_logic;

    --components declaration
    component delay_block_8 is
        generic (
            block_size : integer
        );
        port (
            clk    : in std_logic;
            arst_n : in std_logic;
            ce     : in std_logic;
            D_array : in std_logic_vector_8_array(0 to block_size-1);
            Q_array : out std_logic_vector_8_array(0 to block_size-1)
        );
    end component;

    component SA_wm_im_so is
        generic (
            N : integer;
            M : integer;
            P : integer
        );
        port (
            clk     : in std_logic;
            arst_n  : in std_logic;
            a       : in std_logic_vector_8_array(0 to N-1);
            b       : in std_logic_vector_8_array(0 to P-1);
            sel_mux_acc : in std_logic_matrix(0 to N-1, 0 to P-1);
            sel_mux_adder : in std_logic_matrix(0 to N-1, 0 to P-1);
            acc_en  : in std_logic_matrix(0 to N-1, 0 to P-1);
            a_b_en  : in std_logic_matrix(0 to N-1, 0 to P-1);
            c_array : out std_logic_vector_16_array(0 to P-1)
        );
    end component;

    component SA_wm_im_so_delay is
            generic (
                N : integer;  -- Number of rows in matrix A and C
                M : integer;  -- Number of columns in A and number or rows in B
                P : integer   -- Number of columns in matrix B and C
            );
            port (
                clk     : in  std_logic;
                arst_n   : in  std_logic;
                a : in std_logic_vector_8_array(0 to N-1);
                b : in std_logic_vector_8_array(0 to P-1);
                --mux ports
                sel_mux_acc : in std_logic_matrix( 0 to N-1, 0 to P-1);
                sel_mux_adder : in std_logic_matrix( 0 to N-1, 0 to P-1);
                --enable signals
                acc_en : in std_logic_matrix(0 to N-1, 0 to P-1); --array of ( 0 to N-1, 0 to P-1) STD_LOGIC;
                a_b_en : in std_logic_matrix(0 to N-1, 0 to P-1);
                -- delay enable signal
                delay_en : in std_logic;
                --output
                c_array : out std_logic_vector_16_array(0 to P-1)
            );
    end component;

    component multibank_mem_1_to_N is
        Generic (
            BANK_COUNT : integer := 6;   -- Number of memory banks
            ADDR_WIDTH : integer := 10;  -- encodes adresses of 16 banks of 64 words each
            DATA_WIDTH : integer := 8;   -- 8-bit data width
            BANK_ADDR_WIDTH  : integer := 6  -- 2^6 = 64 words
        );
        Port (
            -- System Clock & Reset
            clk          : in  std_logic;
            arst_n       : in  std_logic;
            
            -- Single Write Bus (Shared across all banks)
            mem_addr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            mem_data  : in  std_logic_vector(DATA_WIDTH downto 0);
            mem_we : in  std_logic;
            
            -- Parallel Read Buses (One per Bank)
            bank_addr : in std_logic_vector_6_array(0 to BANK_COUNT-1);
            --bank_addr : in  std_logic_vector(BANK_COUNT*BANK_ADDR_WIDTH-1 downto 0);
            bank_data : out std_logic_vector_8_array(0 to BANK_COUNT-1);
            --bank_data : out std_logic_vector(BANK_COUNT*DATA_WIDTH-1 downto 0);
            bank_read : in  std_logic_vector(BANK_COUNT-1 downto 0)
        );
    end component;

    component multibank_mem_N_to_1 is  
        Generic (
            BANK_COUNT : integer := 6;   -- Number of memory banks
            ADDR_WIDTH : integer := 10;  -- encodes adresses of 16 banks of 64 words each
            DATA_WIDTH : integer := 8;   -- 8-bit data width
            BANK_ADDR_WIDTH  : integer := 6  -- 2^6 = 64 words
        );
        Port (
            -- System Clock & Reset
            clk          : in  std_logic;
            arst_n       : in  std_logic;
            
            -- Parallel write Buses (One per Bank)
            bank_addr : in std_logic_vector_6_array(0 to BANK_COUNT-1);
            bank_data_in : in std_logic_vector_16_array(0 to BANK_COUNT-1);
            bank_we : in  std_logic_vector(BANK_COUNT-1 downto 0);
    
    
            -- Single read Bus (Shared across all banks)
            read_en : in  std_logic;
            mem_addr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            mem_data_out  : out  std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component SA_pipelined is
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

            --Input registers
            -- N_reg : in integer ;
            -- M_reg : in integer ;
            -- P_reg : in integer 
        );
        end component;

    component SA_pipelined_beh is
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
            P_reg : in integer ;
            ---interface signals
            start : in std_logic;
            done : out std_logic;
            valid_data : in std_logic 
        );
    end component;

    component SA_pipelined_beh_fs is
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
    end component;

    -- type SA_signal is record
    --     --Reset signals
    --     arst_n_sa : std_logic;
    --     arst_n_mem_a : std_logic;
    --     arst_n_mem_b : std_logic;
    --     arst_n_mem_c : std_logic;
    --     ---A 
    --     mem_addr_a  :  std_logic_vector(ADDR_WIDTH-1 downto 0);
    --     --mem_data_a  : in std_logic_vector(DATA_WIDTH-1 downto 0);
    --     mem_we_a :  std_logic;
    --     bank_addr_a :  std_logic_vector_6_array(0 to N-1);
    --     bank_read_a :  std_logic_vector(N-1 downto 0);
    --     ---B
    --     mem_addr_b  :  std_logic_vector(ADDR_WIDTH-1 downto 0);
    --     --mem_data_b  : in std_logic_vector(DATA_WIDTH-1 downto 0);
    --     mem_we_b :   std_logic;
    --     bank_addr_b :  std_logic_vector_6_array(P-1 downto 0);
    --     bank_read_b :  std_logic_vector(P-1 downto 0);
    --     ---C
    --     bank_addr_c :  std_logic_vector_6_array(0 to P-1);
    --     bank_we_c :  std_logic_vector(P-1 downto 0);
    --     read_en_c :  std_logic;
    --     mem_addr_c  :  std_logic_vector(ADDR_WIDTH-1 downto 0);
    --     --mem_data_out_c : out std_logic_vector(DATA_WIDTH_C-1 downto 0);
    --     --SA signals
    --     sel_mux_acc :  std_logic_matrix(0 to N-1, 0 to P-1);
    --     sel_mux_adder :  std_logic_matrix(0 to N-1, 0 to P-1);
    --     acc_en  :  std_logic_matrix(0 to N-1, 0 to P-1);
    --     a_b_en  :  std_logic_matrix(0 to N-1, 0 to P-1);
    --     delay_en :  std_logic;
        
    -- end record;



end package types_pkg;