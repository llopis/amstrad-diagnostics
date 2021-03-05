	; ROM header
	db #01, #00, #00, #05

RSXTable:
	dw RSXNames
	jp Bootup
	jp StartDiagCommand


RSXNames:
	dc 'AmsDiag'
	dc 'DIAG'
	db 0                     ;end of name table marker


Bootup:
	push af
	push bc
	push de
	push hl
	ld hl, game_message
loop_show_message:
	ld a,(hl)
	call $bb5a                      ; txt_output
	inc hl
	or a
	jr nz, loop_show_message
	pop hl
	pop de
	pop bc
	pop af
	ret

StartDiagCommand:
	; C contains the upper ROM the command was executed from
	ld iyh,c		; Save it in iyh
	jp TestStart


game_message
    db " Amstrad Diagnostics |DIAG",13,10,13,10,0
