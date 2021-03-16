
 MODULE KEYBOARDTEST

KEYBOARD_Y EQU #06

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
	ld 	b, 80
	ld 	ix, KeyboardLocations
.printLoop:
	call 	DrawKey
	inc 	ix
	inc 	ix
	inc 	ix
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
	cp	100
	ret

.ESCPressed:
	inc	(hl)
	ld 	a, (hl)
	and	%00000001
	jr	nz, .continue

	;; Draw a new character in the ESC bar
	call	SetDefaultColors
	ld 	a, (hl)
	dec	a
	rra	
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
; Modifies DE
DrawKey:
	ld	d,(ix)   ; text column
	dec	d
	ld	e,(ix+1) ; text row
	ld	a,KEYBOARD_Y
	add	e
	ld	e,a
	ld	(TxtCoords),de

	ld 	a,(ix+2)
	cp	' '
	jr	z,.drawSpaceBar
	call	PrintChar
	ret
.drawSpaceBar:
	push	bc
	ld	b,19
.loop:
	ld	a,' '
	call	PrintChar
	djnz	.loop
	pop	bc
	ret


; IN: HL - Keyboard buffer
PrintOnKeysFromBuffer:
	ld ix,KeyboardLocations
	ld b,KeyboardBufferSize
.byteLoop:
	push bc
	ld a,(hl)
	ld d,a
	ld b,1
.bitLoop:
	ld a,d
	and b
	jr z,.nextBit

	; This one is pressed. Draw it.
	push de
	call DrawKey
	pop de

.nextBit:
	inc ix
	inc ix
	inc ix
	sla b
	jr nc,.bitLoop

.nextByte:
	inc hl
	pop bc
	djnz .byteLoop


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
	ld 	a,4
	call 	SetBorderColor 

	ld 	hl, TxtKeyboardTitle
	ld 	d, (ScreenCharsWidth - TxtTitleLen - TxtKeyboardTitleLen)/2
	call 	PrintTitleBanner

	ld 	hl, #0002
	ld 	(TxtCoords),hl
	call 	SetDefaultColors

	ld 	h, 0
	ld	l, PRESSESC_Y
	ld 	(TxtCoords),hl
	ld 	hl, TxtKeyboard
	call 	PrintString
	call 	NewLine
	ret


PRESSESC_Y EQU #14
ESCBAR_Y EQU PRESSESC_Y+1


TxtKeyboardTitle: db ' - KEYBOARD TEST',0
TxtKeyboardTitleLen EQU $-TxtKeyboardTitle-1

TxtKeyboard: db 'PRESS ESC OR FIRE FOR 2 SECONDS TO EXIT',0

 ENDMODULE