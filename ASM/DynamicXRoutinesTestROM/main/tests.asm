;Macro para dibujar texto en rom para la pantalla
macro DibujarTextoPantalla(Texto)
	LDA.B #!HW_DISP_FBlank                    ;\ Enable F-blank.
	STA.W HW_INIDISP                          ;/
	REP #$30
		LDX.W #$0000
		LDA.B TEXT_IND : CLC : ADC.W #32 : STA.B TEXT_IND
		STA.W HW_VMADD
	SEP #$20
?-		LDA.L <Texto>,X : BEQ ?+
			STA.W HW_VMDATA
			STZ.W HW_VMDATA+1
			INX
			BRA ?-
		?+
	SEP #$10
	LDA.B #$0F
	STA.W HW_INIDISP
endmacro

macro HacerTest(Funcion, TextoPasado, TextoFallido)
	STZ.B TEST_PASADO

    ;Pone tus weas aqui
	LDA.B #(<Funcion>)&$FF : STA.B SA1_CALLFUNC_PTR
	LDA.B #(<Funcion>>>8)&$FF : STA.B SA1_CALLFUNC_PTR+1
	LDA.B #(<Funcion>>>16)&$FF : STA.B SA1_CALLFUNC_PTR+2

	;Llamar a la funcion y esperar (leer sa1.asm)
	LDA.B #$01 : STA.B SA1_EXECUTE_FUNC
-	LDA.B SA1_EXECUTE_FUNC : BNE -

	LDA.B TEST_PASADO : BEQ +
		%DibujarTextoPantalla(<TextoPasado>)
		BRA ++
	+
		%DibujarTextoPantalla(<TextoFallido>)
	++
endmacro

LoopMain:
    ;Pone tus weas aqui
	%HacerTest(DynamicPoseHashmapSlotTests_TestGetHashCode, SlotTestsRet0, SlotTestsRet1)
Terminado:
JML Terminado