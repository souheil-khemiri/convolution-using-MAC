library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;


entity multibank_mem_1_to_N is
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
        mem_data  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        mem_we : in  std_logic;
        
        -- Parallel Read Buses (One per Bank)
        bank_addr : in std_logic_vector_6_array(0 to BANK_COUNT-1);
        --bank_addr : in  std_logic_vector(BANK_COUNT*BANK_ADDR_WIDTH-1 downto 0);
        bank_data : out std_logic_vector_8_array(0 to BANK_COUNT-1);
        --bank_data : out std_logic_vector(BANK_COUNT*DATA_WIDTH-1 downto 0);
        bank_read : in  std_logic_vector(BANK_COUNT-1 downto 0)
    );
end multibank_mem_1_to_N;

architecture RTL of multibank_mem_1_to_N is
    constant BANK_SIZE : integer := 2**BANK_ADDR_WIDTH;
    type mem_array is array (0 to BANK_SIZE) of std_logic_vector(DATA_WIDTH-1 downto 0);
    type bank_array is array (0 to BANK_COUNT-1) of mem_array;
    signal memory : bank_array;        
    
begin
    
    -- Handle Write Requests (Shared Bus)
    process (clk)
        variable bank_select : integer;
        variable bank_addr_int : integer range 0 to BANK_SIZE-1;
    begin
        if rising_edge(clk) then
            if arst_n = '0' then
                memory <= (others => (others => (others => '0')));
            elsif mem_we = '1' then
                bank_select := to_integer(unsigned(mem_addr(ADDR_WIDTH-1 downto BANK_ADDR_WIDTH))); -- Select Bank
                bank_addr_int := to_integer(unsigned(mem_addr(BANK_ADDR_WIDTH-1 downto 0))); -- Select Address
                memory(bank_select)(bank_addr_int) <= mem_data; -- Write Data
               
            end if;
        end if;
    end process;
    
    -- Handle Parallel Reads (Each Bank has its own Read Bus)
    gen_read : for i in 0 to BANK_COUNT-1 generate
        process (clk)
            variable bank_addr_int : integer range 0 to BANK_SIZE-1;
        begin
            if rising_edge(clk) then
                if bank_read(i) = '1' then
                    bank_addr_int := to_integer(unsigned(bank_addr(i)));
                    bank_data(i) <= memory(i)(bank_addr_int);
                    --bank_data((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= memory(i)(bank_addr_int);
                end if;
            end if;
        end process;
    end generate;
    
end RTL;
