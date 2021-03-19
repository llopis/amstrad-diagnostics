
 MODULE KEYBOARDTEST


@TestKeyboard:
	call 	KeyboardSetUpScreen
	call 	PrintKeyboard
	call 	ClearKeyboardBuffer
	ld	a, 0
	ld	(FramesESCPressed), a

.keyboardLoop:
	call 	WaitForVsync
	call 	ReadFullKeyboard
	call 	UpdateKeyBuffers

	call	CheckESCPressedLongEnough
	ret	z


	; Print edge on keys in blue
	ld 	h, pen2
	ld 	l, pen0
	call 	SetTxtColors	
	ld 	hl, EdgeOnKeyboardMatrixBuffer
	call 	PrintOnKeysFromBuffer

	; Print edge off keys in yellow
	ld 	h, pen1
	ld 	l, pen0
	call 	SetTxtColors	
	ld 	hl, EdgeOffKeyboardMatrixBuffer
	call 	PrintOnKeysFromBuffer

	jr .keyboardLoop


PrintKeyboard:
	call 	SetDefaultColors
	ld 	b, KEY_COUNT
	ld	de, KEYB_TABLE_ROW_SIZE
	ld 	hl, KeyboardLocations
.printLoop:
	ld	ix, hl
	call 	DrawKey
	add	hl, de
	djnz	.printLoop
	ret



CheckESCPressedLongEnough:
	ld	hl, FramesESCPressed
	ld	b, (hl)					; Previous number of frames pressed

	ld 	a, (KeyboardMatrixBuffer+8)
	bit 	2, a					; ESC
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
	cp	52
	ret

.ESCPressed:
	inc	(hl)
	ld 	a, (hl)

	;; Draw a new character in the ESC bar
	call	SetDefaultColors
	ld 	a, (hl)
	dec	a
	ld	h, a
	ld	l, ESCBAR_Y
	ld	(TxtCoords), hl
	ld	a, '~'
	call	PrintChar
	jr	.continue


;; IN: A current width
ClearESCBar:
	push	af
	call	SetDefaultColors
	ld	h, 0
	ld	l, ESCBAR_Y
	ld	(TxtCoords), hl
	pop	af
	rra
	ld	b, a
.loop:
	ld	a, ' '
	call	PrintChar
	djnz	.loop
	ret



; IN: IX pointing to keyboard table for that key
DrawKey:
	push	hl
	push	de
	push	bc

	ld	a, 0
	ld	(txt_right), a
	ld	a, (ix)   ; text column in bytes
	ld	(txt_byte_x), a
	ld	a, (ix+1) ; text row in pixels
	ld	(txt_pixels_y), a
	ld 	a,(ix+2)

	ld	d, (ix)
	ld	e, (ix+1)
	cp	SPECIALKEY_SHIFTL
	jr	z, .drawShifts
	bit	7, a
	jr	nz, .specialKey

	cp	'e'
	jp	z, .drawReturn

	call	PrintCharWithPixels

	ld	c, 15
	call	DrawKeySquare
.exit
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
	ld	hl, SpecialKeysTable
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
	pop	de
	ld	a, RIGHTSHIFT_X
	ld	d, a
	ld	(txt_byte_x), a
	ld	a, SPECIALKEY_SHIFTR
	call 	.drawSpecialKey

	jr 	.exit


.drawReturn:
	ld	c, 23
	call	DrawReturnOutline
	ld	hl, TxtReturn
	call	PrintStringWithPixels
	jp	.exit


KEY_HEIGHT EQU 15

;; IN:	D - key x in bytes
;; 	E - key y in pixels
;;	C - width in pixels
DrawKeySquare:
	dec	d
	ld	h, 0
	ld	l, d
	sla	l
	rl	h
	sla	l			
	rl	h			;; HL = left edge
	push	hl
	dec	e
	dec	e
	dec	e
	dec	e
	push 	de			;; DE = top edge

	;; Top line
	push	bc
	ld	b, c
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
	call	DrawHorizontalLine

	ret

RETURN_HEIGHT EQU KEY_HEIGHT*2

;; IN:	D - key x in bytes
;; 	E - key y in pixels
;;	C - width in pixels
DrawReturnOutline:
	dec	d
	ld	h, 0
	ld	l, d
	sla	l
	rl	h
	sla	l			
	rl	h			;; HL = left edge
	push	hl
	dec	e
	dec	e
	dec	e
	dec	e
	push 	de			;; DE = top edge

	;; Top line
	push	bc
	ld	b, c
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
	ld	b, 4
	call	DrawHorizontalLine


	;; Left vertical line
	pop	de
	pop	hl
	push	de
	ld	de, 4
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
	sub	4
	ld	b, a
	call	DrawHorizontalLine


	ret


; IN: HL - Keyboard buffer
PrintOnKeysFromBuffer:
	ld	ix, KeyboardLocations
	ld 	b, KeyboardBufferSize
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
	push 	de
	call 	DrawKey
	pop 	de

.nextBit:
	push	hl
	push	de
	ld	de, KEYB_TABLE_ROW_SIZE
	ld	hl, ix
	add	hl, de
	ld	ix, hl
	pop	de
	pop	hl

	sla 	b
	jr 	nc,.bitLoop

.nextByte:
	inc 	hl
	pop 	bc
	djnz 	.byteLoop
	ret



ClearKeyboardBuffer:
	ld hl, LastKeyboardMatrixBuffer
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

	ld 	hl, #0002
	ld 	(TxtCoords),hl
	call 	SetDefaultColors

	ld 	h, TxtKeyboardX
	ld	l, PRESSESC_Y
	ld 	(TxtCoords),hl
	ld 	hl, TxtKeyboard
	call 	PrintString
	call 	NewLine
	ret


PRESSESC_Y EQU #17
ESCBAR_Y EQU PRESSESC_Y+1


TxtKeyboardTitle: db ' - KEYBOARD TEST',0
TxtKeyboardTitleLen EQU $-TxtKeyboardTitle-1

TxtKeyboard: db 'PRESS ESC OR FIRE FOR 1 SECOND TO EXIT',0
TxtKeyboardLen equ $-TxtKeyboard-1
TxtKeyboardX equ (ScreenCharsWidth-TxtKeyboardLen)/2


 INCLUDE "KeyboardLayout.asm"

 ENDMODULE

