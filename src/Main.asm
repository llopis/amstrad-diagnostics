MainProgramAddr EQU #8000
MAINBEGIN:
	DISP MainProgramAddr

Main:
	call make_scr_table
	call ClearScreen
	ld a, 4
	call SetBorderColor

	call SetTitleColors
	ld hl, TxtTitle
	call PrintString

	call SetDefaultColors

	call NewLine
	call NewLine

	ld hl, TxtLowerRAMOK
	call PrintString
	call NewLine
	call NewLine

	call CheckUpperRAM
	call DetectROMs
	call DetectCRTC
	
Wait:
	jr Wait


TxtTitle: db '              AMSTRAD DIAGNOSTICS V0.0               ',0
TxtLowerRAMOK: db 'LOWER RAM OK.',0


	INCLUDE "DetectROMs.asm"
	INCLUDE "CheckUpperRAM.asm"
	INCLUDE "UtilsPrint.asm"
	INCLUDE "UtilsText.asm"
	INCLUDE "Screen.asm"
	INCLUDE "DetectCRTC.asm"

	ENT
ENDOFPROG:
	ds 16384-ENDOFPROG		;; Round it up to 16 KB
