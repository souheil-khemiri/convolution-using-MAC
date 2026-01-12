onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sa_piplined_tb/sim_done
add wave -noupdate /sa_piplined_tb/N_reg
add wave -noupdate /sa_piplined_tb/M_reg
add wave -noupdate /sa_piplined_tb/P_reg
add wave -noupdate /sa_piplined_tb/clk
add wave -noupdate /sa_piplined_tb/arst_n_sa
add wave -noupdate /sa_piplined_tb/arst_n_mem_a
add wave -noupdate /sa_piplined_tb/arst_n_mem_b
add wave -noupdate /sa_piplined_tb/arst_n_mem_c
add wave -noupdate /sa_piplined_tb/a
add wave -noupdate /sa_piplined_tb/b
add wave -noupdate -radix decimal -childformat {{/sa_piplined_tb/c_array(0) -radix decimal} {/sa_piplined_tb/c_array(1) -radix decimal} {/sa_piplined_tb/c_array(2) -radix decimal} {/sa_piplined_tb/c_array(3) -radix decimal} {/sa_piplined_tb/c_array(4) -radix decimal} {/sa_piplined_tb/c_array(5) -radix decimal}} -expand -subitemconfig {/sa_piplined_tb/c_array(0) {-height 15 -radix decimal} /sa_piplined_tb/c_array(1) {-height 15 -radix decimal} /sa_piplined_tb/c_array(2) {-height 15 -radix decimal} /sa_piplined_tb/c_array(3) {-height 15 -radix decimal} /sa_piplined_tb/c_array(4) {-height 15 -radix decimal} /sa_piplined_tb/c_array(5) {-height 15 -radix decimal}} /sa_piplined_tb/c_array
add wave -noupdate /sa_piplined_tb/sel_mux_acc
add wave -noupdate /sa_piplined_tb/sel_mux_adder
add wave -noupdate /sa_piplined_tb/acc_en
add wave -noupdate /sa_piplined_tb/a_b_en
add wave -noupdate /sa_piplined_tb/delay_en
add wave -noupdate /sa_piplined_tb/mem_addr_a
add wave -noupdate /sa_piplined_tb/mem_data_a
add wave -noupdate /sa_piplined_tb/mem_we_a
add wave -noupdate /sa_piplined_tb/bank_addr_a
add wave -noupdate /sa_piplined_tb/bank_read_a
add wave -noupdate /sa_piplined_tb/mem_addr_b
add wave -noupdate /sa_piplined_tb/mem_data_b
add wave -noupdate /sa_piplined_tb/mem_we_b
add wave -noupdate /sa_piplined_tb/bank_addr_b
add wave -noupdate /sa_piplined_tb/bank_read_b
add wave -noupdate -radix decimal /sa_piplined_tb/bank_addr_c
add wave -noupdate /sa_piplined_tb/bank_we_c
add wave -noupdate /sa_piplined_tb/read_en_c
add wave -noupdate /sa_piplined_tb/mem_addr_c
add wave -noupdate /sa_piplined_tb/mem_data_out_c
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/clk
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/arst_n
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/b_in
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/acc_mux_input
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/sel_adder_mux
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/sel_acc_mux
add wave -noupdate -expand -group SA(0,0) -radix decimal /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/c_out
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_out
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/b_out
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_en
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/b_en
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/acc_en
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_register
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/b_register
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/product
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/sum
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/acc_output
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/mux_to_adder
add wave -noupdate -expand -group SA(0,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/mux_to_acc
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/clk
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/arst_n
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/a_in
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/b_in
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/acc_mux_input
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/sel_adder_mux
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/sel_acc_mux
add wave -noupdate -expand -group SA(1,0) -radix decimal /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/c_out
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/a_out
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/b_out
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/a_en
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/b_en
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/acc_en
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/a_register
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/b_register
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/product
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/sum
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/acc_output
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/mux_to_adder
add wave -noupdate -expand -group SA(1,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/mux_to_acc
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/clk
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/arst_n
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/a_in
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/b_in
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/acc_mux_input
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/sel_adder_mux
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/sel_acc_mux
add wave -noupdate -expand -group SA(2,0) -radix decimal /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/c_out
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/a_out
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/b_out
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/a_en
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/b_en
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/acc_en
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/a_register
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/b_register
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/product
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/sum
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/acc_output
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/mux_to_adder
add wave -noupdate -expand -group SA(2,0) /sa_piplined_tb/SA_wm_im_so_delay_inst/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/mux_to_acc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {759857 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 636
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {739669 ps} {807519 ps}
bookmark add wave bookmark0 {{739669 ps} {784584 ps}} 5
