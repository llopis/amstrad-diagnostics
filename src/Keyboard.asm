IsAnyKeyPressed:
	ld hl,KeyboardMatrixBuffer
	ld a,0
	ld b,10
.loop:
	or (hl)
	inc hl
	djnz .loop

	or a
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


; Special key symbols
; a = Up arrow
; b = Down arrow
; c = Left arrow
; d = Right arrow
; e = Large enter
; f = Small enter
; g = Escape
; h = Clear
; i = Delete (backspace)
; j = Tab
; k = Caps Lock
; l = Shift
; m = Control
; o = Copy

KeyboardLocations:
		;; Column, row, char
		;; 0
		defb	33,04,'a' ; # Key number 00 : ↑
		defb	35,05,'d' ; # Key number 01 : →
		defb	33,05,'b' ; # Key number 02 : ↓
		defb	35,01,'9' ; # Key number 03 : f9
		defb	35,02,'6' ; # Key number 04 : f6
		defb	35,03,'3' ; # Key number 05 : f3
		defb	25,05,'f' ; # Key number 06 : ENTER
		defb	35,04,'.' ; # Key number 07 : .

		;; 1
		defb	31,05,'c' ; # Key number 08 : ←
		defb	03,05,'o' ; # Key number 09 : COPY
		defb	31,01,'7' ; # Key number 10 : f7
		defb	33,01,'8' ; # Key number 11 : f8
		defb	33,02,'5' ; # Key number 12 : f5
		defb	31,03,'1' ; # Key number 13 : f1
		defb	33,03,'2' ; # Key number 14 : f2
		defb	31,04,'0' ; # Key number 15 : f0

		;; 2
		defb	27,01,'h' ; # Key number 16 : CLR
		defb	25,02,'[' ; # Key number 17 : {[
		defb	27,02,'e' ; # Key number 18 : RETURN
		defb	25,03,']' ; # Key number 19 : }]
		defb	31,02,'4' ; # Key number 20 : f4
		defb	01,04,'l' ; # Key number 21 : SHIFT
		;defb	25,04,'l' ; # Key number 21 : SHIFT
		defb	23,04,#5c ; # Key number 22 : `\		
		defb	01,05,'m' ; # Key number 23 : CONTROL

		;; 3
		defb	25,01,'^' ; # Key number 24 : £^
		defb	23,01,'-' ; # Key number 25 : =-
		defb	23,02,'@' ; # Key number 26 : ¦@
		defb	21,02,'P' ; # Key number 27 : P
		defb	23,03,#3b ; # Key number 28 : +;
		defb	21,03,#3a ; # Key number 29 : *:
		defb	21,04,'/' ; # Key number 30 : ?/
		defb	19,04,'.' ; # Key number 31 : >.

		;; 4
		defb	21,01,'0' ; # Key number 32 : _0
		defb	19,01,'9' ; # Key number 33 : )9
		defb	19,02,'O' ; # Key number 34 : O
		defb	17,02,'I' ; # Key number 35 : I
		defb	19,03,'L' ; # Key number 36 : L
		defb	17,03,'K' ; # Key number 37 : K
		defb	15,04,'M' ; # Key number 38 : M
		defb	17,04,',' ; # Key number 39 : <,

		;; 5
		defb	17,01,'8' ; # Key number 40 : (8
		defb	15,01,'7' ; # Key number 41 : '7
		defb	15,02,'U' ; # Key number 42 : U
		defb	13,02,'Y' ; # Key number 43 : Y
		defb	13,03,'H' ; # Key number 44 : H
		defb	15,03,'J' ; # Key number 45 : J
		defb	13,04,'N' ; # Key number 46 : N
		defb	05,05,' ' ; # Key number 47 : SPACE

		;; 6
		defb	13,01,'6' ; # Key number 48 : &6
		defb	11,01,'5' ; # Key number 49 : %5
		defb	09,02,'R' ; # Key number 50 : R
		defb	11,02,'T' ; # Key number 51 : T
		defb	11,03,'G' ; # Key number 52 : G
		defb	09,03,'F' ; # Key number 53 : F
		defb	11,04,'B' ; # Key number 54 : B
		defb	09,04,'V' ; # Key number 55 : V

		;; 7
		defb	09,01,'4' ; # Key number 56 : $4
		defb	07,01,'3' ; # Key number 57 : #3
		defb	07,02,'E' ; # Key number 58 : E
		defb	05,02,'W' ; # Key number 59 : W
		defb	05,03,'S' ; # Key number 60 : S
		defb	07,03,'D' ; # Key number 61 : D
		defb	07,04,'C' ; # Key number 62 : C
		defb	05,04,'X' ; # Key number 63 : X

		;; 8
		defb	03,01,'1' ; # Key number 64 : !1
		defb	05,01,'2' ; # Key number 65 : "2
		defb	01,01,'g' ; # Key number 66 : ESC
		defb	03,02,'Q' ; # Key number 67 : Q
		defb	01,02,'j' ; # Key number 68 : TAB
		defb	03,03,'A' ; # Key number 69 : A
		defb	01,03,'k' ; # Key number 70 : CAPSLOCK
		defb	03,04,'Z' ; # Key number 71 : Z

		;; 9
		defb	41,01,'a' ; # Key number 72 : Joystick Up
		defb	41,03,'b' ; # Key number 73 : Joystick Down
		defb	39,02,'c' ; # Key number 74 : Joystick Left
		defb	43,02,'d' ; # Key number 75 : Joystick Right
		defb	39,05,'1' ; # Key number 76 : Joystick Fire 1
		defb	41,05,'2' ; # Key number 77 : Joystick Fire 2
		defb	43,05,'3' ; # Key number 78 : Joystick Fire 3
		defb	29,01,'i' ; # Key number 79 : DEL
		