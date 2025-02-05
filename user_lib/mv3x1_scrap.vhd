init_proc : process
begin
    -- Initialize signals
    reset_n <= '0';
    start <= '0';
    m_we_tb <= '0';
    v_we_tb <= '0';
    vo_we_tb <= '0';
    m_adrs_tb <= (others => '0');
    v_in_adrs_tb <= (others => '0');
    vo_in_adrs_tb <= (others => '0');
    mem_ctrl <= '1';
    mem_matrix_d <= (others => '0');
    mem_vector_d <= (others => '0');
    wait;
end process;

mem_matrix_init : process 
    variable line_buf : line;
    variable data_buf : integer ;
    variable addr : integer := 0;
    file mem_matrix_file : text open read_mode is "mem_matrix_init.txt";
begin
    wait for clk_period;
    reset_n <= '1';
    wait for clk_period;
    mem_ctrl <= '1';
    while not endfile(mem_matrix_file) loop
        readline(mem_matrix_file, line_buf);
        read(line_buf, data_buf);
        mem_matrix_d <= std_logic_vector(to_unsigned(data_buf, 8));
        m_adrs_tb <= std_logic_vector(to_unsigned(addr, 5));
        m_we_tb <= '1';
        wait for clk_period;
        m_we_tb <= '0';
        addr := addr + 1;
    end loop;
    wait;
    
end process;

process 
    variable i : INTEGER :=0;
begin
    wait for 30*clk_period;
    for 
    i in 0 to 31 loop
        m_adrs_tb <= std_logic_vector(to_unsigned(i, 5));
        wait for clk_period;
        report "Memory value at address " & integer'image(i) & " is " & integer'image(to_integer(unsigned(mem_matrix_q)));
    end loop;
    
end process;