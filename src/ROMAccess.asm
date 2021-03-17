
;; This code needs to be relocated to RAM. It will NOT work from ROM

;; OUT: Z if we can access a low ROM other than diagnostics
 IFDEF TRY_UNPAGING_LOW_ROM
CanAccessLowROM:
	call M4DisableLowerROM
	call DandanatorDisableLowerROM
	; Now check if the low RAM is still there
	; Check if we see the mark DIAG, if not, skip low ROM test
	ld ix,TxtTitle
	ld a,'D'
	cp (ix+8)
	jr nz,.exit
	ld a,'I'
	cp (ix+9)
	jr nz,.exit
	ld a,'A'
	cp (ix+10)
	jr nz,.exit
	ld a,'G'
	cp (ix+11)

.exit:
	push af
	call M4EnableLowerROM
	call DandanatorEnableLowerROM	
	pop af
	ret
 ENDIF



; OUT HL = CRC
CRCLowerRom:
 IFDEF TRY_UNPAGING_LOW_ROM
	call M4DisableLowerROM
	call DandanatorDisableLowerROM
 ENDIF
	ld bc,#7F89                        ; GA select lower rom, and mode 1
	out (c),c
	ld ix,#0000
	ld de,#4000	
	call Crc16
	
	ld bc, RESTORE_ROM_CONFIG
	out (c),c

 IFDEF TRY_UNPAGING_LOW_ROM
	push hl
	call M4EnableLowerROM
	call DandanatorEnableLowerROM	
	pop hl
 ENDIF
	ret


; IN A = ROM number to read
; OUT HL = CRC
CRCUpperRom:
	ld bc,#7F85                        ; GA select upper rom, and mode 1
	out (c),c

	ld bc,#df00
	out (c),a
	
	ld ix,#C000
	ld de,#4000	
	call Crc16
		
 	call RestoreROMState	
	ret


; IN IX = Start address DE = Size
; OUT HL = CRC
; Based on code from from http //map.tni.nl/sources/external/z80bits.html#5.1
Crc16:
	ld hl,#FFFF
.read:
	ld	a,(ix)
	inc	ix
	xor	h
	ld	h,a
	ld	b,8
.byte:
	add	hl,hl
	jr	nc,.next
	ld	a,h
	xor	#10
	ld	h,a
	ld	a,l
	xor	#21
	ld	l,a
.next:
	djnz .byte
	dec de
	ld a,e
	or d
	jr nz,.read
	ret



; IN A = ROM number to read
; OUT A = ROM Type
GetUpperROMType:
	ld bc,#7F85                        ; GA select upper rom, and mode 1
	out (c),c
	ld bc,#df00
	out (c),a
	
	ld a,(#C000)

 	call RestoreROMState
	ret


; IN A = ROM number to read
;    DE = Destination buffer
GetROMString:
	ld bc,#7F85                        ; GA select upper rom, and mode 1
	out (c),c
	ld bc,#df00
	out (c),a
	
	ld ix, #C000
	ld l, (ix+4)
	ld h, (ix+5)
.loop:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	bit 7,a
	jr z, .loop
	
 	call RestoreROMState
	ret


RestoreROMState:
	ld bc, RESTORE_ROM_CONFIG
	out (c),c
 IFDEF UpperROMBuild
 	push af
 	ld bc,#df00
 	ld a, (UpperROMConfig)
	out (c),a
	pop af
 ENDIF
 	ret
