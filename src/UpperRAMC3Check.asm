
SCREEN_PATTERN EQU #BE
OFFSET_INTO_SCREEN EQU #7D0
 

;; See if the X3 config is supported. When setting C3 we should get blocks 1 3 2 7
CheckC3Config:
 IFDEF UpperROMBuild	
 	; Disable upper ROM so we can read from the screen
	ld 	bc, #7F00 + %10001101
	out 	(c),c
 ENDIF

	ld 	hl, C3ConfigFailed
	ld 	(hl),0
	ld 	ix, RAMBANKSTART
	ld 	iy, SCREEN_START + OFFSET_INTO_SCREEN
	ld 	(iy), SCREEN_PATTERN
	; d = bank
	ld 	d, 0
.ramLoop:
	ld	e, 0
	call 	GetPortForBankAndBlock
	push 	hl

	;; First try X4 and make sure this one exists
	ld	l, a
	ld 	bc, #7FFF
	out 	(c), l

	ld 	a, (ix)
	cp 	l
	pop 	hl
	jr 	nz, .nextBank
	ld 	a, (ix+1)
	cp 	b
	jr 	nz, .nextBank

	;; Set up X3 config
	ld 	a,l
	and	%11111000	;; Turn off bits 0-2
	or	%00000011	;; Set config to X3
	ld	l, a
	ld 	bc, #7FFF
	out 	(c), l

	;; First byte of slot 3 should be block 7
	ld	iy, SCREEN_START
	ld 	a, l
	or 	%00000100
	ld 	l, a
	ld 	a, (iy)
	cp 	l
	jr 	nz, .noC3

	;; First byte of slot 2 should be the screen
	ld	iy, RAMBANKSTART + OFFSET_INTO_SCREEN
	ld 	a, (iy)
	cp 	SCREEN_PATTERN
	jr 	nz, .noC3

.nextBank:
	inc 	d
	ld 	a,d
	cp 	8
	jr 	nz,.ramLoop

.end
	ld 	bc, #7FC0
	out 	(c), c

 IFDEF UpperROMBuild	
 	call 	RestoreROMState
 ENDIF
	ret

.noC3:
	ld 	hl, C3ConfigFailed
	ld 	(hl), 1
	jr 	.end


;; Bank-block sequence in binary:
;; 7 - always 1
;; 6 - always 1
;; 5 - bank
;; 4 - bank
;; 3 - bank
;; 2 - always 1
;; 1 - block
;; 0 - block

;; IN: D = bank, E = block
;; OUT: L = port
@GetPortForBankAndBlock:
	ld	a, d
	rla
	rla
	rla
	or	%11000100
	or	e
	ld	l, a
	ret
