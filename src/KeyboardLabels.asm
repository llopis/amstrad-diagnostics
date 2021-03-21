
KeyboardLabelsEnglish:
	db 'a' ; 00 : ↑
	db 'd' ; 01 : →
	db 'b' ; 02 : ↓
	db '9' ; 03 : f9
	db '6' ; 04 : f6
	db '3' ; 05 : f3
	db SPECIALKEY_ENTER ; # 06 : ENTER
	db '.' ; # Key number 07 : .

	;; 1
	db 'c' ; # Key number 08 : ←
	db SPECIALKEY_COPY ; # Key number 09 : COPY
	db '7' ; # Key number 10 : f7
	db '8' ; # Key number 11 : f8
	db '5' ; # Key number 12 : f5
	db '1' ; # Key number 13 : f1
	db '2' ; # Key number 14 : f2
	db '0' ; # Key number 15 : f0

	;; 2
	db 'h' ; # Key number 16 : CLR
	db '[' ; # Key number 17 : {[
	db 'e' ; # Key number 18 : RETURN
	db ']' ; # Key number 19 : }]
	db '4' ; # Key number 20 : f4
	db SPECIALKEY_SHIFTL ; # Key number 21 : SHIFT
	db '\' ; # Key number 22 : `\		
	db SPECIALKEY_CONTROL ; # Key number 23 : CONTROL

	;; 3
	db '^' ; # Key number 24 : £^
	db '-' ; # Key number 25 : =-
	db '@' ; # Key number 26 : ¦@
	db 'P' ; # Key number 27 : P
	db ';' ; # Key number 28 : +;
	db ':' ; # Key number 29 : *:
	db '/' ; # Key number 30 : ?/
	db '.' ; # Key number 31 : >.

	;; 4
	db '0' ; # Key number 32 : _0
	db '9' ; # Key number 33 : )9
	db 'O' ; # Key number 34 : O
	db 'I' ; # Key number 35 : I
	db 'L' ; # Key number 36 : L
	db 'K' ; # Key number 37 : K
	db 'M' ; # Key number 38 : M
	db ',' ; # Key number 39 : <,

	;; 5
	db '8' ; # Key number 40 : (8
	db '7' ; # Key number 41 : '7
	db 'U' ; # Key number 42 : U
	db 'Y' ; # Key number 43 : Y
	db 'H' ; # Key number 44 : H
	db 'J' ; # Key number 45 : J
	db 'N' ; # Key number 46 : N
	db SPECIALKEY_SPACE ; # Key number 47 : SPACE

	;; 6
	db '6' ; # Key number 48 : &6
	db '5' ; # Key number 49 : %5
	db 'R' ; # Key number 50 : R
	db 'T' ; # Key number 51 : T
	db 'G' ; # Key number 52 : G
	db 'F' ; # Key number 53 : F
	db 'B' ; # Key number 54 : B
	db 'V' ; # Key number 55 : V

	;; 7
	db '4' ; # Key number 56 : $4
	db '3' ; # Key number 57 : #3
	db 'E' ; # Key number 58 : E
	db 'W' ; # Key number 59 : W
	db 'S' ; # Key number 60 : S
	db 'D' ; # Key number 61 : D
	db 'C' ; # Key number 62 : C
	db 'X' ; # Key number 63 : X

	;; 8
	db '1' ; # Key number 64 : !1
	db '2' ; # Key number 65 : "2
	db 'g' ; # Key number 66 : ESC
	db 'Q' ; # Key number 67 : Q
	db SPECIALKEY_TAB ; # Key number 68 : TAB
	db 'A' ; # Key number 69 : A
	db SPECIALKEY_CAPS ; # Key number 70 : CAPSLOCK
	db 'Z' ; # Key number 71 : Z

	;; 9
	db 'a' ; # Key number 72 : Joystick Up
	db 'b' ; # Key number 73 : Joystick Down
	db 'c' ; # Key number 74 : Joystick Left
	db 'd' ; # Key number 75 : Joystick Right
	db '1' ; # Key number 76 : Joystick Fire 1
	db '2' ; # Key number 77 : Joystick Fire 2
	db '3' ; # Key number 78 : Joystick Fire 3
	db 'i' ; # Key number 79 : DEL

@KeyboardLabelsTableSize EQU $-KeyboardLabelsEnglish
