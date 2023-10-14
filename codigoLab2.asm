.data

dict:	.asciiz "diccionario.txt"
str_buffer:	.space 1050	# Necesita un buffer para poder procesar el texto
str_data_end:

.text

	j openFile

caracter:
	li $v0, 12
	syscall

readCode:	# Loop que procesa el texto de a par de caracteres
	lw $t0, caracter	# Caracter del texto
	lw $t1, 4($t0)	#Caracter de la derecha
	# Con estos dos se concatenan para formar un bigrama, si no se encuentra el bigrama en el diccionario
	# se codifica solo el caracter de la izquierda y se avanza a la siguiente dirección.
	
	# Branch en el caso de que encuentra el bigrama
	
	# Branch en el caso de que no encuentre el bigrama
	
	# Branch para cuando se terminó de leer el documento.



openFile:
	li $v0, 13	# Abrir archivo
	la $a0, dict
	li $a1, 0	# Read-only mode.
	li $a2, 0
	syscall	# Returned file descriptor = 3
	
	

readFile:
	move $a0, $v0	# Intenta leer el archivo
	li $v0, 14
	la $a1, str_buffer
	la $a2, str_data_end
	syscall
	# Aquí también debería intentar obtener los datos necesarios para poder ir a procesar los caracteres
	
	#Salto al procesamiento de texto.
