#de puede hacer una generalización para realizar la multiplicación en un array de 1000 posiciones, asumiendo como dirección de base a 0x23B8F000, almacenada en $s0. También se almacena el tamaño del arreglo en el registro $t2

#$s0 base adress of array, $s1=i
#initialization code
lui $s0, 0x23BB #$s0=0x0x23BB0000
ori $s0, $s0, 0xF000 #$s0=0x23BBF000
addi $s1,$0,0 #i=0
addi $t2,$0,1000

loop:
  #Cabecera del ciclo
  slt $t0, $s1, $t2 #i<1000
  beq $t0, $0, done
  
  sll $t0, $s1, 2 #$t0=i*4 (byte offset)
  add $t0, $t0, $s0 #adress of array[i]
  lw $t1, 0($t0) #$t1=array[i]
  sll $t1,$t1,3 # $t1=array[i]*8
  sw $t1, 0($t0) # array[i]=array[i]*8
  addi $s1,$s1,1 #i=i+1
  j loop

done: