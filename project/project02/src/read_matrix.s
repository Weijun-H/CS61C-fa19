.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 48
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 64
# - If you receive an fread error or eof,
#   this function terminates the program with error code 66
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 65
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Open a file
    mv a1, s0
    li a2, 0
    jal fopen

    li t1, -1
    beq a0, t1, open_error # If fail to open a file 
    mv s0, a0   # Now s0 = descriptor

    mv a1, s0
    mv a2, s1
    li a3, 4
    jal fread
    

    mv a1, s0
    mv a2, s2
    li a3, 4
    jal fread 

    # Get the number of elements
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul a3, t1, t2  # a3 = 2 + m * n
    mv s3, a3   # s3 = the number of elements

    # Malloc spaces
    li t1, 4
    mul a0, a3, t1  # Now a0 = the byte of the all elements
    jal malloc

    beq a0, x0, malloc_error # If fail to malloc 
    mv s4, a0   # s4 = the pointer to the buffer

    li t1, 4
    mul a3, s3, t1
    mv s3, a3
    li t0, 0
loop_start:
    # Read the file
    mv a1, s0
    mv a2, s4
    add a2, a2, t0

    addi sp, sp, -4
    sw t0, 0(sp)

    jal fread

    lw t0, 0(sp)
    addi sp, sp, 4

    li t1, -1
    beq a0, t1, read_error # If fail to read
ebreak
    add t0, t0, a0
    blt t0, s3, loop_start
loop_end:
    # Close the file
    mv a1, s0
    jal fclose
    li t1, -1
    beq a0, t1, close_error

    mv a0, s4

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    # addi a0, a0, 8
    ret

malloc_error:
    li a1, 48
    j exit2

open_error:
    li a1, 64
    j exit2

read_error:
    li a1, 66
    j exit2

close_error:
    li a1, 65
    j exit2

