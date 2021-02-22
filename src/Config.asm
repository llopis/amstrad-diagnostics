    MACRO PADORG addr
         ; add padding
         IF $ < addr
         BLOCK addr-$
         ENDIF
         ORG addr
    ENDM

;	DEFINE LowerRAMFailure #13
;	DEFINE UpperRAMFailure #61