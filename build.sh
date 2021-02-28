#!/bin/sh

sjasmplus --nologo --msg=war -DDandanatorSupport=1 --raw=ROMs/AmstradDiagDandanator.rom --lst=AmstradDiag_list.txt src/HardwareInit.asm
sjasmplus --nologo --msg=war --raw=ROMs/AmstradDiag.rom  src/HardwareInit.asm
