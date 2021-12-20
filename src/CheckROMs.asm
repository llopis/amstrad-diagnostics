 MODULE ROMTEST


@CheckROMs:
	call ROMSetUpScreen
@CheckROMsWithoutTitle:
	ld	a, TESTRESULT_UNTESTED
	ld	(TestResultTableLowerROM), a
	ld	(TestResultTableUpperROM), a

	call 	CheckLowerROM
	call 	NewLine
	call 	CheckUpperROMs
	call 	NewLine

	call 	SetDefaultColors
	ld 	hl,TxtAnyKeyMainMenu
	call 	PrintString
	ret

ROMSetUpScreen:
	ld 	d, 0
	call 	ClearScreen
	ld 	a, 4
	call 	SetBorderColor 

	ld 	hl,TxtROMTitle
	ld 	d,(ScreenCharsWidth - TxtTitleLen - TxtROMTitleLen)/2
	call 	PrintTitleBanner

	ld 	hl,#0002
	ld 	(TxtCoords),hl
	call 	SetDefaultColors
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
TxtCantAccessLowerROM: db "CAN'T ACCESS SYSTEM LOWER ROM",0


//////////////////////////////////////

CheckLowerROM:
 IFDEF TRY_UNPAGING_LOW_ROM
	call 	CanAccessLowROM
	jr 	nz, .continueLowerROM

	;; Remember failure
	ld	a, TESTRESULT_NOTAVAILABLE
	ld	(TestResultTableLowerROM), a

	ld 	hl,TxtCantAccessLowerROM
	call 	PrintString
	call 	NewLine
	ret
 ENDIF

.continueLowerROM:
	ld hl,TxtCheckingLowerROM
	call PrintString
	call NewLine

	ld hl,TxtLowerROM
	call PrintString

	call CRCLowerRom
	push hl
	call GetROMAddrFromCRC

	or a
	jr z, .unknownROM

	call 	PrintROMName

	;; Remember success
	ld	a, TESTRESULT_PASSED
	ld	(TestResultTableLowerROM), a

.finishROM:
	ld hl, txt_x
	inc (hl)
	pop hl
	call PrintCRC

	call NewLine
	ret

.unknownROM:
	;; Remember failure
	ld	a, TESTRESULT_FAILED
	ld	(TestResultTableLowerROM), a

	call 	SetErrorColors
	ld 	hl,TxtUnknownROM
	call 	PrintString
	jr 	.finishROM



//////////////////////////////////////


CheckUpperROMs:
	ld	a, TESTRESULT_PASSED
	ld	(TestResultTableUpperROM), a

	call	SetDefaultColors
	ld 	hl, TxtDetectingUpperROMs
	call 	PrintString
	call 	NewLine
	ld 	d, 0		;; D = ROM number
.romLoop:
	call 	SetDefaultColors
	push 	de
 IFDEF UpperROMBuild
	ld 	a, (UpperROMConfig)
	cp 	d
	jr 	z, .thisROM
 ENDIF
	call 	CheckUpperROM
	or	a		;; A = result
	jr	nz, .nextROM

	;; Failed, but only fail the test if ROM 0 fails, the others we can ignore
	pop	de		;; D = ROM number
	push	de
	ld	a, d
	or	a
	jr	nz, .nextROM

	;; It was ROM 0 and it failed, so mark it as failed
	ld	a, TESTRESULT_FAILED
	ld	(TestResultTableUpperROM), a

.nextROM:
	pop 	de
	inc 	d
	ld 	a,d
	cp 	#10
	jr 	nz, .romLoop

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
	jr .nextROM
 ENDIF


;; IN 	D = ROM to check
;; OUT	A = 1 known, 0 unknown
CheckUpperROM:
	push 	de

	ld 	hl,TxtROM
	call 	PrintString
	ld 	a,d
	call 	PrintAHex
	ld 	hl,TxtColon
	call 	PrintString	

	pop 	de
	ld 	a,d
	; Always do the 0 ROM
	or 	a
	jr 	z,.doIt
	call 	GetUpperROMType
	
	; Skip any roms of type #80 (because that's the BASIC ROM repeated in other places)
	cp 	#80
	jr 	nz, .doIt

	ld 	hl, TxtDashes
	call 	PrintString	
	call 	NewLine
	ld	a, 1
	ret
	
.doIt:
	push 	de				; Save ROM index for later
	ld 	a, d
	call 	CRCUpperRom
	pop 	de
	push 	hl				; Save CRC

	push 	de				; Save ROM index
	call 	GetROMAddrFromCRC
	or 	a
	jr 	z, .unknownROM

	call 	PrintROMName
	ld	a, 1
	pop 	de

.finishROM:
	ld 	hl, txt_x
	inc 	(hl)
	pop 	hl
	push	af				;; Preserve A, which is the return value
	call 	PrintCRC
	call 	NewLine
	pop	af
	ret

.unknownROM:
	call 	SetErrorColors
	ld 	hl,TxtUnknownROM
	call 	PrintString

	pop 	de
	ld 	a,d
	ld 	de, ROMStringBuffer
	call 	GetROMString
	ld 	hl, ROMStringBuffer
	call 	ConvertToUpperCase7BitEnding
	ld 	hl, ROMStringBuffer
	call 	PrintString7BitEnding

	ld	a,0
	;;push	af

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
; OUT DE = ROM index and A = 1 or A = 0 if unknown
GetROMAddrFromCRC:
	ld 	b, 0
	ld 	ix, ROMInfoTable
.loop:
	ld 	e, (ix)
	ld 	d, (ix+1)
	ld 	a, l
	cp 	e
	jr 	nz, .next
	ld 	a, h
	cp 	d
	jr 	nz, .next

	ld 	de, ix
	ld 	a, 1
	ret
	
.next:
	inc 	ix
	inc 	ix
	inc 	ix
	inc 	ix
	inc 	b
	ld 	a, b
	cp 	ROMCount
	jr 	nz, .loop

	ld 	a, 0
	ret


; IN DE = ROM address in table
PrintROMName:
	ld 	ix, de
	ld 	l, (ix+2)
	ld 	h, (ix+3)
	call 	PrintString
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
