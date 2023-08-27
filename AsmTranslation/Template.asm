;Template para pruebas de asar
lorom
math pri on
namespace nested on

;Defines
!INCREASE_PER_STEP = 15
!HASHMAP_SIZE = 128 ;tiene que ser factor de 2
!VRAMMAP_SIZE = 128 ;vrammap size
!DEBUG = 1

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
org $7F0000
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
namespace off

;-- Scratch
pushpc : org !Base1 ;$0000 (S-CPU) o $3000 (SA-1). Se podria usar un namespace para evitar variables duplicadas
	HashCodeBackup: skip 1
	HashIndexBackup: skip 1
	PoseIDBackup: skip 2
	HashSizeBackup: skip 1
	VRAMMapCurrentSpace:
		.Offset: skip 1
		.Score: skip 1
		.Size: skip 1
	VRAMMapBestSpace:
		.Offset: skip 1
		.Score: skip 1
		.Size: skip 1
	VRAMMapTMP_Size: skip 1
	VRAMMapSlot_Size: skip 1
	VRAMMapSlot_Score: skip 1
	VRAMMapLoop: skip 1
	TimespanLookup: skip 1
	VRAMMap_Adjacent: skip 1
pullpc

;bank
org $008000

;Projecto
incsrc "HashMap.asm"
incsrc "VRAMMAp.asm"
