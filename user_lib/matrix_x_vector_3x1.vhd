library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library user_lib;
use user_lib.all;


entity matrix_x_vector_3x1 is
    port (
        clk   : in std_logic;
        reset_n,start : in std_logic;
        --datapth
        input_1, input_2: in STD_LOGIC_VECTOR(7 downto 0);
        output : out STD_LOGIC_VECTOR(15 downto 0);
        --controlpath

        --Matrix memory signals
        m_adrs : out std_logic_vector(4 downto 0);
        m_we : out std_logic;

        --Vector memory signals 
        v_in_adrs : out std_logic_vector(4 downto 0);
        v_we : out std_logic;

        -- output vector memory signals
        vo_in_adrs : out std_logic_vector(4 downto 0);
        vo_we : out std_logic
    );
end entity;

architecture rtl of matrix_x_vector_3x1 is
    component controlpath is
        port (
            clk   : in std_logic;
            reset_n, start : in std_logic;
            
    
            --mac control signals
            accumulator_select : out std_logic;
            accumulator_reset : out std_logic;
            
            --Matrix memory signals
            m_adrs : out std_logic_vector(4 downto 0);
            m_we : out std_logic;
    
            --Vector memory signals 
            v_in_adrs : out std_logic_vector(4 downto 0);
            v_we : out std_logic;
    
            -- output vector memory signals
            vo_in_adrs : out std_logic_vector(4 downto 0);
            vo_we : out std_logic
            
        );
    end component;

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

    signal accumulator_select_sig : STD_LOGIC;
    signal accumulator_reset_n : STD_LOGIC;

begin
    accumulator_reset_n <= reset_n;

    controlpath_inst: entity user_lib.controlpath

        port map (
            clk   => clk,
            start => start,
            reset_n => reset_n,
            accumulator_select =>accumulator_select_sig,
            accumulator_reset => accumulator_reset_n,
            m_adrs => m_adrs,
            m_we=> m_we,
            v_in_adrs => v_in_adrs,
            v_we => v_we,
            vo_in_adrs => vo_in_adrs,
            vo_we => vo_we
        );

    MAC_8bit_inst: entity user_lib.MAC_8bit
     port map(
        clk => clk,
        reset_n => reset_n,
        input_1 => input_1,
        input_2 => input_2,
        accumulator_select => accumulator_select_sig,
        output => output
    );

    

end architecture;