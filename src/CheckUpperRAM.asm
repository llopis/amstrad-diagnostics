CheckUpperRAM:
	call UpperRAMPrintTitle
CheckUpperRAMWithoutTitle:
	call UpperRAMSetUpScreen
	call AddAllRAMMarkers
	call RunUpperRAMTests

	call AddAllRAMMarkers
	call CheckC3Config

	call PrintResult
	ret

	
UpperRAMPrintTitle:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtUpperRAMTitle
	ld d,(ScreenCharsWidth - TxtTitleLen - TxtUpperRAMTitleLen)/2
	call PrintTitleBanner
	ret

UpperRAMSetUpScreen:
	ld hl,#0002
	ld (txt_coords),hl
	call SetDefaultColors

	ld de,0
.bankPrintLoop:
	ld hl,BankLabelRows
	add hl,de
	ld a,(hl)
	ld l,a
	ld h,BankLabelXStart
	ld (txt_coords),hl
	ld hl,TxtBank
	call PrintString
	ld a,' '
	call PrintChar
	ld a,e
	add '0'
	call PrintChar
	inc e
	ld a,e
	cp 8
	jr nz,.bankPrintLoop


	ld de,0
.blockPrintLoop:
	ld hl,BlockLabelCols
	add hl,de
	ld a,(hl)
	ld h,a
	ld l,BankLabelYStart-2
	ld (txt_coords),hl
	ld hl,TxtBlock
	call PrintString
	ld a,' '
	call PrintChar
	ld a,e
	add '0'
	call PrintChar
	inc e
	ld a,e
	cp 4
	jr nz,.blockPrintLoop

	ret

PrintResult:
	ld hl,#0014
	ld (txt_coords),hl
	ld hl,TxtTotalMemory
	call PrintString
	ld a,(ValidBlockCount)
	ld l,a
	ld h,0
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	call PrintHLDec
	ld hl,TxtKB
	call PrintString
	call NewLine

	; Only print C3 config if some upper RAM was found
	ld a,(ValidBlockCount)
	or a
	jr z,.printFinalResult

	ld hl,TxtC3Config
	call PrintString
	ld hl,C3ConfigFailed
	ld a,(hl)
	or a
	jr nz,.C3NotSupported
	ld hl,TxtSupported
	call PrintString
	call NewLine

.printFinalResult:
	ld a,(FailingBits)
	or a
	jr nz,.failingTests
	ld hl,TxtRAMTestPassed
	call PrintString
	ret

.failingTests:
	call SetErrorColors
	ld hl,TxtRAMTestFailed
	call PrintString
	ld a,(FailingBits)
	ld d,a
	call PrintFailingBits
	call SetDefaultColors
	ret

.C3NotSupported:
	call SetErrorColors
	ld hl,TxtNot
	call PrintString
	ld a,' '
	call PrintChar
	ld hl,TxtSupported
	call PrintString
	call SetDefaultColors
	jr .printFinalResult	


//////////////////////////////
// Constants


TxtUpperRAMTitle: db ' - UPPER RAM TEST',0
TxtUpperRAMTitleLen EQU $-TxtUpperRAMTitle-1

TxtBank: db 'BANK',0
TxtBlock: db 'BLOCK',0
TxtBlockTesting: db '........',0
TxtBlockInvalid: db '________',0
TxtBlockValid: db '~~~~~~~~',0

TxtTotalMemory: db 'TOTAL UPPER RAM: ',0
TxtKB: db 'KB',0
TxtRAMTestPassed: db 'UPPER RAM TESTS PASSED',0
TxtRAMTestFailed: db 'UPPER RAM TESTS FAILED: ',0
TxtC3Config: db 'C3 CONFIG: ',0
TxtSupported: db 'SUPPORTED',0
TxtNot: db 'NOT',0

BankLabelXStart EQU 4
BankLabelYStart EQU 4
BankLabelRows:  db BankLabelYStart, BankLabelYStart+2, BankLabelYStart+4, BankLabelYStart+6
		db BankLabelYStart+8, BankLabelYStart+10, BankLabelYStart+12, BankLabelYStart+14
BlockLabelCols: db BankLabelXStart+8, BankLabelXStart+17, BankLabelXStart+26, BankLabelXStart+35

RAMBankStart equ #4000
BankNumbers: db #C4, #C5, #C6, #C7

//////////////////////////////
// Variables
ValidBlockCount: db 0
FailingBits: db 0
C3ConfigFailed: db 0



;; Go through every bank and block and clear the first word to 0
AddAllRAMMarkers:
	ld ix,RAMBankStart
	; d = bank
	; e = block
	ld de,#0703

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

	;; Get low nibble from block
	ld a,d
	and #01
	rla
	rla
	rla
	add e
	add 4
	or l
	ld l,a

	;; Set first byte to full block byte
	ld b,#7F
	out (c),l
	ld (ix),l

	;; Next block
	ld a,e
	dec e
	or a
	jr nz,.ramLoop

	;; Next bank
	ld e,3
	ld a,d
	dec d
	or a
	jr nz,.ramLoop

	;; Clear the ones in main memory
	ld bc,0x7FC0
	out (c),c
	ld (ix),0

	ret


RunUpperRAMTests:
	ld hl,ValidBlockCount
	ld (hl),0
	ld ix,RAMBankStart
	; d = bank
	; e = block
	ld de,#0000
.ramLoop:
	push de				; Save the bank and block
	ld b,0
	ld c,d
	ld hl,BankLabelRows
	add hl,bc
	ld a,(hl)
	ld e,a

	pop bc
	push bc	
	ld b,0
	ld hl,BlockLabelCols
	add hl,bc
	ld a,(hl)
	ld d,a

	ld (txt_coords),de
	ld hl,TxtBlockTesting
	call PrintString
	ld (txt_coords),de
	pop de				; Restore bank and block


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

	;; Get low nibble from block
	ld a,d
	and #01
	rla
	rla
	rla
	add e
	add 4
	or l
	ld l,a

	;; Check first byte
	ld b,#7F
	out (c),l
	ld a,(ix)
	cp l
	jr nz, .invalidBlock

	;; Valid block
	ld hl,ValidBlockCount
	inc (hl)

	push de
	ld c,0
	ld b,8
	ld hl, RAMBankStart
.dotLoop:
	push bc
	ld de, #500
	call TestRAM
	pop bc
	or c
	ld c,a

	push af
	ld a,'~'
	call PrintChar
	pop af

	djnz .dotLoop
	pop de

	or a
	jr nz,.failedBlock

.nextBlock:
	;; Next block
	inc e
	ld a,e
	cp 4
	jr nz,.ramLoop

	;; Next bank
	ld e,0
	inc d
	ld a,d
	cp d,8
	jr nz,.ramLoop

	ld bc,#7FC0
	out (c),c

	ret

.failedBlock:
	call SetErrorFound

	ld iy,txt_coords
	ld a,(iy+1)
	sub 8
	ld (iy+1),a

	call SetErrorColors
	ld hl,TxtBlockValid
	call PrintString
	call SetDefaultColors
	jr .nextBlock

.invalidBlock:
	ld hl,TxtBlockInvalid
	call PrintString
	jr .nextBlock


; IN HL = Start, DE = length
; OUT A = 0 if good, otherwise failing bits
TestRAM:
	ld a, 1
	ld b, 8     ; test 8 bits
	or a        ; ensure carry is cleared

.bits:
	ld (hl), a
	ld c, a     ; for compare
	ld a, (hl)
	cp c
	jr nz,.bad
	rla
	djnz .bits
	inc hl
	dec de
	ld a, d     ; does de=0?
	or e
	jp z, .done
	jr TestRAM

.done:
	ld a,0
	IFDEF UpperRAMFailure
		DISPLAY "Simulating upper RAM failure."
		ld a, UpperRAMFailure
	ENDIF
	ret

.bad:
	xor c	; a contains failing bits
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
	ld hl,FailingBits
	ld (hl),a
	ld a,#c
	call SetBorderColor
	ret


ScreenPattern EQU #BE

;; See if the X3 config is supported. When setting C3 we should get blocks 1 3 2 7
CheckC3Config:
	ld hl,C3ConfigFailed
	ld (hl),0
	ld ix,RAMBankStart
	ld iy,#C000
	ld (iy),ScreenPattern
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

	ld bc,#7FC0
	out (c),c
	ret

.noC3:
	ld hl,C3ConfigFailed
	ld (hl),1
	ld bc,#7FC0
	out (c),c
	ret



