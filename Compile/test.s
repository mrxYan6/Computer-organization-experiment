.text


main:
add     x3,x1,x2
sll     x4,x1,x2
slli    x5,x2,0x12
addi    x6,x1,-0x64
addi    x6,x1,0x52
lw      x2,0x78(x0)
sw      x2,0x64(x0)
lui     x2,0x34422
bne     x2, x3, -0x32
blt     x3, x4, -0x64
jalr    x0, x0, 0x2
jal     x7, 0x73262


