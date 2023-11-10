.data
mensaje: .asciiz "\nLa suma de las primeras potencias en base 2 de 1 hasta 100 es: "
.text

#high level code
#int sum = 0;
#int i;
#for (i = 1; i < 101; i = i*2) {
#    sum = sum + i;
#}

# $s0 = i. $sl= sum
add $s1, $0, $0 #sum=0
addi $s0, $0, 1 #i=1
addi $t0, $0, 101

for:
  slt $t1, $s0, $t0 #if i<101 => $t1=1 else $t1=0
  beq $t1,$0 done
  add $s1,$s1,$s0 #sum=sum+i
  sll $s0, $s0, 1 #i=i*2
  j for

done:
  li $v0,4
  la $a0,mensaje
  syscall
  
  li $v0,1
  move $a0,$s1
  syscall
