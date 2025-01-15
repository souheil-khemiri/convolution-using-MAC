library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity convolution is
    generic (
        filter0 : integer;
        filter1 : integer;
        filter2 : integer  
    );
    port (
        clk :in std_logic;
        conv_size : in std_logic_vector(4 downto 0); -- size of the batch ot be calculated
        data_in  : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0);
        start , rst : in std_logic;
        --Memory bank r(read)
        mem_r_adrs : out std_logic_vector(4 downto 0);
        mem_r_we : out std_logic;
        --memory bank w(write)
        mem_w_adrs : out std_logic_vector(4 downto 0);
        mem_w_we : out std_logic;
        --verification
        filter_v : out std_logic_vector(1 downto 0)
    );
end entity;


architecture rtl of convolution is
    --datapath component
    component datapath is
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
    end component;
    ---controlpath component
    component controlpath is
        port (
            clk   : in std_logic;
            conv_size : in std_logic_vector(4 downto 0); -- size of the batch ot be calculated
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
    end component;

    --signals
    signal acc_rst : std_logic;
    signal filter_sel : std_logic_vector(1 downto 0);



    begin

        datapath_inst: datapath
            generic map (
                filter0 => filter0,
                filter1 => filter1,
                filter2 => filter2
            )
            port map (
                clk   => clk,
                rst   => acc_rst,
                sel   => filter_sel,
                data_in => data_in,
                data_out => data_out    
            );

        controlpath_inst: controlpath
            port map (
                clk   => clk,
                conv_size => conv_size,
                start => start,
                rst => rst,
                filter_sel => filter_sel,
                acc_rst => acc_rst,
                mem_r_adrs => mem_r_adrs,
                mem_r_we => mem_r_we,
                mem_w_adrs =>mem_w_adrs,
                mem_w_we => mem_w_we
                
            );

            filter_v <= filter_sel ;

    end architecture;