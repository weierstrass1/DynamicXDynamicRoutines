;determine with BEQ to see if test passed
DynamicPoseHashmapSlotTests_TestGetHashCode:
    LDA.B #$85
	AND.b #!HASHMAP_SIZE-1 ;DynamicPoseHashMapSlot.GetHashCode()
    CMP.B #$05
RTL