.data  
	.word 0x100,0x101,0x102,0x103,0x104,0x105,0x106,0x107,0x108,0x109,0x110,0x111,0x112
.text
main:
	add     t0,	x0,	x0
    li      t1,	0x10000000
	addi    t2,	x0,	10
L1:	lw      t3,	0x0(t1)
	add     t0,	t0,	t3
	addi	t1,	t1,	4
	addi	t2,	t2,	-1
	beq 	t2,	x0,	L2
	j	    L1
L2:	li      t1,	0x10000000
    sw      t0,	0x80(t1)
	ret

