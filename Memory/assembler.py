import sys
from argparse import ArgumentParser
from registers import register_dict
from instructions import instruction_dict
from re import split

argparser = ArgumentParser()
argparser.add_argument('input_file', help='Input filename')
argparser.add_argument('output_file', help='Output filename')
argparser.add_argument('-comp_buffer', '-s', help='Enable compressed buffer', default=False)

args = argparser.parse_args(sys.argv[1:])

global comp_buffer_en
comp_buffer_en = args.comp_buffer
#print(comp_buffer_en)

filename = args.input_file
#print(filename)

try:
    inst_file = open(filename)
except:
    print('File error')
    exit()

'''
    parse_file() does the following:
    - get rid of empty lines
    - strip stuff from lines
    - associate instructions to their addresses 

    return variables:
    - dictionary: instructions (contains all instructions)
    - dictionary: labels (contains all labels and symbols)
'''
def parse_file(inst_file):
    line_list = []
    for line in inst_file:
        line_list.append(line)
    
    label_q = []
    
    labels = {}
    instructions = {}
    instruction_address = 0

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

'''
    process_inst() does the following:
    - error checking of instruction syntax

    return variables:
    - array of instruction arguements with replaced registers and address offset
'''
def process_inst(inst, labels, inst_address):
    inst = split('[ \t,()]', inst)
    # go through elements and ditch empty strings
    for j in inst:
        if (j == ''):
            inst.pop(inst.index(j))
    # check if regular instruction
    inst_info = instruction_dict[inst[0].upper()]
    # arg1 = 0
    # arg2 = 0
    # arg3 = 0
    inst[0] = inst[0].upper()
    encoding_type = inst_info['format']
    syntax = inst_info['syntax']
    args = inst_info['args']
    if (len(inst[(args+1):]) > 0):
        print('Error: excessive number of arguments (' + str(args) + '+)')
        exit()
    
    if (args==1):
        if (syntax=='l'):
            try:
                label_address = labels[inst[1]]
                offset = (label_address-inst_address)
                arg1 = str(offset)
            except IndexError:
                print('Invalid first arguement (Label)')
                exit()
        elif (syntax=='i'):
            try:
                arg1 = int(inst[1], 0)
            except IndexError:
                print('Invalid first arguement (Imm)')
                exit()
        elif (syntax=='r'):
            try:
                arg1 = register_dict[inst[1]]
            except IndexError:
                print('Invalid first arguement (Reg)')
                exit()
        inst = [inst[0], arg1]

    elif (args>1):
        try:
            arg1 = register_dict[inst[1]]
        except IndexError:
            print('Invalid first arguement (Reg)')
            exit()

        if ((encoding_type=='CLS') | (encoding_type=='CIW') | (encoding_type=='CB') | (encoding_type=='CH')):
            if (arg1>7 & arg1<16):
                arg1 -= 8
            else:
                print('Invalid first arguement (C.Reg)')
                exit()

        if (args==2):
            if (syntax=='r-l'): 
                try:
                    label_address = labels[inst[2]]
                    offset = (label_address-inst_address)
                    arg2 = str(offset)
                except IndexError:
                    print('Invalid second arguement (Label)')
                    exit()
            elif (syntax=='r-i'):
                try:
                    arg2 = int(inst[2], 0)
                except IndexError:
                    print('Invalid second arguement (Imm)')
                    exit()
            elif (syntax=='r-r'):
                try:
                    arg2 = register_dict[inst[2]]
                except IndexError:
                    print('Invalid second arguement (Reg)')
                    exit()
            inst = [inst[0], arg1, arg2]
            
        elif (args==3):
            arg1 = register_dict[inst[1]]
            if ((syntax=='r-r-l') | (syntax=='r-r-i') | (syntax=='r-r-r')):
                try:
                    arg2 = register_dict[inst[2]]
                except IndexError:
                    print('Invalid second arguement (Reg)')
                    exit()
                if (syntax=='r-r-l'):
                    try:
                        label_address = labels[inst[3]]
                        offset = (label_address-inst_address)
                        arg3 = str(offset)
                    except IndexError:
                        print('Invalid third arguement (Label)')
                        exit()
                elif (syntax=='r-r-i'):
                    try:
                        arg3 = int(inst[3], 0)
                    except IndexError:
                        print('Invalid third arguement (Imm)')
                        exit()
                else:
                    try:
                        arg3 = register_dict[inst[3]]
                    except IndexError:
                        print('Invalid third arguement (Reg)')
                        exit()
            elif (syntax=='r-i_r'):     # Immediate-only arguement
                try:
                    arg2 = int(inst[2], 0)
                except IndexError:
                    print('Invalid second arguement (Imm)')
                    exit()
                try:
                    arg3 = register_dict[inst[3]]
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
            inst = [inst[0], arg1, arg2, arg3]
    
    return inst

'''
    assemble() does the following:
    - convert to machine code
'''
def assemble(instructions, labels, instmem):
    out_buffer = {}
    compressed_counter = 0
    for inst_address in instructions.keys():
        temp_inst = process_inst(instructions[inst_address], labels, inst_address)
        opt = temp_inst[0]
        opcode = instruction_dict[opt]['opcode']
        encoding_type = instruction_dict[opt]['format']

        print('Instruction at address {}: {}'.format(inst_address, temp_inst))

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
                imm = temp_inst[3]
            else:
                print('Something went wrong')
                exit()
            imm &= (2**imm_width-1)
            m_code = opcode | rd<<7 | funct3<<12 | rs1<<15 | imm<<20

        elif (encoding_type=='S'):      # Okay
            rs1 = int(temp_inst[3])
            rs2 = int(temp_inst[1])
            imm = int(temp_inst[2])&(2**imm_width-1)
            m_code = opcode |  (imm&0x1F)<<7 | funct3<<12 | rs1<<15 | rs2<<20 | (imm&0xFE0)<<20
            
        elif (encoding_type=='B'):      # Okay
            rs1 = int(temp_inst[1])
            rs2 = int(temp_inst[2])
            offset = temp_inst[3]
            m_code = opcode | (imm&0x800)>>4 | (imm&0x1E)<<7 | funct3<<12 | rs1<<15 | rs2<<20 | (imm&0x7E0)<<20 | (imm&0x1000)<<19
            
        elif (encoding_type=='U'):      # Okay
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  rd<<7 | ((imm << 12) & 0xFFFFF000)
        
        elif (encoding_type=='J'):
            rd = int(temp_inst[1])
            offset = temp_inst[2]
            m_code = opcode |  rd<<7 | (imm&0xFF000) | (imm&0x800)<<9 | (imm&0x7FE)<<20 | (imm&0x100000)<<11
        
        elif (encoding_type=='CR'):     # Okay
            if (instruction_dict[opt]['syntax']=='r'):
                rd_rs1_ = int(temp_inst[1])
                rs2_ = 0
            else:
                rd_rs1_ = int(temp_inst[1])
                rs2_ = int(temp_inst[2])
            m_code = opcode |  rs2_<<2 | rd_rs1_<<7 | funct4<<12
        
        elif (encoding_type=='CI'):     # Okay
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])&(2**imm_width-1)
            if (temp_inst[0] == 'C.LWSP'):
                imm = imm << 2
                m_code = opcode | (imm&0x1C)<<2 | rd<<7 | (imm&0x20)<<7 | (imm&0xC0)>>4 | funct3<<13            # different format for lwsp
            elif (temp_inst[0] == 'C.SWSP'):
                imm = imm << 2
                m_code = opcode | (imm&0x3C)<<7 | rd<<2 | (imm&0xC0)<<1 | funct3<<13               # also different format for swsp                
            else:
                m_code = opcode | (imm&0x1F)<<2 | rd<<7 | (imm&0x20)<<7 | funct3<<13
        
        elif (encoding_type=='CLS'):    # Okay
            rd_rs2_ = int(temp_inst[1])
            imm = int(temp_inst[2])&(2**imm_width-1)
            rs1_ = int(temp_inst[3])
            rs1_ = (rs1_ & 0x07)
            rd_rs2_ = (rd_rs2_ & 0x07)
            m_code = opcode |  rd_rs2_<<2 | (imm&0x40)>>1 | (imm&0x4)<<4 | rs1_<<7 | (imm&0x38)<<7 | funct3<<13

        elif (encoding_type=='CB'):     # Okay
            rs1_ = int(temp_inst[1])
            offset = temp_inst[2]
            if (rs1_ < 8 | rs1_ > 16):
                print('Warning: Rs1 {} truncated to {}'.format(rs1_, (0x08) | (rs1_ & 0x07)))
            rs1_ = (rs1_ & 0x07)
            m_code = opcode | (imm&0x20)>>3 | (imm&0x6)<<2 | (imm&0xC0)>>1 | rs1_<<7 | (imm&0x18)<<7 | (imm&0x100)<<4 | funct3<<13

        elif (encoding_type=='CA'):     # Okay
            rs2_ = int(temp_inst[2])
            rd_rs1_ = int(temp_inst[1])
            if (rd_rs1_ < 8 | rd_rs1_ > 16):
                print('Warning: Rd/Rs1 {} truncated to {}'.format(rd_rs1_, (0x08) | (rd_rs1_ & 0x07)))
            rd_rs1_ = (rd_rs1_ & 0x07)
            if (rs2_ < 8 | rs2_ > 16):
                print('Warning: Rs2 {} truncated to {}'.format(rs2_, (0x08) | (rs2_ & 0x07)))
            rs2_ = (rs2_ & 0x07)
            m_code = opcode |  rs2_<<2 | funct2<<5 | rd_rs1_<<7 | funct6<<10

        elif (encoding_type=='CH'):     # Okay
            imm = int(temp_inst[2])&(2**imm_width-1)
            rd_rs1_ = int(temp_inst[1])
            m_code = opcode | (imm&0x1F)<<2 | rd_rs1_<<7 | funct2<<10 | (imm&0x20)<<7 | funct3<<13

        elif (encoding_type=='CJ'):
            offset = temp_inst[1]
            # 5|3:1|7|6|10|9:8|4|11
            m_code = opcode | (imm&0x20)>>3 | (imm&0xE)<<2 | (imm&0x80)>>1 | (imm&0x40)<<1 | (imm&0x400)>>2 | (imm&0x300)<<1 | (imm&0x10)<<7 | (imm&0x800)<<1 | funct3<<13

        elif (encoding_type=='CIW'):     # Okay
            rd_ = int(temp_inst[1])
            imm = int(temp_inst[2])<<2
            if (rd_ < 8 | rd_ > 16):
                print('Warning: Rd {} truncated to {}'.format(rd_, (0x08) | (rd_ & 0x07)))
            rd_ = (rd_ & 0x07)
            m_code = opcode |  rd_<<2 | (imm&0x8)<<2 | (imm&0x4)<<4 | (imm&0x3C0)<<1 | (imm&0x30)<<7 | funct3<<13

        elif (encoding_type=='C16'):    # Okay
            imm = int(temp_inst[1])<<4
            m_code = opcode | (imm&0x20)>>3 | (imm&0x180)>>4 | (imm&0x40)>>1 | (imm&0x10)<<2 | 2<<7 | (imm&0x200)<<3 | funct3<<13

        else:
            print('Work in progress')
            m_code = 1

        print(hex(m_code)[2:].zfill(8))
        
        if (opt[0] == 'C'):
            out = (hex(m_code)[2:].zfill(4))
            if (comp_buffer_en == 'True'):
                if (compressed_counter == 0):
                    out_buffer = out
                    compressed_counter = 1
                else:
                    # print(out + out_buffer + '\n')
                    instmem.write(out_buffer + ' ' + out + '\n')
                    compressed_counter = 0
                    out_buffer = ''
            else:   # insert an upper nop
                instmem.write('0001 ' + out + '\n')
        else:
            full_inst = (hex(m_code)[2:].zfill(8))
            # print(full_inst)
            if (out_buffer):
                instmem.write(out_buffer + ' ' + full_inst[4:8] + '\n')
                out_buffer = full_inst[0:4]
            else:
                instmem.write(full_inst[4:8] + ' ' + full_inst[0:4] + '\n')
        print('-------------------------------------------------')
    if (out_buffer):
        instmem.write(hex(0x0001)[2:].zfill(4))
        instmem.write(' ' + out_buffer + '\n')
    return

'''
    convert_file() does the following:
    - replaced compressed instruction with their base equivalent for use in RARS
'''
def convert_file(instructions, base_labels):
    # Create base instructions file
    basename = args.input_file.split('.')[0] + '_base.asm'
    try:
        base_file = open(basename, "w")
    except:
        print("Failed to create file")
    inst_address = 0
    for temp_address in instructions.keys():
        temp_line = instructions[temp_address]
        if ((temp_line[0] == 'C') | (temp_line[0] == 'c')):
            inst = split('[ \t,()]', temp_line)
            for j in inst:
                if (j == ''):
                    inst.pop(inst.index(j))
            inst_info = instruction_dict[inst[0].upper()]
            base_file.write(str(temp_line) + ' converts to ' + str(inst_info['expansion']) + '\n')
        else:
            base_file.write(temp_line + '\n')

    # Delete base instructions file
    #os.remove(basename)
    return base_file

# Running Code
# Parse file
instructions, labels = parse_file(inst_file)

# Convert to base instruction equivalents
base_file = convert_file(instructions, labels)

# Create output file
save_file = args.output_file
try:
    instmem = open(save_file, "w")
    instmem.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
except:
    print("Failed to create file")
# Convert to machine code
assemble(instructions, labels, instmem)
instmem.write(";")
print('Saved to ' + save_file)

exit()