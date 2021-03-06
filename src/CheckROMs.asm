 MODULE ROMTEST


@CheckROMs:
	call ROMSetUpScreen
@CheckROMsWithoutTitle:
	call CheckLowerROM
	call CheckUpperROMs

	call SetDefaultColors
	call NewLine
	ld hl,TxtAnyKeyMainMenu
	call PrintString
	ret

ROMSetUpScreen:
	ld d, 0
	call ClearScreen
	ld a, 4
	call SetBorderColor 

	ld hl,TxtROMTitle
	ld d,(ScreenCharsWidth - TxtTitleLen - TxtROMTitleLen)/2
	call PrintTitleBanner

	ld hl,#0002
	ld (TxtCoords),hl
	call SetDefaultColors
	ret


TxtROMTitle: db ' - ROM TEST',0
TxtROMTitleLen EQU $-TxtROMTitle-1


TxtCheckingLowerROM: db 'CHECKING LOWER ROM...',0
TxtLowerROM: db 'LOWER ROM: ',0
TxtDetectingUpperROMs: db 'DETECTING UPPER ROMS...',0
TxtColon: db ': ',0
TxtDashes: db '----',0
TxtUnknownROM: db 'UNKNOWN: ',0
TxtAmsDiagROM: db 'AMSTRAD DIAG (THIS ROM)',0


//////////////////////////////////////

CheckLowerROM:
	IFDEF TRY_UNPAGING_LOW_ROM
	call CanAccessLowROM
	ret z

	ENDIF

	ld hl,TxtCheckingLowerROM
	call PrintString
	call NewLine

	ld hl,TxtLowerROM
	call PrintString

	call CRCLowerRom
	push hl
	call GetROMAddrFromCRC

	ld a,d
	or e
	jr z, .unknownROM

	call PrintROMName
.finishROM:
	ld hl, txt_x
	inc (hl)
	pop hl
	call PrintCRC

	call NewLine
	call NewLine
	ret

.unknownROM:
	call SetErrorColors
	ld hl,TxtUnknownROM
	call PrintString
	jr .finishROM



//////////////////////////////////////


CheckUpperROMs:
	ld hl, TxtDetectingUpperROMs
	call PrintString
	call NewLine
	ld d,0
.romLoop:
	call SetDefaultColors
	push de
 IFDEF UpperROMBuild
	ld a,(UpperROMConfig)
	cp d
	jr z, .thisROM
 ENDIF
	call CheckUpperROM

.finishLoop
	pop de
	inc d
	ld a,d
	cp #10
	jr nz, .romLoop

	ret

 IFDEF UpperROMBuild
.thisROM:
	ld hl,TxtROM
	call PrintString
	ld a,d
	call PrintAHex
	ld hl,TxtColon
	call PrintString

	ld hl,TxtAmsDiagROM
	call PrintString
	call NewLine
	jr .finishLoop
 ENDIF


; IN D = ROM to check
CheckUpperROM:
	push de

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
	call CRCUpperRom
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
	ld hl, txt_x
	inc (hl)
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
	ld a,h
	cp d
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

 ENDMODULE
