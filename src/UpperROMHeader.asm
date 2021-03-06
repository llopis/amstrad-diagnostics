	; ROM header
	db #01, #00, #00, #05

RSXTable:
	dw RSXNames
	jp Bootup
	jp StartDiagCommand


RSXNames:
	dc 'Ams DIAG'
	dc 'DIAG'
	db 0                     ;end of name table marker


Bootup:
	push af
	push bc
	push de
	push hl
	ld hl, TxtInitializationText
.showMessage:
	ld a,(hl)
	call $bb5a                      ; txt_output
	inc hl
	or a
	jr nz, .showMessage
	pop hl
	pop de
	pop bc
	pop af
	ret

StartDiagCommand:
	; C contains the upper ROM the command was executed from
	ld iyh,c		; Save it in iyh
	jp TestStart


TxtInitializationText:
    db " Amstrad Diagnostics v",VERSION_STR," |diag",13,10,13,10,0
