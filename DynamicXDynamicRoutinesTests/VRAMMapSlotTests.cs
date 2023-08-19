using DynamicXDynamicRoutinesLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace DynamicXDynamicRoutinesTests
{
    [TestClass]
    public class VRAMMapSlotTests
    {
        [TestMethod]
        public void TestIsRestricted()
        {
            VRAMMapSlot slot = new()
            {
                Offset = 0,
                SizeOrPose = 0,
            };
            Assert.IsFalse(slot.IsRestricted);
            slot = new()
            {
                Offset = 0x80,
                SizeOrPose = 0,
            };
            Assert.IsTrue(slot.IsRestricted);
        }
        [TestMethod]
        public void TestIsFree()
        {
            VRAMMapSlot slot = new()
            {
                Offset = 0,
                SizeOrPose = 0,
            };
            Assert.IsFalse(slot.IsFree);
            slot = new()
            {
                Offset = 0,
                SizeOrPose = 0x80,
            };
            Assert.IsTrue(slot.IsFree);
        }
        [TestMethod]
        public void TestGetSize()
        {
            VRAMMapSlot slot = new()
            {
                Offset = 0,
                SizeOrPose = 0,
            };
            DynamicPoseDataBase poseDataBase = new();
            poseDataBase.ReadData(Path.Combine("TestData", "Data.asm"));
            DynamicPoseHashmap hashmap = new();
            hashmap.Add(0, new(0, 0, 0));
            Assert.AreEqual(slot.GetSize(poseDataBase, hashmap), 1);
            slot = new()
            {
                Offset = 0,
                SizeOrPose = 0x85,
            };
            Assert.AreEqual(slot.GetSize(poseDataBase, hashmap), 6);
        }
        [TestMethod]
        public void TestGetScore()
        {
            DynamicPoseHashmap hashmap = new();
            hashmap.Add(0, new(0, 0, 5));
            VRAMMapSlot slot = new()
            {
                Offset = 0,
                SizeOrPose = 0,
            };
            Assert.AreEqual(slot.GetScore(10, hashmap), 5);
            Assert.AreEqual(slot.GetScore(1000, hashmap), 0xFE);
            slot = new()
            {
                Offset = 0,
                SizeOrPose = 0x80,
            };
            Assert.AreEqual(slot.GetScore(10, hashmap), 0xFF);
            Assert.AreEqual(slot.GetScore(1000, hashmap), 0xFF);
        }
    }
}
