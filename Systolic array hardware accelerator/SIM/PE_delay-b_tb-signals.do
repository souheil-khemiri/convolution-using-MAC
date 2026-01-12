onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/clk
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/arst_n
add wave -noupdate -group (0,0) -radix decimal -childformat {{/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(7) -radix decimal} {/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(6) -radix decimal} {/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(5) -radix decimal} {/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(4) -radix decimal} {/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(3) -radix decimal} {/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(2) -radix decimal} {/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(1) -radix decimal} {/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(0) -radix decimal}} -subitemconfig {/sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(7) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(6) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(5) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(4) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(3) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(2) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(1) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in(0) {-height 15 -radix decimal}} /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_in
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/b_in
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/acc_mux_input
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/sel_adder_mux
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/sel_acc_mux
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/c_out
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_out
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/b_out
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_en
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/b_en
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/acc_en
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/a_register
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/b_register
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/product
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/sum
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/acc_output
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/mux_to_adder
add wave -noupdate -group (0,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(0)/PE_inst/mux_to_acc
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/clk
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/arst_n
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/a_in
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/b_in
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/acc_mux_input
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/sel_adder_mux
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/sel_acc_mux
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/c_out
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/a_out
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/b_out
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/a_en
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/b_en
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/acc_en
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/a_register
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/b_register
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/product
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/sum
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/acc_output
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/mux_to_adder
add wave -noupdate -group (1,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(0)/PE_inst/mux_to_acc
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/clk
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/arst_n
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/a_in
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/b_in
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/acc_mux_input
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/sel_adder_mux
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/sel_acc_mux
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/c_out
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/a_out
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/b_out
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/a_en
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/b_en
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/acc_en
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/a_register
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/b_register
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/product
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/sum
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/acc_output
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/mux_to_adder
add wave -noupdate -group (0,1) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(0)/gen_SA_col(1)/PE_inst/mux_to_acc
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/clk
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/arst_n
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/a_in
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/b_in
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/acc_mux_input
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/sel_adder_mux
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/sel_acc_mux
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/c_out
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/a_out
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/b_out
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/a_en
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/b_en
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/acc_en
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/a_register
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/b_register
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/product
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/sum
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/acc_output
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/mux_to_adder
add wave -noupdate -group (2,0) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(0)/PE_inst/mux_to_acc
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/clk
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/arst_n
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/a_in
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/b_in
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/acc_mux_input
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/sel_adder_mux
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/sel_acc_mux
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/c_out
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/a_out
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/b_out
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/a_en
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/b_en
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/acc_en
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/a_register
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/b_register
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/product
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/sum
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/acc_output
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/mux_to_adder
add wave -noupdate -expand -group (2,5) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(2)/gen_SA_col(5)/PE_inst/mux_to_acc
add wave -noupdate -group delay_b -radix decimal /sa_wm_im_so_delay_tb/SA/delay_b/clk
add wave -noupdate -group delay_b -radix decimal /sa_wm_im_so_delay_tb/SA/delay_b/arst_n
add wave -noupdate -group delay_b -radix decimal /sa_wm_im_so_delay_tb/SA/delay_b/ce
add wave -noupdate -group delay_b -radix decimal -childformat {{/sa_wm_im_so_delay_tb/SA/delay_b/D_array(0) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/D_array(1) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/D_array(2) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/D_array(3) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/D_array(4) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/D_array(5) -radix decimal}} -expand -subitemconfig {/sa_wm_im_so_delay_tb/SA/delay_b/D_array(0) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/D_array(1) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/D_array(2) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/D_array(3) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/D_array(4) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/D_array(5) {-height 15 -radix decimal}} /sa_wm_im_so_delay_tb/SA/delay_b/D_array
add wave -noupdate -group delay_b -radix decimal -childformat {{/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0) -radix decimal -childformat {{/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(7) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(6) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(5) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(4) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(3) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(2) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(1) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(0) -radix decimal}}} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(1) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(2) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(3) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(4) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(5) -radix decimal}} -expand -subitemconfig {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0) {-height 15 -radix decimal -childformat {{/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(7) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(6) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(5) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(4) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(3) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(2) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(1) -radix decimal} {/sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(0) -radix decimal}}} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(7) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(6) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(5) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(4) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(3) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(2) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(1) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(0)(0) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(1) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(2) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(3) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(4) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array(5) {-height 15 -radix decimal}} /sa_wm_im_so_delay_tb/SA/delay_b/Q_array
add wave -noupdate -group delay_b -radix decimal /sa_wm_im_so_delay_tb/SA/delay_b/shift_regs
add wave -noupdate -group tb_signals -radix decimal /sa_wm_im_so_delay_tb/clk
add wave -noupdate -group tb_signals -radix decimal /sa_wm_im_so_delay_tb/arst_n
add wave -noupdate -group tb_signals -radix decimal -childformat {{/sa_wm_im_so_delay_tb/a(0) -radix decimal} {/sa_wm_im_so_delay_tb/a(1) -radix decimal} {/sa_wm_im_so_delay_tb/a(2) -radix decimal}} -expand -subitemconfig {/sa_wm_im_so_delay_tb/a(0) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/a(1) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/a(2) {-height 15 -radix decimal}} /sa_wm_im_so_delay_tb/a
add wave -noupdate -group tb_signals -radix decimal -childformat {{/sa_wm_im_so_delay_tb/b(0) -radix decimal} {/sa_wm_im_so_delay_tb/b(1) -radix decimal} {/sa_wm_im_so_delay_tb/b(2) -radix decimal} {/sa_wm_im_so_delay_tb/b(3) -radix decimal} {/sa_wm_im_so_delay_tb/b(4) -radix decimal} {/sa_wm_im_so_delay_tb/b(5) -radix decimal}} -expand -subitemconfig {/sa_wm_im_so_delay_tb/b(0) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/b(1) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/b(2) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/b(3) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/b(4) {-height 15 -radix decimal} /sa_wm_im_so_delay_tb/b(5) {-height 15 -radix decimal}} /sa_wm_im_so_delay_tb/b
add wave -noupdate -group tb_signals -radix decimal /sa_wm_im_so_delay_tb/c_array
add wave -noupdate -group tb_signals -radix decimal /sa_wm_im_so_delay_tb/sel_mux_acc
add wave -noupdate -group tb_signals -radix decimal /sa_wm_im_so_delay_tb/sel_mux_adder
add wave -noupdate -group tb_signals -radix decimal /sa_wm_im_so_delay_tb/acc_en
add wave -noupdate -group tb_signals -radix decimal /sa_wm_im_so_delay_tb/a_b_en
add wave -noupdate -group tb_signals -radix decimal /sa_wm_im_so_delay_tb/delay_en
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/clk
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/arst_n
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/a_in
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/b_in
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/acc_mux_input
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/sel_adder_mux
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/sel_acc_mux
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/c_out
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/a_out
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/b_out
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/a_en
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/b_en
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/acc_en
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/a_register
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/b_register
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/product
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/sum
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/acc_output
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/mux_to_adder
add wave -noupdate -expand -group (1,4) -radix decimal /sa_wm_im_so_delay_tb/SA/systolic_array/gen_SA_row(1)/gen_SA_col(4)/PE_inst/mux_to_acc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41848 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 626
configure wave -valuecolwidth 40
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
WaveRestoreZoom {55402 ps} {91195 ps}
bookmark add wave bookmark0 {{0 ps} {97614 ps}} 0
