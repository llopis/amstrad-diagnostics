
ClearScreen:
	ld hl,#C000
	ld de,#C001
	ld bc,#4000
	ld (hl),0
	ldir
	ret
	

;; nibbles swapped!
pen0 equ %00000000
pen1 equ %00001000
pen2 equ %10000000
pen3 equ %10001000

SetTitleColors:
	ld h,pen2
	ld l,pen0
	call set_txt_colours
	ret
	

SetDefaultColors:
	ld h,pen0
	ld l,pen1
	call set_txt_colours
	ret

SetErrorColors:
	ld h,pen0
	ld l,pen3
	call set_txt_colours
	ret

SetSuccessColors:
	ld h,pen0
	ld l,pen2
	call set_txt_colours
	ret
	

; IN A = color
SetBorderColor:
	ld bc,#7F10
	out (c),c
	ld bc,#7F00
	add a,#40
	out (c),a
	ret
