        
;; Based on Quick and dirty RAM test for CPC by Gerald
;; http://www.cpcwiki.eu/forum/amstrad-cpc-hardware/quick-and-dirty-ram-test-for-cpc/

  IFDEF SkipLowerRAMTest
  	DISPLAY "Skipping lower RAM tests."
	di
 	jp RAMTestPassed
  ENDIF

LowerRAMTest:
	di
	;;===================================================== 
	;; PASS0 : Fill screen with #ff
	;;===================================================== 
	ld e, #FF
	ld hl, LOWER_RAM_TEST_START
	ld bc, LOWER_RAM_TEST_SIZE
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
	ld hl, LOWER_RAM_TEST_START
	ld bc, LOWER_RAM_TEST_SIZE
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
	ld hl, LOWER_RAM_TEST_START
	ld bc, LOWER_RAM_TEST_SIZE
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
	ld hl, LOWER_RAM_TEST_START
	ld bc, LOWER_RAM_TEST_SIZE
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
	ld hl, LOWER_RAM_TEST_START
	ld bc, LOWER_RAM_TEST_SIZE
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
	jp z, RAMTestPassed


	DEFINE SOUND_DURATION #F000
	DEFINE SILENCE_DURATION #8000
	DEFINE SOUND_TONE_L #FF
	DEFINE SOUND_TONE_H #01
	INCLUDE "PlaySound.asm"

	INCLUDE "PlaySound.asm"

	INCLUDE "PlaySound.asm"
	UNDEFINE SOUND_DURATION
	UNDEFINE SILENCE_DURATION
	UNDEFINE SOUND_TONE_L
	UNDEFINE SOUND_TONE_H


	jp DisplayFailingBits


	INCLUDE "DisplayFailingBits.asm"       


