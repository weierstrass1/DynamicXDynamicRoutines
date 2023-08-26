;public void RemovePosesInSpace(Space space)
;{
;    byte limit = (byte)(space.Offset + space.Size);
;    VRAMMapSlot slot;
;    byte size;
;    for (byte i = space.Offset; i < limit; i += size) 
;    {
;        slot = slots[i];
;        size = slot.GetSize(PoseDataBase, Hashmap);
;        if (!slot.IsFree)
;            Hashmap.Remove(slot.SizeOrPose);
;    }
;}
;Input:
;   VRAMMapBestSpace
RemovePosesInSpace:
    LDA.B VRAMMapBestSpace_Offset : TAX ;i = space.Offset
    CLC : ADC.B VRAMMapBestSpace_Size : STA.B VRAMMapLoop ;limit = space.Offset + space.Size
.loop
    %VRAMMapSlot_GetSize()
    STA.b VRAMMapSlot_Size ;size = slot.GetSize(PoseDataBase, Hashmap);

    %VRAMMapSlot_IsFree() ;if (!slot.IsFree)
    BNE +
        PHX
        LDA.L DX_Dynamic_Tile_Pose,x : ASL : TAX
        %CallFunctionLongShortDBG(DynamicPoseHashmap_Remove) ;Hashmap.Remove(slot.SizeOrPose);
        PLX
    +

    TXA : CLC : ADC.B VRAMMapSlot_Size : TAX ;i += size
    CMP.B VRAMMapLoop : BCC .loop ;i < limit
%ReturnLongShortDBG()

;public void RemoveSpace(Space space)
;{
;    RemovePosesInSpace(space);
;    var slot = slots[space.Offset];
;    slot.Offset = space.Offset;
;    slot.SizeOrPose = (byte)((space.Size - 1) | 0x80);
;
;    slot = slots[space.Offset + space.Size - 1];
;    slot.Offset = space.Offset;
;    slot.SizeOrPose = (byte)((space.Size - 1) | 0x80);
;}
;Input:
;   VRAMMapBestSpace
RemoveSpace:
%ReturnLongShortDBG()
;public void AddPoseInSpace(byte hashmapIndex, Space space)
;{
;    var slot = slots[space.Offset];
;    slot.SizeOrPose = hashmapIndex;
;    slot.Offset = space.Offset;
;
;    byte nextSlotIndex = (byte)(space.Offset + slot.GetSize(PoseDataBase, Hashmap));
;    slot = slots[nextSlotIndex - 1];
;    slot.SizeOrPose = hashmapIndex;
;    slot.Offset = space.Offset;
;
;    byte size = (byte)(nextSlotIndex - space.Offset);
;    if (size == space.Size)
;        return;
;    size = (byte)((space.Size - size - 1) | 0x80);
;    slot = slots[nextSlotIndex];
;    slot.SizeOrPose = size;
;    slot.Offset = nextSlotIndex;
;
;    slot = slots[nextSlotIndex + (size & 0x7F)];
;    slot.SizeOrPose = size;
;    slot.Offset = nextSlotIndex;
;}
;Input:
;   HashIndexBackup
;   VRAMMapBestSpace
AddPoseInSpace:

    LDA.b VRAMMapBestSpace_Offset
    TAX                             ;var slot = slots[space.Offset];
    STA.l DX_Dynamic_Tile_Offset,x  ;slot.Offset = space.Offset;
    LDA.b HashIndexBackup
    STA.l DX_Dynamic_Tile_Pose,x    ;slot.SizeOrPose = hashmapIndex;

    %VRAMMapSlot_GetSize()
    STA.b VRAMMapSlot_Size
    CLC
    ADC.b VRAMMapBestSpace_Offset   ;byte nextSlotIndex = (byte)(space.Offset + slot.GetSize(PoseDataBase, Hashmap));
    DEC A
    TAX                             ;slot = slots[nextSlotIndex - 1];
    LDA.b VRAMMapBestSpace_Offset
    STA.l DX_Dynamic_Tile_Offset,x  ;slot.Offset = space.Offset; 
    LDA.b HashIndexBackup
    STA.l DX_Dynamic_Tile_Pose,x    ;slot.SizeOrPose = hashmapIndex;

    LDA VRAMMapBestSpace_Size
    SEC
    SBC VRAMMapSlot_Size
    BNE +                           ;if (size == space.Size)
%ReturnLongShortDBG()               ;   return;
+
    DEC A
    STA VRAMMapSlot_Size            ;size = (byte)((space.Size - size - 1) | 0x80);
    INX                             ;slot = slots[nextSlotIndex];
    ORA #$80
    STA.l DX_Dynamic_Tile_Size,x    ;slot.SizeOrPose = size;
    TXA                             
    STA.l DX_Dynamic_Tile_Offset,x  ;slot.Offset = nextSlotIndex;

    CLC
    ADC VRAMMapSlot_Size
    PHX
    TAX                             ;slot = slots[nextSlotIndex + (size & 0x7F)];

    LDA VRAMMapSlot_Size
    ORA #$80
    STA.l DX_Dynamic_Tile_Size,x    ;slot.SizeOrPose = size;
    PLA
    STA.l DX_Dynamic_Tile_Offset,x  ;slot.Offset = nextSlotIndex;
    
%ReturnLongShortDBG()
