5 MEMORY &3FFF
10 LOAD"romdump.bin",&8000
20 PRINT "ROM DUMPER"
30 INPUT "Which ROM (LOW or number)? ",rom$
40 IF LOWER$(rom$)<>"low" THEN GOTO 110
45 REM ** LOW ROM
50 PRINT "Dumping LOW ROM..."
60 CALL &8000
70 GOTO 200
105 REM ** HIGH ROMS
110 romnum = VAL(rom$)
120 PRINT "Dumping upper ROM ";romnum
130 POKE &8004,romnum
140 CALL &8002
200 crcl = PEEK(&8005) 
210 crch = PEEK(&8006) 
220 crc = crch * 256 + crcl
230 PRINT "CRC &";HEX$(crc,4) 
240 SAVE rom$,b,&4000,&4000  


