;determine with BEQ to see if test passed
DynamicPoseHashmapSlotTests_TestGetHashCode:
    LDA.B #$85
	AND.b #!HASHMAP_SIZE-1 ;DynamicPoseHashMapSlot.GetHashCode()
    CMP.B #$05
    BNE +
        INC.B TEST_PASADO
    +
RTL

SlotTestsRet0: db "Test SlotTests: Pasado",$00
SlotTestsRet1: db "Test SlotTests: Fallado",$00