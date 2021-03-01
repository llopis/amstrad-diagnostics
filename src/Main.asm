	INCLUDE "Config.asm"

	MACRO PADORG addr
		; add padding
		IF $ < addr
		BLOCK addr-$
		ENDIF
		ORG addr
	ENDM


;; *******************************
;; LOWER ROM BUILD
	IFDEF LowerROMBuild
	DISPLAY "Lower ROM build"
	INCLUDE "HardwareInit.asm"

TestStartAddress EQU #4000
TestAmount EQU #C000
	INCLUDE "LowerRAMTest.asm"

	ENDIF


;; **********************************
;; UPPER ROM BUILD
	IFDEF UpperROMBuild
	DISPLAY "Upper ROM build"
	ORG #C000
	INCLUDE "RSXTable.asm"

TestStartAddress EQU #0000
TestAmount EQU #C000
	INCLUDE "LowerRAMTest.asm"

	ENDIF



;; **********************************
;; RAM BUILD
	IFDEF RAMBuild
	DISPLAY "RAM build"
	ORG #4000
TestStartAddress EQU #C000
TestAmount EQU #4000
	INCLUDE "LowerRAMTest.asm"

	ENDIF



;; COMMON

RAMTestPassed:
	ld hl, MAINBEGIN
	ld de, MainProgramAddr
	ld bc, ENDOFPROG-MAINBEGIN
	ldir
	jp MainTests

MainProgramAddr EQU #8000
MAINBEGIN:
	DISP MainProgramAddr
	INCLUDE "MainTests.asm"
	ENT
ENDOFPROG:
	IFDEF DandanatorSupport
		ds 16384-ENDOFPROG		;; Round it up to 16 KB
	ENDIF
