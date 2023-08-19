using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Formats.Asn1.AsnWriter;

namespace DynamicXDynamicRoutinesLibrary
{
    public class VRAMMapSlot
    {
        public bool IsRestricted { get => (Offset & 0x80) == 0x80; }
        public bool IsFree { get => (SizeOrPose & 0x80) == 0x80; }
        public byte SizeOrPose;
        public byte Offset;
        public byte GetSize(DynamicPoseDataBase poseDataBase, DynamicPoseHashmap hashmap)
        {
            if (IsFree)
                return (byte)((SizeOrPose & 0x7F) + 1);
            DynamicPoseHashMapSlot poseslot = hashmap.Get(SizeOrPose);
            return poseDataBase.Get(poseslot.ID).Blocks16x16;
        }
        public byte GetScore(ushort TimeSpan, DynamicPoseHashmap Hashmap)
        {
            if (IsFree)
                return 0xFF;
            return (byte)Math.Min(TimeSpan - Hashmap.Get(SizeOrPose).TimeLastUse, 0xFE);
        }
    }
}
