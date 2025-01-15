library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
    generic (
        filter0 : integer;
        filter1 : integer;
        filter2 : integer
    );
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        sel      : in std_logic_vector(1 downto 0);
        data_in  : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0) 
    );
end entity;

architecture rtl of datapath is

    component filter_select is
        generic (
            val0 : integer ;
            val1 : integer ;
            val2 : integer 
        );
        port (
            sel    : in std_logic_vector(1 downto 0);
            filter : out std_logic_vector(7 downto 0)
        );
    end component;

component accumulator_32_bit is
    generic (
        size_accu: natural := 32
    );
    port (
        clk   : in std_logic;
        rst   : in std_logic;
        D     : in std_logic_vector(31 downto 0);
        Q     : out std_logic_vector(31 downto 0)
    );
end component;


    signal multiplied : std_logic_vector(31 downto 0);
    signal accumulator_in : std_logic_vector(31 downto 0);
    signal accumulator_out : std_logic_vector(31 downto 0);
    signal filter : std_logic_vector(7 downto 0);

begin
    
    filter_select_inst: filter_select
     generic map(
        val0 => filter0,
        val1 => filter1,
        val2 => filter2
    )
     port map(
        sel => sel,
        filter => filter
    );

    accumulator_32_bit_inst: accumulator_32_bit
     generic map(
        size_accu => 32
    )
     port map(
        clk => clk,
        rst => rst,
        D => accumulator_in,
        Q => accumulator_out
    );

    
        
            --resize only works on signed and unsigned types
            --converting input and filter -> multipying -> resizing -> casting to std_logic_vector
            multiplied <= std_logic_vector(resize(signed(filter)*signed(data_in),multiplied'length));
            accumulator_in <= std_logic_vector(signed(multiplied)+signed(accumulator_out));
            data_out <= accumulator_out(7 downto 0);
     
    
end architecture;