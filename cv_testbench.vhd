library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cv_testbench is
end entity;


architecture rtl of cv_testbench is

    ---memory component
    component memory is
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
    --- convolution component
    component convolution is
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
    end component;


    --golabl signals
    signal clk : std_logic;
    --controlpath sigs
    signal conv_size : std_logic_vector(4 downto 0);
    signal start , rst : std_logic;
    --DUT we signal
    signal mem_r_we :  std_logic;
    signal mem_w_we :  std_logic;
    --testbenh we mem signal
    signal mem_r_we_tb,mem_w_we_tb :  std_logic;
    ---combined we  enable signal
    signal mem_r_we_comb , mem_w_we_comb : std_logic;
    -------------in
    signal mem_r_in, mem_w_in :std_logic_vector(7 downto 0);
    -------------out
    signal mem_w_out , mem_r_out  :std_logic_vector(7 downto 0);
    
    signal rst_mem : std_logic;
    ---testbench adress signal
    signal mem_w_adrs_tb, mem_r_adrs_tb :std_logic_vector(4 downto 0);
    ---DUT adress signal
    signal mem_w_adrs, mem_r_adrs :std_logic_vector(4 downto 0);
    ---adress combined signal
    signal mem_w_adrs_comb, mem_r_adrs_comb :std_logic_vector(4 downto 0);

    --memory multiplexer select signal between DUT and TB
    signal mem_ctrl_sig : std_logic ;
    ----filter sel verf
    signal filter_value :std_logic_vector(1 downto 0);
    

begin

    --memory instantiation
    mem_r: memory
        port map (
            clk  => clk,
            rst  => rst_mem,
            adrs => mem_r_adrs_comb,
            we   => mem_r_we_comb,
            D    => mem_r_in,
            Q    => mem_r_out  
        );

    mem_w: memory
        port map (
            clk  => clk,
            rst  => rst_mem,
            adrs => mem_w_adrs_comb,
            we   => mem_w_we_comb,
            D    => mem_w_in,
            Q    => mem_w_out   
        );

    convolution_inst : convolution
    generic map (
        filter0 => 2,
        filter1 => 2,
        filter2 => -1
        
    )
    port map (
        clk => clk,
        conv_size => conv_size,
        data_in  => mem_r_out,
        data_out => mem_w_in,
        start => start,
        rst =>rst,
        --Memory bank r(read)
        mem_r_adrs => mem_r_adrs,
        mem_r_we => mem_r_we,
        --memory bank w(write)
        mem_w_adrs => mem_w_adrs,
        mem_w_we => mem_w_we,
        ---filter sel
        filter_v => filter_value
    );

    clkproc : process
    begin
        clk <= '1';
        wait for 5 ns ;
        clk <= '0';
        wait for 5 ns;
    end process;

    --memory control multiplxing process
    mem_ctrl: process (mem_ctrl_sig, mem_w_adrs, mem_w_we, mem_r_adrs, mem_r_we, mem_w_adrs_tb, mem_w_we_tb, mem_r_adrs_tb, mem_r_we_tb)
    begin
        if (mem_ctrl_sig='0') then --DUT controls mem
            mem_w_adrs_comb <= mem_w_adrs;
            mem_w_we_comb <= mem_w_we;
            mem_r_adrs_comb <= mem_r_adrs;
            mem_r_we_comb <= mem_r_we;
        elsif (mem_ctrl_sig ='1') then --tb controls mem
            mem_w_adrs_comb <= mem_w_adrs_tb;
            mem_w_we_comb <= mem_w_we_tb;
            mem_r_adrs_comb <= mem_r_adrs_tb;
            mem_r_we_comb <= mem_r_we_tb;
        end if;
    end process;

    ---simproc : fill mem_r and then test the DUT

    simproc : process 
    begin
        --initialize signals
        rst <= '1';
        rst_mem <= '1';
        start <= '0';
        conv_size <= (others => '0');
        mem_r_adrs_tb <= (others => '0');
        mem_w_adrs_tb <= (others => '0');
        mem_r_we_tb <= '0';
        mem_w_we_tb <= '0';
        mem_r_in <= (others => '0');
        wait for 10 ns ;

        rst_mem <='0';
        rst <= '0';
        wait for 10 ns;
        
        --fill mem_r from tb
        mem_ctrl_sig <= '1';
        for i in 0 to 5 loop
            mem_r_we_tb <= '1';
            mem_r_adrs_tb <= std_logic_vector(to_unsigned(i, mem_r_adrs_tb'length));
            wait for 2 ns;
            mem_r_in<= std_logic_vector(to_unsigned(i + 1, mem_r_in'length)); -- Example data
            wait for 10 ns;
        end loop;
        
        --check values in mem_r   
        mem_r_we_tb <= '0';
        wait for 50 ns ;
        wait for 1 ns ;
        mem_r_adrs_tb <= "00000";
        wait for 10 ns ;
        mem_r_adrs_tb <= "00001";
        wait for 10 ns ;
        mem_r_adrs_tb <= "00011";
        wait for 50 ns ;


        --start convolution
        mem_ctrl_sig <= '0';
        conv_size <= "00011";
        start <= '1';
        wait for 50 ns;
        start <= '0';
        wait for 1000 ns;

        
        --check values in mem_w
        mem_ctrl_sig <= '1';
        mem_w_adrs_tb <= "00010";
        wait for 10 ns ;

        mem_w_adrs_tb <= "00001";
        wait for 10 ns ;

        mem_w_adrs_tb <= "00000";
        wait for 10 ns ;


        wait; 
        end process;
        

        
        


        



    
    

end architecture;