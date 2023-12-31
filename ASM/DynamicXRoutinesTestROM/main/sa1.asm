;Call a function to the SA-1 by storing the poitner to it in SA1_CALLFUNC_PTR then setting SA1_EXECUTE_FUNC to 01
TEST_CRASH:
	LDA.B #$FF : STA.B TEST_STATUS : STZ.B SA1_EXECUTE_FUNC

	SEI : CLC : XCE
	REP #$38 ;A/X/Y 16-bit, Disable Decimal Mode
		LDA.W #DirectPage : TCD
		LDA.W #$37FF : TCS
	SEP #$30
BRA SA1_READYSTAT

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

SA1_READYSTAT:
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
	JSL CLEAR_DYNAMIC_POSE_SPACE

	INC.B SA1_READY
SA1_LOOP:
    LDA.B SA1_EXECUTE_FUNC : BEQ SA1_LOOP
		PHB : PHK : PLB
		JSL CALL_SA1_FUNCTION
        PLB
		STZ.B SA1_EXECUTE_FUNC
BRA SA1_LOOP

SA1_NMI:
SA1_IRQ:
	RTI

CALL_SA1_FUNCTION:
JML.W [SA1_CALLFUNC_PTR]

CLEAR_DYNAMIC_POSE_SPACE:
	REP #$30
		LDA.W #$FFFF
		!i = 0
		while !i < 256
			STA.L DX_Dynamic_Pose_ID+!i
			!i #= !i+2
		endif
		LDA.W #$0000
		!i = 0
		while !i < 128
    		STA.l DX_Dynamic_Pose_HashSize+!i
			!i #= !i+2
		endif
	SEP #$30
    LDA.b #$00
    STA.l DX_Dynamic_Pose_Length
RTL