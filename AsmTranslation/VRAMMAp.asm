;        public void AddPoseInSpace(byte hashmapIndex, Space space)
;        {
;            var slot = slots[space.Offset];
;            slot.SizeOrPose = hashmapIndex;
;            slot.Offset = space.Offset;
;
;            byte nextSlotIndex = (byte)(space.Offset + slot.GetSize(PoseDataBase, Hashmap));
;            slot = slots[nextSlotIndex - 1];
;            slot.SizeOrPose = hashmapIndex;
;            slot.Offset = space.Offset;
;
;            byte size = (byte)(nextSlotIndex - space.Offset);
;            if (size == space.Size)
;                return;
;            size = (byte)((space.Size - size - 1) | 0x80);
;            slot = slots[nextSlotIndex];
;            slot.SizeOrPose = size;
;            slot.Offset = nextSlotIndex;
;
;            slot = slots[nextSlotIndex + (size & 0x7F)];
;            slot.SizeOrPose = size;
;            slot.Offset = nextSlotIndex;
;        }