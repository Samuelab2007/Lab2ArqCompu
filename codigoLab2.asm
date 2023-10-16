.data

dict:	.asciiz "diccionario.txt"
codedProgram:	.asciiz "resultado.txt"
str_buffer:	.space 100	# Necesita un buffer para poder procesar el texto
str_data_end:

.text

	j openToRead

caracter:
	li $v0, 12
	syscall

readCaracter:	# Loop que procesa el texto de a par de caracteres
	lw $t0, caracter	# Caracter del texto
	lw $t1, 4($t0)	#Caracter de la derecha
	# Con estos dos se concatenan para formar un bigrama, si no se encuentra el bigrama en el diccionario
	# se codifica solo el caracter de la izquierda y se avanza a la siguiente direcci�n.
	
	# Branch en el caso de que encuentra el bigrama
	
	# Branch en el caso de que no encuentre el bigrama
	
	# Branch para cuando se termin� de leer el documento.


# La direcci�n del archivo se deber�a cargar como un parametro. Para tener la flexibilidad de leer el archivo java y otras cosas.
openToRead:	# Abre archivo para leerlo. Se deber�an ejecutar una vez en toda la ejecuci�n del programa
	li $v0, 13	# Abrir archivo
	la $a0, dict
	li $a1, 0	# Read-only mode.
	li $a2, 0
	syscall	# Returned file descriptor = 3
	move $t0, $v0
	
	li $v0, 1	# Show on screen file descriptor
	move $a0, $t0
	syscall
	j readFile

readFile:	# Abre archivo para escribir. Se deber�an ejecutar una vez en toda la ejecuci�n del programa
	move $a0, $t0	# Intenta leer el archivo
	li $v0, 14
	la $a1, str_buffer
	la $a2, 100
	syscall
	move $s0, $v0
	
	li $v0, 1	# Print number of read characters.
	move $a0, $s0        
    	syscall
	# Aqu� tambi�n deber�a intentar obtener los datos necesarios para poder ir a procesar los caracteres

openToWrite:
	li $v0, 13
	la $a0, codedProgram
	li $a1, 1	# Write-only. Si ya existe lo deja vac�o para escribir.
	# Si el flag = 9. Cuando el archivo ya existe. No lo deja vac�o sino que escribe concatenando al final de este.
	li $a2, 0
