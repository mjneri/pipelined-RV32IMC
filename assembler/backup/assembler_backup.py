import sys
from argparse import ArgumentParser
from registers import register_dict
from instructions import instruction_dict
from re import split

argparser = ArgumentParser()
argparser.add_argument('file', help='input filename')
argparser.add_argument('-o', '--output', help='output filename')
argparser.add_argument('-e', '--encoding', help='output encoding')

#print(sys.argv)
k = argparser.parse_args(sys.argv[1:])
#print(k)
#print(k.file)

try:
    prog = open(k.file)
except:
    print('file error')
    exit()

line_list = []
for line in prog:
    line_list.append(line)
    pass

#print(line_list[0])




# lines, lines, more lines
'''
    preprocess_file() does the following:
    - get rid of empty lines
    - strip stuff from lines
    to-do:
    - tokenize all instructions, registers, and things of that nature

    return variables:
    - dict: directives (contains all preprocessor directives)
    - dict: instructions (contains all instructions)
    - dict: labels (contains all labels and symbols)
'''
def preprocess_file(lines):
    directives = {}
    instructions = {}
    labels = {}
    label_q = []


    # for pre-processed insts
    def mini_inst(inst_type, t_inst):
        
        if ((inst_type['syntax']=='none')):
            if (len(t_inst[1:]) > 0):
                print('Error: excessive number of arguments (0+)')
                exit()
        if ((inst_type['syntax']=='i')):
            if (len(t_inst[2:]) > 0):
                print('Error: excessive number of arguments (1+)')
                exit()
        if ((inst_type['syntax']=='r-i') or (inst_type['syntax']=='r-r')):
            if (len(t_inst[3:]) > 0):
                print('Error: excessive number of arguments (2+)')
                exit()
        if ((inst_type['syntax']=='r-r-r') or (inst_type['syntax']=='r-r-i') or (inst_type['syntax']=='r-i_r')):
            if (len(t_inst[4:]) > 0):
                print('Error: excessive number of arguments (3+)')
                exit()
        
        if (inst_type['syntax']=='none'):
            t_inst = t_inst[0]
            return t_inst
        elif (inst_type['syntax']=='i'):
            try:
                arg1 = int(t_inst[1])
            except IndexError:
                print('Invalid first arguement (Imm)')
                exit()
        else:
            try:
                arg1 = register_dict[t_inst[1]]
            except IndexError:
                print('Invalid first arguement (Reg)')
                exit()

        if ((inst_type['syntax']=='r-r-r') or (inst_type['syntax']=='r-r-i')):
            # inst reg, reg, reg
            # inst reg, reg, imm
            try:
                arg2 = register_dict[t_inst[2]]
            except IndexError:
                print('Invalid second arguement (Reg)')
                exit()
            if (inst_type['syntax'] == 'r-r-r'):
                try:
                    arg3 = register_dict[t_inst[3]]
                except IndexError:
                    print('Invalid third arguement (Reg)')
                    exit()
            else:
                try:
                    arg3 = int(t_inst[3], 0)
                except IndexError:
                    print('Invalid third arguement (Imm)')
                    exit()
            try:
                t_inst = [t_inst[0], arg1, arg2, arg3]
            except IndexError:
                print('How on earth did you get this error?!')
                exit()
                
        elif (inst_type['syntax']=='r-i'):
            # inst reg, imm
            if (len(t_inst[3:]) > 0):
                print('Error: excessive number of arguments')
                exit()
            try:
                arg2 = int(t_inst[2], 0)
            except:
                print('Invalid second arguement (Imm)')
                exit()
            try:
                t_inst = [t_inst[0], arg1, arg2]
            except IndexError:
                print('How on earth did you get this error?!')
                exit()

        elif (inst_type['syntax']=='r-i_r'):
            # inst reg, imm(reg)
            if (len(t_inst[4:]) > 0):
                print('Error: excessive number of arguments')
                exit()
            try:
                arg2 = int(t_inst[2])
            except IndexError:
                print('Invalid second arguement (Imm)')
                exit()
            try:
                arg3 = register_dict[t_inst[3]]
            except IndexError:
                print('Invalid third arguement (Reg)')
                exit()
            try:
                t_inst = [t_inst[0], arg1, arg2, arg3]
            except IndexError:
                print('How on earth did you get this error?!')
                exit()

        else:
            print('Too Lazy')
            exit()
        
        return t_inst

    def process_inst(inst):
        t_inst = inst
        t_inst = split('[ \t,()]', t_inst)
        # go through elements and ditch empty strings
        for j in t_inst:
            if (j == ''):
                t_inst.pop(t_inst.index(j))
        #print(t_inst)
        # check if regular instruction
        inst_type = instruction_dict[t_inst[0].upper()]
        t_inst = mini_inst(inst_type, t_inst)
        return t_inst

    ## main loops ###

    for index in list(range(0,len(lines))):
        # delete all comments
        line = lines[index]
        try:
            line = line[0:line.index('#')]
        except ValueError:
            pass

        # look at each line
        temp_line = line.strip()
        # classify according to directive, instruction, label/symbol
        if (len(temp_line) != 0):
            # check if a label exists
            try:
                colon = temp_line.index(':')
                # label
                temp_label = temp_line[0:colon]
                temp_line = temp_line[colon + 1:len(temp_line)]
                if (len(temp_label) != 0):
                    # label exists -> save for now
                    try:
                        exists = labels[temp_label]
                        print('line {}: label {} already exists on line {}'.format(index, temp_label, exists))
                    except KeyError:
                        # empty entry
                        labels[temp_label] = index
                        label_q.append(temp_label)
                else:
                    # error
                    print('error on line {}'.format(index + 1))        
            except ValueError:
                # no label -> either a directive or an instruction
                pass
            # check and associate labels + symbols to their corresponding lines
            temp_line = temp_line.strip()
            if (temp_line == ''):
                # now empty
                pass
            elif (temp_line[0] == '.'):
                # directive, probably
                directives[index] = temp_line
                # it's a symbol
                if (len(label_q) > 0):
                    if (len(label_q) > 1):
                        # error!
                        print('Multiple names assigned to same symbol: {}'.format(label_q))
                    else:
                        labels[label_q.pop(0)] = index
            else:
                # instruction, probably
                instructions[index] = temp_line
                # it's (a) label(s)
                if (len(label_q) > 0):
                    for l in label_q:
                        labels[l] = index
                    label_q.clear()
    # tokenizing strings
    for i in instructions.keys():
        temp_inst = process_inst(instructions[i])
        print('instruction: {}'.format(temp_inst))

        opcode = instruction_dict[temp_inst[0].upper()]['opcode']

        if (instruction_dict[temp_inst[0].upper()]['format']=='R'):
            rd = int(temp_inst[1])
            funct3 = instruction_dict[temp_inst[0].upper()]['funct3']
            rs1 = int(temp_inst[2])
            rs2 = int(temp_inst[3])
            funct7 = instruction_dict[temp_inst[0].upper()]['funct7']
            m_code = opcode |  rd<<7 | funct3<<12 | rs1<<15 | rs2<<20 | funct7<<25
        elif (instruction_dict[temp_inst[0].upper()]['format']=='I'):
            rd = int(temp_inst[1])
            funct3 = instruction_dict[temp_inst[0].upper()]['funct3']
            rs1 = int(temp_inst[2])
            imm = int(temp_inst[3])
            m_code = opcode | rd<<7 | funct3<<12 | rs1<<15 | imm<<20
        elif (instruction_dict[temp_inst[0].upper()]['format']=='S'):
            funct3 = instruction_dict[temp_inst[0].upper()]['funct3']
            rs1 = int(temp_inst[3])
            rs2 = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  (imm&0x1F)<<7 | funct3<<12 | rs1<<15 | rs2<<20 | (imm&0xFE0)<<20
        elif (instruction_dict[temp_inst[0].upper()]['format']=='B'):
            funct3 = instruction_dict[temp_inst[0].upper()]['funct3']
            rs1 = int(temp_inst[1])
            rs2 = int(temp_inst[2])
            imm = int(temp_inst[3])
            m_code = opcode | imm&0x800>>4 | imm&0x1E<<8 | funct3<<12 | rs1<<15 | rs2<<20 | imm&0x7E<<25 | imm&0x800<<31
        elif (instruction_dict[temp_inst[0].upper()]['format']=='U'):
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  rd<<7 | imm&0xFFFFF000<<12   
        elif (instruction_dict[temp_inst[0].upper()]['format']=='J'):
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  rd<<7 | imm&0xFF000<<12 | imm&0x800<<20 | imm&0x7FE<<21 | imm&0x100000<<31

        print(bin(m_code)[2:].zfill(32))
        #print(hex(m_code)[2:].zfill(8))
    # turn into neat lists and assign labels/symbols to addresses here
        
    return directives, instructions, labels

directives, instructions, labels = preprocess_file(line_list)

print(directives)
#print(instructions)
#print(labels)
#print(register_dict)

# Start of processing



exit()