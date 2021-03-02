
	IFDEF ROM_CHECK
DetectROMs:
	call ROMSetUpScreen

	ld hl,TxtDetecting
	call PrintString
	call NewLine
	
	; Stop paging mode in Dandanator so system lower ROM is accessible
	ld b,#20
	ld iy,ScratchByte
	db #FD, #FD
	ld (iy+0),b

	; Now check if the low RAM is still there
	; Check if we see the mark DIAG, if not, skip low RAM test
	ld ix,TxtROMMark
	ld a,'D'
	cp (ix)
	jr nz, .startUpperROMCheck
	ld a,'I'
	cp (ix+1)
	jr nz, .startUpperROMCheck
	ld a,'A'
	cp (ix+2)
	jr nz, .startUpperROMCheck
	ld a,'G'
	cp (ix+3)
	jr nz, .startUpperROMCheck

	call CheckLowerROM
	
.startUpperROMCheck:
	ld d,0
	call CheckUpperROM
	ld d,7
	call CheckUpperROM
	ret
	

ROMSetUpScreen:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,#0000
	call SetTextCoords
	call SetTitleColors
	ld hl,TxtROMTitle
	call PrintString

	ld hl,#0002
	call SetTextCoords
	call SetDefaultColors
	ret


TxtROMTitle: db '          AMSTRAD DIAGNOSTICS - ROM TEST             ',0

TxtDetecting: db 'DETECTING ROMS...',0
TxtLowerROM: db 'LOWER ROM: ',0
TxtROM: db 'ROM ',0
TxtColon: db ': ',0
ScratchByte: db 0

CheckLowerROM:
	ld hl,TxtLowerROM
	call PrintString

	call CRCLowerRom
	push hl
	call PrintROMName
	ld a,CharSpace
	call PrintChar
	ld a,CharLeftParen
	call PrintChar
	pop hl
	ld a,h
	call PrintNumHex
	ld a,l
	call PrintNumHex
	ld a,CharRightParen
	call PrintChar
	call NewLine
	ret


CRCLowerRom:
	ld bc,#7F89                        ; GA select lower rom, and mode 1
	out (c),c

	ld ix,#0000
	ld de,#4000	
	call Crc16
	
	ld bc,#7F8D                        ; GA deselect lower rom, and mode 1
	out (c),c
	
	ret


; IN D = ROM to check
CheckUpperROM:
	ld a,d
	call GetUpperROMType
	
	; Skip any roms of type #80 that are not the 0 ROM
	cp #80
	jr nz,.doIt
	ld a,d
	or a
	jr z,.doIt
	ret
	
.doIt:
	ld hl,TxtROM
	call PrintString
	ld a,d
	call PrintNumHex
	ld hl,TxtColon
	call PrintString	
	ld a,d
	call CRCRom
	push hl
	call PrintROMName

	ld a,CharSpace
	call PrintChar
	ld a,CharLeftParen
	call PrintChar
	pop hl
	ld a,h
	call PrintNumHex
	ld a,l
	call PrintNumHex
	ld a,CharRightParen
	call PrintChar
	call NewLine
	ret


; IN A = ROM number to read
; OUT A = ROM Type
GetUpperROMType:
	ld bc,#7F85                        ; GA select upper rom, and mode 1
	out (c),c

	ld bc,#df00
	out (c),a
	
	ld a,(#C000)
	
	ld bc,#7F8D                        ; GA deselect upper rom, and mode 1
	out (c),c
	
	ret

; IN A = ROM number to read
; OUT HL = CRC
;     A = ROM Type
CRCRom:
	ld bc,#7F85                        ; GA select upper rom, and mode 1
	out (c),c

	ld bc,#df00
	out (c),a
	
	ld ix,#C000
	ld de,#4000	
	call Crc16
	
	ld a,(#C000)
	
	ld bc,#7F8D                        ; GA deselect upper rom, and mode 1
	out (c),c
	
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


; IN HL = CRC
PrintROMName:
	ld b,ROMCount
	ld ix,ROMInfoTable
	
.loop:
	ld e,(ix)
	ld d,(ix+1)
	ld a,l
	cp e
	jr nz, .next

	ld a,h
	cp d
	jr nz, .next
	ld l,(ix+2)
	ld h,(ix+3)
	call PrintString
	ret
	
.next:
	inc ix
	inc ix
	inc ix
	inc ix
	djnz .loop
	
	ld hl,TxtUnknownROM
	call PrintString
	ret
	
	INCLUDE "ROMTable.asm"

	ENDIF
