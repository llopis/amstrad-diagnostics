 INCLUDE "Config.asm"

 ;OUTPUT "build/AmstradDiag.rom"
  OUTPUT OutFile
 IFDEF PAD_TO_16K
	SIZE #4000					;; Round it up to 16 KB
 ENDIF

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
 INCLUDE "UpperROMHeader.asm"
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
 ORG #400
 ENDIF



;; COMMON
	ld ix, SoakTestIndicator
	ld (ix), 0
	ld (ix+1), 0
	ld (ix+2), 0
	ld (ix+3), 0

; This is where the Soak test loops
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

	call RAMInitialize

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
	jp 	MainMenu

.soakTest:
	ld (SoakTestCount),a
	call MarkSoakTestActive
	jp MainMenu


RAMInitialize:
	;; Copy the part of the program that can't run from ROM into RAM
	ld 	hl, RAMBlockBegin
	ld 	de, RAMProgramAddr
	ld 	bc, RAMDataEnd-RAMBegin
	ldir

	call	InitializeCRTC
	call 	MakeScrTable
	ret


	INCLUDE "MainMenu.asm"


;; This is the code that needs to be in RAM to function
RAMProgramAddr EQU #8000
RAMBlockBegin:
 DISP RAMProgramAddr
RAMBegin:
 	INCLUDE "ROMAccess.asm"
 	INCLUDE "UpperRAMC3Check.asm"
 IFDEF UpperROMBuild
 	INCLUDE "PrintChar.asm"
 	INCLUDE "Draw.asm"
 ENDIF
 IFDEF TRY_UNPAGING_LOW_ROM
 	INCLUDE "Dandanator.asm"
 	INCLUDE "M4.asm"
 ENDIF
 	INCLUDE "VariablesInitialized.asm"
RAMDataEnd:
 	;; This is just saving room in RAM, but it's not taking up any of the ROM size
 	OUTEND
 	INCLUDE "Variables.asm"
RAMEnd:
 ENT
ProgramEnd:

 
 IFDEF PRINT_PROGRAM_SIZE
	DISPLAY "Total size: ", ProgramEnd - ProgramStart - (RAMEnd - RAMDataEnd)
	DISPLAY "RAM size: ", RAMEnd - RAMBegin
 ENDIF
