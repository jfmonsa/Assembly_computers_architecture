# Realice un código que permita obtener la multiplicación de dos números con signo A y B de
# 16 bits en el lenguaje ensamblador para la arquitectura MIPS

# DESCRIPCION DE LOS REGISTROS
# -----------------------------------------------------------------------------
# $s0 =  loop counter  -
# $s1 = Q (multiplier)  - 
# $s2 = M (multiplicand) -
# $s3 = Q0 --> LSB(Q) := Bit Menos Signficativo del multiplicador (Q)
# $s4 = Q-1 -> Bit extra que guarda el valor del LSB(Q) de la iteracion anterior
# $s5 = A -> (Acomulador) Guarda los valores de la operación para los casos 01 y 10
# -----------------------------------------------------------------------------

# (especial case)
# $s3 = V --> holds the overflow from U, when right-shift <-> ¿Esto es necesario?
# 1) Algorithm will work better, if the number who has 'less bit transitions' is 
#    initialized to Q (as multiplier).
# 2) Overflow case, when multiplicand is the largest negative integer, is taken
#    into consideration in the implementation.

.data
#valores iniciales
str_init_values: .asciiz "Los valores iniciales son:"
str_Q: .asciiz "\n\t Multiplicador: Q = "
str_M: .asciiz "\n\t Multiplicando: M = "

#Cabecera de la tabla
str_table_head_sep: .asciiz "________________________________________________________________________\n"
str_table_head: .asciiz "| n |        A         |        Q        |  Q-1  |   Operation descp   |\n"
str_lb:			.asciiz "\n"
str_space: .asciiz "    "

#operations descp
str_case_00_descp:		.asciiz "(00) no op & shift"
str_case_01_descp:		.asciiz "(01) A=A+M & shift"
str_case_10_descp:		.asciiz "(10) A=A-M & shift"
str_case_11_descp:		.asciiz "(11) no op & shift"

str_print_result:		.asciiz "\n\nResult -> [concat(U, V) of Step=16]: "
.text

#initialize values
main:
	#=================== Init values and init prints =======================
	addi $s0, $0, 0 #iterador del ciclo (Step n) $s0

    #Ingresar numeros en base 10, el lenguaje se encarga de convertirlos y operarlos
    #multiplier (Q) and multiplicand (M)
    addi $s1, $0, 3 # Q<-$s1
	addi $s2, $0, 3 # M<-$s2
    #Nota: Para los valores iniciales
    #Hacer un testeo dinamico iterando dos arrays con valores para multiplicar
    #cumpliendo así el requerimiento de la clase

	addi $s3, $0, 0 #Q0<-$s3 (LSB(Q))
	addi $s4, $0, 0 #Q-1<-s4
	addi $s5, $0, 0 #A<-s5
	#addi $s6, $0, 0 #especial case

	#codigo modificado
	andi $s1, $s1, 0xFFFF #Saca los primeros 16 bits de AQ
	addi $s4,$s0,0 #Q-1=0
	sll $s2,$s2,16 #desplaza M a la izquierda

	#============ init prints
	#print init text <- str_init_values 
    li $v0,4
    la $a0,str_init_values
    syscall	

    #print "Q" <- str_Q 
    li $v0,4
    la $a0,str_Q
    syscall

	#print Q <- $s1
	li $v0,1
    move $a0,$s1
    syscall

	#print "M" <- str_M
	li $v0,4
    la $a0,str_M
    syscall

	#print M <- $s2
	li $v0,1
    move $a0,$s2
    syscall

	#print \n <- str_lb
	li $v0,4
    la $a0,str_lb
    syscall

	#print table separator <- str_table_head_sep
	li $v0,4
	la $a0,str_table_head_sep
    syscall

	#print table header <- str_table_head
	li $v0,4
	la $a0,str_table_head
    syscall

	#print table separator <- str_table_head_sep
	li $v0,4
	la $a0,str_table_head_sep
    syscall
	#============ init prints
	#=================== Init values and init prints =======================

print_step:
	#if is the last iteration go to done
	beq  $s0, 17, done

    #print n
    li $v0,1
    move $a0,$s0
    syscall

	li $v0,4
	la $a0,str_space
    syscall
	
    #print A
    li $v0,1
    move $a0,$s5
    syscall

	li $v0,4
	la $a0,str_space
    syscall

    #print Q
    li $v0,1
    move $a0,$s1
    syscall

	li $v0,4
	la $a0,str_space
    syscall

    #print Q-1
    li $v0,1
    move $a0,$s4
    syscall

	li $v0,4
	la $a0,str_space
    syscall

	#comparar LSB(Q) y Q-1
	#---------------------------------------------------------

	andi $s3, $s1, 1		# $s7<-LSB(Q) := Obteniendo el LSB de Q
	beq  $t0, $0, x_lsb_0	# if ($s7 == 0) then goto lsb_q_0
	j    x_lsb_1			# if ($s7 == 1) then goto lsb_q_1

#Casos
x_lsb_0: 				# when the LSB of Q = 0
	beq  $s4, $0, case_00	# if (Q-1 == 0) then goto case_00
	j    case_01			# if (Q-1 == 1) then goto case_01

x_lsb_1:				# when the LSB of X = 1
	beq  $s4, $0, case_10	# if (Q-1 == 0) then goto case_10
	j    case_11			# if (Q-1 == 1) then goto case_11

case_00:
	# print info operation
	li $v0,4
    la $a0,str_case_00_descp
    syscall

	#andi $t0, $s3, 1		# LSB of U for overflow checking
	#bne  $t0, $zero, V		# if LSB of U not zero, goto V, i.e. U overflows
	#srl  $s4, $s4, 1		# shift right logical V by 1-bit
	j    shift			# goto shift other variables

case_01:
	# print info operation
	li $v0,4
    la $a0,str_case_01_descp
    syscall

	add  $s5, $s5, $s2		# A = A+M <-> $s5 = $s5+$s2
	andi $s4, $s4, 0		# Q0=0, so next time Q-1=0

	# check for special case -is multiplier the largest negative number?
	#beq  $s2, -2147483648, do_special_add
	#andi $t0, $s3, 1		# LSB of A for overflow checking
	#bne  $t0, $zero, V		# if LSB of A not zero, goto V, i.e. U overflows
	#srl  $s4, $s4, 1		# shift right logical A by 1-bit
	j    shift			# goto shift other variables

case_10:
	# print info operation
	li $v0,4
    la $a0,str_case_10_descp
    syscall

	sub  $s5, $s5, $s2		#  A = A-M <-> $s5 = $s5-$s2
	ori  $s4, $s4, 1		# Q0=1, so next time Q-1=1

	# check for special case -is multiplier the largest negative number?
	#beq  $s2, -2147483648, do_special_sub
	#andi $t0, $s3, 1		# LSB of U for overflow checking
	#bne  $t0, $zero, V		# if LSB of U not zero, goto V, i.e. U overflows
	#srl  $s4, $s4, 1		# shift right logical V by 1-bit
	j    shift			# goto shift other variables

case_11:
	# print info about action
	li $v0,4
    la $a0,str_case_11_descp
    syscall

	#andi $t0, $s3, 1		# LSB of U for overflow checking
	#bne  $t0, $zero, V		# if LSB of U not zero, goto update
	#srl  $s4, $s4, 1		# shift right logical V by 1-bit
	j    shift 			# goto shift other variables


shift:
	#print line break y termino de imprimir la interacion
	li $v0,4
    la $a0,str_lb
    syscall

	sra  $s5, $s5, 1		# shift right arithmetic A by 1-bit
	ror  $s1, $s1, 1		# rotate right Q by 1-bit
	addi $s0, $s0, 1		# decrement loop counter
	beq  $s0, 16, save		# if it is last step, save the contents of the regs for result                 
	j    print_step			# iterar

save:
	#si es la última iteración
	
	add  $t1, $0, $s3		# save A in $t1
	add $t2, $0, $s1
	#add  $t2, $zero, $s4		# save V in $t2
	j    print_step			# loop again	

done:
	## Call U
	#lw   $v0, sys_print_binary
	#add  $a0, $zero, $t1
	#syscall
	## Call V
	#lw   $v0, sys_print_binary
	#add  $a0, $zero, $t2
	#syscall
	li $v0,4
    la $a0,str_print_result
    syscall

	li $v0,1
    move $a0,$s3
    syscall

	#imprimir resultados (cancatenar A y Q) ori ?
    li $v0,1
    move $a0,$s1
    syscall

	## Terminar ejecucion
	li $v0, 10
    syscall


#caso especial revisar
#V:
#	andi $t0, $s4, 0x80000000	# What is the MSB of V?
#	bne  $t0, $zero, v_msb_1	# If MSB == 1, goto v_msb_1
#	srl  $s4, $s4, 1		# MSB == 0, so first shift right logical V by 1-bit
#	ori  $s4, $s4, 0x80000000	# then make MSB of V = 1
#	j    shift			# goto shift other variables
#
#v_msb_1:
#	srl  $s4, $s4, 1		# shift right logical V by 1-bit
#	ori  $s4, $s4, 0x80000000	# MSB 0f V = 1
#	j    shift			# goto shift other variables
#


#	special case -multiplicand is the largest negative integer
#	----------------------------------------------------------	
#do_special_sub:				# to ignore overflow on U by adding variable N as MSB of U
#	subu $s3, $s3, $s2		# sub Y from U
#	andi $s6, $s6, 0		# set N=0
#	ori  $s5, $s5, 1		# X=1, so next time X-1=1
#	andi $t0, $s3, 1		# LSB of U for overflow checking
#	bne  $t0, $zero, V		# if LSB of U not zero, goto V, i.e. U overflows
#	srl  $s4, $s4, 1		# shift right logical V by 1-bit
#	j    shift_special		# goto shift_special, we gotta check N for updating U
#
#do_special_add:				# to ignore overflow on U by adding variable N as MSB of U
#	addu $s3, $s3, $s2		# add Y to U
#	ori  $s6, $s6, 1		# set N=1
#	andi $s5, $s5, 0		# X=0, so next time X-1=0
#	andi $t0, $s3, 1		# LSB of U for overflow checking
#	bne  $t0, $zero, V		# if LSB of U not zero, goto V, i.e. U overflows
#	srl  $s4, $s4, 1		# shift right logical V by 1-bit
#	j    shift_special		# goto shift_special, we gotta check N for updating U
#	
#	
#shift_special:
#	beq  $s6, $zero, n_0	# if (N==0) then goto n_0
#	sra  $s3, $s3, 1		# shift right arithmetic U by 1-bit
#	ror  $s1, $s1, 1		# rotate right X by 1-bit
#	addi $s0, $s0, 1		# decrement loop counter
#	beq  $s0, 32, save		# if it is last step, save the contents of the regs for result
#	j    print_step			# loop again
#
#n_0:
#	srl  $s3, $s3, 1		# shift right logic U by 1-bit, because N=0
#	ror  $s1, $s1, 1		# rotate right X by 1-bit
#	addi $s0, $s0, 1		# decrement loop counter
#	beq  $s0, 32, save		# if it is last step, save the contents of the regs for result
#	j    print_step			# loop again
#	--------------------------------------------
