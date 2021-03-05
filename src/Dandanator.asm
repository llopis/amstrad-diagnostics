
ScratchByte: db 0

DandanatorPagingStop:
	; Stop paging mode in Dandanator so system lower ROM is accessible
	ld b, %00100000
	jr DandanatorZone0CommandSequence

DandanatorPagingStart:
	; Stop paging mode in Dandanator so system lower ROM is accessible
	ld b, %00000000
	jr DandanatorZone0CommandSequence

DandanatorZone0CommandSequence:
	ld iy, ScratchByte
	db #FD, #FD
	ld (iy+0), b
	ret
