ColorBackground EQU ColorBlack
ColorNumber     EQU ColorWhite
ColorGood       EQU ColorLime
ColorBad        EQU ColorBrightRed

DisplayFailingBits:
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
	ld a, ColorNumber

	DEFINE F #ed,#79, 
	DEFINE _ #ed,#49, 
	DEFINE B #ed,#69, 
	DEFINE EOL #ed,#49, #ed,#49, #ed,#49, #ed,#49

	INCLUDE "ColorChange.asm"

	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL

	; 0
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL

	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _     EOL

	INCLUDE "ColorChange.asm"

	; 1
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ B B B B B B B B    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL
	db _ F _ _ _ _ _ _ _ _ _ _    EOL

	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _     EOL

	INCLUDE "ColorChange.asm"

	; 2
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL

	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _     EOL

	INCLUDE "ColorChange.asm"

	; 3
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL

	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _     EOL

	INCLUDE "ColorChange.asm"

	; 4
	db F _ F _ _ _ _ _ _ _ _ _    EOL
	db F _ F _ _ _ _ _ _ _ _ _    EOL
	db F _ F _ _ _ _ _ _ _ _ _    EOL
	db F _ F _ _ _ _ _ _ _ _ _    EOL
	db F _ F _ _ _ _ _ _ _ _ _    EOL
	db F _ F _ _ _ _ _ _ _ _ _    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL

	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _     EOL

	INCLUDE "ColorChange.asm"

	; 5
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL

	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _     EOL

	INCLUDE "ColorChange.asm"

	; 6
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F _ _ _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F F F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F _ F _ B B B B B B B B    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL

	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _ _ _ _ _    EOL
	db _ _ _ _ _ _ _ _     EOL

	INCLUDE "ColorChange.asm"

	; 7
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db F F F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ B B B B B B B B    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL
	db _ _ F _ _ _ _ _ _ _ _ _    EOL


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

