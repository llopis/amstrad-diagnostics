MainTests:
	di
	ld bc,#7F8D                        ; GA deselect upper rom, and mode 1
	out (c),c

	call make_scr_table
	call DrawInitialScreen

	call CheckUpperRAM
	call NewLine
	call DetectROMs
	call NewLine
	call DetectCRTC
	call NewLine
	call TestKeyboard
	call NewLine
	
	call PrintResult
Wait:
	jr Wait


DrawInitialScreen:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	call SetTitleColors

	ld hl,TxtTitle
	call PrintString
	ld hl,#0018
	call SetTextCoords
	ld hl,TxtFooter
	call PrintString

	ld hl,#0002
	call SetTextCoords

	call SetDefaultColors
	ld hl,TxtLowerRAMOK
	call PrintString
	call NewLine
	call NewLine
	ret

PrintResult:
	ld hl,ErrorFound
	ld a,(hl)
	or a
	jr z,.success
	
	call SetErrorColors
	ld hl,TxtTestsFailed
	call PrintString
	ret
.success:
	call SetSuccessColors
	ld hl,TxtSuccess
	call PrintString
	ret

SetErrorFound:
	ld a,#c
	call SetBorderColor
	ld hl,ErrorFound
	ld (hl),1
	ret


TxtTitle: db '             AMSTRAD DIAGNOSTICS V', VERSION_STR, BUILD_STR, '               ',0
TxtFooter: db '                  NOEL LLOPIS 2021                   ',0
TxtLowerRAMOK: db 'LOWER RAM OK.',0
TxtTestsFailed: db 'TESTS FAILED',0
TxtSuccess: db '**SUCCESS**',0
ErrorFound: db 0

	INCLUDE "DetectROMs.asm"
	INCLUDE "CheckUpperRAM.asm"
	INCLUDE "UtilsPrint.asm"
	INCLUDE "UtilsText.asm"
	INCLUDE "Screen.asm"
	INCLUDE "DetectCRTC.asm"
	INCLUDE "KeyboardTest.asm"

