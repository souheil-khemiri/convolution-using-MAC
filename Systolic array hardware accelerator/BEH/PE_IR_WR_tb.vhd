library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity PE_IR_WR_tb is
end entity;

architecture tb of PE_IR_WR_tb is
    -- Component declaration
    component PE_IR_WR is
        port (
            clk, arst_n : in std_logic;
            a_in, b_in : in std_logic_vector(7 downto 0);
            acc_mux_input : in std_logic_vector(15 downto 0);
            sel_adder_mux, sel_acc_mux : in std_logic;
            c_out : out std_logic_vector(15 downto 0);
            a_out, b_out : out std_logic_vector(7 downto 0);
            a_en, b_en, acc_en : in std_logic
        );
    end component;

    -- Test signals
    signal clk, arst_n : std_logic;
    signal a_in, b_in : std_logic_vector(7 downto 0);
    signal acc_mux_input : std_logic_vector(15 downto 0);
    signal sel_adder_mux, sel_acc_mux : std_logic;
    signal c_out : std_logic_vector(15 downto 0);
    signal a_out, b_out : std_logic_vector(7 downto 0);
    signal a_en, b_en, acc_en : std_logic;

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin
    -- DUT instantiation
    dut: PE_IR_WR 
        port map (
            clk => clk, arst_n => arst_n,
            a_in => a_in, b_in => b_in,
            acc_mux_input => acc_mux_input,
            sel_adder_mux => sel_adder_mux,
            sel_acc_mux => sel_acc_mux,
            c_out => c_out,
            a_out => a_out, b_out => b_out,
            a_en => a_en, b_en => b_en, acc_en => acc_en
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    simproc : process 
    begin
        --6 control signals
        --reset system
        arst_n <= '0';
        acc_en <= '0';
        a_en <='0';
        b_en <='0';
        sel_adder_mux <='0'; -- start addition with 0 value
        sel_acc_mux <='1'; -- accumulator is fed the sum 
        wait for clk_period;

        --set inputs => start execution
        a_in <= STD_LOGIC_VECTOR(to_signed(1,8));
        b_in <= STD_LOGIC_VECTOR(to_signed(1,8));
        acc_mux_input <= STD_LOGIC_VECTOR(to_signed(55,16));
        arst_n <='1';
        acc_en <= '1';
        a_en <='1';
        b_en <='1';
        wait for clk_period;

        -- clk_1 :  mux_to_acc = 1st prod / acc_output = 0 or undifined ?! need to check

        --set inputs for clock 2 / change sel_adder_mux so that we start accumulating 
        a_in <= STD_LOGIC_VECTOR(to_signed(2,8));
        b_in <= STD_LOGIC_VECTOR(to_signed(2,8));
        sel_adder_mux <= '1';
        wait for clk_period;

        --clk_2 : mux_to_acc = 1st prod + 2nd prod / acc_output = 1st prod

        --set inputs for clock 3 
        a_in <= STD_LOGIC_VECTOR(to_signed(1,8));
        b_in <= STD_LOGIC_VECTOR(to_signed(2,8));
        wait for clk_period;
        
        --clk_3 : mux_to_acc = 1st prod + 2nd prod + 3rd prod / acc_output = 1st prod + 2nd prod

        --one extra clock cycle to latch acc_output <= mux_to_acc = 1st prod + 2nd prod + 3rd prod
        wait for clk_period;
        
        --clk_4 : acc_output = 1st prod + 2nd prod + 3rd prod =1+4+2=7

        -- disable clock for acc to hold  the value / set se acc_mux for the shift down
        -- wait for some clock cycles to obseve any problem
        acc_en<='0';
        sel_acc_mux <= '0';
        wait for 5*clk_period;


        --shift down
        acc_en<='1';
        wait for clk_period;
        wait;



        
    end process;















    -- -- Stimulus process
    -- stim_proc: process
    -- begin
    --     -- Reset test
    --     arst_n <= '0';
    --     wait for clk_period*2;
    --     arst_n <= '1';
    --     wait for clk_period;

    --     -- Test case 1: Basic multiplication
    --     a_en <= '1'; b_en <= '1'; acc_en <= '1';
    --     a_in <= std_logic_vector(to_signed(2, 8));  -- 2
    --     b_in <= std_logic_vector(to_signed(3, 8));  -- 3
    --     sel_adder_mux <= '0';  -- Use zero
    --     sel_acc_mux <= '1';    -- Use multiplier result
    --     wait for clk_period;
    --     assert signed(c_out) = 6 
    --         report "Test 1: Basic multiplication failed" 
    --         severity error;

    --     -- Test case 2: Accumulation
    --     a_in <= std_logic_vector(to_signed(2, 8));  -- 2
    --     b_in <= std_logic_vector(to_signed(2, 8));  -- 2
    --     sel_adder_mux <= '0';  -- Use accumulator
    --     wait for clk_period;
    --     assert signed(c_out) = 10 
    --         report "Test 2: Accumulation failed" 
    --         severity error;

    --     -- Test case 3: External input
    --     acc_mux_input <= std_logic_vector(to_signed(16, 16));
    --     sel_acc_mux <= '1';    -- Select external input
    --     wait for clk_period;
    --     assert signed(c_out) = 16 
    --         report "Test 3: External input failed" 
    --         severity error;

    --     -- Test case 4: Disabled registers
    --     a_en <= '0'; b_en <= '0';
    --     a_in <= std_logic_vector(to_signed(15, 8));
    --     b_in <= std_logic_vector(to_signed(15, 8));
    --     wait for clk_period;
    --     assert signed(c_out) = 16 
    --         report "Test 4: Register disable failed" 
    --         severity error;

    --     -- End simulation
    --     wait for clk_period*2;
    --     assert false report "Test completed successfully" 
    --         severity note;
        
    --     --shift 0 vector down from acc to output
    --     sel_acc_mux <= '0';
    --     wait for 2 * clk_period;
    --     wait;
    -- end process;

end architecture;