using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class getpoly : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int id = int.Parse(Request["id"]);
            GSTool gs = new GSTool(Context);
            var feature = gs.GetFeatureDB(Context, id);
            Response.Write(feature.wkt);

            //           Response.Write(Server.UrlEncode("http://app01.saeon.ac.za/profiler/getpoly.aspx?id=21"));

            // 

            

        }
    }
}