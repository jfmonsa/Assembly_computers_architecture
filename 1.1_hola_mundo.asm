.data

salto: .asciiz "\n"
mensaje: .asciiz "Hola mundo"
mensaje_2: .asciiz "Impreso en mips"

.text

li $v0,4 	#determina que lo que se va a imprimir es un string
la $a0,mensaje 	#asigna el mensaje a imprimir
syscall 	#imprime
li $v0,4
la $a0,salto
syscall
li $v0,4
la $a0,mensaje_2
syscall
