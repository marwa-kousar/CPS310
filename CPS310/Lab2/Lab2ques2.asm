.begin
.org 2048

prog:
    ! Load base and exponent into registers
    ld [base], %r1       ! Load base into %r1
    ld [exp], %r2        ! Load exponent into %r2

    ! Initialize result to 1 (since any number^0 = 1)
    mov 1, %r3           ! %r3 will hold the result, initialize to 1

    ! Check if exponent is 0
    cmp %r2, 0           ! Compare exponent with 0
    be done              ! If exponent is 0, result is 1 (already in %r3)

loop:
    ! Multiply result by base correctly
    mov %r3, %r4         ! Copy current result to %r4
    mov 0, %r5           ! Initialize loop counter for multiplication
    mov 0, %r6           ! Store multiplication result here

multiply_loop:
    add %r6, %r4, %r6    ! %r6 = %r6 + %r4 (adding result %r4 times)
    add %r5, 1, %r5      ! Increment loop counter
    cmp %r5, %r1         ! Compare loop counter with base
    bl multiply_loop     ! If loop counter < base, continue adding

    mov %r6, %r3         ! Store multiplication result in %r3 (final result)

    ! Decrement exponent
    sub %r2, 1, %r2      ! Decrement exponent by 1

    ! Check if exponent is greater than 0
    cmp %r2, 0           ! Compare exponent with 0
    bne loop             ! If exponent is not 0, repeat loop

done:
    ! Store the result in memory location res
    st %r3, [res]        ! Store the result in res

    ! End of program
    halt

base: 4                  ! Base value (4)
exp: 7                   ! Exponent value (7)
res: 0                   ! Result will be stored here

.end


