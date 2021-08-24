.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 35
    # - If malloc fails, this function terminates the program with exit code 48
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

     addi sp, sp, -52
     sw s0, 0(sp)
     sw s1, 4(sp)
     sw s2, 8(sp)
     sw s3, 12(sp)
     sw s4, 16(sp)
     sw s5, 20(sp)
     sw s6, 24(sp)
     sw s7, 28(sp)
     sw s8, 32(sp)
     sw s9, 36(sp)
     sw s10, 40(sp)
     sw s11, 44(sp)
     sw ra, 48(sp)

     mv s0, a0
     mv s1, a1
    #  mv s2, a2
     mv s2, x0

     # If the number of args is wrong
     li t0, 5
     bne t0, a0, args_error

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    li a0, 8
    jal malloc
    beq a0, x0, malloc_error

    mv s7, a0
    mv a1, a0
    mv a2, a0
    addi a2, a2, 4
    lw a0, 4(s1)

    jal read_matrix

    mv s3, a0       # s3 = pointer to m0

    # Load pretrained m1
    li a0, 8
    jal malloc
    beq a0, x0, malloc_error

    mv s8, a0
    mv a1, a0
    mv a2, a0
    addi a2, a2, 4
    lw a0, 8(s1)

    jal read_matrix

    mv s4, a0       # s4 = pointer to m1

    # Load input matrix
    li a0, 8
    jal malloc
    beq a0, x0, malloc_error

    mv s9, a0
    mv a1, a0
    mv a2, a0
    addi a2, a2, 4
    lw a0, 12(s1)

    jal read_matrix

    mv s5, a0       # s4 = pointer to matrix

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # m0 * input
    lw t0, 0(s7)
    lw t1, 4(s9)
    mul a0, t0, t1

    jal malloc
    beq a0, x0, malloc_error

    mv s10, a0

    mv a0, s3
    lw a1, 0(s7)    # the row of the m0
    lw a2, 4(s7)
    mv a3, s5
    lw a4, 0(s9)
    lw a5, 4(s9)    # the column of the m1
    mv a6, s10

    jal matmul

    # ReLU(m0 * input)
    mv a0, s10

    lw t0, 0(s7)
    lw t1, 4(s9)
    mul a1, t0, t1

    jal relu

    # m1 * ReLU(m0 * input)
    lw t0, 0(s8)
    lw t1, 4(s9)
    mul a0, t0, t1
    jal malloc
    beq a0, x0, malloc_error
    mv s11, a0

    mv a0, s4
    lw a1, 0(s8)
    lw a2, 4(s8)
    mv a3, s10
    lw a4, 0(s7)
    lw a5, 4(s9)
    mv a6, s11

    jal matmul
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 12(s1)
    mv a1, s11
    lw a2, 0(s8)
    lw a3, 4(s9)

    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s11
    lw t0, 0(s8)
    lw t1, 4(s9)
    mul a1, t0, t1
    jal argmax
    mv s0, a0
    # Print classification
    
    mv a1, s0
    jal print_int
    # Print newline afterwards for clarity

	li a1 '\n'
    jal print_char

dont_print:
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    mv a0, s10
    jal free
    mv a0, s11
    jal free
    
    mv a0, s0

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52


    ret

malloc_error:
    li a1, 48
    j exit2
args_error:
    li a1, 35
    j exit2

