# This is a database for all supported instructions

instruction_dict= {
    # Base
    'LUI':      {'args':2,  'syntax':'r-i',     'i_width':32,   'format':'U',   'opcode':55,    'funct3':0},
    'AUIPC':    {'args':2,  'syntax':'r-i',     'i_width':32,   'format':'U',   'opcode':23,    'funct3':0},
    'JAL':      {'args':2,  'syntax':'r-l',     'i_width':21,   'format':'J',   'opcode':111,   'funct3':0},
    'JALR':     {'args':3,  'syntax':'r-r-i',   'i_width':12,   'format':'I',   'opcode':103,   'funct3':0},
    #'JALR':     {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'I',   'opcode':103,   'funct3':0},
    'BEQ':      {'args':3,  'syntax':'r-r-l',   'i_width':13,   'format':'B',   'opcode':99,    'funct3':0},
    'BNE':      {'args':3,  'syntax':'r-r-l',   'i_width':13,   'format':'B',   'opcode':99,    'funct3':1},
    'BLT':      {'args':3,  'syntax':'r-r-l',   'i_width':13,   'format':'B',   'opcode':99,    'funct3':4},
    'BGE':      {'args':3,  'syntax':'r-r-l',   'i_width':13,   'format':'B',   'opcode':99,    'funct3':5},
    'BLTU':     {'args':3,  'syntax':'r-r-l',   'i_width':13,   'format':'B',   'opcode':99,    'funct3':6},
    'BGEU':     {'args':3,  'syntax':'r-r-l',   'i_width':13,   'format':'B',   'opcode':99,    'funct3':7},
    'LB':       {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'I',   'opcode':3,     'funct3':0},
    'LH':       {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'I',   'opcode':3,     'funct3':1},
    'LW':       {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'I',   'opcode':3,     'funct3':2},
    'LBU':      {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'I',   'opcode':3,     'funct3':4},
    'LHU':      {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'I',   'opcode':3,     'funct3':5},
    'SB':       {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'S',   'opcode':35,    'funct3':0},
    'SH':       {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'S',   'opcode':35,    'funct3':1},
    'SW':       {'args':3,  'syntax':'r-i_r',   'i_width':12,   'format':'S',   'opcode':35,    'funct3':2},
    'ADDI':     {'args':3,  'syntax':'r-r-i',   'i_width':12,   'format':'I',   'opcode':19,    'funct3':0},
    'SLTI':     {'args':3,  'syntax':'r-r-i',   'i_width':12,   'format':'I',   'opcode':19,    'funct3':2},
    'SLTIU':    {'args':3,  'syntax':'r-r-i',   'i_width':12,   'format':'I',   'opcode':19,    'funct3':3},
    'XORI':     {'args':3,  'syntax':'r-r-i',   'i_width':12,   'format':'I',   'opcode':19,    'funct3':4},
    'ORI':      {'args':3,  'syntax':'r-r-i',   'i_width':12,   'format':'I',   'opcode':19,    'funct3':6},
    'ANDI':     {'args':3,  'syntax':'r-r-i',   'i_width':12,   'format':'I',   'opcode':19,    'funct3':7},
    'SLLI':     {'args':3,  'syntax':'r-r-i',   'i_width':5,    'format':'R',   'opcode':19,    'funct3':1, 'funct7':0},
    'SRLI':     {'args':3,  'syntax':'r-r-i',   'i_width':5,    'format':'R',   'opcode':19,    'funct3':5, 'funct7':0},
    'SRAI':     {'args':3,  'syntax':'r-r-i',   'i_width':5,    'format':'R',   'opcode':19,    'funct3':5, 'funct7':32},
    'ADD':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':0, 'funct7':0},
    'SUB':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':0, 'funct7':32},
    'SLL':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':1, 'funct7':0},
    'SLT':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':2, 'funct7':0},
    'SLTU':     {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':3, 'funct7':0},
    'XOR':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':4, 'funct7':0},
    'SRL':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':5, 'funct7':0},
    'SRA':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':5, 'funct7':32},
    'OR':       {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':6, 'funct7':0},
    'AND':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':7, 'funct7':0},
    'NOP':      {'args':0,  'syntax':'none',                    'format':'N',   'opcode':19},
    #'FENCE':    {'args':3,  'syntax':'r-r-r',                   'format':'F',   'opcode':15},
    'ECALL':    {'args':0,  'syntax':'none',                    'format':'N',   'opcode':115},
    'EBREAK':   {'args':0,  'syntax':'none',                    'format':'N',   'opcode':1048691},

    # Multiplication
    'MUL':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':0, 'funct7':1},
    'MULH':     {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':1, 'funct7':1},
    'MULHSU':   {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':2, 'funct7':1},
    'MULHU':    {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':3, 'funct7':1},
    'DIV':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':4, 'funct7':1},
    'DIVU':     {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':5, 'funct7':1},
    'REM':      {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':6, 'funct7':1},
    'REMU':     {'args':3,  'syntax':'r-r-r',                   'format':'R',   'opcode':51,    'funct3':7, 'funct7':1},

    # Compressed (Floating Points were removed)
    'C.ADDI4SPN':{'args':2, 'syntax':'r-i',     'i_width':10,   'format':'CIW', 'opcode':0,     'funct3':0,                 'expansion_method':'none',          'expansion':'none'},
    #'C.FLD':    {'args':3,  'syntax':'r-i_r',   'i_width':8,    'format':'CLS', 'opcode':0,     'funct3':1,                'expansion_method':'none',			'expansion':'none'},
    'C.LW':     {'args':3,  'syntax':'r-i_r',   'i_width':7,    'format':'CLS', 'opcode':0,     'funct3':2,                 'expansion_method':'none',			'expansion':'lw rd_, offset[6:2](rs1_)'},
    #'C.FLW':    {'args':3,  'syntax':'r-i_r',   'i_width':7,    'format':'CLS', 'opcode':0,     'funct3':3,                 'expansion_method':'none',	         'expansion='none'},
    #'C.FSD':    {'args':3,  'syntax':'r-i_r',   'i_width':7,    'format':'CLS', 'opcode':0,     'funct3':5,                 'expansion_method':'none',		     'expansion':'none'},
    #'C.FSW':    {'args':3,  'syntax':'r-i_r',   'i_width':7,    'format':'CLS', 'opcode':0,     'funct3':7,                 'expansion_method':'none',		     'expansion':'none'},
    'C.SW':     {'args':3,  'syntax':'r-i_r',   'i_width':7,    'format':'CLS', 'opcode':0,     'funct3':6,                 'expansion_method':'none',			'expansion':'sw rs2_, offset[6:2](rs1_)'},
    'C.NOP':    {'args':0,  'syntax':'none',                    'format':'N',   'opcode':1,                                 'expansion_method':'none',			'expansion':'nop'},
    'C.ADDI':   {'args':2,  'syntax':'r-i',     'i_width':6,    'format':'CI',  'opcode':1,     'funct3':0,                 'expansion_method':'dup_reg',		'expansion':'addi rd, rd, imm'},
    'C.JAL':    {'args':1,  'syntax':'l',       'i_width':12,   'format':'CJ',  'opcode':1,     'funct3':1,                 'expansion_method':'insert_x1',		'expansion':'jal x1, label',            'equivalent':'jal'},
    'C.LI':     {'args':2,  'syntax':'r-i',     'i_width':6,    'format':'CI',  'opcode':1,     'funct3':2,                 'expansion_method':'insert_x0',		'expansion':'addi, rd, x0, imm',        'equivalent':'addi'},
    'C.ADDI16SP':{'args':1, 'syntax':'i',       'i_width':10,   'format':'C16', 'opcode':1,     'funct3':3,                 'expansion_method':'replace',		'expansion':'addi x2, x2, nzimm[9:4]',  'equivalent':'addi x2, x2'},
    'C.LUI':    {'args':2,  'syntax':'r-i',     'i_width':18,   'format':'CI',  'opcode':1,     'funct3':3,                 'expansion_method':'none',			'expansion':'lui rd, nzimm[17:12]'},
    'C.SRLI':   {'args':2,  'syntax':'r-i',     'i_width':6,    'format':'CH',  'opcode':1,     'funct2':0, 'funct3':4,     'expansion_method':'dup_reg',		'expansion':'srli rd_, rd_, shamt'},
    'C.SRAI':   {'args':2,  'syntax':'r-i',	    'i_width':6,    'format':'CH',  'opcode':1,     'funct2':1, 'funct3':4,     'expansion_method':'dup_reg',		'expansion':'srai rd_, rd_, shamt'},
    'C.ANDI':   {'args':2,  'syntax':'r-i',	    'i_width':6,    'format':'CH',  'opcode':1,     'funct2':2, 'funct3':4,     'expansion_method':'dup_reg',		'expansion':'andi rd_, rd_, imm'},
    'C.SUB':    {'args':2,  'syntax':'r-r',	                    'format':'CA',  'opcode':1,     'funct2':0, 'funct6':35,    'expansion_method':'dup_reg',		'expansion':'sub rd_, rd_, rs2_'},
    'C.XOR':    {'args':2,  'syntax':'r-r',	                    'format':'CA',  'opcode':1,     'funct2':1, 'funct6':35,    'expansion_method':'dup_reg',		'expansion':'xor rd_, rd_, rs2_'},
    'C.OR':     {'args':2,  'syntax':'r-r',	                    'format':'CA',  'opcode':1,     'funct2':2, 'funct6':35,    'expansion_method':'dup_reg',		'expansion':'or rd_, rd_, rs2_'},
    'C.AND':    {'args':2,  'syntax':'r-r',	                    'format':'CA',  'opcode':1,     'funct2':3, 'funct6':35,    'expansion_method':'dup_reg',		'expansion':'and rd_, rd_, rs2_'},
    'C.J':      {'args':1,  'syntax':'l',       'i_width':12,   'format':'CJ',  'opcode':1,     'funct3':5,                 'expansion_method':'replace',		'expansion':'jal, x0, label',           'equivalent':'jal x0'},
    'C.BEQZ':   {'args':2,  'syntax':'r-l',	    'i_width':9,    'format':'CB',  'opcode':1,     'funct3':6,                 'expansion_method':'insert_x0',		'expansion':'beq rs1_, x0, label',      'equivalent':'beq'},
    'C.BNEZ':   {'args':2,  'syntax':'r-l',	    'i_width':9,    'format':'CB',  'opcode':1,     'funct3':7,                 'expansion_method':'insert_x0',		'expansion':'bne rs1_, x0, label',      'equivalent':'bne'},
    'C.SLLI':   {'args':2,  'syntax':'r-i',	    'i_width':6,    'format':'CI',  'opcode':2,     'funct3':0,                 'expansion_method':'dup_reg',		'expansion':'slli rd, rd, shamt'},
    #'C.FLDSP':  {'args':2,  'syntax':'r-i',     'i_width':9,    'format':'CI',  'opcode':2,     'funct3':1,                 'expansion_method':'none',		     'expansion':'none'},
    'C.LWSP':   {'args':2,  'syntax':'r-i',     'i_width':9,    'format':'CI',  'opcode':2,     'funct3':2,                 'expansion_method':'replace',		'expansion':'lw rd, offset[7:2](x2)',   'equivalent':'lw'},
    #'C.FLWSP':  {'args':2,  'syntax':'r-i',     'i_width':9,    'format':'CI',  'opcode':2,     'funct3':3,                 'expansion_method':'none',		     'expansion':'none'},
    'C.JR':     {'args':1,  'syntax':'r',                       'format':'CR',  'opcode':2,     'funct4':8,                 'expansion_method':'replace',		'expansion':'jalr x0, rs1, 0',          'equivalent':'jalr x0'},
    'C.MV':     {'args':2,  'syntax':'r-r',                     'format':'CR',  'opcode':2,     'funct4':8,                 'expansion_method':'insert_x0',		'expansion':'add rd, x0, rs2',          'equivalent':'add'},
    'C.EBREAK': {'args':0,  'syntax':'none',                    'format':'N',   'opcode':36866,                             'expansion_method':'none',			'expansion':'ebreak'},
    'C.JALR':   {'args':1,  'syntax':'r',	                    'format':'CR',  'opcode':2,     'funct4':9,                 'expansion_method':'insert_x1',		'expansion':'jalr x1, rs1, 0',          'equivalent':'jalr'},
    'C.ADD':    {'args':2,  'syntax':'r-r',                     'format':'CR',  'opcode':2,     'funct4':9,                 'expansion_method':'dup_reg',		'expansion':'add rd_, rd_, rs2_'},
    #'C.FSDSP':  {'args':2,  'syntax':'r-i',     'i_width':9,    'format':'CI',  'opcode':2,     'funct3':5,                 'expansion_method':'none',		     'expansion':'none'},
    'C.SWSP':   {'args':2,  'syntax':'r-i',     'i_width':8,    'format':'CI',  'opcode':2,     'funct3':6,                 'expansion_method':'replace',		'expansion':'sw rs2, offset[8:2](x2)',  'equivalent':'sw'},
    #'C.FSWSP':  {'args':2,  'syntax':'r-i',     'i_width':8,    'format':'CI',  'opcode':2,     'funct3':7,                 'expansion_method':'none',		     'expansion':'none'

    # Interrupts
    'URET':     {'args':0,  'syntax':'none',                    'format':'N',   'opcode':2097267}
}