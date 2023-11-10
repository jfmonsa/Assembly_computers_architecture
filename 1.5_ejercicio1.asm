.data
mensaje1: .asciiz "el resultado de a es: "
mensaje2: .asciiz "el resultado de f es: "
salto: .asciiz "\n"
.text
# s0 = a ; s1 = b ; s2 = c ; s3 = f ; s4 = g ; s5 = h ; s6 = i ; s7 = j 
addi $s1,$0,1
addi $s2,$0,1
addi $s4,$0,1
addi $s5,$0,1
addi $s6,$0,1
addi $s7,$0,1

sub $s0,$s1,$s2 #s0 = a = b - c

add $t0,$s4,$s5 #t0 = g + h
add $t1,$s6,$s7 #t1 = i + j
sub $s3,$t0,$t1 #s3 = t0 - t1 = (g + h) - (i + j)
#imprimir resultados
li $v0,4
la $a0,mensaje1
syscall

li $v0,1
move $a0,$s0
syscall

li $v0, 4
la $a0,salto
syscall 
#---------------------------------------------
li $v0,4
la $a0,mensaje2
syscall

li $v0,1
move $a0,$s3
syscall

li $v0, 4
la $a0,salto
syscall