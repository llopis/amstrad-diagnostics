	INCLUDE "Colors.asm"

ColorBackground EQU ColorBlack
ColorNumber     EQU ColorWhite
ColorGood       EQU ColorLime
ColorBad        EQU ColorBrightRed

DisplayFailingBits:
	di 
	; Turn the whole screen into a giant border
	; out &bc00,6:out &bd00,0
	ld bc,#bc06
	out (c),c
	ld bc,#bd00
	out (c),c


	;; Select color 0 register
	ld bc, #7F00
	out (c), c
	ld c, ColorBlack
	out (c), c        
        
        ; Wait for Vsync
.frameLoop:
	ld     b,#f5
.vbLoop1
	in    a,(c)
	rra
	jr    c,.vbLoop1
.vbLoop2
	in    a,(c)
	rra
	jr    nc,.vbLoop2

	;; Select Border color register
	ld bc, #7F10
	out (c), c
	ld c, ColorBackground
	out (c), c

	ld bc, #6103
.waitLoop:
	djnz .waitLoop        ; [3]
	dec c                   ; [1]
	jr nz, .waitLoop      ; [3]


	ld bc, #7F10
	out (c), c
	ld c, ColorBackground
	ld h, ColorNumber

	; out (c), h
	DEFINE F #ed,#61, 
	; out (c), c
	DEFINE _ #ed,#49, 
	; out (c), l
	DEFINE B #ed,#69, 
	DEFINE EOL , #ed,#49, #ed,#49

/*
	ld a,#f			; [2]
.testLoop:
	dec a			; [1]
	jr nz,.testLoop		; [3] / [2]
	nop
	nop
	nop
*/
	DEFINE WAIT16 #3E, #0f, #3D, #20, #fD, 0, 0, 0
	DEFINE WAIT12 #3E, #0b, #3D, #20, #fD, 0, 0, 0
	DEFINE WAIT9  #3E, #08, #3D, #20, #fD, 0, 0, 0

	INCLUDE "ColorChange.asm"

	db WAIT16
	db WAIT16
	db WAIT16

	; 0
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12

	db WAIT16
	db WAIT16
	db WAIT12

	INCLUDE "ColorChange.asm"

	; 1
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ B WAIT9 EOL
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12
	db _ F _ _ WAIT12

	db WAIT16
	db WAIT16
	db WAIT12

	INCLUDE "ColorChange.asm"

	; 2
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12

	db WAIT16
	db WAIT16
	db WAIT12

	INCLUDE "ColorChange.asm"

	; 3
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12

	db WAIT16
	db WAIT16
	db WAIT12

	INCLUDE "ColorChange.asm"

	; 4
	db F _ F _ WAIT12
	db F _ F _ WAIT12
	db F _ F _ WAIT12
	db F _ F _ WAIT12
	db F _ F _ WAIT12
	db F _ F _ WAIT12
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12

	db WAIT16
	db WAIT16
	db WAIT12

	INCLUDE "ColorChange.asm"

	; 5
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12

	db WAIT16
	db WAIT16
	db WAIT12

	INCLUDE "ColorChange.asm"

	; 6
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F _ _ _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F F F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F _ F _ B WAIT9 EOL
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12

	db WAIT16
	db WAIT16
	db WAIT12

	INCLUDE "ColorChange.asm"

	; 7
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db F F F _ WAIT12
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ B WAIT9 EOL
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12
	db _ _ F _ WAIT12


	UNDEFINE F
	UNDEFINE _
	UNDEFINE B
	UNDEFINE EOL


	nop
	nop
	nop
	nop
	nop
	nop

	jp .frameLoop

