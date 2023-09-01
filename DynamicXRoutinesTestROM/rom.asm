;sa1
sa1rom

;variables generales
incsrc "hardware_registers.asm"
incsrc "variables.asm"

;rom
reset bytes : ORG $008000
incsrc "main/loop.asm"
incsrc "main/tests.asm"
incsrc "main/test.asm"
incsrc "main/sa1.asm"

GRAFICOS_TEXTO:
incbin "graficos.bin"

I_CRASH:
STP

;game header
org $00FFD5
MemoryMap:      db $23 ;SA-1 Rom
CatridgeType:   db $35 ;ROM + SRAM + SA-1 + RAM + battery
ROMSize:        db $0C ;4mb ROM
SRAMSize:       db $07 ;128kb RAM
CountryCode:    db $01 ;Country, implies NTSC/PAL
LicenseeCode:   db $33 ;Developer ID
MaskROMVersion: db $00 ;ROM Version (0 = first)

;vectors
ORG $00FFE0
dw $0000, $0000, I_CRASH, I_CRASH, I_CRASH, I_CRASH, I_RESET, I_CRASH
dw $0000, $0000, I_CRASH, I_CRASH, I_CRASH, I_CRASH, I_RESET, I_CRASH