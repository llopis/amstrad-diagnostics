 MODULE UtilsText


;; By Kevin Thacker from http://cpctech.cpc-live.com/source/sixpix.asm
;; each char is 6 mode 1 pixels wide and 8 mode 1 pixels tall
;; in mode 1, each byte uses 4 pixels
;; so this means that each char uses 2 bytes, with the last 2 pixels of each line are unused.
;; this is done for simplicity.
;;
;; this means each char is 2 bytes wide and 8 bytes tall


;; to work out screen address to draw char to
;; 
;; byte 0   byte 2   byte 3     byte 4        byte 5
;; 0 1 2 3  4 5 6 7  8 9 10 11  12 13 14 15   16 17 18 19

;; first char uses pixels 0,1,2,3,4,5
;; second char uses pixels 6,7,8,9,10,11
;; third char uses 12,13,14,15, 16, 17

;; even/odd x coord

@ScreenCharsWidth equ 53

;; IN: A character to print. 
;; Location: txt_x and txt_y
@PrintChar:
	push	af
	push	bc

	;; x coord, remove bit 0, and multiply by 3
	;; 0->0
	;; 1->0
	;; 2->3
	;; 3->3
	;; 4->6
	;; 5->6
	;; 6->9
	ld 	a, (txt_x)
	srl 	a
	ld 	c,a
	add 	a,a ;; x2
	add 	a,c ;; x3
	ld 	c,a
	ld 	a, (txt_x)
	and 	1
	add 	a, c
	ld 	(txt_byte_x), a

	ld 	a, (txt_x)
	and	1
	ld	(txt_right), a

	;; l == pixel row == text row * 8
	ld 	a, (txt_y)
	add 	a, a
	add 	a, a
	add 	a, a
	ld 	(txt_pixels_y),	a

	pop	bc
	pop	af
	jr	PrintCharWithPixels		;; Jump and return from there


@PrintCharWithPixels:
	push 	hl
	push 	de
	push 	bc

 IFDEF UpperROMBuild	
 	; Disable upper ROM so we can read from the screen
	ld 	bc, #7F00 + %10001101
	out 	(c),c
 ENDIF
	;; work out location of pixel data
	;; 1 bit per pixel font used here
	sub 	' '
	ld 	l,a
	ld 	h,0
	add 	hl,hl
	add 	hl,hl
	add 	hl,hl
	ld 	de,font
	add 	hl,de
	;; convert from 1 bit per pixel to 2 bit per pixel
	call 	depack_char

	ld	a, (txt_byte_x)
	ld	h, a
	ld 	a, (txt_pixels_y)
	ld	l, a

	call 	GetScreenAddress

	;; now display char in appropiate location
	ld 	de,char_depack_buffer
	ex 	de,hl

	call 	display_char2

	;; increment text coord position
	ld 	hl, txt_x
	inc 	(hl)
	ld	a, (txt_right)
	inc	a
	and	1
	ld	(txt_right), a
	ld	hl, txt_byte_x
	inc	(hl)
	or	a
	jr	nz, .sameByteGroup
	inc	(hl)
.sameByteGroup:

 IFDEF UpperROMBuild
	ld bc, RESTORE_ROM_CONFIG
	out (c),c
 ENDIF
	pop bc
	pop de
	pop hl

	ret

display_char2:
	ld	a,(txt_right)
	or 	a
	jp 	nz,display_char_odd
	jp 	display_char_even


@NewLine:
	ld hl,(TxtCoords)
	inc l
	ld h,0
	ld (TxtCoords),hl
	ret

;; set foreground and background colours
@SetTxtColors:
	ld 	a,h
	ld 	(bk_color),a
	ld 	a,l
	ld 	(fg_color),a
	ret

;; convert 1-bit per pixel into 2 bit per pixel
depack_char:
	ld b,8
	ld de,char_depack_buffer
depack_char2:
	push bc
	ld c,(hl)
	call depack_byte
	call depack_byte
	inc hl
	pop bc
	djnz depack_char2
	ret

;; take 4x 1 bit per pixel from one byte and write out 4 2-bit per pixels to one byte

depack_byte:
	xor a
	push	de
	call depack_pixel
	call depack_pixel
	call depack_pixel
	call depack_pixel
	pop	de
	ld (de),a
	inc de
	ret

depack_pixel:
	call depack_pix
	or b
	rlca
	ret

depack_pix:
	;; shift into carry
	rlc 	c
	ld	d, a
	ld 	a, (bk_color)
	ld	b, a
	ld	a, d
	ret 	nc
	ld	d, a
	ld 	a, (fg_color)
	ld	b, a
	ld 	a, d
	ret

scr_NewLine:
	ld a,h
	add a,8
	ld h,a
	ret nc
	ld a,l
	add a,#50
	ld l,a
	ld a,h
	adc a,#c0
	ld h,a
	ret

;; IN: H - x in bytes
;;     L - y in pixels
;; OUT: HL screen address
GetScreenAddress:
	push 	bc
	push 	de
	ld 	c, h
	ld 	h, 0
	add 	hl, hl
	ld 	de, scr_table
	add 	hl, de
	ld 	a, (hl)
	inc 	hl
	ld 	h, (hl)
	ld 	l, a
	ld 	b, 0
	add 	hl,bc
	pop 	de
	pop 	bc
	ret

@MakeScrTable:
	ld ix,scr_table
	ld hl,#c000
	ld b,200
mst1:
	ld (ix+0),l
	ld (ix+1),h
	inc ix
	inc ix
	call scr_NewLine
	djnz mst1
	ret


;; in this example B is the odd char
;; on screen:
;;
;; aaaa aabb bbbb 
;;  0    1    2   
;;
;; pixels from char:
;; bbbb bb

display_char_odd:
	ld b,8
dco1:
	push bc
	push de

	;; read 4 pixels from screen
	;; keep left 2 pixels
	ld a,(de)
	and %11001100
	ld c,a
	;; read font data
	;; shift data two pixels to right
	ld a,(hl)
	rrca
	rrca
	and %00110011
	;; combine with screen
	or c
	ld (de),a
	inc de

	ld a,(hl)
	rlca
	rlca
	and %11001100
	ld c,a
	inc hl
	ld a,(hl)
	rrca
	rrca
	and %00110011
	or c
	ld (de),a
	inc hl
	pop de
	ex de,hl
	call scr_NewLine
	ex de,hl
	pop bc
	djnz dco1
	ret


;; in this example A is the even char
;; on screen:
;;
;; aaaa aabb bbbb 
;;  0    1    2   
;;
;; pixels from char:
;; aaaa aa

display_char_even:
	ld b,8
dce1:
	push bc
	push de

	;; read 4 pixels
	ld a,(hl)
	;; store to screen
	ld (de),a
	inc de
	inc hl

	;; read 4 pixels from screen
	ld a,(de)
	;; isolate the pixels we don't want to change
	and %00110011
	ld c,a

	;; now read 4 pixels from font
	ld a,(hl)
	;; isolate pixels we want
	and %11001100
	;; combine with screen data
	or c
	;; write back to screen
	ld (de),a
	;;inc de
	inc hl
	pop de
	ex de,hl
	call scr_NewLine
	ex de,hl
	pop bc
	djnz dce1
	ret



 INCLUDE "Font.asm"

 ENDMODULE
