
CharCR equ 13
CharLF equ 10

; IN HL = address of string
PrintString:
	ld a,(hl)
	inc hl
	or a
	ret z
	call PrintChar
    jr PrintString

; IN A = number to print
; Modifies BC
PrintAHex:
	ld b,0
	ld c,a
	rr a
	rr a
	rr a
	rr a
.low:
	and #0f
	cp #0a
	jr nc,.af
	add a,#30
	push bc
	call PrintChar
	jr .done
.af:
	add a,#37
	push bc
	call PrintChar
.done:
	pop bc
	ld a,b
	cp 1
	ret z
	ld a,c
	ld b,1
	jr .low


; IN A = number to print
; Modifies BC
PrintHLHex:
	ld a,h
	call PrintAHex
	ld a,l
	call PrintAHex
	ret


; IN A = number to rpint
; Modifies BC, D
PrintADec:
	ld d,100
	call .digit
	ld d,10
	call .digit
	ld d,1
.digit:
	ld c,0
.loop:
	sub d
	jr c,.exit
	inc c
	jr .loop
.exit:
	add a,d
	push af
	ld a,c
	add a,#30
	call PrintChar
	pop af
	ret


PrintHLDec:
	ld b,0
	ld de,10000
	call .digit
	ld de,1000
	call .digit
	ld de,100
	call .digit
	ld de,10
	call .digit
	ld b,1   ; We want to print this digit for sure
	ld de,1
.digit:
	xor a
.loop:
	scf
	ccf
	sbc hl,de
	jr c,.exit
	inc a
	jr .loop
.exit:
	add hl,de

	; Skip leading zeroes
	ld c,a
	or a
	jr nz,.nonZeroChar
	ld a,b
	or a
	ret z
.nonZeroChar:
	ld b,1
	ld a,c
	add a,#30
	call PrintChar
	ret
