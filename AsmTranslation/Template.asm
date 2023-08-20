;Template para pruebas de asar
lorom
math pri on
namespace nested on

;Defines
!INCREASE_PER_STEP = 15
!HASHMAP_SIZE = 128 ;tiene que ser factor de 2

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

;bank
org $008000

;Projecto
incsrc "HashMap.asm"