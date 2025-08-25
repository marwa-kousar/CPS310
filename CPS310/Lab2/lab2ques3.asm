.begin
.org 2048

prog:
    ! Load dividend (x) and divisor (y) into registers
    ld [x], %r1          ! Load dividend (x) into %r1
    ld [y], %r2          ! Load divisor (y) into %r2

    ! Initialize quotient to 0
    mov 0, %r3           ! %r3 will hold the quotient, initialize to 0

    ! Check if divisor is 0 (division by zero)
    cmp %r2, 0           ! Compare divisor with 0
    be done              ! If divisor is 0, jump to done (avoid division by zero)

divide_loop:
    cmp %r1, %r2         ! Compare dividend with divisor
    bl done              ! If dividend < divisor, stop loop

    sub %r1, %r2, %r1    ! Subtract divisor from dividend
    add %r3, 1, %r3      ! Increment quotient
    ba divide_loop       ! Repeat loop

done:
    ! Store quotient and remainder
    st %r3, [quot]       ! Store quotient in quot
    st %r1, [rem]        ! Store remainder in rem

    ! End of program
    halt

x: 8                    ! Dividend (8)
y: 3                    ! Divisor (3)
quot: 0                 ! Quotient will be stored here
rem: 0                  ! Remainder will be stored here

.end

