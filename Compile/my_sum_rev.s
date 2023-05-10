
# my_sum.o：     文件格式 elf32-littleriscv


# Disassembly of section 
.text

00000000 <sum>:
   0:	00000293          	li	t0,0
   4:	00000313          	li	t1,0
   8:	00150393          	addi	t2,a0,1

0000000c <Loop>:
   c:	00530333          	add	t1,t1,t0
  10:	00128293          	addi	t0,t0,1
  14:	fe729ce3          	bne	t0,t2,c <Loop>
  18:	00030513          	mv	a0,t1
  1c:	00008067          	ret

00000020 <main>:
  20:	00000517          	auipc	a0,0x0
  24:	00050513          	mv	a0,a0
  28:	00052503          	lw	a0,0(a0) # 20 <main>
  2c:	ff810113          	addi	sp,sp,-8
  30:	00112023          	sw	ra,0(sp)
  34:	00812223          	sw	s0,4(sp)
  38:	fc9ff0ef          	jal	ra,0 <sum>
  3c:	00012083          	lw	ra,0(sp)
  40:	00412403          	lw	s0,4(sp)
  44:	00810113          	addi	sp,sp,8
  48:	00000297          	auipc	t0,0x0
  4c:	00028293          	mv	t0,t0
  50:	00a2a023          	sw	a0,0(t0) # 48 <main+0x28>
  54:	00000513          	li	a0,0
  58:	00008067          	ret