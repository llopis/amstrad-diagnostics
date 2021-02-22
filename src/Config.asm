    MACRO PADORG addr
         ; add padding
         IF $ < addr
         BLOCK addr-$
         ENDIF
         ORG addr
    ENDM

	; If DandanatorSupport is defined, it will attempt to remove page 0 and access the low system ROM
	DEFINE DandanatorSupport 1

;	DEFINE LowerRAMFailure #13
;	DEFINE UpperRAMFailure #61
