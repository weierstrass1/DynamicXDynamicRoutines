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

	;SA-1 init
	LDA.B #$80 : STA.W SA1_MMC_BANKS
	LDA.B #$81 : STA.W SA1_MMC_BANKS+1
	LDA.B #$82 : STA.W SA1_MMC_BANKS+2
	LDA.B #$83 : STA.W SA1_MMC_BANKS+3
	
	LDA.B #$80 : STA.W SA1_CPU_BWRAM_WRITE_ON
	STZ.W SA1_CPU_BWRAM_PROT_AREA
	STZ.W SA1_CPU_BWRAM_MAPPING
	LDA.B #$FF : STA.W SA1_CPU_IRAM_WRITE_PROT
	STZ.W SA1_CPUCONTROL

	;Ready
-	LDA.B SA1_READY : BEQ -

	;Screen init
	LDA.B #!HW_BG_Mode0 : STA.W HW_BGMODE

	;White screen
	STZ.W HW_CGADD
	LDA.B #$FF : STA.W HW_CGDATA
	LDA.B #$7F : STA.W HW_CGDATA
	LDA.B #$00 : STA.W HW_CGDATA
	LDA.B #$00 : STA.W HW_CGDATA
	LDA.B #$FF : STA.W HW_CGDATA
	LDA.B #$7F : STA.W HW_CGDATA
	LDA.B #$FF : STA.W HW_CGDATA
	LDA.B #$7F : STA.W HW_CGDATA
	
	;Disable all layers but l1
	LDA.B #!HW_Through_BG1 : STA.W HW_TM
	STZ.W HW_TMW
	STZ.W HW_TS
	STZ.W HW_TSW

	;Set l1 to 256x256
	STZ.W HW_BG1SC

	;Set L1 to use $7000 in VRAM
	LDA.B #$33 : STA.W HW_BG12NBA : STA.W HW_BG34NBA

	;(Debug, see nmi time)
	LDA.B #!HW_VINC_IncOnHi
	STA.W HW_VMAINC
	REP #$10
		LDX.W #$3000 : STX.W HW_VMADD
		LDX.W #$1801 : STX.W HW_DMAPARAM
		LDX.W #$1000 : STX.W HW_DMACNT
		LDX.W #GRAFICOS_TEXTO : STX.W HW_DMAADDR
		LDA.B #GRAFICOS_TEXTO>>16 : STA.W HW_DMAADDR+2
	SEP #$10
	LDA.B #!Ch0 : STA.W HW_MDMAEN
JML LoopMain