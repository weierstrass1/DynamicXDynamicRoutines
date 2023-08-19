using DynamicXDynamicRoutinesLibrary;

namespace DynamicXDynamicRoutinesTests
{
    [TestClass]
    public class DynamicPoseHashmapTests
    {
        [TestMethod]
        public void TestAdd()
        {
            DynamicPoseHashmap hashmap = new();
            Assert.AreEqual(hashmap.Length, 0);
            Assert.AreEqual(hashmap.GetHashSize(0), 0);
            DynamicPoseHashMapSlot slot = new(0, 0, 0);
            hashmap.Add(0, slot);
            Assert.AreEqual(hashmap.Length, 1);
            Assert.AreEqual(hashmap.GetHashSize(0), 1);
            Assert.AreEqual(hashmap.Get(0), slot);
            Assert.ThrowsException<Exception>(() => hashmap.Add(0, new(1, 2, 0)));
            Assert.AreEqual(hashmap.Length, 1);
            Assert.AreEqual(hashmap.GetHashSize(0), 1);
            Assert.AreEqual(hashmap.Get(0), slot);
        }
        [TestMethod]
        public void TestRemove()
        {
            DynamicPoseHashmap hashmap = new();
            DynamicPoseHashMapSlot slot = new(0, 0, 0);
            hashmap.Add(0, slot);
            Assert.AreEqual(hashmap.Length, 1);
            Assert.AreEqual(hashmap.GetHashSize(0), 1);
            Assert.AreEqual(hashmap.Get(0), slot);
            hashmap.Remove(0);
            Assert.AreEqual(hashmap.Length, 0);
            Assert.AreEqual(hashmap.GetHashSize(0), 0);
            Assert.ThrowsException<Exception>(() => hashmap.Get(0));
            Assert.ThrowsException<Exception>(() => hashmap.Remove(0));
        }
        [TestMethod]
        public void TestFindFreeSpace()
        {
            DynamicPoseHashmap hashmap = new();
            for (int i = 1; i <= 5; i++)
            {
                hashmap.Add((byte)((i * DynamicPoseHashmap.INCREASE_PER_STEP) % DynamicPoseHashmap.HASHMAP_SIZE),
                            new((ushort)((i * DynamicPoseHashmap.HASHMAP_SIZE) + DynamicPoseHashmap.INCREASE_PER_STEP), 
                            (byte)(i * 2), 0));
            }
            Assert.AreEqual(hashmap.Length, 5);
            Assert.AreEqual(hashmap.GetHashSize(DynamicPoseHashmap.INCREASE_PER_STEP), 5);
            byte hashmapIndex = DynamicPoseHashmap.INCREASE_PER_STEP;
            Assert.IsTrue(hashmap.FindFreeSpace(ref hashmapIndex));
            Assert.AreEqual(hashmapIndex, DynamicPoseHashmap.INCREASE_PER_STEP * 6);

            hashmap = new();
            for (int i = 1; i <= DynamicPoseHashmap.HASHMAP_SIZE; i++)
            {
                hashmap.Add((byte)((i * DynamicPoseHashmap.INCREASE_PER_STEP) % DynamicPoseHashmap.HASHMAP_SIZE),
                                new((ushort)((i * DynamicPoseHashmap.HASHMAP_SIZE) + DynamicPoseHashmap.INCREASE_PER_STEP),
                                (byte)(i * 2), 0));
            }
            Assert.AreEqual(hashmap.Length, DynamicPoseHashmap.HASHMAP_SIZE);
            Assert.AreEqual(hashmap.GetHashSize(DynamicPoseHashmap.INCREASE_PER_STEP), DynamicPoseHashmap.HASHMAP_SIZE);
            hashmapIndex = DynamicPoseHashmap.INCREASE_PER_STEP;
            Assert.IsFalse(hashmap.FindFreeSpace(ref hashmapIndex));
            Assert.AreEqual(hashmapIndex, DynamicPoseHashmap.INCREASE_PER_STEP);
        }
        [TestMethod]
        public void TestFindPose()
        {
            DynamicPoseHashmap hashmap = new();
            Assert.IsFalse(hashmap.FindPose(DynamicPoseHashmap.INCREASE_PER_STEP, out byte result));
            Assert.AreEqual(result, DynamicPoseHashmap.INCREASE_PER_STEP);
            hashmap.Add(0, new(0, 0, 0));
            Assert.IsFalse(hashmap.FindPose(DynamicPoseHashmap.INCREASE_PER_STEP, out result));
            Assert.AreEqual(result, DynamicPoseHashmap.INCREASE_PER_STEP);
            for (int i = 0; i < 5; i++)
            {
                hashmap.Add((byte)(((i + 1) * DynamicPoseHashmap.INCREASE_PER_STEP) % DynamicPoseHashmap.HASHMAP_SIZE),
                            new((ushort)((i * DynamicPoseHashmap.HASHMAP_SIZE) + DynamicPoseHashmap.INCREASE_PER_STEP),
                            (byte)(i * 2), 0));
            }
            Assert.AreEqual(hashmap.Length, 6);
            Assert.AreEqual(hashmap.GetHashSize(DynamicPoseHashmap.INCREASE_PER_STEP), 5);
            Assert.IsTrue(hashmap.FindPose(DynamicPoseHashmap.INCREASE_PER_STEP, out result));
            Assert.AreEqual(result, DynamicPoseHashmap.INCREASE_PER_STEP);
            Assert.IsTrue(hashmap.FindPose(DynamicPoseHashmap.INCREASE_PER_STEP + (1 * DynamicPoseHashmap.HASHMAP_SIZE), out result));
            Assert.AreEqual(result, DynamicPoseHashmap.INCREASE_PER_STEP * 2);
            Assert.IsTrue(hashmap.FindPose(DynamicPoseHashmap.INCREASE_PER_STEP + (2 * DynamicPoseHashmap.HASHMAP_SIZE), out result));
            Assert.AreEqual(result, DynamicPoseHashmap.INCREASE_PER_STEP * 3);
            Assert.IsTrue(hashmap.FindPose(DynamicPoseHashmap.INCREASE_PER_STEP + (3 * DynamicPoseHashmap.HASHMAP_SIZE), out result));
            Assert.AreEqual(result, DynamicPoseHashmap.INCREASE_PER_STEP * 4);
            Assert.IsTrue(hashmap.FindPose(DynamicPoseHashmap.INCREASE_PER_STEP + (4 * DynamicPoseHashmap.HASHMAP_SIZE), out result));
            Assert.AreEqual(result, DynamicPoseHashmap.INCREASE_PER_STEP * 5);
            Assert.IsFalse(hashmap.FindPose(DynamicPoseHashmap.INCREASE_PER_STEP + (5 * DynamicPoseHashmap.HASHMAP_SIZE), out result));
            Assert.AreEqual(result, DynamicPoseHashmap.INCREASE_PER_STEP * 6);
        }
    }
}