main:
# x1 reserved for jal
# x2 stack pointer
# x3 spi - control signal
# x4 spi - data transmit
addi x0, x0, 0

addi x2, x0, 60	# stack pointer

addi x3, x0, 13	# registers number
sw x3, 0(x0)

addi x3, x0, 1000
slli x3, x3, 8
addi x3, x3, 0xc
sw x3, 8(x0)	# prescale

jal x1, delay_250us

xori x3, x3, 0x2	# turnon
sw x3, 8(x0)

jal x1, delay_250us

addi x4, x0, 0x2D	# accel measure
slli x4, x4, 8
addi x4, x4, 0x08
jal x1, spi_send

addi x4, x0, 0x1E	# x offset
slli x4, x4, 8
addi x4, x4, 0x00
jal x1, spi_send

addi x4, x0, 0x1F	# y offset
slli x4, x4, 8
addi x4, x4, 0x00
jal x1, spi_send

addi x4, x0, 0x20	# z offset
slli x4, x4, 8
addi x4, x4, 0x0B
jal x1, spi_send

jal x1, lcd_setup	# setup lcd

# x5 - acc debounce
# x6 - acc x
# x7 - acc y
# x8 - acc z
# x9, x10 - temp

addi x5, x0, 50

spi_read:
addi x4, x0, 0xb3	# x msb
slli x4, x4, 8
addi x4, x4, 0xff
jal x1, spi_send
lw x9, 0x44(x0)
andi x10, x9, 0xFF
slli x10, x10, 8

addi x4, x0, 0xb2	# x lsb
slli x4, x4, 8
addi x4, x4, 0xff
jal x1, spi_send
lw x9, 0x44(x0)
andi x9, x9, 0xFF
add x6, x9, x10

addi x4, x0, 0xb5	# y msb
slli x4, x4, 8
addi x4, x4, 0xff
jal x1, spi_send
lw x9, 0x44(x0)
andi x10, x9, 0xFF
slli x10, x10, 8

addi x4, x0, 0xb4	# y lsb
slli x4, x4, 8
addi x4, x4, 0xff
jal x1, spi_send
lw x9, 0x44(x0)
andi x9, x9, 0xFF
add x7, x9, x10

addi x4, x0, 0xb7	# z msb
slli x4, x4, 8
addi x4, x4, 0xff
jal x1, spi_send
lw x9, 0x44(x0)
andi x10, x9, 0xFF
slli x10, x10, 8

addi x4, x0, 0xb6	# z lsb
slli x4, x4, 8
addi x4, x4, 0xff
jal x1, spi_send
lw x9, 0x44(x0)
andi x9, x9, 0xFF
add x8, x9, x10

# 009A - 0200 pos
# FE00 - FF66 neg

# 14 ctr1
# 11 ctr2
# 12 ctr3
# 13 ctr4


lw x20, 0x50
andi x22, x20, 0xFF
addi x21, x0, 0x7E
srli x20, x20, 8
bne x22, x21, skip_song_end

jal x1, lcd_setup
jal x1, send_next
andi x22, x20, 0xFF
addi x21, x0, 0xFF
srli x20, x20, 8
bne x22, x21, skip_song_end

jal x1, send_next
andi x22, x20, 0xFF
addi x21, x0, 0x06
srli x20, x20, 8
bne x22, x21, skip_song_end

jal x1, send_next
andi x22, x20, 0xFF
addi x21, x0, 0x3D
srli x20, x20, 8
bne x22, x21, skip_song_end

jal x1, send_next
skip_song_end:

# xpos
addi x9, x0, 0x9A
bltu x6, x9, cmd1
addi x9, x0, 0x200
bgeu x6, x9, cmd1
bltu x14, x5, inc1
addi x14, x0, 0

jal x1, uart_play
jal x1, lcd_setup
jal x1, send_play
cmd1:
addi x14, x0, 0
inc1:
addi x14, x14, 1

# xneg
addi x9, x0, 0xFE
slli x9, x9, 8
bltu x6, x9, cmd2
addi x9, x0, 0xFF
slli x9, x9, 8
addi x9, x9, 0x66
bgeu x6, x9, cmd2
bltu x11, x5, inc2
addi x11, x0, 0

jal x1, uart_pause
jal x1, lcd_setup
jal x1, send_pause
cmd2:
addi x11, x0, 0
inc2:
addi x11, x11, 1

# ypos
addi x9, x0, 0x9A
bltu x7, x9, cmd3
addi x9, x0, 0x200
bgeu x7, x9, cmd3
bltu x12, x5, inc3
addi x12, x0, 0

jal x1, uart_next
jal x1, lcd_setup
jal x1, send_next
cmd3:
addi x12, x0, 0
inc3:
addi x12, x12, 1

# yneg
addi x9, x0, 0xFE
slli x9, x9, 8
bltu x7, x9, cmd4
addi x9, x0, 0xFF
slli x9, x9, 8
addi x9, x9, 0x66
bgeu x7, x9, cmd4
bltu x13, x5, inc4
addi x13, x0, 0

jal x1, uart_previous
jal x1, lcd_setup
jal x1, send_prev
cmd4:
addi x13, x0, 0
inc4:
addi x13, x13, 1

beq x0, x0, spi_read

spi_send:
# x4 = data to be sent
addi x2, x2, -8
sw x5, 8(x2)
sw x6, 4(x2)

sw x4, 0x4(x0)	# store data

xori x3, x3, 1	# enable
sw x3, 8(x0)

addi x6, x0, 2

spi_busy:
lw x5, 0x40(x0)
bne x5, x6, spi_busy

xori x3, x3, 1
sw x3, 0x8(x0)	# disable

addi x6, x0, 1

spi_done_high:
lw x5, 0x40(x0)
bne x5, x6, spi_done_high

spi_done_low:
lw x5, 0x40(x0)
beq x5, x6, spi_done_low

lw x5, 8(x2)
lw x6, 4(x2)
addi x2, x2, 8

jalr x0, x1, 0


uart_pause:
addi x15, x0, 0
addi x16, x0, 0
addi x17, x0, 0
addi x18, x0, 0
lui x16, 0x258
addi x17, x0, 0x4c

addi x2, x2, -4
sw x1, 4(x2)

addi x15, x0, 0x7E	# UART Data In
jal x1, uart_send

addi x15, x0, 0xFF	# UART Data In
jal x1, uart_send

addi x15, x0, 0x06	# UART Data In
jal x1, uart_send

addi x15, x0, 0x0E	# UART Data In
jal x1, uart_send

addi x15, x0, 0x00	# UART Data In
jal x1, uart_send

addi x15, x0, 0x00	# UART Data In
jal x1, uart_send

addi x15, x0, 0x01	# UART Data In
jal x1, uart_send

addi x15, x0, 0xFE	# UART Data In
jal x1, uart_send

addi x15, x0, 0xEC	# UART Data In
jal x1, uart_send

addi x15, x0, 0xEF	# UART Data In
jal x1, uart_send

addi x16, x16, 0x4	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

jal x1, nop_13

addi x16, x16, -4	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

lw x1, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0

uart_next:
addi x15, x0, 0
addi x16, x0, 0
addi x17, x0, 0
addi x18, x0, 0
lui x16, 0x258
addi x17, x0, 0x4c

addi x2, x2, -4
sw x1, 4(x2)

addi x15, x0, 0x7E	# UART Data In
jal x1, uart_send

addi x15, x0, 0xFF	# UART Data In
jal x1, uart_send

addi x15, x0, 0x06	# UART Data In
jal x1, uart_send

addi x15, x0, 0x01	# UART Data In
jal x1, uart_send

addi x15, x0, 0x00	# UART Data In
jal x1, uart_send

addi x15, x0, 0x00	# UART Data In
jal x1, uart_send

addi x15, x0, 0x01	# UART Data In
jal x1, uart_send

addi x15, x0, 0xFE	# UART Data In
jal x1, uart_send

addi x15, x0, 0xF9	# UART Data In
jal x1, uart_send

addi x15, x0, 0xEF	# UART Data In
jal x1, uart_send

addi x16, x16, 0x4	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

jal x1, nop_13

addi x16, x16, -4	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

lw x1, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0

uart_previous:
addi x15, x0, 0
addi x16, x0, 0
addi x17, x0, 0
addi x18, x0, 0
lui x16, 0x258
addi x17, x0, 0x4c

addi x2, x2, -4
sw x1, 4(x2)

addi x15, x0, 0x7E	# UART Data In
jal x1, uart_send

addi x15, x0, 0xFF	# UART Data In
jal x1, uart_send

addi x15, x0, 0x06	# UART Data In
jal x1, uart_send

addi x15, x0, 0x02	# UART Data In
jal x1, uart_send

addi x15, x0, 0x00	# UART Data In
jal x1, uart_send

addi x15, x0, 0x00	# UART Data In
jal x1, uart_send

addi x15, x0, 0x01	# UART Data In
jal x1, uart_send

addi x15, x0, 0xFE	# UART Data In
jal x1, uart_send

addi x15, x0, 0xF8	# UART Data In
jal x1, uart_send

addi x15, x0, 0xEF	# UART Data In
jal x1, uart_send

addi x16, x16, 0x4	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

jal x1, nop_13

addi x16, x16, -4	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

lw x1, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0

uart_play:
addi x15, x0, 0
addi x16, x0, 0
addi x17, x0, 0
addi x18, x0, 0
lui x16, 0x258
addi x17, x0, 0x4c

addi x2, x2, -4
sw x1, 4(x2)

addi x15, x0, 0x7E	# UART Data In
jal x1, uart_send

addi x15, x0, 0xFF	# UART Data In
jal x1, uart_send

addi x15, x0, 0x06	# UART Data In
jal x1, uart_send

addi x15, x0, 0x0D	# UART Data In
jal x1, uart_send

addi x15, x0, 0x00	# UART Data In
jal x1, uart_send

addi x15, x0, 0x00	# UART Data In
jal x1, uart_send

addi x15, x0, 0x01	# UART Data In
jal x1, uart_send

addi x15, x0, 0xFE	# UART Data In
jal x1, uart_send

addi x15, x0, 0xED	# UART Data In
jal x1, uart_send

addi x15, x0, 0xEF	# UART Data In
jal x1, uart_send

addi x16, x16, 0x4	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

jal x1, nop_13

addi x16, x16, -4	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

lw x1, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0

nop_13:
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
jalr x0, x1, 0

uart_send:
sw x15, 0xc(x0)

addi x16, x16, 0x1	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0
addi x0, x0, 0

addi x16, x16, -1	# UART Input Control 1 (Mode)
sw x16, 0x10(x0)

addi x18, x18, 0x2
u1:
lw x15, 0x0(x17)
bne x15, x18, u1
jalr x0, x1, 0

#SETUP START
lcd_setup:
addi x2, x2, -16

sw x1, 16(x2)
sw x4, 12(x2)
sw x5, 8(x2)
sw x6, 4(x2)

addi x4, x0, 0x38
jal x1, i2c_send
addi x4, x0, 0x3C
jal x1, i2c_send
addi x4, x0, 0x38
jal x1, i2c_send

jal x1, delay_4_7ms	#delay 4.7 ms

addi x4, x0, 0x38
jal x1, i2c_send
addi x4, x0, 0x3C
jal x1, i2c_send
addi x4, x0, 0x38
jal x1, i2c_send

jal x1, delay_4_7ms	#delay 4.7 ms

addi x4, x0, 0x38
jal x1, i2c_send
jal x1, delay_250us	#delay 250 us
addi x4, x0, 0x3C
jal x1, i2c_send
jal x1, delay_250us	#delay 250 us
addi x4, x0, 0x38
jal x1, i2c_send

jal x1, delay_250us	#delay 250 us

addi x4, x0, 0x28
jal x1, i2c_send
addi x4, x0, 0x2C
jal x1, i2c_send
addi x4, x0, 0x28
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x28
jal x1, i2c_send
addi x4, x0, 0x2C
jal x1, i2c_send
addi x4, x0, 0x28
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x88
jal x1, i2c_send
addi x4, x0, 0x8C
jal x1, i2c_send
addi x4, x0, 0x88
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x08
jal x1, i2c_send
addi x4, x0, 0x0C
jal x1, i2c_send
addi x4, x0, 0x08
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0xC8
jal x1, i2c_send
addi x4, x0, 0xCC
jal x1, i2c_send
addi x4, x0, 0xC8
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x08
jal x1, i2c_send
addi x4, x0, 0x0C
jal x1, i2c_send
addi x4, x0, 0x08
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x18
jal x1, i2c_send
addi x4, x0, 0x1C
jal x1, i2c_send
addi x4, x0, 0x18
jal x1, i2c_send

jal x1, delay_2_1ms	#delay 2.1 ms

addi x4, x0, 0x08
jal x1, i2c_send
addi x4, x0, 0x0C
jal x1, i2c_send
addi x4, x0, 0x08
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x68
jal x1, i2c_send
addi x4, x0, 0x6C
jal x1, i2c_send
addi x4, x0, 0x68
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x08
jal x1, i2c_send
addi x4, x0, 0x0C
jal x1, i2c_send
addi x4, x0, 0x08
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x28
jal x1, i2c_send
addi x4, x0, 0x2C
jal x1, i2c_send
addi x4, x0, 0x28
jal x1, i2c_send

jal x1, delay_2_1ms	#delay 2.1 ms

addi x4, x0, 0x08
jal x1, i2c_send
addi x4, x0, 0x88
jal x1, i2c_send
addi x4, x0, 0x8C
jal x1, i2c_send
addi x4, x0, 0x88
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x18
jal x1, i2c_send
addi x4, x0, 0x1C
jal x1, i2c_send
addi x4, x0, 0x18
jal x1, i2c_send

lw x1, 16(x2)
lw x4, 12(x2)
lw x5, 8(x2)
lw x6, 4(x2)

addi x2, x2, 16
jalr x0, x1, 0
#SETUP END


#space start
send_space:
addi x2, x2, -16

sw x1, 16(x2)
sw x4, 12(x2)
sw x5, 8(x2)
sw x6, 4(x2)

jal x1, delay_65us	#delay 65 us
addi x4, x0, 0x29
jal x1, i2c_send
addi x4, x0, 0x2D
jal x1, i2c_send
addi x4, x0, 0x29
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x09
jal x1, i2c_send
addi x4, x0, 0x0D
jal x1, i2c_send
addi x4, x0, 0x09
jal x1, i2c_send

lw x1, 16(x2)
lw x4, 12(x2)
lw x5, 8(x2)
lw x6, 4(x2)

addi x2, x2, 16
jalr x0, x1, 0
#space end


#PLAYING start
send_play:
addi x2, x2, -16

sw x1, 16(x2)
sw x4, 12(x2)
sw x5, 8(x2)
sw x6, 4(x2)

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x09
jal x1, i2c_send
addi x4, x0, 0x0D
jal x1, i2c_send
addi x4, x0, 0x09
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0xC9
jal x1, i2c_send
addi x4, x0, 0xCD
jal x1, i2c_send
addi x4, x0, 0xC9
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x19
jal x1, i2c_send
addi x4, x0, 0x1D
jal x1, i2c_send
addi x4, x0, 0x19
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x99
jal x1, i2c_send
addi x4, x0, 0x9D
jal x1, i2c_send
addi x4, x0, 0x99
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x99
jal x1, i2c_send
addi x4, x0, 0x9D
jal x1, i2c_send
addi x4, x0, 0x99
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0xE9
jal x1, i2c_send
addi x4, x0, 0xED
jal x1, i2c_send
addi x4, x0, 0xE9
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x79
jal x1, i2c_send
addi x4, x0, 0x7D
jal x1, i2c_send
addi x4, x0, 0x79
jal x1, i2c_send

lw x1, 16(x2)
lw x4, 12(x2)
lw x5, 8(x2)
lw x6, 4(x2)

addi x2, x2, 16
jalr x0, x1, 0
#PLAYING end


#PAUSED start
send_pause:
addi x2, x2, -16

sw x1, 16(x2)
sw x4, 12(x2)
sw x5, 8(x2)
sw x6, 4(x2)

jal x1, delay_65us	#delay 65 us
addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x09
jal x1, i2c_send
addi x4, x0, 0x0D
jal x1, i2c_send
addi x4, x0, 0x09
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x19
jal x1, i2c_send
addi x4, x0, 0x1D
jal x1, i2c_send
addi x4, x0, 0x19
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x39
jal x1, i2c_send
addi x4, x0, 0x3D
jal x1, i2c_send
addi x4, x0, 0x39
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

lw x1, 16(x2)
lw x4, 12(x2)
lw x5, 8(x2)
lw x6, 4(x2)

addi x2, x2, 16
jalr x0, x1, 0
#PAUSED end


#PREVIOUS start
send_prev:
addi x2, x2, -16

sw x1, 16(x2)
sw x4, 12(x2)
sw x5, 8(x2)
sw x6, 4(x2)

jal x1, delay_65us	#delay 65 us
addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x09
jal x1, i2c_send
addi x4, x0, 0x0D
jal x1, i2c_send
addi x4, x0, 0x09
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x29
jal x1, i2c_send
addi x4, x0, 0x2D
jal x1, i2c_send
addi x4, x0, 0x29
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x69
jal x1, i2c_send
addi x4, x0, 0x6D
jal x1, i2c_send
addi x4, x0, 0x69
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x99
jal x1, i2c_send
addi x4, x0, 0x9D
jal x1, i2c_send
addi x4, x0, 0x99
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0xF9
jal x1, i2c_send
addi x4, x0, 0xFD
jal x1, i2c_send
addi x4, x0, 0xF9
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x39
jal x1, i2c_send
addi x4, x0, 0x3D
jal x1, i2c_send
addi x4, x0, 0x39
jal x1, i2c_send

lw x1, 16(x2)
lw x4, 12(x2)
lw x5, 8(x2)
lw x6, 4(x2)

addi x2, x2, 16
jalr x0, x1, 0
#PREVIOUS end

#NEXT start
send_next:
addi x2, x2, -16

sw x1, 16(x2)
sw x4, 12(x2)
sw x5, 8(x2)
sw x6, 4(x2)

jal x1, delay_65us	#delay 65 us
addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0xE9
jal x1, i2c_send
addi x4, x0, 0xED
jal x1, i2c_send
addi x4, x0, 0xE9
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x89
jal x1, i2c_send
addi x4, x0, 0x8D
jal x1, i2c_send
addi x4, x0, 0x89
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x59
jal x1, i2c_send
addi x4, x0, 0x5D
jal x1, i2c_send
addi x4, x0, 0x59
jal x1, i2c_send

jal x1, delay_65us	#delay 65 us

addi x4, x0, 0x49
jal x1, i2c_send
addi x4, x0, 0x4D
jal x1, i2c_send
addi x4, x0, 0x49
jal x1, i2c_send

lw x1, 16(x2)
lw x4, 12(x2)
lw x5, 8(x2)
lw x6, 4(x2)

addi x2, x2, 16
jalr x0, x1, 0
#NEXT end

i2c_send: 
#x4 = data to be sent

addi x2, x2, -12
sw x5, 12(x2)
sw x6, 8(x2)
sw x1, 4(x2)

addi x5, x0, 0x20	#set prescale

sw x5, 0x18(x0)

sw x4, 0x14(x0)	#save data

addi x5, x0, 0x29	#write start command
slli x5, x5, 8
addi x5, x5, 0xCA

sw x5, 0x18(x0)
addi x4, x0, 0x00
jal x1, nop_13
sw x4, 0x14(x0) 

i2c_loop_w1:	#exit if BUSY
lw x6, 0x58(x0)
addi x5, x0, 1

bne x6, x5, i2c_loop_w1

addi x5, x0, 0	#clear signals
sw x5, 0x18(x0)

i2c_loop2_w1:	#exit if DONE
lw x6, 0x58(x0)
addi x5, x0, 2
bne x6, x5, i2c_loop2_w1

jal x1, delay_250us	#delay 250 us
jal x1, delay_250us	#delay 250 us
jal x1, delay_250us	#delay 250 us
jal x1, delay_250us	#delay 250 us

lw x5, 12(x2)
lw x6, 8(x2)
lw x1, 4(x2)
addi x2, x2, 12

jalr x0, x1, 0
#i2c send end

#delay 4.7 ms_start
delay_4_7ms:
addi x2, x2, -4
sw x5, 4(x2)

addi x5, x0, 0x07
slli x5, x5, 8
addi x5, x5, 0xA7

stall_4_7ms:
addi x5, x5, -1
bne x5, x0, stall_4_7ms

lw x5, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0
#delay 4.7 ms_end

#delay 2.1 ms_start
delay_2_1ms:
addi x2, x2, -4
sw x5, 4(x2)

addi x5, x0, 0x07
slli x5, x5, 8
addi x5, x5, 0xE3

stall_2_1ms:
addi x5, x5, -1
bne x5, x0, stall_2_1ms

lw x5, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0
#delay 2.1 ms_end


#delay 250 us_start
delay_250us:
addi x2, x2, -4
sw x5, 4(x2)

addi x5, x0, 0x7F

stall_250us:
addi x5, x5, -1
bne x5, x0, stall_250us

lw x5, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0
#delay 250 us_end


#delay 65 us_start
delay_65us:
addi x2, x2, -4
sw x5, 4(x2)

addi x5, x0, 63

stall_65us:
addi x5, x5, -1
bne x5, x0, stall_65us

lw x5, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0
#delay 65 us_end


#delay 90 us_start
delay_90us:
addi x2, x2, -4
sw x5, 4(x2)

addi x5, x0, 86

stall_90us:
addi x5, x5, -1
bne x5, x0, stall_90us

lw x5, 4(x2)
addi x2, x2, 4

jalr x0, x1, 0
#delay 90 us_end