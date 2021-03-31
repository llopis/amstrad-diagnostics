 MODULE SYSTEMINFO

@DetectSystemInfo:
	;; Try to detect the model and language
	call	CalculateTotalUpperRAM
	call	DetectModel

	;; From the model, determine the keyboard layout
	ld	a, (ModelType)
	cp	MODEL_CPC6128
	jr	c, .set464Layout
	ld	a, KEYBOARD_LAYOUT_6128
	jr	.setLayout
.set464Layout:
	ld	a, KEYBOARD_LAYOUT_464
.setLayout:
	ld	(KeyboardLayout), a

	ld	a, (MenuItemCount)
	ld	(SelectedMenuItem), a

	call	IsAmstradFDCPresent
	jr	c, .noFDC

	ld	a, 1
	ld	(FDCPresent), a

.noFDC:

	ret



 ENDMODULE
