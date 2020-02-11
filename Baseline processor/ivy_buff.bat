iverilog -o bufftest_compile.out -s tb_buffer tb_buffer.v compressed_buffer.v
vvp bufftest_compile.out
gtkwave ccc.vcd