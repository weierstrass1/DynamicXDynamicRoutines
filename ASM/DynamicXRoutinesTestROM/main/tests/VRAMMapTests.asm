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

;TestAddPoseInSpace
VRAMMapTests_TestAddPoseInSpace:
	STZ.B TEST_STATUS

	;vramMap.AddPoseInSpace(0, new()
	LDA.B #$00 : STA.B HashIndexBackup
	LDA.B #$00 : STA.B VRAMMapBestSpace_Offset
	LDA.B #!VRAMMAP_SIZE : STA.B VRAMMapBestSpace_Size
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)

	;get(vrammapsize-1)
	LDX.B #!VRAMMAP_SIZE-1
	LDA.B DX_Dynamic_Tile_Offset,X : CMP.B #$01 : BEQ +
		LDA.B #$01 : STA.B TEST_STATUS : RTL
	+
	LDA.B DX_Dynamic_Tile_Size,X : CMP.B #(!VRAMMAP_SIZE-2)|$80 : BEQ +
		LDA.B #$02 : STA.B TEST_STATUS : RTL
	+

	;get(1)
	LDX.B #$01
	LDA.B DX_Dynamic_Tile_Offset,X : CMP.B #$01 : BEQ +
		LDA.B #$03 : STA.B TEST_STATUS : RTL
	+
	LDA.B DX_Dynamic_Tile_Size,X : CMP.B #(!VRAMMAP_SIZE-2)|$80 : BEQ +
		LDA.B #$04 : STA.B TEST_STATUS : RTL
	+

	;get(0)
	LDX.B #$00
	LDA.B DX_Dynamic_Tile_Offset,X : CMP.B #$00 : BEQ +
		LDA.B #$05 : STA.B TEST_STATUS : RTL
	+
	LDA.B DX_Dynamic_Tile_Size,X : BEQ +
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