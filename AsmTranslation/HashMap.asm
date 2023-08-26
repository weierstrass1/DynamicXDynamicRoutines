;Implementacion de Hashmap
namespace DynamicPoseHashmap
{

;-----------------------------------------------------------------------------------------
;             DynamicPoseHashmap.FindPose     JSL DynamicPoseHashmap_FindPose
;-----------------------------------------------------------------------------------------

;-- ENTRADA:
;A -> 8-bit, XY -> 16-bit
;Y (16-bit) = Pose ID

;-- SALIDA:
;Carry clear si no se encontro y Carry set si se encontro
;HashIndexBackup es el slot devuelto.
FindPose:
		;getHashCode
		STY.W PoseIDBackup : TYA : AND.B #!HASHMAP_SIZE-1
	SEP #$10 ;XY -> 8
	STA.B HashCodeBackup : STA.B HashIndexBackup

	LDA.L DX_Dynamic_Pose_Length : BEQ .ReturnFalseCarryClear ;if (Length == 0) return false
	LDA.L DX_Dynamic_Pose_HashSize,X : BEQ .ReturnFalseCarryClear ;if (hashSize[hashCode]) return false
	STA.B HashSizeBackup

	;X = hashCode * 2
	LDA.B HashCodeBackup : ASL : TAX
.hashLoop
	REP #$20 ;A->16
		LDA.L DX_Dynamic_Pose_ID,X : CMP.W #$FFFF : BEQ .incrementHashLoopAndContinue ;if (slot is null)
		CMP.B PoseIDBackup ;z = (A == PoseIDBackup)
	SEP #$20 ;A->8
	BEQ ReturnHashIndexAndTrue ;slot.ID == id

	AND.B #!HASHMAP_SIZE-1 : CMP.B HashCodeBackup : BNE .incrementHashLoopAndContinue_8bit ;DynamicPoseHashMapSlot.GetHashCode(slot.ID) != hashCode
	DEC.B HashSizeBackup : BNE .incrementHashLoopAndContinue_8bit ;i--, i > 0 -> incrementHashLoopAndContinue_8bit
;no se encontro, devolver X / 2 y Carry Clear
.couldNotBeFound
	TXA : LSR : STA.B HashIndexBackup
.ReturnFalseCarryClear
	CLC
RTL

;Incrementar resultado hash y continuar.
.incrementHashLoopAndContinue
	SEP #$20 ;A->8
.incrementHashLoopAndContinue_8bit
	;Seguir la busqueda
	TXA : CLC : ADC.B #!INCREASE_PER_STEP*2 : AND.B #(!HASHMAP_SIZE-1)*2 : TAX
BRA .hashLoop

;se encontro, devolver X / 2 y Carry Set
;este label es tambien utilizado en FindFreeSpace para devolver el slot que se encontro.
ReturnHashIndexAndTrue:
	TXA : LSR : STA.B HashIndexBackup : SEC
RTL

;---------------------------------------------------------------------------------------------
;          DynamicPoseHashmap.FindFreeSpace     JSL DynamicPoseHashmap_FindFreeSpace
;---------------------------------------------------------------------------------------------
;-- ENTRADA:
;AXY -> 8-bit
;X = hashmapIndex

;-- SALIDA:
;Carry clear si no se encontro y Carry set si se encontro
;HashIndexBackup es el slot devuelto.
FindFreeSpace:
	LDA.L DX_Dynamic_Pose_Length : CMP.B #!HASHMAP_SIZE : BCS FindPose_ReturnFalseCarryClear ;Length >= HASHMAP_SIZE

	;X = hashmapIndex * 2
	TXA : ASL : TAX
.hashLoop
	REP #$20 ;A->16
		LDA.L DX_Dynamic_Pose_ID,X : CMP.W #$FFFF ;z = if (slot is null)
	SEP #$20 ;A->8
	BEQ ReturnHashIndexAndTrue

	;Seguir la busqueda
	TXA : CLC : ADC.B #!INCREASE_PER_STEP*2 : AND.B #(!HASHMAP_SIZE-1)*2 : TAX
BRA .hashLoop

;------------------------------------------------------------------------------------------------------------
;                DynamicPoseHashmap.Add     %CallFunctionLongShortDBG(DynamicPoseHashmap_Add)
;------------------------------------------------------------------------------------------------------------
;-- ENTRADA:
;A -> 16-bit, XY -> 8-bit
;A = Pose ID (16-bit)
;X = hashmapIndex * 2
Add:
		if !DEBUG != 0 ;-- TEST: slots[hashmapIndex] is not null
			PHA : LDA.L DX_Dynamic_Pose_ID,X : CMP.W #$FFFF : BEQ + : BRK : + : PLA
		endif
		STA.L DX_Dynamic_Pose_ID,X ;slots[hashmapIndex] = slot;
	SEP #$20
	AND.B #!HASHMAP_SIZE-1 : TAX ;DynamicPoseHashMapSlot.GetHashCode()
	LDA.L DX_Dynamic_Pose_HashSize,X : INC A : STA.L DX_Dynamic_Pose_HashSize,X ;hashSize[]++;
	LDA.L DX_Dynamic_Pose_Length : INC A : STA.L DX_Dynamic_Pose_Length ;Length++;
%ReturnLongShortDBG()

;------------------------------------------------------------------------------------------------------------------
;                DynamicPoseHashmap.Remove     %CallFunctionLongShortDBG(DynamicPoseHashmap_Remove)
;------------------------------------------------------------------------------------------------------------------
;-- ENTRADA:
;XY -> 8-bit
;X = hashmapIndex * 2
Remove:
	REP #$20
		LDA.L DX_Dynamic_Pose_ID,X
		if !DEBUG != 0 ;-- TEST: slots[hashmapIndex] is null
			CMP.W #$FFFF : BNE + : BRK : +
		endif
		PHA
		LDA.W #$FFFF : STA.L DX_Dynamic_Pose_ID,X ;slots[hashmapIndex] = null;
		PLA
	SEP #$20
	AND.B #!HASHMAP_SIZE-1 : TAX ;DynamicPoseHashMapSlot.GetHashCode()
	LDA.L DX_Dynamic_Pose_HashSize,X : DEC A : STA.L DX_Dynamic_Pose_HashSize,X ;hashSize[]--
	LDA.L DX_Dynamic_Pose_Length : DEC A : STA.L DX_Dynamic_Pose_Length ;Length--;
%ReturnLongShortDBG()

}
namespace off
