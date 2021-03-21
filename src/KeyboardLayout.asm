

@KEYBOARD_LAYOUT_464	EQU 0
@KEYBOARD_LAYOUT_6128	EQU 1
@KEYBOARD_LAYOUT_MATRIX	EQU 2

KEY_HEIGHT EQU 15


; IN	KeyboardLayout - Layout to set
SetKeyboardTables:
	ld	a, (KeyboardLayout)
	or	a
	jr	z, .layout464

	cp	1
	jr	z, .layout6128

	;; Layout matrix
	ld	hl, KeyboardLocationsMatrix
	ld 	(KeyboardLocationTable), hl
	ld	hl, SpecialKeysTableMatrix
	ld 	(SpecialKeysTable), hl
	ret

.layout6128:
	ld	hl, KeyboardLocations6128
	ld 	(KeyboardLocationTable), hl
	ld	hl, SpecialKeysTable6128
	ld 	(SpecialKeysTable), hl
	ret

.layout464:
	ld	hl, KeyboardLocations464
	ld 	(KeyboardLocationTable), hl
	ld	hl, SpecialKeysTable464
	ld 	(SpecialKeysTable), hl
	ret



KEY_COUNT EQU 80

KEYB_TABLE_ROW_SIZE EQU 2
RIGHTSHIFT_TABLE_OFFSET EQU KEY_COUNT*KEYB_TABLE_ROW_SIZE

KEYB_ROW_SPACING EQU KEY_HEIGHT + 1
KEYB_COL_SPACING EQU 4

 DEFINE KEYB_ROW_1 KEYB_Y
 DEFINE KEYB_ROW_2 KEYB_ROW_1 + KEYB_ROW_SPACING
 DEFINE KEYB_ROW_3 KEYB_ROW_2 + KEYB_ROW_SPACING
 DEFINE KEYB_ROW_4 KEYB_ROW_3 + KEYB_ROW_SPACING
 DEFINE KEYB_ROW_5 KEYB_ROW_4 + KEYB_ROW_SPACING
 DEFINE KEYB_ROW_6 KEYB_ROW_5 + KEYB_ROW_SPACING
 DEFINE KEYB_ROW_7 KEYB_ROW_6 + KEYB_ROW_SPACING
 DEFINE KEYB_ROW_8 KEYB_ROW_7 + KEYB_ROW_SPACING
 DEFINE KEYB_ROW_9 KEYB_ROW_8 + KEYB_ROW_SPACING
 DEFINE KEYB_ROW_10 KEYB_ROW_9 + KEYB_ROW_SPACING




SPECIALKEY_RETURN	EQU 0 + #80
SPECIALKEY_SPACE 	EQU 1 + #80
SPECIALKEY_CONTROL 	EQU 2 + #80
SPECIALKEY_COPY		EQU 3 + #80
SPECIALKEY_CAPS		EQU 4 + #80
SPECIALKEY_TAB		EQU 5 + #80
SPECIALKEY_ENTER	EQU 6 + #80
SPECIALKEY_SHIFTL	EQU 7 + #80
SPECIALKEY_SHIFTR	EQU 8 + #80
SPECIALKEY_DEL		EQU 9 + #80

; Special key symbols
; a = Up arrow
; b = Down arrow
; c = Left arrow
; d = Right arrow
; e = Large enter
; f = Small enter
; g = Escape
; h = Clear
; i = Delete (backspace)
; j = Tab
; k = Caps Lock
; l = Shift
; m = Control
; o = Copy


TxtKeySpace: 		db '       SPACE',0
TxtKeySpaceShort:	db ' ',0
TxtKeyShiftL: 		db 'SHFT',0
TxtKeyShiftR: 		db 'SHF',0
TxtKeyShiftShort:	db 'l',0
TxtKeyControl: 		db 'CTRL',0
TxtKeyControlShort:	db 'm',0
TxtKeyCopy: 		db 'COPY',0
TxtKeyCopyShort: 	db 'o',0
TxtKeyCaps: 		db 'CAP',0
TxtKeyCapsShort:	db 'k',0
TxtKeyTab: 		db '->',0
TxtKeyTabShort:		db 'j',0
TxtKeyEnter: 		db 'ENTER',0
TxtKeyEnterShort: 	db 'f',0
TxtKeyDel:		db 'DE',0
TxtKeyDelShort:		db 'i',0
TxtKeyReturn: 		db ' e',0



 INCLUDE "KeyboardLayout6128.asm"
 INCLUDE "KeyboardLayout464.asm"
 INCLUDE "KeyboardLayoutMatrix.asm"

