import sys
from argparse import ArgumentParser
from registers import register_dict
from instructions import instruction_dict
from re import split

argparser = ArgumentParser()
argparser.add_argument('input_file', help='Input filename')
argparser.add_argument('output_file', help='Output filename')
argparser.add_argument('-comp_buffer', '-s', help='Enable compressed buffer', default=True)

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
            elif (temp_line[0] == '.'):
                # ignore directives
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

    return instructions, labels, line_list

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
    args = inst_info['args']
    if (len(inst[(args+1):]) > 0):
        print('Error: excessive number of arguments (' + str(args) + '+)')
        exit()
    encoding_type = inst_info['format']
    syntax = inst_info['syntax']
    try:
        imm_width = int(inst_info['i_width'])
    except:
        pass

    if (args==1):
        if (syntax=='l'):
            try:
                label_address = labels[inst[1]]
                offset = (label_address-inst_address)
                arg1 = str(offset)
            except IndexError:
                print('Invalid first arguement (Label) on {}'.format(inst))
                exit()
        elif (syntax=='i'): # Only C.ADDI16SP has this syntax
            try:
                imm = int(inst[1], 0)
                if (imm == 0):
                    print('Invalid immediate {} (nzimm) on {}'.format(imm, inst))
                    #exit()
                if ((imm < (0-(2**(imm_width-1)))) | (imm >= (2**(imm_width-1)))):
                    print('Immediate {} out of bounds on {}'.format(imm, inst))
                    print('[{},{}]'.format((2**(imm_width-1)-1), (0-(2**(imm_width-1)))))
                    #exit()
                tr_imm = imm & (2**imm_width-1)
                arg1 = str(tr_imm)
            except IndexError:
                print('Invalid first arguement (Imm) on {}'.format(inst))
                exit()
        elif (syntax=='r'):
            try:
                arg1 = register_dict[inst[1]]
            except IndexError:
                print('Invalid first arguement (Reg) on {}'.format(inst))
                exit()
        inst = [inst[0], arg1]

    elif (args>1):
        try:
            arg1 = register_dict[inst[1]]
        except IndexError:
            print('Invalid first arguement (Reg) on {}'.format(inst))
            exit()

        if ('C.' in inst[0]):
            if (inst_info['comp_reg']):
                if ((arg1<8) | (arg1>15)):
                    print('Invalid first arguement (C.Reg) on {}'.format(inst))
                    #exit()

        if (args==2):
            if (syntax=='r-l'): 
                try:
                    label_address = labels[inst[2]]
                    offset = (label_address-inst_address)
                    arg2 = str(offset)
                except IndexError:
                    print('Invalid second arguement (Label) on {}'.format(inst))
                    #exit()
            elif (syntax=='r-i'):
                try:
                    imm = int(inst[2], 0)
                    if ('C.' in inst[0]):
                        if ('uimm' in inst_info['imm']):
                            if ((imm < 1) | (imm >= (2**(imm_width)))) & (inst_info['imm']=='nzuimm'):
                                print('Invalid immediate {} (nzuimm) on {}'.format(imm, inst))
                                print('[1,{}]'.format((2**(imm_width)-1)))
                                #exit()
                            elif ((imm < 0) | (imm >= (2**(imm_width)))) & (inst_info['imm']=='uimm'):
                                print('Invalid immediate {} (uimm) on {}'.format(imm, inst))
                                print('[0,{}]'.format((2**(imm_width)-1)))
                                #exit()
                        else:
                            if (imm == 0) & (inst_info['imm']=='nzimm'):
                                print('Invalid immediate {} (nzimm) on {}'.format(imm, inst))
                                #exit()
                            if ((imm < (0-(2**(imm_width-1)))) | (imm >= (2**(imm_width-1)))):
                                print('Immediate {} out of bounds on {}'.format(imm, inst))
                                print('[{},{}]'.format((0-(2**(imm_width-1))), (2**(imm_width-1)-1)))
                                #exit()
                    elif ((imm < (0-(2**(imm_width-1)))) | (imm >= (2**(imm_width-1)))):
                        print('Immediate {} out of bounds on {}'.format(imm, inst))
                        print('[{},{}]'.format((0-(2**(imm_width-1))), (2**(imm_width-1)-1)))
                        #exit()
                    tr_imm = imm & (2**imm_width-1)
                    arg2 = str(tr_imm)
                except IndexError:
                    print('Invalid second arguement (Imm) on {}'.format(inst))
                    exit()
            elif (syntax=='r-r'):
                try:
                    arg2 = register_dict[inst[2]]
                except IndexError:
                    print('Invalid second arguement (Reg) on {}'.format(inst))
                    exit()
                if ('C.' in inst[0]):
                    if (inst_info['comp_reg']):
                        if ((arg2<8) | (arg2>15)):
                            print('Invalid second arguement (C.Reg) on {}'.format(inst))
                            exit()
            inst = [inst[0], arg1, arg2]
            
        elif (args==3):
            arg1 = register_dict[inst[1]]
            if ((syntax=='r-r-l') | (syntax=='r-r-i') | (syntax=='r-r-r')):
                try:
                    arg2 = register_dict[inst[2]]
                except IndexError:
                    print('Invalid second arguement (Reg) on {}'.format(inst))
                    exit()
                if (syntax=='r-r-l'):
                    try:
                        label_address = labels[inst[3]]
                        offset = (label_address-inst_address)
                        arg3 = str(offset)
                    except IndexError:
                        print('Invalid third arguement (Label) on {}'.format(inst))
                        exit()
                elif (syntax=='r-r-i'):
                    try:
                        imm = int(inst[3], 0)
                        tr_imm = imm & (2**imm_width-1)
                        if ((imm < (0-(2**(imm_width-1)))) & (imm >= (2**(imm_width-1)))):    # Only case is signed imm
                            print('Immediate {} out of bounds on {}'.format(imm, inst))
                            print('[{},{}]'.format((0-(2**(imm_width-1))), (2**(imm_width-1)-1)))
                            #exit()
                        arg3 = str(tr_imm)
                    except IndexError:
                        print('Invalid third arguement (Imm) on {}'.format(inst))
                        exit()
                else:
                    try:
                        arg3 = register_dict[inst[3]]
                    except IndexError:
                        print('Invalid third arguement (Reg) on {}'.format(inst))
                        exit()
            elif (syntax=='r-i_r'):
                try:
                    imm = int(inst[2], 0)
                    tr_imm = imm & (2**imm_width-1)
                    if ('C.' in inst[0]):   # Either C.LW or C.SW which are unsigned imm
                        if (imm < 0):
                            print('Invalid immediate {} (uimm) on {}'.format(imm, inst))
                            #exit()
                        elif (imm != tr_imm):
                            print('Immediate {} out of bounds on {}'.format(imm, inst))
                            print('[0,{}]'.format((2**(imm_width)-1)))
                            #exit()
                    elif ((imm < (0-(2**(imm_width-1)))) | (imm >= (2**(imm_width-1)))):    # Only case is signed imm
                        print('Immediate {} out of bounds on {}'.format(imm, inst))
                        print('[{},{}]'.format((0-(2**(imm_width-1))), (2**(imm_width-1)-1)))
                        #exit()
                    arg2 = str(tr_imm)
                except IndexError:
                    print('Invalid second arguement (Imm) on {}'.format(inst))
                    exit()
                try:
                    arg3 = register_dict[inst[3]]
                except IndexError:
                    print('Invalid third arguement (Reg) on {}'.format(inst))
                    exit()
                if (encoding_type=='CLS'):
                    if ((arg3<8) | (arg3>15)):
                        print('Invalid third arguement (C.Reg) on {}'.format(inst))
                        exit()
            inst = [inst[0], arg1, arg2, arg3]
    
    return inst

'''
    assemble() does the following:
    - convert to machine code
'''
def assemble(instructions, labels, instmem):
    out_buffer = ''
    try:
        logs = open(filename.split('.')[0]+'.log', "w")
    except:
        print("Failed to create file")

    for inst_address in instructions.keys():
        temp_inst = process_inst(instructions[inst_address], labels, inst_address)
        opt = temp_inst[0]
        opcode = instruction_dict[opt]['opcode']
        encoding_type = instruction_dict[opt]['format']

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

        if (encoding_type=='N'):
            m_code = opcode
        
        elif (encoding_type=='R'):
            rd = int(temp_inst[1])
            rs1 = int(temp_inst[2])
            rs2_shamt = int(temp_inst[3])
            m_code = opcode |  rd<<7 | funct3<<12 | rs1<<15 | rs2_shamt<<20 | funct7<<25
            
        elif (encoding_type=='I'):
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

        elif (encoding_type=='S'):
            rs1 = int(temp_inst[3])
            rs2 = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  (imm&0x1F)<<7 | funct3<<12 | rs1<<15 | rs2<<20 | (imm&0xFE0)<<20
            
        elif (encoding_type=='B'):
            rs1 = int(temp_inst[1])
            rs2 = int(temp_inst[2])
            offset = int(temp_inst[3])
            m_code = opcode | (offset&0x800)>>4 | (offset&0x1E)<<7 | funct3<<12 | rs1<<15 | rs2<<20 | (offset&0x7E0)<<20 | (offset&0x1000)<<19
            
        elif (encoding_type=='U'):
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            m_code = opcode |  rd<<7 | ((imm << 12) & 0xFFFFF000)
        
        elif (encoding_type=='J'):
            rd = int(temp_inst[1])
            offset = int(temp_inst[2])
            m_code = opcode |  rd<<7 | (offset&0xFF000) | (offset&0x800)<<9 | (offset&0x7FE)<<20 | (offset&0x100000)<<11
        
        elif (encoding_type=='CR'):
            if (instruction_dict[opt]['syntax']=='r'):
                rd_rs1 = int(temp_inst[1])
                rs2 = 0
            else:
                rd_rs1 = int(temp_inst[1])
                rs2 = int(temp_inst[2])
            m_code = opcode |  rs2<<2 | rd_rs1<<7 | funct4<<12
        
        elif (encoding_type=='CI'):
            rd = int(temp_inst[1])
            imm = int(temp_inst[2])
            if (temp_inst[0] == 'C.LWSP'):
                imm = imm << 2
                m_code = opcode | (imm&0x1C)<<2 | rd<<7 | (imm&0x20)<<7 | (imm&0xC0)>>4 | funct3<<13            # different format for lwsp
            elif (temp_inst[0] == 'C.SWSP'):
                imm = imm << 2
                m_code = opcode | (imm&0x3C)<<7 | rd<<2 | (imm&0xC0)<<1 | funct3<<13         # also different format for swsp                
            else:
                m_code = opcode | (imm&0x1F)<<2 | rd<<7 | (imm&0x20)<<7 | funct3<<13
        
        elif (encoding_type=='CLS'):
            rd_rs2_ = int(temp_inst[1]) - 8
            imm = (int(temp_inst[2])) << 2
            rs1_ = int(temp_inst[3]) - 8
            m_code = opcode |  rd_rs2_<<2 | (imm&0x40)>>1 | (imm&0x4)<<4 | rs1_<<7 | (imm&0x38)<<7 | funct3<<13

        elif (encoding_type=='CB'):
            rs1_ = int(temp_inst[1]) - 8
            offset = int(temp_inst[2])
            m_code = opcode | (offset&0x20)>>3 | (offset&0x6)<<2 | (offset&0xC0)>>1 | rs1_<<7 | (offset&0x18)<<7 | (offset&0x100)<<4 | funct3<<13

        elif (encoding_type=='CA'):
            rs2_ = int(temp_inst[2]) - 8
            rd_rs1_ = int(temp_inst[1]) - 8
            m_code = opcode |  rs2_<<2 | funct2<<5 | rd_rs1_<<7 | funct6<<10

        elif (encoding_type=='CH'):
            imm = int(temp_inst[2])
            rd_rs1_ = int(temp_inst[1]) - 8
            m_code = opcode | (imm&0x1F)<<2 | rd_rs1_<<7 | funct2<<10 | (imm&0x20)<<7 | funct3<<13

        elif (encoding_type=='CJ'):
            offset = int(temp_inst[1])
            # 5|3:1|7|6|10|9:8|4|11
            m_code = opcode | (offset&0x20)>>3 | (offset&0xE)<<2 | (offset&0x80)>>1 | (offset&0x40)<<1 | (offset&0x400)>>2 | (offset&0x300)<<1 | (offset&0x10)<<7 | (offset&0x800)<<1 | funct3<<13

        elif (encoding_type=='CIW'):
            rd_ = int(temp_inst[1]) - 8
            imm = int(temp_inst[2]) << 2
            m_code = opcode |  rd_<<2 | (imm&0x8)<<2 | (imm&0x4)<<4 | (imm&0x3C0)<<1 | (imm&0x30)<<7 | funct3<<13

        elif (encoding_type=='C16'):
            imm = int(temp_inst[1]) << 4
            m_code = opcode | (imm&0x20)>>3 | (imm&0x180)>>4 | (imm&0x40)>>1 | (imm&0x10)<<2 | 2<<7 | (imm&0x200)<<3 | funct3<<13

        else:
            print('Encoding type not supported.')
            m_code = 1
        
        if ('C.' in opt):
            out = str(hex(m_code)[2:].zfill(4))
            if (comp_buffer_en == 'True'):
                if (out_buffer == ''):
                    out_buffer = out
                else:
                    # print(out + out_buffer + '\n')
                    instmem.write(str(out_buffer) + '\n' + str(out) + '\n')
                    out_buffer = ''
            else:   # insert an upper nop
                instmem.write('0001 ' + '\n' + out + '\n')
        else:
            full_inst = str(hex(m_code)[2:].zfill(8))
            # print(full_inst)
            if (out_buffer):
                instmem.write(out_buffer + '\n' + full_inst[4:8] + '\n')
                out_buffer = full_inst[0:4]
            else:
                instmem.write(full_inst[4:8] + '\n' + full_inst[0:4] + '\n')
                out_buffer = ''

        #print('Instruction at address {}:\t{}\t{}'.format(inst_address, str(hex(m_code)[2:].zfill(8)), temp_inst))
        #print('----------------------------------------------------------------------------------------------------')

        logs.write('0x{:03x}: {} '.format(inst_address, temp_inst))
        if('C.' in opt):
            logs.write(hex(m_code)[2:].zfill(4))
        else:
            logs.write(hex(m_code)[2:].zfill(8))
        logs.write('\n')

    if (out_buffer):
        instmem.write(str(out_buffer) + '\n0001\n')

    logs.close()
    return

'''
    convert_file() does the following:
    - replaced compressed instruction with their base equivalent for use in RARS
'''
def convert_file(line_list):
    # Create base instructions file
    basename = args.input_file.split('.')[0] + '_base.s'
    try:
        base_file = open(basename, "w")
    except:
        print("Failed to create file")
    
    for index in list(range(0,len(line_list))):
        temp_line = line_list[index].strip()
        if ((temp_line.split('.')[0] == 'c') | (temp_line.split('.')[0] == 'C')):
            inst = split('[ \t,()]', temp_line)
            for j in inst:
                if (j == ''):
                    inst.pop(inst.index(j))
            inst_info = instruction_dict[inst[0].upper()]
            expansion_method = inst_info['expansion_method']
            if (expansion_method == 'none'):
                base_file.write(str(temp_line[2:]))
            elif (expansion_method == 'dup_reg'):
                base_file.write(str(inst[0][2:]) + ' ' + str(inst[1]) + ', ' +str(inst[1]) + ', ' + str(inst[2]))
            else:
                equivalent = inst_info['equivalent']
                if (expansion_method == 'insert_x0'):
                    if inst_info['args']==1:
                        base_file.write(str(equivalent) + ' x0, ' + str(inst[1]))
                    elif inst_info['args']==2:
                        base_file.write(str(equivalent) + ' ' + str(inst[1]) + ', x0, ' + str(inst[2]))
                elif (expansion_method == 'insert_x0+0'):
                    base_file.write(str(equivalent) + ' x0, ' + str(inst[1]) + ', 0')
                elif (expansion_method == 'insert_x1'):
                    base_file.write(str(equivalent) + ' x1, ' + str(inst[1]))
                elif (expansion_method == 'insert_x1+0'):
                    base_file.write(str(equivalent) + ' x1, ' + str(inst[1]) + ', 0')
                elif (expansion_method == 'replace'):
                    base_file.write(str(equivalent) + ' ' + str(inst[1:]))
                elif (expansion_method == 'times_4(x2)'):
                    base_file.write(str(equivalent) + ' ' + str(inst[1]) + ', ' + str(int(inst[2])*4) + '(x2)')
                elif (expansion_method == 'times_4'):
                    base_file.write(str(equivalent) + ' ' + str(inst[1]) + ', ' + str(int(inst[2])*4) + '({})'.format(inst[3]))
                elif (expansion_method == 'x2_times_4'):
                    base_file.write(str(equivalent) + ' ' + str(inst[1]) + ', x2, ' + str(int(inst[2])*4))
                elif (expansion_method == 'times_16'):
                    base_file.write(str(equivalent) + ', ' + str(int(inst[1])*16))
                else:
                    base_file.write(str(inst_info['expansion']))
            base_file.write('\t#from ' + temp_line + '\n')
        else:
            base_file.write(temp_line + '\n')
        #print(temp_line)
    # Delete base instructions file
    #os.remove(basename)
    base_file.close()
    return base_file

# Running Code
# Parse file
instructions, labels, line_list = parse_file(inst_file)

# Convert to base instruction equivalents
convert_file(line_list)

# Create output file
save_file = args.output_file
try:
    instmem = open(save_file, "w")
    # instmem.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
except:
    print("Failed to create file")
# Convert to machine code
assemble(instructions, labels, instmem)
# instmem.write(";")
instmem.close()
print('Saved to ' + save_file)

exit()
