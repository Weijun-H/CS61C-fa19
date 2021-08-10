.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    # Prologue
    bge a0, x0, end

    xori a0, a0, 0xFF

    # # return 0
    # mv a0, zero

    # Epilogue

end:    ret
