#!/bin/sh

mkdir -p build
sjasmplus --nologo --msg=war -DDandanatorSupport=1 --raw=ROMs/AmstradDiagDandanator.rom --lst=build/AmstradDiagDandanator_list.txt src/Main.asm
sjasmplus --nologo --msg=war --raw=ROMs/AmstradDiag.rom --lst=build/AmstradDiag_list.txt  src/Main.asm
sjasmplus --nologo --msg=war -DUpperROM=1 --raw=ROMs/AmstradDiagUpper.rom --lst=build/AmstradDiagUpper_list.txt src/Main.asm
