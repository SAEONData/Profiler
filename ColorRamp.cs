using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;

namespace profiler
{
    public class ColorRamp
    {
        public void Load(String file)
        {
            using (Bitmap bmp = new Bitmap(file))
            {
                for (int x = 0; x < bmp.Width; x++)
                {
                    colors.Add(bmp.GetPixel(x, 2));
                }
            }
        }

        public String GetColor(double f)
        {
            double count = colors.Count;
            int index = (int)(f * count);
            if (index < 0)
                index = 0;
            if (index > colors.Count - 1)
                index = colors.Count - 1;
            Color c = colors[index];

            return ToWebString(c).ToLower();


        }

        String ToWebString(Color c)
        {
            return "#" + c.R.ToString("X2") + c.G.ToString("X2") + c.B.ToString("X2");

        }


        private List<Color> colors = new List<Color>();
    }
}