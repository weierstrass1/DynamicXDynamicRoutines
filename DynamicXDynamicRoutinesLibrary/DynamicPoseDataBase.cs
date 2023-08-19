using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace DynamicXDynamicRoutinesLibrary
{
    public class DynamicPoseDataBase
    {
        public ushort Length { get => (ushort)poses.Length; }
        private DynamicPose[] poses = new DynamicPose[0];
        public DynamicPose Get(ushort id)
            => poses[id];
        public void ReadData(string filepath)
        {
            string content = File.ReadAllText(filepath);

            Match msizes = Regex.Match(content, @"PoseSize:\s*\n(\s*dw\s\$[a-zA-Z0-9]{4}(,\$[a-zA-Z0-9]{4})*\s*(\n|$))+");
            Match mblocks = Regex.Match(content, @"Pose16x16Blocks:\s*\n(\s*db\s\$[a-zA-Z0-9]{2}(,\$[a-zA-Z0-9]{2})*\s*(\n|$))+");
            Match mres = Regex.Match(content, @"PoseResource:\s*\n(\s*dl\s\$[a-zA-Z0-9]{6}(,\$[a-zA-Z0-9]{6})*\s*(\n|$))+");
            Match msizePerLine = Regex.Match(content, @"PoseResourceSizePerLine:\s*\n(\s*dw\s\$[a-zA-Z0-9]{4},\$[a-zA-Z0-9]{4}\s*(\n|$))+");
            Match moffset = Regex.Match(content, @"PoseSize:\s*\n(\s*dw\s\$[a-zA-Z0-9]{4}(,\$[a-zA-Z0-9]{4})*\s*(\n|$))+");
            Regex mnumber = new(@"\$[a-zA-Z0-9]*");
            MatchCollection sizes = mnumber.Matches(msizes.Value);
            MatchCollection blocks = mnumber.Matches(mblocks.Value);
            MatchCollection res = mnumber.Matches(mres.Value);
            MatchCollection sizePerLine = mnumber.Matches(msizePerLine.Value);
            MatchCollection offset = mnumber.Matches(moffset.Value);

            poses = new DynamicPose[sizes.Count];

            for (int i = 0; i < poses.Length; i++) 
            {
                poses[i] = new()
                {
                    ID = (ushort)i,
                    Size = ushort.Parse(sizes[i].Value[1..], NumberStyles.HexNumber),
                    Blocks16x16 = byte.Parse(blocks[i].Value[1..], NumberStyles.HexNumber),
                    Resource = uint.Parse(res[i].Value[1..], NumberStyles.HexNumber),
                    SizePerLine1 = ushort.Parse(sizePerLine[i * 2].Value[1..], NumberStyles.HexNumber),
                    SizePerLine2 = ushort.Parse(sizePerLine[(i * 2) + 1].Value[1..], NumberStyles.HexNumber),
                    SecondLineOffset = ushort.Parse(offset[i].Value[1..], NumberStyles.HexNumber),
                };
            }
        }
    }
}
