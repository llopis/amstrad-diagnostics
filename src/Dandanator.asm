
DandanatorPagingStop:
	; Stop paging mode in Dandanator so system lower ROM is accessible
	ld a, %10000011
	jr DandanatorConfigCommandSequence

DandanatorPagingStart:
	; Start paging mode in Dandanator again to diag ROM is in 0x0000-0x3FFFF
	ld a, %10000010
	jr DandanatorConfigCommandSequence

DandanatorConfigCommandSequence:
	ld iy, ScratchByte
	db #FD, #FD
	ld (iy+0), a
	ret
