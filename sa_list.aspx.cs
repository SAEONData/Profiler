using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class sa_list : System.Web.UI.Page
    {
        public GSTool gstool = null;
        public GSSource source = null;


        protected void Page_Load(object sender, EventArgs e)
        {
            gstool = new GSTool(Context);

            if (Request["mode"] == "list")
            {
                Response.Write(gstool.Filter(Context, Request["source"], Request["text"]));
                Response.End();
            }

            if (Request["mode"] == "getfeature")
            {
                int id = gstool.GetFeature(Context, Request["source"], Request["id"]);
                GSFeature feature = gstool.GetFeatureDB(Context, id);
                Response.Write(id.ToString() + "|" + feature.name);
                Response.End();
            }

            if (Request["mode"] == "getSources")
            {
                String name = Request["fid"];
                foreach (GSGroup group in gstool.groups)
                {
                    if (group.name == name)
                    {
                        foreach (GSSource source in group.sources)
                        {
                            Response.Write("<option>" + source.name + "</option>");
                        }
                    }
                }
                Response.End();

            }
        }
    }
}