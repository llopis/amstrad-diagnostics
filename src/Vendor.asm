 MODULE VENDOR

;; Useful info from here:
;; www.cpcwiki.eu/index.php/LK-selectable_Brand_Names
;; LK1,LK2,LK3 are optional links on the CPC mainboard, connected to PPI Port B, Bit1-3. The links select the distributor name (which is displayed by the BIOS in the boot message). 
;; www.cpcwiki.eu/index.php/LK_Links
;; LK4 default 50Hz

@VendorNames:
TxtAmstrad: db "AMSTRAD",0
TxtOrion: db "ORION",0
TxtSchneider: db "SCHNEIDER",0
TxtAwa: db "AWA",0
TxtSolavox: db "SOLAVOX",0
TxtSaisho: db "SAISHO",0
TxtTriumph: db "TRIUMPH",0
TxtIsp: db "ISP",0            

;; Offsets from VendorNames

@VendorTableOffset:
	db 0
	db TxtOrion - TxtAmstrad
	db TxtSchneider - TxtAmstrad
	db TxtAwa - TxtAmstrad
	db TxtSolavox - TxtAmstrad
	db TxtSaisho - TxtAmstrad
	db TxtTriumph - TxtAmstrad
	db TxtIsp - TxtAmstrad

@RefreshNames:
Txt50HZ: db "50Hz",0
Txt60HZ: db "60Hz",0

@RefreshTableOffset:
	db 0
	db Txt60HZ - Txt50HZ

;; OUT:	(Vendor) - vendor from LK3-1 configuration
@DetectVendor:
	ld b,#f5			; PPI port B input
    in a,(c)            ; lower byte bits7-0
    cpl                 ; invert bits
    and %00001110	    ; Links LK3-LK1 define machine
    rrca                ; get rid of bit0
	ld (VendorName),a
	ret

;;  OUT: (Frequency) - frequency from LK4 configuration
@DetectFrequency:
	ld b,#f5			; PPI port B input
 	in a,(c)            ; 
	and %00010000       ; LK4 50/60 Hz  &10/&00 
	ld (RefreshFrequency),a
	ret
    
 ENDMODULE
