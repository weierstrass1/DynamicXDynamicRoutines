;public void TestAdd()
;{
;    DynamicPoseHashmap hashmap = new();
;    Assert.AreEqual(hashmap.Length, 0);
;    Assert.AreEqual(hashmap.GetHashSize(0), 0);
;    DynamicPoseHashMapSlot slot = new(0, 0, 0);
;    hashmap.Add(0, slot);
;    Assert.AreEqual(hashmap.Length, 1);
;    Assert.AreEqual(hashmap.GetHashSize(0), 1);
;    Assert.AreEqual(hashmap.Get(0), slot);
;    Assert.ThrowsException<Exception>(() => hashmap.Add(0, new(1, 2, 0)));
;    Assert.AreEqual(hashmap.Length, 1);
;    Assert.AreEqual(hashmap.GetHashSize(0), 1);
;    Assert.AreEqual(hashmap.Get(0), slot);
;}
DynamicPoseHashmap_TestAdd:
    STZ.B TEST_STATUS

    ;Assert.AreEqual(hashmap.Length, 0);
    LDA DX_Dynamic_Pose_Length
    BEQ +
    LDA.B #$01 : STA.B TEST_STATUS : RTL
+
    ;Assert.AreEqual(hashmap.GetHashSize(0), 0);
    LDA DX_Dynamic_Pose_HashSize
    BEQ +
    LDA.B #$02   : STA.B TEST_STATUS : RTL
+
	;vramMap.Hashmap.Add(0, new(0, 0x40, 10));
	LDX.b #$00
	LDA.B #$00
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
    STA.l DX_Dynamic_Pose_Offset,x
	STA.L DX_Timer
	STA.L DX_Timer+1
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

    ;Assert.AreEqual(hashmap.Length, 1);
    LDA DX_Dynamic_Pose_Length
    CMP #$01
    BEQ +
    LDA.B #$03 : STA.B TEST_STATUS : RTL
+
    ;Assert.AreEqual(hashmap.GetHashSize(0), 1);
    LDA DX_Dynamic_Pose_HashSize
    CMP #$01
    BEQ +
    LDA.B #$04   : STA.B TEST_STATUS : RTL
+
    ;Assert.AreEqual(hashmap.Get(0), slot);
    LDA DX_Dynamic_Pose_ID
    BEQ +
    LDA.B #$05   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_ID+1
    BEQ +
    LDA.B #$06   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_Offset
    BEQ +
    LDA.B #$07   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_TimeLastUse
    BEQ +
    LDA.B #$08   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_TimeLastUse+1
    BEQ +
    LDA.B #$08   : STA.B TEST_STATUS : RTL
+
	LDX.b #$00
    LDA.b #$01
    STA.b PoseIDBackup
    STZ.b PoseIDBackup+1
    LDA.b #$03
	STA.L DX_Timer
	STA.L DX_Timer+1
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)
    LDA.b TEST_STATUS
    CMP.b #$FF
    BEQ +
    LDA.B #$09   : STA.B TEST_STATUS : RTL
+
    STZ.B TEST_STATUS
    ;Assert.AreEqual(hashmap.Length, 1);
    LDA DX_Dynamic_Pose_Length
    CMP #$01
    BEQ +
    LDA.B #$0A : STA.B TEST_STATUS : RTL
+
    ;Assert.AreEqual(hashmap.GetHashSize(0), 1);
    LDA DX_Dynamic_Pose_HashSize
    CMP #$01
    BEQ +
    LDA.B #$0B   : STA.B TEST_STATUS : RTL
+
    ;Assert.AreEqual(hashmap.Get(0), slot);
    LDA DX_Dynamic_Pose_ID
    BEQ +
    LDA.B #$0C   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_ID+1
    BEQ +
    LDA.B #$0D   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_TimeLastUse
    BEQ +
    LDA.B #$0E   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_TimeLastUse+1
    BEQ +
    LDA.B #$0F   : STA.B TEST_STATUS : RTL
+
RTL
DynamicPoseHashmap_Test1:
    dl .Pasado
    dl .Assert1
    dl .Assert2
    dl .Assert3
    dl .Assert4
    dl .Assert5
    dl .Assert6
    dl .Assert7
    dl .Assert8
    dl .Assert9
    dl .AssertA
    dl .AssertB
    dl .AssertC
    dl .AssertD
    dl .AssertE
    dl .AssertF
.Pasado db "TestAdd: Pasado",$00
.Assert1 db "TestAdd Assert 1",$00
.Assert2 db "TestAdd Assert 2",$00
.Assert3 db "TestAdd Assert 3",$00
.Assert4 db "TestAdd Assert 4",$00
.Assert5 db "TestAdd Assert 5",$00
.Assert6 db "TestAdd Assert 6",$00
.Assert7 db "TestAdd Assert 7",$00
.Assert8 db "TestAdd Assert 8",$00
.Assert9 db "TestAdd Assert 9",$00
.AssertA db "TestAdd Assert A",$00
.AssertB db "TestAdd Assert B",$00
.AssertC db "TestAdd Assert C",$00
.AssertD db "TestAdd Assert D",$00
.AssertE db "TestAdd Assert E",$00
.AssertF db "TestAdd Assert F",$00
;public void TestRemove()
;{
;    DynamicPoseHashmap hashmap = new();
;    DynamicPoseHashMapSlot slot = new(0, 0, 0);
;    hashmap.Add(0, slot);
;    Assert.AreEqual(hashmap.Length, 1);
;    Assert.AreEqual(hashmap.GetHashSize(0), 1);
;    Assert.AreEqual(hashmap.Get(0), slot);
;    hashmap.Remove(0);
;    Assert.AreEqual(hashmap.Length, 0);
;    Assert.AreEqual(hashmap.GetHashSize(0), 0);
;    Assert.ThrowsException<Exception>(() => hashmap.Get(0));
;    Assert.ThrowsException<Exception>(() => hashmap.Remove(0));
;}
DynamicPoseHashmap_TestRemove:
    STZ.B TEST_STATUS

;    DynamicPoseHashMapSlot slot = new(0, 0, 0);
;    hashmap.Add(0, slot);
	LDX.b #$00
	LDA.B #$00
    STZ.b PoseIDBackup
    STZ.b PoseIDBackup+1
    STA.l DX_Dynamic_Pose_Offset,x
	STA.L DX_Timer
	STA.L DX_Timer+1
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

    ;Assert.AreEqual(hashmap.Length, 1);
    LDA DX_Dynamic_Pose_Length
    CMP #$01
    BEQ +
    LDA.B #$01 : STA.B TEST_STATUS : RTL
+
    ;Assert.AreEqual(hashmap.GetHashSize(0), 1);
    LDA DX_Dynamic_Pose_HashSize
    CMP #$01
    BEQ +
    LDA.B #$02   : STA.B TEST_STATUS : RTL
+
    ;Assert.AreEqual(hashmap.Get(0), slot);
    LDA DX_Dynamic_Pose_ID
    BEQ +
    LDA.B #$03   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_ID+1
    BEQ +
    LDA.B #$04   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_Offset
    BEQ +
    LDA.B #$05   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_TimeLastUse
    BEQ +
    LDA.B #$06   : STA.B TEST_STATUS : RTL
+
    LDA DX_Dynamic_Pose_TimeLastUse+1
    BEQ +
    LDA.B #$07   : STA.B TEST_STATUS : RTL
+
;    hashmap.Remove(0);
    LDX.b #$00
    %CallFunctionLongShortDBG(DynamicPoseHashmap_Remove)

    ;Assert.AreEqual(hashmap.Length, 0);
    LDA DX_Dynamic_Pose_Length
    BEQ +
    LDA.B #$08 : STA.B TEST_STATUS : RTL
+
    ;Assert.AreEqual(hashmap.GetHashSize(0), 0);
    LDA DX_Dynamic_Pose_HashSize
    BEQ +
    LDA.B #$09   : STA.B TEST_STATUS : RTL
+
;    Assert.ThrowsException<Exception>(() => hashmap.Remove(0));
    LDX.b #$00
    %CallFunctionLongShortDBG(DynamicPoseHashmap_Remove)
    LDA.b TEST_STATUS
    CMP.b #$FF
    BEQ +
    LDA.B #$0A   : STA.B TEST_STATUS : RTL
+
    STZ.b TEST_STATUS
RTL
DynamicPoseHashmap_Test2:
    dl .Pasado
    dl .Assert1
    dl .Assert2
    dl .Assert3
    dl .Assert4
    dl .Assert5
    dl .Assert6
    dl .Assert7
    dl .Assert8
    dl .Assert9
    dl .AssertA
.Pasado db "TestRemove: Pasado",$00
.Assert1 db "TestRemove Assert 1",$00
.Assert2 db "TestRemove Assert 2",$00
.Assert3 db "TestRemove Assert 3",$00
.Assert4 db "TestRemove Assert 4",$00
.Assert5 db "TestRemove Assert 5",$00
.Assert6 db "TestRemove Assert 6",$00
.Assert7 db "TestRemove Assert 7",$00
.Assert8 db "TestRemove Assert 8",$00
.Assert9 db "TestRemove Assert 9",$00
.AssertA db "TestRemove Assert A",$00
;public void TestFindFreeSpace()
;{
;    DynamicPoseHashmap hashmap = new();
;    for (int i = 1; i <= 5; i++)
;    {
;        hashmap.Add((byte)((i * DynamicPoseHashmap.INCREASE_PER_STEP) % DynamicPoseHashmap.HASHMAP_SIZE),
;                    new((ushort)((i * DynamicPoseHashmap.HASHMAP_SIZE) + DynamicPoseHashmap.INCREASE_PER_STEP), 
;                    (byte)(i * 2), 0));
;    }
;    Assert.AreEqual(hashmap.Length, 5);
;    Assert.AreEqual(hashmap.GetHashSize(DynamicPoseHashmap.INCREASE_PER_STEP), 5);
;    byte hashmapIndex = DynamicPoseHashmap.INCREASE_PER_STEP;
;    Assert.IsTrue(hashmap.FindFreeSpace(ref hashmapIndex));
;    Assert.AreEqual(hashmapIndex, DynamicPoseHashmap.INCREASE_PER_STEP * 6);
;
;    hashmap = new();
;    for (int i = 1; i <= DynamicPoseHashmap.HASHMAP_SIZE; i++)
;    {
;        hashmap.Add((byte)((i * DynamicPoseHashmap.INCREASE_PER_STEP) % DynamicPoseHashmap.HASHMAP_SIZE),
;                        new((ushort)((i * DynamicPoseHashmap.HASHMAP_SIZE) + DynamicPoseHashmap.INCREASE_PER_STEP),
;                        (byte)(i * 2), 0));
;    }
;    Assert.AreEqual(hashmap.Length, DynamicPoseHashmap.HASHMAP_SIZE);
;    Assert.AreEqual(hashmap.GetHashSize(DynamicPoseHashmap.INCREASE_PER_STEP), DynamicPoseHashmap.HASHMAP_SIZE);
;    hashmapIndex = DynamicPoseHashmap.INCREASE_PER_STEP;
;    Assert.IsFalse(hashmap.FindFreeSpace(ref hashmapIndex));
;    Assert.AreEqual(hashmapIndex, DynamicPoseHashmap.INCREASE_PER_STEP);
;}

DynamicPoseHashmap_TestFindFreeSpace:
    STZ.B TEST_STATUS

;    for (int i = 1; i <= 5; i++)
;    {
;        hashmap.Add((byte)((i * DynamicPoseHashmap.INCREASE_PER_STEP) % DynamicPoseHashmap.HASHMAP_SIZE),
;                    new((ushort)((i * DynamicPoseHashmap.HASHMAP_SIZE) + DynamicPoseHashmap.INCREASE_PER_STEP), 
;                    (byte)(i * 2), 0));
;    }
    REP #$20
	LDA.w #!HASHMAP_SIZE+!INCREASE_PER_STEP
    STA.b PoseIDBackup
    SEP #$20
    LDX.b #!INCREASE_PER_STEP
    LDA.b #$02
    STA.l DX_Dynamic_Pose_Offset,x
	STA.L DX_Timer
	STA.L DX_Timer+1
    TXA
    ASL
    TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

    REP #$20
	LDA.w #(!HASHMAP_SIZE*2)+!INCREASE_PER_STEP
    STA.b PoseIDBackup
    SEP #$20
    LDX.b #!INCREASE_PER_STEP*2
    LDA.b #$04
    STA.l DX_Dynamic_Pose_Offset,x
    TXA
    ASL
    TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

    REP #$20
	LDA.w #(!HASHMAP_SIZE*3)+!INCREASE_PER_STEP
    STA.b PoseIDBackup
    SEP #$20
    LDX.b #!INCREASE_PER_STEP*3
    LDA.b #$06
    STA.l DX_Dynamic_Pose_Offset,x
    TXA
    ASL
    TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

    REP #$20
	LDA.w #(!HASHMAP_SIZE*4)+!INCREASE_PER_STEP
    STA.b PoseIDBackup
    SEP #$20
    LDX.b #!INCREASE_PER_STEP*4
    LDA.b #$08
    STA.l DX_Dynamic_Pose_Offset,x
    TXA
    ASL
    TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

    REP #$20
	LDA.w #(!HASHMAP_SIZE*5)+!INCREASE_PER_STEP
    STA.b PoseIDBackup
    SEP #$20
    LDX.b #!INCREASE_PER_STEP*5
    LDA.b #$0A
    STA.l DX_Dynamic_Pose_Offset,x
    TXA
    ASL
    TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)

    LDA DX_Dynamic_Pose_Length
    CMP #$05
    BEQ +
    LDA.B #$01 : STA.B TEST_STATUS : RTL
+
;    Assert.AreEqual(hashmap.GetHashSize(DynamicPoseHashmap.INCREASE_PER_STEP), 5);
    LDA DX_Dynamic_Pose_HashSize+!INCREASE_PER_STEP
    CMP #$05
    BEQ +
    LDA.B #$02   : STA.B TEST_STATUS : RTL
+
;    byte hashmapIndex = DynamicPoseHashmap.INCREASE_PER_STEP;
    LDA.b #!INCREASE_PER_STEP
    STA.b HashIndexBackup
;    Assert.IsTrue(hashmap.FindFreeSpace(ref hashmapIndex));
    %CallFunctionLongShortDBG(DynamicPoseHashmap_FindFreeSpace)
    BCS +
    LDA.B #$03   : STA.B TEST_STATUS : RTL
+
;    Assert.AreEqual(hashmapIndex, DynamicPoseHashmap.INCREASE_PER_STEP * 6);
    LDA.b HashIndexBackup
    CMP.b #!INCREASE_PER_STEP*6
    BEQ +
    LDA.B #$04   : STA.B TEST_STATUS : RTL
+
    JSL CLEAR_DYNAMIC_POSE_SPACE

;    for (int i = 1; i <= DynamicPoseHashmap.HASHMAP_SIZE; i++)
;    {
;        hashmap.Add((byte)((i * DynamicPoseHashmap.INCREASE_PER_STEP) % DynamicPoseHashmap.HASHMAP_SIZE),
;                        new((ushort)((i * DynamicPoseHashmap.HASHMAP_SIZE) + DynamicPoseHashmap.INCREASE_PER_STEP),
;                        (byte)(i * 2), 0));
;    }
    !i = 1
    while !i <= 128
    REP #$20
	LDA.w #(!HASHMAP_SIZE*!i)+!INCREASE_PER_STEP
    STA.b PoseIDBackup
    SEP #$20
    LDX.b #(!INCREASE_PER_STEP*!i)&$7F
    LDA.b #!i*2
    STA.l DX_Dynamic_Pose_Offset,x
    LDX.b #((!INCREASE_PER_STEP*!i)&$7F)*2
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)
    !i #= !i+1
    endif
;    Assert.AreEqual(hashmap.Length, DynamicPoseHashmap.HASHMAP_SIZE);
    LDA.l DX_Dynamic_Pose_Length
    CMP.b #$80
    BEQ +
    LDA.B #$05 : STA.B TEST_STATUS : RTL
+
;    Assert.AreEqual(hashmap.GetHashSize(DynamicPoseHashmap.INCREASE_PER_STEP), DynamicPoseHashmap.HASHMAP_SIZE);
    LDA.l DX_Dynamic_Pose_HashSize+!INCREASE_PER_STEP
    CMP.b #$80
    BEQ +
    LDA.B #$06   : STA.B TEST_STATUS : RTL
+
;    byte hashmapIndex = DynamicPoseHashmap.INCREASE_PER_STEP;
    LDA.b #!INCREASE_PER_STEP
    STA.b HashIndexBackup
;    Assert.IsFalse(hashmap.FindFreeSpace(ref hashmapIndex));
    %CallFunctionLongShortDBG(DynamicPoseHashmap_FindFreeSpace)
    BCC +
    LDA.B #$07   : STA.B TEST_STATUS : RTL
+
;    Assert.AreEqual(hashmapIndex, DynamicPoseHashmap.INCREASE_PER_STEP);
    LDA.b HashIndexBackup
    CMP.b #!INCREASE_PER_STEP
    BEQ +
    LDA.B #$08   : STA.B TEST_STATUS : RTL
+
RTL
DynamicPoseHashmap_Test3:
    dl .Pasado
    dl .Assert1
    dl .Assert2
    dl .Assert3
    dl .Assert4
    dl .Assert5
    dl .Assert6
    dl .Assert7
    dl .Assert8
.Pasado db "TestFindFreeSpace: Pasado",$00
.Assert1 db "TestFindFreeSpace Assert 1",$00
.Assert2 db "TestFindFreeSpace Assert 2",$00
.Assert3 db "TestFindFreeSpace Assert 3",$00
.Assert4 db "TestFindFreeSpace Assert 4",$00
.Assert5 db "TestFindFreeSpace Assert 5",$00
.Assert6 db "TestFindFreeSpace Assert 6",$00
.Assert7 db "TestFindFreeSpace Assert 7",$00
.Assert8 db "TestFindFreeSpace Assert 8",$00