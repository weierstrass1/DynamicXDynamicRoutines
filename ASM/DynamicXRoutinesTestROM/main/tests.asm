macro HacerTest(Funcion, Textos)
	STZ.B TEST_STATUS

	;Background color
	LDA.B #!HW_DISP_FBlank                    ;\ Enable F-blank.
	STA.W HW_INIDISP                          ;/

	STZ.W HW_CGADD
	LDA.B #$08 : STA.W HW_CGDATA
	LDA.B #$01 : STA.W HW_CGDATA

	LDA.B #$0F
	STA.W HW_INIDISP

    ;Pone tus weas aqui
	LDA.B #(<Funcion>)&$FF : STA.B SA1_CALLFUNC_PTR
	LDA.B #(<Funcion>>>8)&$FF : STA.B SA1_CALLFUNC_PTR+1
	LDA.B #(<Funcion>>>16)&$FF : STA.B SA1_CALLFUNC_PTR+2

	;Llamar a la funcion y esperar (leer sa1.asm)
	LDA.B #$01 : STA.B SA1_EXECUTE_FUNC
-	LDA.B SA1_EXECUTE_FUNC : BNE -

	;Dibujar texto en pantalla
	LDA.B TEST_STATUS : ASL : CLC : ADC.B TEST_STATUS : TAX

	;ptr
	LDA.L <Textos>,X : STA.B TEXT_PTR
	LDA.L <Textos>+1,X : STA.B TEXT_PTR+1
	LDA.L <Textos>+2,X : STA.B TEXT_PTR+2

	LDA.B #!HW_DISP_FBlank                    ;\ Enable F-blank.
	STA.W HW_INIDISP                          ;/

	STZ.W HW_CGADD
	LDA.B #$00 : STA.W HW_CGDATA
	LDA.B #$20 : STA.W HW_CGDATA
	REP #$30
		LDY.W #$0000
		LDA.B TEXT_IND : CLC : ADC.W #32 : STA.B TEXT_IND
		STA.W HW_VMADD
	SEP #$20
?-		LDA.B [TEXT_PTR],Y : BEQ ?+
			STA.W HW_VMDATA
			STZ.W HW_VMDATA+1
			INY
			BRA ?-
		?+
	SEP #$10
	LDA.B #$0F
	STA.W HW_INIDISP
endmacro

LoopMain:
    ;Pone tus weas aqui
	%HacerTest(DynamicPoseHashmapSlotTests_TestGetHashCode, SlotTestsStrings)
	%HacerTest(VRAMMapSlotTests_TestIsRestricted, VRAMMapSlotTests1)
	%HacerTest(VRAMMapSlotTests_TestIsFree, VRAMMapSlotTests2)
	%HacerTest(VRAMMapSlotTests_TestGetSize,VRAMMapSlotTests3)
Terminado:
JML Terminado