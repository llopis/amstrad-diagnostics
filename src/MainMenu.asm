MainMenu:
	di

	; Check if we're in the middle of a soak test
	call IsSoakTestRunning
	jp z, SoakTestSelected

MainMenuRepeat:
	call SetUpScreen
	call DrawMenuItems

MainMenuLoop:
	call WaitForVsync
	call ReadFullKeyboard

	;; Check if key keys for the items are pressed
	ld ix, MenuTable
	ld b, MenuItemCount
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


	;; Check if keys to move the selected item are pressed
	ld a,(KeyboardMatrixBuffer)
	bit 0,a					; Cursor down
	jr nz, .selectionUp
	bit 2,a					; Cursor up
	jr nz, .selectionDown

	ld a,(KeyboardMatrixBuffer+9)		
	bit 0,a					; Joystick up
	jr nz, .selectionUp
	bit 1,a					; Joystick down
	jr nz, .selectionDown

	;; Check if keys to activate selected item are pressed
	ld a,(KeyboardMatrixBuffer+5)		
	bit 7,a					; Space
	jr nz, .selectionChoose
	ld a,(KeyboardMatrixBuffer+2)		
	bit 2,a					; Enter
	jr nz, .selectionChoose
	ld a,(KeyboardMatrixBuffer+0)		
	bit 6,a					; Return
	jr nz, .selectionChoose
	ld a,(KeyboardMatrixBuffer+9)		
	bit 4,a					; Joystick fire
	jr nz, .selectionChoose

	jr MainMenuLoop

.doItem:
	ld l,(ix+2)
	ld h,(ix+3)
	jp (hl)	

.selectionDown:
	ld a,(SelectedMenuItem)
	inc a
	cp MenuItemCount
	jr nz, .selectionChanged
	ld a,0
	jr .selectionChanged

.selectionUp:
	ld a,(SelectedMenuItem)
	dec a
	jr nc, .selectionChanged
	ld a, MenuItemCount
	dec a
	jr .selectionChanged

.selectionChanged:
	ld (SelectedMenuItem),a
	call DrawMenuItems
	jr MainMenuLoop

.selectionChoose:
	ld ix, MenuTable
	ld de, MenuItemSize
	ld a,(SelectedMenuItem)	
.loop:
	or a
	jr z,.doItem
	add ix,de
	dec a
	jr .loop





UpperRAMTestSelected:
	call CheckUpperRAM
	jp TestComplete


ROMTestSelected:
 IFDEF ROM_CHECK
	call CheckROMs
	jp TestComplete
 ELSE
	jp MainMenuLoop
 ENDIF

KeyboardTestSelected:
	call TestKeyboard
	jp MainMenuRepeat

SystemInfoSelected:
	call SystemInfo
	jp TestComplete


TestComplete:
.loop:
	call WaitForVsync
	call ReadFullKeyboard
	call IsAnyKeyPressed
	jr z,.loop
	jp MainMenuRepeat


SetUpScreen:
	ld d, 0
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtBlank
 IFDEF UpperROMBuild
	ld d, (ScreenCharsWidth-TxtTitleLen-7)/2
	call PrintTitleBanner
	ld hl, txt_x
	inc (hl)
 	ld hl, TxtROM
 	call PrintString
 	ld a, (UpperROMConfig)
 	call PrintAHex
 ELSE
	ld d, (ScreenCharsWidth-TxtTitleLen)/2
	call PrintTitleBanner
 ENDIF

 	call SetDefaultColors
 	ld hl, #0403
 	ld (TxtCoords), hl
 	ld hl, TxtSelectTest
	call PrintString 	
 	ret

DrawMenuItems:
	; Menu items

	ld ix,MenuTable
	ld hl,#0405
	ld b,0
.itemLoop:
	ld (TxtCoords),hl
	push hl

	call SetDefaultColors
	ld a, (SelectedMenuItem)
	cp b
	jr nz, .normalItem
	call SetInverseColors

.normalItem:
	ld l,(ix+4)
	ld h,(ix+5)
	call PrintString

	; Increase ix to next menu item
	ld de,MenuItemSize
	add ix,de

	pop hl
	inc l
	inc l
	inc b
	ld a,b
	cp MenuItemCount
	jr nz, .itemLoop

	ret



; IN HL = Address of title
;    D = starting X
PrintTitleBanner:
	push hl
	call SetTitleColors
	ld hl,#0000
	ld (TxtCoords), hl
	ld b,ScreenCharsWidth
.bannerLoop:
	ld a,' '
	call PrintChar
	djnz .bannerLoop

	ld e,0
	ld (TxtCoords), de
	ld hl, TxtTitle
	call PrintString
	pop hl
	call PrintString
	ret


LowerRAMTestSuccess:
	ld d, 0
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtLowerRAMTitle
	ld d, (ScreenCharsWidth-TxtTitleLen-TxtLowerRAMTitleLen)/2
	call PrintTitleBanner

	call SetDefaultColors
	ld hl, #0002
	ld (TxtCoords), hl
	ld hl, TxtLowerRAMSuccess
	call PrintString
	ld hl, #0004
	ld (TxtCoords), hl
	ld hl, TxtAnyKeyMainMenu
	call PrintString

	jp TestComplete



/////// Constants
TxtRAMTest: db "[1] UPPER RAM ",0
 IFDEF ROM_CHECK
TxtROMTest: db "[2] ROM ",0
 ELSE
TxtROMTest: db "[2] ROM (DISABLED)",0
 ENDIF
TxtKeyboardTest: db "[3] KEYBOARD ",0
TxtSystemInfo: db "[4] SYSTEM INFO ",0
TxtSoakTest: db "[5] SOAK TEST ",0
MenuTable:
	; Offset into keyboard buffer, bit mask, address to jump to, item text
	db 8, %0001
	dw UpperRAMTestSelected, TxtRAMTest
	db 8, %0010
	dw ROMTestSelected, TxtROMTest
	db 7, %0010
	dw KeyboardTestSelected, TxtKeyboardTest
	db 7, %0001
	dw SystemInfoSelected, TxtSystemInfo
	db 6, %0010
	dw SoakTestSelected, TxtSoakTest
MenuItemSize equ 1+1+2+2
MenuItemCount equ ($-MenuTable)/MenuItemSize


TxtTitle: db 'AMSTRAD DIAGNOSTICS V', VERSION_STR, BUILD_STR,0
TxtTitleLen EQU $-TxtTitle-1
TxtBlank: db 0

TxtLowerRAMTitle: db " - LOWER RAM TESTS",0
TxtLowerRAMTitleLen equ $-TxtLowerRAMTitle-1
TxtLowerRAMSuccess: db "LOWER RAM TESTS PASSED",0
TxtSelectTest: db "SELECT WHICH TEST TO RUN:",0
TxtAnyKeyMainMenu: db "PRESS ANY KEY FOR MAIN MENU",0
TxtROM: db 'ROM ',0

 INCLUDE "SoakTest.asm"
 INCLUDE "CheckUpperRAM.asm"
 INCLUDE "UtilsPrint.asm"
 INCLUDE "Screen.asm"
 INCLUDE "Keyboard.asm"
 INCLUDE "DetectCRTC.asm"
 INCLUDE "KeyboardTest.asm"
 INCLUDE "SystemInfo.asm"
 IFDEF ROM_CHECK
	INCLUDE "CheckROMs.asm"
 ENDIF
