using DynamicXDynamicRoutinesLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DynamicXDynamicRoutinesTests
{
    [TestClass]
    public class DynamicXSystemTests
    {
        [TestMethod]
        public void TestTakeDynamicRequest()
        {
            Random r = new Random(0);
            DynamicPoseHashmap hashmap = new();
            DynamicPoseDataBase poseDataBase = new();
            poseDataBase.ReadData(Path.Combine("TestData", "HeavyTest.asm"));
            VRAMMap vramMap = new()
            {
                Hashmap = hashmap,
                PoseDataBase = poseDataBase
            };
            DynamicXSystem dynamicXSystem = new()
            {
                Hashmap = hashmap,
                PoseDataBase = poseDataBase,
                VRAMMap = vramMap
            };
            
            List<SpriteSim> spriteSimList = new();
            List<SpriteSim> cleaner = new();
            double rand;
            StringBuilder sb = new();
            int j, size;
            for (int i = 0; i < 100000; i++)
            {
                sb.AppendLine($"Iteration {i}");
                rand = r.NextDouble();
                while (spriteSimList.Count < 22 && rand < 0.5)
                {
                    spriteSimList.Add(new(dynamicXSystem, r));
                    sb.AppendLine($"\tAdded Sprite {spriteSimList.Last().ID} - Total sprites {spriteSimList.Count}");
                    rand = r.NextDouble();
                }
                sb.AppendLine();
                cleaner.Clear();
                foreach (var spriteSim in spriteSimList)
                {
                    if(i == 30 && spriteSim.ID == 19)
                    {
                        int a = 0;
                    }
                    if (spriteSim.PoseID != spriteSim.LastPoseID)
                    {
                        sb.AppendLine($"\tSprite {spriteSim.ID}: {spriteSim}");
                        sb.AppendLine($"\t\tCurrent Data: {dynamicXSystem.CurrentDataSent:X4} - Required: {(poseDataBase.Get(spriteSim.PoseID).Size + dynamicXSystem.CurrentDataSent):X4} - Maximum: {dynamicXSystem.MaximumDataPerFrame:X4}");
                    }
                    spriteSim.Upload();
                    if (spriteSim.PoseID != spriteSim.LastPoseID)
                        sb.AppendLine($"\t\t{(spriteSim.PoseID == spriteSim.LastPoseID ? "Success" : "Failed")}-{spriteSim}");
                    spriteSim.AnimationRoutine();
                    spriteSim.CheckAllIsCorrect();
                    if (spriteSim.SurviveTimer == 0)
                        cleaner.Add(spriteSim);
                }
                sb.AppendLine();
                foreach (var spriteSim in cleaner)
                {
                    spriteSimList.Remove(spriteSim);
                    sb.AppendLine($"\tRemoved Sprite - Total sprites {spriteSimList.Count}");
                }
                ValidateHashmap(hashmap);
                ValidateVRAMMap(vramMap);
                dynamicXSystem.UpdateTimeSpan();
                dynamicXSystem.ResetCurrentDataSent();
                sb.AppendLine();
                sb.AppendLine($"\tSize: {hashmap.Length}");
                for (j = 0; j < DynamicPoseHashmap.HASHMAP_SIZE; j++)
                {
                    size = hashmap.GetHashSize((byte)j);
                    if(size > 0)
                    sb.AppendLine($"\tSize {j}: {size}");
                }
            }
            if (File.Exists("log.txt"))
                File.Delete("log.txt");
            File.WriteAllText("log.txt", sb.ToString());
        }
        public void ValidateHashmap(DynamicPoseHashmap hashmap)
        {
            Dictionary<ushort, int> countDic = new();
            DynamicPoseHashMapSlot? slot = null;
            for (byte i = 0; i < DynamicPoseHashmap.HASHMAP_SIZE; i++)
            {
                try
                {
                    slot = hashmap.Get(i);
                }
                catch
                {
                    slot = null;
                }
                finally
                {
                    if (slot != null)
                    {
                        if(!countDic.ContainsKey(slot.ID))
                            countDic.Add(slot.ID, 0);
                        countDic[slot.ID]++;
                    }
                }
            }
            foreach (var kvp in countDic)
                Assert.IsTrue(kvp.Value < 2);
        }
        public void ValidateVRAMMap(VRAMMap vramMap)
        {
            VRAMMapSlot slot0, slot1;
            byte size;
            bool check = false;
            DynamicPoseHashMapSlot hashmapSlot;
            for (byte i = VRAMMap.VRAMMAP_SIZE - 1; i < VRAMMap.VRAMMAP_SIZE; i = (byte)(slot0.Offset - 1))
            {
                slot0 = vramMap.Get(i);
                slot1 = vramMap.Get(slot0.Offset);
                Assert.AreEqual(slot0.Offset, slot1.Offset);
                Assert.AreEqual(slot0.SizeOrPose, slot1.SizeOrPose);
                size = slot0.GetSize(vramMap.PoseDataBase, vramMap.Hashmap);
                Assert.AreEqual(i - slot0.Offset + 1, size);
                if(!slot0.IsFree)
                {
                    hashmapSlot = vramMap.Hashmap.Get(slot0.SizeOrPose);
                    Assert.AreEqual(hashmapSlot.Offset, slot0.Offset);
                }
                if (slot0.Offset == 0)
                {
                    check = true;
                    break;
                }
            }
            Assert.IsTrue(check);
        }
    }
    public class SpriteSim
    {
        private static int id = 0;
        public int ID { get; init; }
        public ushort SafeFrame;
        public ushort PoseID;
        public ushort LastPoseID;
        public byte LastPoseHashID;
        public byte GlobalFlip;
        public byte LocalFlip;
        public byte LastFlip;
        public byte AnimationTimer;
        public int SurviveTimer { get; private set; }
        public DynamicXSystem System { get; init; }
        public Random Random { get; init; }
        public SpriteSim(DynamicXSystem system, Random random)
        {
            ID = id;
            id++;
            Random = random;
            System = system;
            SurviveTimer = Random.Next(100);
            SafeFrame = System.TimeSpan;
            PoseID = (ushort)Random.Next(System.PoseDataBase.Length);
            LastPoseID = 0xFFFF;
            LastPoseHashID = 0xFF;
            GlobalFlip = (byte)Random.Next(4);
            LocalFlip = (byte)Random.Next(4);
            LastFlip = (byte)(GlobalFlip ^ LocalFlip);
            AnimationTimer = (byte)Random.Next(16);
        }
        public bool Upload()
        {
            if (SafeFrame == System.TimeSpan)
                return uploadResult();
            SafeFrame = System.TimeSpan;
            if (PoseID == LastPoseID || !System.TakeDynamicRequest(PoseID))
                return uploadResult();
            LastPoseID = PoseID;
            System.Hashmap.FindPose(PoseID, out LastPoseHashID);
            LastFlip = (byte)(GlobalFlip ^ LocalFlip);
            return uploadResult();
        }
        private bool uploadResult()
        {
            if (LastPoseHashID == 0xFF)
                return false;
            System.Hashmap.Get(LastPoseHashID).UpdateTimeLastUse(System);
            return true;
        }
        public void AnimationRoutine()
        {
            SurviveTimer--;
            if (SurviveTimer < 0)
                SurviveTimer = 0;
            if (AnimationTimer > 0)
            {
                AnimationTimer--;
                return;
            }
            AnimationTimer = (byte)Random.Next(16);
            PoseID = (ushort)Random.Next(System.PoseDataBase.Length);
            GlobalFlip = (byte)Random.Next(4);
            LocalFlip = (byte)Random.Next(4);
        }
        public void CheckAllIsCorrect()
        {
            if (LastPoseHashID == 0xFF)
                return;
            var hashmapSlot = System.Hashmap.Get(LastPoseHashID);
            Assert.AreEqual(hashmapSlot.ID, LastPoseID);
            var pose = System.PoseDataBase.Get(LastPoseID);
            var vramSlot0 = System.VRAMMap.Get(hashmapSlot.Offset);
            var vramSlot1 = System.VRAMMap.Get((byte)(hashmapSlot.Offset + pose.Blocks16x16 - 1));
            Assert.AreEqual(vramSlot0.Offset, vramSlot1.Offset);
            Assert.AreEqual(vramSlot0.SizeOrPose, vramSlot1.SizeOrPose);
            Assert.AreEqual(vramSlot0.SizeOrPose, LastPoseHashID);
            Assert.AreEqual(hashmapSlot.TimeLastUse, System.TimeSpan);
        }
        public override string ToString()
            => $"({PoseID},{LastPoseID},{LastPoseHashID},{SafeFrame})";
    }
}
