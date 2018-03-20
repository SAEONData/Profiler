using GeoAPI.Geometries;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Xml;

namespace profiler
{
    public class GSTool
    {
        public List<GSGroup> groups = new List<GSGroup>();

        public GSTool(HttpContext context)
        {
            String path = context.Server.MapPath("config.js");
            String txt = File.ReadAllText(path);
            JavaScriptSerializer js = new JavaScriptSerializer();
            dynamic config = js.DeserializeObject(txt);
            dynamic features = config["features"];
            foreach (dynamic feature in features)
            {
                GSGroup group = new GSGroup();
                group.name = feature["name"];


                group.def = feature["default"] == "yes";
                foreach (dynamic source in feature["sources"])
                {
                    String regfield = "";
                    if (source.ContainsKey("regfield"))
                        regfield = source["regfield"];
                    group.sources.Add(new GSSource(source["name"], source["url"], source["layer"], source["style"], source["field"], "FID", regfield));
                }

                groups.Add(group);
            }
            
        }

        public GSSource GetSource(String name)
        {
            foreach (GSGroup group in groups)
            {
                foreach (GSSource source in group.sources)
                {
                    if (source.name == name)
                        return source;
                }
            }
            throw new Exception("Invalid source name: " + name);
        }

        public string Filter(HttpContext context, String dsname, String text)
        {
            GSSource source = GetSource(dsname);
            String url = source.server + "&request=GetFeature&typeName=" + context.Server.UrlEncode(source.layer) + "&propertyName=" + context.Server.UrlEncode(source.fieldName);
            SortedDictionary<string, string> sdict = new SortedDictionary<string, string>();

            using (WebClient wc = new WebClient())
            {
                String xmltxt = wc.DownloadString(url);

                XmlDocument xmldoc = new XmlDocument(); // Create an XML document object
                xmldoc.LoadXml(xmltxt);

                // Get elements
                XmlNodeList girlAddress = xmldoc.GetElementsByTagName(source.layer);
                foreach (XmlNode node in girlAddress)
                {
                    String id = node.Attributes["gml:id"].Value;
                    String name = "";
                    foreach (XmlNode child in node.ChildNodes)
                    {
                        name = child.InnerText;
                    }

                    if (text != "")
                    {
                        if (name.ToLower().IndexOf(text.ToLower()) != -1)
                        {
                            sdict[name] = id;
                        }
                    }
                    else
                    {
                        sdict[name] = id;
                    }
                        

                }

            }

            String code = "";
            foreach (String name in sdict.Keys)
            {
                code += "<a class='gslink' href='#" + context.Server.UrlEncode(sdict[name]) + "'>" + context.Server.HtmlEncode(name) + "</a><br />";
            }

            return code;
        }

        public int GetFeatureID(HttpContext context, String type, String name)
        {
            GSSource source = GetSource(type);
            String query = "SELECT * FROM TblFeature WHERE fFeatureRef = @fFeatureRef AND @fFeatureType = @fFeatureType";
            int featureID = -1;
            using (SqlConnection con = new SqlConnection(dbsource.main))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@fFeatureRef", name);
                    cmd.Parameters.AddWithValue("@fFeatureType", type);
                    using (SqlDataReader set = cmd.ExecuteReader())
                    {
                        if (set.Read() == true)
                        {
                            featureID = (int)set["fFeatureID"];
                        }
                    }
                }
            }
            return featureID;
        }


        public GSFeature GetFeatureDB(HttpContext context, int id)
        {
            String query = "SELECT * FROM TblFeature WHERE fFeatureID = @fFeatureID";
            GSFeature feature = null;
            using (SqlConnection con = new SqlConnection(dbsource.main))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@fFeatureID", id);
                    using (SqlDataReader set = cmd.ExecuteReader())
                    {
                        if (set.Read() == true)
                        {
                            feature = new GSFeature();
                            feature.fref = set["fFeatureRef"].ToString();
                            feature.name = set["fFeatureName"].ToString();
                            feature.type = set["fFeatureType"].ToString();
                            feature.region = set["fRegionName"].ToString();
                            feature.wkt = set["fFeatureWKT"].ToString();
                            feature.x1 = (double)set["fBoundX1"];
                            feature.y1 = (double)set["fBoundY1"];
                            feature.x2 = (double)set["fBoundX2"];
                            feature.y2 = (double)set["fBoundY2"];
                        }
                    }
                }
            }
            return feature;
        }


        public int GetFeature(HttpContext context, String dsname, String fref)
        {
            int featureID = GetFeatureID(context, dsname, fref);
            if (featureID != -1)
                return featureID;

            GSSource source = GetSource(dsname);
            String url = source.server + "&request=GetFeature&typeName=" + context.Server.UrlEncode(source.layer) + "&featureID=" + context.Server.UrlEncode(fref);
            String featureName = "";
            String regionName = "";


            using (WebClient wc = new WebClient())
            {
                String xmltxt = wc.DownloadString(url);

                XmlDocument xmldoc = new XmlDocument(); // Create an XML document object
                xmldoc.LoadXml(xmltxt);

                String[] parts = source.layer.Split(':');
                String workspace = parts[0];

                XmlNodeList nameNode = xmldoc.GetElementsByTagName(workspace + ":" + source.fieldName);
                featureName = nameNode[0].InnerText;

                if (source.regfield != "")
                {
                    XmlNodeList regionNode = xmldoc.GetElementsByTagName(workspace + ":" + source.regfield);
                    regionName = regionNode[0].InnerText;
                }


                XmlNodeList surfaceMembers = xmldoc.GetElementsByTagName("gml:surfaceMember");

                String coords = "";

                double x1 =  1e100;
                double y1 =  1e100;
                double x2 = -1e100;
                double y2 = -1e100;
                foreach (XmlNode surfaceMember in surfaceMembers)
                {
                    if (coords != "")
                        coords += ", ";
                    coords += "(";

                    XmlNode polygon = surfaceMember.ChildNodes[0];
                    if (polygon.Name != "gml:Polygon")
                        throw new Exception("Invalid geom type 1:" + polygon.Name);

                    XmlNode exterior = polygon.ChildNodes[0];
                    if (exterior.Name != "gml:exterior")
                        throw new Exception("Invalid geom type 2:" + exterior.Name);

                    XmlNode LinearRing = exterior.ChildNodes[0];
                    if (LinearRing.Name != "gml:LinearRing")
                        throw new Exception("Invalid geom type 3:" + LinearRing.Name);

                    XmlNode posList = LinearRing.ChildNodes[0];
                    if (posList.Name != "gml:posList")
                        throw new Exception("Invalid geom type 4:" + posList.Name);

                    String[] positions = posList.InnerText.Split(' ');
                    String outc = "";
                    int count = positions.Length / 2;
                    for (int i=0; i<count; i++) {
                        double px = double.Parse(positions[i * 2 + 1]);
                        double py = double.Parse(positions[i * 2 + 0]);
                        if (outc != "")
                            outc += ", ";
                        outc += px + " " + py;

                        x1 = Math.Min(x1, px);
                        y1 = Math.Min(y1, py);
                        x2 = Math.Max(x2, px);
                        y2 = Math.Max(y2, py);
                    }

                    coords += outc;
                    coords += ")";
                }

                String wkt = "POLYGON(" + coords + ")";

                String sql = "INSERT INTO TblFeature (fFeatureRef, fFeatureType, fFeatureName, fFeatureWKT, fBoundX1, fBoundY1, fBoundX2, fBoundY2, fRegionName) VALUES (@fFeatureRef, @fFeatureType, @fFeatureName, @fFeatureWKT, @fBoundX1, @fBoundY1, @fBoundX2, @fBoundY2, @fRegionName)";
                using (SqlConnection con = new SqlConnection(dbsource.main))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.AddWithValue("@fFeatureRef", fref);
                        cmd.Parameters.AddWithValue("@fFeatureType", source.name);
                        cmd.Parameters.AddWithValue("@fFeatureName", featureName);
                        cmd.Parameters.AddWithValue("@fRegionName", regionName);
                        cmd.Parameters.AddWithValue("@fFeatureWKT", wkt);
                        cmd.Parameters.AddWithValue("@fBoundX1", x1);
                        cmd.Parameters.AddWithValue("@fBoundY1", y1);
                        cmd.Parameters.AddWithValue("@fBoundX2", x2);
                        cmd.Parameters.AddWithValue("@fBoundY2", y2);
                        cmd.ExecuteNonQuery();
                    }
                }

                featureID = GetFeatureID(context, dsname, fref);
            }

            return featureID;
        }
    }

    public class GSFeature
    {
        public string type;
        public string fref;
        public string name;
        public string region;
        public string wkt;
        public double x1;
        public double y1;
        public double x2;
        public double y2;
    }

    public class GSSource
    {
        public GSSource(string name, string server, string layer, string style, string fieldName, string fieldID, string regfield)
        {
            this.name = name;
            this.server = server;
            this.layer = layer;
            this.style = style;
            this.fieldName = fieldName;
            this.fieldID = fieldID;
            this.regfield = regfield;
        }

        public string name;
        public string server;
        public string layer;
        public string style;
        public string fieldName;
        public string fieldID;
        public string regfield;
    }

    public class GSGroup
    {
        public string name;
        public bool def;
        public List<GSSource> sources = new List<GSSource>();
    }

    
}