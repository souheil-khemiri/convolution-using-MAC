library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity controlpath is
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
end entity;

architecture rtl of controlpath is
    type fsm_states is (idle, m11v1, m12v2, m13v3, m21v1, m22v2, m23v3, m31v1, m32v2, m33v3, write_vo );
    signal current_state, next_state : fsm_states;
    signal m_adrs_sig, v_in_adrs_sig, vo_in_adrs_sig : std_logic_vector(4 downto 0);
    
begin
    m_adrs <= m_adrs_sig;
    v_in_adrs <= v_in_adrs_sig;
    vo_in_adrs <= vo_in_adrs_sig;

    --sync process
    sync : process (reset_n, clk)
    begin
        if (reset_n = '0') then 
            current_state <= idle;
        elsif (clk'event and clk = '1') then
            current_state <= next_state;
        end if;
    end process;

    --next logic
    process(current_state, start)
    begin
        case current_state is 
            when idle =>
                m_we <= '0';
                v_we <= '0';
                vo_we <= '0';
                m_adrs_sig <= (others => '0');
                v_in_adrs_sig <= (others => '0');
                vo_in_adrs_sig <= (others => '0');
                accumulator_select <= '0';
                accumulator_reset <= '0';
                if (start = '1') then
                    next_state <= m11v1;
                end if;

            when m11v1 =>
                accumulator_reset <= '1';
                accumulator_select <= '1';
                next_state <= m12v2;
            when m12v2 =>
                m_adrs_sig <= std_logic_vector(unsigned(m_adrs_sig) + 1);
                v_in_adrs_sig <= std_logic_vector(unsigned(v_in_adrs_sig) + 1);
                ---
                next_state <= m13v3 ;
            when m13v3 =>
                m_adrs_sig <= std_logic_vector(unsigned(m_adrs_sig) + 1);
                v_in_adrs_sig <= std_logic_vector(unsigned(v_in_adrs_sig) + 1);
                ---
                next_state <= m21v1;
            when m21v1 => -- save output in memory
                accumulator_select <= '0';
                m_adrs_sig <= std_logic_vector(unsigned(m_adrs_sig) + 1);
                v_in_adrs_sig <= std_logic_vector(unsigned(v_in_adrs_sig) -2);
                ---
                vo_we <= '1';
                ---
                next_state <= m22v2;
            when m22v2 =>
                accumulator_select <= '1';
                m_adrs_sig <= std_logic_vector(unsigned(m_adrs_sig) + 1);
                v_in_adrs_sig <= std_logic_vector(unsigned(v_in_adrs_sig) + 1);
                ---
                vo_we <= '0';
                ---
                next_state <= m23v3 ;
            when m23v3 =>
                m_adrs_sig <= std_logic_vector(unsigned(m_adrs_sig) + 1);
                v_in_adrs_sig <= std_logic_vector(unsigned(v_in_adrs_sig) + 1);
                ---
                next_state <= m31v1;
            when m31v1 => -- save output to memory
                accumulator_select <= '0';
                m_adrs_sig <= std_logic_vector(unsigned(m_adrs_sig) + 1);
                v_in_adrs_sig <= std_logic_vector(unsigned(v_in_adrs_sig) -2);
                ---
                vo_we <= '1';
                vo_in_adrs_sig <= std_logic_vector(unsigned(vo_in_adrs_sig) + 1);
                ---
                next_state <= m32v2;
            when m32v2 =>
                accumulator_select <= '1';
                m_adrs_sig <= std_logic_vector(unsigned(m_adrs_sig) + 1);
                v_in_adrs_sig <= std_logic_vector(unsigned(v_in_adrs_sig) + 1);
                ---
                vo_we <= '0';
                ---
                next_state <= m33v3 ;
            when m33v3 =>
                m_adrs_sig <= std_logic_vector(unsigned(m_adrs_sig) + 1);
                v_in_adrs_sig <= std_logic_vector(unsigned(v_in_adrs_sig) + 1);
                ---
                next_state <= write_vo;
            when write_vo =>
                vo_we <= '1';
                vo_in_adrs_sig <= std_logic_vector(unsigned(vo_in_adrs_sig) + 1);
                next_state <= idle;
            when others =>
                next_state <= idle;
        end case;
    end process;
end architecture;