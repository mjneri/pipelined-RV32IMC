.data
.word 0xc0e19800
.word 0xeee19000

.text
main:
lw x1, 0(x0)
lw x2, 4(x0)

mul x3, x1, x2
mulh x4, x1, x2
mulhu x5, x1, x2
mulhsu x6, x1, x2