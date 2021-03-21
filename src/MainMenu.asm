MainMenu:
	di

	; Check if we're in the middle of a soak test
	call 	IsSoakTestRunning
	jp 	z, SoakTestSelected

	;; Try to detect the model and language
	call	DetectModel

	;; From the model, determine the keyboard layout
	ld	a, (ModelType)
	cp	MODEL_CPC6128
	jr	c, .set464Layout
	ld	a, KEYBOARD_LAYOUT_6128
	jr	.setLayout
.set464Layout:
	ld	a, KEYBOARD_LAYOUT_464
.setLayout:
	ld	(KeyboardLayout), a

MainMenuRepeat:
	call 	SetUpScreen
	ld 	a, (LowRAMSuccess)
	or	a
	jr	z, .drawMenuItems
	call 	LowerRAMTestSuccess
	ld 	a, 0
	ld	(LowRAMSuccess), a

.drawMenuItems:
	call DrawMenuItems

MainMenuLoop:
	call WaitForVsync
	call ReadFullKeyboard
	call UpdateKeyBuffers

	;; Check if key keys for the items are pressed
	ld ix, MenuTable
	ld b, MenuItemCount
.itemLoop:
	; Get address of part of keyboard buffer to read
	ld hl,EdgeOnKeyboardMatrixBuffer
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
	ld a,(EdgeOnKeyboardMatrixBuffer)
	bit 0,a					; Cursor down
	jr nz, .selectionUp
	bit 2,a					; Cursor up
	jr nz, .selectionDown

	ld a,(EdgeOnKeyboardMatrixBuffer+9)		
	bit 0,a					; Joystick up
	jr nz, .selectionUp
	bit 1,a					; Joystick down
	jr nz, .selectionDown

	;; Check if keys to activate selected item are pressed
	ld a,(EdgeOnKeyboardMatrixBuffer+5)		
	bit 7,a					; Space
	jr nz, .selectionChoose
	ld a,(EdgeOnKeyboardMatrixBuffer+2)		
	bit 2,a					; Enter
	jr nz, .selectionChoose
	ld a,(EdgeOnKeyboardMatrixBuffer+0)		
	bit 6,a					; Return
	jr nz, .selectionChoose
	ld a,(EdgeOnKeyboardMatrixBuffer+9)		
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
	or a
	jr z, .moveSelectionToTop
	dec a
	jr .selectionChanged
.moveSelectionToTop:
	ld a, MenuItemCount
	dec a
	jr .selectionChanged

.selectionChanged:
	push af
	ld a, (SelectedMenuItem)
	ld c, 0
	call DrawMenuItemFromIndex
	pop af
	ld (SelectedMenuItem), a
	ld c, 1
	call DrawMenuItemFromIndex
	jp MainMenuLoop

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
	call UpdateKeyBuffers
	call IsAnyKeyPressed
	jr z,.loop
	jp MainMenuRepeat


MENU_X EQU 16
MENU_Y EQU 7
MENU_ITEM_START_POS equ (MENU_X << 8) | MENU_Y
SELECT_X EQU MENU_X - 2
SELECT_Y EQU MENU_Y - 2
SELECT_POS equ (SELECT_X << 8) | SELECT_Y


SetUpScreen:
	ld 	d, 0
	call 	ClearScreen
	ld 	a, 4
	call 	SetBorderColor 

	ld 	hl, TxtBlank
 IFDEF UpperROMBuild
	ld 	d, (ScreenCharsWidth-TxtTitleLen-7)/2
	call 	PrintTitleBanner
	ld 	hl, txt_x
	inc 	(hl)
 	ld 	hl, TxtROM
 	call 	PrintString
 	ld 	a, (UpperROMConfig)
 	call 	PrintAHex
 ELSE
	ld 	d, (ScreenCharsWidth-TxtTitleLen)/2
	call 	PrintTitleBanner
 ENDIF

 	call 	SetDefaultColors
 	ld 	h, SELECT_X
 	ld	l, SELECT_Y
 	ld 	(TxtCoords), hl
 	ld 	hl, TxtSelectTest
	call 	PrintString 

	/*
	ld	h, 0
	ld	l, 1
	ld	e, 15
	ld	b, 16
	call	DrawHorizontalLine
	*/
	/*
	ld	h, 0
	ld	l, 0
	ld	e, 100
	ld	b, 16
	call	DrawVerticalLine

	ld	h, 0
	ld	l, 2
	ld	e, 100
	ld	b, 16
	call	DrawVerticalLine

	ld	h, 0
	ld	l, 0
	ld	e, 120
	ld	b, 16
	call	DrawVerticalLine

	ld	h, 0
	ld	l, 4
	ld	e, 120
	ld	b, 16
	call	DrawVerticalLine
	*/

 	ret


DrawMenuItems:
	ld 	ix, MenuTable
	ld 	hl, MENU_ITEM_START_POS
	ld 	b, 0
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


; IN: A menu item to draw
;     C selected or not
DrawMenuItemFromIndex:
	; First find the item in the table
	ld b, MENU_Y
	ld hl, MenuTable
	ld de, MenuItemSize
.findLoop:
	or a
	jr z, .foundItem
	add hl,de
	dec a
	inc b
	inc b
	jr .findLoop

.foundItem:
	ld ix, hl

	; Set the position
	ld d, MENU_X
	ld e, b
	ld (TxtCoords), de

	; Now set the color
	ld a,c
	or a
	jr nz, .selectedItem
	call SetDefaultColors
.drawItem:
	ld l,(ix+4)
	ld h,(ix+5)
	call PrintString

	ret

.selectedItem:
	call SetInverseColors
	jr .drawItem


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
	call 	SetSuccessColors
	ld 	hl, #0002
	ld 	(TxtCoords), hl
	ld 	hl, TxtLowerRAMSuccess
	call 	PrintString
	ret


/////// Constants

TxtLowerRAMTest: db "[1] LOWER RAM ",0
TxtRAMTest: db "[2] UPPER RAM ",0
 IFDEF ROM_CHECK
TxtROMTest: db "[3] ROM ",0
 ELSE
TxtROMTest: db "[3] ROM (DISABLED)",0
 ENDIF
TxtKeyboardTest: db "[4] KEYBOARD ",0
TxtSystemInfo: db "[5] SYSTEM INFO ",0
TxtSoakTest: db "[6] SOAK TEST ",0
MenuTable:
	; Offset into keyboard buffer, bit mask, address to jump to, item text
	db 8, %0001			; 1
	dw TestStart, TxtLowerRAMTest
	db 8, %0010			; 2
	dw UpperRAMTestSelected, TxtRAMTest
	db 7, %0010			; 3
	dw ROMTestSelected, TxtROMTest
	db 7, %0001			; 4
	dw KeyboardTestSelected, TxtKeyboardTest
	db 6, %0010			; 5
	dw SystemInfoSelected, TxtSystemInfo
	db 6, %0001			; 6
	dw SoakTestSelected, TxtSoakTest
MenuItemSize equ 1+1+2+2
MenuItemCount equ ($-MenuTable)/MenuItemSize


TxtTitle: db 'AMSTRAD DIAGNOSTICS V', VERSION_STR, BUILD_STR,0
TxtTitleLen EQU $-TxtTitle-1
TxtBlank: db 0

TxtLowerRAMSuccess: db "LOWER RAM TESTS PASSED",0
TxtSelectTest: db "SELECT WHICH TEST TO RUN:",0
TxtAnyKeyMainMenu: db "PRESS ANY KEY FOR MAIN MENU",0
TxtROM: db 'ROM ',0

 INCLUDE "Model.asm"
 INCLUDE "SoakTest.asm"
 INCLUDE "CheckUpperRAM.asm"
 INCLUDE "UtilsPrint.asm"
 INCLUDE "Screen.asm"
 INCLUDE "Keyboard.asm"
 INCLUDE "DetectCRTC.asm"
 INCLUDE "KeyboardTest.asm"
 INCLUDE "SystemInfo.asm"
 IFNDEF UpperROMBuild
 	INCLUDE "PrintChar.asm"
	INCLUDE "Draw.asm"
 ENDIF
 IFDEF ROM_CHECK
	INCLUDE "CheckROMs.asm"
 ENDIF
