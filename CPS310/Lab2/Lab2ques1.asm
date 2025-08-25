	.begin
 	.org 2048
prog: ! Your assembly code here
	ld   [flt], %r1       
   	srl   %r1, 23, %r2      ! shift right by 23 bits; exponent now in lower 8 bits of r2
    	and   %r2, 0xFF, %r2    ! mask off to isolate the exponent bits
   	sub   %r2, 127, %r2     ! subtract the bias (127) from the exponent
   	st    %r2, [exp]       ! store the computed exponent result into memory location exp
	halt
flt: 0xc14a0000 ! 32-bit float to load
exp: 0x0 ! store exponent as integer here
	.end
