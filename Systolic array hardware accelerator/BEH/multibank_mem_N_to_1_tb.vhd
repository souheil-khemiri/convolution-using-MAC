library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity multibank_mem_N_to_1_tb is
end entity;

architecture rtl of multibank_mem_N_to_1_tb is
    -- Constants 
    constant BANK_COUNT     : integer := 6;
    constant ADDR_WIDTH     : integer := 10;
    constant DATA_WIDTH     : integer := 16;
    constant BANK_ADDR_WIDTH : integer := 6;
    constant BANK_SIZE      : integer := 2**BANK_ADDR_WIDTH;
    constant CLK_PERIOD     : time := 10 ns;
    constant PAUSE_CYCLES   : integer := 5;
    constant TEST_DEPTH     : integer := 16; -- How many addresses to test
    
    
    -- Test Signals
    signal clk          : std_logic;
    signal arst_n       : std_logic;

    signal bank_addr    :  std_logic_vector_6_array(0 to BANK_COUNT-1);
    signal bank_data_in :  std_logic_vector_16_array(0 to BANK_COUNT-1);
    signal bank_we      :  std_logic_vector(BANK_COUNT-1 downto 0);

    signal mem_addr     :  std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal mem_data_out :  std_logic_vector(DATA_WIDTH-1 downto 0);
    signal read_en      :  std_logic;

    -- Simulation Control
    signal sim_done     : boolean := false;

    begin
        multibank_mem_N_to_1: entity work.multibank_mem_N_to_1
            generic map (
                BANK_COUNT     => BANK_COUNT,
                ADDR_WIDTH     => ADDR_WIDTH,
                DATA_WIDTH     => DATA_WIDTH,
                BANK_ADDR_WIDTH => BANK_ADDR_WIDTH
            )
            port map (
                clk          => clk,
                arst_n       => arst_n,
                bank_addr    => bank_addr,
                bank_data_in => bank_data_in,
                bank_we      => bank_we,
                mem_addr     => mem_addr,
                mem_data_out => mem_data_out,
                read_en      => read_en
            );

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

        simprocess: process

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
            read_en <= '0';
            arst_n <= '0';
            bank_we <= (others => '0');
            wait for CLK_PERIOD * 2;
            arst_n <= '1';
            wait for CLK_PERIOD;

            
            -- Write Phase: Parallel write to all banks
            report "Starting write phase...";
            bank_we <= (others => '1');

            -- For each address index (address 0 gets 1, address 1 gets 2, etc.)
            for addr_idx in 0 to TEST_DEPTH-1 loop
                -- Set up address for all banks (same address for all banks)
                for bank_idx in 0 to BANK_COUNT-1 loop
                    bank_addr(bank_idx) <= std_logic_vector(to_unsigned(addr_idx, BANK_ADDR_WIDTH));
                    bank_data_in(bank_idx) <= std_logic_vector(to_unsigned(addr_idx+1, DATA_WIDTH));
                end loop;
                -- Report what was written
                report "Written value " & integer'image(addr_idx+1) & 
                        " to Address " & integer'image(addr_idx) & 
                        " of all banks";
                wait for CLK_PERIOD;
            end loop;
            bank_we <= (others => '0');
            
            -- Idle period between write and read phases
            report "Write phase complete. Pausing for " & integer'image(PAUSE_CYCLES) & " cycles...";
            wait for CLK_PERIOD * PAUSE_CYCLES;

            -- Read Phase: Sequential reads through all banks and addresses
            report "Starting read phase...";

             -- Read from each bank sequentially by setting mem_addr
             read_en <= '1';
            for bank_idx in 0 to BANK_COUNT-1 loop
                for addr_idx in 0 to TEST_DEPTH-1 loop
                    -- Create address that selects bank and address within bank
                    mem_addr <= create_addr(bank_idx, addr_idx);
                    
                    -- Need one cycle for read operation
                    wait for CLK_PERIOD;
                    
                    -- Display and verify read results
                    report "Read from Bank " & integer'image(bank_idx) & 
                        " Address " & integer'image(addr_idx) & 
                        " Value = " & integer'image(to_integer(unsigned(mem_data_out)));
                end loop;
            end loop;
            
            wait for CLK_PERIOD * 5;
            -- Finish simulation
            sim_done <= true;
        end process;


    end architecture;