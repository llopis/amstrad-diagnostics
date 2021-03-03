
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

	ld hl,#0000
	ld (txt_coords),hl
	call SetTitleColors
	ld hl,TxtSystemInfoTitle
	call PrintString

	ld hl,#0002
	ld (txt_coords),hl
	call SetDefaultColors
	ret


TxtSystemInfoTitle: db '         AMSTRAD DIAGNOSTICS - SYSTEM INFO           ',0
TxtCRTC: db 'CRTC TYPE ',0

