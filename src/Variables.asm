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


;; Main menu
LowRAMSuccess: db 0
SelectedMenuItem: db 0
 IFDEF UpperROMBuild
UpperROMConfig: db 0				; Here we store the upper ROM we were launched from
 ENDIF


;; Upper RAM test
ValidBankCount: db 0
FailingBits: db 0
C3ConfigFailed: db 0

;; ROM test
ROMStringBuffer: ds 16


;; Soak test
SoakTestIndicator: ds 4				; Save 4 bytes
SoakTestCount: db 0

;; Keyboard test
FramesESCPressed: db 0
FillKeyPattern: db 0