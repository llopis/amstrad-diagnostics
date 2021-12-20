

MenuItemCount: db MENU_ITEM_COUNT
SelectedMenuItem: db 0


 STRUCT MenuItem
Text WORD
Function WORD
KeybOffset BYTE
BitMask BYTE
 ENDS

MenuTable:
MenuItemLowerRAMTest:
	MenuItem TxtLowerRAMTest, LowerRAMTestSelected, 4, %00010000  	;; L
MenuItemUpperRAMTest:
	MenuItem TxtUpperRAMTest, UpperRAMTestSelected, 5, %00000100	;; U
MenuItemROMTest:
	MenuItem TxtROMTest, ROMTestSelected, 6, %00000100		;; R
MenuItemKeyboardTest:
	MenuItem TxtKeyboardTest, KeyboardTestSelected, 4, %00100000	;; K
MenuItemSoakTest:
	MenuItem TxtSoakTest, SoakTestSelected, 7, %00010000		;; S
MenuTableEnd:

MENU_ITEM_SIZE EQU MenuItemUpperRAMTest-MenuItemLowerRAMTest
MENU_ITEM_COUNT equ ($-MenuTable)/MENU_ITEM_SIZE


TESTRESULT_UNTESTED 	EQU 0
TESTRESULT_PASSED 	EQU 1
TESTRESULT_FAILED 	EQU 2
TESTRESULT_ABORTED 	EQU 3
TESTRESULT_NOTAVAILABLE EQU 4


TestResultTable:
;; 0 - status 
TestResultTableLowerRAM:
	db TESTRESULT_PASSED
TestResultTableUpperRAM:
	db TESTRESULT_UNTESTED
 IFDEF ROM_CHECK
TestResultTableLowerROM:
	db TESTRESULT_UNTESTED
TestResultTableUpperROM:
	db TESTRESULT_UNTESTED
 ELSE
TestResultTableLowerROM:
	db TESTRESULT_NOTAVAILABLE
TestResultTableUpperROM:
	db TESTRESULT_NOTAVAILABLE
 ENDIF
TestResultTableKeyboard:
	db TESTRESULT_UNTESTED
TestResultTableJoystick:
	db TESTRESULT_UNTESTED

