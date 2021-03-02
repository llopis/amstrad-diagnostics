MainTests:
	di
	ld bc,#7F8D                        ; GA deselect upper rom, and mode 1
	out (c),c

	call make_scr_table

	call CheckUpperRAM
	call NewLine

	IFDEF ROM_CHECK
	call DetectROMs
	call NewLine
	ENDIF
	
	call DetectCRTC
	call NewLine
	call TestKeyboard
	call NewLine
	
	call PrintResult
Wait:
	jr Wait



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


TxtTestsFailed: db 'TESTS FAILED',0
TxtSuccess: db '**SUCCESS**',0
ErrorFound: db 0

