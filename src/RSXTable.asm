	; ROM header
	db #00, #00, #01, #00

RSXTable:
	dw RSXNames
	jp LowerRAMTest


RSXNames:
	db "DIA", 'G' | 0x80
	db 0                     ;end of name table marker


