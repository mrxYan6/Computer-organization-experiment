.data
x:	.word 100
y: 	.word 0
.globl	main

.text

# 函数定义
sum:
	li		t0, 0
	li		t1, 0
	addi 	t2, a0 , 1
Loop:
	add		t1, t1, t0
	addi	t0, t0, 1
	bne 	t0, t2, Loop
	mv		a0, t1
	jr		ra

main:
	la		a0, x			 
	lw		a0, 0(a0)
	addi 	sp, sp, -8		
	sw		ra, 0(sp)
	sw 		s0, 4(sp)
	jal		sum	
	lw		ra, 0(sp)
	lw		s0, 4(sp)
	addi	sp, sp, 8
	la      t0, y      	
	sw      a0, 0(t0)
	li		a0, 0			
	jr		ra
