# Python script for generating Text & Data dump files using RARS and
# generating halfword instructions using halfword_gen.py
# when executing, terminal should be at the directory of the Assembly code.
import sys
import os
from argparse import ArgumentParser

argparser = ArgumentParser()
argparser.add_argument('input_file', help='Input filename')
args = argparser.parse_args(sys.argv[1:])

print('\u001b[32mFILE: ' + args.input_file + '\u001b[0m')

# Check if file exists
try:
	rvfile = open(args.input_file)
except:
	print('File Error')
	exit()
finally:
	rvfile.close()

filename = args.input_file.split('.')[0]

# Generating Command strings
rars_path = ""
text_command = 'python3 "../Assembler+Testbench/Assembler/assembler.py" ' + args.input_file + ' ' + filename + '.coe ' + '-comp_buffer True'
data_command = 'java -jar ' + rars_path + 'rars1_4.jar a mc CompactDataAtZero dump .data HexText \"' + filename + '_data.mem\" \"' + filename+'_base.asm'+'"'
ans_command = 'java -jar ' + rars_path + 'rars1_4.jar 1000 mc CompactDataAtZero dump .data HexText \"' + 'answerkey.mem\"  \"' + filename+'_base.asm' + '"'

print('\u001b[44m----------------------------------------------------------------------------------------------------\u001b[0m')
# print('cmd /c "java -jar C:\\Users\\MJ\\Documents\\RARS\\rars1_4.jar a d mc CompactDataAtZero dump .text HexText \"'+filename+' text.dmp\" '+args.file+'"')
print("Generating text dump...")
print(text_command + '\n')
os.system(text_command)
#os.system('cmd /c "java -jar' + path + 'rars1_4.jar a mc CompactDataAtZero dump .text HexText \"' + filename + ' text.dmp\" '+args.file+'"')
print('\u001b[44m----------------------------------------------------------------------------------------------------\u001b[0m')
print("Generating data dump...")
os.system(data_command)
print('\u001b[44m----------------------------------------------------------------------------------------------------\u001b[0m')
print("Generating answer key...")
os.system(ans_command)
print('\u001b[44m----------------------------------------------------------------------------------------------------\u001b[0m')
#print("Generating halfword instructions...")
#os.system('cmd /c "py "C:\\Users\\Emman\\Documents\\halfword_gen.py" \"' +filename+' text.dmp\""')
# print('py "C:\\Users\\MJ\\Documents\\UP Diliman\\5th Year\\2nd Sem\\CoE 198\\pipelined-RV32IMC\\Assembler+Testbench\\Assembler\\halfword_gen.py" \"'+filename+' text.dmp\" '+args.file+'')
rvfile.close()