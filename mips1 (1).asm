.data
input_file: .asciiz "input.txt"
output_file: .asciiz "output.txt"
msg1:	.asciiz "Escriba una cadena de caracteres: "
Enter:	.byte 0x0d, 0x0a, 0x0d, 0x0a, 0x00
input_string:	.space 100
file_buffer:	.space 1024
.text
	#li $v0, 4
	#la $a0, msg1
	#syscall
	
#	li $v0, 8
#	la $a0, input_string
#	li $a1, 100
#	syscall
	
	li $v0, 13
	la $a0, input_file
	li $a1, 0
	syscall
	move $s0, $v0
	
	li $v0, 14
	move $a0, $s0
	la $a1, file_buffer
	li $a2, 1024
	syscall
	move $s2, $v0
	
	li $v0, 13
	la $a0, output_file
	li $a1, 9
	syscall
	move $s1, $v0
	
	li $v0, 15
	move $a0, $s1
	la $a1, file_buffer
	move $a2, $s2
	syscall
	
	li $v0, 16
	move $a0, $s0
	syscall
	
	li $v0, 16
	move $a0, $s1
	syscall
		
	li $v0, 10
	syscall
