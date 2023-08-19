using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DynamicXDynamicRoutinesLibrary
{
    public class DynamicPoseHashMapSlot
    {
        public ushort ID { get; init; }
        public byte Offset { get; init; }
        public ushort TimeLastUse { get; private set; }
        public DynamicPoseHashMapSlot(ushort id, byte offset, ushort timeLastUse)
        {
            ID = id;
            Offset = offset;
            TimeLastUse = timeLastUse;
        }
        public static byte GetHashCode(ushort ID)
            => (byte)(ID % DynamicPoseHashmap.HASHMAP_SIZE);
        public void UpdateTimeLastUse(DynamicXSystem system)
        {
            TimeLastUse = system.TimeSpan;
        }
    }
}
