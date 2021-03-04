	;; Activate B channel
	ld bc,#F407 ;;<< register
	out (c),c
	ld bc,#F6c0 ;;<<<<<< select register
	out (c),c 
	ld bc,#F600
	out (c),c ;; << back to inactive

	ld bc,#F400 + %10111101 ;; << data
	out (c),c
	ld bc,#F680 ;; << write data to register
	out (c),c
	ld bc,#F600
	out (c),c

	;; Select note for B channel
	ld bc,#F402 ;;<< register
	out (c),c
	ld bc,#F6c0 ;;<<<<<< select register
	out (c),c 
	ld bc,#F600
	out (c),c ;; << back to inactive

	ld bc,#F400 + SOUND_TONE_L ;; << data
	out (c),c
	ld bc,#F680 ;; << write data to register
	out (c),c
	ld bc,#F600
	out (c),c

	ld bc,#F403 ;;<< register
	out (c),c
	ld bc,#F6c0 ;;<<<<<< select register
	out (c),c 
	ld bc,#F600
	out (c),c ;; << back to inactive

	ld bc,#F400 + SOUND_TONE_H ;; << data
	out (c),c
	ld bc,#F680 ;; << write data to register
	out (c),c
	ld bc,#F600
	out (c),c

	;; Select volume for B channel
	ld bc,#F409 ;;<< register
	out (c),c
	ld bc,#F6c0 ;;<<<<<< select register
	out (c),c 
	ld bc,#F600
	out (c),c ;; << back to inactive

	ld bc,#F400 + %00000111 ;; << data
	out (c),c
	ld bc,#F680 ;; << write data to register
	out (c),c
	ld bc,#F600
	out (c),c

	ld bc,SOUND_DURATION
1
	dec bc
	ld a,b
	or c
	jr nz,1B

	;; Deactivate B channel
	ld bc,#F407 ;;<< register
	out (c),c
	ld bc,#F6c0 ;;<<<<<< select register
	out (c),c 
	ld bc,#F600
	out (c),c ;; << back to inactive

	ld bc,#F400 + %10111111 ;; << data
	out (c),c
	ld bc,#F680 ;; << write data to register
	out (c),c
	ld bc,#F600
	out (c),c

	ld bc,SILENCE_DURATION
2:
	dec bc
	ld a,b
	or c
	jr nz,2B

