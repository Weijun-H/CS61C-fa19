.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# =================================================================
argmax:
    li t0, 0
    li t4, 1
    ble t4, a1, no_exception
    li a1, 32
    j exit2

no_exception:
    lw t1, 0(a0) # t1 = a[0]
    li t3, 0 # t2 = index of the largest

loop_start:
    lw t2, 0(a0) # t2 = a[i]
    bge t1, t2, loop_continue # if temp > a[i] continue 
    add t1, t2, x0
    add t3, x0, t0

loop_continue:
    addi a0, a0, 4
    addi t0, t0, 1
    bge	t0, a1, loop_end # if t0 > the number of the array
    j loop_start

loop_end:
    add a0, t3, x0
    ret    
