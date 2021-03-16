
ScreenPattern EQU #BE

;; See if the X3 config is supported. When setting C3 we should get blocks 1 3 2 7
CheckC3Config:
 IFDEF UpperROMBuild	
 	; Disable upper ROM so we can read from the screen
	ld bc, #7F00 + %10001101
	out (c),c
 ENDIF

	ld hl, C3ConfigFailed
	ld (hl),0
	ld ix, RAMBANKSTART
	ld iy, #C000
	ld (iy), ScreenPattern
	; d = bank
	ld d,0
.ramLoop:
	;; Get high nibble from bank
	ld a,d
	rrca
	and #0F
	rla
	rla
	rla
	rla
	add #C0
	ld l,a
	push hl

	;; First try X4 and make sure this one exists
	or #4
	ld l,a
	ld b,#7F
	out (c),l

	ld a,(ix)
	cp l
	pop hl
	jr nz, .nextBank

	;; Set up X3 config
	ld a,l
	and #F0
	or #3
	ld l,a
	ld b,#7F
	out (c),l

	;; First byte of slot 3 should be block 7
	ld a,l
	and #F0
	or #7
	ld l,a
	ld a,(iy)
	cp l
	jr nz, .noC3

	;; First byte of slot 2 should be the screen
	ld a,(ix)
	cp ScreenPattern
	jr nz, .noC3

.nextBank:
	ld e,0
	inc d
	ld a,d
	cp d,8
	jr nz,.ramLoop

.end
	ld bc,#7FC0
	out (c),c

 IFDEF UpperROMBuild	
 	call RestoreROMState
 ENDIF
	ret

.noC3:
	ld 	hl, C3ConfigFailed
	ld 	(hl), 1
	jr 	.end
