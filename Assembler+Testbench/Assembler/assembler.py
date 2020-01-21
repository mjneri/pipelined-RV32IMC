import sys
from argparse import ArgumentParser
from registers import register_dict
from instructions import instruction_dict
from re import split

argparser = ArgumentParser()
argparser.add_argument('file', help='Input filename')

filename = argparser.parse_args(sys.argv[1:])
try:
    inst_file = open(filename.file)
except:
    print('File error')
    exit()

'''
    parse_file() does the following:
    - get rid of empty lines
    - strip stuff from lines
    to-do:
    - tokenize all instructions, registers, and things of that nature

    return variables:
    - dict: instructions (contains all instructions)
    - dict: labels (contains all labels and symbols)
'''
# Outputs parsed instruction line with replaced registers
def parse_inst(inst_type, t_inst):
    if ((inst_type['syntax']=='none')):
        if (len(t_inst[1:]) > 0):
            print('Error: excessive number of arguments (0+)')
            exit()
    if ((inst_type['syntax']=='i') or (inst_type['syntax']=='r')):
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
            t_inst = [t_inst[0], arg1]
        except IndexError:
            print('Invalid first arguement (Imm)')
            exit()
    else:
        try:
            arg1 = register_dict[t_inst[1]]
        except IndexError:
            print('Invalid first arguement (Reg)')
            exit()

    if (inst_type['syntax']=='r'):
        t_inst = [t_inst[0], arg1]
    elif ((inst_type['syntax']=='r-r-r') or (inst_type['syntax']=='r-r-i') or (inst_type['syntax']=='r-r')):
        # inst reg, reg, reg
        # inst reg, reg, imm
        # inst reg, reg
        try:
            arg2 = register_dict[t_inst[2]]
        except IndexError:
            print('Invalid second arguement (Reg)')
            exit()
        if (inst_type['syntax'] == 'r-r'):
            t_inst = [t_inst[0], arg1, arg2]
        elif (inst_type['syntax'] == 'r-r-r'):
            try:
                arg3 = register_dict[t_inst[3]]
                t_inst = [t_inst[0], arg1, arg2, arg3]
            except IndexError:
                print('Invalid third arguement (Reg)')
                exit()
        else:
            try:
                arg3 = int(t_inst[3], 0)
                t_inst = [t_inst[0], arg1, arg2, arg3]
            except IndexError:
                print('Invalid third arguement (Imm)')
                exit()
            
    elif (inst_type['syntax']=='r-i_r' or (inst_type['syntax']=='r-i')):
        # inst reg, i(reg)
        # inst reg, imm
        try:
            arg2 = int(t_inst[2], 0)
        except:
            print('Invalid second arguement (i)')
            exit()
        if (inst_type['syntax']=='r-i'):
            t_inst = [t_inst[0], arg1, arg2]
        else:
            try:
                arg3 = register_dict[t_inst[3]]
                t_inst = [t_inst[0], arg1, arg2, arg3]
            except IndexError:
                print('Invalid third arguement (Reg)')
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
    t_inst = parse_inst(inst_type, t_inst)
    return t_inst

def parse_file(line_list):
    line_list = []
    for line in inst_file:
        line_list.append(line)

    instructions = {}
    labels = {}
    label_q = []

    ## main loops ###

    for index in list(range(0,len(line_list))):
        # delete all comments
        line = line_list[index]
        try:
            line = line[0:line.index('#')]
        except ValueError:
            pass

        # look at each line
        temp_line = line.strip()
        # classify according to instruction or label
        if (len(temp_line) != 0):
            # check if a label exists
            try:
                colon = temp_line.index(':')
                # label
                temp_label = temp_line[0:colon]
                temp_line = temp_line[colon + 1:len(temp_line)].strip()
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
                # no label -> instruction
                pass
            # check and associate labels + symbols to their corresponding lines

            if (temp_line == ''):
                # now empty
                pass
            else:
                # instruction, probably
                instructions[index] = temp_line
                # it's (a) label(s)
                if (len(label_q) > 0):
                    for l in label_q:
                        labels[l] = index
                    label_q.clear()
    
    return instructions, labels

def assemble(instructions, labels):
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
            imm &= (2**instruction_dict[temp_inst[0].upper()]['i_width']-1)
            m_code = opcode | rd<<7 | funct3<<12 | rs1<<15 | imm<<20

        elif (instruction_dict[temp_inst[0].upper()]['format']=='S'):
            funct3 = instruction_dict[temp_inst[0].upper()]['funct3']
            rs1 = int(temp_inst[3])
            rs2 = int(temp_inst[1])
            imm = int(temp_inst[2])
            imm &= (2**instruction_dict[temp_inst[0].upper()]['i_width']-1)
            m_code = opcode |  (imm&0x1F)<<7 | funct3<<12 | rs1<<15 | rs2<<20 | (imm&0xFE0)<<20

        elif (instruction_dict[temp_inst[0].upper()]['format']=='B'):
            funct3 = instruction_dict[temp_inst[0].upper()]['funct3']
            rs1 = int(temp_inst[1])
            rs2 = int(temp_inst[2])
            imm = int(temp_inst[3])
            imm &= (2**instruction_dict[temp_inst[0].upper()]['i_width']-1)
            m_code = opcode | imm&0x800>>4 | imm&0x1E<<8 | funct3<<12 | rs1<<15 | rs2<<20 | imm&0x7E<<25 | imm&0x800<<31
        
        elif (instruction_dict[temp_inst[0].upper()]['format']=='U'):
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            imm &= (2**instruction_dict[temp_inst[0].upper()]['i_width']-1)
            m_code = opcode |  rd<<7 | imm&0xFFFFF000<<12
        
        elif (instruction_dict[temp_inst[0].upper()]['format']=='J'):
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            imm &= (2**instruction_dict[temp_inst[0].upper()]['i_width']-1)
            m_code = opcode |  rd<<7 | imm&0xFF000<<12 | imm&0x800<<20 | imm&0x7FE<<21 | imm&0x100000<<31
        
        elif (instruction_dict[temp_inst[0].upper()]['format']=='CR'):
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  rd<<7 | imm&0xFF000<<12 | imm&0x800<<20 | imm&0x7FE<<21 | imm&0x100000<<31
        
        elif (instruction_dict[temp_inst[0].upper()]['format']=='CI'):
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  rd<<7 | imm&0xFF000<<12 | imm&0x800<<20 | imm&0x7FE<<21 | imm&0x100000<<31
        
        #print(bin(m_code)[2:].zfill(32))
        if (temp_inst[0][0:1].upper=="C."):
            print(hex(m_code)[2:].zfill(4))
            print(bin(m_code)[2:].zfill(16))
        else:
            print(hex(m_code)[2:].zfill(8))
            print(bin(m_code)[2:].zfill(32))
           
        print('-------------------------------------------------')

    return

# Running Code
instructions, labels = parse_file(inst_file)
assemble(instructions, labels)

exit()