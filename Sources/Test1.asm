.text
#	lui $s0, 0x0000101
#	ori $s1, $s0, 0x24
#	addi $s2, $zero, 1
#	addi $s3, $zero, 32
#	sll $t0, $s2, 4
#	srl $t1, $s3, 4
#	sub $t2, $t0, $t1
	addi $t0, $zero, 4
	andi $t1, $t0, 0x0f
	
