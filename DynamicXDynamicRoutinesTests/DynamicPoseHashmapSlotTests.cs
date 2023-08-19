using DynamicXDynamicRoutinesLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DynamicXDynamicRoutinesTests
{
    [TestClass]
    public class DynamicPoseHashmapSlotTests
    {
        [TestMethod]
        public void TestGetHashCode()
        {
            byte result = DynamicPoseHashMapSlot.GetHashCode(0x185);
            Assert.AreEqual(5, result);
        }
    }
}
