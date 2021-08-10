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
ebreak
    # Prologue
    bge a0, x0, end

    sub a0, zero, a0
    # # return 0
    # mv a0, zero

    # Epilogue

end: ret
