MainMenu:
	di
	ld bc,#7F8D                        ; GA deselect upper rom, and mode 1
	out (c),c

	call make_scr_table

MainMenuRepeat:
	call DrawMainMenu

.mainMenuLoop:
	call WaitForVsync
	call ReadFullKeyboard

	ld a,(KeyboardMatrixBuffer+8)
	bit 0,a
	jr nz,.upperRAMTestSelected

 IFDEF ROM_CHECK
	ld a,(KeyboardMatrixBuffer+8)
	bit 1,a
	jr nz,.ROMTestSelected
 ENDIF

	ld a,(KeyboardMatrixBuffer+7)
	bit 1,a
	jr nz,.keyboardTestSelected

	jr .mainMenuLoop


.upperRAMTestSelected:
	call CheckUpperRAM
	jp TestComplete


 IFDEF ROM_CHECK
.ROMTestSelected:
	call DetectROMs
	jp TestComplete
 ENDIF

.keyboardTestSelected:
	call TestKeyboard
	jp MainMenuRepeat

TestComplete:
	call NewLine
	ld hl,TxtAnyKeyMainMenu
	call PrintString
.loop:
	call WaitForVsync
	call ReadFullKeyboard
	call IsAnyKeyPressed
	jr z,.loop
	jp MainMenuRepeat


DrawMainMenu:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,#0000
	call SetTextCoords
	call SetTitleColors
	ld hl,TxtTitle
	call PrintString

	call SetDefaultColors

	ld hl,#0403
	call SetTextCoords
	ld hl,TxtSelectTest
	call PrintString

	ld hl,#0405
	call SetTextCoords
	ld hl,TxtRAMTest
	call PrintString

	ld hl,#0407
	call SetTextCoords
	ld hl,TxtROMTest
	call PrintString

	ld hl,#0409
	call SetTextCoords
	ld hl,TxtKeyboardTest
	call PrintString

	ret


TxtTitle: db '             AMSTRAD DIAGNOSTICS V', VERSION_STR, BUILD_STR, '               ',0
TxtSelectTest: db "SELECT WHICH TEST TO RUN:",0
TxtRAMTest: db "[1] UPPER RAM",0
TxtROMTest: db "[2] ROM",0
TxtKeyboardTest: db "[3] KEYBOARD",0
TxtAnyKeyMainMenu: db "PRESS ANY KEY FOR MAIN MENU",0


	INCLUDE "MainTests.asm"
	INCLUDE "DetectROMs.asm"
	INCLUDE "CheckUpperRAM.asm"
	INCLUDE "UtilsPrint.asm"
	INCLUDE "UtilsText.asm"
	INCLUDE "Screen.asm"
	INCLUDE "Keyboard.asm"
	INCLUDE "DetectCRTC.asm"
	INCLUDE "KeyboardTest.asm"

