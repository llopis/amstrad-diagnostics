MainMenu:
	di
	ld bc,#7F8D                        ; GA deselect upper rom, and mode 1
	out (c),c

	call make_scr_table

	; Check if we're in the middle of a soak test
	call IsSoakTestRunning
	jp z, SoakTestSelected

MainMenuRepeat:
	call DrawMainMenu

.mainMenuLoop:
	call WaitForVsync
	call ReadFullKeyboard


	ld ix,MenuTable
	ld b,MenuItemCount
.itemLoop:
	; Get address of part of keyboard buffer to read
	ld hl,KeyboardMatrixBuffer
	ld d,0
	ld e,(ix)
	add hl,de
	ld a,(hl)
	; Get mask to check against for the key we care about
	ld d,(ix+1)
	and d
	or a
	jp nz,.doItem

	; Increase ix to next menu item
	ld de,MenuItemSize
	add ix,de

	djnz .itemLoop

	jr .mainMenuLoop

.doItem:
	ld l,(ix+2)
	ld h,(ix+3)
	jp (hl)	


UpperRAMTestSelected:
	call CheckUpperRAM
	jp TestComplete


 IFDEF ROM_CHECK
ROMTestSelected:
	call DetectROMs
	jp TestComplete
 ENDIF

KeyboardTestSelected:
	call TestKeyboard
	jp MainMenuRepeat

SystemInfoSelected:
	call SystemInfo
	jp TestComplete


TestComplete:
	call NewLine
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

	ld hl,TxtVersion
	ld d,#e
	call PrintTitleBanner

	; Menu items
	call SetDefaultColors

	ld ix,MenuTable
	ld hl,#0403
	ld b,MenuItemCount
.itemLoop:
	ld (txt_coords),hl
	push hl
	ld l,(ix+4)
	ld h,(ix+5)
	call PrintString

	; Increase ix to next menu item
	ld de,MenuItemSize
	add ix,de

	pop hl
	inc l
	inc l

	djnz .itemLoop

	ret


; IN HL = Address of title
;    D = starting X
PrintTitleBanner:
	push hl
	call SetTitleColors
	ld hl,#0000
	ld (txt_coords),hl
	ld b,ScreenCharsWidth
.bannerLoop:
	ld a,' '
	call PrintChar
	djnz .bannerLoop

	ld e,0
	ld (txt_coords),de
	ld hl,TxtDiagnostics
	call PrintString
	pop hl
	call PrintString
	ret


TxtRAMTest: db "[1] UPPER RAM",0
TxtROMTest: db "[2] ROM",0
TxtKeyboardTest: db "[3] KEYBOARD",0
TxtSystemInfo: db "[4] SYSTEM INFO",0
TxtSoakTest: db "[5] SOAK TEST",0
MenuTable:
	; Offset into keyboard buffer, bit mask, address to jump to, item text
	db 8, %0001
	dw UpperRAMTestSelected, TxtRAMTest
 IFDEF ROM_CHECK
	db 8, %0010
	dw ROMTestSelected, TxtROMTest
 ENDIF
	db 7, %0010
	dw KeyboardTestSelected, TxtKeyboardTest
	db 7, %0001
	dw SystemInfoSelected, TxtSystemInfo
	db 6, %0010
	dw SoakTestSelected, TxtSoakTest
MenuItemSize equ 1+1+2+2
MenuItemCount equ ($-MenuTable)/MenuItemSize


TxtDiagnostics: db 'AMSTRAD DIAGNOSTICS ',0
TxtDiagnosticsLen equ $ - TxtDiagnostics
TxtVersion: db 'V', VERSION_STR, BUILD_STR,0

TxtSelectTest: db "SELECT WHICH TEST TO RUN:",0
TxtAnyKeyMainMenu: db "PRESS ANY KEY FOR MAIN MENU",0
TxtDisabled: db "(DISABLED)",0

 INCLUDE "SoakTest.asm"
 INCLUDE "DetectROMs.asm"
 INCLUDE "CheckUpperRAM.asm"
 INCLUDE "UtilsPrint.asm"
 INCLUDE "UtilsText.asm"
 INCLUDE "Screen.asm"
 INCLUDE "Keyboard.asm"
 INCLUDE "DetectCRTC.asm"
 INCLUDE "KeyboardTest.asm"
 INCLUDE "SystemInfo.asm"
 INCLUDE "Dandanator.asm"

