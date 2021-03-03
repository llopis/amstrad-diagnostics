
KEYBOARD_Y EQU #06

TestKeyboard:
		call KeyboardSetUpScreen
		call ClearKeyPresses
		call	PrintKeyboard
		call ClearKeyPresses
		ret

ClearKeyPresses:
		ld	hl, KeyboardMatrixBufferPerm	; clear all previous keypresses
		ld	b,10
ClearKeypressesLoop:
		ld	(hl), 0
		inc	hl
		djnz	ClearKeypressesLoop

PrintKeyboard:
		ld	a, (KeyboardMatrixBuffer+2)	; check row 2 (keys 16-23)
		cp	#a4				; for ctrl+shift+enter %c0s0 0e00 = #A4
		jr	nz, PrintKeyboardContinue
		ret
PrintKeyboardContinue:
		ld	b,80
		ld	hl,KeyboardLocations
PrintKeyboardLoop:
		ld	d,(hl) ; text column
		dec	d
		inc	hl
		ld	e,(hl) ; text row
		ld	a,KEYBOARD_Y
		add	e
		ld	e,a
		ld	(txt_coords),de

		push	bc
		push	hl
		call	ReadFullKeyboard
		pop	hl
		pop	bc

		push	bc
		push	hl
		call	SetKeyColor
		pop	hl
		pop	bc

		inc	hl
		ld	a,(hl)
		inc	hl
		push	hl
		push	bc
		call	PrintChar
		pop	bc
		pop	hl
		djnz	PrintKeyboardLoop
		ld	hl,#0010
		ld	(txt_coords),hl
		jr	PrintKeyboard
SetKeyColor:
		ld	a,80
		sub	b		; Get key number
		ld	hl,KeyboardMatrixBufferPerm
		ld	c,a
		sra	a
		sra	a
		sra	a		; Divide by 8
		ld	e,a
		ld	d,0
		add	hl,de		; Find matrix address for row
		ld	a,c
		and	%00000111	; Find relevant bit
		sll	a
		sll	a
		sll	a		; prepration for bit manipulation
		or	%01000110	; the second part of the BIT 0, (HL) opcode
		ld	(TestBitDirtyHack+1),a ; !!!
		ld	a,(hl)
TestBitDirtyHack:
		bit	0,(hl)
		jr	z,KeyNormalColor
		ld	hl,#0800
		call	set_txt_colours
		jr	KeyColorsDone
KeyNormalColor:
		ld	hl,#0008
		call	set_txt_colours
KeyColorsDone:
		ret


KeyboardSetUpScreen:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,#0000
	ld (txt_coords),hl
	call SetTitleColors
	ld hl,TxtKeyboardTitle
	call PrintString

	ld hl,#0002
	ld (txt_coords),hl
	call SetDefaultColors

	ld hl,#0014
	ld (txt_coords),hl
	ld hl,TxtKeyboard
	call PrintString
	call NewLine
	ret


TxtKeyboardTitle: db '       AMSTRAD DIAGNOSTICS - KEYBOARD TEST          ',0
TxtKeyboard:      db 'PRESS CONTROL+SHIFT+RETURN TO EXIT',0
