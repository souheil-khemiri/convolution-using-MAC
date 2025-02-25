library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RegisterFile is
  generic (
    DATA_WIDTH : integer := 32;
    NUM_ROWS   : integer := 10
  );
  port (
    clk       : in  std_logic;
    wr_en     : in  std_logic;
    wr_addr   : in  integer range 0 to NUM_ROWS-1;
    wr_data   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    rd_addr   : in  integer range 0 to NUM_ROWS-1;
    rd_data   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    rd_all    : out std_logic_vector(NUM_ROWS*DATA_WIDTH-1 downto 0) -- 10 outputs at once
  );
end entity;

architecture Behavioral of RegisterFile is
  type reg_array is array (0 to NUM_ROWS-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal registers : reg_array;
begin
  -- Write Operation (Synchronous)
  process(clk)
  begin
    if rising_edge(clk) then
      if wr_en = '1' then
        registers(wr_addr) <= wr_data;
      end if;
    end if;
  end process;

  -- Parallel Read Output
  process(registers)
  begin
    for i in 0 to NUM_ROWS-1 loop
      rd_all((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= registers(i);
    end loop;
  end process;

  -- Single Row Read (for debugging)
  rd_data <= registers(rd_addr);
end Behavioral;
------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MultiBankedSRAM is
  generic (
    DATA_WIDTH : integer := 32;
    ADDR_WIDTH : integer := 4;  -- Assuming 16 locations per bank
    NUM_BANKS  : integer := 10  -- 10 banks for 10 parallel outputs
  );
  port (
    clk        : in  std_logic;
    wr_en      : in  std_logic_vector(NUM_BANKS-1 downto 0);
    wr_addr    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    wr_data    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    rd_addr    : in  std_logic_vector(NUM_BANKS*(ADDR_WIDTH) -1 downto 0); -- 10 addresses
    rd_data    : out std_logic_vector(NUM_BANKS*(DATA_WIDTH) -1 downto 0) -- 10 outputs
  );
end entity;

architecture Behavioral of MultiBankedSRAM is
  type sram_bank is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
  type sram_type is array (0 to NUM_BANKS-1) of sram_bank;
  signal banks : sram_type;
begin
  -- Read Process (Synchronous)
  process(clk)
  begin
    if rising_edge(clk) then
      for i in 0 to NUM_BANKS-1 loop
        rd_data((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= banks(i)(to_integer(unsigned(rd_addr((i+1)*ADDR_WIDTH-1 downto i*ADDR_WIDTH))));
      end loop;
    end if;
  end process;

  -- Write Process (Synchronous)
  process(clk)
  begin
    if rising_edge(clk) then
      for i in 0 to NUM_BANKS-1 loop
        if wr_en(i) = '1' then
          banks(i)(to_integer(unsigned(wr_addr))) <= wr_data;
        end if;
      end loop;
    end if;
  end process;
end Behavioral;
----------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_Buffer is
    generic (
        DATA_WIDTH : integer := 8;
        DEPTH : integer := 32
    );
    port (
        clk   : in std_logic;
        reset_n : in std_logic;
        read_enable : in std_logic;
        write_enable : in std_logic;
        data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of Memory_Buffer is
    type mem_array is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mem : mem_array := (others => (others => '0'));
    signal read_ptr, write_ptr : integer range 0 to DEPTH-1 := 0;

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                read_ptr <= 0;
                write_ptr <= 0;
            elsif write_enable = '1' then
                mem(write_ptr) <= data_in;
                write_ptr <= (write_ptr + 1) mod DEPTH;
            end if;
            if read_enable = '1' then
                data_out <= mem(read_ptr);
                read_ptr <= (read_ptr + 1) mod DEPTH;
            end if;
        end if;
    end process;
end architecture;
