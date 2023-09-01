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
;Input:
;   Y 16 bits: Pose ID
TakeDynamicRequest:
	JSL DynamicPoseHashmap_FindPose
	BCC +                           ;if (Hashmap.FindPose(id, out byte hashmapindex))
		LDX.b HashIndexBackup
		SEC : RTL ;return true;
	+
	PHB : PHK : PLB

	REP #$30 ;AXY->16 bit
			LDA.b PoseIDBackup : ASL : TAY ;DynamicPose pose = PoseDataBase.Get(id);
			LDA.w PoseSize,y : CLC : ADC.l DX_Dynamic_CurrentDataSend : CMP.l DX_Dynamic_MaxDataPerFrame : BEQ + : BCC + ;if (currentDataSent > MaximumDataPerFrame)
			BCC +
				SEP #$30
				PLB
				CLC : RTL  ;return false;
			+
			PHA ;ushort currentDataSent = (ushort)(pose.Size + CurrentDataSent);
			LDY.b PoseIDBackup
		SEP #$20 ;A->8 bit
		LDA.w Pose16x16Blocks,y : STA.b VRAMMapTMP_Size
	SEP #$10 ;XY->8 bit
	%CallFunctionLongShortDBG(VRAMMap_GetBestSlot) ;Space bestSpace = VRAMMap.GetBestSlot(pose.Blocks16x16, TimeSpan);
	LDA.b VRAMMapBestSpace_Offset : CMP #$FF : BNE + ;if (bestSpace.Offset == 0xFF)
		PLA : PLA
		CLC : RTL  ;return false;
	+
	%CallFunctionLongShortDBG(VRAMMap_RemoveSpace)              ;VRAMMap.RemoveSpace(bestSpace);
	%CallFunctionLongShortDBG(DynamicPoseHashmap_FindFreeSpace) ;Hashmap.FindFreeSpace(ref hashmapindex);
	REP #$20 ;A->16 bit
		PLA : STA.l DX_Dynamic_CurrentDataSend ;CurrentDataSent = currentDataSent;
	SEP #$20 ;A->8 bit

	LDX.b HashIndexBackup
	LDA.b VRAMMapBestSpace_Offset : STA.l DX_Dynamic_Pose_Offset,x
	LDA.b HashIndexBackup : ASL : TAX
	%CallFunctionLongShortDBG(DynamicPoseHashmap_Add)           ;Hashmap.Add(hashmapindex, new(pose.ID, bestSpace.Offset, TimeSpan));
	%CallFunctionLongShortDBG(VRAMMap_AddPoseInSpace)           ;VRAMMap.AddPoseInSpace(hashmapindex, bestSpace);

	LDX.b HashIndexBackup
	PLB
	SEC
RTL                                                             ;return true;