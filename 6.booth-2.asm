.data
str_init: .asciiz "(*) Los operandos son: "
str_init_m: .asciiz "\n--> Multiplicador, Q = "
str_init_q: .asciiz "\n--> Multiplicando, M = "

str_table_head: .asciiz "\n step |                A                  |                Q                 |  Q-1 "
str_table_sep: .asciiz  "\n------------------------------------------------------------------------------------\n"
str_space: .asciiz "    "
str_salto: .asciiz "\n"

str_result: .asciiz "El resultado es M * Q = "
.text

main:
    #init values
    addi $s1,$0,-100 #Multiplier (Q)
    addi $s2,$0,-2 #Multiplicando (M)
        
    addi $s0,$0,0 #iterador n
	addi $s3,$0,0 #LSB(Q) = Q0
    addi $s4,$0,0 #Bit extra Q-1 
    addi $s5,$0,0 #Acomulator (A)

    #print init values
    li $v0,4
    la $a0,str_init
    syscall

    li $v0,4
    la $a0,str_init_q
    syscall

    li $v0,1
    move $a0,$s1
    syscall

    li $v0,4
    la $a0,str_init_m
    syscall

    li $v0,1
    move $a0,$s2
    syscall

    li $v0,4
    la $a0,str_table_head
    syscall

    li $v0,4
    la $a0,str_table_sep
    syscall


loop:
    #prints
    li $v0,4
    la $a0,str_space
    syscall

    li $v0, 1
	move $a0, $s0
	syscall

    li $v0,4
    la $a0,str_space
    syscall

	li $v0, 35
	move $a0, $s5
	syscall
	
	li $v0,4
    la $a0,str_space
    syscall
        
	li $v0, 35
	move $a0, $s1
	syscall

    li $v0,4
    la $a0,str_space
    syscall
        
	li $v0, 1
	move $a0, $s4
	syscall
        
    li $v0,4
    la $a0,str_space
    syscall
        
    li $v0,4
    la $a0,str_salto
    syscall

    # $s3<-LSB(Q) := Obteniendo el LSB de Q
    andi $s3, $s1,1

    #Branch depending of the LSB
    #if $s3==0 -> if_lsbq_0
	beq  $s3, 0, if_lsbq_0
    #else go to if_lsbq_1 
    j    if_lsbq_1

#condicionales
if_lsbq_0:
    beq $s4,1 case_01
    j case_00 #else shift

case_01:
    #A=A+M
	add $s5,$s5,$s2
    j shift
case_00:
    j shift

if_lsbq_1:
    beq $s4,0 case_10
    j case_11 #else shift

case_10:
    #A=A-M
    sub $s5, $s5,$s2
    j shift
case_11:
    j shift


shift:
    #arithmetic shift right (A,Q,Q-1)
        #actualizar los valores de Q-1, antes del shift
        andi $s4, $s3, 1 # Q-1 = LSB(Q)
        
        #Aplicar mascaras a A y Q para concatenarlos
        #preparar Q
        addi $t0,$0,0x0000FFFF
        and $t0,$t0,$s1
        
        #preparar A
        sll $t1,$s5,16
        
        #Concatenar A y Q en $t2
        add $t2,$t1,$t0

        #Aritmethic Shift Right de A y Q
        sra $t2, $t2, 1
        
    #A y Q nuevamente en ciclos separados
        #obtener A
        add $t3,$t2,$0
        sra $s5,$t2,16
  	
        #obtener Q
        andi $s1, $t3,0x0000FFFF       

    #Si es la ultima iteraccion romper el ciclo
    #y mostrar resultados
    #if n==16-1 stop loop; else: iterate again
        beq $s0, 15, done
    
    #iterar de nuevo
        add $s0,$s0,1# n=n+1
        j loop

done:
    #Resultado guardado en $t2, imprimirlo
    li $v0,4
    la $a0,str_result
    syscall

    li $v0,1
    move $a0,$t2
    syscall

    #terminar la ejecución del programa
    li $v0, 10
    syscall