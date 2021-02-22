        
;;*****************************************************************************
;; RamTestBasic :
;; Entry :
;;   L : command
;;
;; Exit  : 
;;
;;*****************************************************************************
TestStartAddress equ #C000
TestAmount equ #4000


LowerRAMTest::
	;;===================================================== 
	;; PASS0 : Fill screen with #ff
	;;===================================================== 
	ld e, #FF
	ld hl, TestStartAddress
	ld bc, TestAmount
RTB_L0:
	ld (hl), e
	inc hl
	dec bc
	xor a
	or b
	or c
	jr nz, RTB_L0

	;; D contains error bits mask
	ld d, #00

	;;===================================================== 
	;; PASS1 : Check #ff filling and replace with #55
	;;===================================================== 
	ld e, #55
	ld hl, TestStartAddress
	ld bc, TestAmount
RTB_L1:
	ld a, (hl)
	xor #FF                 ; compare to expected
	jr z, RTB_L1OK
	;; error, update error bitmask
	or d
	ld d, a
        
RTB_L1OK:
	ld (hl), e
	inc hl
	dec bc
	xor a
	or b
	or c
	jr nz, RTB_L1

	;;===================================================== 
	;; PASS2 : Check #55 filling and replace with #AA
	;;===================================================== 
	ld e, #AA
	ld hl, TestStartAddress
	ld bc, TestAmount
RTB_L2:
	ld a, (hl)
	xor #55                 ; compare to expected
	jr z, RTB_L2OK
	;; error, update error bitmask
	or d
	ld d, a
        
RTB_L2OK:
	ld (hl), e
	inc hl
	dec bc
	xor a
	or b
	or c
	jr nz, RTB_L2

	;;===================================================== 
	;; PASS3 : Check #AA filling and replace with #00
	;;===================================================== 
	ld e, #00
	ld hl, TestStartAddress
	ld bc, TestAmount
RTB_L3:
	ld a, (hl)
	xor #AA                 ; compare to expected
	jr z, RTB_L3OK
	;; error, update error bitmask
	or d
	ld d, a
        
RTB_L3OK:
	ld (hl), e
	inc hl
	dec bc
	xor a
	or b
	or c
	jr nz, RTB_L3

	;;===================================================== 
	;; PASS4 : Check #00 filling
	;;===================================================== 
	ld hl, TestStartAddress
	ld bc, TestAmount
RTB_L4:
	ld a, (hl)
	xor 0                 ; compare to expected
	jr z, RTB_L4OK
	;; error, update error bitmask
	or d
	ld d, a
        
RTB_L4OK:
	inc hl
	dec bc
	xor a
	or b
	or c
	jr nz, RTB_L4

	IFDEF LowerRAMFailure
		DISPLAY "Simulating lower RAM failure."
		ld d, LowerRAMFailure
	ENDIF

	;;===================================================== 
	;; Display failing bits if any
	;;===================================================== 
	;; D = failing bits

	ld a,d
	or a
	jr z,RAMTestPassed
        
        
RamTestError:
	ld b, #F5
	;; wait for VSYNC
RTE_Sync:
	in a,(c)
	and 1
	jr z, RTE_Sync

	;; Select color 0 register
	ld bc, #7F00
	out (c), c
	;; set to black
	ld c, #54
	out (c), c
	;; Select Border color register
	ld bc, #7F10
	out (c), c
	;; set to black
	ld c, #57
	out (c), c

	;; Wait for visible line
	ld bc, #0806
RTE_WaitLp:
	djnz RTE_WaitLp
	dec c
	jr nz, RTE_WaitLp

	;; Display bit in order
	ld e, #08
        
RTE_BitLp:
	ld b, #7F             ; [2]
	rlc d                   ; [2]
	jr c, RTE_ColErr        ; [2][3]
	ld c, #5a             ; [2]    green (21)
	jr RTE_ColSet           ; [3]
RTE_ColErr:     
	ld c, #4c             ;    [2] red (6s)
	nop                     ;    [1]
	nop                     ;    [1]
RTE_ColSet:
	out (c), c              ; [4]

	;; wait end of line
	;; wait for 7 lines
	ld b, #7B               ; [2]
RTE_L1: 
	djnz RTE_L1

	;; wait for 7 lines
	ld b, #7f
	ld c, #54
	out (c), c              ; [4]
RTE_L2: 
	djnz RTE_L2

	;; loop
	dec e                   ; [1]
	jr nz, RTE_BitLp        ; [3]

	ld bc, #7F57
	out (c), c
	jp RamTestError



RAMTestPassed:
	ld sp, #BFFF
	ld hl, MAINBEGIN
	ld de, MainProgramAddr
	ld bc, ENDOFPROG-MAINBEGIN
	ldir
	jp MainProgramAddr
       
	INCLUDE "Main.asm"

