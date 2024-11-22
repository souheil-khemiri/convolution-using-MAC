library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conv_testbench is
end entity;


architecture rtl of cv_testbench is
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
            start : in std_logic;
            
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
    ---memory component
    component mem is
        generic (
            adress_width : natural := 5; -- 2 **5 = 32
            word_width : natural := 8
        );
        port (
            clk  : in std_logic;
            rst  : in std_logic;
            adrs : in std_logic_vector((adress_width-1) downto 0);
            we   : in std_logic;
            D    : in std_logic_vector((word_width-1) downto 0);
            Q    : out std_logic_vector((word_width-1) downto 0)
        );
    end component;


    --golabl signals
    signal clk : std_logic;
    --controlpath sigs
    -------------in 
    signal conv_size : in std_logic_vector(4 downto 0);
    
    -------------out
    signal filter_sel : out std_logic_vector(1 downto 0);
    signal acc_rst : out std_logic;
    signal mem_r_adrs : out std_logic_vector(4 downto 0);
    signal mem_r_we : out std_logic;
    signal mem_w_adrs : out std_logic_vector(4 downto 0);
    signal mem_w_we : out std_logic;
    --datapath/mem
    -------------in
    signal mem_r_in , memw_w_in  :std_logic_vector(7 downto 0);
    -------------out
    signal mem_r_out , memw_w_out  :std_logic_vector(7 downto 0);

    signal rst_mem : std_logic;

begin
    --memory instantiation
    mem_r: mem
        port map (
            clk  => clk,
            rst  => rst_mem,
            adrs => mem_r_adrs,
            we   => mem_r_we,
            D    => mem_r_in,
            Q    => mem_r_out,     
        );

    mem_w: mem
        port map (
            clk  => clk,
            rst  => rst_mem,
            adrs => mem_w_adrs,
            we   => mem_w_we,
            D    => mem_w_in,
            Q    => mem_w_out,     
        );

    --datapath instantiation 

    datapath_inst: datapath
        generic (
            filter0 =>-1,
            filter1 => 0,
            filter2 => 1
        );
        port (
            clk      => clk,
            rst      => acc_rst,
            sel      => filter_sel,
            data_in  => mem_r_out,
            data_out => mem_w_in
        );

    --controlpath instantiation
    controlpath_inst: controlpath
        generic map (
            generics
        )
        port map (
            clk   => clk,
            reset => reset,
            
        );



    

end architecture;