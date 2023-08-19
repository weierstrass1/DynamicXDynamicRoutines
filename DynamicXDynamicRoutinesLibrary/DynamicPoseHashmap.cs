using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DynamicXDynamicRoutinesLibrary
{
    public class DynamicPoseHashmap
    {
        public const byte HASHMAP_SIZE = 128;
        public const byte INCREASE_PER_STEP = 15;
        public byte Length { get; private set; } = 0;
        private byte[] hashSize = new byte[HASHMAP_SIZE];
        private DynamicPoseHashMapSlot?[] slots;
        public DynamicPoseHashmap()
        {
            slots = new DynamicPoseHashMapSlot?[HASHMAP_SIZE];
            hashSize = new byte[HASHMAP_SIZE];
            for (int i = 0; i < HASHMAP_SIZE; i++)
            {
                slots[i] = null;
                hashSize[i] = 0;
            }
        }
        public bool FindPose(ushort id, out byte result)
        {
            byte hashCode = DynamicPoseHashMapSlot.GetHashCode(id);
            result = hashCode;
            if (Length == 0) 
                return false;
            ushort i = hashSize[hashCode];
            if (i == 0) 
                return false;
            DynamicPoseHashMapSlot? slot;
            for (; i > 0; result = (byte)((result + INCREASE_PER_STEP) % HASHMAP_SIZE)) 
            {
                slot = slots[result];
                if (slot is null)
                    continue;
                if (slot.ID == id)
                    return true;
                if (DynamicPoseHashMapSlot.GetHashCode(slot.ID) != hashCode)
                    continue;
                i--;
            }
            return false;
        }
        public bool FindFreeSpace(ref byte hashmapIndex)
        {
            if (Length == HASHMAP_SIZE)
                return false;
            for (; slots[hashmapIndex] is not null; hashmapIndex = (byte)((hashmapIndex + INCREASE_PER_STEP) % HASHMAP_SIZE)) ;
            return true;
        }
        public void Add(byte hashmapIndex, DynamicPoseHashMapSlot slot)
        {
            if (slots[hashmapIndex] is not null)
                throw new Exception("Slot is Already used");
            slots[hashmapIndex] = slot;
            Length++;
            hashSize[DynamicPoseHashMapSlot.GetHashCode(slot.ID)]++;
        }
        public void Remove(byte hashmapIndex)
        {
            DynamicPoseHashMapSlot? slot = slots[hashmapIndex];
            if (slot is null)
                throw new Exception("Slot is Empty");
            slots[hashmapIndex] = null;
            Length--;
            hashSize[DynamicPoseHashMapSlot.GetHashCode(slot.ID)]--;
        }
        public DynamicPoseHashMapSlot Get(byte hashmapIndex)
        {
            DynamicPoseHashMapSlot? slot = slots[hashmapIndex];
            if (slot is null)
                throw new Exception("Slot not Found");
            return slot;
        }
        public byte GetHashSize(byte hashmapIndex)
            => hashSize[hashmapIndex];
    }
}
