.data
salto: .asciiz "\n"
.text
addi $s0, $0, 15 #amount = s0
addi $s1, $0, 0 #fee = s1 

case20:
	addi, $t0, $0, 20 #t0 = 20
	bne $s0,$t0, case50 # amount == 20 ? if not, skip to case50
    addi $s1,$0,2 # if so, fee=2
    j done #and break out the case
case50:
	addi, $t0, $0, 20 #t0 = 50
	bne $s0,$t0, case100 # amount == 20 ? if not, skip to case100
    addi $s1,$0,3 # if so, fee=3
    j done
case100:
	addi, $t0, $0, 20 #t0 = 100
	bne $s0,$t0, default # amount == 20 ? if not, skip to default
    addi $s1,$0,5 # if so, fee=3
    j done
default:
    addi $s1,$0,0 # if so, fee=0
    j done
done:
  li $v0,1
  move $a0,$s1
  syscall
  
  li $v0, 4
  la $a0,salto
  syscall
