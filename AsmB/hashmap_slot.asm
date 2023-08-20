math pri on

!INCREASE_PER_STEP = 15
!HASHMAP_SIZE = 128 ;tiene que ser factor de 2

namespace DX
	Timer: skip 2
	namespace Dynamic
		;Number of bytes send with DMA during the current SNES Frame
		CurrentDataSend: skip 2
		MaxDataPerFrame: skip 2
		if !DynamicPoses
		namespace Tile
			Pose: ;Marked by high bit being set
			Size: skip 128
			Offset: skip 128
		namespace off
		namespace Pose
			Length: skip 1
			HashSize: skip !HASHMAP_SIZE ;Elements with same hash value
			Offset: skip !HASHMAP_SIZE ;VRAM Offset of the Pose
			TimeLastUse: skip !HASHMAP_SIZE ;SNES Frames since the last time that the pose was used
			ID: skip !HASHMAP_SIZE*2 ;Current Pose ID that was loaded to VRAM
		namespace off
	namespace off
namespace off

;Scratch RAM
org $0000
HashCodeBackup: skip 1
PoseIDBackup: skip 2
HashSizeBackup: skip 1

;ASUMIENDO
;Y (16-bit), $01 = Pose ID (16-bit)
;X (8-bit), $00 -> hashCode (0 a 127)
;$03 = hashSize pose
;Se asume A 8-bit, XY 16-bit
;Deuelve Carry clear si no se encontro y Carry set si se encontro
FindPose:
		;getHashCode
		STY.B PoseIDBackup : TYA : AND.B #!HASHMAP_SIZE-1
	SEP #$10 ;XY -> 8
	STA.B HashCodeBackup : TAX

	LDA.L DX_Dynamic_Pose_Length : BEQ .couldNotBeFound ;if (Length == 0) return false
	LDA.L DX_Dynamic_Pose_HashSize,X : BEQ .couldNotBeFound ;if (hashSize[hashCode]) return false
	STA.B HashSizeBackup

	;X = hashCode * 2
	TXA : ASL : TAX
.hashLoop
	REP #$20 ;A->16
		LDA.L DX_Dynamic_Pose_ID,X : CMP.W #$FFFF : BEQ .incrementHashLoopAndContinue ;if (slot is null)
		CMP.B PoseIDBackup ;z = (A == PoseIDBackup)
	SEP #$20 ;A->8
	BEQ .found ;slot.ID == id

	AND.B #!HASHMAP_SIZE-1 : CMP.B HashCodeBackup : BEQ .incrementHashLoopAndContinue_8bit ;DynamicPoseHashMapSlot.GetHashCode(slot.ID) != hashCode
	DEC.B HashSizeBackup : BNE .incrementHashLoopAndContinue_8bit ;i--, i > 0 -> incrementHashLoopAndContinue_8bit
.couldNotBeFound
	CLC ;return false
RTL

.incrementHashLoopAndContinue
	SEP #$20 ;A->8
.incrementHashLoopAndContinue_8bit
	TXA : CLC : ADC.B #!INCREASE_PER_STEP*2 : AND.B #(!HASHMAP_SIZE*2)-1 : TAX
BRA .hashLoop

;found, devolver X / 2 y Carry Set
.found
	TXA : LSR : TAX : SEC
RTL