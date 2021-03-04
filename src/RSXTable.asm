	; ROM header
	db #01, #00, #00, #05

RSXTable:
	dw RSXNames
	jp Bootup
	jp LowerRAMTest


RSXNames:
	dc 'AmsDiag'
	dc 'DIAG'
	db 0                     ;end of name table marker


Bootup:
		PUSH AF
		PUSH BC
		PUSH DE
		PUSH HL
		LD   HL, game_message
loop_show_message:
		LD   A,(HL)
		CALL $BB5A                      ; TXT_OUTPUT
		INC  HL
		OR	 A
		JR   NZ,loop_show_message
		POP  HL
		POP  DE
		POP  BC
		POP  AF
		RET

game_message
    db " Amstrad Diagnostics ",164," Noel Llopis 2021",13,10,13,10,0
