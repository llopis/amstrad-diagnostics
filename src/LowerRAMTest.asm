        
;; Based on Quick and dirty RAM test for CPC by Gerald
;; http://www.cpcwiki.eu/forum/amstrad-cpc-hardware/quick-and-dirty-ram-test-for-cpc/

	IFDEF UpperROM
TestStartAddress EQU #0000
TestAmount EQU #C000
	ELSE
TestStartAddress EQU #4000
TestAmount EQU #C000
	ENDIF

LowerRAMTest:
	di
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
	ld a,b
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
	ld a,b
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
	ld a,b
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
	ld a,b
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
	ld a,b
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
	jp z,RAMTestPassed


	jp DisplayFailingBits


	INCLUDE "DisplayFailingBits.asm"       


