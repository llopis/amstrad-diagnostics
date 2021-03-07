#!/bin/sh

rm -rf build
mkdir -p build
sjasmplus --nologo --msg=war -DUpperROMBuild=1 --raw=build/AmstradDiagUpper.rom --lst=build/AmstradDiagUpper_list.txt src/Main.asm
sjasmplus --nologo --msg=war -DCartridgeBuild=1 --raw=build/AmstradDiag.cpr --lst=build/AmstradDiagCPR_list.txt src/Main.asm
sjasmplus --nologo --msg=war -DRAMBuild=1 --raw=build/diag.bin --lst=build/AmstradDiagDSK_list.txt src/Main.asm
sjasmplus --nologo --msg=war -DLowerROMBuild=1 --raw=build/AmstradDiagLower.rom --lst=build/AmstradDiagLower_list.txt  src/Main.asm
iDSK -n build/AmstradDiag.dsk > /dev/null 2>&1
iDSK build/AmstradDiag.dsk -e 400 -c 400 -t 1 -i build/diag.bin > /dev/null 2>&1
2cdt -F 2 -X 0x400 -L 0x400 -r diag.bin -n build/diag.bin build/AmstradDiag.cdt > /dev/null 2>&1
cd build; zip -q AmstradDiag.zip *.rom *.cpr *.dsk *.cdt ; cd ..
