VRAMMapSlotTests:
    LDA.B #$01 : STA.B TEST_PASADO

;TestIsRestricted
TestIsRestricted:
    ;VRAMMapSlot slot = new() Offset = 0, SizeOrPose = 0,
    LDX.B #$00
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsRestricted()
    BEQ +
        STZ.B TEST_PASADO
        RTL
    +
    ;Offset = 0x80, SizeOrPose = 0,
    LDA.B #$80 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsRestricted()
    BNE +
        STZ.B TEST_PASADO
        RTL
    +

;TestIsFree
TestIsFree:
    ;VRAMMapSlot slot = new() Offset = 0, SizeOrPose = 0,
    LDX.B #$00
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsFree()
    BEQ +
        STZ.B TEST_PASADO
        RTL
    +
    ;Offset = 0, SizeOrPose = 0x80,
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$80 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsFree()
    BNE +
        STZ.B TEST_PASADO
        RTL
    +
RTL

VRAMMapSlotTestsRetP: db "Test VRAMSlots: Pasado",$00
VRAMMapSlotTestsF: db "Test VRAMSlots: Fallado",$00