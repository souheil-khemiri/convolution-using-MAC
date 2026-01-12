onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /pe_ir_wr_tb/clk
add wave -noupdate -radix decimal /pe_ir_wr_tb/arst_n
add wave -noupdate -radix decimal /pe_ir_wr_tb/a_in
add wave -noupdate -radix decimal /pe_ir_wr_tb/b_in
add wave -noupdate -radix decimal /pe_ir_wr_tb/acc_mux_input
add wave -noupdate -radix decimal /pe_ir_wr_tb/sel_adder_mux
add wave -noupdate -radix decimal /pe_ir_wr_tb/sel_acc_mux
add wave -noupdate -radix decimal /pe_ir_wr_tb/acc_en
add wave -noupdate -radix decimal /pe_ir_wr_tb/c_out
add wave -noupdate -radix decimal /pe_ir_wr_tb/a_out
add wave -noupdate -radix decimal /pe_ir_wr_tb/b_out
add wave -noupdate -radix decimal /pe_ir_wr_tb/a_en
add wave -noupdate -radix decimal /pe_ir_wr_tb/b_en
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/clk
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/arst_n
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/a_in
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/b_in
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/acc_mux_input
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/sel_adder_mux
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/sel_acc_mux
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/c_out
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/a_out
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/b_out
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/a_en
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/b_en
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/acc_en
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/a_register
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/b_register
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/product
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/sum
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/acc_output
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/mux_to_adder
add wave -noupdate -expand -group PE -radix decimal /pe_ir_wr_tb/dut/mux_to_acc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {110292 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 208
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
WaveRestoreZoom {0 ps} {184603 ps}
