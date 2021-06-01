 MODULE UPPERRAMTEST

;; OUT	ValidBankCount - contains number of available upper banks
@CalculateTotalUpperRAM:
	call 	ClearAllRAMBlockMarkers
	call 	DetectAvailableUpperRAM
	ret

@CheckUpperRAM:
	call 	UpperRAMPrintTitle
@CheckUpperRAMWithoutTitle:
	call 	PrintAvailableUpperRAM

	call 	SetUpScreen4MB

	ld	a, 0
	ld	(FailingBits), a
	call 	ClearAllRAMBlockMarkers
	call 	RunUpperRAMTests4MB
	or	a
	jr	nz, .printAborted

	call 	ClearAllRAMBlockMarkers
	call 	CheckC3Config

	call 	PrintResult
	ret

.printAborted:
	call	PrintAborted
	ret

	
UpperRAMPrintTitle:
	ld d, 0
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtUpperRAMTitle
	ld d,(ScreenCharsWidth - TxtTitleLen - TxtUpperRAMTitleLen)/2
	call PrintTitleBanner
	ret


PrintAvailableUpperRAM:
	call	SetDefaultColors
	ld 	hl, #0002
	ld 	(TxtCoords),hl
	ld 	hl,TxtTotalMemory
	call 	PrintString
	ld 	a, (ValidBankCount)
	ld 	l,a
	ld 	h,0
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	call 	PrintHLDec
	ld 	hl,TxtKB
	call 	PrintString
	call 	NewLine

	ret


SetUpScreen4MB:
	call 	SetDefaultColors

	ld	l, BANKLABELYSTART4MB
	ld 	de, 0
.lineLoop:
	ld	h, BANKLABELXSTART4MB
	ld 	(TxtCoords), hl
	push	hl

	ld 	hl, TxtBank
	call 	PrintString
	ld	hl, txt_x
	inc	(hl)

.bankLoop:
	ld 	a, e
	call 	PrintAHex
	inc	e

	ld 	hl, txt_x
	ld	a, (hl)
	add	10
	ld	(hl), a

	ld	a, e
	and	%00000011
	jr	nz, .bankLoop

	pop	hl
	inc	l

	ld 	a, e
	cp 	#40
	jr 	nz, .lineLoop

	;; Message to press ESC only if it's not soak mode
	call IsSoakTestRunning
	jp z, .skipESCToCancel

	ld	h, 0
	ld	l, RESULT_Y
	ld	(TxtCoords), hl
	ld	hl, TxtPressESCToCancel
	call	PrintString

.skipESCToCancel:
	ret


PrintResult:
	;; Clear line telling to press key
	ld	h, 0
	ld	l, RESULT_Y
	ld	(TxtCoords), hl
	ld	b, 30
.loop:
	ld	a, ' '
	call	PrintChar
	djnz	.loop

	ld	h, 0
	ld	l, RESULT_Y
	ld	(TxtCoords), hl
	; Only print C3 config if some upper RAM was found
	ld 	a, (ValidBankCount)
	or 	a
	jr 	z, .printFinalResult

	call	SetDefaultColors
	ld 	hl,TxtC3Config
	call 	PrintString
	ld 	hl,C3ConfigFailed
	ld 	a,(hl)
	or 	a
	jr 	nz,.C3NotSupported
	ld 	hl,TxtSupported
	call 	PrintString
	call 	NewLine

.printFinalResult:
	ld 	a, (FailingBits)
	or 	a
	jr 	nz,.failingTests

	;; Remember success
	ld	a, TESTRESULT_PASSED
	ld	(TestResultTableUpperRAM), a

	call	SetSuccessColors
	ld 	hl,TxtRAMTestPassed
	call 	PrintString
	ret

.failingTests:
	call 	SetErrorColors
	ld 	hl,TxtRAMTestFailed
	call 	PrintString
	ld 	a,(FailingBits)
	ld 	d,a
	call 	PrintFailingBits
	call 	SetDefaultColors

	;; Remember failure
	ld	a, TESTRESULT_FAILED
	ld	(TestResultTableUpperRAM), a
	
	ret

.C3NotSupported:
	call 	SetErrorColors
	ld 	hl,TxtNot
	call 	PrintString
	ld 	a,' '
	call 	PrintChar
	ld 	hl,TxtSupported
	call 	PrintString
	call 	NewLine
	call 	SetDefaultColors
	jr 	.printFinalResult	



PrintAborted:
	;; Remember failure
	ld	a, TESTRESULT_ABORTED
	ld	(TestResultTableUpperRAM), a

	;; Clear line telling to press key
	ld	h, 0
	ld	l, RESULT_Y
	ld	(TxtCoords), hl
	ld	b, 30
.loop:
	ld	a, ' '
	call	PrintChar
	djnz	.loop


	call	SetErrorColors
	ld	h, 0
	ld	l, RESULT_Y
	ld	(TxtCoords), hl
	ld	hl, TxtTestAborted
	call	PrintString
	ret



TxtUpperRAMTitle: db ' - UPPER RAM TEST',0
TxtUpperRAMTitleLen EQU $-TxtUpperRAMTitle-1

TxtBank: db 'BANK',0
TxtTotalMemory: db 'TOTAL UPPER RAM: ',0
TxtRAMTestPassed: db 'UPPER RAM TESTS PASSED',0
TxtRAMTestFailed: db 'UPPER RAM TESTS FAILED: ',0
TxtC3Config: db 'C3 CONFIG: ',0
TxtSupported: db 'SUPPORTED',0
TxtNot: db 'NOT',0
TxtPressESCToCancel: db 'PRESS ESC TO CANCEL TEST',0
TxtTestAborted: db 'TEST ABORTED PRESS ANY KEY FOR MAIN MENU',0
TxtInvalidBank: db '________',0
TxtValidBank: 	db '........',0


BANKLABELXSTART4MB EQU 1
BANKLABELYSTART4MB EQU 4
RESULT_Y EQU #16


@RAMBANKSTART equ #4000

;; Port sequence for full 4MB:
;; 7F 7E 7D 7C 7B 7A 70 78

;; Bank block table
;; C4 C5 C6 C7 
;; CC CD CE CF
;; D4 D5 D6 D7
;; DC DD DE DF
;; E4 E5 E6 E7
;; EC ED EE EF
;; F4 F5 F6 F7
;; FC FD FE FF


;; Go through every bank and set the first word to 0
ClearAllRAMBlockMarkers:
	;; In this case we want to iterate through the banks backwards because if a bank doesn't exit, we'll get the default one
	;; so we want to leave that one for last
	ld 	ix, RAMBANKSTART
	ld 	bc, #78FF

.loop512K:
	ld 	d, 7

.bankLoop:
	ld 	e, 0

.blockLoop:
	call 	GetPortForBankAndBlock

	;; Set first two bytes to 0
	out 	(c), l
	ld 	(ix), 0
	ld 	(ix+1), 0

	;; Next block
	inc 	e
	ld 	a, e
	cp 	4
	jr 	nz, .blockLoop

	;; Next bank
	ld 	a, d
	dec 	d
	or 	a
	jr 	nz, .bankLoop

	; Next section of 512K (from #7F to #78) for a total of 4MB
	ld	a, b
	inc	b
	cp	#7F
	jr 	nz, .loop512K

	;; Clear the ones in main memory
	ld 	bc, #7FC0
	out 	(c), c
	ld 	(ix), #FF
	ld 	(ix+1), #FF

	ret



;; Find all available upper RAM checking if each bank works
;; Updates ValidBankCount
DetectAvailableUpperRAM:
	ld 	a, 0
	ld 	(ValidBankCount), a
	ld	a, #FF
	ld	(LastReadBank), a
	ld	(LastReadBank+1), a
	ld 	ix, RAMBANKSTART
	ld 	bc, #7FFF
	; d = bank
	; e = block
.loop512K:
	ld 	d, 0

.bankLoop:
	ld 	e, 0

	call 	GetPortForBankAndBlock
	out 	(c), l				;; Swap banks

	;; If we read #FF or the same data as last bank, then this is not a valid bank
	push	de
	call	IsBankValid
	pop	de
	jr	z, .nextBank

	;; Valid bank
	ld 	hl, ValidBankCount
	inc 	(hl)

	call	UpdateBankData

.nextBank:
	;; Next bank
	inc	d
	ld 	a, d
	cp	8
	jr 	nz, .bankLoop

	; Next section of 512K (from #7F to #78) for a total of 4MB
	dec 	b
	ld 	a, b
	cp 	#77
	jr 	nz, .loop512K

	ld 	bc, #7FC0
	out 	(c), c

	ret


;; OUT: A = 0 normal ending, 1 aborted

RunUpperRAMTests4MB:
	ld	a, #FF
	ld	(LastReadBank), a
	ld	(LastReadBank+1), a
	ld	h, BANKLABELXSTART4MB+8
	ld	l, BANKLABELYSTART4MB
	ld	(TxtCoords), hl

	ld 	bc, #7FFF
.loop512K:
	ld 	d, 0

.bankLoop:
	ld 	e, 0

	call 	GetPortForBankAndBlock
	out 	(c), l

	push	de
	call	IsBankValid
	pop	de
	jr	z, .invalidBank

	call	PrintBank

.blockLoop:
	call 	GetPortForBankAndBlock

	out 	(c), l

	push	bc
	push 	de
	ld 	c, 0
	ld 	b, 2
	ld 	hl, RAMBANKSTART
.dotLoop:
	;; Check if ESC was pressed and if so abort test
	call	CheckESC

	push 	bc
	ld 	de, #2000
	call 	TestRAM
	pop 	bc
	or 	c
	ld 	c,a			; C = bad bit pattern so far

	push 	af
	call 	SetSuccessColors
	ld 	a,'~'
	call 	PrintChar
	pop 	af

	djnz 	.dotLoop

	pop 	de
	pop	bc

	or a
	jr nz,	.failedBlock

.nextBlock:
	call	UpdateBankData
	inc 	e
	ld 	a, e

.notFirstBlock:
	cp 	4
	jr 	nz, .blockLoop

.nextBank:
	;; Next bank
	ld	a, (txt_x)
	add	4
	ld	(txt_x),a

	inc 	d
	ld 	a, d
	and	a, %00000011			;; Every 4 banks, move to the next line
	jr	nz, .sameLine
	ld	a, BANKLABELXSTART4MB+8
	ld	(txt_x), a
	ld	hl, txt_y
	inc	(hl)

.sameLine:
	ld	a, d
	cp 	8
	jr 	nz, .bankLoop

	; Next section of 512K (from #7F to #78) for a total of 4MB
	dec 	b
	ld 	a, b
	cp 	#77
	jp 	nz, .loop512K

	ld 	bc, #7FC0
	out 	(c),c

	ld	a,0
	ret

.invalidBank:
	call	SetDefaultColors
	ld 	hl, TxtInvalidBank
	call 	PrintString
	jr 	.nextBank

.failedBlock:
	call 	SetErrorFound

	ld 	hl, txt_x
	ld 	a, (hl)
	dec	a
	dec	a
	ld 	(hl), a

	call SetErrorColors
	ld a,'~'
	call PrintChar
	ld a,'~'
	call PrintChar
	call SetDefaultColors
	jr .nextBlock


PrintBank:
	push	bc
	push 	de				; Save the bank and block

	call 	SetDefaultColors
	ld	hl, TxtValidBank
	call	PrintString
	ld	a, (txt_x)
	sub	8
	ld	(txt_x), a

	pop 	de				; Restore bank and block
	pop	bc
	ret


IsBankValid:	
	;; If we read #FF or the same data as last bank, then this is not a valid bank
	ld 	ix, RAMBANKSTART
	ld 	a, (ix)
	cp 	#FF
	ret	z
	ld	e, a
	ld	a, (LastReadBank)
	cp	e
	ret	z

	ld 	a, (ix+1)
	cp 	#FF
	ret	z
	ld	e, a
	ld	a, (LastReadBank+1)
	cp	e
	ret	z
	ret

UpdateBankData:
	ld 	ix, RAMBANKSTART
	ld	(ix), #FF
	ld	(ix+1), #FF
	ld	a, (ix)
	ld	(LastReadBank), a
	ld	a, (ix+1)
	ld	(LastReadBank+1), a
	ret

CheckESC:
	push	hl
	push 	de
	push	bc
	call 	ReadFullKeyboard
	call 	UpdateKeyBuffers
	pop	bc
	pop	de
	pop	hl
	ld 	a, (KeyboardMatrixBuffer+8)
	bit	2, a					; ESC
	ret	z			

.testAborted:
	ld 	bc, #7FC0
	out 	(c),c

	pop	hl
	pop	hl
	ld	a,1
	ret



; IN HL = Start, DE = length
; OUT A = 0 if good, otherwise failing bits
TestRAM:
	ld 	a, 1
	ld 	b, 8     ; test 8 bits
	or 	a        ; ensure carry is cleared

.bits:
	ld 	(hl), a
	ld 	c, a     ; for compare
	ld 	a, (hl)
	cp 	c
	jr 	nz,.bad
	rla
	djnz 	.bits
	inc 	hl
	dec 	de
	ld 	a, d     ; does de=0?
	or 	e
	jp 	z, .done
	jr 	TestRAM

.done:
	ld 	a, 0
	IFDEF UpperRAMFailure
		DISPLAY "Simulating upper RAM failure."
		ld a, UpperRAMFailure
	ENDIF
	ret

.bad:
	xor 	c	; a contains failing bits
	ret


FirstUpperRAMIC equ 119


; IN D = failing bits
PrintFailingBits:
	ld b,8
.loop:
	ld a,d
	push de
	push bc
	and 1	; Check if the LSB is set
	jr z, .next

	ld a,8
	sub b
	call PrintAHex
	
	ld a,' '
	call PrintChar
	

.next:
	pop bc
	pop de
	rr d    ; Shift bits right once
	djnz .loop
	
	ret


SetErrorFound:
	ld 	hl, FailingBits
	ld 	(hl), a
	ld 	a, #c
	call 	SetBorderColor
	ret





 ENDMODULE
