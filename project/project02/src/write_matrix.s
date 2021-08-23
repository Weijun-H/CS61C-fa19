.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 64
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 67
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 65
# ==============================================================================
write_matrix:

    # Prologue

    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # Open a file
    mv a1, s0
    li a2, 1
    jal fopen
    li t1, -1
    beq a0, t1, open_error # If fail to a file
    mv s0, a0   # Now s0 = descriptor

    # assign the memory for the row ans column
    li a0, 8
    jal malloc
    beq a0, x0, malloc_error
    mv s4, a0   # s3 = the address of the row and column

    # Start to write the row and column 
    mv a1, s0
    mv a2, s4
    li a3, 2
    li a4, 4
    jal fwrite
    li t1, 2
    bne a0, t1, write_error


    mul s5, s2, s3
    li t0, 0    # t0 = the number of wrritten elements
loop_start:
    # Start to write the matrix
    mv a1, s0
    sub a3, s5, t0

    mv a2, s1
    li t1, 4
    mul t1, t1, t0
    add a2, a2, t1

    li a4, 4

    addi sp, sp, -4
    sw t0, 0(sp)

    jal fwrite

    lw t0, 0(sp)
    addi sp, sp, 4

    add t0, t0, a0

    bne t0, s5, loop_start
    
loop_end:
    mv a1, s0
    jal fclose
    li t1, -1
    beq a0, t1, close_error

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    
    ret

malloc_error:
    li a1, 48
    j exit2

open_error:
    li a1, 64
    j exit2

write_error:
    li a1, 67
    j exit2

close_error:
    li a1, 65
    j exit2

