using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Net;
using System.Web.Script.Serialization;

namespace profiler
{
    public partial class frame_ma : System.Web.UI.Page
    {
        public int regionID = 0;
        public string results = "";
        public dynamic records;

        protected void Page_Load(object sender, EventArgs e)
        {
            int id = int.Parse(Request["id"]);

            MMTools mm = new MMTools(Context);
            string region = mm.GetRegionName(id);
            regionID = mm.GetRegionID(region);

            String url = "http://app01.saeon.ac.za/nccrdapi/api/projects/GetAllFiltered?titlePart=&statusId=0&sectorId=0&typologyId=0&regionId=" + regionID;
            using (WebClient wc = new WebClient())
            {
                results = wc.DownloadString(url);
                JavaScriptSerializer js = new JavaScriptSerializer();
                records = js.DeserializeObject(results);



            }

        }

    }
}