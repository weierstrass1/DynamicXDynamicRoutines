using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DynamicXDynamicRoutinesLibrary
{
    public class DynamicXSystem
    {
        public ushort TimeSpan { get; private set; } = 0;
        public ushort CurrentDataSent { get; private set; } = 0;
        public ushort MaximumDataPerFrame = 0x800;
        public required DynamicPoseDataBase PoseDataBase { get; init; }
        public required DynamicPoseHashmap Hashmap { get; init; }
        public required VRAMMap VRAMMap { get; init; }
        public bool TakeDynamicRequest(ushort id)
        {
            if (Hashmap.FindPose(id, out byte hashmapindex))
                return true;
            DynamicPose pose = PoseDataBase.Get(id);
            ushort currentDataSent = (ushort)(pose.Size + CurrentDataSent);
            if (currentDataSent > MaximumDataPerFrame)
                return false;
            Space bestSpace = VRAMMap.GetBestSlot(pose.Blocks16x16, TimeSpan);
            if (bestSpace.Offset == 0xFF)
                return false;
            VRAMMap.RemoveSpace(bestSpace);
            Hashmap.FindFreeSpace(ref hashmapindex);
            CurrentDataSent = currentDataSent;
            Hashmap.Add(hashmapindex, new(pose.ID, bestSpace.Offset, TimeSpan));
            VRAMMap.AddPoseInSpace(hashmapindex, bestSpace);
            return true;
        }
        public void UpdateTimeSpan()
            => TimeSpan++;
        public void ResetCurrentDataSent()
            => CurrentDataSent = 0;
    }
}
