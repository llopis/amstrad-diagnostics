

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

KEY_COUNT EQU 80


KEYB_TABLE_ROW_SIZE EQU 2
RIGHTSHIFT_TABLE_OFFSET EQU KEY_COUNT*KEYB_TABLE_ROW_SIZE


TxtKeySpace: 		db '       SPACE',0
TxtKeyShiftL: 		db 'SHFT',0
TxtKeyShiftR: 		db 'SHF',0
TxtKeyControl: 		db 'CTRL',0
TxtKeyControlShort:	db 'm',0
TxtKeyCopy: 		db 'COPY',0
TxtKeyCopyShort: 	db 'o',0
TxtKeyCaps: 		db 'CAP',0
TxtKeyTab: 		db '->',0
TxtKeyEnter: 		db 'ENTER',0
TxtKeyEnterShort: 	db 'f',0
TxtKeyDel:		db 'DE',0
TxtKeyDelShort:		db 'i',0
TxtKeyReturn: 		db ' e',0


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

KEYB_ROW_SPACING EQU 16
KEYB_COL_SPACING EQU 4



 INCLUDE "KeyboardLayout6128.asm"
 INCLUDE "KeyboardLayout464.asm"
