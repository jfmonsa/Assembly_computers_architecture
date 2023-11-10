.data 
salto: .asciiz "\n"
mensaje_1: .asciiz "el numero a es: "
mensaje_2: .asciiz "el numero b es: "
mensaje_3: .asciiz "el numero c es: "
mensaje_4: .asciiz "el numero d es: "
.text
addi $s2,$0,5 # s2 = b = 5
addi $s3,$0,6 # s3 = c = 6
addi $s4,$0,6 # s4 = d = 6

sub $t1,$s3,$s4 # t1 = c - d
add $s1,$s2,$t1 # s1 = a = b + c - d

#imprime el texto de los numeros a operar
li $v0,4
la $a0,mensaje_2
syscall

li $v0,1
move $a0,$s2
syscall

li $v0, 4
la $a0,salto
syscall
#-----------------------------------------------------
li $v0,4
la $a0,mensaje_3
syscall

li $v0,1
move $a0,$s3
syscall

li $v0, 4
la $a0,salto
syscall
#-------------------------------------------------------
li $v0,4
la $a0,mensaje_4
syscall

li $v0,1
move $a0,$s4
syscall

li $v0, 4
la $a0,salto
syscall
#imprime el resultado de la operacion
li $v0,4
la $a0,mensaje_1
syscall

li $v0,1
move $a0,$s1
syscall

li $v0, 4
la $a0,salto
syscall
#----------------------------------------------------------