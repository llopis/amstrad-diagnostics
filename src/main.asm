org &8000


Start:
	call DetectROMs
	call CheckUpperRAM
		
    ret
Wait:
	jr Wait


read "UtilsPrint.asm"
read "DetectROMs.asm"
read "CheckUpperRAM.asm"

