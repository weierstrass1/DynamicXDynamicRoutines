using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DynamicXDynamicRoutinesLibrary
{
    public class VRAMMap
    {
        public const byte VRAMMAP_SIZE = 128;
        public int SpaceCount { get; private set; } = 1;
        private readonly VRAMMapSlot[] slots;
        public required DynamicPoseHashmap Hashmap { get; init; }
        public required DynamicPoseDataBase PoseDataBase { get; init; }
        public VRAMMap() 
        {
            slots = new VRAMMapSlot[VRAMMAP_SIZE];
            for (int i  = 0; i < slots.Length; i++)
            {
                slots[i] = new()
                {
                    SizeOrPose = 0xFF,
                    Offset = 0
                };
            }
        }
        public Space GetBestSlot(byte size, ushort TimeSpan)
        {
            Space current = new();
            Space best = new();
            bool adjacent = false;
            for (byte i = VRAMMAP_SIZE - 1; i < VRAMMAP_SIZE; i = (byte)(current.Offset - 1))
            {
                if (checkSpace(i, size, ref adjacent, current, TimeSpan))
                    checkIfCurrentIsBest(size, ref adjacent, current, best);
            }
            return best;
        }
        private bool checkSpace(byte i, byte size, ref bool adjacent, Space current, ushort TimeSpan)
        {
            VRAMMapSlot slot = slots[i];
            current.Offset = (byte)(slot.Offset & 0x7F);
            if (slot.IsRestricted)
            {
                adjacent = false;
                return false;
            }
            byte slotSize = slot.GetSize(PoseDataBase, Hashmap);
            byte score = slot.GetScore(TimeSpan, Hashmap);
            if(adjacent)
            {
                slotSize += current.Size;
                score = Math.Min(score, current.Score);
            }
            current.Size = slotSize;
            current.Score = score;
            if(score < 2)
            {
                adjacent = false;
                return false;
            }
            if (slotSize < size)
                adjacent = true;
            return true;
        }
        private bool checkIfCurrentIsBest(byte size, ref bool adjacent, Space current, Space best)
        {
            if (current.Size < size)
                return false;
            adjacent = false;
            if (current.Score < best.Score)
                return false;
            if (current.Score == best.Score && current.Size >= best.Size)
                return false;
            best.Offset = current.Offset;
            best.Size = current.Size;
            best.Score = current.Score;
            return true;
        }
        public void RemovePosesInSpace(Space space)
        {
            byte limit = (byte)(space.Offset + space.Size);
            VRAMMapSlot slot;
            byte size;
            for (byte i = space.Offset; i < limit; i += size) 
            {
                slot = slots[i];
                size = slot.GetSize(PoseDataBase, Hashmap);
                if (!slot.IsFree)
                    Hashmap.Remove(slot.SizeOrPose);
            }
        }
        public void RemoveSpace(Space space)
        {
            RemovePosesInSpace(space);
            var slot = slots[space.Offset];
            slot.Offset = space.Offset;
            slot.SizeOrPose = (byte)((space.Size - 1) | 0x80);

            slot = slots[space.Offset + space.Size - 1];
            slot.Offset = space.Offset;
            slot.SizeOrPose = (byte)((space.Size - 1) | 0x80);
        }
        public void AddPoseInSpace(byte hashmapIndex, Space space)
        {
            var slot = slots[space.Offset];
            slot.SizeOrPose = hashmapIndex;
            slot.Offset = space.Offset;

            byte nextSlotIndex = (byte)(space.Offset + slot.GetSize(PoseDataBase, Hashmap));
            slot = slots[nextSlotIndex - 1];
            slot.SizeOrPose = hashmapIndex;
            slot.Offset = space.Offset;

            byte size = (byte)(nextSlotIndex - space.Offset);
            if (size == space.Size)
                return;
            size = (byte)((space.Size - size - 1) | 0x80);
            slot = slots[nextSlotIndex];
            slot.SizeOrPose = size;
            slot.Offset = nextSlotIndex;

            slot = slots[nextSlotIndex + (size & 0x7F)];
            slot.SizeOrPose = size;
            slot.Offset = nextSlotIndex;
        }
        public VRAMMapSlot Get(byte slotIndex)
            => slots[slotIndex];
    }
    public record Space
    {
        public byte Size = 0;
        public byte Offset = 0xFF;
        public byte Score = 0;
    }
}
