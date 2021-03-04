
SystemInfo:
	call SystemInfoSetUpScreen

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
	call ClearScreen
	ld a,4
	call SetBorderColor 

	ld hl,TxtSystemInfoTitle
	ld d,#A
	call PrintTitleBanner

	ld hl,#0002
	ld (txt_coords),hl
	call SetDefaultColors
	ret


TxtSystemInfoTitle: db '- SYSTEM INFO',0
TxtCRTC: db 'CRTC TYPE ',0

