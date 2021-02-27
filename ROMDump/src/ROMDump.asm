	ORG #8000
	jr DumpLowROM
	ORG #8002
	jr DumpHighROM
	ORG #8004
ROMNumber: db 0
	ORG #8005
Result: dw 0


DumpLowROM:
	di
	ld bc,#7F89                        ; GA select lower rom, and mode 1
	out (c),c

	ld hl,#0000
	ld de,#4000
	ld bc,#4000
	ldir
	
	ld bc,#7F8D                        ; GA deselect lower rom, and mode 1
	out (c),c

	ei

	ld ix,#4000
	ld de,#4000	
	call Crc16

	ld ix,Result
	ld (ix),l
	ld (ix+1),h
	ret


DumpHighROM:
	di
	ld bc,#7F85                       ; GA select upper rom, and mode 1
	out (c),c

	ld hl,ROMNumber
	ld a,(hl)
	ld bc,#df00
	out (c),a

	ld hl,#C000
	ld de,#4000
	ld bc,#4000
	ldir
	
	ld bc,#7F8D                        ; GA deselect upper rom, and mode 1
	out (c),c

	ei

	ld ix,#4000
	ld de,#4000	
	call Crc16

	ld ix,Result
	ld (ix),l
	ld (ix+1),h
	ret

; IN IX = Start address DE = Size
; OUT HL = CRC
; Based on code from from http //map.tni.nl/sources/external/z80bits.html#5.1
Crc16:
	ld hl,#FFFF
_read:
	ld	a,(ix)
	inc	ix
	xor	h
	ld	h,a
	ld	b,8
_byte:
	add	hl,hl
	jr	nc,_next
	ld	a,h
	xor	#10
	ld	h,a
	ld	a,l
	xor	#21
	ld	l,a
_next:
	djnz _byte
	dec de
	ld a,e
	or d
	jr nz,_read
	ret

