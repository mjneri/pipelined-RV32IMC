iverilog -o test_compile.out -s tb_decode tb_decode.v id_dec_test.v compressed_decoder.v
vvp test_compile.out
gtkwave bbb.vcd bbb.gtkw