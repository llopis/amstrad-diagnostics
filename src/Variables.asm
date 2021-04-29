

 IFDEF UpperROMBuild
UpperROMConfig: db 0				; Here we store the upper ROM we were launched from
 ENDIF

;; System info
ModelType: db 0
KeyboardLanguage: db 0
FDCPresent: db 0


;; Upper RAM test
ValidBankCount: db 0
FailingBits: db 0
C3ConfigFailed: db 0
LastReadBank: db #FF, #FF

;; ROM test
ROMStringBuffer: ds 16


;; Soak test
SoakTestIndicator: ds 4				; Save 4 bytes
SoakTestCount: db 0

;; Keyboard test
KeyboardLayout: db 0				; 0: 6128, 1: 464
FramesESCPressed: db 0
FillKeyPattern: db 0
KeyboardLocationTable: dw 0
SpecialKeysTable: dw 0
KeyboardLabels: ds KeyboardLabelsTableSize	; Copy of the labels, patched up with correct language variations
;;KeyboardResult: ds 

;; Keyboard
;; This buffer has one byte per keyboard line. 
;; Each byte defines a single keyboard line, which defines 
;; the state for up to 8 keys.
;;
;; A bit in a byte will be '1' if the corresponding key 
;; is pressed, '0' if the key is not pressed.

KeyboardBufferSize equ 10
KeyboardMatrixBuffer: 	     defs KeyboardBufferSize
LastKeyboardMatrixBuffer:    defs KeyboardBufferSize
EdgeOnKeyboardMatrixBuffer:  defs KeyboardBufferSize
EdgeOffKeyboardMatrixBuffer: defs KeyboardBufferSize
PresseddMatrixBuffer: 	     defs KeyboardBufferSize

;; Print char
@TxtCoords:
@txt_y: defb 0
@txt_x: defb 0
@txt_pixels_y: defb 0
@txt_byte_x: defb 0
@txt_right: db 0			; 0 = draw left char at that byte, 1 = draw right char

@bk_color: db 0
@fg_color: db 0

@scr_table: defs 200*2
char_depack_buffer: defs 16

