
/*
D
  1 2 E Q T A C Z
  4 3 E W S D C X
  6 5 R T G F B V
  8 7 U Y H J N SPACE
  0 9 O I L K M ,
  ^ - @ P ; : / .
  C [ E ] 4 SH \ CT
  L C 7 8 5 1 2 0
  U R D 9 6 3 E .
*/


 DEFINE KEYB_X 21
 DEFINE KEYB_Y 25


KeyboardLocationsMatrix:
	;; Column, row, char
	;; 0
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_10 ; # Key number 00 : ↑
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_10 ; # Key number 01 : →
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_10 ; # Key number 02 : ↓
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_10 ; # Key number 03 : f9
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_10 ; # Key number 04 : f6
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_10 ; # Key number 05 : f3
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_10 ; # Key number 06 : ENTER
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_10 ; # Key number 07 : .

	;; 1
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_9 ; # Key number 08 : ←
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_9 ; # Key number 09 : COPY
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_9 ; # Key number 10 : f7
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_9 ; # Key number 11 : f8
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_9 ; # Key number 12 : f5
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_9 ; # Key number 13 : f1
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_9 ; # Key number 14 : f2
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_9 ; # Key number 15 : f0

	;; 2
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_8 ; # Key number 16 : CLR
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_8 ; # Key number 17 : {[
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_8 ; # Key number 18 : RETURN
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_8 ; # Key number 19 : }]
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_8 ; # Key number 20 : f4
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_8 ; # Key number 21 : SHIFT
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_8 ; # Key number 22 : `\		
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_8 ; # Key number 23 : CONTROL

	;; 3
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_7 ; # Key number 24 : £^
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_7 ; # Key number 25 : =-
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_7 ; # Key number 26 : ¦@
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_7 ; # Key number 27 : P
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_7 ; # Key number 28 : +;
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_7 ; # Key number 29 : *:
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_7 ; # Key number 30 : ?/
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_7 ; # Key number 31 : >.

	;; 4
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_6 ; # Key number 32 : _0
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_6 ; # Key number 33 : )9
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_6 ; # Key number 34 : O
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_6 ; # Key number 35 : I
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_6 ; # Key number 36 : L
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_6 ; # Key number 37 : K
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_6 ; # Key number 38 : M
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_6 ; # Key number 39 : <,

	;; 5
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_5 ; # Key number 40 : (8
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_5 ; # Key number 41 : '7
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_5 ; # Key number 42 : U
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_5 ; # Key number 43 : Y
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_5 ; # Key number 44 : H
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_5 ; # Key number 45 : J
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_5 ; # Key number 46 : N
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_5 ; # Key number 47 : SPACE

	;; 6
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_4 ; # Key number 48 : &6
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_4 ; # Key number 49 : %5
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_4 ; # Key number 50 : R
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_4 ; # Key number 51 : T
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_4 ; # Key number 52 : G
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_4 ; # Key number 53 : F
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_4 ; # Key number 54 : B
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_4 ; # Key number 55 : V

	;; 7
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_3 ; # Key number 56 : $4
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_3 ; # Key number 57 : #3
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_3 ; # Key number 58 : E
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_3 ; # Key number 59 : W
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_3 ; # Key number 60 : S
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_3 ; # Key number 61 : D
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_3 ; # Key number 62 : C
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_3 ; # Key number 63 : X

	;; 8
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_2 ; # Key number 64 : !1
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_2 ; # Key number 65 : "2
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_2 ; # Key number 66 : ESC
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_2 ; # Key number 67 : Q
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_2 ; # Key number 68 : TAB
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_2 ; # Key number 69 : A
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_2 ; # Key number 70 : CAPSLOCK
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_2 ; # Key number 71 : Z

	;; 9
	db KEYB_X+KEYB_COL_SPACING*1,	KEYB_ROW_1 ; # Key number 72 : Joystick Up
	db KEYB_X+KEYB_COL_SPACING*2,	KEYB_ROW_1 ; # Key number 73 : Joystick Down
	db KEYB_X+KEYB_COL_SPACING*3,	KEYB_ROW_1 ; # Key number 74 : Joystick Left
	db KEYB_X+KEYB_COL_SPACING*4,	KEYB_ROW_1 ; # Key number 75 : Joystick Right
	db KEYB_X+KEYB_COL_SPACING*5,	KEYB_ROW_1 ; # Key number 76 : Joystick Fire 1
	db KEYB_X+KEYB_COL_SPACING*6,	KEYB_ROW_1 ; # Key number 77 : Joystick Fire 2
	db KEYB_X+KEYB_COL_SPACING*7,	KEYB_ROW_1 ; # Key number 78 : Joystick Fire 3
	db KEYB_X+KEYB_COL_SPACING*8,	KEYB_ROW_1 ; # Key number 79 : DEL

	db KEYB_Z_X+KEYB_COL_SPACING*11,	KEYB_ROW_4,	SPECIALKEY_SHIFTR ; # Key number 21 : SHIFT


SpecialKeysTableMatrix:
	db KEY_HEIGHT			; RETURN
	dw TxtKeyReturn+1
	db KEY_HEIGHT			; SPACE
	dw TxtKeySpaceShort
	db KEY_HEIGHT			; CONTROL
	dw TxtKeyControlShort
	db KEY_HEIGHT			; COPY
	dw TxtKeyCopyShort
	db KEY_HEIGHT			; CAPS LOCK
	dw TxtKeyCapsShort
	db KEY_HEIGHT			; TAB
	dw TxtKeyTabShort
	db KEY_HEIGHT			; ENTER
	dw TxtKeyEnterShort
	db KEY_HEIGHT			; LEFT SHIFT
	dw TxtKeyShiftShort
	db KEY_HEIGHT			; RIGHT SHIFT
	dw TxtKeyShiftShort
	db KEY_HEIGHT			; DEL
	dw TxtKeyDelShort

 UNDEFINE KEYB_X
 UNDEFINE KEYB_Y

