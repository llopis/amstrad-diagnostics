
 MODULE KEYBOARDTEST

KEYBOARD_Y EQU #06

@TestKeyboard:
	call KeyboardSetUpScreen
	call PrintKeyboard
	call ClearKeyboardBuffer

.keyboardLoop:
	call WaitForVsync
	call ReadFullKeyboard

	; Look for exit key combination
	ld a, (KeyboardMatrixBuffer+2)	; check row 2 (keys 16-23)
	cp %10100100			; for ctrl+shift+enter bits 2, 5, 7
	ret z

	call UpdateKeyBuffers

	; Print edge on keys in blue
	ld h,pen2
	ld l,pen0
	call set_txt_colours	
	ld hl,EdgeOnKeyboardMatrixBuffer
	call PrintOnKeysFromBuffer

	; Print edge off keys in yellow
	ld h,pen1
	ld l,pen0
	call set_txt_colours	
	ld hl,EdgeOffKeyboardMatrixBuffer
	call PrintOnKeysFromBuffer

	jr .keyboardLoop


PrintKeyboard:
	call SetDefaultColors
	ld b,80
	ld ix,KeyboardLocations
.printLoop:
	call DrawKey
	inc ix
	inc ix
	inc ix
	djnz	.printLoop
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
	ld	(txt_coords),de

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
	ld hl,LastKeyboardMatrixBuffer
	ld b,KeyboardBufferSize
.loop:
	ld (hl),0
	inc hl
	djnz .loop
	ret

; Put bits for new keys in EdgeOnKeyboardMatrixBuffer and EdgeOffKeyboardMatrixBuffer
; Save matris buffer to LastKeyboardMatrixBuffer
UpdateKeyBuffers:
	; First detect edge offs and copy last buffer
	ld hl,KeyboardMatrixBuffer
	ld de,LastKeyboardMatrixBuffer
	ld ix,EdgeOffKeyboardMatrixBuffer
	ld iy,EdgeOnKeyboardMatrixBuffer
	ld b,KeyboardBufferSize
.loop:
	ld a,(de)	; Last pressed keys
	ld c,a
	ld a,(hl)	; Currently pressed keys
	xor c
	and c
	ld (ix),a	; Off edges

	ld c,(hl)	; Currently pressed keys
	ld a,(de)       ; Last pressed keys
	xor c
	and c
	ld (iy),a	; On edges

	ld a,(hl)
	ld (de),a	; Copy currently pressed keys

	inc de
	inc hl
	inc ix
	inc iy
	djnz .loop

	ret


LastKeyboardMatrixBuffer:
	defs KeyboardBufferSize

EdgeOnKeyboardMatrixBuffer:
	defs KeyboardBufferSize
EdgeOffKeyboardMatrixBuffer:
	defs KeyboardBufferSize



KeyboardSetUpScreen:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtKeyboardTitle
	ld d,(ScreenCharsWidth - TxtTitleLen - TxtKeyboardTitleLen)/2
	call PrintTitleBanner

	ld hl,#0002
	ld (txt_coords),hl
	call SetDefaultColors

	ld hl,#0014
	ld (txt_coords),hl
	ld hl,TxtKeyboard
	call PrintString
	call NewLine
	ret


TxtKeyboardTitle: db ' - KEYBOARD TEST',0
TxtKeyboardTitleLen EQU $-TxtKeyboardTitle-1

TxtKeyboard:      db 'PRESS CONTROL+SHIFT+RETURN TO EXIT',0

 ENDMODULE