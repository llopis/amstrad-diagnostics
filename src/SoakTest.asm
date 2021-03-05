
SoakTestByte1 EQU 'S'
SoakTestByte2 EQU 'O'
SoakTestByte3 EQU 'A'
SoakTestByte4 EQU 'K'

SoakTestIndicator: ds 4				; Save 4 bytes
SoakTestCount: db 0
 IFDEF UpperROMBuild
UpperROMConfig: db 0				; Here we store the upper ROM we were launched from
 ENDIF

IsSoakTestRunning:
	ld ix, SoakTestIndicator		
	ld b,4

	ld a,(ix)
	cp SoakTestByte1
	ret nz
	ld a,(ix+1)
	cp SoakTestByte2
	ret nz
	ld a,(ix+2)
	cp SoakTestByte3
	ret nz
	ld a,(ix+3)
	cp SoakTestByte4
	ret nz

	ret	

SoakTestSelected:
	call MarkSoakTestActive
	ld a,(SoakTestCount)
	inc a
	ld (SoakTestCount),a

 IFDEF ROM_CHECK
	call SoakTestPrintTitle
	call CheckROMsWithoutTitle
 ENDIF
	call SoakTestPrintTitle
	call CheckUpperRAMWithoutTitle
	; Check if upper RAM test failed and if so stop
	ld a, (FailingBits)
	or a
.infiniteLoop:
	jr nz, .infiniteLoop

	; Everything passed, so add a delay and do it over
	ld hl, #FFFF
.delay:
	dec hl
	ld a, h
	or l
	jr nz, .delay

 IFDEF LowerROMBuild
	call DandanatorPagingStart
	ld bc,#7F89                        ; GA select lower rom, and mode 1
	out (c),c
 ENDIF
 IFDEF UpperROMBuild
	ld bc,#7F85                        ; GA select upper rom, and mode 1
	out (c),c
 	ld bc,#df00
 	ld a,(UpperROMConfig)
	out (c),a
 ENDIF
	jp TestStart


MarkSoakTestActive:
	ld ix, SoakTestIndicator
	ld (ix), SoakTestByte1			; Set those byte to indicate soak test
	ld (ix+1), SoakTestByte2
	ld (ix+2), SoakTestByte3
	ld (ix+3), SoakTestByte4
	ret


SoakTestPrintTitle:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtSoakTestTitle
	ld d,#6
	call PrintTitleBanner

	ld hl,#2B00
	ld (txt_coords),hl
	ld a, (SoakTestCount)
	call PrintADec

	call SetDefaultColors
	ld hl,#0002
	ld (txt_coords),hl

	ret


TxtSoakTestTitle: db '- SOAK ITERATION ',0
