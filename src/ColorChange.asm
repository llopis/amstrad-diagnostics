; Changes contents of L depending on whether the LSB of D was good or bad
	nop
	nop
	nop
	rrc d                   ; [2]
	jr c, $+6               ; [2][3]
	ld l, ColorGood         ; [2]    green (21)
	jr $+6                  ; [3]
	ld l, ColorBad          ;    [2] red (6s)
	nop                     ;    [1]
	nop                     ;    [1]
	out (c), c              ; [4]
