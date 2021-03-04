	INCLUDE "Config.asm"


;; *******************************
;; LOWER ROM BUILD
	IFDEF LowerROMBuild
	DISPLAY "Lower ROM build"

	ORG #0000
ProgramStart:
	INCLUDE "HardwareInit.asm"
	ENDIF


;; **********************************
;; UPPER ROM BUILD
	IFDEF UpperROMBuild
	DISPLAY "Upper ROM build"
	ORG #C000
ProgramStart:
	INCLUDE "RSXTable.asm"
	ENDIF


;; *******************************
;; CARTRIDGE BUILD
	IFDEF CartridgeBuild
	DISPLAY "Lower ROM build"

	ORG #0000
ProgramStart:
	INCLUDE "CartridgeHeader.asm"
	INCLUDE "HardwareInit.asm"
	ENDIF



;; **********************************
;; RAM BUILD
	IFDEF RAMBuild
	DISPLAY "RAM build"
	ORG #4000

	ENDIF



;; COMMON
	DEFINE SOUND_DURATION #6000
	DEFINE SILENCE_DURATION #1
	DEFINE SOUND_TONE_L #FF
	DEFINE SOUND_TONE_H #00
	INCLUDE "PlaySound.asm"
	UNDEFINE SOUND_DURATION
	UNDEFINE SILENCE_DURATION
	UNDEFINE SOUND_TONE_L
	UNDEFINE SOUND_TONE_H

SoakTestStart:
	ld iy,0
	ld ix,SoakTestIndicator		; This is out in RAM
	ld a,(ix)			; See if we can find the two bytes that tells us we're doing a soak test
	cp SoakTestByte1
	jr nz,.startTests
	ld a,(ix+1)
	cp SoakTestByte2
	jr nz,.startTests
	ld a,(SoakTestCount)
	ld iyl,a			; Remember that we're in a soak test
.startTests:
	INCLUDE "LowerRAMTest.asm"
RAMTestPassed:

	ld hl, MainBegin
	ld de, MainProgramAddr
	ld bc, ProgramEnd-MainBegin
	ldir

	ld a,iyl
	or a
	jp nz,.soakTest

	DEFINE SOUND_DURATION #4000
	DEFINE SILENCE_DURATION #1000
	DEFINE SOUND_TONE_L #A0
	DEFINE SOUND_TONE_H #00
	INCLUDE "PlaySound.asm"

	INCLUDE "PlaySound.asm"
	jp MainMenu

.soakTest:
	ld (SoakTestCount),a
	ld ix, SoakTestIndicator
	ld (ix), SoakTestByte1
	ld (ix+1), SoakTestByte2	
	jp MainMenu




TxtROMMark:
	db 'DIAG'

MainProgramAddr EQU #8000
MainBegin:
	DISP MainProgramAddr
	INCLUDE "MainMenu.asm"
	ENT
ProgramEnd:
	IFDEF PAD_TO_16K
		ds (ProgramStart+#4000)-ProgramEnd		;; Round it up to 16 KB
	ENDIF

	IFDEF PRINT_PROGRAM_SIZE
		DISPLAY "Program size: ", ProgramEnd - ProgramStart
	ENDIF