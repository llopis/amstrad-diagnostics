
/*
E 1 2 3 4 5 6 7 8 9 0 - ^ C D
T Q W E R T Y U I O P @ [
C  A S D F G H J K L ; : ] RET
SH  Z X C V B N M , . / \   SH
CTL CP      SPACE        ENTER
*/


 DEFINE KEYB_X 5
 DEFINE KEYB_Y 35
 DEFINE JOY_X 26
 DEFINE JOY_Y 130

 DEFINE KEYB_ESC_X KEYB_X
 DEFINE KEYB_Q_X KEYB_ESC_X + KEYB_COL_SPACING + 2
 DEFINE KEYB_A_X KEYB_Q_X + 1
 DEFINE KEYB_Z_X KEYB_A_X + 2

 DEFINE KEYB_NUMPAD_X KEYB_ESC_X+KEYB_COL_SPACING*15

KeyboardLocations6128:
	;; Column, row, char
	;; 0
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*1,	KEYB_ROW_4 ; # Key number 00 : ↑
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*2,	KEYB_ROW_5 ; # Key number 01 : →
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*1,	KEYB_ROW_5 ; # Key number 02 : ↓
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*2,	KEYB_ROW_1 ; # Key number 03 : f9
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*2,	KEYB_ROW_2 ; # Key number 04 : f6
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*2,	KEYB_ROW_3 ; # Key number 05 : f3
	db 50+KEYB_X,				KEYB_ROW_5 ; # Key number 06 : ENTER
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*2,	KEYB_ROW_4 ; # Key number 07 : .

	;; 1
	db KEYB_NUMPAD_X,			KEYB_ROW_5 ; # Key number 08 : ←
	db KEYB_Z_X,				KEYB_ROW_5 ; # Key number 09 : COPY
	db KEYB_NUMPAD_X,			KEYB_ROW_1 ; # Key number 10 : f7
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*1,	KEYB_ROW_1 ; # Key number 11 : f8
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*1,	KEYB_ROW_2 ; # Key number 12 : f5
	db KEYB_NUMPAD_X,			KEYB_ROW_3 ; # Key number 13 : f1
	db KEYB_NUMPAD_X+KEYB_COL_SPACING*1,	KEYB_ROW_3 ; # Key number 14 : f2
	db KEYB_NUMPAD_X,			KEYB_ROW_4 ; # Key number 15 : f0

	;; 20
	db KEYB_ESC_X+KEYB_COL_SPACING*13,	KEYB_ROW_1 ; # Key number 16 : CLR
	db KEYB_Q_X+KEYB_COL_SPACING*11,	KEYB_ROW_2 ; # Key number 17 : {[
	db 54+KEYB_X,				KEYB_ROW_2 ; # Key number 18 : RETURN
	db KEYB_A_X+KEYB_COL_SPACING*11,	KEYB_ROW_3 ; # Key number 19 : }]
	db KEYB_NUMPAD_X,			KEYB_ROW_2 ; # Key number 20 : f4
	db KEYB_X,				KEYB_ROW_4 ; # Key number 21 : SHIFT
	db KEYB_Z_X+KEYB_COL_SPACING*10,	KEYB_ROW_4 ; # Key number 22 : `\		
	db KEYB_X,				KEYB_ROW_5 ; # Key number 23 : CONTROL

	;; 3
	db KEYB_ESC_X+KEYB_COL_SPACING*12,	KEYB_ROW_1 ; # Key number 24 : £^
	db KEYB_ESC_X+KEYB_COL_SPACING*11,	KEYB_ROW_1 ; # Key number 25 : =-
	db KEYB_Q_X+KEYB_COL_SPACING*10,	KEYB_ROW_2 ; # Key number 26 : ¦@
	db KEYB_Q_X+KEYB_COL_SPACING*9,		KEYB_ROW_2 ; # Key number 27 : P
	db KEYB_A_X+KEYB_COL_SPACING*10,	KEYB_ROW_3 ; # Key number 28 : +;
	db KEYB_A_X+KEYB_COL_SPACING*9,		KEYB_ROW_3 ; # Key number 29 : *:
	db KEYB_Z_X+KEYB_COL_SPACING*9,		KEYB_ROW_4 ; # Key number 30 : ?/
	db KEYB_Z_X+KEYB_COL_SPACING*8,		KEYB_ROW_4 ; # Key number 31 : >.

	;; 4
	db KEYB_ESC_X+KEYB_COL_SPACING*10,	KEYB_ROW_1 ; # Key number 32 : _0
	db KEYB_ESC_X+KEYB_COL_SPACING*9,	KEYB_ROW_1 ; # Key number 33 : )9
	db KEYB_Q_X+KEYB_COL_SPACING*8,		KEYB_ROW_2 ; # Key number 34 : O
	db KEYB_Q_X+KEYB_COL_SPACING*7,		KEYB_ROW_2 ; # Key number 35 : I
	db KEYB_A_X+KEYB_COL_SPACING*8,		KEYB_ROW_3 ; # Key number 36 : L
	db KEYB_A_X+KEYB_COL_SPACING*7,		KEYB_ROW_3 ; # Key number 37 : K
	db KEYB_Z_X+KEYB_COL_SPACING*6,		KEYB_ROW_4 ; # Key number 38 : M
	db KEYB_Z_X+KEYB_COL_SPACING*7,		KEYB_ROW_4 ; # Key number 39 : <,

	;; 5
	db KEYB_ESC_X+KEYB_COL_SPACING*8,	KEYB_ROW_1 ; # Key number 40 : (8
	db KEYB_ESC_X+KEYB_COL_SPACING*7,	KEYB_ROW_1 ; # Key number 41 : '7
	db KEYB_Q_X+KEYB_COL_SPACING*6,		KEYB_ROW_2 ; # Key number 42 : U
	db KEYB_Q_X+KEYB_COL_SPACING*5,		KEYB_ROW_2 ; # Key number 43 : Y
	db KEYB_A_X+KEYB_COL_SPACING*5,		KEYB_ROW_3 ; # Key number 44 : H
	db KEYB_A_X+KEYB_COL_SPACING*6,		KEYB_ROW_3 ; # Key number 45 : J
	db KEYB_Z_X+KEYB_COL_SPACING*5,		KEYB_ROW_4 ; # Key number 46 : N
	db 18+KEYB_X,				KEYB_ROW_5 ; # Key number 47 : SPACE

	;; 6
	db KEYB_ESC_X+KEYB_COL_SPACING*6,	KEYB_ROW_1 ; # Key number 48 : &6
	db KEYB_ESC_X+KEYB_COL_SPACING*5,	KEYB_ROW_1 ; # Key number 49 : %5
	db KEYB_Q_X+KEYB_COL_SPACING*3,		KEYB_ROW_2 ; # Key number 50 : R
	db KEYB_Q_X+KEYB_COL_SPACING*4,		KEYB_ROW_2 ; # Key number 51 : T
	db KEYB_A_X+KEYB_COL_SPACING*4,		KEYB_ROW_3 ; # Key number 52 : G
	db KEYB_A_X+KEYB_COL_SPACING*3,		KEYB_ROW_3 ; # Key number 53 : F
	db KEYB_Z_X+KEYB_COL_SPACING*4,		KEYB_ROW_4 ; # Key number 54 : B
	db KEYB_Z_X+KEYB_COL_SPACING*3,		KEYB_ROW_4 ; # Key number 55 : V

	;; 7
	db KEYB_ESC_X+KEYB_COL_SPACING*4,	KEYB_ROW_1 ; # Key number 56 : $4
	db KEYB_ESC_X+KEYB_COL_SPACING*3,	KEYB_ROW_1 ; # Key number 57 : #3
	db KEYB_Q_X+KEYB_COL_SPACING*2,		KEYB_ROW_2 ; # Key number 58 : E
	db KEYB_Q_X+KEYB_COL_SPACING*1,		KEYB_ROW_2 ; # Key number 59 : W
	db KEYB_A_X+KEYB_COL_SPACING*1,		KEYB_ROW_3 ; # Key number 60 : S
	db KEYB_A_X+KEYB_COL_SPACING*2,		KEYB_ROW_3 ; # Key number 61 : D
	db KEYB_Z_X+KEYB_COL_SPACING*2,		KEYB_ROW_4 ; # Key number 62 : C
	db KEYB_Z_X+KEYB_COL_SPACING*1,		KEYB_ROW_4 ; # Key number 63 : X

	;; 8
	db KEYB_ESC_X+KEYB_COL_SPACING*1,	KEYB_ROW_1 ; # Key number 64 : !1
	db KEYB_ESC_X+KEYB_COL_SPACING*2,	KEYB_ROW_1 ; # Key number 65 : "2
	db KEYB_ESC_X,				KEYB_ROW_1 ; # Key number 66 : ESC
	db KEYB_Q_X,				KEYB_ROW_2 ; # Key number 67 : Q
	db KEYB_X,				KEYB_ROW_2 ; # Key number 68 : TAB
	db KEYB_A_X,				KEYB_ROW_3 ; # Key number 69 : A
	db KEYB_X,				KEYB_ROW_3 ; # Key number 70 : CAPSLOCK
	db KEYB_Z_X,				KEYB_ROW_4 ; # Key number 71 : Z

	;; 9
	db 04+JOY_X,				00+JOY_Y ; # Key number 72 : Joystick Up
	db 04+JOY_X,				30+JOY_Y ; # Key number 73 : Joystick Down
	db 00+JOY_X,				15+JOY_Y ; # Key number 74 : Joystick Left
	db 08+JOY_X,				15+JOY_Y ; # Key number 75 : Joystick Right
	db 14+JOY_X,				15+JOY_Y ; # Key number 76 : Joystick Fire 1
	db 18+JOY_X,				15+JOY_Y ; # Key number 77 : Joystick Fire 2
	db 22+JOY_X,				15+JOY_Y ; # Key number 78 : Joystick Fire 3
	db KEYB_ESC_X+KEYB_COL_SPACING*14,	KEYB_ROW_1 ; # Key number 79 : DEL

	db KEYB_Z_X+KEYB_COL_SPACING*11,	KEYB_ROW_4,	SPECIALKEY_SHIFTR ; # Key number 21 : SHIFT


SpecialKeysTable6128:
	db 23				; RETURN
	dw TxtKeyReturn
	db 127				; SPACE
	dw TxtKeySpace
	db 35				; CONTROL
	dw TxtKeyControl
	db 35				; COPY
	dw TxtKeyCopy
	db 27				; CAPS LOCK
	dw TxtKeyCaps
	db 23				; TAB
	dw TxtKeyTab
	db 39				; ENTER
	dw TxtKeyEnter
	db 35				; LEFT SHIFT
	dw TxtKeyShiftL
	db 27				; RIGHT SHIFT
	dw TxtKeyShiftR
	db 16				; DEL
	dw TxtKeyDelShort

 UNDEFINE KEYB_X
 UNDEFINE KEYB_Y
 UNDEFINE KEYB_NUMPAD_X
 UNDEFINE JOY_X
 UNDEFINE JOY_Y
