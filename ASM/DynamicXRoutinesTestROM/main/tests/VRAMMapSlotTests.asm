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
VRAMMapSlotTests1:
    dl .Pasado
    dl .Assert1
    dl .Assert2
.Pasado db "Test TestIsRestricted: Pasado",$00
.Assert1 db "TestIsRestricted Assert 1",$00
.Assert2 db "TestIsRestricted Assert 2",$00

;TestIsFree
VRAMMapSlotTests_TestIsFree:
    STZ.B TEST_STATUS

    ;VRAMMapSlot slot = new() Offset = 0, SizeOrPose = 0,
    LDX.B #$00
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsFree()
    BEQ +
        LDA.B #$01 : STA.B TEST_STATUS
        RTL
    +
    ;Offset = 0, SizeOrPose = 0x80,
    LDA.B #$00 : STA.L DX_Dynamic_Tile_Offset,X
    LDA.B #$80 : STA.L DX_Dynamic_Tile_Size,X
    %VRAMMapSlot_IsFree()
    BNE +
        LDA.B #$02 : STA.B TEST_STATUS
    +
RTL

VRAMMapSlotTests2:
    dl .Pasado
    dl .Assert1
    dl .Assert2
.Pasado db "Test TestIsFree: Pasado",$00
.Assert1 db "TestIsFree Assert 1",$00
.Assert2 db "TestIsFree Assert 2",$00
;public void TestGetSize()
;{
;    VRAMMapSlot slot = new()
;    {
;        Offset = 0,
;        SizeOrPose = 0,
;    };
;    DynamicPoseDataBase poseDataBase = new();
;    poseDataBase.ReadData(Path.Combine("TestData", "Data.asm"));
;    DynamicPoseHashmap hashmap = new();
;    hashmap.Add(0, new(0, 0, 0));
;    Assert.AreEqual(slot.GetSize(poseDataBase, hashmap), 1);
;    slot = new()
;    {
;        Offset = 0,
;        SizeOrPose = 0x85,
;    };
;    Assert.AreEqual(slot.GetSize(poseDataBase, hashmap), 6);
;}
VRAMMapSlotTests_TestGetSize:
    STZ.B TEST_STATUS
    ;VRAMMapSlot slot = new() Offset = 0, SizeOrPose = 0,
    LDX.B #$00
    LDA.B #$00
    STA.L DX_Dynamic_Tile_Offset,X
    STA.L DX_Dynamic_Tile_Size,X
    ;hashmap.Add(0, new(0, 0, 0));
    STA.l DX_Dynamic_Pose_Offset,x
    %CallFunctionLongShortDBG(DynamicPoseHashmap_Add)
    ;Assert.AreEqual(slot.GetSize(poseDataBase, hashmap), 1);
    %VRAMMapSlot_GetSize()
    CMP #$01
    BEQ +
    LDA.B #$01 : STA.B TEST_STATUS
    BRA .ret
+
;    slot = new()
;    {
;        Offset = 0,
;        SizeOrPose = 0x85,
;    };
    LDA #$85
    STA.L DX_Dynamic_Tile_Size,X
    ;Assert.AreEqual(slot.GetSize(poseDataBase, hashmap), 6);
    %VRAMMapSlot_GetSize()
    CMP #$06
    BEQ .ret
    LDA.B #$02 : STA.B TEST_STATUS
.ret
    LDA.b #$FF
    STA.l DX_Dynamic_Pose_ID,x
    STA.l DX_Dynamic_Pose_ID+1,x
    LDA.b #$00
    STA.l DX_Dynamic_Pose_Length
    STA.l DX_Dynamic_Pose_HashSize
RTL
VRAMMapSlotTests3:
    dl .Pasado
    dl .Assert1
    dl .Assert2
.Pasado db "Test TestGetSize: Pasado",$00
.Assert1 db "TestGetSize Assert 1",$00
.Assert2 db "TestGetSize Assert 2",$00