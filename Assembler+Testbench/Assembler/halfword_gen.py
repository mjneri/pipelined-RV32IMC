import sys
from argparse import ArgumentParser

argparser = ArgumentParser()
argparser.add_argument('file', help='Input filename')
args = argparser.parse_args(sys.argv[1:])
flines = open(args.file)
line_list = []
for line in flines:
    line_list.append(line[4:8])
    line_list.append(line[0:4])

flines.close()

out_file = open('halfword_inst_' + args.file, "w")

for line in line_list:
    out_file.write(line + '\n')

out_file.close()
