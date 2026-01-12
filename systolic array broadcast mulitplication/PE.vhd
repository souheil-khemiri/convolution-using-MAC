library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity PE is
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
end entity;


architecture rtl of PE is
    signal product : STD_LOGIC_VECTOR(15 downto 0);
    signal sum : STD_LOGIC_VECTOR(15 downto 0);
    constant zero_vector : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
    signal acc_output : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
    signal mux_to_adder : STD_LOGIC_VECTOR(15 downto 0);
    signal mux_to_acc : STD_LOGIC_VECTOR(15 downto 0);

begin
    --resize does not support std_logic_vector
    product <= STD_LOGIC_VECTOR(resize(signed(a)*signed(b),product'length));
    
    --mux_to_adder : using the with <slct signal> select  block
    with sel_adder_mux select
        mux_to_adder <= acc_output when '0',
            zero_vector when others;
    
    sum <= STD_LOGIC_VECTOR(signed(product) + signed(mux_to_adder));

    --mux_to_acc 
    with sel_acc_mux select
        mux_to_acc <= acc_mux_input when '1',
                      sum when others;

    --accumulator process
    process (clk,reset_n)
    begin
        if (reset_n = '0') then
            acc_output <= (others => '0');
        elsif (clk'event and clk = '1') then
            acc_output <= mux_to_acc;
        end if;
    end process;

    --output
    c <= acc_output;

end architecture;