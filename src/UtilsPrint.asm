PrintChar     equ #BB5A   
	
CharCR equ 13
CharLF equ 10
CharSpace equ 32
CharLeftParen equ 40
CharRightParen equ 41

; IN HL = address of string
PrintString:
    ld a,(hl)    ;Print a '255' terminated string
    cp 255
    ret z
    inc hl
    call PrintChar
    jr PrintString

PrintNewLine:
    ld a,CharCR        ;Carriage return
    call PrintChar
    ld a,CharLF        ;Line Feed
    jp PrintChar

; IN A = number to rpint
; Modifies BC
PrintNumHex:
	ld b,0
	ld c,a
	rr a
	rr a
	rr a
	rr a
_printHexLow:
	and #0f
	cp #0a
	jr nc,_printHexAaf
	add a,#30
	push bc
	call PrintChar
	jr _printHexDone
_printHexAaf:
	add a,#37
	push bc
	call PrintChar
_printHexDone:
	pop bc
	ld a,b
	cp 1
	ret z
	ld a,c
	ld b,1
	jr _printHexLow


; IN A = number to rpint
; Modifies BC, D
PrintNumDec:
	ld d,100
	call _PrintNumDecDigit
	ld d,10
	call _PrintNumDecDigit
	ld d,1
_PrintNumDecDigit:
	ld c,0
_PrintNumDecLoop:
	sub d
	jr c,_PrintNumDecExit
	inc c
	jr _PrintNumDecLoop
_PrintNumDecExit:
	add a,d
	push af
	ld a,c
	add a,#30
	call PrintChar
	pop af
	ret
