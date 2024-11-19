library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity controlpath is

    port (
        clk   : in std_logic;
        conv_size : in std_logic_vector(4 downto 0); -- size of the batch ot be calculated
        start : in std_logic;
        
        --filter select
        filter_sel : out std_logic_vector(1 downto 0);
        --accumulator
        acc_rst : out std_logic;
        --Memory
        ram_in_adrs : out std_logic_vector(4 downto 0);
        ram_out_adrs : out std_logic_vector(4 downto 0);
        ram_out_we : out std_logic
        
    );
end entity;

architecture rtl of controlpath is
type fsm_states is (idle,clear_and_load,MAC_0,MAC_1,MAC_2);
signal current_state, next_state : fsm_states;
signal MAC_counter : integer;
signal it_number : integer;
signal ram_in_adrs_sig , ram_out_adrs_sig : std_logic_vector(4 downto 0);
begin
    ram_in_adrs <= ram_in_adrs_sig;
    ram_out_adrs <= ram_out_adrs_sig ; 
    --sync process
    sync : process(clk,start)
    begin
        if (start = '0') then 
           current_state <= idle;
        elsif (clk = '1' and clk'event) then
            current_state <= next_state;
        end if;
    end process;

    --next logic process
    next_logic : process(current_state,start)
    begin
            case current_state is

                when idle =>
                if start = '1' then
                    next_state <= clear_and_load ;
                end if;

                when clear_and_load =>
                if (start ='0') then
                    next_state <= idle ;
                elsif (MAC_counter = 0) then
                    next_state <= MAC_0;
                end if ;
                
                when MAC_0 =>
                if (start='0') then
                    next_state <= idle;
                elsif (MAC_counter=1) then
                    next_state <= MAC_1 ;
                end if;

                when MAC_1 => 
                if (start = '0') then
                    next_state <=  idle;
                elsif MAC_counter = 2 then
                    next_state <= MAC_2;
                end if ;

                when MAC_2 =>
                if (start = '0') then
                    next_state <=  idle;
                    --checking if batch calculation is finished.
                elsif (it_number < to_integer(unsigned(conv_size)))then 
                    next_state <= clear_and_load;
                elsif (it_number <= to_integer(unsigned(conv_size)) )then
                    next_state <= idle;
                end if ;

            end case;
        end process;


        --Output logic
        process(current_state)
        begin
            case current_state is


                when idle => 
                    acc_rst <= '1';
                    ram_out_we <= '0';
                    ram_in_adrs_sig <= (others => '0');
                    ram_out_adrs_sig <= (others => '0');
                    MAC_counter <= 0;
                    it_number <= 0;

                when clear_and_load => 
                    ram_out_we <= '0';
                    acc_rst <= '1';
                    if (ram_in_adrs_sig /= "00000" ) then
                        ram_in_adrs_sig <= std_logic_vector(unsigned(ram_in_adrs_sig) + 1);
                        ram_out_adrs_sig <= std_logic_vector(unsigned(ram_out_adrs_sig) + 1);   
                    end if;
                    MAC_counter <= 0;
                    it_number <= it_number + 1 ;

                when MAC_0 =>
                    filter_sel <= "00";
                    MAC_counter <= 0;

                when MAC_1 =>
                    filter_sel <= "01";
                    MAC_counter <=  1 ;

                when MAC_2 =>
                    filter_sel <="01";
                    MAC_counter <= 2;
                    ram_out_we <='1';

            end case;
                
        end process;

end architecture;