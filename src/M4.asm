 MODULE M4BOARD


@M4DisableLowerROM:
	ld	a, 0
	ld	(M4CmdBufferROMEnable), a
	ld	hl, M4CmdBuffer
	call	SendM4Command

	ld 	bc, #7F00 + %10001001           ; Enable lower ROM to refresh M4 state
	out 	(c), c

	ret

@M4EnableLowerROM:
	ld	a, 1
	ld	(M4CmdBufferROMEnable), a
	ld	hl, M4CmdBuffer
	call	SendM4Command

	ld 	bc, #7F00 + %10001001           ; Enable lower ROM to refresh M4 state
	out 	(c),c
	ret


DATAPORT equ #FE00
ACKPORT	 equ #FC00

; Send command to M4
SendM4Command:
	ld	bc, DATAPORT
	ld	d, (hl)
	inc	d
.sendLoop:
	inc	b
	outi
	dec	d
	jr	nz, .sendLoop

	ld	bc, ACKPORT
	out	(c), c
	ret


C_ROMLOW equ #433D

;; Variables but this resides in RAM, so that's OK
M4CmdBuffer:	
	db 3
	dw C_ROMLOW
M4CmdBufferROMEnable:
	db 0

 ENDMODULE
