addiu $1, $0, 0 # f(n-1)
addiu $2, $0, 1 # f(n)
loop:
addu $3, $2, $1
addu $1, $2, $0
addu $2, $3, $0
j loop
