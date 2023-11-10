.data
salto: .asciiz "\n"
.text

addi $s0, $0, 4 	#s0= 4 f
addi $s1, $0, 1 	#s1 = 1 g
addi $s2, $0, 2 	#s0= 2 h
addi $s3, $0, 3 	#s0= 3 i
addi $s4, $0, 5 	#s0= 5 j

bne $s3, $s4, L1 #if i!=j skip if block
add $s0, $s1, $s2 #if block: f=g+h => 3
L1:
sub $s0, $s0, $s3 #f=f-i => 1

#imprimimos los datos para comprobar
li $v0,1
move $a0,$s0
syscall

li $v0, 4
la $a0,salto
syscall