
 MODULE KEYBOARDTEST


@TestKeyboard:
	call 	KeyboardSetUpScreen
.afterScreenDraw:
	call	SetKeyboardTables
	call 	PrintKeyboard
	ld 	hl, LastKeyboardMatrixBuffer
	call 	ClearKeyboardBuffer
	ld 	hl, PresseddMatrixBuffer
	call 	ClearKeyboardBuffer
	ld	a, 0
	ld	(FramesESCPressed), a

.keyboardLoop:
	call 	WaitForVsync
	call 	ReadFullKeyboard
	call 	UpdateKeyBuffers

	call	CheckESCPressedLongEnough
	jr	nz, .continue

	;; Something was pressed long enough
	ld 	a, (KeyboardMatrixBuffer+8)
	bit 	4, a					; TAB
	jr	z, ExitTest

	;; Toggle the keyboard layout
	ld	a, (KeyboardLayout)
	inc	a
	cp	KEYBOARD_LAYOUT_MATRIX+1
	call	z, .clearA
	ld	(KeyboardLayout), a
	call	ClearESCBar
	call	ClearKeyboardArea
	jr	.afterScreenDraw

.continue:
	; Print edge on keys in blue
	ld	a, PATTERN_BLUE
	ld	(FillKeyPattern), a
	ld 	h, pen2
	ld 	l, pen0
	call 	SetTxtColors	
	ld 	hl, EdgeOnKeyboardMatrixBuffer
	call 	PrintOnKeysFromBuffer

	; Print edge off keys in yellow
	ld	a, PATTERN_YELLOW
	ld	(FillKeyPattern), a
	ld 	h, pen1
	ld 	l, pen0
	call 	SetTxtColors	
	ld 	hl, EdgeOffKeyboardMatrixBuffer
	call 	PrintOnKeysFromBuffer

	jr .keyboardLoop

.clearA:
	ld	a, 0
	ret


ExitTest:
	call	CountPressedKeys
	cp	KEYBOARD_KEY_COUNT
	jr	nz, .keyTestFailed

	ld	a, TESTRESULT_PASSED
	ld	(TestResultTableKeyboard), a

.continueExit:
	call	CountPressedJoystickButtons
	cp	JOYSTICK_KEY_COUNT
	jr	nz, .joyTestFailed

	ld	a, TESTRESULT_PASSED
	ld	(TestResultTableJoystick), a

	ret

.keyTestFailed:
	ld	a, TESTRESULT_FAILED
	ld	(TestResultTableKeyboard), a
	jr	.continueExit

.joyTestFailed:
	ld	a, TESTRESULT_FAILED
	ld	(TestResultTableJoystick), a
	ret


;; OUT: A - number of different pressed keys
@CountPressedKeys:
	push	bc
	push	de
	ld	d, 0
	ld 	hl, PresseddMatrixBuffer
	ld 	c, KeyboardBufferSize
	ld	e, #FF			;; Mask for bits
.byteLoop:
	ld 	a, (hl)
	and	e			;; Mask out all bits from joystick
	ld	b, 8
.bitLoop:
	bit	0, a
	jr	z, .nextBit
	inc	d
.nextBit:
	srl	a
	djnz	.bitLoop

	inc	hl
	dec	c
	ld	a, c
	cp	1
	jr	nz, .notLastByte
	ld	e, %10000000		;; Set mask for last byte to ignore all joystick presses
.notLastByte:
	or	a
	jr	nz, .byteLoop

	ld	a, d
	pop	de
	pop	bc
	ret


;; OUT: A - number of different pressed joystick buttons
@CountPressedJoystickButtons:
	push	bc

	ld	d, 0
	ld 	hl, PresseddMatrixBuffer+9
	ld 	a, (hl)

	ld	b, 5
.bitLoop:
	bit	0, a
	jr	z, .nextBit
	inc	d
.nextBit:
	srl	a
	djnz	.bitLoop

	ld	a, d
	pop	bc
	ret


ClearKeyboardArea:
	ld 	hl, SCREEN_START+#50
	ld	b, 8

.outerloop:
	push	bc
	push	hl
	ld 	bc, #6D0
 IFNDEF UpperROMBuild
 	ld	(hl), 0
 	ld	de, hl
 	inc	de
 	ldir
 ELSE

	ld	d, 0
.loop:
	ld 	(hl),d
	inc 	hl
	dec 	bc
	ld 	a, b
	or 	c
	jr 	nz, .loop
 ENDIF
	pop	hl
	pop	bc
	ld	de, #800
	add	hl, de
	djnz	.outerloop

	ret

PrintKeyboard:
	call 	SetDefaultColors
	ld	a, PATTERN_CLEAR
	ld	(FillKeyPattern), a
	ld 	b, KEY_COUNT
	ld	de, KEYB_TABLE_ROW_SIZE
	ld	hl, (KeyboardLocationTable)
	ld	iy, KeyboardLabels
.printLoop:
	ld	ix, hl
	call 	DrawKey
	add	hl, de
	inc	iy
	djnz	.printLoop
	ret


CheckESCPressedLongEnough:
	ld	hl, FramesESCPressed
	ld	b, (hl)					; Previous number of frames pressed

	ld 	a, (KeyboardMatrixBuffer+8)
	bit 	2, a					; ESC
	jr 	nz, .ESCPressed
	bit 	4, a					; TAB
	jr 	nz, .ESCPressed
	ld 	a, (KeyboardMatrixBuffer+9)
	bit 	4, a					; Fire
	jr 	nz, .ESCPressed

	;; ESC not pressed
	ld	a, b
	or 	a
	call	nz, ClearESCBar
	ld	hl, FramesESCPressed
	ld	(hl), 0

.continue:
	;; Check if it's time to exit to main menu
	ld	hl, FramesESCPressed
	ld	a, (hl)
	cp	53
	ret

.ESCPressed:
	inc	(hl)
	ld 	a, (hl)

	;; Draw a new character in the ESC bar
	call	SetInverseColors
	ld 	a, (hl)
	dec	a
	ld	h, a
	ld	l, ESCBAR_Y
	ld	(TxtCoords), hl
	ld	d, 0
	ld	e, a
	ld	hl, TxtKeyboardOptions
	add	hl, de
	ld	a, (hl)
	call	PrintChar
	jr	.continue


ClearESCBar:
	call	SetDefaultColors
	ld 	h, 0
	ld	l, PRESSESC_Y
	ld 	(TxtCoords),hl
	ld 	hl, TxtKeyboardOptions
	call 	PrintString
	ret



; IN: 	IX - keyboard table for that key
;	IY - keyboard label
DrawKey:
	push	hl
	push	de
	push	bc
	push	ix

	ld	a, 0
	ld	(txt_right), a
	ld	a, (ix)   ; text column in bytes
	ld	(txt_byte_x), a
	ld	a, (ix+1) ; text row in pixels
	ld	(txt_pixels_y), a

	ld	d, (ix)
	ld	e, (ix+1)

	ld	a, (KeyboardLayout)
	cp	KEYBOARD_LAYOUT_MATRIX
	jr	z, .drawKeyNormal

	ld 	a,(iy)
	cp	SPECIALKEY_SHIFTL
	jr	z, .drawShifts
	cp	'e'
	jp	z, .drawReturn

.drawKeyNormal:
	ld 	a,(iy)	
	bit	7, a
	jr	nz, .specialKey
	push	af
	ld	c, 15
	call	DrawKeySquare
	pop	af

	call	PrintCharWithPixels

.exit
	pop	ix
	pop	bc
	pop	de
	pop	hl
	ret

.specialKey:
	call 	.drawSpecialKey
	jr	.exit


.drawSpecialKey:
	push	de
	and	%01111111
	ld	b, a
	ld	d, 0
	ld	e, 3
	ld	hl, (SpecialKeysTable)
	or	a
	jr	z, .found
.loop:
	add	hl, de
	djnz	.loop
.found:
	ld	c, (hl)
	pop	de
	push	hl
	call	DrawKeySquare
	pop	ix
	ld	l, (ix+1)
	ld	h, (ix+2)
	call	PrintStringWithPixels
	ret

.drawShifts:
	;; Left shift
	push	de
	call 	.drawSpecialKey

	;; Right shift
	push	hl
	ld	hl, (KeyboardLocationTable)
	ld	de, RIGHTSHIFT_TABLE_OFFSET
	add	hl, de
	ld	a, (hl)
	pop	hl

	pop	de
	ld	d, a
	ld	(txt_byte_x), a
	ld	a, SPECIALKEY_SHIFTR
	call 	.drawSpecialKey

	jr 	.exit


.drawReturn:
	ld	ix, (SpecialKeysTable)
	ld	c, (ix)
	call	DrawReturnOutline
	ld	hl, TxtKeyReturn
	call	PrintStringWithPixels
	jp	.exit



;; IN:	D - key x in bytes
;; 	E - key y in pixels
;;	C - width in pixels
DrawKeySquare:
	ld	a, (FillKeyPattern)
	or	a
	jr	nz, DrawKeyFill

	call	GetKeyTopLeftEdge
	push	hl
	push	de

	;; Top line
	push	bc
	ld	b, c
	ld	a, PATTERN_YELLOW
	call	DrawHorizontalLine
	pop	bc


	;; Left
	pop	de
	pop 	hl
	push	hl
	push	de
	push	bc
	ld	b, KEY_HEIGHT-1
	call	DrawVerticalLine
	pop	bc

	;; Right
	pop	de
	pop	hl
	push	hl
	push	de
	ld	d, 0
	ld	e, c
	dec	e
	add	hl, de
	pop	de
	push 	de

	push	bc
	ld	b, KEY_HEIGHT-1
	call	DrawVerticalLine
	pop	bc


	;; Bottom line
	pop	de
	ld	hl, KEY_HEIGHT-1
	add	hl, de
	ld	de, hl
	pop	hl
	ld	b, c
	ld	a, PATTERN_YELLOW
	call	DrawHorizontalLine

	ret

;; IN:	D - key x in bytes
;; 	E - key y in pixels
;; OUT: HL - left edge
;;	E - top edge
GetKeyTopLeftEdge:
	dec	d
	ld	h, 0
	ld	l, d
	sla	l
	rl	h
	sla	l			
	rl	h			

	dec	e
	dec	e
	dec	e
	dec	e
	ret

;; IN:	D - key x in bytes
;; 	E - key y in pixels
;;	C - width in pixels
DrawKeyFill:
	call	GetKeyTopLeftEdge
	ld	b, KEY_HEIGHT
.loop:
	push	hl
	push	de
	push	bc
	ld	b, c
	ld	a, (FillKeyPattern)
	call	DrawHorizontalLine
	pop	bc
	pop	de
	pop	hl
	inc	e
	djnz	.loop

	ret


RETURN_INSET EQU 4

RETURN_HEIGHT EQU KEY_HEIGHT*2

;; IN:	D - key x in bytes
;; 	E - key y in pixels
;;	C - width in pixels
DrawReturnOutline:
	ld	a, (FillKeyPattern)
	or	a
	jr	nz, DrawReturnFill

	call	GetKeyTopLeftEdge
	push	hl
	push	de

	;; Top line
	push	bc
	ld	b, c
	ld	a, PATTERN_YELLOW
	call	DrawHorizontalLine
	pop	bc


	;; Left
	pop	de
	pop 	hl
	push	hl
	push	de
	push	bc
	ld	b, KEY_HEIGHT-1
	call	DrawVerticalLine
	pop	bc

	;; Right
	pop	de
	pop	hl
	push	hl
	push	de
	ld	d, 0
	ld	e, c
	dec	e
	add	hl, de
	pop	de
	push 	de

	push	bc
	ld	b, RETURN_HEIGHT+1
	call	DrawVerticalLine
	pop	bc


	;; Small horiz line
	pop	de
	ld	hl, KEY_HEIGHT-1
	add	hl, de
	ld	de, hl
	pop	hl
	push	hl
	push	de
	ld	b, RETURN_INSET
	ld	a, PATTERN_YELLOW
	call	DrawHorizontalLine

	;; Left vertical line
	pop	de
	pop	hl
	push	de
	ld	de, RETURN_INSET
	add	hl, de
	pop	de
	push	hl
	push	de
	push	bc
	ld	b, RETURN_HEIGHT-KEY_HEIGHT+1
	call	DrawVerticalLine
	pop	bc


	;; Bottom line
	pop	de
	ld	hl, RETURN_HEIGHT-KEY_HEIGHT+1
	add	hl, de
	ld	de, hl
	pop 	hl

	ld	a, c
	sub	RETURN_INSET
	ld	b, a
	ld	a, PATTERN_YELLOW
	call	DrawHorizontalLine

	ret

;; IN:	D - key x in bytes
;; 	E - key y in pixels
;;	C - width in pixels
DrawReturnFill:
	call	GetKeyTopLeftEdge
	ld	b, KEY_HEIGHT
.loop:
	push	hl
	push	de
	push	bc
	ld	b, c
	ld	a, (FillKeyPattern)
	call	DrawHorizontalLine
	pop	bc
	pop	de
	pop	hl
	inc	e
	djnz	.loop

	;; Bottom half of the key
	push	de
	ld	de, RETURN_INSET
	add	hl, de
	pop	de
	ld	a, c
	sub	RETURN_INSET
	ld	c, a
	ld	b, RETURN_HEIGHT-KEY_HEIGHT+1
.loop2:
	push	hl
	push	de
	push	bc
	ld	b, c
	ld	a, (FillKeyPattern)
	call	DrawHorizontalLine
	pop	bc
	pop	de
	pop	hl
	inc	e
	djnz	.loop2

	ret



; IN: HL - Keyboard buffer
PrintOnKeysFromBuffer:
	ld	ix, (KeyboardLocationTable)
	ld 	b, KeyboardBufferSize
	ld	iy, KeyboardLabels
.byteLoop:
	push 	bc
	ld 	a,(hl)
	ld 	d,a
	ld 	b,1
.bitLoop:
	ld 	a,d
	and 	b
	jr 	z,.nextBit

	; This one is pressed. Draw it.
	call 	DrawKey

.nextBit:
	push	hl
	push	de
	ld	de, KEYB_TABLE_ROW_SIZE
	ld	hl, ix
	add	hl, de
	ld	ix, hl
	inc	iy
	pop	de
	pop	hl

	sla 	b
	jr 	nc,.bitLoop

.nextByte:
	inc 	hl
	pop 	bc
	djnz 	.byteLoop
	ret



;; IN: HL - buffer
@ClearKeyboardBuffer:
	ld b, KeyboardBufferSize
.loop:
	ld (hl),0
	inc hl
	djnz .loop
	ret


KeyboardSetUpScreen:
	ld 	d, 0
	call 	ClearScreen
	ld 	a, 4
	call 	SetBorderColor 

	ld 	hl, TxtKeyboardTitle
	ld 	d, (ScreenCharsWidth - TxtTitleLen - TxtKeyboardTitleLen)/2
	call 	PrintTitleBanner

	call	ClearESCBar
	ret


PRESSESC_Y EQU #18
ESCBAR_Y EQU PRESSESC_Y


TxtKeyboardTitle: db ' - KEYBOARD TEST',0
TxtKeyboardTitleLen EQU $-TxtKeyboardTitle-1

TxtKeyboardOptions: db ' HOLD ESC OR FIRE TO EXIT. HOLD TAB TO CHANGE LAYOUT.',0


 INCLUDE "KeyboardLayout.asm"
 INCLUDE "KeyboardLabels.asm"

 ENDMODULE

