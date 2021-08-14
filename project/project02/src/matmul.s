.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 34
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 34
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 34
# =======================================================
matmul:

    # Error checks
    #   The dimension of m0 do not make sense
    bge x0, a1, exception
    bge x0, a2, exception
    #   The dimension of m0 do not make sense
    bge x0, a4, exception
    bge x0, a5, exception
    #    The dimensions of m0 and m1 don't match
    bne a1, a5, exception
    bne a2, a4, exception

    # Prologue
    

outer_loop_start:




inner_loop_start:












inner_loop_end:




outer_loop_end:
    ret

    # Epilogue
exception:
    li a1, 34
    j exit2

    
