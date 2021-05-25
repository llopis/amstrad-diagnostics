MainMenu:

	; Check if we're in the middle of a soak test
	call 	IsSoakTestRunning
	jp 	z, SoakTestSelected

 IFNDEF ROM_CHECK
 	call	RemoveROMTest
 ENDIF

	call	DetectSystemInfo
	ld	a, (ValidBankCount)
	or	a
	jr	nz, .upperRAMPresent
	call	RemoveUpperRAMTest

.upperRAMPresent:
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
	ld	a, (MenuItemCount)
	ld 	b, a
	ld	c, %00000001
.itemLoop:
	;; Get address of part of keyboard buffer to read
	ld	hl, EdgeOnKeyboardMatrixBuffer
	ld 	d, 0
	ld 	e, (ix+MenuItem.KeybOffset)
	add 	hl, de
	ld 	a, (hl)
	;; Get mask to check against for the key we care about
	ld 	d, (ix+MenuItem.BitMask)
	and 	d
	or 	a
	jp 	nz,.doItem

.nextItem:
	;; Increase ix to next menu item
	ld 	de, MENU_ITEM_SIZE
	add 	ix, de
	sla	c			;; Move bitmask left

	djnz .itemLoop


	;; Check if keys to move the selected item are pressed
	ld 	a, (EdgeOnKeyboardMatrixBuffer)
	bit 	0, a					; Cursor down
	jr 	nz, .selectionUp
	bit 	2, a					; Cursor up
	jr 	nz, .selectionDown
	bit 	6, a					; Return
	jr 	nz, .selectionChoose

	ld 	a, (EdgeOnKeyboardMatrixBuffer+2)		
	bit 	2, a					; Enter
	jr 	nz, .selectionChoose

	ld 	a, (EdgeOnKeyboardMatrixBuffer+5)		
	bit 	7, a					; Space
	jr 	nz, .selectionChoose
	ld 	a, (EdgeOnKeyboardMatrixBuffer+9)		
	bit 	0, a					; Joystick up
	jr 	nz, .selectionUp
	bit 	1, a					; Joystick down
	jr 	nz, .selectionDown
	bit 	4, a					; Joystick fire
	jr 	nz, .selectionChoose

	jr 	MainMenuLoop

.doItem:
	ld 	l, (ix+MenuItem.Function)
	ld 	h, (ix+MenuItem.Function+1)
	jp 	(hl)	

.selectionUp:
	ld 	a, (SelectedMenuItem)
	ld 	c, 0
	call 	DrawMenuItemFromIndex
.selectionUpWithoutErase:
	ld	a, (MenuItemCount)
	ld	c, a
	ld 	a, (SelectedMenuItem)
	dec 	a
	cp	c
	jr 	c, .selectionChangedUp
	;; Wrap around
	ld 	a, (MenuItemCount)
	dec	a
.selectionChangedUp:
	ld	(SelectedMenuItem), a
	jr	.selectionChanged


.selectionDown:
	ld 	a, (SelectedMenuItem)
	ld 	c, 0
	call 	DrawMenuItemFromIndex
.selectionDownWithoutErase:
	ld	a, (MenuItemCount)
	ld	c, a
	ld 	a, (SelectedMenuItem)
	inc 	a
	cp 	c
	jr 	c, .selectionChangedDown
	;; Wrap around
	ld 	a, 0
.selectionChangedDown:
	ld	(SelectedMenuItem), a
	;; Drop down to .selectionChanged

.selectionChanged:
	ld 	a, (SelectedMenuItem)
	ld 	c, 1
	call 	DrawMenuItemFromIndex
	jp 	MainMenuLoop

.selectionChoose:
	ld 	ix, MenuTable
	ld 	de, MENU_ITEM_SIZE
	ld 	a,(SelectedMenuItem)	
.loop:
	or 	a
	jr 	z,.doItem
	add 	ix,de
	dec 	a
	jr 	.loop


LowerRAMTestSelected:
 IFDEF UpperROMBuild
 	call 	ClearScreen
 	ld	a, (UpperROMConfig)
	ld 	iyh, a			;; Save the ROM we came from in I
 ENDIF
	jp TestStart

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


TxtSystemInfo:	db 'SYSTEM INFO  ',0
TxtModel: 	db 'MODEL     : ',0
TxtVendor: 	db 'VENDOR    : ',0
TxtRefresh:	db 'REFRESH   : ',0
;TxtPPIPB:	db 'PPI PORTB : ',0
TxtRAM: 	db 'RAM       : ',0
TxtCRTC: 	db 'CRTC      : ',0
TxtKB: 		db 'KB',0
TxtFDC: 	db 'FDC       : ',0
TxtDetected: 	db 'DETECTED',0
TxtNone:	db 'NONE',0

TxtTestResults: db 'TEST RESULTS ',0
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

KEYBOARD_TEST_INDEX EQU 4
JOYSTICK_TEST_INDEX EQU 5


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


MENUHEADERS_X		EQU 0
MENUHEADERS_Y		EQU 3
RESULTS_Y 		EQU MENUHEADERS_Y+1
RESULTS_X 		EQU MENUHEADERS_X+2
RESULTS_COLON_X 	EQU RESULTS_X + 10
RESULTS_STRING_X 	EQU RESULTS_COLON_X + 2
SYSTEMINFO_POS EQU 	(MENUHEADERS_X << 8) | MENUHEADERS_Y


TxtSelectTest: 	  db 'SELECT A TEST TO RUN ',0
TxtSelectTestLen EQU $-TxtSelectTest-1


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
 	call 	SetInverseColors
 	ld	hl, SYSTEMINFO_POS
 	push	hl
 	ld	(TxtCoords), hl
 	ld	hl, TxtSystemInfo
 	call	PrintString

 	call 	SetDefaultColors
 	pop	hl
 	ld	h, RESULTS_X
 	inc	l
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

    ;; VENDOR
	pop	hl
	inc	l
	push 	hl
 	ld	(TxtCoords), hl
	ld 	hl, TxtVendor
	call 	PrintString
	ld	a, (VendorName)
	ld	e, a
	ld	d, 0
	ld	hl, VendorTableOffset
	add	hl, de                 ; offset
	ld	a, (hl)
	ld	e, a
	ld	hl, VendorNames
	add	hl, de                 ; 1st name + offset
	call    PrintString

    ;; REFRESH
	pop	hl
	inc	l
	push 	hl
 	ld	(TxtCoords), hl
	ld 	hl, TxtRefresh
	call 	PrintString
	ld	a, (RefreshFrequency)
	ld	e, a
	ld	d, 0
	ld	hl, RefreshTableOffset
	add	hl, de
	ld	a, (hl)
	ld	e, a
	ld	hl, RefreshNames
	add	hl, de
	call    PrintString

	;; PPI Port B
	;pop	hl
	;inc	l
	;push 	hl
 	;ld	(TxtCoords), hl
	;ld 	hl, TxtPPIPB
	;call 	PrintString
	;ld b,#f5			; PPI port B input
 	;in a,(c)            	
	;call    PrintABin

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


	;; FDC
	pop	hl
	inc	l
	push 	hl
 	ld	(TxtCoords), hl
	ld 	hl, TxtFDC
	call 	PrintString
	ld	a, (FDCPresent)
	or	a
	ld	hl, TxtNone
	jr	z, .FDCskip
	ld	hl, TxtDetected
.FDCskip:
	call	PrintString

	;; Results
	pop	hl
	inc	l
	inc	l
	ld	h, MENUHEADERS_X
 	ld	(TxtCoords), hl
 	call 	SetInverseColors
 	ld	hl, TxtTestResults
 	call	PrintString
	ld	hl, txt_y
	inc	(hl)

 	call 	SetDefaultColors
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
	cp	KEYBOARD_TEST_INDEX
	jr	nz, .nextResult
	ld	a, (iy)
	cp	TESTRESULT_FAILED
	jr	nz, .nextResult
	call	CountPressedKeys
	ld	d, KEYBOARD_KEY_COUNT
	call	PrintPressedKeys

.nextResult:
	ld	a, c
	cp	JOYSTICK_TEST_INDEX
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
 	ld 	h, SELECT_X
 	ld	l, SELECT_Y
 	ld 	(TxtCoords), hl
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
	ld	a, SELECT_Y
	ld	(txt_y), a
	ld	c, %00000001		;; Bit flag for this menu item
	ld 	ix, MenuTable
	ld 	de, MENU_ITEM_SIZE
	ld 	b, 0
.itemLoop:
	call 	SetDefaultColors
	ld 	a, (SelectedMenuItem)
	cp 	b
	jr 	nz, .normalItem
	call 	SetInverseColors

.normalItem:
	ld	hl, txt_y
	inc	(hl)
	ld	a, MENU_ITEM_X
	ld	(txt_x), a
	ld 	l, (ix+MenuItem.Text)
	ld 	h, (ix+MenuItem.Text+1)
	call 	PrintString

.nextItem:
	; Increase ix to next menu item
	add 	ix, de

	sla	c			;; Move bit of test mask one left
	inc 	b
	ld 	a, (MenuItemCount)
	cp 	b
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

	ld	b, a
	ld	a, (MenuItemCount)
	cp	b
	ret	c
	ret	z
	ld	a, b
	push	af

	ld	b, SELECT_Y+1		;; Line to draw item
	ld 	hl, MenuTable
	ld 	de, MENU_ITEM_SIZE
.findLoop:
	or 	a
	jr 	z, .foundItem
	add 	hl, de
	dec 	a
	inc	b
	jr 	.findLoop

.foundItem:
	ld	ix, hl
	ld	h, MENU_ITEM_X
	ld	l, b
	ld	(TxtCoords), hl

	; Now set the color
	ld 	a, c
	or 	a
	jr 	nz, .selectedItem
	call 	SetDefaultColors
.drawItem:
	ld 	l, (ix+MenuItem.Text)
	ld 	h, (ix+MenuItem.Text+1)
	call 	PrintString

	pop	af
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


RemoveROMTest:
	ld	a, TESTRESULT_NOTAVAILABLE
	ld	(TestResultTableLowerROM), a
	ld	(TestResultTableUpperROM), a

	ld	hl, MenuItemROMTest + MENU_ITEM_SIZE
	ld	de, MenuItemROMTest
	ld	bc, MenuTableEnd - (MenuItemROMTest + MENU_ITEM_SIZE)
	jr	RemoveTestEnd

RemoveUpperRAMTest:
	ld	a, TESTRESULT_NOTAVAILABLE
	ld	(TestResultTableUpperRAM), a

	ld	hl, MenuItemUpperRAMTest + MENU_ITEM_SIZE
	ld	de, MenuItemUpperRAMTest
	ld	bc, MenuTableEnd - (MenuItemUpperRAMTest + MENU_ITEM_SIZE)
	;;jr	RemoveTestEnd			;; Drop through 

RemoveTestEnd:	
	ldir

	ld	hl, MenuItemCount
	dec	(hl)
	ret


/////// Constants

SELECT_Y EQU 3
SELECT_X EQU 32
MENU_ITEM_X EQU SELECT_X+2

TxtLowerRAMTest: db "[L] LOWER RAM ",0
TxtUpperRAMTest: db "[U] UPPER RAM ",0
TxtROMTest: 	 db "[R] ROM ",0
TxtKeyboardTest: db "[K] KEYBOARD ",0
TxtSoakTest: 	 db "[S] SOAK TEST ",0


TxtTitle: db 'AMSTRAD DIAGNOSTICS V', VERSION_STR, BUILD_STR,0
TxtTitleLen EQU $-TxtTitle-1
TxtBlank: db 0

TxtAnyKeyMainMenu: db "PRESS ANY KEY FOR MAIN MENU",0
TxtROM: db 'ROM ',0

