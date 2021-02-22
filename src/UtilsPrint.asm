
CharCR equ 13
CharLF equ 10
CharSpace equ 32
CharLeftParen equ 40
CharRightParen equ 41

; IN HL = address of string
PrintString:
	ld a,(hl)
	inc hl
	or a
	ret z
	call PrintChar
    jr PrintString

; IN A = number to rpint
; Modifies BC
PrintNumHex:
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


; IN A = number to rpint
; Modifies BC, D
PrintNumDec:
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


