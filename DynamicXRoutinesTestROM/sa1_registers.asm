;SA-1 Registers
;https://wiki.superfamicom.org/sa-1-registers
ORG $002200
SA1_CPUCONTROL: skip 1			;SA-1 CPU Control
SA1_CPUINTERRUPTENABLE: skip 1	;S-CPU Interrupt Enable
SA1_CPUINTERRUPTCLEAR: skip 1	;S-CPU Interrupt Clear
SA1_CPURESETVECTOR: skip 2		;SA-1 CPU Reset Vector
SA1_CPUNMIVECTOR: skip 2		;SA-1 CPU NMI Vector
SA1_CPUIRQVECTOR: skip 2		;SA-1 CPU IRQ Vector
SA1_SCPUCONTROL: skip 1			;S-CPU Control
SA1_INTERRUPTENABLE: skip 1		;SA-1 Interrupt Enable
SA1_INTERRUPTCLEAR: skip 1		;SA-1 Interrupt Clear
SA1_RESETVECTOR: skip 2			;S-CPU CPU Reset Vector
SA1_IRQVECTOR: skip 2			;S-CPU CPU IRQ Vector

ORG $002220
SA1_MMC_BANKS: skip 4			;SA-1 Super MMC Banks (CXB, DXB, EXB, FXB)
SA1_CPU_BWRAM_MAPPING: skip 2	;CPU BW-RAM Address Mapping (First byte: S-CPU, second byte: SA-1)
SA1_CPU_BWRAM_WRITE_ON: skip 2	;CPU BW-RAM Write Enable (First byte: S-CPU, second byte: SA-1)
SA1_CPU_BWRAM_PROT_AREA: skip 1	;BW-RAM Write Protected Area
SA1_CPU_IRAM_WRITE_PROT: skip 2	;CPU I-RAM Write Protection (First byte: S-CPU, second byte: SA-1)