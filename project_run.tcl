#Create project and set part
# cd D:/pipelined-RV32IMC
# create_project -force -part xc7a35ticsg324-1L CoE198_project RV32IMC
#create_project -force -part target Xilinx_part project_directory project_name

#Set board
# set_property BOARD_PART digilentinc.com:arty-a7-35:part0:1.0 [current_project]

#Add Verilog Files to Project
add_files -scan_for_includes ./processor
add_files -scan_for_includes ./processor/protocol-controllers
import_files

#Add data memory files
add_files ./memory/instmem.mem
add_files ./memory/isr_mem.mem

#Add constraints
import_files -fileset constrs_1 ./constraints/arty7_a35t.xdc

#Add testbench and answer key
add_files -fileset sim_1 ./sim/tb_top.v
add_files -fileset sim_1 ./sim/tb_core.v
add_files ./memory/answerkey.mem

#Set tb_top to be top module of simulation sources
set_property top tb_top [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

#set top.v to be the top module of design sources
set_property top top [current_fileset]

#Import IP Modules
import_ip -files {./vivado-ip-src/blk_mem_gen_datamem/blk_mem_gen_datamem.xci   \
				  ./vivado-ip-src/blk_mem_gen_protocol/blk_mem_gen_protocol.xci \
				  ./vivado-ip-src/clk_wiz_0/clk_wiz_0.xci 						\
				  ./vivado-ip-src/div_gen_unsigned/div_gen_unsigned.xci 		\
				  ./vivado-ip-src/div_gen_signed/div_gen_signed.xci 			\
				  ./vivado-ip-src/mult_gen_hsu/mult_gen_hsu.xci  				\
				  ./vivado-ip-src/mult_gen_signed/mult_gen_signed.xci 			\
				  ./vivado-ip-src/mult_gen_u/mult_gen_u.xci}

#Generate output products so that instmem.coe and datamem.coe will not be read-only files
#generate_target synthesis [get_files blk_mem_gen_instmem.xci]
#generate_target synthesis [get_files blk_mem_gen_datamem.xci]

#Disable clk ip's xdc files to apply set constraints
#generate_target synthesis [get_files clk_wiz_0.xci]
#set clk_wiz_xdc [get_files -of_objects [get_files   \
#clk_wiz_0.xci] -filter {FILE_TYPE == XDC}]
#set_property is_enabled false [get_files $clk_wiz_xdc]

#Upgrade IPs - to prevent clk ip to be locked
#set locked [get_property IS_LOCKED [get_ips clk_wiz_0]]
#set upgrade [get_property UPGRADE_VERSIONS [get_ips clk_wiz_0]]
#if {$locked && $upgrade != ""} {
#    upgrade_ip [get_ips clk_wiz_0]
#}

#Set target constraints
#set_property target_constrs_file D:/pipelined-RV32IMC/PipelineProcessor_3/CoE198_test3.srcs/constrs_1/imports/VivadoFiles/arty7_a35t.xdc [current_fileset -constrset]

#Synthesis and Implementation
#launch_runs synth_1
#wait_on_run synth_1
#launch_runs impl_1 -to_step write_bitstream
#wait_on_run impl_1