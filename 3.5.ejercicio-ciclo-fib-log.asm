#==== idea ==== -> 
#def log2c(n:int)->int:
#  m:int=0
#  p:int=1
#  while p<n:
#    m=m+1
#    p=p*2
#  return m

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
mensaje_1: .asciiz "\nPara n = "
mensaje_2: .asciiz " => fib(n) = "
mensaje_1_1: .asciiz " => entonces  log2_c(fib(n)) es igual a: "
.text

#funcion fib
fib:
    #$s0 -> n (terminos fibonacci) asumiento arranca en n=1
    addi $s0,$0,0

    #Primeros dos terminos de la función fibonacci $s1=0, $s2=0
    addi $s1,$0,0 #f1=0 <- $s1
    addi $s2,$0,1  #f2=1 <- $s2

    #limite del ciclo $t0=16
    addi $t0,$0,15

    #variable temporal para hacer el cambio de valores en el ciclo $t2=aux
    addi $t2,$0,0

    j while #ir a el ciclo fib(n=1... 16)

while:
    #cabecera del ciclo
    slt $t1,$s0,$t0 #if i<17 -> $t1=1 else $t0=0
    beq $t1,$0 done #if $t1=0 -> done (rompe el ciclo)

    #invocar a log2_C
    jal log2_c #pasarle como parametro f1 <- $s1

    #actualizar los valores de los ultmos dos terminos de fibonacci tal como el pseudocodigo
    addi $t2,$s2,0 #aux=f2 : se usa la variable auxiliar
    add $s2,$s2,$s1 #f2=f1+f2
    addi $s1,$t2,0 #t1=aux


    add $s0,$s0,1 #n=n+1
    j while #repetir el ciclo


#funcion log2_c
log2_c:
    #valores iniciales
    addi $s3,$0,0 #m=0 <-> m<-$s3
    addi $s4,$0,1 #p=1 <-> p<-$s4

    j log2_c_while #revisar el cliclo anidado

log2_c_while:
    #cabecera del ciclo
    slt $t3, $s4, $s1 #p<n <-> if $s4 < $s1 then $t3=1 else $t3=0
    beq $t3, $0, log2c_done

    add $s3,$s3,1 #m=m+1 <-> $s3=$s3+1
    sll $s4,$s4,1 #p=p*2 <-> $s4=$s4*2
    j log2_c_while

log2c_done:
    #imprimir el termino de la sucesion log2_c(fib($s2))

    #imprimir mensaje_1, $s1, mensaje_1_1, $s3 y salto
    #mensaje_1
    li $v0,4
    la $a0,mensaje_1
    syscall
    
    #$s2 imprimir termino n de fibonacci
    li $v0,1
    move $a0,$s0
    syscall

    li $v0,4
    la $a0,mensaje_2
    syscall

    li $v0,1
    move $a0,$s1
    syscall

    #mensaje_1_1
    li $v0,4
    la $a0,mensaje_1_1
    syscall

    #$s3 imprimir el termino n evaluando en log2_c(n)
    li $v0,1
    move $a0,$s3
    syscall

    jr $ra #terminar de ejecutar la funcion

#Terminar la ejecucion del programa
done:
    li $v0, 10
    syscall
