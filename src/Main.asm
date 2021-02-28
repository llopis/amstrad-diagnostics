	INCLUDE "Config.asm"

	MACRO PADORG addr
		; add padding
		IF $ < addr
		BLOCK addr-$
		ENDIF
		ORG addr
	ENDM

	IFNDEF UpperROM
		INCLUDE "HardwareInit.asm"
	ELSE
		ORG #C000
		INCLUDE "RSXTable.asm"
	ENDIF

	INCLUDE "LowerRAMTest.asm"


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
	IFDEF UpperROM
		ds 65536-ENDOFPROG		;; Round it up to 16 KB
	ELSE
		ds 16384-ENDOFPROG		;; Round it up to 16 KB
	ENDIF

