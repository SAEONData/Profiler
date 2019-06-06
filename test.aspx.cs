using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class test : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["polyurl"] != null)
            {
                using (WebClient client = new WebClient())
                {
                    String poly = client.DownloadString(Request["polyurl"]);

                    Response.Write(poly);
                }
            }

        }
    }
}