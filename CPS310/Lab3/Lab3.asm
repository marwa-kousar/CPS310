		.begin
		.org 2048

! REGISTERS
! 1  = BASE 0x3FFFC0
! 2  = Input signal
! 3  = Input from user
! 4  = Output signal
! 5  = Input iterations counter 3
! 6  = Storage index
! 7  = test digits
! 8  = Print register, hold address to print subroutine.
! 9  = print indexer
! 10 = print character
! 20 = pow base storage
! 22 = result print assistance flag
! 23 = result print assistance index
! 25 = arthimetic sign switch
! 26 = math helper
! 27 = result print assitance
! 28 = 1st digit
! 29 = arthimetic sign
! 30 = 2nd digit
! 31 = final result
! FINALIZE REGISTERS
! 12 = finalize temporary storage
! 16-23 = storing bits for print


BASE		.equ 0x3fffc0
COUT		.equ 0x0
CSTAT		.equ 0x4
CIN		.equ 0x8
CICTL		.equ 0xc

iter:		3				! iterations counter

errMsg:	0x49, 0x6e, 0x76, 0x61			! string - Invalid input!
		0x6c, 0x69, 0x64, 0x20
		0x69, 0x6e, 0x70, 0x75
		0x74, 0x21, 0

equal:		0x20, 0x3d, 0x20, 0		! string -  = 
hexPrefix:	0x30, 0x78, 0			! string - 0x
charCode:	0x0, 0x0
		
main:		clr %r1
		clr %r6
		sethi BASE, %r1
		ld [iter], %r5
		sethi char, %r6			! store address of %r6
		srl %r6, 10, %r6
		call resetR6			! call - reset r6


iwait:		halt
		ldub [%r1 + CICTL], %r2		! wait for input
		andcc %r2, 0x80, %r2		! check if its ready
		be iwait			! proceed unless its 0

		ldub [%r1+CIN], %r3		! get char input

		st %r3, %r6			! store char to [char + index]
		add %r6, 4, %r6			! increment storage index
		addcc %r5, -1, %r5		! decrement iteration
		bg iwait			! repurpose and go back to iwait:
		call resetR6			! call - reset r6
		call testError			! call - parse input values

		
		or %r29, %r0, %r25		! copy sign to r25
		addcc %r25, -1, %r25		! test +
		bneg case0
		addcc %r25, -1, %r25		! test -
		bneg case1
		addcc %r25, -1, %r25		! test *
		bneg case2
		addcc %r25, -1, %r25		! test /
		bneg case3
		addcc %r25, -1, %r25		! test ^
		bneg case4

finalize:	call resetR6			! reset r6
	
		sethi hexPrefix, %r8		! print 0x prefix
		srl %r8, 10, %r8
		call print

		add %r6, 12, %r6		! offset r6 by 12
		st %r31, %r6			! store results

		ldub %r6, %r16			! extract most significant byte r16
		srl %r16, 4, %r16		! eliminate lower 4 bits
		subcc %r16, 9, %r12		! test if its 0-9, use r12 as ASCII storage
		ble num1			! if neg then its num, jump to num
		addcc %r12, 7, %r12		! else its A-F, add alpha offset
num1:		addcc %r12, 57, %r12		! add number offet
		sethi charCode, %r8		! prepare r8 
		srl %r8, 10, %r8
		st %r12, %r8			! set r12 to r8 (print register)
		call print
		
		ldub %r6, %r17			! extract most significant byte to r17
		sll %r17, 28, %r17
		srl %r17, 28, %r17
		subcc %r17, 9, %r12
		ble num2
		addcc %r12, 7, %r12
num2:		addcc %r12, 57, %r12		
		sethi charCode, %r8
		srl %r8, 10, %r8
		st %r12, %r8
		call print
		
		ldub %r6+1, %r18		! extract 2nd most significant byte to r18
		srl %r18, 4, %r18
		subcc %r18, 9, %r12
		ble num3
		addcc %r12, 7, %r12
num3:		addcc %r12, 57, %r12		
		sethi charCode, %r8
		srl %r8, 10, %r8
		st %r12, %r8
		call print
	
		ldub %r6+1, %r19		! extract 2nd most significant byte to r19
		sll %r19, 28, %r19
		srl %r19, 28, %r19
		subcc %r19, 9, %r12
		ble num4
		addcc %r12, 7, %r12
num4:		addcc %r12, 57, %r12		
		sethi charCode, %r8
		srl %r8, 10, %r8
		st %r12, %r8
		call print

		ldub %r6+2, %r20		! extract 3rd most significant byte to r20
		srl %r20, 4, %r20
		subcc %r20, 9, %r12
		ble num5
		addcc %r12, 7, %r12
num5:		addcc %r12, 57, %r12		
		sethi charCode, %r8
		srl %r8, 10, %r8
		st %r12, %r8
		call print

		ldub %r6+2, %r21		! extract 3rd most significant byte  to r21
		sll %r21, 28, %r21
		srl %r21, 28, %r21
		subcc %r21, 9, %r12
		ble num6
		addcc %r12, 7, %r12
num6:		addcc %r12, 57, %r12		
		sethi charCode, %r8
		srl %r8, 10, %r8
		st %r12, %r8
		call print

		ldub %r6+3, %r22		! extract least significant byte to r22
		srl %r22, 4, %r22
		subcc %r22, 9, %r12
		ble num7
		addcc %r12, 7, %r12
num7:		addcc %r12, 57, %r12		
		sethi charCode, %r8
		srl %r8, 10, %r8
		st %r12, %r8
		call print

		ldub %r6+3, %r23		! extract least significant byte  to r23
		sll %r23, 28, %r23
		srl %r23, 28, %r23
		subcc %r23, 9, %r12
		ble num8
		addcc %r12, 7, %r12
num8:		addcc %r12, 57, %r12		
		sethi charCode, %r8
		srl %r8, 10, %r8
		st %r12, %r8
		call print

		
done:		halt				! PROGRAM TERMINATES 


! ----------------------------------------
! print Subroutine. r8 stores address of printString
print:		clr %r9				! reset string indexer
printLoop:	ld [%r8 + %r9], %r10		! load char at r8 + r9
		orcc %r10, %r0, %r0		
		be printEnd

printOWait:	ldub [%r1 + CSTAT],%r4		! get byte from CSTAT
		andcc %r4, 0x80, %r4		! check if CSTAT is ready
		be printOWait			! If no (0), goto owait

		stb %r10, [%r1 + COUT]		! write one byte console
		add %r9, 4, %r9			! +4 to indexer
		ba printLoop			! do again

printEnd:	jmpl %r15+4, %r0		! return

! ----------------------------------------
! Shared - storage. 3 for equation, 4th for answer, 5th for 0x0
		.org 2800
char:		.dwb 5				! reserve space at 2800

		halt


! ----------------------------------------
! subroutine: reset %r6 back to original state
resetR6:	sethi char, %r6			! store address of %r6
		srl %r6, 10, %r6	
		jmpl %r15+4, %r0		! return


! ----------------------------------------
! subroutine: test error
testError:	clr %r7
		ld [char], %r7			! load first char to r7, expects single number
		addcc %r7, -48, %r7
		bneg testFailed
		addcc %r7, -9, %r7
		bg testFailed

		clr %r7
		ld [char+8], %r7		! load third char to r7, expects single number
		addcc %r7, -48, %r7
		bneg testFailed
		addcc %r7, -9, %r7
		bg testFailed

		clr %r7
		ld [char+4], %r7		! load third char to r7, expects single +-*/^
		addcc %r7, -42, %r7		! test *
		be testSuccess
		addcc %r7, -1, %r7		! test +
		be testSuccess
		addcc %r7, -2, %r7		! test -
		be testSuccess
		addcc %r7, -2, %r7		! test /
		be testSuccess
		addcc %r7, -47, %r7		! test ^
		be testSuccess

testFailed:	sethi errMsg, %r8		! load error message address
		srl %r8, 10, %r8		
		call print			! call - print sub
		halt				! PROGRAM TERMINATES

! subroutine for postprocessing after successful entry
! r28 shows 1st digit
! r29 shows symbol: 0 = + ; 1 = - ; 2 = * ; 3 = / ; 4 = ^
! r30 shows 2nd digit
testSuccess:	or %r15, %r0, %r19		! backup r15 to secondary jump
						! print valid formula entry
		sethi char, %r8			! load formula
		srl %r8, 10, %r8		
		call print			! call - print subroutine
		sethi equal, %r8		! load equal sign
		srl %r8, 10, %r8		
		call print			! call - print subroutine
		or %r19, %r0, %r15		! copy secondary jump back to r15

		clr %r7				! clear r7
		ld [char], %r7			! load first digit
		add %r7, -48, %r7		! 1st into number
		or %r7, %r28, %r28		! r28 - 1st digit for visual purpose
		st %r7, [char]			! store back into original memory 

		clr %r7				! clear r7
		ld [char+8], %r7		! load 2nd digit
		add %r7, -48, %r7		! transform into number
		or %r7, %r30, %r30		! r30 - 2nd digit for visual purpose
		st %r7, [char+8]		! store back into original memory 

		clr %r7				! clear r7
		clr %r29			! r29 - math sign storage
		ld [char+4], %r7		! load math sign
		addcc %r7, -43, %r7		! check +
		be testSuccessExit
		inc %r29
		addcc %r7, -2, %r7		! check -
		be testSuccessExit
		inc %r29
		addcc %r7, 3, %r7		! check *
		be testSuccessExit
		inc %r29
		addcc %r7, -5, %r7		! check /
		be testSuccessExit
		inc %r29
		addcc %r7, -47, %r7		! check ^
		be testSuccessExit

testSuccessExit:
		st %r29, [char+4]		! store back into original memory 
		jmpl %r15+4, %r0		! return

! ----------------------------------------
! subroutine for addition
case0:		clr %r31			! clear r31
		add %r28, %r30, %r31		! addition
		ba finalize			! return


! ----------------------------------------
! subroutine for subtraction
case1:		clr %r31			! clear r31
		sub %r28, %r30, %r31		! subtraction
		ba finalize			! return

! ----------------------------------------
! subroutine for multiplication
case2:		clr %r31			! clear r31
		clr %r26			! clear r26
		or %r0, %r30, %r26		! copy 2nd digit (r30) to r26 for processing
mult:		addcc %r26, -1, %r26		! decrement counter
		bneg finalize			! if counter is negative, return
		add %r28, %r31, %r31		! addition		
		ba mult				! always go to mult:
		

! ----------------------------------------
! subroutine for division
case3:		clr %r31			! clear r31
		clr %r26			! clear r26
		or %r0, %r28, %r26		! copy 1st digit (r28) to r26 for processing
div:		subcc %r26, %r30, %r26		! division
		bneg finalize			! if dividend is negative, return
		inc %r31			! increment quotient by 1
		ba div				! always goto div:

! ----------------------------------------
! subroutine for exponent
case4:		clr %r31			! clear r31
		clr %r24			! clear r24
		clr %r26			! clear r26
		clr %r27			! clear r27

		orcc %r0, %r28, %r20		! copy base to r20, test for special cases
		be zeroBase			! branch on 0 base
		orcc %r0, %r30, %r26		! copy exponent to r26, test for special cases
		be zeroExpo			! branch on 0 expo

pow:		addcc %r26, -1, %r26		! -1 exp.
		ble powResult			! ends if power is 0.

		clr %r31			! clear result r31
		or %r0, %r28, %r24		! reset/store multiply counter
powMulti:	
		add %r20, %r31 , %r31		! addition
		addcc %r24, -1, %r24		! decrement multiply counter
		bg powMulti			! If > 0, goto powMulti:
		
		clr %r20			! clear the base
		or %r31, %r0, %r20		! set new base
		
		ba pow		

powResult:	ba finalize			! return

! special cases with zeros.
zeroExpo:	inc %r31			! any zero expo equals to 1.
		ba finalize			! return
zeroBase:	orcc %r0, %r30, %r0		! base is 0, test if expo is also 0
		bg finalize			! if (expo > 0) -> answer = 0, jump to finalize
		ba testFailed			! else return error.

.end
