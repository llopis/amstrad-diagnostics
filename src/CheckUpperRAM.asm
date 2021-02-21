CheckUpperRAM:
	ld hl,TxtCheckingUpperRAM
	call PrintString
	call NewLine
	
	call IsUpperRAMPresent
	jr z,_CheckUpperRAM_None

	ld hl,TxtYesUpperRAM
	call PrintString
	
	; Loop for all 4 data banks
	ld bc,#7FC4
_CheckUpperRAM_BankLoop:
	ld a,46
	call PrintChar

	push bc
	out (c),c
	
	ld hl, RAMBankStart
	ld de, #4000
	call TestRAM

	ld bc,#7FC0
	out (c),c

	or a
	jr nz,_CheckUpperRAM_Failed
	
	pop bc
	inc c
	ld a,c
	cp #C8
	jr nz,_CheckUpperRAM_BankLoop

	call NewLine
	ld hl,TxtRAMTestPassed
	call PrintString
	call NewLine
	call NewLine
	ret
	
	
_CheckUpperRAM_Failed:
	pop bc
	ld d,a
	push de
	call NewLine
	ld hl,TxtRAMTestFailed
	call PrintString
	call NewLine
	
	pop de
	call PrintFailingBits
	call NewLine
	ret
	
_CheckUpperRAM_None:
	ld hl,TxtNoUpperRAM
	call PrintString
	call NewLine
	call NewLine
	ret
	

TxtCheckingUpperRAM: db 'CHECKING UPPER RAM...',0
TxtNoUpperRAM: db 'NO UPPER RAM DETECTED.',0
TxtYesUpperRAM: db 'FOUND UPPER RAM',0
TxtRAMTestPassed: db 'RAM TEST PASSED.',0
TxtRAMTestFailed: db 'RAM TEST FAILED: ',0

RAMBankStart equ #4000
TestPatternLength equ 4
TestPattern: defb #DE,#AD,#BE,#EF


; OUT Z flag = set no, not set yes
IsUpperRAMPresent:
	; Write test pattern to beginning of bank
	ld hl,TestPattern
	ld de,RAMBankStart
	ld bc,TestPatternLength
	ldir
	
	ld bc,#7FC4
	out (c),c

	; Read it back. If any bytes don't match up, we have upper RAM
	ld hl,RAMBankStart
	ld ix,TestPattern
	ld a,(ix)
	cpi
	jr nz,_IsUpperRAMPresentEnd
	ld a,(ix+1)
	cpi
	jr nz,_IsUpperRAMPresentEnd
	ld a,(ix+2)
	cpi
	jr nz,_IsUpperRAMPresentEnd
	ld a,(ix+3)
	cpi

_IsUpperRAMPresentEnd:
	ld bc,#7FC0
	out (c),c
	ret

; IN HL = Start, BC = length
; OUT A = 0 if good, otherwise failing bits
TestRAM:
	ld a, 1
	ld b, 8     ; test 8 bits
	or a        ; ensure carry is cleared

_TestRAMBits:
	ld (hl), a
	ld c, a     ; for compare
	ld a, (hl)
	cp c
	jr nz, _TestRAMBad
	rla
	djnz _TestRAMBits
	inc hl
	dec de
	ld a, d     ; does de=0?
	or e
	jp z, _TestRAMDone
	jr TestRAM

_TestRAMDone:
	ld a,0
	; ld a,10   ; Uncomment this to test failing case
	ret

_TestRAMBad:
	xor c	; a contains failing bits
	ret


TxtBit: db "BIT ",0
TxtIC: db "IC",0

FirstUpperRAMIC equ 119


; IN D = failing bits
PrintFailingBits:
	; TODO Print which data bits failed
	; TODO Print which ICs are likely bad
	ld b,8
_PrintFailingBits_BitLoop:
	ld a,d
	push de
	push bc
	and 1	; Check if the LSB is set
	jr z, _PrintFailingBits_Next

	ld hl,TxtBit
	call PrintString
	ld a,8
	sub b
	push af
	call PrintNumHex
	
	ld a,CharSpace
	call PrintChar
	ld a,CharLeftParen
	call PrintChar

	ld hl,TxtIC
	call PrintString
	
	pop af
	add a,FirstUpperRAMIC
	call PrintNumDec

	ld a,CharRightParen
	call PrintChar
	call NewLine
	

_PrintFailingBits_Next:
	pop bc
	pop de
	rr d    ; Shift bits right once
	djnz _PrintFailingBits_BitLoop
	
	ret
