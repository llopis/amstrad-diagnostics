////// Variables
ROMStringBuffer: ds 16


CheckROMs:
	call ROMSetUpScreen
CheckROMsWithoutTitle:
	call CheckLowerROM
	call CheckUpperROMs
	ret

ROMsPrintTitle:

	
ROMSetUpScreen:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtROMTitle
	ld d,#B
	call PrintTitleBanner

	ld hl,#0002
	ld (txt_coords),hl
	call SetDefaultColors
	ret


TxtROMTitle: db '- ROM TEST',0

TxtCheckingLowerROM: db 'CHECKING LOWER ROM...',0
TxtLowerROM: db 'LOWER ROM: ',0
TxtDetectingUpperROMs: db 'DETECTING UPPER ROMS...',0
TxtROM: db 'ROM ',0
TxtColon: db ': ',0
TxtDashes: db '____',0
TxtUnknownROM: db 'UNKNOWN: ',0


//////////////////////////////////////

CheckLowerROM:
	IFDEF TRY_UNPAGING_LOW_ROM
	call DandanatorPagingStop

	; Now check if the low RAM is still there
	; Check if we see the mark DIAG, if not, skip low RAM test
	ld ix,TxtROMMark
	ld a,'D'
	cp (ix)
	ret nz
	ld a,'I'
	cp (ix+1)
	ret nz
	ld a,'A'
	cp (ix+2)
	ret nz
	ld a,'G'
	cp (ix+3)
	ret nz
	ENDIF

	ld hl,TxtCheckingLowerROM
	call PrintString
	call NewLine

	ld hl,TxtLowerROM
	call PrintString

	call CRCLowerRom
	push hl
	call PrintROMName
	ld a,' '
	call PrintChar
	ld a,'('
	call PrintChar
	pop hl
	ld a,h
	call PrintAHex
	ld a,l
	call PrintAHex
	ld a,')'
	call PrintChar
	call NewLine

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

//////////////////////////////////////


CheckUpperROMs:
	ld hl,TxtDetectingUpperROMs
	call PrintString
	call NewLine
	ld d,0
.romLoop:
	push de
	call CheckUpperROM
	pop de
	inc d
	ld a,d
	cp #10
	jr nz, .romLoop

	call NewLine
	ld hl,TxtAnyKeyMainMenu
	call PrintString

	ret


; IN D = ROM to check
CheckUpperROM:
	push de

	call SetDefaultColors
	ld hl,TxtROM
	call PrintString
	ld a,d
	call PrintAHex
	ld hl,TxtColon
	call PrintString	

	pop de
	ld a,d
	; Always do the 0 ROM
	or a
	jr z,.doIt
	call GetUpperROMType
	
	; Skip any roms of type #80 (because that's the BASIC ROM repeated in other places)
	cp #80
	jr nz, .doIt

	ld hl,TxtDashes
	call PrintString	
	call NewLine
	ret
	
.doIt:
	push de				; Save ROM index for later
	ld a, d
	call CRCRom
	pop de
	push hl

	push de
	call GetROMAddrFromCRC

	ld a,d
	or e
	jr z, .unknownROM

	call PrintROMName
	pop de
.finishROM:
	ld a,(txt_coords+1)
	inc a
	ld (txt_coords+1),a
	pop hl
	call PrintCRC
	call NewLine
	ret

.unknownROM:
	call SetErrorColors
	ld hl,TxtUnknownROM
	call PrintString

	pop de
	ld a,d
	ld de, ROMStringBuffer
	call GetROMString
	ld hl, ROMStringBuffer
	call ConvertToUpperCase7BitEnding
	ld hl, ROMStringBuffer
	call PrintString7BitEnding

	jr .finishROM


; IN HL = CRC
PrintCRC:
	ld a,'('
	call PrintChar
	ld a,h
	call PrintAHex
	ld a,l
	call PrintAHex
	ld a,')'
	call PrintChar
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
; OUT DE = ROM index or 0000 if unknown
GetROMAddrFromCRC:
	ld b, 0
	ld ix, ROMInfoTable
.loop:
	ld e,(ix)
	ld d,(ix+1)
	ld a,l
	cp e
	jr nz, .next

	ld de, ix
	ret
	
.next:
	inc ix
	inc ix
	inc ix
	inc ix
	inc b
	ld a,b
	cp ROMCount
	jr nz, .loop

	ld de,0
	ret


; IN DE = ROM address in table
PrintROMName:
	ld ix,de
	ld l,(ix+2)
	ld h,(ix+3)
	call PrintString
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
	
	ld bc,#7F8D                        ; GA deselect upper rom, and mode 1
	out (c),c
	ret


; IN HL = String
ConvertToUpperCase7BitEnding:
	ld a, (hl)
	and %01111111
	cp #61
	jr c, .skipChar
	ld a, (hl)
	sub #20
	ld (hl), a
.skipChar:
	ld a, (hl)
	inc hl
	bit 7, a
	jr z, ConvertToUpperCase7BitEnding
	ret
	
	INCLUDE "ROMTable.asm"

