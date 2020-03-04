# Python script for generating Text & Data dump files using RARS and
# generating halfword instructions using halfword_gen.py
# when executing, terminal should be at the directory of the Assembly code.
import sys
import os
from argparse import ArgumentParser

argparser = ArgumentParser()
argparser.add_argument('input_file', help='Input filename')
args = argparser.parse_args(sys.argv[1:])

print("FILE: ", args.input_file)

# Check if file exists
try:
	rvfile = open(args.input_file)
except:
	print('File Error')
	exit()
finally:
	rvfile.close()

filename = args.input_file.split('.')[0]
# Put rars path here
path = "C:\\Users\\Emman\\Documents\\GitHub\\pipelined-RV32IMC\\Memory\\"
# Generating Command strings
text_command = 'cmd /c "py ' + 'assembler.py ' + args.input_file + ' ' + filename + '.coe' + '"'
data_command = 'cmd /c "java -jar ' + path + 'rars1_4.jar a mc CompactDataAtZero dump .data HexText \"' + filename + '_data.mem\" '+filename+'_base.asm'+'"'
ans_command = 'cmd /c "java -jar ' + path + 'rars1_4.jar 1000 mc CompactDataAtZero dump .data HexText \"' + filename + '_answerkey.mem\" ' + filename+'_base.asm' + '"'

# print('cmd /c "java -jar C:\\Users\\MJ\\Documents\\RARS\\rars1_4.jar a d mc CompactDataAtZero dump .text HexText \"'+filename+' text.dmp\" '+args.file+'"')
print("Generating text dump...")
os.system(text_command)
#os.system('cmd /c "java -jar' + path + 'rars1_4.jar a mc CompactDataAtZero dump .text HexText \"' + filename + ' text.dmp\" '+args.file+'"')

print("Generating data dump...")
os.system(data_command)

print("Generating answer key...")
os.system(ans_command)

#print("Generating halfword instructions...")
#os.system('cmd /c "py "C:\\Users\\Emman\\Documents\\halfword_gen.py" \"' +filename+' text.dmp\""')
# print('py "C:\\Users\\MJ\\Documents\\UP Diliman\\5th Year\\2nd Sem\\CoE 198\\pipelined-RV32IMC\\Assembler+Testbench\\Assembler\\halfword_gen.py" \"' +
#       filename+' text.dmp\" '+args.file+'')
