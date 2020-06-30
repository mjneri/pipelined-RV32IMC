# Set Current Directory to point to Github Repo directory (where project_run.tcl should be located)
set SRCDIR "Z:/Your Directory/Github/pipelined-RV32IMC"

cd $SRCDIR

#Add Verilog Files to Project
add_files -scan_for_includes ./processor

#Add data memory files
add_files ./memory/instmem.mem
add_files ./memory/isr_mem.mem

#Add constraints
add_files -fileset constrs_1 ./constraints/arty7_a35t.xdc

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
add_files	{./vivado-ip-src/blk_mem_gen_datamem/blk_mem_gen_datamem.xci	\
			./vivado-ip-src/blk_mem_gen_protocol/blk_mem_gen_protocol.xci	\
			./vivado-ip-src/clk_wiz_0/clk_wiz_0.xci 						\
			./vivado-ip-src/div_gen_unsigned/div_gen_unsigned.xci 			\
			./vivado-ip-src/div_gen_signed/div_gen_signed.xci 				\
			./vivado-ip-src/mult_gen_hsu/mult_gen_hsu.xci  					\
			./vivado-ip-src/mult_gen_signed/mult_gen_signed.xci 			\
			./vivado-ip-src/mult_gen_u/mult_gen_u.xci}

# Import Waveform files
# add_files -fileset sim_1 ./wcfg

# Set arty7_a35t.xdc as target constraints file
set_property target_constrs_file [format %s%s $SRCDIR "/constraints/arty7_a35t.xdc"] [current_fileset -constrset]

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

#Synthesis and Implementation
#launch_runs synth_1
#wait_on_run synth_1
#launch_runs impl_1 -to_step write_bitstream
#wait_on_run impl_1