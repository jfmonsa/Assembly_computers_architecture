#def fib():
#  n=1
#  f1=0
#  f2=1
#  aux=0
#  while n<16:
#    aux=f2
#    f2=f1+f2
#    f1=aux
#    log2c(f2)
#    print(log2c(f2))
#    n=n+1 #se itera


#==== Implementación ====
.data
mensaje_1: .asciiz "\nEl termino (n ="
mensaje_2: .asciiz ") -> es fib(n) = "
salto: .asciiz "\n"
.text


#funcion fib
fib:
    #$s0 -> n (terminos fibonacci) asumiento arranca en n=1
    #[addi $s0 $0 0 => I(op:8(addi) rs:0(0) rt:16(s0) immed:0x00000000)]
    addi $s0,$0,0 

    #Primeros dos terminos de la función fibonacci $s1=0, $s2=0
    #0x20110000 [addi $s1 $0 0  => I(op:8(addi) rs:0(0) rt:17(s1) immed:0x00000000)]
    addi $s1,$0,0 #f1=0 <- $s1
    #0x20120001 [addi $s2 $0 1  => I(op:8(addi) rs:0(0) rt:18(s2) immed:0x00000001)]
    addi $s2,$0,1  #f2=1 <- $s2

    #variable temporal para hacer el cambio de valores en el ciclo $t2=aux
    #0x200a0000 [addi $t2 $0 0  => I(op:8(addi) rs:0(0) rt:10(t2) immed:0x00000000)]
    addi $t2,$0,0

#ir a el ciclo fib(n=1... 16)
#program counter, linea (direccion) donde se guarda la etiqueta while: 
while:
    #cabecera del ciclo
    #La instruccion beq se dividen en dos:
    # 1) addi $1,$0,0x00000008
    # codigo maquina => 0x20010008 [addi $1 $0 0x00000008 => I(op:8(addi) rs:0(0) rt:1(1) immed:0x00000008)]
    # 2) beq $1,$s0,0x00000013
    #0x10300003 [beq $1 $s0 0x00000013 => I(op:4(beq) rs:1(1) rt:16(s0) immed:0x00000003)]
    beq $s0,8 done #7 la ultima iteracion

    #hacer los prints
    #0x24020004 [addiu $2 $0 0x4  => I(op:9(addiu) rs:0(0) rt:2(2) immed:0x00000004)]
        li $v0,4
    #0x3c011001 [lui $1 0x1001  => I(op:15(lui) rs:0(0) rt:1(1) immed:0x00001001)]
    #0x34240000 [ori $4 $1 0x0  => I(op:13(ori) rs:1(1) rt:4(4) immed:0x00000000)]
        la $a0,mensaje_1
        syscall

        #imprimir n
    #0x24020001 [addiu $2 $0 0x1  => I(op:9(addiu) rs:0(0) rt:2(2) immed:0x00000001)]
        li $v0,1
    #0x00102021 [addu $4 $0 $s0  => R(op:0(addu) rs:0(0) rt:16(s0) rd:4(4) sh:0 func:33)]
        move $a0,$s0
        syscall
    #0x24020004 [addiu $2 $0 0x4  => I(op:9(addiu) rs:0(0) rt:2(2) immed:0x00000004)]
        li $v0,4
    #0x3c011001 [lui $1 0x1001  => I(op:15(lui) rs:0(0) rt:1(1) immed:0x00001001)]
    #0x34240000 [ori $4 $1 0x0  => I(op:13(ori) rs:1(1) rt:4(4) immed:0x00000000)]
        la $a0,mensaje_2
        syscall

        #$s2 imprimir termino n de fibonacci
    #0x24020004 [addiu $2 $0 0x4  => I(op:9(addiu) rs:0(0) rt:2(2) immed:0x00000004)]
        li $v0,1
    #0x3c011001 [lui $1 0x1001  => I(op:15(lui) rs:0(0) rt:1(1) immed:0x00001001)]
    #0x34240000 [ori $4 $1 0x0  => I(op:13(ori) rs:1(1) rt:4(4) immed:0x00000000)]
        move $a0,$s1
        syscall


    #actualizar los valores de los ultmos dos terminos de fibonacci tal como el pseudocodigo
    	#0x224a0000 [addi $t2 $s2 0  => I(op:8(addi) rs:18(s2) rt:10(t2) immed:0x00000000)]
        addi $t2,$s2,0 #aux=f2 : se usa la variable auxiliar
        #0x02519020 [add $s2 $s2 $s1  => R(op:0(add) rs:18(s2) rt:17(s1) rd:18(s2) sh:0 func:32)]
        add $s2,$s2,$s1 #f2=f1+f2
        #0x21510000 [addi $s1 $t2 0 => I(op:8(addi) rs:10(t2) rt:17(s1) immed:0x00000000)]
        addi $s1,$t2,0 #t1=aux

    #0x22100001 [addi $s0 $s0 1 => I(op:8(addi) rs:16(s0) rt:16(s0) immed:0x00000001)]
    addi $s0,$s0,1 #n=n+1
    #0x08100004 [j 0x00400010 => JFormat(op:2(j) target:0x00400010 >> 2 = 0x00100004)]
    j while #repetir el ciclo

done:
