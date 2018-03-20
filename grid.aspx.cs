using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class grid : System.Web.UI.Page
    {
        public string id = "";
        public string file = "";
        public string rootStock = "";
        public string rootDriver = "";
        public GSFeature feature = null;

        public int rot = 2;

        protected void LoadSelection()
        {
            using (SqlConnection con = new SqlConnection(dbsource.main))
            {
                con.Open();

                GridTools gt = new GridTools(con, Context);
                int featureID = int.Parse(Request["fid"]);
                int i1 = gt.GetIndicatorID(Request["i1"]);
                int i2 = gt.GetIndicatorID(Request["i2"]);
                int gridID = gt.GetGridID(featureID, i1, i2);
                double total = 0;
                bool valFound = false;
                String query = "SELECT * FROM TblSelection WHERE fGridRef = @fGridRef";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@fGridRef", gridID);
                    using (SqlDataReader set = cmd.ExecuteReader())
                    {
                        while (set.Read() == true)
                        {
                            double val = (double)set["fValue"];
                            total += val;
                            valFound = true;
                        }
                    }
                }

                if (valFound == true)
                {
                    ColorRamp ramp = new ColorRamp();
                    ramp.Load(Server.MapPath("images/ramp.png"));
                    String color = ramp.GetColor(total / 100);
                    Response.Write(Request["id"] + "|" + Math.Round(total) + "|" + color);
                }
                else
                {
                    Response.Write(Request["id"] + "|" + "0" + "|" + "#ffffff");
                }


            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            String mode = Request["mode"];
            if (mode != null && mode != "")
            {
                if (mode == "loadSel")
                    LoadSelection();

                Response.End();
                return;
            }
            
            id = Request["id"];

            GSTool gs = new GSTool(Context);
            feature = gs.GetFeatureDB(Context, int.Parse(id));

            MMTools tool = new MMTools(Context);
            file = tool.file;
            rootStock = tool.rootStock;
            rootDriver = tool.rootDriver;

            if (Request["rot"] != null && Request["rot"] != "")
                rot = int.Parse(Request["rot"]);

        }
    }
}