;TestIsRestricted
VRAMMapSlotTests_TestIsRestricted:
    STZ.B TEST_STATUS

    ;VRAMMapSlot slot = new() Offset = 0, SizeOrPose = 0,
    LDX.B #$00
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsRestricted()
    BEQ +
        LDA.B #$01 : STA.B TEST_STATUS
        RTL
    +
    ;Offset = 0x80, SizeOrPose = 0,
    LDA.B #$80 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsRestricted()
    BNE +
        LDA.B #$02 : STA.B TEST_STATUS
    +
RTL

;TestIsFree
VRAMMapSlotTests_TestIsFree:
    LDA.B #$03 : STA.B TEST_STATUS

    ;VRAMMapSlot slot = new() Offset = 0, SizeOrPose = 0,
    LDX.B #$00
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsFree()
    BEQ +
        LDA.B #$04 : STA.B TEST_STATUS
        RTL
    +
    ;Offset = 0, SizeOrPose = 0x80,
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$80 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsFree()
    BNE +
        LDA.B #$05 : STA.B TEST_STATUS
    +
RTL

VRAMMapSlotTestStrings:
    dl VRAMMapSlotTestsRetP1
    dl VRAMMapSlotTestsAssert1
    dl VRAMMapSlotTestsAssert2
    dl VRAMMapSlotTestsRetP2
    dl VRAMMapSlotTestsAssert3
    dl VRAMMapSlotTestsAssert4

VRAMMapSlotTestsRetP1: db "Test TestIsRestricted: Pasado",$00
VRAMMapSlotTestsAssert1: db "TestIsRestricted Assert 1",$00
VRAMMapSlotTestsAssert2: db "TestIsRestricted Assert 2",$00

VRAMMapSlotTestsRetP2: db "Test TestIsFree: Pasado",$00
VRAMMapSlotTestsAssert3: db "TestIsFree Assert 3",$00
VRAMMapSlotTestsAssert4: db "TestIsFree Assert 4",$00