
SoakTestByte1 EQU #BE
SoakTestByte2 EQU #EF
SoakTestIndicator: db 0,0
SoakTestCount: db 0

IsSoakTestRunning:
	ld ix,SoakTestIndicator		
	ld a,(ix)
	cp SoakTestByte1
	ret nz
	ld a,(ix+1)
	cp SoakTestByte2
	ret nz
	ret	

SoakTestSelected:
	ld ix, SoakTestIndicator
	ld (ix), SoakTestByte1			; Set those byte to indicate soak test
	ld (ix+1), SoakTestByte2
	ld a,(SoakTestCount)
	inc a
	ld (SoakTestCount),a

	call SoakTestPrintTitle
	call CheckUpperRAMWithoutTitle
	ld hl, #FFFF
.delay:
	dec hl
	ld a, h
	or l
	jr nz, .delay

	ld bc,#7F89                        ; GA select lower rom, and mode 1
	out (c),c
	jp SoakTestStart


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


	ret


TxtSoakTestTitle: db '- SOAK ITERATION ',0
