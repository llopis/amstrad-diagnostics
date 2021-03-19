
;; The build types are passed in from the build script (but can also be forced here)
;	DEFINE LowerROMBuild 1
;	DEFINE UpperROMBuild 1
;	DEFINE CartridgeBuild 1
;	DEFINE RAMBuild 1


;	DEFINE SkipLowerRAMTest
;	DEFINE LowerRAMFailure %00100011
;	DEFINE UpperRAMFailure #61

	IFDEF LowerROMBuild
		DEFINE BUILD_STR 'L'
		DEFINE PAD_TO_16K
		DEFINE LOWER_RAM_TEST_START #4000
		DEFINE LOWER_RAM_TEST_SIZE  #C000
		DEFINE ROM_CHECK
		DEFINE TRY_UNPAGING_LOW_ROM
		DEFINE PRINT_PROGRAM_SIZE
		DEFINE RESTORE_ROM_CONFIG #7F00 + %10001001
	ENDIF

	IFDEF UpperROMBuild
		DEFINE BUILD_STR 'U'
		DEFINE PAD_TO_16K
		DEFINE LOWER_RAM_TEST_START #0000
		DEFINE LOWER_RAM_TEST_SIZE  #C000
		DEFINE ROM_CHECK
		DEFINE RESTORE_ROM_CONFIG #7F00 + %10000101
	ENDIF

	IFDEF CartridgeBuild
		DEFINE BUILD_STR 'C'
		DEFINE PAD_TO_16K
		DEFINE LOWER_RAM_TEST_START #4000
		DEFINE LOWER_RAM_TEST_SIZE  #C000
		DEFINE RESTORE_ROM_CONFIG #7F00 + %10001001
	ENDIF

	IFDEF RAMBuild
		DEFINE BUILD_STR 'A'
		DEFINE LOWER_RAM_TEST_START #C000
		DEFINE LOWER_RAM_TEST_SIZE  #4000
		DEFINE ROM_CHECK
		DEFINE RESTORE_ROM_CONFIG #7F00 + %10001101
	ENDIF

	DEFINE VERSION_STR '1.0'


