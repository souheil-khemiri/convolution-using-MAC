library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;


entity multibank_mem_N_to_1 is
    Generic (
        BANK_COUNT : integer := 6;   -- Number of memory banks
        ADDR_WIDTH : integer := 10;  -- encodes adresses of 16 banks of 64 words each
        DATA_WIDTH : integer := 16;   -- 16-bit data width
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
end multibank_mem_N_to_1;

architecture RTL of multibank_mem_N_to_1 is
    constant BANK_SIZE : integer := 2**BANK_ADDR_WIDTH;
    type mem_array is array (0 to BANK_SIZE) of std_logic_vector(DATA_WIDTH-1 downto 0);
    type bank_array is array (0 to BANK_COUNT-1) of mem_array;
    signal memory : bank_array;        
    
begin
    
    -- Handle parallel Write Requests (each bank has its own Write Bus)
    process (clk, arst_n)
        variable bank_addr_int : integer range 0 to BANK_SIZE-1;
    begin
        if (arst_n = '0') then
                memory <= (others => (others => (others => '0')));
        elsif rising_edge(clk) then
            for i in 0 to BANK_COUNT-1 loop
                if (bank_we(i) = '1') then
                    bank_addr_int := to_integer(unsigned(bank_addr(i))); -- Select Address
                    memory(i)(bank_addr_int) <= bank_data_in(i); -- Write Data
                    report "Bank " & integer'image(i) & " Address " & integer'image(bank_addr_int) & " Data " & integer'image(to_integer(signed(bank_data_in(i))));
                end if;
            end loop;
        end if;
    end process;
    
    -- Handle single Reads (single read bus shared across all banks)
    process (clk)
        variable bank_addr_int : integer range 0 to BANK_SIZE-1;
        variable bank_select : integer range 0 to BANK_COUNT-1;
    begin
        if (read_en ='1') then
            if rising_edge(clk) then
                bank_select := to_integer(unsigned(mem_addr(ADDR_WIDTH-1 downto BANK_ADDR_WIDTH))); -- Select Bank
                bank_addr_int := to_integer(unsigned(mem_addr(BANK_ADDR_WIDTH-1 downto 0))); -- Select Address
                mem_data_out <= memory(bank_select)(bank_addr_int); -- Read Data
            end if;
        end if;
    end process;
    
end RTL;