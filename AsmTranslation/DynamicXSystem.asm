;public bool TakeDynamicRequest(ushort id)
;{
;    if (Hashmap.FindPose(id, out byte hashmapindex))
;        return true;
;    DynamicPose pose = PoseDataBase.Get(id);
;    ushort currentDataSent = (ushort)(pose.Size + CurrentDataSent);
;    if (currentDataSent > MaximumDataPerFrame)
;        return false;
;    Space bestSpace = VRAMMap.GetBestSlot(pose.Blocks16x16, TimeSpan);
;    if (bestSpace.Offset == 0xFF)
;        return false;
;    VRAMMap.RemoveSpace(bestSpace);
;    Hashmap.FindFreeSpace(ref hashmapindex);
;    CurrentDataSent = currentDataSent;
;    Hashmap.Add(hashmapindex, new(pose.ID, bestSpace.Offset, TimeSpan));
;    VRAMMap.AddPoseInSpace(hashmapindex, bestSpace);
;    return true;
;}
TakeDynamicRequest:
    JSL DynamicPoseHashmap_FindPose
    BCC +                           ;if (Hashmap.FindPose(id, out byte hashmapindex))
    SEC
RTL                                 ;   return true;
+
    PHB
    PHK
    PLB

    REP #$30
    LDA.b PoseIDBackup              ;DynamicPose pose = PoseDataBase.Get(id);
    ASL
    TAY
    LDA.w PoseSize,y
    CLC
    ADC.l DX_CurrentDataSend
    CMP.l DX_MaxDataPerFrame
    BEQ +
    BCC +                           ;if (currentDataSent > MaximumDataPerFrame)
    SEP #$30
    CLC
RTL                                 ;   return false;
+
    PHA                             ;ushort currentDataSent = (ushort)(pose.Size + CurrentDataSent);
    LDY.b PoseIDBackup
    SEP #$20
    LDA.w Pose16x16Blocks,y
    STA.b VRAMMapTMP_Size
    SEP #$10
    VRAMMap_GetBestSlot
    PLB
RTL