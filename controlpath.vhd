library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity controlpath is
    port (
        clk   : in std_logic;
        conv_size : in std_logic_vector(4 downto 0); -- size of the batch to be calculated
        start , rst : in std_logic;

        
        --filter select
        filter_sel : out std_logic_vector(1 downto 0);
        --accumulator
        acc_rst : out std_logic;

        --Memory bank r(read)
        mem_r_adrs : out std_logic_vector(4 downto 0);
        mem_r_we : out std_logic;

        --memory bank w(write)
        mem_w_adrs : out std_logic_vector(4 downto 0);
        mem_w_we : out std_logic
    );
end entity;

architecture rtl of controlpath is

type fsm_states is (s1, s2, s3, s4, s5, s6, s7);

signal current_state, next_state : fsm_states;
signal it_number : integer;
signal mem_r_adrs_sig, mem_w_adrs_sig : std_logic_vector(4 downto 0);

begin
    mem_r_adrs <= mem_r_adrs_sig;
    mem_w_adrs <= mem_w_adrs_sig; 

    --sync process
    sync : process(clk, start)
    begin
        if (rst = '1') then 
            current_state <= s1;
        elsif (clk = '1' and clk'event) then
            current_state <= next_state;
        end if;
    end process;

    --next logic process
    next_logic : process(current_state, start)

    begin
        case current_state is
            
            when s1 => --idle 
                if start = '1' then
                    next_state <= s2;
                end if;

            when s2 =>  -- Call address i of mem_r and mem_
                next_state <= s3;

            when s3 => -- mem_r 1 value available / sel filter 00 / Call address i+1 of mem_r / start accumulating rst =0
                    next_state <= s4;

            when s4 =>-- accu outputs mac 1 / mem_r 2 available /select filter 01 / call mem_r adress mac 3
                    next_state <= s5;
           
            when s5 => --accu output mac 2 / mem_r 3 available / select filter 10 /
                next_state <= s6;

            when s6 => --accu output mac 3 /mem_w_we = 1 save output in memory
            next_state <= s7;

            when s7 => --  reset accu/ disable writing to mem_w/ increment convolution itertaion
            if (it_number < to_integer(unsigned(conv_size))-1) then
                next_state <= s2;
            else
                next_state <= s1;
            end if;

        end case;


    end process;

    --Output logic
    process(current_state)
    begin
        case current_state is
            when s1 => 
                mem_w_we <= '0';
                acc_rst <= '1';
                mem_r_we <= '0';
                mem_r_adrs_sig <= (others => '0');
                mem_w_adrs_sig <= (others => '0');
                it_number <= 0;

            when s2 => 
                mem_w_we <= '0';
                mem_r_we <= '0';
                acc_rst <= '1';
                filter_sel <= "00";
                if(it_number/=0) then 
                    mem_w_adrs_sig <= std_logic_vector(unsigned(mem_w_adrs_sig) + 1);
                    mem_r_adrs_sig <= std_logic_vector(unsigned(mem_r_adrs_sig) - 1);    
                end if;
                

                

            when s3 => -- output of the 1 mac is done -----------2
                mem_w_we <= '0';
                acc_rst <= '0';
                filter_sel <= "00";
                mem_r_adrs_sig <= std_logic_vector(unsigned(mem_r_adrs_sig) + 1);
                

            when s4 =>--output of the 2 mac is done -------------3
                acc_rst <='0';
                filter_sel <= "01";
                mem_r_adrs_sig <= std_logic_vector(unsigned(mem_r_adrs_sig) + 1);


            when s5 =>-- output of the 3 mac --------------4

                filter_sel <="10";
            when S6 =>
                mem_w_we <= '1';
            when s7 =>
                mem_w_we <= '0';
                acc_rst<='1';
                it_number <= it_number + 1;

        end case;
    end process;

end architecture;


--- load adresss of  mac 1
--- mem_r 1 is here select filter 00 / call mem_r adress of mac 2/ rst =1
--- output of the 1st mac is here / mem_r  2 is here /select filter 01 /rst =0/ call mem_r adress mac 3
--- output of mac 2 is here / mem_r 3 is here / select filter 10 /
--- output of mac 3 is here /mem_w_we = 1 save in memory
---  / rst = 1/mem_w_we = 0