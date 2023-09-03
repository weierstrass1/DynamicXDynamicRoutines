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
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
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
;public void TestGetScore()
;{
;    DynamicPoseHashmap hashmap = new();
;    hashmap.Add(0, new(0, 0, 5));
;    VRAMMapSlot slot = new()
;    {
;        Offset = 0,
;        SizeOrPose = 0,
;    };
;    Assert.AreEqual(slot.GetScore(10, hashmap), 5);
;    Assert.AreEqual(slot.GetScore(1000, hashmap), 0xFE);
;    slot = new()
;    {
;        Offset = 0,
;        SizeOrPose = 0x80,
;    };
;    Assert.AreEqual(slot.GetScore(10, hashmap), 0xFF);
;    Assert.AreEqual(slot.GetScore(1000, hashmap), 0xFF);
;}
;In ASM Translation this was merges with get size to do 2 in one
VRAMMapSlotTests_TestGetSizeAndScore:
    STZ.B TEST_STATUS
    ;VRAMMapSlot slot = new() Offset = 0, SizeOrPose = 0,
    LDX.B #$00
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
    LDA.B #$00
    STA.l DX_Timer+1
    STA.L DX_Dynamic_Tile_Offset,X
    STA.L DX_Dynamic_Tile_Size,X
    STA.l DX_Dynamic_Pose_Offset,x
    LDA.b #$05
    STA.l DX_Timer
    ;hashmap.Add(0, new(0, 0, 5));
    %CallFunctionLongShortDBG(DynamicPoseHashmap_Add)
    LDA.b #$0A
    STA.l DX_Timer
    ;Assert.AreEqual(slot.GetScore(10, hashmap), 5);
    %CallFunctionLongShortDBG(VRAMMapSlot_GetSizeAndScore)
    CMP #$05
    BEQ +
    LDA.B #$01 : STA.B TEST_STATUS
    JMP .ret
+
    LDA VRAMMapSlot_Size
    CMP #$01
    BEQ +
    LDA.B #$02 : STA.B TEST_STATUS
    BRA .ret
+
    LDA.b #$E8
    STA.l DX_Timer
    LDA.B #$03
    STA.l DX_Timer+1
    ;Assert.AreEqual(slot.GetScore(1000, hashmap), 5);
    %CallFunctionLongShortDBG(VRAMMapSlot_GetSizeAndScore)  
    CMP #$FE
    BEQ +
    LDA.B #$03 : STA.B TEST_STATUS
    BRA .ret
+
    LDA VRAMMapSlot_Size
    CMP #$01
    BEQ +
    LDA.B #$04 : STA.B TEST_STATUS
    BRA .ret
+
;    slot = new()
;    {
;        Offset = 0,
;        SizeOrPose = 0x85,
;    };
    LDA.b #$0A
    STA.l DX_Timer
    LDA.b #$00
    STA.l DX_Timer+1
    LDA #$85
    STA.L DX_Dynamic_Tile_Size,X
    ;Assert.AreEqual(slot.GetScore(10, hashmap), 0xFF);
    %CallFunctionLongShortDBG(VRAMMapSlot_GetSizeAndScore)
    CMP #$FF
    BEQ +
    LDA.B #$05 : STA.B TEST_STATUS
    BRA .ret
+
    LDA VRAMMapSlot_Size
    CMP #$06
    BEQ +
    LDA.B #$06 : STA.B TEST_STATUS
    BRA .ret
+
    LDA.b #$E8
    STA.l DX_Timer
    LDA.B #$03
    STA.l DX_Timer+1
    ;Assert.AreEqual(slot.GetScore(1000, hashmap), 0xFF);
    %CallFunctionLongShortDBG(VRAMMapSlot_GetSizeAndScore)  
    CMP #$FF
    BEQ +
    LDA.B #$07 : STA.B TEST_STATUS
    BRA .ret
+
    LDA VRAMMapSlot_Size
    CMP #$06
    BEQ +
    LDA.B #$08 : STA.B TEST_STATUS
    BRA .ret
+
.ret
    LDA.b #$FF
    STA.l DX_Dynamic_Pose_ID,x
    STA.l DX_Dynamic_Pose_ID+1,x
    LDA.b #$00
    STA.l DX_Dynamic_Pose_Length
    STA.l DX_Dynamic_Pose_HashSize
RTL
VRAMMapSlotTests4:
    dl .Pasado
    dl .Assert1
    dl .Assert2
    dl .Assert3
    dl .Assert4
    dl .Assert5
    dl .Assert6
    dl .Assert7
    dl .Assert8
.Pasado db "TestGetSizeAndScore: Pasado",$00
.Assert1 db "TestGetSizeAndScore Assert 1",$00
.Assert2 db "TestGetSizeAndScore Assert 2",$00
.Assert3 db "TestGetSizeAndScore Assert 3",$00
.Assert4 db "TestGetSizeAndScore Assert 4",$00
.Assert5 db "TestGetSizeAndScore Assert 5",$00
.Assert6 db "TestGetSizeAndScore Assert 6",$00
.Assert7 db "TestGetSizeAndScore Assert 7",$00
.Assert8 db "TestGetSizeAndScore Assert 8",$00