import sys
from argparse import ArgumentParser

argparser = ArgumentParser()
argparser.add_argument('file', help='Input filename')
args = argparser.parse_args(sys.argv[1:])
flines = open(args.file)
line_list = []
for line in flines:
    temp_line = (line.strip()).split()
    if temp_line[0][0:2].lower() == 'c.':
        print(temp_line[0][2:])
        temp_line[0] = temp_line[0][2:]
    temp_line = ' '.join(temp_line)
    line_list.append(temp_line)

flines.close()

out_file = open('base_inst_' + args.file, "w")

for line in line_list:
    out_file.write(line + '\n')

out_file.close()
