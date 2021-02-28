#!/bin/sh

mkdir -p build
sjasmplus --nologo --msg=war -DDandanatorSupport=1 --raw=build/AmstradDiagDandanator.rom --lst=build/AmstradDiagDandanator_list.txt src/Main.asm
sjasmplus --nologo --msg=war --raw=build/AmstradDiag.rom --lst=build/AmstradDiag_list.txt  src/Main.asm
sjasmplus --nologo --msg=war -DUpperROM=1 --raw=build/AmstradDiagUpper.rom --lst=build/AmstradDiagUpper_list.txt src/Main.asm
cd build; zip AmstradDiag.zip *.rom