
SCREEN_START EQU #C000
PATTERN_CLEAR EQU %00000000
PATTERN_YELLOW EQU %11110000
PATTERN_BLUE EQU %00001111
PATTERN_RED EQU %11111111


CRTCDefaultTable:
	db 63                 ;* R0 = 63     : Horizontal Total
	db 40                 ;* R1 = 40     : Horizontal Displayed
	db 46                 ;* R2 = 46     : Horizontal Sync Position
	db 142                ;* R3 = 8*16+14 : Horizontal and Vertical Sync Widths
	db 38                 ;* R4 = 38     : Vertical Total
	db 0                  ;* R5 =  0     : Vertical Total Adjust
	db 25                 ;* R6 = 25     : Vertical Displayed
	db 30                 ;* R7 = 30     : Vertical Sync position
	db 0                  ;* R8 =  0     : Interlace and Skew
	db 7                  ;* R9 =  7     : Maximum Raster Address
	db 0                  ;R10 
	db 0                  ;R11
	db #30                ;*R12 =        : Display Start Address (#C000 / 16k)
	db #00                ;*R13 =  0     : Display Start Address 
	db #C0                ;R14
	db #00                ;R15
CRTCDefaultTableEnd:

; IN: D = Byte to clear to
InitializeCRTC:
	;; Initialize Display
	ld hl, CRTCDefaultTableEnd
	ld bc, #BC0F      ;; CRTC select 0F
.crtcLoop:
	out (c),c        
	dec hl
	ld a,(hl)
	inc b
	out (c),a
	dec b
	dec c
	jp p,.crtcLoop
	ret

ClearScreen:
	; More efficient clear routine, but we can't do that and have the upper ROM enabled
	/*
	ld hl,#C000
	ld de,#C001
	ld bc,#4000
	ld (hl),0
	ldir
	*/

	ld 	hl, SCREEN_START
	ld 	bc, #4000
	ld	d, 0
.loop:
	ld 	(hl),d
	inc 	hl
	dec 	bc
	ld 	a, b
	or 	c
	jr 	nz, .loop
	ret
	

WaitForVsync:
        ; Wait for Vsync
.frameLoop:
	ld     b,#f5
.vbLoop1
	in    a,(c)
	rra
	jr    nc,.vbLoop1
	ret


;; nibbles swapped!
pen0 equ %00000000
pen1 equ %00001000
pen2 equ %10000000
pen3 equ %10001000

SetTitleColors:
	push	hl
	ld 	h,pen2
	ld 	l,pen0
	call 	SetTxtColors
	pop	hl
	ret

SetDefaultColors:
	push	hl
	ld 	h,pen0
	ld 	l,pen1
	call 	SetTxtColors
	pop	hl
	ret

SetInverseColors:
	push	hl
	ld 	h,pen1
	ld 	l,pen0
	call 	SetTxtColors
	pop	hl
	ret

SetErrorColors:
	push	hl
	ld 	h,pen0
	ld 	l,pen3
	call 	SetTxtColors
	pop	hl
	ret

SetSuccessColors:
	push	hl
	ld 	h,pen0
	ld 	l,pen2
	call 	SetTxtColors
	pop	hl
	ret
	

; IN A = color
SetBorderColor:
	ld bc,#7F10
	out (c),c
	ld bc,#7F00
	add a,#40
	out (c),a
	ret

