using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class spread : System.Web.UI.Page
    {
        public int colMax = 30;
        public int rowMax = 500;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void WriteGrid()
        {
            String cl = "";
            String output = "";


            for (int r = 0; r < rowMax; r++)
            {
                // headers
                cl = r < rowMax - 1 ? "lt" : "ltb";

                output += "<tr>";
                for (int c = 0; c < colMax; c++)
                {
                    String id = String.Format("{0}_{1}", c + 1, r + 1);
                    String text = "";
                    if (c == colMax - 1)
                        cl += "r";

                    output += "<td id='" + id + "' class='" + cl + "'>" + text + "</td>";
                }
                output += "</tr>";
            }

            Response.Write(output);
        }
    }
}