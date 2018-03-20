using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class map : System.Web.UI.Page
    {
        public string id = "";
        public string v1 = "";
        public string v2 = "";

        public GSFeature feature = null;
        public dynamic ideas;
        public ProfVar var1 = null;
        public ProfVar var2 = null;

        public int regionID = 0;
        public string features = "[]";


        public string truncate(String text)
        {
            int max = 35;
            if (text.Length > max)
            {
                text = text.Substring(0, max) + "...";
            }
            return text;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            id = Request["id"];
            v1 = Request["v1"];
            v2 = Request["v2"];

            GSTool gs = new GSTool(Context);
            feature = gs.GetFeatureDB(Context, int.Parse(id));


            MMTools mm = new MMTools(Context);
            string region = mm.GetRegionName(int.Parse(id));
            regionID = mm.GetRegionID(region);
            if (regionID != 0)
            {
                String featureURL = "http://app01.saeon.ac.za/nccrdapi/api/Projects/GEO/GetAll?regionId=" + regionID;
                using (WebClient wc = new WebClient())
                {
                    features = wc.DownloadString(featureURL);
                }
            }

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