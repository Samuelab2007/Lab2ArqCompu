.data

input: .asciiz "digram_test.java"
output: .asciiz "output.txt"
dict:	.asciiz "dictionary.txt"
codedProgram:	.asciiz "output.txt"
.align 2
input_buffer:	.space 1024	# Necesita un buffer para poder procesar el texto
.align 2
dict_buffer:	.space 1024	# To save dictionary.txt data
output_buffer:	.space 1024


.text
	la $s0, input
	la $s1, input_buffer
	jal openToRead	# Read input(digram_test.java)
	move $a3, $a0
	# openToRead loads file data onto the Memory
	
	
	# FIX: Los buffer se sobreescriben entre ellos en la memoria de programa

	 la $s0, dict
	 la $s1, dict_buffer
	 jal openToRead	# Read dictionary

	 jal closeFile	# Close dictionary
	 move $a0, $a3	# Close input
	 jal closeFile
	
	la $t3, input_buffer	# Address of buffer

	# Idea, usamos un registro para tener en cuenta el offset del registro $t4 a medida que vamos procesando el buffer.
	# Este registro sería a modo de contador

	jal processCaracter	# Una vez cargado input y dict en la memoria. Se procede a procesar usando ambos buffers.

processCaracter:

	# Loop que procesa el texto de a par de caracteres
	
	lb $t4, ($t3)	# Caracter izq. de digrama
	lb $t5, 1($t3)	#Caracter de la derecha del inicial
	
	
	
	# Con estos dos se concatenan para formar un digrama, si no se encuentra el digrama en el diccionario
	# se codifica solo el caracter de la izquierda y se avanza a la siguiente dirección.
	
	# Branch en el caso de que encuentra el bigrama
	
	# Branch en el caso de que no encuentre el bigrama
	
	# Branch para cuando se terminó de leer el documento.

searchDict:
	# LOOP PARA BUSCAR EL DIGRAMA EN EL DICCIONARIO.



# La dirección del archivo se debería cargar como un parametro. Para tener la flexibilidad de leer el archivo java y otras cosas.
openToRead:	# Abre archivo para leerlo. Se deberían ejecutar una vez en toda la ejecución del programa
	li $v0, 13	# Abrir archivo
	move $a0, $s0	# TODO: Reemplazar por registro con la dirección del archivo a usar
	li $a1, 0	# Read-only mode.
	li $a2, 0
	syscall	# Returns file descriptor
	
	move $a0, $v0	# Mueve a $a0 el descriptor de archivo retornado al abrir archivo
	li $v0, 14	# Lee el archivo abierto.
	move $a1, $s1	# Direccion con el buffer respectivo
	la $a2, 1024
	syscall
	
    	jr $ra
    	
    	# Aquí también debería intentar obtener los datos necesarios para poder ir a procesar los caracteres

openToWrite:
	li $v0, 13
	la $a0, codedProgram
	li $a1, 9	# Write-only. Si ya existe lo deja vacío para escribir.
	# Si el flag = 9. Cuando el archivo ya existe. No lo deja vacío sino que escribe concatenando al final de este.
	li $a2, 0
	syscall
	
closeFile:
	# a0 is already setted with file descriptor.
	li $v0, 16
	syscall
	jr $ra
	

writeFile:
	move $a0, $t0	# File descriptor
	li $v0, 15
	la $a1, output_buffer
	li $a2, 2
	syscall # $v0 returns number of carachters written
	
	
