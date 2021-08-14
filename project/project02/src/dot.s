.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 33
# =======================================================
dot:
    li t0, 0
    li t4, 1
    add t5, a4, x0

    blt a2, t4, length_error
    blt a3, t4, stride_error
    blt a4, t4, stride_error

    slli a3, a3, 2
    slli a4, a4, 2


    li t1, 0 # t1 = temp 

loop_start:

    li t2, 0 # t2 is the multiple result
    lw t3, 0(a0) # t3 = a0[i]
    lw t5, 0(a1) # t5 = a1[i]
    mul t2, t3, t5
    add t1, t1, t2

loop_continue:
    add a0, a0, a3
    add a1, a1, a4
    addi t0, t0, 1
    bge	t0, a2, loop_end # if t0 > the number of the array
    j loop_start

loop_end:
    add a0, t1, x0
    ret

length_error:
    li a1, 32
    j exit2

stride_error:
    li a1, 33
    j exit2
