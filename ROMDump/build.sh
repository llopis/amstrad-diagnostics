#!/bin/sh
mkdir -p build
sjasmplus --nologo --msg=war --raw=build/ROMDump.bin --inc=src --lst=build/ROMDump_list.txt src/ROMDump.asm
iDSK -n DSK/ROMDump.dsk
iDSK DSK/ROMDump.dsk -t 0 -i src/ROMDump.bas
iDSK DSK/ROMDump.dsk -t 1 -i build/ROMDump.bin

