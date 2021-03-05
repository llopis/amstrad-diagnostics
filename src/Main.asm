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
	nop				; Just to be able to set the first byte of the bank in the tests
 ENDIF



;; COMMON
TestStart:
	DEFINE SOUND_DURATION #6000
	DEFINE SILENCE_DURATION #1
	DEFINE SOUND_TONE_L #FF
	DEFINE SOUND_TONE_H #00
	INCLUDE "PlaySound.asm"
	UNDEFINE SOUND_DURATION
	UNDEFINE SILENCE_DURATION
	UNDEFINE SOUND_TONE_L
	UNDEFINE SOUND_TONE_H

	xor a
	ld iyl,0
	ld ix,SoakTestIndicator		; This is out in RAM
	ld a,(ix)			; See if we can find the two bytes that tells us we're doing a soak test
	cp SoakTestByte1
	jr nz,.startTests
	ld a,(ix+1)
	cp SoakTestByte2
	jr nz,.startTests
	ld a,(SoakTestCount)
	ld a,(ix+2)
	cp SoakTestByte3
	jr nz,.startTests
	ld a,(SoakTestCount)
	ld a,(ix+3)
	cp SoakTestByte4
	jr nz,.startTests
	ld a,(SoakTestCount)
	ld iyl, a			; Remember that we're in a soak test
 IFDEF UpperROMBuild
	ld a, (UpperROMConfig)
	ld iyh, a			; Save the upper ROM config
 ENDIF
.startTests:
	INCLUDE "LowerRAMTest.asm"
RAMTestPassed:

	ld hl, MainBegin
	ld de, MainProgramAddr
	ld bc, ProgramEnd-MainBegin
	ldir

 IFDEF UpperROMBuild
	ld a,iyh			; Restore the upper ROM config to RAM
	ld (UpperROMConfig),a
 ENDIF
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
	call MarkSoakTestActive
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
