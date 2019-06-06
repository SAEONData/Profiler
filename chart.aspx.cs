using GeoAPI.Geometries;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace profiler
{
    public partial class chart : System.Web.UI.Page
    {
        public string id = "";
        public string v = "";
        public string v1 = "";
        public string v2 = "";
        public GSFeature feature = null;

        public dynamic ideas;
        public ProfVar var1 = null;
        public ProfVar var2 = null;


        public Bitmap bmp1 = null;
        public Bitmap bmp2 = null;
        public Bitmap mask = null;

        public String file_mask = "";
        public String file_v1 = "";
        public String file_v2 = "";

        public double selectedValue = -1;
        public string selectedColor = "";
        
        

        int bmpx = 500;
        int bmpy = 500;
        public int gridID = 0;

        String wkt = "";

        public ColorRamp ramp;
        public List<GridSel> gridSelection = new List<GridSel>();


        private void SaveSelection()
        {
            int gridID = int.Parse(Request["grid"]);
            string col1 = Request["c1"];
            string col2 = Request["c2"];
            double value = double.Parse(Request["val"]);
            bool selected = Request["sel"] == "true";

            string sql = selected ? "INSERT INTO TblSelection (fGridRef, fColor1, fColor2, fValue) VALUES (@fGridRef, @fColor1, @fColor2, @fValue)" : "DELETE FROM TblSelection WHERE fGridRef=@fGridRef AND fColor1=@fColor1 AND fColor2=@fColor2";
            using (SqlConnection con = new SqlConnection(dbsource.main))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@fGridRef", gridID);
                    cmd.Parameters.AddWithValue("@fColor1", col1);
                    cmd.Parameters.AddWithValue("@fColor2", col2);
                    if (selected)
                        cmd.Parameters.AddWithValue("@fValue", value);
                    cmd.ExecuteNonQuery();
                }


                double total = 0;
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
                        }
                    }
                }

                ColorRamp ramp = new ColorRamp();
                ramp.Load(Server.MapPath("images/ramp.png"));
                String color = ramp.GetColor(total / 100);


                Response.Write(Math.Round(total) + "|" + color);
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            Session.LCID = 1033;

            String mode = Request["mode"];
            if (mode != null && mode != "")
            {
                if (mode == "savesel")
                    SaveSelection();

                Response.End();
                return;
            }


            id = Request["id"];
            v1 = Request["v1"];
            v2 = Request["v2"];

            GSTool gs = new GSTool(Context);
            feature = gs.GetFeatureDB(Context, int.Parse(id));


            if (Request["v"] != null)
                v = Request["v"];

            double x1 = feature.x1;
            double y1 = feature.y1;
            double x2 = feature.x2;
            double y2 = feature.y2;

            ramp = new ColorRamp();
            ramp.Load(Server.MapPath("images/ramp.png"));

            CMapRect maprect = new CMapRect(x1, y1, x2, y2);
            CScreenRect scrrect = new CScreenRect(0, 0, bmpx, bmpy);
            CZoom zoom = new CZoom();
            zoom.ZoomToFullExtent(maprect, scrrect);

            wkt = feature.wkt;
            mask = new Bitmap(bmpx, bmpy);
            using (Graphics gr = Graphics.FromImage(mask))
            {
                Brush white = new SolidBrush(Color.White);
                Brush black = new SolidBrush(Color.Black);
                gr.FillRectangle(white, new Rectangle(0, 0, bmpx, bmpy));

                string wkt1 = wkt;
                wkt1 = wkt1.Replace("POLYGON((", "");
                wkt1 = wkt1.Replace("))", "");
                wkt1 = wkt1.Replace("), (", "|");

                GraphicsPath path = new GraphicsPath();

                String[] parts = wkt1.Split('|');
                foreach (String part in parts)
                {
                    String[] coords = part.Split(',');
                    List<Point> pointArray = new List<Point>();

                    foreach (String coord in coords)
                    {
                        String[] xy = coord.Trim().Split(' ');
                        double mx = double.Parse(xy[0].Trim(), CultureInfo.InvariantCulture);
                        double my = double.Parse(xy[1].Trim(), CultureInfo.InvariantCulture);
                        int sx = 0;
                        int sy = 0;
                        zoom.Map2Screen(mx, my, out sx, out sy);
                        pointArray.Add(new Point(sx, sy));
                    }
                    path.AddPolygon(pointArray.ToArray());
                }
                gr.FillPath(black, path);
            }
            String name = "temp/mask_" + Guid.NewGuid().ToString() + ".png";
            String file = Server.MapPath(name);
            mask.Save(file, System.Drawing.Imaging.ImageFormat.Png);
            file_mask = name;


            MMTools mm = new MMTools(Context);
            dynamic ideas = mm.ReadIdeas(Context);

            if (v1 != null && v1 != "")
            {
                var1 = mm.GetVariable(ideas, v1, Context);
                if (var1 == null)
                {
                    Response.End();
                    return;
                }
                ProcessChart(1, var1);
            }

            if (v2 != null && v2 != "")
            {
                var2 = mm.GetVariable(ideas, v2, Context);
                if (var2 == null)
                {
                    Response.End();
                    return;
                }
                ProcessChart(2, var2);
            }

            // normalize
            double dTotalMain1 = 0;
            double dTotalSub1 = 0;
            
            foreach (String key in var1.dicb.Keys)
            {
                MMBucket bucket = var1.dicb[key];
                dTotalMain1 += bucket.count;
                foreach (String sub in bucket.dict.Keys)
                    dTotalSub1 += bucket.dict[sub].count;
            }

            foreach (String key in var1.dicb.Keys)
            {
                MMBucket bucket = var1.dicb[key];
                bucket.count = (bucket.count / dTotalMain1);
                foreach (String sub in bucket.dict.Keys)
                    bucket.dict[sub].count = (bucket.dict[sub].count / dTotalSub1);
            }

            // var 2
            if (var2 != null)
            {
                LoadGrid();

                double dTotalMain2 = 0;
                double dTotalSub2 = 0;
                foreach (String key in var2.dicb.Keys)
                {
                    MMBucket bucket = var2.dicb[key];
                    dTotalMain2 += bucket.count;
                    foreach (String sub in bucket.dict.Keys)
                    {
                        dTotalSub2 += bucket.dict[sub].count;
                    }
                }

                foreach (String key in var2.dicb.Keys)
                {
                    MMBucket bucket = var2.dicb[key];
                    bucket.count = (bucket.count / dTotalMain2);
                    foreach (String sub in bucket.dict.Keys)
                    {
                        bucket.dict[sub].count = (bucket.dict[sub].count / dTotalSub2);
                    }
                }
            }

            // dispose
            if (bmp1 != null)
                bmp1.Dispose();

            if (bmp2 != null)
                bmp2.Dispose();

            if (mask != null)
                mask.Dispose();
        }

        public bool IsSelected(String col1, String col2)
        {
            foreach (GridSel sel in gridSelection)
            {
                if (sel.color1 == col1 && sel.color2 == col2)
                    return true;
            }
            return false;
        }

        public void AddSelection(String col1, String col2, double value)
        {
            using (SqlConnection con = new SqlConnection(dbsource.main))
            {
                con.Open();
                String sql = "INSERT INTO TblSelection (fGridRef, fColor1, fColor2, fValue) VALUES (@fGridRef, @fColor1, @fColor2, @fValue)";
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@fGridRef", gridID);
                    cmd.Parameters.AddWithValue("@fColor1", col1);
                    cmd.Parameters.AddWithValue("@fColor2", col2);
                    cmd.Parameters.AddWithValue("@fValue", value);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        

        public void LoadGrid()
        {
            using (SqlConnection con = new SqlConnection(dbsource.main))
            {
                con.Open();
                GridTools gt = new GridTools(con, Context);
                int featureID = int.Parse(id);
                int i1 = gt.GetIndicatorID(var1.id);
                int i2 = gt.GetIndicatorID(var2.id);
                gridID = gt.GetGridID(featureID, i1, i2);

                String query = "SELECT * FROM TblSelection WHERE fGridRef = @fGridRef";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@fGridRef", gridID);
                    using (SqlDataReader set = cmd.ExecuteReader())
                    {
                        while (set.Read() == true)
                        {
                            GridSel gs = new GridSel();
                            gs.color1 = set["fColor1"].ToString();
                            gs.color2 = set["fColor2"].ToString();
                            gridSelection.Add(gs);
                        }
                    }
                }
            }
        }

        public void ProcessChart(int index, ProfVar var)
        {
            double x1 = feature.x1;
            double y1 = feature.y1;
            double x2 = feature.x2;
            double y2 = feature.y2;

            double mx = x2 - x1;
            double my = y2 - y1;

            String url = var.wmsurl + String.Format("&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&LAYERS={0}&STYLES={1}&TILED=true&WIDTH={6}&HEIGHT={7}&CRS=EPSG:4326&BBOX={2},{3},{4},{5}", var.wmslayers, var.wmsstyles, x1, y1, x2, y2, bmpx, bmpy);

            String name = "temp/" + Guid.NewGuid().ToString() + ".png";
            String file = Server.MapPath(name);
            String col = "";
            if (index == 1)
                file_v1 = name;
            else
                file_v2 = name;




            // IPolygon geom = (IPolygon)GeometryFromWKT.Parse(wkt);

            


            using (WebClient wc = new WebClient())
            {
                try
                {
                    wc.DownloadFile(url, file);
                }
                catch (Exception err)
                {
                    Response.Write("Error: Failed to download '" + url + "':<br>" + err.Message);
                    Response.End();
                    return;
                }
                Bitmap bmp = new Bitmap(file);

                if (index == 1)
                    bmp1 = bmp;
                else
                    bmp2 = bmp;

                for (int y = 0; y < bmpy; y++)
                {

                    double py = y1 + ((double)y / (double)bmpy) * my;
                    for (int x = 0; x < bmpx; x++)
                    {
                        double px = x1 + ((double)x / (double)bmpx) * mx;

                        Color mc = mask.GetPixel(x, y);
                        if (mc.R < 10 && mc.G < 10 && mc.B < 10)
                        {
                            col = ToWebString(bmp.GetPixel(x, y)).ToLower();
                            if (var.dict1.ContainsKey(col))
                            {
                                String value = var.dict1[col];
                                double v = var.dictv.ContainsKey(col) ? var.dictv[col] : 1;

                                MMBucket bucket = var.dicb[value];
                                bucket.count += v;

                                if (index == 2)
                                {
                                    String col1 = ToWebString(bmp1.GetPixel(x, y)).ToLower();
                                    if (var1.dict1.ContainsKey(col1))
                                    {
                                        String value1 = var1.dict1[col1];
                                        MMBucket bucket1 = var1.dicb[value1];
                                        double v1 = var1.dictv.ContainsKey(col1) ? var1.dictv[col1] : 1;


                                        if (bucket1.dict.ContainsKey(value) == false)
                                            bucket1.dict[value] = new MMBucket();
                                        bucket1.dict[value].count += v1;


                                        String col2 = ToWebString(bmp2.GetPixel(x, y)).ToLower();
                                        if (var2.dict1.ContainsKey(col2))
                                        {
                                            String value2 = var2.dict1[col2];
                                            MMBucket bucket2 = var2.dicb[value2];
                                            double v2 = var2.dictv.ContainsKey(col2) ? var2.dictv[col2] : 1;


                                            if (bucket2.dict.ContainsKey(value1) == false)
                                                bucket2.dict[value1] = new MMBucket();
                                            bucket2.dict[value1].count += v2;
                                        }

                                    }
                                }
                            }
                        }
                        else
                        {
                            // Response.Write("no ");
                        }
                    }
                }
            }

        }


        String ToWebString(Color c)
        {
            return "#" + c.R.ToString("X2") + c.G.ToString("X2") + c.B.ToString("X2");
        }

        public class GridSel
        {
            public String color1;
            public String color2;
        }
    }
}