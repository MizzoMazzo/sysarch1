jal func
addiu $6, $0, 456
loop:
j loop

func:
addiu $5, $0, 123
jr $ra