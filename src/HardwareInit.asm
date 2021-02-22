	INCLUDE "Config.asm"
    
;; Reset vector
;==============================================================================
;
;  Simple boot :
;     initialise ROM overlay
;     set basic RST vectors
;  
;==============================================================================
;; RESET
;; RST #00
	ORG #0000
	
	ld bc, #7F89
	out (c),c        ;; CRTC RMR : Disable Upper Rom, Enable Lower ROM, mode 1
	jp __HwInit

;; RST #08
	PADORG #0008
	ret
  
;; RST #10
	PADORG #0010
	ret
  
;; RST #18
	PADORG #0018
	ret
  
;; RST #20
	PADORG #0020
	ret
  
;; RST #28
	PADORG #0028
	ret
  
;; RST #30
	PADORG #0030
	ret

;; RST #38
;; IRQ
	PADORG #0038
	ret
  
;;*****************************************************************************
;; screen 40*25, use 16k from #C000 to #FFFF
;;*****************************************************************************
HwInit_Crtc_base:
	db 63                 ;* R0 = 63     : Horizontal Total
	db 40                 ;* R1 = 40     : Horizontal Displayed
	db 46                 ;* R2 = 46     : Horizontal Sync Position
	db 142                ;* R3 = 128+15 : Horizontal and Vertical Sync Widths
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
HwInit_Crtc50:
HWInit_GAInk:
  db #44, #4A, #53, #4C, #5C, #4C, #4E, #4A
  db #5C, #4C, #4E, #4A, #5C, #4C, #4E, #4A
  db #57   ; Border color
    
__HwInit:
	;; Disable Interrupt (warm boot)
	di
	;; Initialize IOs
	ld BC, #F782     ;; PPI control Reg = #82
	out (C),C
	ld BC, #F400     ;; PPI Port A=0
	out (C),C
	ld BC, #F600     ;; PPI Port C=0
	out (C),C
	ld BC, #EF7F     ;; Printer port all high
	out (C),C

	;; Initialize Display
	ld HL, HwInit_Crtc50     ;; CRTC init table for 50Hz
	ld BC, #BC0F      ;; CRTC select 0F
HwInit_CrtcLoop:
	out (C),C        
	dec HL
	ld A,(HL)
	inc B
	out (C), A
	dec B
	dec C
	jp P, HwInit_CrtcLoop
  
  ;; Init GA color
HwInit_GAC:
	ld e, 17
	ld HL, HWInit_GAInk ;; CRTC color init table
	ld BC, #7F00        ;;
HwInit_GACLoop:
	out (C),C
	ld A,(HL)
	out (C),A
	inc hl
	inc c
	dec e
	jr nz, HwInit_GACLoop
  
	;; Other HW init
	im 1
	ld BC, #DF00    ;; Select UROM 0
	out (C), C
	ld BC, #F8FF    ;; Exp reset
	out (C), C
	ld BC, #7FC0    ;; RAM C0
	out (C), C
	ld BC, #FA7E    ;; RAM Disk motor OFF
	xor A
	out (C), A

	jp LowerRAMTest
        

	INCLUDE "LowerRAMTest.asm"

