.data

input: .asciiz "digram_test.java"
dict:	.asciiz "dictionary.txt"
codedProgram:	.asciiz "output.txt"
.align 2
input_buffer:	.space 500	# Necesita un buffer para poder procesar el texto
.align 2
dict_buffer:	.space 420	# To save dictionary.txt data
.align 2
output_buffer:	.space 2
# El output_buffer está enfocado para guardar de a caracter o de a digrama, y se va escribiendo al archivo instantáneamente.
# Por tanto hay que abrir y escribir constantemente.

.text
	
	# Abrir y leer archivo de input
	la $s0, input
	la $s1, input_buffer
	jal openToRead	# Read input(digram_test.java)
	jal closeFile	# Cierra el archivo del input
	# Abre el diccionario y lo lee en el buffer
	la $s0, dict
	la $s1, dict_buffer
	jal openToRead	# Read dictionary
	jal closeFile # Cierra el diccionario.
	
	la $t3, input_buffer	# Direccion inicial del buffer
	jal processCaracter	# Una vez cargado input, procesa en memoria todos los caracteres de entrada.
	
	li $v0, 10	# Termina el programa
	syscall

processCaracter:
	
	# Loop que recorre el texto de a par de caracteres
	# Recorro hasta que encuentre un registro con valor null.     0x00 = null
	
	lb $a0, ($t3)	# Caracter izq. de digrama
	lb $a1, 1($t3)	#Caracter de la derecha del inicial
	beq $a0, 0x00, end_input_file	# Fin de archivo.	Debería procesar el último caracter y salirse de la rutina processCaracter
	jal searchDict	# Busco en el diccionario el digrama correspondiente.
	
	# Escribo en el output el digrama o caracter codificado.
	add $t3, $t3, $v0	# Avanza el equivalente encontrado en el diccionario.
	jal codeIntoOutput
	
	# addi $t3, $t3, 1	# Avanza de a uno en la memoria del buffer.
	
	j processCaracter	# Repite el bucle.
	

end_input_file:	# Fin de programa
	li $v0, 10
	syscall

searchDict:
# Busca el digrama y lo cierra.
	move $t6, $ra	# Guarda la direccion de retorno.
	
	# Busca en el diccionario el digrama o el caracter
	la $t0, dict_buffer	# Dirección inicial del buffer
	la $t5, output_buffer	# Guarda la dirección del buffer de escritura
	la $t8, 95($t0)	# Valor de memoria para iniciar la busqueda en el dict.
	li $t9, 125	# Valor inicial del indice
	# jal searchDigram	# Primero buscamos un digrama
	# $v0 sólo será 2 en el caso de que se haya encontrado un digrama.
	la $t8, ($t0)	# Valor de memoria para iniciar la busqueda en el dict.
	li $t9, 32	# Valor inicial del indice
	bne $v0, 2, searchCharacter	# Si no encuentra digrama busca un caracter en el diccionario.
	
	
	jr $t6	# Retorno.


searchDigram:	#Loop
# Entradas: $a0 y $a1 conforman un digrama de la entrada.

# Returns: 2 si encontré un digrama
# 	   1 si no encontré digrama
# (también se usa para saber de a cuanto avanzar en el input_buffer)
	# Cargo digramas del diccionario en registros.
	move $s6, $ra	# Direccion de retorno
	lb $t1, ($t8)	# Carga dos caracteres contiguos del diccionario.
	lb $t2, 1($t8)
	beq $t2, 0x00, finalizarBusqueda	# Cuando llego al final, realizo una última busqueda para caracter y continuo el programa.
	beq $a0, $t1, comparaSegundoCaracter	# Si hay coincidencias entre los primeros caracteres, se verifica si coinciden los otros.
	beq $v0, 2, finalizarBusqueda
	addi $t9, $t9, 1	# Suma de a uno al índice
	addi $t8, $t8, 2	# jAvanzo en el buffer de lectura del diccionario.
	
	j searchDigram

finalizarBusqueda:
	jr $s6
	# Sale de la busqueda de digramas

comparaSegundoCaracter:
# Si encuentro un digrama, paro la busqueda y escribo en output.
	move $t7, $ra	# Direccion de retorno
	li $v0, 1
	beq $a1, $t2, encuentraDigrama	# Si coincide también el segundo caracter del digrama
	jr $t7
	
encuentraDigrama:
# Returns: $v0: 2 significa que encontró un digrama.
# 	   $v1: código a usar para la codificacion. (En este caso es el index a codificar)
	move $v1, $t9
	sb $v1, output_buffer	# Escribe $t8(indice) en el buffer de salida.
	li $v0, 2	# Esto indica que se encontró un digrama, también se podría usar para decidir cuanto avanzar en el diccionario.
 	jr $ra
 
 
searchCharacter:	# LOOP

	move $s6, $ra
	lb $t1, ($t8)	# Carga un caracter del diccionario.
	li $v0, 1
	beq $a0, $t1, encuentraCaracter
	beq $t1, 0x00, finalizarBusqueda
	
	addi $t8, $t8, 1	# Direccion en el buffer del diccionario
	addi $t9, $t9, 1	# Indice
	j searchCharacter
	#addi $ra, $ra, 4	# para ir a la siguiente instruccion
	#jr $ra

encuentraCaracter:
	move $v1, $t9
	sb $v1, output_buffer
	jr $s6

openToRead:	# Abre archivo para leerlo.
	li $v0, 13	# Abrir archivo
	move $a0, $s0	# Carga la dirección del archivo a leer.
	li $a1, 0	# Read-only mode.
	li $a2, 0
	syscall	# Returns file descriptor
	
	move $a0, $v0	# Mueve a $a0 el descriptor de archivo retornado al abrir archivo
	li $v0, 14	# Lee el archivo abierto.
	move $a1, $s1	# Direccion con el buffer respectivo
	la $a2, 1024
	syscall
	
    	jr $ra
    	

codeIntoOutput:
# Abre archivo
	li $v0, 13
	la $a0, codedProgram
	li $a1, 9	# Write-only.
	# Si el flag = 9. Cuando el archivo ya existe. No lo deja vacío sino que escribe concatenando al final de este.
	li $a2, 0
	syscall
	
	move $a0, $v0	# File descriptor
# Escribe o concatena al archivo
	li $v0, 15
	la $a1, output_buffer
	li $a2, 2
	syscall # $v0 returns number of carachters written
# Cierra el archivo
	li $v0, 16	# closes file
	syscall
	jr $ra	# Returns to caller
	
closeFile:
	# a0 is already setted with file descriptor.
	li $v0, 16
	syscall
	jr $ra

	
	
	
