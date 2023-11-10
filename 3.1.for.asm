.data
mensaje: .asciiz "\nLa suma de los primeros 10 numeros (1+2+3+4+5+6+7+8+9) es: "
.text


# $s0 = i. $sl= sum
add $s0, $0, $0 #sum=0
addi $s1, $0, 0 #i=0
addi $t0, $0, 10

for:
  beq $s0, $t0, done #if i==10 branch to done
  add $s1,$s1,$s0 #sum=sum+i
  addi $s0,$s0,1 #increment i
  j for
done:
  li $v0,4
  la $a0,mensaje
  syscall
  
  li $v0,1
  move $a0,$s1
  syscall