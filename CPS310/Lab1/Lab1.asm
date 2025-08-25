! This program adds two numbers
	.begin
	.org 2048
prog1:	ld [x], %r1
 	ld [x+4], %r2
 	addcc %r1, %r2, %r1
	ld [x+8], %r2
	addcc %r1, %r2, %r1
	ld [x+12], %r2
	addcc %r1, %r2, %r1
	ld [x+16], %r2
	addcc %r1, %r2, %r1
 	st %r1, [2240]

	.org 2200
x: 	-1
	2
	-3
	4
	-5
	.end

