MainMenu:

	; Check if we're in the middle of a soak test
	call 	IsSoakTestRunning
	jp 	z, SoakTestSelected

	call	DetectSystemInfo
	ld 	hl, PresseddMatrixBuffer
	call 	ClearKeyboardBuffer

MainMenuRepeat:
	call 	SetUpScreen
	call 	DrawMenuItems

MainMenuLoop:
	call 	WaitForVsync
	call 	ReadFullKeyboard
	call 	UpdateKeyBuffers

	;; Check if key keys for the items are pressed
	ld 	ix, MenuTable
	ld 	b, MenuItemCount
.itemLoop:
	; Get address of part of keyboard buffer to read
	ld	hl, EdgeOnKeyboardMatrixBuffer
	ld 	d, 0
	ld 	e, (ix+2)
	add 	hl, de
	ld 	a, (hl)
	; Get mask to check against for the key we care about
	ld 	d,(ix+3)
	and 	d
	or 	a
	jp 	nz,.doItem

	; Increase ix to next menu item
	ld 	de, MenuItemSize
	add 	ix, de

	djnz .itemLoop


	;; Check if keys to move the selected item are pressed
	ld a,(EdgeOnKeyboardMatrixBuffer)
	bit 0,a					; Cursor down
	jr nz, .selectionUp
	bit 1,a					; Cursor right
	jr nz, .selectionRight
	bit 2,a					; Cursor up
	jr nz, .selectionDown
	bit 6,a					; Return
	jr nz, .selectionChoose

	ld a,(EdgeOnKeyboardMatrixBuffer+1)
	bit 0,a					; Cursor left
	jr nz, .selectionLeft
	ld a,(EdgeOnKeyboardMatrixBuffer+2)		
	bit 2,a					; Enter
	jr nz, .selectionChoose

	ld a,(EdgeOnKeyboardMatrixBuffer+5)		
	bit 7,a					; Space
	jr nz, .selectionChoose
	ld a,(EdgeOnKeyboardMatrixBuffer+9)		
	bit 0,a					; Joystick up
	jr nz, .selectionUp
	bit 1,a					; Joystick down
	jr nz, .selectionDown
	bit 2,a					; Joystick left
	jr nz, .selectionLeft
	bit 3,a					; Joystick right
	jr nz, .selectionRight
	bit 4,a					; Joystick fire
	jr nz, .selectionChoose

	jr MainMenuLoop

.doItem:
	ld l,(ix+4)
	ld h,(ix+5)
	jp (hl)	

.selectionDown:
	ld 	a,(SelectedMenuItem)
	inc 	a
.increasedSelection:
	cp 	MenuItemCount
	jr 	c, .selectionChanged
	ld 	a, 0
	jr 	.selectionChanged
.selectionRight:
	ld 	a,(SelectedMenuItem)
	inc	a
	inc	a
	jr	.increasedSelection
.selectionUp:
	ld 	a,(SelectedMenuItem)
	dec 	a
.decreasedSelection:
	cp	MenuItemCount
	jr 	nc, .moveSelectionToTop
	jr 	.selectionChanged
.selectionLeft:
	ld 	a,(SelectedMenuItem)
	dec	a
	dec	a
	jr	.decreasedSelection

.moveSelectionToTop:
	ld 	a, MenuItemCount
	dec 	a
	jr 	.selectionChanged

.selectionChanged:
	push 	af
	ld 	a, (SelectedMenuItem)
	ld 	c, 0
	call 	DrawMenuItemFromIndex
	pop 	af
	ld 	(SelectedMenuItem), a
	ld 	c, 1
	call 	DrawMenuItemFromIndex
	jp 	MainMenuLoop

.selectionChoose:
	ld 	ix, MenuTable
	ld 	de, MenuItemSize
	ld 	a,(SelectedMenuItem)	
.loop:
	or 	a
	jr 	z,.doItem
	add 	ix,de
	dec 	a
	jr 	.loop


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


TestComplete:
.loop:
	call WaitForVsync
	call ReadFullKeyboard
	call UpdateKeyBuffers
	call IsAnyKeyPressed
	jr z,.loop
	jp MainMenuRepeat



TxtModel: 	db 'MODEL     : ',0
TxtRAM: 	db 'RAM       : ',0
TxtCRTC: 	db 'CRTC      : ',0
TxtKB: 		db 'KB',0
TxtSelectTest: 	  db "SELECT A TEST TO RUN",0
TxtSelectTestLen EQU $-TxtSelectTest-1

TxtResultLowerRAM: db 'LOWER RAM',0
TxtResultUpperRAM: db 'UPPER RAM',0
TxtResultLowerROM: db 'LOWER ROM',0
TxtResultUpperROM: db 'UPPER ROM',0
TxtResultKeyboard: db 'KEYBOARD',0
TxtResultJoystick: db 'JOYSTICK',0

ResultLabelTable:
	dw TxtResultLowerRAM
	dw TxtResultUpperRAM
	dw TxtResultLowerROM
	dw TxtResultUpperROM
	dw TxtResultKeyboard
	dw TxtResultJoystick
ResultLabelTableCount EQU ($-ResultLabelTable)/2


TxtUntested: db "UNTESTED",0
TxtPassed: db "PASSED",0
TxtFailed: db "FAILED",0
TxtAborted: db "ABORTED",0
TxtNotAvailable: db "NOT AVAILABLE",0

ResultTextTable:
	dw TxtUntested
	dw TxtPassed
	dw TxtFailed
	dw TxtAborted
	dw TxtNotAvailable


RESULTS_X 		EQU 14
RESULTS_COLON_X 	EQU RESULTS_X + 10
RESULTS_STRING_X 	EQU RESULTS_COLON_X + 2

SetUpScreen:
	ld 	d, 0
	call 	ClearScreen
	ld 	a, 4
	call 	SetBorderColor 

	;; Banner title
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

 	;; Model
 	call 	SetDefaultColors
 	ld	h, RESULTS_X
 	ld	l, 4
 	push	hl
 	ld	(TxtCoords), hl
	ld	hl, TxtModel
	call	PrintString
	ld	a, (ModelType)
	ld	e, a
	ld	d, 0
	ld	hl, ModelNameTableOffset
	add	hl, de
	ld	a, (hl)
	ld	e, a
	ld	hl, ModelNames
	add	hl, de
	call	PrintString

	;; RAM
	pop	hl
	inc	l
	push 	hl
 	ld	(TxtCoords), hl
	ld 	hl, TxtRAM
	call 	PrintString

	ld 	a, (ValidBankCount)
	ld 	l,a
	ld 	h,0
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	ld	de, 64
	add	hl, de
	call 	PrintHLDec
	ld 	hl, TxtKB
	call 	PrintString


	;; CRTC yype
	pop	hl
	inc	l
	push 	hl
 	ld	(TxtCoords), hl
	ld 	hl, TxtCRTC
	call 	PrintString
	call 	GetCRTCType
	call 	PrintAHex
	pop	hl


	;; Results
	inc	l
	inc	l
 	ld	(TxtCoords), hl
 	ld	b, ResultLabelTableCount
 	ld	ix, ResultLabelTable
	ld 	iy, TestResultTable
	ld	c, 0
.resultLoop:
	;; Result label
	call	SetDefaultColors
	ld	a, RESULTS_X
	ld	(txt_x), a
 	ld	l, (ix)
 	ld	h, (ix+1)
	call 	PrintString

	;; Colon
	ld	a, RESULTS_COLON_X
	ld	(txt_x), a
	ld	a, ':'
	call	PrintChar

	;; Actual result
	ld	a, RESULTS_STRING_X
	ld	(txt_x), a
	ld	a, (iy)
	call	SetColorForResultType
	ld	a, (iy)
	sla	a
	ld	e, a
	ld	d, 0
	ld	hl, ResultTextTable
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, de
	call	PrintString

	ld	a, c
	cp	4
	jr	nz, .nextResult
	ld	a, (iy)
	cp	TESTRESULT_FAILED
	jr	nz, .nextResult
	call	CountPressedKeys
	ld	d, KEYBOARD_KEY_COUNT
	call	PrintPressedKeys

.nextResult:
	ld	a, c
	cp	5
	jr	nz, .nextResult2
	ld	a, (iy)
	cp	TESTRESULT_FAILED
	jr	nz, .nextResult2
	call	CountPressedJoystickButtons
	ld	d, JOYSTICK_KEY_COUNT
	call	PrintPressedKeys

.nextResult2:
	inc	iy
	inc	ix
	inc	ix
	ld	hl, txt_y
	inc	(hl)
	inc	c
	djnz	.resultLoop


 	;; Select a test to run
 	call	SetInverseColors
 	ld 	h, 0
 	ld	l, SELECT_Y
 	ld 	(TxtCoords), hl
	ld 	b, ScreenCharsWidth
.bannerLoop:
	ld 	a,' '
	call 	PrintChar
	djnz 	.bannerLoop

	ld 	a, (ScreenCharsWidth - TxtSelectTestLen)/2
	ld 	(txt_x), a
	ld 	hl, TxtTitle
 	ld 	hl, TxtSelectTest
	call 	PrintString

 	ret


;; IN: 	A - count
;;	D - total
PrintPressedKeys:
	push	bc
	push	de
	push	af
	ld	hl, txt_x
	inc	(hl)
	ld	a, '('
	call	PrintChar
	pop	af
	call	PrintADecLess100
	ld	a, '/'
	call	PrintChar
	pop	de
	ld	a, d
	call	PrintADecLess100
	ld	a, ')'
	call	PrintChar
	pop	bc
	ret


DrawMenuItems:
	ld 	ix, MenuTable
	ld 	b, 0
.itemLoop:
	call 	SetDefaultColors
	ld 	a, (SelectedMenuItem)
	cp 	b
	jr 	nz, .normalItem
	call 	SetInverseColors

.normalItem:
	ld	h,(ix)
	ld	l,(ix+1)
	ld	(TxtCoords), hl
	ld 	l,(ix+6)
	ld 	h,(ix+7)
	call 	PrintString

.nextItem:
	; Increase ix to next menu item
	ld 	de, MenuItemSize
	add 	ix, de

	inc 	b
	ld 	a,b
	cp 	MenuItemCount
	jr 	nz, .itemLoop

	ret


;; IN:	A - result type
;; OUT: Color set
SetColorForResultType:
	cp	TESTRESULT_PASSED
	jp	z, SetSuccessColors
	cp	TESTRESULT_FAILED
	jp	z, SetErrorColors
	cp	TESTRESULT_ABORTED
	jp	z, SetErrorColors
	jp	SetDefaultColors	// jump and ret


; IN: A menu item to draw
;     C selected or not
DrawMenuItemFromIndex:
	cp	MenuItemCount
	ret	nc
	ld 	hl, MenuTable
	ld 	de, MenuItemSize
.findLoop:
	or 	a
	jr 	z, .foundItem
	add 	hl, de
	dec 	a
	jr 	.findLoop

.foundItem:
	ld	ix, hl
	ld	h,(ix)
	ld	l,(ix+1)
	ld	(TxtCoords), hl

	; Now set the color
	ld 	a, c
	or 	a
	jr 	nz, .selectedItem
	call 	SetDefaultColors
.drawItem:
	ld 	l,(ix+6)
	ld 	h,(ix+7)
	call 	PrintString

	ret

.selectedItem:
	call 	SetInverseColors
	jr 	.drawItem


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


DetectSystemInfo:
	;; Try to detect the model and language
	call	CalculateTotalUpperRAM
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

	ld	a, MenuItemCount
	ld	(SelectedMenuItem), a

	ret


/////// Constants

SELECT_Y EQU 22
MENU_COL1_X EQU 0
MENU_COL2_X EQU 17
MENU_COL3_X EQU 37
MENU_ROW1_Y EQU SELECT_Y+1
MENU_ROW2_Y EQU MENU_ROW1_Y+1


TxtLowerRAMTest: db "[1] LOWER RAM ",0
TxtRAMTest: 	 db "[2] UPPER RAM ",0
 IFDEF ROM_CHECK
TxtROMTest: 	 db "[3] ROM ",0
 ELSE
TxtROMTest: 	 db "[3] ROM (DISABLED)",0
 ENDIF
TxtKeyboardTest: db "[4] KEYBOARD ",0
TxtSoakTest: 	 db "[5] SOAK TEST ",0
MenuTable:
	; x, y, Offset into keyboard buffer, bit mask, address to jump to, item text
	db MENU_COL1_X, MENU_ROW1_Y, 8, %0001			; 1
	dw TestStart, TxtLowerRAMTest
	db MENU_COL1_X, MENU_ROW2_Y, 8, %0010			; 2
	dw UpperRAMTestSelected, TxtRAMTest
	db MENU_COL2_X, MENU_ROW1_Y, 7, %0010			; 3
	dw ROMTestSelected, TxtROMTest
	db MENU_COL2_X, MENU_ROW2_Y, 7, %0001			; 4
	dw KeyboardTestSelected, TxtKeyboardTest
	db MENU_COL3_X, MENU_ROW1_Y, 6, %0010			; 5
	dw SoakTestSelected, TxtSoakTest
MenuItemSize equ 4+2+2
MenuItemCount equ ($-MenuTable)/MenuItemSize


TxtTitle: db 'AMSTRAD DIAGNOSTICS V', VERSION_STR, BUILD_STR,0
TxtTitleLen EQU $-TxtTitle-1
TxtBlank: db 0

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
 IFNDEF UpperROMBuild
 	INCLUDE "PrintChar.asm"
	INCLUDE "Draw.asm"
 ENDIF
 IFDEF ROM_CHECK
	INCLUDE "CheckROMs.asm"
 ENDIF
