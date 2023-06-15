addi    t0,x0,5                 #5→t0
lui       t1,0x800              #800 000h→t1
L1:
lw        t2,0(t1)                #Mem32[t1+0]→t2
addi     t2,t2,100             #t2+100→t2
sw       t2,0(t1)                #t2→Mem32[t1+0]
addi    t1,t1,4                  #t1+4→t1
addi    t0,t0,-1                #t0-1→t0
bne     t0,x0,L1               #if (t0≠0) goto L1
exit: