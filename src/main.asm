org &8000

Start:
	call make_scr_table
	call ClearScreen

	call SetTitleColors
	ld hl,TxtTitle
	call PrintString

	call SetDefaultColors

	call NewLine
	call NewLine
	call DetectROMs
	call CheckUpperRAM
	call DetectCRTC
		
    ret
Wait:
	jr Wait


TxtTitle: db '              AMSTRAD DIAGNOSTICS V0.0               ',0


read "DetectROMs.asm"
read "CheckUpperRAM.asm"
read "UtilsPrint.asm"
read "UtilsText.asm"
read "Screen.asm"
read "DetectCRTC.asm"

