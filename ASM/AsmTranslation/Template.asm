;Template para pruebas de asar
math pri on
namespace nested on

;Defines
!INCREASE_PER_STEP = 15
!HASHMAP_SIZE = 128 ;tiene que ser factor de 2
!VRAMMAP_SIZE = 128 ;vrammap size
!DEBUG = 1
!UnitTests = 1

;Macros
macro ReturnLongShortDBG()
    if !DEBUG != 0
        RTL
    else
        RTS
    endif
endmacro

macro CallFunctionLongShortDBG(func)
    if !DEBUG != 0
        JSL <func>
    else
        JSR <func>
    endif
endmacro

;Variables
pushpc : org $404000
!Base1 = $3000 ;de SA-1, base directpage
namespace DX
	Timer: skip 2
	namespace Dynamic
		;Number of bytes send with DMA during the current SNES Frame
		CurrentDataSend: skip 2
		MaxDataPerFrame: skip 2
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
pullpc : namespace off

;-- Scratch
pushpc : org !Base1 ;$0000 (S-CPU) o $3000 (SA-1). Se podria usar un namespace para evitar variables duplicadas
    HashCodeBackup: skip 1            ;$00
    HashIndexBackup: skip 1            ;$01
    PoseIDBackup: skip 2            ;$02
    HashSizeBackup: skip 1            ;$04
    VRAMMapCurrentSpace:
        .Offset: skip 1                ;$05
        .Score: skip 1                ;$06
        .Size: skip 1                ;$07
    VRAMMapBestSpace:
        .Offset: skip 1                ;$08
        .Score: skip 1                ;$09
        .Size: skip 1                ;$0A
    VRAMMapTMP_Size: skip 1            ;$0B
    VRAMMapSlot_Size: skip 1        ;$0C
    VRAMMapSlot_Score: skip 1        ;$0D
    VRAMMapLoop: skip 1                ;$0E
    VRAMMap_Adjacent: skip 1        ;$0F
pullpc

;Projecto
incsrc  "./VRAMMapSlot.asm"
incsrc  "./HashMap.asm"
incsrc  "./VRAMMap.asm"
incsrc  "./DynamicXSystem.asm"
if !UnitTests
incsrc "./TestData.asm"
else
incsrc "./HeavyTestData.asm"
endif
