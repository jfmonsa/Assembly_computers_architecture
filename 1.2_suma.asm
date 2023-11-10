.data 
salto: .asciiz "\n"
mensaje_1: .asciiz "el numero a es: "
mensaje_2: .asciiz "el numero b es: "
mensaje_3: .asciiz "el numero c es: "
.text
addi $s2,$0,5
addi $s3,$0,6

add $s1,$s2,$s3

li $v0,4
la $a0,mensaje_2
syscall

li $v0,1
move $a0,$s2
syscall

li $v0, 4
la $a0,salto
syscall

li $v0,4
la $a0,mensaje_3
syscall

li $v0,1
move $a0,$s3
syscall

li $v0, 4
la $a0,salto
syscall

li $v0,4
la $a0,mensaje_1
syscall

li $v0,1
move $a0,$s1
syscall

li $v0, 4
la $a0,salto
syscall

