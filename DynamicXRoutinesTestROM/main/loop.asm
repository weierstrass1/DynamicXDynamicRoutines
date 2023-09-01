I_RESET:
	SEI                                       ; Disable IRQ.
	STZ.W HW_NMITIMEN                         ; Disable IRQ, NMI and joypad reading.
	STZ.W HW_HDMAEN                           ; Disable HDMA.
	STZ.W HW_MDMAEN                           ; Disable DMA.
	STZ.W HW_APUIO0                           ;\ Clear SPC I/O ports.
	STZ.W HW_APUIO1                           ;|
	STZ.W HW_APUIO2                           ;|
	STZ.W HW_APUIO3                           ;/
	LDA.B #!HW_DISP_FBlank                    ;\ Enable F-blank.
	STA.W HW_INIDISP                          ;/
	CLC                                       ;\ Disable emulation mode.
	XCE                                       ;/
	REP #$38                                  ; AXY->16, Disable decimal mode.
		;Initialize direct page and CPU stack.
		LDA.W #DirectPage : TCD
		LDA.W #$1FFF : TCS
		
		STZ.W HW_VTIME

        ;SA1
		LDA.W #SA1_Reset : STA.W SA1_CPURESETVECTOR
		LDA.W #SA1_NMI : STA.W SA1_CPUNMIVECTOR
		LDA.W #SA1_IRQ : STA.W SA1_CPUIRQVECTOR
	SEP #$30

	LDA.B #$80 : STA.W SA1_MMC_BANKS
	LDA.B #$81 : STA.W SA1_MMC_BANKS+1
	LDA.B #$82 : STA.W SA1_MMC_BANKS+2
	LDA.B #$83 : STA.W SA1_MMC_BANKS+3
	
	LDA.B #$80 : STA.W SA1_CPU_BWRAM_WRITE_ON
	STZ.W SA1_CPU_BWRAM_PROT_AREA
	STZ.W SA1_CPU_BWRAM_MAPPING
	LDA.B #$FF : STA.W SA1_CPU_IRAM_WRITE_PROT
	STZ.W SA1_CPUCONTROL
LoopMain:
    ;Pone tus weas aqui
	LDA.B #(FuncionTest)&$FF : STA.B SA1_CALLFUNC_PTR
	LDA.B #(FuncionTest>>8)&$FF : STA.B SA1_CALLFUNC_PTR+1
	LDA.B #(FuncionTest>>16)&$FF : STA.B SA1_CALLFUNC_PTR+2

	;Llamar a la funcion y esperar (leer sa1.asm)
	LDA.B #$01 : STA.B SA1_EXECUTE_FUNC
-	LDA.B SA1_EXECUTE_FUNC : BNE -

	;Hacer la pantalla blanca para indicar que hubo suceso, por ejemplo.
	STZ.W HW_CGADD
	LDA.B #$FF : STA.W HW_CGDATA
	LDA.B #$7F : STA.W HW_CGDATA

	LDA.B #$0F
	STA.W HW_INIDISP
Terminado:
JML Terminado