
# sum.o：     文件格式 elf32-littleriscv


.text:

00010074 <main>:
   10074:	00000513          	li	a0,0
   10078:	00008067          	ret

0001014c <sum>:
   1014c:	02054063          	bltz	a0,1016c <sum+0x20>
   10150:	00150713          	addi	a4,a0,1
   10154:	00000793          	li	a5,0
   10158:	00000513          	li	a0,0
   1015c:	00f50533          	add	a0,a0,a5
   10160:	00178793          	addi	a5,a5,1
   10164:	fee79ce3          	bne	a5,a4,1015c <sum+0x10>
   10168:	00008067          	ret
   1016c:	00000513          	li	a0,0
   10170:	00008067          	ret

00010174 <exit>:
   10174:	ff010113          	addi	sp,sp,-16
   10178:	00000593          	li	a1,0
   1017c:	00812423          	sw	s0,8(sp)
   10180:	00112623          	sw	ra,12(sp)
   10184:	00050413          	mv	s0,a0
   10188:	194000ef          	jal	ra,1031c <__call_exitprocs>
   1018c:	c281a503          	lw	a0,-984(gp) # 119b8 <_global_impure_ptr>
   10190:	03c52783          	lw	a5,60(a0)
   10194:	00078463          	beqz	a5,1019c <exit+0x28>
   10198:	000780e7          	jalr	a5
   1019c:	00040513          	mv	a0,s0
   101a0:	3a4000ef          	jal	ra,10544 <_exit>
