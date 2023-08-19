using DynamicXDynamicRoutinesLibrary;
using TypeMock.ArrangeActAssert;
using TypeMock.ArrangeActAssert.Fluent;
using TypeMock.Internal;

namespace DynamicXDynamicRoutinesTests
{
    [TestClass]
    public class VRAMMApTests
    {
        private VRAMMap startVRAMMap(bool withHashMapSlot = true)
        {
            DynamicPoseHashmap hashmap = new();
            if (withHashMapSlot)
                hashmap.Add(0, new(0, 0, 0));
            DynamicPoseDataBase poseDataBase = new();
            poseDataBase.ReadData(Path.Combine("TestData", "Data.asm"));
            VRAMMap vramMap = new()
            {
                Hashmap = hashmap,
                PoseDataBase = poseDataBase
            };
            return vramMap;
        }
        [TestMethod]
        public void TestGetBestSlot()
        {
            VRAMMap vramMap = startVRAMMap(false);
            var vramSlot0 = vramMap.Get(0);
            var vramSlot3F = vramMap.Get(0x3F);
            var vramSlot40 = vramMap.Get(0x40);
            var vramSlot5F = vramMap.Get(0x5F);
            var vramSlot60 = vramMap.Get(0x60);
            var vramSlotL_1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
            vramSlot0.Offset = 0x80;
            vramSlot0.SizeOrPose = 0x3F | 0x80;
            vramSlot3F.Offset = 0x80;
            vramSlot3F.SizeOrPose = 0x1F | 0x80;
            vramSlot40.Offset = 0x40;
            vramSlot40.SizeOrPose = 0x1F | 0x80;
            vramSlot5F.Offset = 0x40;
            vramSlot5F.SizeOrPose = 0x1F | 0x80;
            vramSlot60.Offset = 0x60;
            vramSlot60.SizeOrPose = (VRAMMap.VRAMMAP_SIZE - 0x60 - 1) | 0x80;
            vramSlotL_1.Offset = 0x60;
            vramSlotL_1.SizeOrPose = (VRAMMap.VRAMMAP_SIZE - 0x60 - 1) | 0x80;

            vramMap.Hashmap.Add(0, new(0, 0x40, 10));
            vramMap.Hashmap.Add(1, new(0, 0x60, 20));

            vramMap.AddPoseInSpace(0, new()
            {
                Offset = 0x40,
                Size = 0x20,
            });
            vramMap.AddPoseInSpace(1, new()
            {
                Offset = 0x60,
                Size = 0x20,
            });

            Space best = vramMap.GetBestSlot(0x20, 30);
            Assert.AreEqual(best.Offset, 0x40);
            Assert.AreEqual(best.Size, 0x20);
            Assert.AreEqual(best.Score, 20);
        }
        [TestMethod, Isolated]
        public void TestcheckSpace()
        {
            VRAMMap vramMap = startVRAMMap(false);
            var vramSlot0 = vramMap.Get(0);
            var vramSlot1 = vramMap.Get(1);
            var vramSlotL_1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
            vramSlot0.Offset = 0x80;
            vramSlot0.SizeOrPose = 0x80;
            vramSlot1.Offset = 1;
            vramSlot1.SizeOrPose = (VRAMMap.VRAMMAP_SIZE - 1) | 0x80;
            vramSlotL_1.Offset = 1;
            vramSlotL_1.SizeOrPose = (VRAMMap.VRAMMAP_SIZE - 1) | 0x80;

            vramMap.Hashmap.Add(0, new(0, 1, 5));
            vramMap.AddPoseInSpace(0, new()
            {
                Offset = 1,
                Size = VRAMMap.VRAMMAP_SIZE - 1,
                Score = 0
            });
            vramMap.Hashmap.Add(1, new(0, 2, 2));
            vramMap.AddPoseInSpace(1, new()
            {
                Offset = 2,
                Size = VRAMMap.VRAMMAP_SIZE - 2,
                Score = 0
            });
            byte i = 0;
            byte size = 3;
            bool adjacent = true;
            Space current = new()
            {

            };
            ushort TimeSpan = 0;
            var ibox = Args.Ref(adjacent);

            Assert.IsFalse((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkSpace",
                i, size, ibox, current, TimeSpan));
            Assert.AreEqual(current.Offset, 0);
            Assert.IsFalse(ibox.Value);

            i = 1;
            size = 1;
            adjacent = false;
            ibox = Args.Ref(adjacent);
            TimeSpan = 5;
            Assert.IsFalse((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkSpace",
                i, size, ibox, current, TimeSpan));
            Assert.AreEqual(current.Offset, 1);
            Assert.AreEqual(current.Size, 1);
            Assert.AreEqual(current.Score, 0);
            Assert.IsFalse(ibox.Value);

            i = 2;
            size = 1;
            adjacent = false;
            ibox = Args.Ref(adjacent);
            TimeSpan = 10;
            Assert.IsTrue((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkSpace",
                i, size, ibox, current, TimeSpan));
            Assert.AreEqual(current.Offset, 2);
            Assert.AreEqual(current.Size, 1);
            Assert.AreEqual(current.Score, 8);
            Assert.IsFalse(ibox.Value);

            i = 2;
            size = 2;
            adjacent = false;
            ibox = Args.Ref(adjacent);
            TimeSpan = 10;
            current = new();
            Assert.IsTrue((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkSpace",
                i, size, ibox, current, TimeSpan));
            Assert.AreEqual(current.Offset, 2);
            Assert.AreEqual(current.Size, 1);
            Assert.AreEqual(current.Score, 8);
            Assert.IsTrue(ibox.Value);

            i = 1;
            Assert.IsTrue((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkSpace",
                i, size, ibox, current, TimeSpan));
            Assert.AreEqual(current.Offset, 1);
            Assert.AreEqual(current.Size, 2);
            Assert.AreEqual(current.Score, 5);
            Assert.IsTrue(ibox.Value);
        }
        [TestMethod, Isolated]
        public void TestcheckIfCurrentIsBest()
        {
            VRAMMap vramMap = startVRAMMap();
            byte size = 3;
            bool adjacent = true;
            var ibox = Args.Ref(adjacent);
            Space current = new()
            {
                Offset = 0,
                Size = 2,
                Score = 40,
            };
            Space best = new()
            {
                Offset = 0,
                Size = 4,
                Score = 40,
            };
            Assert.IsFalse((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkIfCurrentIsBest",
                size, ibox, current, best));
            Assert.IsTrue(ibox.Value);
            current = new()
            {
                Offset = 0,
                Size = 5,
                Score = 40,
            };
            Assert.IsFalse((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkIfCurrentIsBest",
                size, ibox, current, best));
            Assert.IsFalse(ibox.Value);
            ibox = Args.Ref(adjacent);
            current = new()
            {
                Offset = 0,
                Size = 4,
                Score = 39,
            };
            Assert.IsFalse((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkIfCurrentIsBest",
                size, ibox, current, best));
            Assert.IsFalse(ibox.Value);
            ibox = Args.Ref(adjacent);
            current = new()
            {
                Offset = 0,
                Size = 4,
                Score = 40,
            };
            Assert.IsFalse((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkIfCurrentIsBest",
                size, ibox, current, best));
            Assert.IsFalse(ibox.Value);
            ibox = Args.Ref(adjacent);
            current = new()
            {
                Offset = 0,
                Size = 4,
                Score = 41,
            };
            Assert.IsTrue((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkIfCurrentIsBest",
                size, ibox, current, best));
            Assert.IsFalse(ibox.Value);
            Assert.AreEqual(best.Offset, current.Offset);
            Assert.AreEqual(best.Size, current.Size);
            Assert.AreEqual(best.Score, current.Score);
            ibox = Args.Ref(adjacent);
            current = new()
            {
                Offset = 0,
                Size = 3,
                Score = 40,
            };
            best = new()
            {
                Offset = 0,
                Size = 4,
                Score = 40,
            };
            Assert.IsTrue((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkIfCurrentIsBest",
                size, ibox, current, best));
            Assert.IsFalse(ibox.Value);
            Assert.AreEqual(best.Offset, current.Offset);
            Assert.AreEqual(best.Size, current.Size);
            Assert.AreEqual(best.Score, current.Score);
            ibox = Args.Ref(adjacent);
            current = new()
            {
                Offset = 0,
                Size = 3,
                Score = 45,
            };
            best = new()
            {
                Offset = 0,
                Size = 4,
                Score = 40,
            };
            Assert.IsTrue((bool)Isolate.Invoke.MethodFromBase<VRAMMap>(vramMap, "checkIfCurrentIsBest",
                size, ibox, current, best));
            Assert.IsFalse(ibox.Value);
            Assert.AreEqual(best.Offset, current.Offset);
            Assert.AreEqual(best.Size, current.Size);
            Assert.AreEqual(best.Score, current.Score);
        }
        [TestMethod]
        public void TestRemovePosesInSpace()
        {
            VRAMMap vramMap = startVRAMMap();
            vramMap.Hashmap.Add(1, new(0, 1, 0));
            vramMap.Hashmap.Add(2, new(0, 2, 0));
            vramMap.AddPoseInSpace(0, new()
            {
                Offset = 0,
                Score = 0,
                Size = VRAMMap.VRAMMAP_SIZE
            });
            vramMap.AddPoseInSpace(1, new()
            {
                Offset = 1,
                Score = 0,
                Size = VRAMMap.VRAMMAP_SIZE - 1
            });
            vramMap.AddPoseInSpace(2, new()
            {
                Offset = 2,
                Score = 0,
                Size = VRAMMap.VRAMMAP_SIZE - 2
            });
            VRAMMapSlot slot0 = vramMap.Get(0);
            Assert.AreEqual(slot0.Offset, 0);
            Assert.AreEqual(slot0.SizeOrPose, 0);
            VRAMMapSlot slot1 = vramMap.Get(1);
            Assert.AreEqual(slot1.Offset, 1);
            Assert.AreEqual(slot1.SizeOrPose, 1);
            VRAMMapSlot slot2 = vramMap.Get(2);
            Assert.AreEqual(slot2.Offset, 2);
            Assert.AreEqual(slot2.SizeOrPose, 2);
            VRAMMapSlot EndSlot1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
            Assert.AreEqual(EndSlot1.Offset, 3);
            Assert.AreEqual(EndSlot1.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 4) | 0x80);
            VRAMMapSlot EndSlot2 = vramMap.Get(3);
            Assert.AreEqual(EndSlot2.Offset, 3);
            Assert.AreEqual(EndSlot2.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 4) | 0x80);

            Assert.IsNotNull(vramMap.Hashmap.Get(0));
            Assert.IsNotNull(vramMap.Hashmap.Get(1));
            Assert.IsNotNull(vramMap.Hashmap.Get(2));
            Assert.AreEqual(vramMap.Hashmap.Length, 3);
            Assert.AreEqual(vramMap.Hashmap.GetHashSize(0), 3);
            vramMap.RemovePosesInSpace(new()
            {
                Offset = 1,
                Score = 0,
                Size = VRAMMap.VRAMMAP_SIZE - 1
            });
            Assert.IsNotNull(vramMap.Hashmap.Get(0));
            Assert.ThrowsException<Exception>(() => vramMap.Hashmap.Get(1));
            Assert.ThrowsException<Exception>(() => vramMap.Hashmap.Get(2));
            Assert.AreEqual(vramMap.Hashmap.Length, 1);
            Assert.AreEqual(vramMap.Hashmap.GetHashSize(0), 1);
        }
        [TestMethod]
        public void TestRemoveSpace()
        {
            VRAMMap vramMap = startVRAMMap();
            vramMap.AddPoseInSpace(0, new()
            {
                Offset = 0,
                Score = 0,
                Size = VRAMMap.VRAMMAP_SIZE
            });
            vramMap.RemoveSpace(new()
            {
                Offset = 0,
                Score = 0,
                Size = VRAMMap.VRAMMAP_SIZE
            });
            VRAMMapSlot EndSlot1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
            Assert.AreEqual(EndSlot1.Offset, 0);
            Assert.AreEqual(EndSlot1.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 1) | 0x80);
            VRAMMapSlot EndSlot2 = vramMap.Get(0);
            Assert.AreEqual(EndSlot2.Offset, 0);
            Assert.AreEqual(EndSlot2.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 1) | 0x80);
        }
        [TestMethod]
        public void TestAddPoseInSpace()
        {
            VRAMMap vramMap = startVRAMMap();
            vramMap.AddPoseInSpace(0, new()
            {
                Offset = 0,
                Score = 0,
                Size = VRAMMap.VRAMMAP_SIZE
            });
            VRAMMapSlot EndSlot1 = vramMap.Get(VRAMMap.VRAMMAP_SIZE - 1);
            Assert.AreEqual(EndSlot1.Offset, 1);
            Assert.AreEqual(EndSlot1.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 2) | 0x80);
            VRAMMapSlot EndSlot2 = vramMap.Get(1);
            Assert.AreEqual(EndSlot2.Offset, 1);
            Assert.AreEqual(EndSlot2.SizeOrPose, (VRAMMap.VRAMMAP_SIZE - 2) | 0x80);
            VRAMMapSlot StartSlot = vramMap.Get(0);
            Assert.AreEqual(StartSlot.Offset, 0);
            Assert.AreEqual(StartSlot.SizeOrPose, 0);
        }
    }
}
