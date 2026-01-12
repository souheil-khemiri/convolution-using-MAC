library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity multibank_mem_1_to_N_tb is
end multibank_mem_1_to_N_tb;

architecture behavioral of multibank_mem_1_to_N_tb is
    -- Constants matching DUT
    constant BANK_COUNT     : integer := 6;
    constant ADDR_WIDTH     : integer := 10;
    constant DATA_WIDTH     : integer := 8;
    constant BANK_ADDR_WIDTH : integer := 6;
    constant BANK_SIZE      : integer := 2**BANK_ADDR_WIDTH;
    constant CLK_PERIOD     : time := 10 ns;
    constant PAUSE_CYCLES   : integer := 5;
    constant TEST_DEPTH     : integer := 16; -- How many addresses to test
    
    
    -- Test Signals
    signal clk          : std_logic;
    signal arst_n       : std_logic;
    signal mem_addr     : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal mem_data     : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal mem_we       : std_logic;
    signal bank_addr    : std_logic_vector_6_array(0 to BANK_COUNT-1);
    signal bank_data    : std_logic_vector_8_array(0 to BANK_COUNT-1);
    signal bank_read    : std_logic_vector(BANK_COUNT-1 downto 0);
    
    -- Simulation Control
    signal sim_done     : boolean := false;
    
begin
    -- Instantiate the DUT
    dut: multibank_mem_1_to_N
        generic map (
            BANK_COUNT     => BANK_COUNT,
            ADDR_WIDTH     => ADDR_WIDTH,
            DATA_WIDTH     => DATA_WIDTH,
            BANK_ADDR_WIDTH => BANK_ADDR_WIDTH
        )
        port map (
            clk            => clk,
            arst_n         => arst_n,
            mem_addr       => mem_addr,
            mem_data       => mem_data,
            mem_we         => mem_we,
            bank_addr      => bank_addr,
            bank_data      => bank_data,
            bank_read      => bank_read
        );
    
    -- Clock Generation
    clk_process: process
    begin
        while not sim_done loop
            clk <= '1';
            wait for CLK_PERIOD/2;
            clk <= '0';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;
    
    -- Stimulus Process
    stim_proc: process
        -- Function to create full memory address for bank/addr combination
        function create_addr(bank : integer; addr : integer) return std_logic_vector is
            variable result : std_logic_vector(ADDR_WIDTH-1 downto 0);
        begin
            result := std_logic_vector(to_unsigned(bank, ADDR_WIDTH-BANK_ADDR_WIDTH)) & 
                      std_logic_vector(to_unsigned(addr, BANK_ADDR_WIDTH));
            return result;
        end function;
        
    begin
        -- Reset the DUT
        arst_n <= '0';
        mem_we <= '0';
        bank_read <= (others => '0');
        wait for CLK_PERIOD * 2;
        arst_n <= '1';
        wait for CLK_PERIOD;
        
        -- Write Phase: Fill all banks with sequential values
        report "Starting write phase...";
        
        -- For each address index
        for addr_value in 1 to TEST_DEPTH loop
            -- For each bank, set the same address and value
            for bank_idx in 0 to BANK_COUNT-1 loop
                -- Create address based on bank and addr_value-1 (0-based addressing)
                mem_addr <= create_addr(bank_idx, addr_value-1);
                
                -- All banks have same pattern: addr 0 = 1, addr 1 = 2, etc.
                mem_data <= std_logic_vector(to_unsigned(addr_value, DATA_WIDTH));
                
                -- Enable write and wait a cycle
                mem_we <= '1';
                wait for CLK_PERIOD;
                mem_we <= '0';
                
                -- Report what was written
                report "Written value " & integer'image(addr_value) & 
                       " to Bank " & integer'image(bank_idx) & 
                       " Address " & integer'image(addr_value-1);
                       
                wait for CLK_PERIOD;
            end loop;
        end loop;
        
        -- Idle period between write and read phases
        report "Write phase complete. Pausing for " & integer'image(PAUSE_CYCLES) & " cycles...";
        mem_we <= '0';
        wait for CLK_PERIOD * PAUSE_CYCLES;
        
        -- Read Phase: Read all banks in parallel, one address at a time
        report "Starting read phase...";
        
        -- For each address
        for addr_idx in 0 to TEST_DEPTH-1 loop
            -- Set up same read address for all banks
            for bank_idx in 0 to BANK_COUNT-1 loop
                bank_addr(bank_idx) <= std_logic_vector(to_unsigned(addr_idx, BANK_ADDR_WIDTH));
            end loop;
            
            -- Enable read for all banks and wait a cycle
            bank_read <= (others => '1');
            wait for CLK_PERIOD;
            
            -- Display read results
            for bank_idx in 0 to BANK_COUNT-1 loop
                report "Read from Bank " & integer'image(bank_idx) & 
                       " Address " & integer'image(addr_idx) & 
                       " Value = " & integer'image(to_integer(unsigned(bank_data(bank_idx))));
                
                -- Verify data matches what we wrote (addr_idx+1)
                assert to_integer(unsigned(bank_data(bank_idx))) = addr_idx+1
                    report "Verification failed for Bank " & integer'image(bank_idx) & 
                           " Address " & integer'image(addr_idx) & 
                           ": Expected " & integer'image(addr_idx+1) & 
                           ", Got " & integer'image(to_integer(unsigned(bank_data(bank_idx))))
                    severity error;
            end loop;
            
            -- Disable reads for a cycle
            bank_read <= (others => '0');
            wait for CLK_PERIOD;
        end loop;
        
        report "Read phase complete. Simulation ending...";
        -- End simulation
        wait for CLK_PERIOD * 5;
        sim_done <= true;
        wait;
    end process;
    
end behavioral;