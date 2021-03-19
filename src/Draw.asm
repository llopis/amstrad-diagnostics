 MODULE DRAW


LINE_PATTERN EQU %11110000


;; IN: 	HL - x in pixels
;;     	E - y in pixels
;;     	B - width in pixels
;;	A - fill patter
;; Doesn't work for line smaller than 1 byte
@DrawHorizontalLine:
 IFDEF UpperROMBuild	
 	; Disable upper ROM so we can read from the screen
 	push	bc
	ld 	bc, #7F00 + %10001101
	out 	(c),c
	pop	bc
 ENDIF
	ld	d, a				; D = fill pattern
	ld	a, l
	and	%00000011
	or	a
	push	af
	call	GetScreenAddress		; HL = screen address
	pop	af
	jr	z, .byteBoundary

	;; Draw initial header of pixels between 1 and 3 pixels
	call	GetHorizMaskAndUpdateCount
	push	bc
	ld	b, a				; B = pixel mask
	ld	a, (hl)				; A = contents of screen
	and	b				; A = masked contents
	ld	c, a				; C = masked contents
	ld	a, b				; A = pixel mask
	xor	#FF				; A = inverse mask
	ld	b, d
	and	b				; A = bits to add to screen
	or	c				; A = combined bits and what was there before 
	ld	(hl), a
	inc	hl
	pop	bc

.byteBoundary:
	ld	a, d
	push	bc
	srl	b				; B = number of bytes (pixels / 4)
	srl	b

	;; Draw main body of the line
.loop:
	ld	(hl), a
	inc	hl
	djnz 	.loop

	pop	bc				; B = number of pixels to draw 
	ld	a, b
	and	%00000011			; A = amount of pixels to draw to finish line
	or	a
	jr	z, .end

	;; Draw final tail of pixels between 1 and 3
	call	GetHorizEndMask
	ld	b, a
	ld	a, (hl)				; A = contents of screen
	and	b				; A = masked contents
	ld	c, a				; C = masked contents
	ld	a, b				; A = pixel mask
	xor	#FF				; A = inverse mask
	ld	b, d
	and	b				; A = bits to add to screen
	or	c				; A = combined bits and what was there before 
	ld	(hl), a

.end:
 IFDEF UpperROMBuild
 	push	bc
	ld 	bc, RESTORE_ROM_CONFIG
	out 	(c),c
	pop	bc
 ENDIF
	ret

;; IN: 	A - Pixel to start drawing line (1-3)
;;	B - number of pixels to draw
;; OUT: A - bit mask to draw a line from there to the right
;;	B - updated
GetHorizMaskAndUpdateCount:
	bit	0, a
	jr	z, .two
	bit	1, a
	jr	z, .three
.one:
	dec	b
	ld	a, %11101110
	ret
.two:
	dec	b
	dec	b
	ld	a, %11001100
	ret
.three:
	dec	b
	dec	b
	dec	b
	ld	a, %10001000
	ret


GetHorizEndMask:
	bit	0, a
	jr	z, .two
	bit	1, a
	jr	nz, .three
.one:
	ld	a, %01110111
	ret
.two:
	ld	a, %00110011
	ret
.three:
	ld	a, %00010001
	ret


;; IN: HL - x in pixels
;;     E - y in pixels
;;     B - width in bytes
@DrawVerticalLine:
 IFDEF UpperROMBuild	
 	; Disable upper ROM so we can read from the screen
 	push	bc
	ld 	bc, #7F00 + %10001101
	out 	(c),c
	pop	bc
 ENDIF
	call	GetVerticalMask
	ld	c, a			; C = mask for pixels on screen
	xor	#FF
	and	LINE_PATTERN
	ld	d, a			; D = bites to draw
.loop:
	push	hl
	push	de
	call	GetScreenAddress
	ld	a, (hl)
	and	c
	or	d
	ld	(hl), a
	pop	de
	pop	hl
	inc	e
	djnz 	.loop

 IFDEF UpperROMBuild
 	push	bc
	ld 	bc, RESTORE_ROM_CONFIG
	out 	(c),c
	pop	bc
 ENDIF
	ret


;; IN	L - LSB of x position in pixels
;; OUT	A - mask
GetVerticalMask:
	push	hl
	push	de
	ld	a, l
	and	%00000011
	ld	d, 0
	ld 	e, a
	ld	hl, VerticalMaskTable
	add	hl, de
	ld	a, (hl)
	pop	de
	pop	hl
	ret

VerticalMaskTable:
	db %01110111
	db %10111011
	db %11011101
	db %11101110


;; IN: HL - x in pixels
;;     E - y in pixels
;; OUT: HL - address
GetScreenAddress:
	push	de
	push	hl
	ld	h,0
	ld	l,e
	add 	hl, hl
	ld 	de, scr_table
	add 	hl, de
	ld 	a, (hl)
	inc 	hl
	ld 	h, (hl)
	ld 	l, a
	pop	de

	srl	d
	rr	e
	srl	d
	rr	e

	add	hl, de
	pop	de
	ret


 ENDMODULE
