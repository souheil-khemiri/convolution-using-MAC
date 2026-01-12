--Generic size SA for multiplication of Anm x Bmp = Cnp
--M is the number of cycle need to accomplish the multiplication after start for a broadcast iputs and weights SA



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.types_pkg.all;

entity SA_wm_im_so is
    generic (
        N : integer;  -- Number of rows in matrix A and C
        M : integer;  -- Number of columns in A and number or rows in B
        P : integer   -- Number of columns in matrix B and C
    );
    port (
        clk     : in  std_logic;
        arst_n   : in  std_logic;
        a : in std_logic_vector_8_array(0 to N-1);
        b : in std_logic_vector_8_array(0 to P-1);
        --mux ports
        sel_mux_acc : in std_logic_matrix( 0 to N-1, 0 to P-1);
        sel_mux_adder : in std_logic_matrix( 0 to N-1, 0 to P-1);
        --enable signals
        acc_en : in std_logic_matrix(0 to N-1, 0 to P-1); --array of ( 0 to N-1, 0 to P-1) STD_LOGIC;
        a_b_en : in std_logic_matrix(0 to N-1, 0 to P-1);
        --output
        c_array : out std_logic_vector_16_array(0 to P-1)
    );
end entity SA_wm_im_so;

architecture rtl of SA_wm_im_so is

    component PE_IR_WR is
        port (
            clk   : in std_logic;
            arst_n : in std_logic;
            a_in : in STD_LOGIC_VECTOR(7 downto 0);
            b_in : in STD_LOGIC_VECTOR(7 downto 0);
            acc_mux_input : STD_LOGIC_VECTOR(15 downto 0);
            sel_adder_mux : in STD_LOGIC;
            sel_acc_mux : in STD_LOGIC;
            c_out : out STD_LOGIC_VECTOR(15 downto 0);
            a_out : out STD_LOGIC_VECTOR(7 downto 0);
            b_out : out STD_LOGIC_VECTOR(7 downto 0);
            --Enable signals
            a_en, b_en, acc_en : in STD_LOGIC
            
        );
    end component;
 
    
    type c_downstream_sig is array (0 to N, 0 to P-1) of STD_LOGIC_VECTOR(15 downto 0);
    type a_stream_sig is array (0 to N-1, 0 to P) of STD_LOGIC_VECTOR(7 downto 0);
    type b_stream_sig is array (0 to N, 0 to P-1) of STD_LOGIC_VECTOR(7 downto 0);

    signal c_downstream: c_downstream_sig;
    signal a_stream: a_stream_sig;
    signal b_stream: b_stream_sig;
    
    
    

begin

    gen_SA_row : for i in 0 to N-1 generate
        gen_SA_col : for j in 0 to P-1 generate
            PE_inst : PE_IR_WR
                port map (
                    clk => clk,
                    arst_n => arst_n,
                    a_in => a_stream(i,j),
                    b_in => b_stream(i,j),
                    acc_mux_input => c_downstream(i,j) , 
                    sel_adder_mux => sel_mux_adder(i,j),
                    sel_acc_mux => sel_mux_acc(i,j),
                    c_out => c_downstream(i+1,j),--fixed indexing error, was c_downstream(i,j)
                    a_out => a_stream(i,j+1),
                    b_out => b_stream(i+1,j),
                    a_en => a_b_en(i,j),
                    b_en => a_b_en(i,j),
                    acc_en => acc_en(i, j)
                );
        end generate gen_SA_col;
    end generate gen_SA_row;
    
    -- a_stream input and output
    gen_a_stream : for i in 0 to N-1 generate
        a_stream(i,0) <= a(i);
    end generate;
    
    -- b_stream input and output
    gen_b_stream : for i in 0 to P-1 generate
        b_stream(0,i) <= b(i);
    end generate;
    
    -- c_downstream in and out
    gen_c_downstream : for i in 0 to P-1 generate
        c_downstream(0,i) <= (others => '0');
        c_array(i) <= c_downstream(N, i);
    end generate;
        
end architecture;



--copilot suggestion-- made me so mad
    --architecture rtl of SA_wm_im_so is
    --    -- ... existing component and signal declarations ...
    --begin
    --    -- Generate systolic array
    --    gen_row: for i in 0 to N-1 generate
    --        gen_col: for j in 0 to P-1 generate
    --            PE_inst: PE_IR_WR
    --                port map (
    --                    clk => clk,
    --                    arst_n => arst_n,
    --                    -- Input a: first column from input, others from previous PE
    --                    a_in => a(i) when j = 0 else a_stream(i,j-1),
    --                    -- Input b: first row from input, others from above
    --                    b_in => b(j) when i = 0 else b_stream(i-1,j),
    --                    -- Accumulator input: zeros for first row, others from above
    --                    acc_mux_input => (others => '0') when i = 0 else c_downstream(i-1,j),
    --                    sel_adder_mux => sel_mux_adder,
    --                    sel_acc_mux => sel_mux_acc,
    --                    -- Output c: to output array if last row, else downstream
    --                    c_out => c_array(j) when i = N-1 else c_downstream(i,j),
    --                    -- Output a: open if last column, else to next PE
    --                    a_out => open when j = P-1 else a_stream(i,j),
    --                    -- Output b: open if last row, else downstream
    --                    b_out => open when i = N-1 else b_stream(i,j),
    --                    a_en => a_b_en,
    --                    b_en => a_b_en,
    --                    acc_en => acc_en(i,j)
    --                );
    --        end generate;
    --    end generate;
    --end architecture;