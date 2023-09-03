VRAMMapTests_TestGetBestSlot:
	STZ.B TEST_STATUS

	;la misma wea
	LDX.B #$00
	LDA.B #$80 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #$3F|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDX.B #$3F
	LDA.B #$80 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #$1F|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDX.B #$40
	LDA.B #$40 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #$1F|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDX.B #$5F
	LDA.B #$40 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #$1F|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDX.B #$60
	LDA.B #$60 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #(!VRAMMAP_SIZE-$60-1)|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDX.B #!VRAMMAP_SIZE-1
	LDA.B #$60 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #(!VRAMMAP_SIZE-$60-1)|$80 : STA.L DX_Dynamic_Tile_Size,X

.p1
	;vramMap.Hashmap.Add(0, new(0, 0x40, 10));
	LDX.b #$00
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
	LDA.B #$40 : STA.l DX_Dynamic_Pose_Offset,x
	LDA.B #10 : STA.L DX_Timer
	LDA.B #0 : STA.L DX_Timer+1
	TXA : ASL : TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

	;Getsize
	LDY #$00 : LDA.w Pose16x16Blocks,y : STA.b VRAMMapTMP_Size

	;vramMap.AddPoseInSpace(0, new()
	LDA.B #$00 : STA.B HashIndexBackup
	LDA.B #$40 : STA.B VRAMMapBestSpace_Offset
	LDA.B #$20 : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)

.p2
	;vramMap.Hashmap.Add(1, new(0, 0x60, 20));
	LDX.b #$01
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
	LDA.B #$60 : STA.l DX_Dynamic_Pose_Offset,x
	LDA.B #20 : STA.L DX_Timer
	LDA.B #0 : STA.L DX_Timer+1
	TXA : ASL : TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

	;Getsize
	LDY #$00 : LDA.w Pose16x16Blocks,y : STA.b VRAMMapTMP_Size

	;vramMap.AddPoseInSpace(0, new()
	LDA.B #$01 : STA.B HashIndexBackup
	LDA.B #$60 : STA.B VRAMMapBestSpace_Offset
	LDA.B #$20 : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)

	;vramMap.GetBestSlot(0x20, 30);
	LDA.B #$20
	STA.b VRAMMapTMP_Size
	LDA.b #30
	STA.l DX_Timer
	LDA.b #$00
	STA.l DX_Timer+1
	%CallFunctionLongShortDBG(VRAMMap_GetBestSlot)

	LDA.B VRAMMapBestSpace_Offset : CMP.B #$40 : BEQ +
		LDA.B #$01 : STA.B TEST_STATUS : RTL
	+
	LDA.B VRAMMapBestSpace_Size : CMP.B #$20 : BEQ +
		LDA.B #$02 : STA.B TEST_STATUS : RTL
	+
	LDA.B VRAMMapBestSpace_Score : CMP.B #20 : BEQ +
		LDA.B #$03 : STA.B TEST_STATUS : RTL
	+
RTL

.returnStr
	dl .suceso
	dl .assert1
	dl .assert2
	dl .assert3

.suceso: db "TestGetBestSlot: Pasado",$00
.assert1: db "TestGetBestSlot: Assert 1",$00
.assert2: db "TestGetBestSlot: Assert 2",$00
.assert3: db "TestGetBestSlot: Assert 3",$00

;public void TestRemovePosesInSpace()
;{
;	VRAMMap vramMap = startVRAMMap();
;	vramMap.Hashmap.Add(1, new(0, 1, 0));
;	vramMap.Hashmap.Add(2, new(0, 2, 0));
;	vramMap.AddPoseInSpace(0, new()
;	{
;Offset = 0,
;Score = 0,
;Size = VRAMMap.VRAMMAP_SIZE
;	});
;	vramMap.AddPoseInSpace(1, new()
;	{
;Offset = 1,
;Score = 0,
;Size = VRAMMap.VRAMMAP_SIZE - 1
;	});
;	vramMap.AddPoseInSpace(2, new()
;	{
;Offset = 2,
;Score = 0,
;Size = VRAMMap.VRAMMAP_SIZE - 2
;	});
;	VRAMMapSlot slot0 = vramMap.Get(0);
;	Assert.AreEqual(slot0.Offset, 0);
;	Assert.AreEqual(slot0.SizeOrPose, 0);
;	VRAMMapSlot slot1 = vramMap.Get(1);
;	Assert.AreEqual(slot1.Offset, 1);
;	Assert.AreEqual(slot1.SizeOrPose, 1);
;	VRAMMapSlot slot2 = vramMap.Get(2);
;	Assert.AreEqual(slot2.Offset, 2);
;	Assert.AreEqual(slot2.SizeOrPose, 2);
;	VRAMMapSlot endSlot1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
;	Assert.AreEqual(endSlot1.Offset, 3);
;	Assert.AreEqual(endSlot1.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 4) | 0x80);
;	VRAMMapSlot endSlot2 = vramMap.Get(3);
;	Assert.AreEqual(endSlot2.Offset, 3);
;	Assert.AreEqual(endSlot2.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 4) | 0x80);

;	Assert.IsNotNull(vramMap.Hashmap.Get(0));
;	Assert.IsNotNull(vramMap.Hashmap.Get(1));
;	Assert.IsNotNull(vramMap.Hashmap.Get(2));
;	Assert.AreEqual(vramMap.Hashmap.Length, 3);
;	Assert.AreEqual(vramMap.Hashmap.GetHashSize(0), 3);
;	vramMap.RemovePosesInSpace(new()
;	{
;Offset = 1,
;Score = 0,
;Size = VRAMMap.VRAMMAP_SIZE - 1
;	});
;	Assert.IsNotNull(vramMap.Hashmap.Get(0));
;	Assert.ThrowsException<Exception>(() => vramMap.Hashmap.Get(1));
;	Assert.ThrowsException<Exception>(() => vramMap.Hashmap.Get(2));
;	Assert.AreEqual(vramMap.Hashmap.Length, 1);
;	Assert.AreEqual(vramMap.Hashmap.GetHashSize(0), 1);
;}
VRAMMapTests_TestRemovePosesInSpace:
	STZ.B TEST_STATUS

	LDY #$00 : LDA.w Pose16x16Blocks,y : STA.b VRAMMapTMP_Size
	;vramMap.Hashmap.Add(1, new(0, 0, 0));
	LDX.b #$00
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
	LDA.B #$00 : STA.l DX_Dynamic_Pose_Offset,x
	LDA.B #$00 : STA.L DX_Timer : STA.L DX_Timer+1
	TXA : ASL : TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)
	;vramMap.Hashmap.Add(1, new(0, 1, 0));
	LDX.b #$01
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
	LDA.B #$01 : STA.l DX_Dynamic_Pose_Offset,x
	LDA.B #$00 : STA.L DX_Timer : STA.L DX_Timer+1
	TXA : ASL : TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

	;vramMap.Hashmap.Add(2, new(0, 2, 0));
	LDX.b #$02
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
	LDA.B #$02 : STA.l DX_Dynamic_Pose_Offset,x
	LDA.B #$00 : STA.L DX_Timer : STA.L DX_Timer+1
	TXA : ASL : TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

	;que wea
	LDA.B #$00 : STA.B HashIndexBackup
	LDA.B #$00 : STA.B VRAMMapBestSpace_Offset
	LDA.B #!VRAMMAP_SIZE : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)

	LDA.B #$01 : STA.B HashIndexBackup
	LDA.B #$01 : STA.B VRAMMapBestSpace_Offset
	LDA.B #!VRAMMAP_SIZE-1 : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)

	LDA.B #$02 : STA.B HashIndexBackup
	LDA.B #$02 : STA.B VRAMMapBestSpace_Offset
	LDA.B #!VRAMMAP_SIZE-2 : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)

	;get(0)
	LDX.B #$00
	LDA.l DX_Dynamic_Tile_Offset,X : CMP.B #$00 : BEQ +
	LDA.B #$01 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #$00 : BEQ +
	LDA.B #$02 : STA.B TEST_STATUS : RTL
	+
	;get(1)
	LDX.B #$01
	LDA.l DX_Dynamic_Tile_Offset,X : CMP.B #$01 : BEQ +
	LDA.B #$03 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #$01 : BEQ +
	LDA.B #$04 : STA.B TEST_STATUS : RTL
	+
	;get(2)
	LDX.B #$02
	LDA.l DX_Dynamic_Tile_Offset,X : CMP.B #$02 : BEQ +
	LDA.B #$05 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #$02 : BEQ +
	LDA.B #$06 : STA.B TEST_STATUS : RTL
	+
	;get(size-1)
	LDX.B #!VRAMMAP_SIZE-1
	LDA.l DX_Dynamic_Tile_Offset,X : CMP.B #$03 : BEQ +
	LDA.B #$07 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #(!VRAMMAP_SIZE-4)|$80 : BEQ +
	LDA.B #$08 : STA.B TEST_STATUS : RTL
	+
	;get(3)
	LDX.B #$03
	LDA.l DX_Dynamic_Tile_Offset,X : CMP.B #$03 : BEQ +
	LDA.B #$09 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #(!VRAMMAP_SIZE-4)|$80 : BEQ +
	LDA.B #$0A : STA.B TEST_STATUS : RTL
	+
RTL

.returnStr
	dl .pasado

	dl .assert1
	dl .assert2
	dl .assert3
	dl .assert4
	dl .assert5
	dl .assert6
	dl .assert7
	dl .assert8
	dl .assert9
	dl .assert10

	dl .assert11null
	dl .assert12null
	dl .assert13null
	dl .assert14
	dl .assert15

	dl .assert16null
	dl .assert17exception
	dl .assert18exception
	dl .assert19
	dl .assert20

.pasado: db "RemovePosesInSpace: Pasado",$00

.assert1: db "RemovePosesInSpace: Assert 1",$00
.assert2: db "RemovePosesInSpace: Assert 2",$00
.assert3: db "RemovePosesInSpace: Assert 3",$00
.assert4: db "RemovePosesInSpace: Assert 4",$00
.assert5: db "RemovePosesInSpace: Assert 5",$00
.assert6: db "RemovePosesInSpace: Assert 6",$00
.assert7: db "RemovePosesInSpace: Assert 7",$00
.assert8: db "RemovePosesInSpace: Assert 8",$00
.assert9: db "RemovePosesInSpace: Assert 9",$00
.assert10: db "RemovePosesInSpace: Assert 10",$00

.assert11null: db "RemovePosesInSpace: Null 11",$00
.assert12null: db "RemovePosesInSpace: Null 12",$00
.assert13null: db "RemovePosesInSpace: Null 13",$00
.assert14: db "RemovePosesInSpace: Assert 14",$00
.assert15: db "RemovePosesInSpace: Assert 15",$00

.assert16null: db "RemovePosesInSpace: Null 16",$00
.assert17exception: db "RemovePosesInSpace: Excep 17",$00
.assert18exception: db "RemovePosesInSpace: Excep 18",$00
.assert19: db "RemovePosesInSpace: Assert 19",$00
.assert20: db "RemovePosesInSpace: Assert 20",$00

;public void TestRemoveSpace()
;{
;	VRAMMap vramMap = startVRAMMap();
;	vramMap.AddPoseInSpace(0, new()
;	{
;		Offset = 0,
;		Score = 0,
;		Size = VRAMMap.VRAMMAP_SIZE
;	});
;	vramMap.RemoveSpace(new()
;	{
;		Offset = 0,
;		Score = 0,
;		Size = VRAMMap.VRAMMAP_SIZE
;	});
;	VRAMMapSlot endSlot1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
;	Assert.AreEqual(endSlot1.Offset, 0);
;	Assert.AreEqual(endSlot1.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 1) | 0x80);
;	VRAMMapSlot endSlot2 = vramMap.Get(0);
;	Assert.AreEqual(endSlot2.Offset, 0);
;	Assert.AreEqual(endSlot2.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 1) | 0x80);
;}
;TestRemoveSpace
VRAMMapTests_TestRemoveSpace:
	STZ.B TEST_STATUS

	LDX.B #$00
	LDA.B #$80 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #$7F|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDX.B #$7F
	LDA.B #$80 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #$7F|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDY #$00 : LDA.w Pose16x16Blocks,y : STA.b VRAMMapTMP_Size

	LDX.b #$00
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
	LDA.B #$00
	STA.l DX_Dynamic_Pose_Offset,x
	STA.L DX_Timer
	STA.L DX_Timer+1
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

;	vramMap.AddPoseInSpace(0, new()
;	{
;		Offset = 0,
;		Score = 0,
;		Size = VRAMMap.VRAMMAP_SIZE
;	});
	LDA.B #$00 : STA.B HashIndexBackup
	LDA.B #$00 : STA.B VRAMMapBestSpace_Offset
	LDA.B #!VRAMMAP_SIZE : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)

	LDA.B #$00 : STA.B HashIndexBackup
	LDA.B #$00 : STA.B VRAMMapBestSpace_Offset
	LDA.B #!VRAMMAP_SIZE : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_RemoveSpace)

	;get(vrammapsize-1)
	LDX.B #!VRAMMAP_SIZE-1
	LDA.l DX_Dynamic_Tile_Offset,X : BEQ +
		LDA.B #$01 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #(!VRAMMAP_SIZE-1)|$80 : BEQ +
		LDA.B #$02 : STA.B TEST_STATUS : RTL
	+

	;get(0)
	LDX.B #$00
	LDA.l DX_Dynamic_Tile_Offset,X : BEQ +
		LDA.B #$02 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #(!VRAMMAP_SIZE-1)|$80 : BEQ +
		LDA.B #$03 : STA.B TEST_STATUS : RTL
	+
RTL

.returnStr
	dl .suceso
	dl .assert1
	dl .assert2
	dl .assert3
	dl .assert4

.suceso: db "TestRemoveSpace: Pasado",$00
.assert1: db "TestRemoveSpace: Assert 1",$00
.assert2: db "TestRemoveSpace: Assert 2",$00
.assert3: db "TestRemoveSpace: Assert 3",$00
.assert4: db "TestRemoveSpace: Assert 4",$00

;public void TestAddPoseInSpace()
;{
;	VRAMMap vramMap = startVRAMMap();
;	vramMap.AddPoseInSpace(0, new()
;	{
;		Offset = 0,
;		Score = 0,
;		Size = VRAMMap.VRAMMAP_SIZE
;	});
;	VRAMMapSlot endSlot1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
;	Assert.AreEqual(endSlot1.Offset, 1);
;	Assert.AreEqual(endSlot1.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 2) | 0x80);
;	VRAMMapSlot endSlot2 = vramMap.Get(1);
;	Assert.AreEqual(endSlot2.Offset, 1);
;	Assert.AreEqual(endSlot2.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 2) | 0x80);
;	VRAMMapSlot startSlot = vramMap.Get(0);
;	Assert.AreEqual(startSlot.Offset, 0);
;	Assert.AreEqual(startSlot.SizeOrPose, 0);
;}
;TestAddPoseInSpace
VRAMMapTests_TestAddPoseInSpace:
	STZ.B TEST_STATUS

	LDX.B #$00
	LDA.B #$80 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #$7F|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDX.B #$7F
	LDA.B #$80 : STA.L DX_Dynamic_Tile_Offset,X
	LDA.B #$7F|$80 : STA.L DX_Dynamic_Tile_Size,X

	LDY #$00 : LDA.w Pose16x16Blocks,y : STA.b VRAMMapTMP_Size

	;vramMap.AddPoseInSpace(0, new()
	LDA.B #$00 : STA.B HashIndexBackup
	LDA.B #$00 : STA.B VRAMMapBestSpace_Offset
	LDA.B #!VRAMMAP_SIZE : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)

	;get(vrammapsize-1)
	LDX.B #!VRAMMAP_SIZE-1
	LDA.l DX_Dynamic_Tile_Offset,X : CMP.B #$01 : BEQ +
		LDA.B #$01 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #(!VRAMMAP_SIZE-2)|$80 : BEQ +
		LDA.B #$02 : STA.B TEST_STATUS : RTL
	+

	;get(1)
	LDX.B #$01
	LDA.l DX_Dynamic_Tile_Offset,X : CMP.B #$01 : BEQ +
		LDA.B #$03 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : CMP.B #(!VRAMMAP_SIZE-2)|$80 : BEQ +
		LDA.B #$04 : STA.B TEST_STATUS : RTL
	+

	;get(0)
	LDX.B #$00
	LDA.l DX_Dynamic_Tile_Offset,X : CMP.B #$00 : BEQ +
		LDA.B #$05 : STA.B TEST_STATUS : RTL
	+
	LDA.l DX_Dynamic_Tile_Size,X : BEQ +
		LDA.B #$06 : STA.B TEST_STATUS : RTL
	+
RTL

.returnStr
	dl .suceso
	dl .assert1
	dl .assert2
	dl .assert3
	dl .assert4
	dl .assert5
	dl .assert6

.suceso: db "TestAddPoseInSpace: Pasado",$00
.assert1: db "TestAddPoseInSpace: Assert 1",$00
.assert2: db "TestAddPoseInSpace: Assert 2",$00
.assert3: db "TestAddPoseInSpace: Assert 3",$00
.assert4: db "TestAddPoseInSpace: Assert 4",$00
.assert5: db "TestAddPoseInSpace: Assert 5",$00
.assert6: db "TestAddPoseInSpace: Assert 6",$00