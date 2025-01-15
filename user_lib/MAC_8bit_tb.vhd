library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAC_8bit_tb is
end entity;

architecture rtl of MAC_8bit_tb is
    component MAC_8bit is
        port (
            clk   : in std_logic;
            reset_n : in std_logic;
            input_1 : in STD_LOGIC_VECTOR(7 downto 0);
            input_2 : in STD_LOGIC_VECTOR(7 downto 0);
            accumulator_select : in STD_LOGIC;
            output : out STD_LOGIC_VECTOR(15 downto 0) 
        );
    end component;

    --defining 16bit signed integer type
    subtype int8 is integer range -128 to 127;
    subtype int16 is integer range -32768 to 32767;
    
    --signal initiation
    signal clk, reset_n, accumulator_select : STD_LOGIC;
    signal input_1_int , input_2_int : int8 := 0 ;
    signal input_1_std, input_2_std : STD_LOGIC_VECTOR(7 downto 0);
    signal output : STD_LOGIC_VECTOR(15 downto 0);
    signal output_int16 : int16 := 0;

begin
    mac: MAC_8bit
        port map (
            clk   => clk,
            reset_n => reset_n,
            accumulator_select => accumulator_select,
            input_1 =>input_1_std,
            input_2 =>input_2_std,
            output => output   
        );
        
        --casting inputs and outputs to weak people readable
        input_1_std <= std_logic_vector(to_signed(input_1_int, 8));  
        input_2_std <= std_logic_vector(to_signed(input_2_int, 8));
        output_int16 <= to_integer(signed(output));
        

        process
        begin
            clk <= '1';
            wait for 5 ns ;
            clk <='0';
            wait for 5 ns;
        end process;

        simproc : process 
        begin
            --reset
            reset_n <= '0';
            wait for 10 ns;

            --first batch
            reset_n <= '1';
            input_1_int <= 1;
            input_2_int <= 1;
            accumulator_select <= '0';
            wait for 10 ns;

            --2nd batch
            input_1_int <= 2;
            input_2_int <= 2;
            accumulator_select <= '1';
            wait for 10 ns;

            --3rd batch
            input_1_int <=-2;
            input_2_int <= 3;
            wait for 10 ns;

            --lock value
            accumulator_select <= '0';
            wait;


        end process;
        

    

end architecture;