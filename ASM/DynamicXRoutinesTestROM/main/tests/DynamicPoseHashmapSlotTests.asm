;determine with BEQ to see if test passed
DynamicPoseHashmapSlotTests_TestGetHashCode:
    STZ.B TEST_STATUS
    LDA.B #$85
	AND.b #!HASHMAP_SIZE-1 ;DynamicPoseHashMapSlot.GetHashCode()
    CMP.B #$05
    BNE +
        INC.B TEST_STATUS
    +
RTL

SlotTestsStrings:
    dl SlotTestsRetF
    dl SlotTestsRetP

SlotTestsRetP: db "Test SlotTests: Pasado",$00
SlotTestsRetF: db "Test SlotTests: Fallado",$00