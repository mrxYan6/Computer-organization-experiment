.text


BHtest:	
        # test lh
        addi		    x31,x0,16				#x31=16
        lh		    x26,0(x31)  			#x26=DMem16[16]
        lh		    x27,4(x31)  			#x27=DMem16[20]
        sh		    x27,0(x31)				#DMem16[16]=x27
        sh		    x26,4(x31)				#DMem16[20]=x26
        lh		    x26,0(x31) 		        	#x26=DMem16[16]
        lh		    x27,4(x31)  			#x27=DMem16[20]
        add		    x28,x26,x27		    	        #x28=x26+x27
        sh		    x28,16(x0)				#DMem16[16]=x28
        lh                  x29,16(x0)				#x29=DMem16[16]

        #  test lb
        addi		    x31,x0,8				#x31=8
        lb		    x26,0(x31)  			#x26=DMem[8]
        lb		    x27,4(x31)  			#x27=DMem[12]
        sb		    x27,0(x31)				#DMem[8]=x27
        sb		    x26,4(x31)				#DMem[12]=x26
        lb		    x26,0(x31) 		    	        #x26=DMem[8]
        lb		    x27,4(x31)  			#x27=DMem[12]
        add		    x28,x26,x27		    	        #x28=x26+x27
        sb		    x28,16(x0)				#DMem[8]=x28
        lb	    	    x29,16(x0)				#x29=DMem[8]

        # test lhu
        addi		    x31,x0,16				#x31=16
        lhu		    x26,0(x31)  			#x26=DMem16[16]
        lhu		    x27,4(x31)  			#x27=DMem16[20]
        sh		    x27,0(x31)				#DMem16[16]=x27
        sh		    x26,4(x31)				#DMem16[20]=x26
        lhu		    x26,0(x31) 		    	        #x26=DMem16[16]
        lhu		    x27,4(x31)  			#x27=DMem16[20]
        add		    x28,x26,x27		    	        #x28=x26+x27
        sh		    x28,16(x0)				#DMem16[16]=x28
        lhu                  x29,16(x0)				#x29=DMem16[16]

        #test lbu
        addi		    x31,x0,8				#x31=8
        lbu		    x26,0(x31)  			#x26=DMem[8]
        lbu		    x27,4(x31)  			#x27=DMem[12]
        sb		    x27,0(x31)				#DMem[8]=x27
        sb		    x26,4(x31)				#DMem[12]=x26
        lbu		    x26,0(x31) 		    	        #x26=DMem[8]
        lbu		    x27,4(x31)  			#x27=DMem[12]
        add		    x28,x26,x27		    	        #x28=x26+x27
        sb		    x28,16(x0)				#DMem[8]=x28
        lbu	    	    x29,16(x0)				#x29=DMem[8]
        
Itest:
        lui	    	x13,0x80000	    		        #x13=0x8000_0000
        addi		x14,x13,-1				#x14=0x7FFF_FFFF
        addi            x2,x0,0                                 #x2=0

Jtest:
        addi            x1,x1,-1                        #x1 = x1 - 1
        beq             x2,x0,exit                      #stop test
        blt             x14,x13,nxt1                    #if 0x7FFF_FFFF < 0x8000_0000 jump to nxt1 (false)
        blt             x13,x14,nxt1                    #if 0x8000_0000 < 0x7FFF_FFFF jump to nxt1 (true)
        addi            x1,x0,0                         # do nothing
        addi            x1,x0,0                         # do nothing

nxt1:   
        bge             x13,x14,nxt2                    #if 0x8000_0000 >= 0x7FFF_FFFF jump to nxt2(falase)
        bge             x13,x13,nxt2                    #if 0x8000_0000 = 0x8000_0000 jump to nxt2(true)


        addi            x1,x0,0                         # do nothing
        addi            x1,x0,0                         # do nothing
nxt2:   
        bltu            x13,x14, nxt3                   #if U(0x8000_0000)  < U(0x7FFF_FFFF) jump to nxt3(flase)
        bltu            x14,x13, nxt3                   #if U(0x7FFF_FFFF)  < U(0x8000_0000) jump to nxt3(true)

        addi            x1,x0,0                         # do nothing
        addi            x1,x0,0                         # do nothing
nxt3:   
        bgeu            x14,x13, nxt4                   #if U(0x7FFF_FFFF) >= U(0x8000_0000) jump to nxt4(false)
        bgeu            x13,x13, nxt4                   #if U(0x8000_0000) == U(0x8000_0000) jump to nxt4(true)

        addi            x1,x0,0                         # do nothing
        addi            x1,x0,0                         # do nothing
nxt4:
        bne             x0,x1,Jtest                     #if x1 != 0, jump Jtest

exit:
        addi            x1,x0,0                         #x1 = 0
        auipc           x1,0x23000                      #x1 = 0x23000 + PC 
        addi            x1,x0,0                         #x1 = 0
