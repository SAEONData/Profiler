using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class prof : System.Web.UI.Page
    {
        public string v1 = "";
        public string v2 = "";
        
        public dynamic ideas;
        public ProfVar var1 = null;
        public ProfVar var2 = null;

        public string chartFrameSrc = "";
        public int regionID = 0;


        protected void Page_Load(object sender, EventArgs e)
        {
            int id = int.Parse(Request["id"]);
            MMTools mm = new MMTools(Context);
            string region = mm.GetRegionName(id);
            regionID = mm.GetRegionID(region);

            v1 = Request["v1"];
            v2 = Request["v2"];


            chartFrameSrc = "chart.aspx?id=" + Request["id"] + "&v1=" + v1 + "&v2=" + v2;
            

            dynamic ideas = mm.ReadIdeas(Context);

            if (v1 != null && v1 != "")
            {
                var1 = mm.GetVariable(ideas, v1, Context);
                if (var1 == null)
                {
                    Response.End();
                    return;
                }
            }

            if (v2 != null && v2 != "")
            {
                chartFrameSrc = "loading.aspx";
                var2 = mm.GetVariable(ideas, v2, Context);
                if (var2 == null)
                {
                    Response.End();
                    return;
                }
            }



        }



    }

}