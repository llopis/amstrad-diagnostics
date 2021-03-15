 MODULE Dandanator

@DandanatorDisableLowerROM:
	; Disable Dandanator lower ROM so system lower ROM is accessible
	ld a, %10000011
	jr DandanatorConfigCommandSequence

@DandanatorEnableLowerROM:
	; Enable Dandanator lower ROM
	ld a, %10000010
	jr DandanatorConfigCommandSequence

DandanatorConfigCommandSequence:
	ld iy, ScratchByte
	db #FD, #FD
	ld (iy+0), a
	ret


;; Variable, but this resides in RAM, so that's OK
ScratchByte: db 0

 ENDMODULE