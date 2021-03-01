
	; If DandanatorSupport is defined, it will attempt to remove page 0 and access the low system ROM
;	DEFINE LowerROMBuild 1
;	DEFINE DandanatorSupport 1
;	DEFINE UpperROMBuild 1
;	DEFINE RAMBuild 1

;	DEFINE LowerRAMFailure #13
;	DEFINE UpperRAMFailure #61

	IFNDEF LowerROMBuild
		DEFINE LOWER_ROM_CHECK_ENABLED
	ELSE
		IFDEF DandanatorSupport
			DEFINE LOWER_ROM_CHECK_ENABLED
		ENDIF
	ENDIF