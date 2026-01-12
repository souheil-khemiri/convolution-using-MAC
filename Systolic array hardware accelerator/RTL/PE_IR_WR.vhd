--PE_IR_WR : Processing Element Input Register Weight Register
--This PE elemnt is for SA multiplication where:
--Weights are moving systolically 
--Inputs are moving systolicallybroadcast
--Output is stationary

 library ieee;
 use ieee.std_logic_1164.all;
 use ieee.numeric_std.all;
 use ieee.math_real.all;
 
 use work.types_pkg;

 entity PE_IR_WR is
    port (
        clk   : in std_logic;
        arst_n : in std_logic;
        a_in : in STD_LOGIC_VECTOR(7 downto 0);
        b_in : in STD_LOGIC_VECTOR(7 downto 0);
        acc_mux_input : STD_LOGIC_VECTOR(15 downto 0);
        sel_adder_mux : in STD_LOGIC;
        sel_acc_mux : in STD_LOGIC;
        c_out : out STD_LOGIC_VECTOR(15 downto 0);
        a_out : out STD_LOGIC_VECTOR(7 downto 0);
        b_out : out STD_LOGIC_VECTOR(7 downto 0);
        --Enable signals
        a_en, b_en, acc_en : in STD_LOGIC 

    );
 end entity;
architecture rtl of PE_IR_WR is
    signal a_register, b_register :  STD_LOGIC_VECTOR(7 downto 0);
    signal product : STD_LOGIC_VECTOR(15 downto 0);
    signal sum : STD_LOGIC_VECTOR(15 downto 0);
    constant zero_vector : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
    signal acc_output : STD_LOGIC_VECTOR(15 downto 0);
    signal mux_to_adder : STD_LOGIC_VECTOR(15 downto 0);
    signal mux_to_acc : STD_LOGIC_VECTOR(15 downto 0);


begin

    product <= STD_LOGIC_VECTOR(resize(signed(a_register)*signed(b_register),product'length));

    -- adder multiplexer selection
    -- when "sel_adder_mux" is 1 adder gets accumulator output otherwise gets 0 vector.
    with sel_adder_mux select
        mux_to_adder <= acc_output when '1',
            zero_vector when others;

    
    sum <= STD_LOGIC_VECTOR(signed(product) + signed(mux_to_adder));

    --accumulation multiplexer selection
    --when "sel_acc_mux" is 1 accumulator gets sum otherwise it gets external input form upper PE accumulator in the design case of Matrix mult SA.
    with sel_acc_mux select
        mux_to_acc <= sum  when '1',
            acc_mux_input when others;

    
    --accumulator process
    process (clk,arst_n)
    begin
        if (arst_n = '0') then
            acc_output <= (others => '0');
        elsif (clk'event and clk = '1') then
            if(acc_en ='1') then
                acc_output <= mux_to_acc;
            end if; 
        end if;
    end process;

    -- a register process
    process (clk, arst_n)
    begin
        if (arst_n = '0') then
            a_register <= (others => '0');
        elsif (clk'event and clk = '1') then
            if(a_en ='1') then
                a_register <= a_in;
            end if; 
        end if;
    end process;
        
    -- b register process
    process (clk, arst_n)
    begin
        if (arst_n = '0') then
            b_register <= (others => '0');
        elsif (clk'event and clk = '1') then
            if(b_en ='1') then
                b_register <= b_in;
            end if; 
        end if;
    end process;

    c_out <= acc_output;
    a_out <= a_register;
    b_out <= b_register; 



    

end architecture;