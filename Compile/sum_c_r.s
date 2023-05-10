
# sum_c.o：     文件格式 elf32-littleriscv


.text:

00010144 <sum>:
   10144:	fd010113          	addi	sp,sp,-48
   10148:	02812623          	sw	s0,44(sp)
   1014c:	03010413          	addi	s0,sp,48
   10150:	fca42e23          	sw	a0,-36(s0)
   10154:	fe042423          	sw	zero,-24(s0)
   10158:	fe042623          	sw	zero,-20(s0)
   1015c:	0200006f          	j	1017c <sum+0x38>
   10160:	fe842703          	lw	a4,-24(s0)
   10164:	fec42783          	lw	a5,-20(s0)
   10168:	00f707b3          	add	a5,a4,a5
   1016c:	fef42423          	sw	a5,-24(s0)
   10170:	fec42783          	lw	a5,-20(s0)
   10174:	00178793          	addi	a5,a5,1
   10178:	fef42623          	sw	a5,-20(s0)
   1017c:	fec42703          	lw	a4,-20(s0)
   10180:	fdc42783          	lw	a5,-36(s0)
   10184:	fce7dee3          	bge	a5,a4,10160 <sum+0x1c>
   10188:	fe842783          	lw	a5,-24(s0)
   1018c:	00078513          	mv	a0,a5
   10190:	02c12403          	lw	s0,44(sp)
   10194:	03010113          	addi	sp,sp,48
   10198:	00008067          	ret

0001019c <main>:
   1019c:	fe010113          	addi	sp,sp,-32
   101a0:	00112e23          	sw	ra,28(sp)
   101a4:	00812c23          	sw	s0,24(sp)
   101a8:	02010413          	addi	s0,sp,32
   101ac:	06400793          	li	a5,100
   101b0:	fef42623          	sw	a5,-20(s0)
   101b4:	fec42503          	lw	a0,-20(s0)
   101b8:	f8dff0ef          	jal	ra,10144 <sum>
   101bc:	fea42423          	sw	a0,-24(s0)
   101c0:	00000793          	li	a5,0
   101c4:	00078513          	mv	a0,a5
   101c8:	01c12083          	lw	ra,28(sp)
   101cc:	01812403          	lw	s0,24(sp)
   101d0:	02010113          	addi	sp,sp,32
   101d4:	00008067          	ret

000101d8 <exit>:
   101d8:	ff010113          	addi	sp,sp,-16
   101dc:	00000593          	li	a1,0
   101e0:	00812423          	sw	s0,8(sp)
   101e4:	00112623          	sw	ra,12(sp)
   101e8:	00050413          	mv	s0,a0
   101ec:	194000ef          	jal	ra,10380 <__call_exitprocs>
   101f0:	c281a503          	lw	a0,-984(gp) # 11a18 <_global_impure_ptr>
   101f4:	03c52783          	lw	a5,60(a0)
   101f8:	00078463          	beqz	a5,10200 <exit+0x28>
   101fc:	000780e7          	jalr	a5
   10200:	00040513          	mv	a0,s0
   10204:	3a4000ef          	jal	ra,105a8 <_exit>
