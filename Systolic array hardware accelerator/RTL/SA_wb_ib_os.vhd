library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.types_pkg.all;

--Clock enable could be added added to hold the values in the accumulator for clock cycles after multiplication process is done. PE needs to be modified.
--Array could be also be made generic.
entity SA_wb_ib_os is
    port (
        clk   : in std_logic;
        reset_n : in std_logic;
        a : in pe_input_a;
        b : in pe_input_b;
        sel_mux_acc : in STD_LOGIC;
        sel_mux_adder : in STD_LOGIC;
        c_array : out pe_output_array;
        c1,c2 : out pe_output_array
    );
end entity;

architecture rtl of SA_wb_ib_os is
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
    --downstream signals
    signal c_downstream_1, c_downstream_2 : pe_output_array;  

begin
    c1 <= c_downstream_1;
    c2 <= c_downstream_2;

    gen_systolic_array_row: for i in 0 to 2 generate
        gen_systolic_array_column : for j in 0 to 5 generate
            gen_systolic_array_row_0 : if (i = 0) generate
            pe_row_0: PE
                port map (
                    clk => clk,
                    reset_n => reset_n,
                    a => a(i),
                    b => b(j),
                    acc_mux_input => (others => '0'), -- first array gets 0
                    sel_adder_mux => sel_mux_adder,
                    sel_acc_mux => sel_mux_acc,
                    c => c_downstream_1(j) 
                );
            end generate;
            gen_systolic_array_row_1 : if (i = 1) generate
                pe_row_1: PE
                    port map (
                        clk => clk,
                        reset_n => reset_n,
                        a => a(i),
                        b => b(j),
                        acc_mux_input => c_downstream_1(j), -- previous row's output
                        sel_adder_mux => sel_mux_adder,
                        sel_acc_mux => sel_mux_acc,
                        c => c_downstream_2(j) 
                    );
            end generate;
            gen_systolic_array_row_2 : if (i = 2) generate
                pe_row_2 : PE
                port map (
                    clk => clk,
                    reset_n => reset_n,
                    a => a(i),
                    b => b(j),
                    acc_mux_input => c_downstream_2(j), -- previous row's output
                    sel_adder_mux => sel_mux_adder,
                    sel_acc_mux => sel_mux_acc,
                    c => c_array(j)
                );
            end generate;
        end generate;
    end generate;
    
        

    

end architecture;