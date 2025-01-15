library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAC_8bit is
    port (
        clk   : in std_logic;
        reset_n : in std_logic;
        input_1 : in STD_LOGIC_VECTOR(7 downto 0);
        input_2 : in STD_LOGIC_VECTOR(7 downto 0);
        accumulator_select : in STD_LOGIC;
        output : out STD_LOGIC_VECTOR(15 downto 0)
    );
end entity;

architecture rtl of MAC_8bit is
    signal product : STD_LOGIC_VECTOR(16 downto 0);
    signal sum : STD_LOGIC_VECTOR(31 downto 0);
    constant zero_vector : STD_LOGIC_VECTOR(31 downto 0) := (others =>'0');
    signal accumulator : STD_LOGIC_VECTOR(31 downto 0) := (others=>'0');
    signal mux_out : STD_LOGIC_VECTOR(31 downto 0);

begin
    --resize does not support std_logic_vector
    product <= STD_LOGIC_VECTOR(resize(signed(input_1)*signed(input_2),product'length));
    
    --mux_out : uing the with <slct signal> select  block
    with accumulator_select select
        mux_out <= accumulator when '1',
            zero_vector when others;
    
    sum <= STD_LOGIC_VECTOR(resize(signed(product),sum'length) + signed(mux_out));

    --accumulator process
    process (clk,reset_n)
    begin
        if (reset_n = '0') then
            accumulator <= (others => '0');
        elsif (clk'event and clk = '1') then
            accumulator <= sum;
        end if;
    end process;

    --output
    output <= accumulator(15 downto 0);

end architecture;
