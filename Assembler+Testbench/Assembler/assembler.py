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
# to do: flip bytes (Little Endian)
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
    t_inst[0] = t_inst[0].upper()
    encoding_type = inst_type['format']
    syntax = inst_type['syntax']
    args = inst_type['args']
    if (len(t_inst[(args+1):]) > 0):
        print('Error: excessive number of arguments (' + str(args) + '+)')
        exit()
    
    if (args==1):
        if (syntax=='l'):
            try:
                arg1 = str(t_inst[1])
            except IndexError:
                print('Invalid first arguement (Label)')
                exit()
        elif (syntax=='i'):
            try:
                arg1 = int(t_inst[1], 0)
            except IndexError:
                print('Invalid first arguement (Imm)')
                exit()
        elif (syntax=='r'):
            try:
                arg1 = register_dict[t_inst[1]]
            except IndexError:
                print('Invalid first arguement (Reg)')
                exit()
        t_inst = [t_inst[0], arg1]

    elif (args>1):
        try:
            arg1 = register_dict[t_inst[1]]
        except IndexError:
            print('Invalid first arguement (Reg)')
            exit()

        if (args==2):
            if (syntax=='r-l'):
                if (encoding_type=='CLS'):
                    if (arg1>7 & arg1<16):
                        arg1 -= 8
                    else:
                        print('Invalid first arguement (C.Reg)')
                        exit()
                try:
                    arg2 = str(t_inst[2])
                except IndexError:
                    print('Invalid second arguement (Label)')
                    exit()
            elif (syntax=='r-i'):
                try:
                    arg2 = int(t_inst[2], 0)
                except IndexError:
                    print('Invalid second arguement (Imm)')
                    exit()
            elif (syntax=='r-r'):
                try:
                    arg2 = register_dict[t_inst[2]]
                except IndexError:
                    print('Invalid second arguement (Reg)')
                    exit()
            t_inst = [t_inst[0], arg1, arg2]
            
        elif (args==3):
            arg1 = register_dict[t_inst[1]]
            if ((syntax=='r-r-l') | (syntax=='r-r-i')):
                try:
                    arg2 = register_dict[t_inst[2]]
                except IndexError:
                    print('Invalid second arguement (Reg)')
                    exit()
                if (syntax=='r-r-l'):
                    try:
                        arg3 = str(t_inst[3])
                    except IndexError:
                        print('Invalid third arguement (Label)')
                        exit()
                elif (syntax=='r-r-i'):
                    try:
                        arg3 = int(t_inst[3], 0)
                    except IndexError:
                        print('Invalid third arguement (Imm)')
                        exit()
            elif (syntax=='r-i_r'):     # Immediate-only arguement
                try:
                    arg2 = int(t_inst[2], 0)
                except IndexError:
                    print('Invalid second arguement (Imm)')
                    exit()
                try:
                    arg3 = register_dict[t_inst[3]]
                except IndexError:
                    print('Invalid third arguement (Reg)')
                    exit()
                if (encoding_type=='CLS'):
                    if (arg1>7 & arg1<16):
                        arg1 -= 8
                    else:
                        print('Invalid first arguement (C.Reg)')
                        exit()
                    if (arg3>7 & arg3<16):
                        arg3 -= 8
                    else:
                        print('Invalid third arguement (C.Reg)')
                        exit()
            t_inst = [t_inst[0], arg1, arg2, arg3]
    
    return t_inst

def process_inst(inst):
    t_inst = inst
    t_inst = split('[ \t,()]', t_inst)
    # go through elements and ditch empty strings
    for j in t_inst:
        if (j == ''):
            t_inst.pop(t_inst.index(j))
    # check if regular instruction
    inst_type = instruction_dict[t_inst[0].upper()]
    t_inst = parse_inst(inst_type, t_inst)
    return t_inst

def parse_file(line_list):
    line_list = []
    for line in inst_file:
        line_list.append(line)

    instructions = {}
    instruction_address = 0
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
                instructions[instruction_address] = temp_line
                # it's (a) label(s)
                if (len(label_q) > 0):
                    for l in label_q:
                        labels[l] = instruction_address
                    label_q.clear()
                if (temp_line[0][0].upper()=='C'):
                    instruction_address += 2
                else:
                    instruction_address += 4

    return instructions, labels

def assemble(instructions, labels, instmem):
    for inst_address in instructions.keys():
        temp_inst = process_inst(instructions[inst_address])
        opt = temp_inst[0]
        opcode = instruction_dict[opt]['opcode']
        encoding_type = instruction_dict[opt]['format']

        print('instruction: {}'.format(temp_inst))

        try:
            imm_width = instruction_dict[opt]['i_width']
        except:
            pass
        try:    
            funct2 = instruction_dict[opt]['funct2']
        except:
            pass
        try:    
            funct3 = instruction_dict[opt]['funct3']
        except:
            pass
        try:    
            funct4 = instruction_dict[opt]['funct4']
        except:
            pass
        try:    
            funct6 = instruction_dict[opt]['funct6']
        except:
            pass
        try:    
            funct7 = instruction_dict[opt]['funct7']
        except:
            pass

        if (encoding_type=='N'):        # Okay
            m_code = opcode
        
        elif (encoding_type=='R'):      # Okay
            rd = int(temp_inst[1])
            rs1 = int(temp_inst[2])
            rs2_shamt = int(temp_inst[3])
            m_code = opcode |  rd<<7 | funct3<<12 | rs1<<15 | rs2_shamt<<20 | funct7<<25
            
        elif (encoding_type=='I'):      # Okay
            rd = int(temp_inst[1])
            if (instruction_dict[opt]['syntax']=='r-i_r'):
                rs1 = int(temp_inst[3])
                imm = int(temp_inst[2])
            elif (instruction_dict[opt]['syntax']=='r-r-i'):
                rs1 = int(temp_inst[2])
                imm = int(temp_inst[3])
            elif (instruction_dict[opt]['syntax']=='r-r-l'):
                rs1 = int(temp_inst[2])
                label_address = labels[temp_inst[3]]
                imm = (label_address-inst_address)
            else:
                print('Something went wrong')
                exit()
            imm &= (2**imm_width-1)
            m_code = opcode | rd<<7 | funct3<<12 | rs1<<15 | imm<<20

        elif (encoding_type=='S'):      # Okay
            rs1 = int(temp_inst[3])
            rs2 = int(temp_inst[1])
            imm = int(temp_inst[2])&(2**imm_width-1)
            m_code = opcode |  (imm&0x1F)<<7 | funct3<<12 | rs1<<15 | rs2<<20 | (imm&0xFE0)<<14

        elif (encoding_type=='B'):      # Okay
            rs1 = int(temp_inst[1])
            rs2 = int(temp_inst[2])
            label_address = labels[temp_inst[3]]
            imm = (label_address-inst_address)
            m_code = opcode | (imm&0x800)>>4 | (imm&0x1E)<<7 | funct3<<12 | rs1<<15 | rs2<<20 | (imm&0x7E0)<<20 | (imm&0x1000)<<19
            
        elif (encoding_type=='U'):      # Okay
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])&(2**imm_width-1)&0xFFFFF000
            m_code = opcode |  rd<<7 | imm
        
        elif (encoding_type=='J'):
            rd = int(temp_inst[1])
            label_address = labels[temp_inst[2]]
            imm = (label_address-inst_address)
            m_code = opcode |  rd<<7 | (imm&0xFF000) | (imm&0x800)<<9 | (imm&0x7FE)<<20 | (imm&0x100000)<<11
        
        elif (encoding_type=='CR'):     # Okay
            if (instruction_dict[opt]['syntax']=='r'):
                rd_rs1_ = int(temp_inst[1])
                rs2_ = 0
            else:
                rd_rs1_ = int(temp_inst[1])
                rs2_ = int(temp_inst[2])
            m_code = opcode |  rs2_<<2 | rd_rs1_<<7 | (imm&0x38)<<10 | funct4<<12
        
        elif (encoding_type=='CI'):     # Okay
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])&(2**imm_width-1)
            m_code = opcode | (imm&0x1F)<<2 | rd<<7 | (imm&0x20)<<7 | funct3<<13
        
        elif (encoding_type=='CLS'):    # Okay
            rd_rs2_ = int(temp_inst[1])
            imm = int(temp_inst[2])&(2**imm_width-1)
            rs1_ = int(temp_inst[3])
            m_code = opcode |  rd_rs2_<<2 | (imm&0x40)>>1 | (imm&0x4)<<4 | rs1_<<7 | (imm&0x38)<<7 | funct3<<13

        elif (encoding_type=='CB'):     # Okay
            rs1_ = int(temp_inst[1])
            label_address = labels[temp_inst[2]]
            imm = (label_address-inst_address)
            m_code = opcode | (imm&0x20)>>2 | (imm&0x6)<<2 | (imm&0xC)>>1 | rs1_<<7 | (imm&0x18)<<7 | (imm&0x100)<<4 | funct3<<13

        elif (encoding_type=='CA'):     # Okay
            rs2_ = int(temp_inst[2])
            rd_rs1_ = int(temp_inst[1])
            m_code = opcode |  rs2_<<2 | funct2<<5 | rd_rs1_<<7 | funct6<<10

        elif (encoding_type=='CH'):     # Okay
            imm = int(temp_inst[2])&(2**imm_width-1)
            rd_rs1_ = int(temp_inst[1])
            m_code = opcode | imm&0x1F<<2 | rd_rs1_<<7 | funct2<<10 | imm&0x20<<7 | funct3<<10

        elif (encoding_type=='CJ'):
            label_address = labels[temp_inst[1]]
            imm = (label_address-inst_address)
            # 5|3:1|7|6|10|9:8|4|11
            m_code = opcode | (imm&0x20)>>2 | (imm&0xE)>>2 | (imm&0x80)>>1 | (imm&0x40)<<1 | (imm&0x400)>>2 | (imm&0x30)>>1 | (imm&0x10)<<8 | (imm&0x800)<<1 | funct3<<13

        elif (encoding_type=='C4'):     # Okay
            rd_ = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  rd_<<2 | (imm&0x8)<<2 | (imm&0x4)<<4 | (imm&0x3C0)<<1 | (imm&0x30)<<7 | funct3<<13

        elif (encoding_type=='C16'):    # Okay
            imm = int(temp_inst[1])
            m_code = opcode | (imm&0x20)>>3 | (imm&0x18)>>4 | (imm&0x40)>>1 | (imm&0x10)<<2 | 2<<7 | (imm&0x200)<<4 | funct3<<13

        else:
            print('Work in progress')
            m_code = 1
        
        if (opt[0]=='C'):
            out = (hex(m_code)[2:].zfill(4))
            print(out)
            instmem.write(out +'\n')
            #print(bin(m_code)[2:].zfill(16))
        else:
            out = (hex(m_code)[2:].zfill(8))
            print(out)
            instmem.write(out +'\n')
            #print(bin(m_code)[2:].zfill(32))
           
        print('-------------------------------------------------')

    return

# Running Code
instructions, labels = parse_file(inst_file)

try:
    instmem = open("instmem.txt", "w")
except:
    print("Failed to create file")

print(instructions)
print(labels)

assemble(instructions, labels, instmem)

exit()