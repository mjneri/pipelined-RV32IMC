# Python script for generating Text & Data dump files using RARS and
# generating halfword instructions using assembler.py
# when executing, terminal should be at the directory of the Assembly code.
import sys
import os
from argparse import ArgumentParser

argparser = ArgumentParser()
argparser.add_argument('file', help='Input Filename')
args = argparser.parse_args(sys.argv[1:])

print("FILE: ", args.file)

# Check if file exists
try:
	rvfile = open(args.file)
except:
	print('File Error')
	exit()
finally:
	rvfile.close()

filename = args.file.split('.')[0]

# Generating Command strings
assembler_folder_path = "..\\pipelined-RV32IMC\\assembler"
text_command = 'py "'+ assembler_folder_path + 'assembler.py" ' + args.file + ' ' + filename + '_text.dmp ' + '-comp_buffer True'
data_command = 'java -jar "' + assembler_folder_path + 'rars1_4.jar" a mc CompactDataAtZero dump .data HexText \"' + filename + '_data.dmp\" \"' + filename+'_base.s'+'"'
ans_command = 'java -jar "' + assembler_folder_path + 'rars1_4.jar" 50000 mc CompactDataAtZero dump .data HexText \"' + filename + '_answerkey.mem\"  \"' + filename+'_base.s' + '"'

print('\u001b[44m----------------------------------------------------------------------------------------------------\u001b[0m')

print("Generating text dump...")
print(text_command + '\n')
os.system(text_command)

print('\u001b[44m----------------------------------------------------------------------------------------------------\u001b[0m')
print("Generating data dump...")
os.system(data_command)

print('\u001b[44m----------------------------------------------------------------------------------------------------\u001b[0m')
print("Generating answer key...")
os.system(ans_command)

print("Files have been generated.")
rvfile.close()
