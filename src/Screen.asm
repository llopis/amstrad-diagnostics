
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
	; TODO Set ink colors here once we load from ROM

	ld h,pen0
	ld l,pen1
	call set_txt_colours
	ret
	

