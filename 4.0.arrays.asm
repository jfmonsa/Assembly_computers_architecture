#$s0 base adress of array
lui $s0, 0x1000 #$s0=0x10000000
ori $s0, $s0, 0x7000 #$s0=0x10007000

#para array[0]
lw $t1, 0($s0) #$t1=array[0]
sll $t1, $t1, 3 #$t1=$t1<<3 = $t1*2^3
sw $t1, 0($s0) #array[0]=$t1

#para array[1]
lw $t1, 4($s0) #$t1=array[1]
sll $t1, $t1, 3 #$t1=$t1<<3 = $t1*2^3
sw $t1, 4($s0) #array[1]=$t1

#si queremos hacer esto más dinamico debemos usar "ciclos" (saltos)