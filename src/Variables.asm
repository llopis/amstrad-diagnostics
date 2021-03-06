;; Keyboard
;; This buffer has one byte per keyboard line. 
;; Each byte defines a single keyboard line, which defines 
;; the state for up to 8 keys.
;;
;; A bit in a byte will be '1' if the corresponding key 
;; is pressed, '0' if the key is not pressed.

KeyboardBufferSize equ 10
KeyboardMatrixBuffer: defs KeyboardBufferSize


;; Common
ScratchByte: db 0

;; Main menu
SelectedMenuItem: db 0
 IFDEF UpperROMBuild
UpperROMConfig: db 0				; Here we store the upper ROM we were launched from
 ENDIF


;; Upper RAM test
ValidBlockCount: db 0
FailingBits: db 0
C3ConfigFailed: db 0

;; ROM test
ROMStringBuffer: ds 16


;; Keyboard test
LastKeyboardMatrixBuffer:    defs KeyboardBufferSize
EdgeOnKeyboardMatrixBuffer:  defs KeyboardBufferSize
EdgeOffKeyboardMatrixBuffer: defs KeyboardBufferSize

;; Soak test
SoakTestIndicator: ds 4				; Save 4 bytes
SoakTestCount: db 0

;; Text utils
scr_table: defs 200*2

txt_coords:
txt_y: defb 0
txt_x: defb 0
char_depack_buffer: defs 16

