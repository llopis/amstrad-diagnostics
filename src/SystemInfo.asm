
 MODULE SYSTEMINFO

@SystemInfo:
	call 	SystemInfoSetUpScreen

	;; Model
	ld	hl, TxtModel
	call	PrintString
	ld	a, (ModelType)
	ld	e, a
	ld	d, 0
	ld	hl, ModelNameTableOffset
	add	hl, de
	ld	a, (hl)
	ld	e, a
	ld	hl, ModelNames
	add	hl, de

	call	PrintString
	call 	NewLine

	;; CRTC yype
	ld hl,TxtCRTC
	call PrintString
	call GetCRTCType
	call PrintAHex
	call NewLine

	call NewLine
	ld hl,TxtAnyKeyMainMenu
	call PrintString

	ret
	

SystemInfoSetUpScreen:
	ld d, 0
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtSystemInfoTitle
	ld d,(ScreenCharsWidth - TxtTitleLen - TxtSystemInfoTitleLen)/2
	call PrintTitleBanner

	ld hl,#0002
	ld (TxtCoords),hl
	call SetDefaultColors
	ret


TxtSystemInfoTitle: db ' - SYSTEM INFO',0
TxtSystemInfoTitleLen EQU $-TxtSystemInfoTitle-1
TxtModel: db 'MODEL: ',0
TxtCRTC: db 'CRTC TYPE ',0


 ENDMODULE