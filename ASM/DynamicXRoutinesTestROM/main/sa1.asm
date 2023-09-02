;Call a function to the SA-1 by storing the poitner to it in SA1_CALLFUNC_PTR then setting SA1_EXECUTE_FUNC to 01
SA1_Reset:
	SEI : CLC : XCE
	REP #$38 ;A/X/Y 16-bit, Disable Decimal Mode
		LDA.W #DirectPage : TCD
		LDA.W #$37FF : TCS

        ;Clear I-RAM
        LDX.W #$07FE
-       STZ.W DirectPage,X
        DEX #2 : BPL -
	SEP #$30 ;A/X/Y 8-bit
	LDA.B #$01 : STA.B TEXT_IND

	LDA.B #$80 : STA.W SA1_CPU_BWRAM_WRITE_ON+1
	STZ.W SA1_CPU_BWRAM_MAPPING+1
	LDA.B #$FF : STA.W SA1_CPU_IRAM_WRITE_PROT+1

	;Clear BWRAM
	REP #$30
		LDX.W #$0000
		LDA.W #$0000
-		STA.L $400000,X
		STA.L $410000,X
		INX #2 : BNE -

		LDA.W #$FFFF
		!i = 0
		while !i < 256
			STA.L DX_Dynamic_Pose_ID+!i
			!i #= !i+2
		endif
	SEP #$30

	INC.B SA1_READY
SA1_LOOP:
    LDA.B SA1_EXECUTE_FUNC : BEQ SA1_LOOP
		JSL CALL_SA1_FUNCTION
        STZ.B SA1_EXECUTE_FUNC
BRA SA1_LOOP

SA1_NMI:
SA1_IRQ:
	RTI

CALL_SA1_FUNCTION:
JML.W [SA1_CALLFUNC_PTR]