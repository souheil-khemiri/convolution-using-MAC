library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity PE_tb is
end entity;

architecture rtl of PE_tb is
    component PE is
        port (
            clk   : in std_logic;
            reset_n : in std_logic;
            a : in STD_LOGIC_VECTOR(7 downto 0);
            b : in STD_LOGIC_VECTOR(7 downto 0);
            acc_mux_input : STD_LOGIC_VECTOR(15 downto 0);
            sel_adder_mux : in STD_LOGIC;
            sel_acc_mux : in STD_LOGIC;
            c : out STD_LOGIC_VECTOR(15 downto 0)
            
        );
    end component;

    --defining 16bit signed integer type
    subtype int8 is integer range -128 to 127;
    subtype int16 is integer range -32768 to 32767;

    --signals
    signal clk, reset_n,sel_adder_mux,sel_acc_mux  : STD_LOGIC;
    signal a,b : STD_LOGIC_VECTOR(7 downto 0);
    signal c : STD_LOGIC_VECTOR(15 downto 0);
    signal acc_mux_input : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal a_int8 , b_int8 : int8 := 0 ;
    signal c_int16 : int16 := 0;


begin   

    PE_inst: PE
        port map (
            clk   => clk,
            reset_n => reset_n,
            a => a,
            b => b,
            acc_mux_input => acc_mux_input,
            sel_adder_mux => sel_adder_mux,
            sel_acc_mux => sel_acc_mux,
            c => c 
            
        );

        --casting inputs and outputs to weak people readable
        a <= STD_LOGIC_VECTOR(to_signed(a_int8,8)); -- convert integer type to signed bin
        b <= STD_LOGIC_VECTOR(to_signed(b_int8,8));
        c_int16 <= TO_INTEGER(signed(c)); --used as a type conversion function to convert a STD_LOGIC_VECTOR to a signed type.
    

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
            a_int8 <= 1;
            b_int8 <= 1;
            sel_adder_mux <= '0';
            sel_acc_mux <= '0';
            wait for 10 ns;

            --2nd batch
            a_int8 <= 2;
            b_int8 <= 2;
            sel_adder_mux <= '0';
            wait for 10 ns;

            --3rd batch
            a_int8 <=-2;
            b_int8 <= 3;
            wait for 10 ns;

            --lock value
            sel_acc_mux <= '1';
            wait;


        end process;
    

end architecture;