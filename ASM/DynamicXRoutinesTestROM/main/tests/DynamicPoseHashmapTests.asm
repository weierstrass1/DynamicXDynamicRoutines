;public void TestAdd()
;{
;    DynamicPoseHashmap hashmap = new();
;    Assert.AreEqual(hashmap.Length, 0);
;    Assert.AreEqual(hashmap.GetHashSize(0), 0);
;    DynamicPoseHashMapSlot slot = new(0, 0, 0);
;    hashmap.Add(0, slot);
;    Assert.AreEqual(hashmap.Length, 1);
;    Assert.AreEqual(hashmap.GetHashSize(0), 1);
;    Assert.AreEqual(hashmap.Get(0), slot);
;    Assert.ThrowsException<Exception>(() => hashmap.Add(0, new(1, 2, 0)));
;    Assert.AreEqual(hashmap.Length, 1);
;    Assert.AreEqual(hashmap.GetHashSize(0), 1);
;    Assert.AreEqual(hashmap.Get(0), slot);
;}
DynamicPoseHashmap_TestAdd:
    
RTL
DynamicPoseHashmap_Test1:
    dl .Pasado
    dl .Assert1
    dl .Assert2
    dl .Assert3
    dl .Assert4
    dl .Assert5
    dl .Assert6
    dl .Assert7
    dl .Assert8
.Pasado db "Test TestGetSizeAndScore: Pasado",$00
.Assert1 db "TestGetSizeAndScore Assert 1",$00
.Assert2 db "TestGetSizeAndScore Assert 2",$00
.Assert3 db "TestGetSizeAndScore Assert 3",$00
.Assert4 db "TestGetSizeAndScore Assert 4",$00
.Assert5 db "TestGetSizeAndScore Assert 5",$00
.Assert6 db "TestGetSizeAndScore Assert 6",$00
.Assert7 db "TestGetSizeAndScore Assert 7",$00
.Assert8 db "TestGetSizeAndScore Assert 8",$00