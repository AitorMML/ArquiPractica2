.text
#	lui $s0, 0x0000101
#	ori $s1, $s0, 0x24
#	addi $s2, $zero, 1
#	addi $s3, $zero, 32
#	sll $t0, $s2, 4
#	srl $t1, $s3, 4
#	sub $t2, $t0, $t1
#	addi $t0, $zero, 4
#	andi $t1, $t0, 0x0f
	ori $t1, $zero, 4 #4

#	addi $t0, $zero, 8
#	beq $t0, 8, success
	#not success
#	sub $t0, $t0, 8 
	
#success:
#	add $t1, $t0, $t0
