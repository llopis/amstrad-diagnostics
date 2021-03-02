CheckUpperRAM:
	call UpperRAMSetUpScreen

	call IsUpperRAMPresent
	jr z,.none

	ld hl,TxtYesUpperRAM
	call PrintString
	
	; Loop for all 4 data banks
	ld bc,#7FC4
.loop:
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
	jr nz,.failed
	
	pop bc
	inc c
	ld a,c
	cp #C8
	jr nz,.loop

	call NewLine
	ld hl,TxtRAMTestPassed
	call PrintString
	call NewLine
	ret
	
.failed:
	pop bc
	ld d,a
	push de
	call NewLine
	call SetErrorColors
	ld hl,TxtRAMTestFailed
	call PrintString
	call NewLine
	
	pop de
	call PrintFailingBits
	call SetDefaultColors

	call SetErrorFound
	ret
	
.none:
	ld hl,TxtNoUpperRAM
	call PrintString
	call NewLine
	ret
	
UpperRAMSetUpScreen:
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,#0000
	call SetTextCoords
	call SetTitleColors
	ld hl,TxtUpperRAMTitle
	call PrintString

	ld hl,#0002
	call SetTextCoords
	call SetDefaultColors
	ret


TxtUpperRAMTitle: db '       AMSTRAD DIAGNOSTICS - UPPER RAM TEST          ',0
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
	jr nz,.end
	ld a,(ix+1)
	cpi
	jr nz,.end
	ld a,(ix+2)
	cpi
	jr nz,.end
	ld a,(ix+3)
	cpi

.end:
	ld bc,#7FC0
	out (c),c
	ret

; IN HL = Start, BC = length
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


TxtBit: db "BIT ",0
TxtIC: db "IC",0

FirstUpperRAMIC equ 119


; IN D = failing bits
PrintFailingBits:
	; TODO Print which data bits failed
	; TODO Print which ICs are likely bad
	ld b,8
.loop:
	ld a,d
	push de
	push bc
	and 1	; Check if the LSB is set
	jr z, .next

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
	

.next:
	pop bc
	pop de
	rr d    ; Shift bits right once
	djnz .loop
	
	ret
