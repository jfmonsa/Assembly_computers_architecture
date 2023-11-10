.data
mensaje: .asciiz "\nEl logaritmo en base dos de 128 es: "
.text

# $s0 = pow. $sl= x
addi $s0, $0, 1
addi $s1, $0, 0
addi $t0, $0, 128

while:
  #mientras $s0 != $s1 haga
  #beq = branch on equal <-> cuando $s0 == $s1 salte a done
  beq $s0, $t0, done 
  #multiplique $s1*2 sll -> cada dezplazamiento de bits a la izquierda
  #es una multiplicación por dos
  sll $s0, $s0,1
  addi $s1, $s1, 1 
  j while
done:
#imprimir resultados
li $v0,4
la $a0,mensaje
syscall

li $v0,1
move $a0,$s1
syscall
