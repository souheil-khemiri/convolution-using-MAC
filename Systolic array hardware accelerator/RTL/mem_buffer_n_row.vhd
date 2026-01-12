library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_Buffer is
    generic (
        DATA_WIDTH : integer := 8;
        DEPTH : integer := 32;
        NUM_ROWS : integer   
    );
    port (
        clk : in std_logic;
        reset_n : in std_logic;
        read_enable : in std_logic;
        -- Vector of write enables for each row
        write_enable : in std_logic_vector(NUM_ROWS-1 downto 0);
        -- Data input/output sized for N rows
        data_in : in std_logic_vector(NUM_ROWS*DATA_WIDTH-1 downto 0);
        data_out : out std_logic_vector(NUM_ROWS*DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of Memory_Buffer is
    -- Single row memory type
    type mem_array is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    -- N-row memory type
    type mem_rows is array (0 to NUM_ROWS-1) of mem_array;
    signal mem : mem_rows := (others => (others => (others => '0')));
    
    -- Array of write pointers (one per row)
    type ptr_array is array (0 to NUM_ROWS-1) of integer range 0 to DEPTH-1;
    signal write_ptrs : ptr_array := (others => 0);
    signal read_ptr : integer range 0 to DEPTH-1 := 0;

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                read_ptr <= 0;
                write_ptrs <= (others => 0);
                data_out <= (others => '0');
            else
                -- Independent write to each row
                for i in 0 to NUM_ROWS-1 loop
                    if write_enable(i) = '1' then
                        mem(i)(write_ptrs(i)) <= data_in((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH);
                        write_ptrs(i) <= (write_ptrs(i) + 1) mod DEPTH;
                    end if;
                end loop;
                
                -- Synchronized read from all rows
                if read_enable = '1' then
                    for i in 0 to NUM_ROWS-1 loop
                        data_out((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= mem(i)(read_ptr);
                    end loop;
                    read_ptr <= (read_ptr + 1) mod DEPTH;
                end if;
            end if;
        end if;
    end process;
end architecture;