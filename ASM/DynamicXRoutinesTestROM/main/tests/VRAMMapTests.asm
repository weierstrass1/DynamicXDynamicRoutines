
            VRAMMap vramMap = startVRAMMap(false);
            var vramSlot0 = vramMap.Get(0);
            var vramSlot3F = vramMap.Get(0x3F);
            var vramSlot40 = vramMap.Get(0x40);
            var vramSlot5F = vramMap.Get(0x5F);
            var vramSlot60 = vramMap.Get(0x60);
            var vramSlotL_1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
            vramSlot0.Offset = 0x80;
            vramSlot0.SizeOrPose = 0x3F | 0x80;
            vramSlot3F.Offset = 0x80;
            vramSlot3F.SizeOrPose = 0x1F | 0x80;
            vramSlot40.Offset = 0x40;
            vramSlot40.SizeOrPose = 0x1F | 0x80;
            vramSlot5F.Offset = 0x40;
            vramSlot5F.SizeOrPose = 0x1F | 0x80;
            vramSlot60.Offset = 0x60;
            vramSlot60.SizeOrPose = (VRAMMap.VRAMMAP_SIZE - 0x60 - 1) | 0x80;
            vramSlotL_1.Offset = 0x60;
            vramSlotL_1.SizeOrPose = (VRAMMap.VRAMMAP_SIZE - 0x60 - 1) | 0x80;

            vramMap.Hashmap.Add(0, new(0, 0x40, 10));
            vramMap.Hashmap.Add(1, new(0, 0x60, 20));

            vramMap.AddPoseInSpace(0, new()
            {
                Offset = 0x40,
                Size = 0x20,
            });
            vramMap.AddPoseInSpace(1, new()
            {
                Offset = 0x60,
                Size = 0x20,
            });

            Space best = vramMap.GetBestSlot(0x20, 30);
            Assert.AreEqual(best.Offset, 0x40);
            Assert.AreEqual(best.Size, 0x20);
            Assert.AreEqual(best.Score, 20);

VRAMMapTests_TestGetBestSlot:
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

    ;se añaden 2
    LDX.B #$00
    LDA.B #$00
    STA.L DX_Dynamic_Tile_Offset,X
    STA.L DX_Dynamic_Tile_Size,X
    ;vramMap.Hashmap.Add(0, new(0, 0x40, 10));
    STA.l DX_Dynamic_Pose_Offset,x
    %CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

    LDX.B #$01
    LDA.B #$00
    STA.L DX_Dynamic_Tile_Offset,X
    STA.L DX_Dynamic_Tile_Size,X
    ;vramMap.Hashmap.Add(1, new(0, 0x60, 20));
    STA.l DX_Dynamic_Pose_Offset,x
    %CallFunctionLongShortDBG(DynamicPoseHashmap_Add)
RTL

