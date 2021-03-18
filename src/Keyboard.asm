IsAnyKeyPressed:
	ld 	hl, EdgeOnKeyboardMatrixBuffer
	ld 	a, 0
	ld 	b, 10
.loop:
	or 	(hl)
	inc 	hl
	djnz 	.loop

	or 	a
	ret

ReadFullKeyboard:
; code from http://cpctech.cpc-live.com/source/keyboard.html

;; This example shows the correct method to read the keyboard and
;; joysticks on the CPC, CPC+ and KC Compact.
;;
;; This source is compatible with the CPC+.
;;
;; The following is assumed before executing of this algorithm:
;; - I/O port A of the PSG is set to input,
;; - PPI Port A is set to output
;;

;;--------------------------------------------------------------------------------
;; example code showing how to use read_matrix.

;; wait for vsync
		ld	b,#f5
; WaitFrameFlyback:
; 		in	a,(c)
; 		rra
; 		jr	nc,WaitFrameFlyback

;;--------------------------------------------------------------------------------

	ld	hl,KeyboardMatrixBuffer	; buffer to store matrix data

	ld	bc,#f40e		; write PSG register index (14) to PPI port A (databus to PSG)
	out	(c),c

	ld	b,#f6
	in	a,(c)
	and	#30
	ld	c,a

	or	#C0			; bit 7=bit 6=1 (PSG operation: write register index)
	out	(c),a			; set PSG operation -> select PSG register 14

	;; at this point PSG will have register 14 selected.
	;; any read/write operation to the PSG will act on this register.

	out	(c),c			; bit 7=bit 6=0 (PSG operation: inactive)

	inc	b
	ld	a,#92
	out	(c),a			; write PPI control: port A: input, port B: input, port C upper: output
					; port C lower: output
	push	bc
	set	6,c			; bit 7=0, bit 6=1 (PSG operation: read register data)

ScanKey:
	ld	b,#f6
	out	(c),c			;set matrix line & set PSG operation

	ld	b,#f4			;PPI port A (databus to/from PSG)
	in	a,(c)			;get matrix line data from PSG register 14

	cpl				;invert data: 1->0, 0->1
					;if a key/joystick button is pressed bit will be "1"
					;keys that are not pressed will be "0"

	ld	(hl),a			;write line data to buffer
	inc	hl			;update position in buffer
	inc	c			;update line

	ld	a,c
	and	#0f
	cp	#0a			;scanned all rows?
	jr	nz,ScanKey		;no loop and get next row

	;; scanned all rows
	pop	bc

	ld	a,#82			;write PPI Control: Port A: Output, Port B: Input, Port C upper: output, Port C lower: output.
	out	(c),a

	dec	b
	out	(c),c			;set PSG operation: bit7=0, bit 6=0 (PSG operation: inactive)

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

