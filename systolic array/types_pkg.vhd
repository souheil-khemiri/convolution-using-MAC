library ieee;
use ieee.std_logic_1164.all;

package types_pkg is
    type pe_output_array is array (0 to 5) of STD_LOGIC_VECTOR(15 downto 0);
    type pe_input_a is array (0 to 2) of STD_LOGIC_VECTOR(7 downto 0);
    type pe_input_b is array (0 to 5) of STD_LOGIC_VECTOR(7 downto 0);

    subtype int8 is integer range -128 to 127;
    subtype int16 is integer range -32768 to 32767;
end package types_pkg;