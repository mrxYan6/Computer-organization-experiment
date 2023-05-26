main:
	addi		x31,x0,16				#x31=16
	lw		x26,0(x31) 			#x26=DMem[16]
	lw		x27,4(x31) 			#x27=DMem[20]
	sw		x27,0(x31)				# DMem[16]=x27
	sw		x26,4(x31)				# DMem[20]=x26
	lw		x26,0(x31) 			#x26=DMem[16]
	lw		x27,4(x31) 			#x27=DMem[20]
	add		x28,x26,x27			#x28= x26+ x27
	sw		x28,16(x0)				# DMem[16]=x28
	lw		x29,16(x0)				#x29=DMem[16]
	addi		x1,x0,-0x78A			#x1=0xFFFF_F876
	addi		x2,x0,4					#x2=0x0000_0004
	add		x3,x1,x2				#x3=0xFFFF_F87A
	sub		x4,x1,x2				#x4=0xFFFF_F872
	sll		x5,x1,x2				#x5=0xFFFF_8760
	srl		x6,x1,x2				#x6=0x0FFF_FF87
	sra		x7,x1,x2				#x7=0xFFFF_FF87
	slt		x8,x1,x2				#x8=0x0000_0001
	sltu		x9,x1,x2				#x9=0x0000_0000
	and		x10,x5,x6				#x10=0x0FFF_8700
	or		x11,x5,x6				#x11=0xFFFF_FFE7
	xor		x12,x5,x6				#x12=0xF000_78E7
	lui		x13,0x80000			#x13=0x8000_0000
	addi		x14,x13,-1				#x14=0x7FFF_FFFF
	addi		x15,x14,0x123			#x15=0x8000_0122
	slli		x16,x15,3				#x16=0x0000_0910
	srli		x17,x15,3				#x17=0x1000_0024
	srai		x18,x15,3				#x18=0xF000_0024
	slti		x19,x18,-1				#x19=0x0000_0001
	sltiu		x20,x18,-1				#x20=0x0000_0001
	slti		x21,x18,1				#x21=0x0000_0001
	sltiu		x22,x18,1				#x22=0x0000_0000
	andi		x23,x12,0xFF			#x23=0x0000_00E7
	ori		x23,x12,0xFF			#x23=0xF000_78FF
	lui		x24,0x00010			#x24=0x0001_0000
	addi		x24,x24,-1				#x24=0x0000_FFFF
	xori		x25,x24,-1				#x25=0xFFFF_0000
