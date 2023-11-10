data
salto: .asciiz "\n"
.text
addi $s0, $0, 4 	#s0 = 0 + 4 = 4
addi $s1, $0, 1 	#s1 = 0 + 1 = 1
sll $s1, $s1, 2		#s1 = 1 << 2 = 4
bne $s0, $s1, target 	#s0 != s1, salta al branch indicado, como son iguales no salta
addi $s1, $s1, 1	#s1 = 4 + 1 = 5
sub $s1, $s1, $s0	#s1 = 5 - 4 = 1

target: 
  add $s1, $s1, $s0	#s1 = 1 + 4 = 5
  
#imprimimos los datos para comprobar
li $v0,1
move $a0,$s0
syscall

li $v0, 4
la $a0,salto
syscall
#-------------------------------------------
li $v0,1
move $a0,$s1
syscall

li $v0, 4
la $a0,salto
syscall