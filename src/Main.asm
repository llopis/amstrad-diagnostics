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


;; **********************************
;; RAM BUILD
	IFDEF RAMBuild
	DISPLAY "RAM build"
	ORG #4000
	ENDIF



;; COMMON

	INCLUDE "LowerRAMTest.asm"
RAMTestPassed:
	ld hl, MainBegin
	ld de, MainProgramAddr
	ld bc, ProgramEnd-MainBegin
	ldir
	jp MainTests

MainProgramAddr EQU #8000
MainBegin:
	DISP MainProgramAddr
	INCLUDE "MainTests.asm"
	ENT
ProgramEnd:
	IFDEF PAD_TO_16K
		ds (ProgramStart+#4000)-ProgramEnd		;; Round it up to 16 KB
	ENDIF

	IFDEF PRINT_PROGRAM_SIZE
		DISPLAY "Program size: ", ProgramEnd - ProgramStart
	ENDIF