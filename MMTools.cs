using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;

namespace profiler
{
    public class MMTools
    {
        public string file = "";
        public string rootStock = "";
        public string rootDriver = "";

        public MMTools(HttpContext context)
        {
            String path = context.Server.MapPath("config.js");
            String txt = File.ReadAllText(path);
            JavaScriptSerializer js = new JavaScriptSerializer();
            dynamic config = js.DeserializeObject(txt);
            file = config["mindmup"];
            rootStock = config["rootStock"];
            rootDriver = config["rootDriver"];
        }

        public dynamic ReadIdeas(HttpContext context)
        {
            
            String path = context.Server.MapPath(file);
            String txt = File.ReadAllText(path);

            JavaScriptSerializer js = new JavaScriptSerializer();
            dynamic obj = js.DeserializeObject(txt);

            return obj["ideas"];



        }

        public ProfVar GetVariable(dynamic ideas, String id, HttpContext context)
        {
            JavaScriptSerializer js = new JavaScriptSerializer();

            List<String> path = new List<string>();
            dynamic idea = FindIdea(ideas, id, path);
            if (idea == null)
            {
                context.Response.Write("Invalid variable id: " + id);
                context.Response.End();
                return null;
            }
            path.Reverse();

            ProfVar var = new ProfVar();
            var.name = idea["title"];
            var.id = idea["id"].ToString().Replace(".", "_");

            foreach (String s in path)
                var.path += s + ".";

            int index = var.name.IndexOf("http://");
            if (index == -1)
                index = var.name.IndexOf("https://");
            if (index != -1)
            {
                var.link = var.name.Substring(index);
                var.name = var.name.Substring(0, index);
            }

            if (var.link != "")
            {
                try
                {
                    String[] parts = var.link.Split('?');
                    String wmsurl = parts[0];
                    String[] args = parts[1].Split('&');

                    foreach (String arg in args)
                    {
                        String[] stuff = arg.Split('=');
                        String key = stuff[0].ToLower();
                        String val = stuff[1];

                        if (key == "request" || key == "bbox" || key == "width" || key == "height" || key == "format" || key == "srs")
                        {
                            // ignore
                        }
                        else if (key == "layers")
                        {
                            var.wmslayers = val;
                        }
                        else if (key == "styles")
                        {
                            var.wmsstyles = val;
                        }
                        else
                        {
                            // add back to url
                            if (wmsurl.IndexOf('?') == -1)
                                wmsurl += '?';
                            else
                                wmsurl += '&';
                            wmsurl += arg;
                        }
                        var.wmsurl = wmsurl;
                    }
                }
                catch (Exception err)
                {
                    context.Response.Write("Failed to parse wms url:<hr>" + var.link + "<hr>" + err.Message);
                }

            }



            if (idea.ContainsKey("attr"))
            {
                dynamic attr = idea["attr"];
                string json = "";

                if (attr.ContainsKey("note"))
                {
                    dynamic note = attr["note"];
                    var.note = note["text"];

                    

                    try
                    {
                        

                        string text = var.note;
                        int indexLink = text.IndexOf("http://");
                        if (indexLink == -1)
                            throw new Exception("Missing link in text");
                        string link = text.Substring(indexLink);
                        int indexEnd1 = link.IndexOf(' ');
                        int indexEnd2 = link.IndexOf('\n');
                        if (indexEnd1 != -1 && indexEnd2 != -1 && indexEnd1 > indexEnd2)
                            indexEnd1 = indexEnd2;
                        if (indexEnd1 == -1)
                            throw new Exception("Missing end of link in text");
                        link = link.Substring(0, indexEnd1);
                        var.metalink = link;


                        int indexJSON = text.IndexOf('{');
                        if (indexJSON == -1)
                            throw new Exception("no json found in note");

                        json = text.Substring(indexJSON);

                        dynamic obj = js.DeserializeObject(json);

                        if (obj.ContainsKey("application"))
                            var.name = obj["application"];



                        dynamic title = obj["title"];
                        dynamic style = obj["style"];
                        dynamic colormap = obj["colourmap"];
                        foreach (dynamic item in colormap)
                        {
                            dynamic dict = item;
                            foreach (string key in dict.Keys)
                            {
                                String[] vals = dict[key].Split(',');
                                String color = vals[0].Trim();

                                double val = 1;
                                if (vals.Length > 1)
                                    val = double.Parse(vals[1]);

                                if (color.IndexOf('#') == -1)
                                    color = '#' + color;
                                color = color.ToLower();

                                var.dict1[color] = key;
                                var.dict2[key] = color;

                                // fixme
                                // var.dictv[color] = 1; // val;

                                if (var.dicb.ContainsKey(key) == false)
                                {
                                    var.dicb[key] = new MMBucket();
                                    var.dicb[key].dict = new Dictionary<string,MMBucket>();
                                }
                                
                            }
                        }
                    }
                    catch (Exception err)
                    {
                        context.Response.Write("Failed to parse note<hr><pre>" + json + "</pre><hr>" + err.Message);
                        return null;
                    }

                    // parse metadata 
                    if (var.metalink != "")
                    {
                        String uid = GetURLVar(var.metalink, "uuid");
                        
                        String url = "http://oa.dirisa.org/jsonGetRecords?uuid=" + uid;
                        String org = url;
                        String usr = "admin";
                        String psw = "editbew123";
                        url += "&__ac_name=" + usr + "&__ac_password=" + psw;


                        using (WebClient wc = new WebClient())
                        {
                            String text = wc.DownloadString(url);

                            dynamic res = js.DeserializeObject(text);
                            if (res["count"] < 1)
                                throw new Exception("Record not found:" + url);

                            dynamic content = res["content"][0];
                            dynamic jsonData = content["jsonData"];
                            dynamic additionalFields = jsonData["additionalFields"];
                            dynamic onlineResources = additionalFields["onlineResources"];
                            dynamic onlineResource = onlineResources[0];
                            string href = onlineResource["href"];

                            try
                            {
                                String[] parts = href.Split('?');
                                String url2 = parts[0];
                                String[] args = parts[1].Split('&');

                                foreach (String arg in args)
                                {
                                    String[] stuff = arg.Split('=');
                                    String key = stuff[0].ToLower();
                                    String val = stuff[1];

                                    if (key == "request" || key == "bbox" || key == "width" || key == "height" || key == "format" || key == "srs")
                                    {
                                        // ignore
                                    }
                                    else if (key == "layers")
                                    {
                                        var.wmslayers = val;
                                    }
                                    else if (key == "styles")
                                    {
                                        var.wmsstyles = val;
                                    }
                                    else
                                    {
                                        // add back to url
                                        if (url2.IndexOf('?') == -1)
                                            url2 += '?';
                                        else
                                            url2 += '&';
                                        url2 += arg;
                                    }
                                    var.wmsurl = url2;
                                }
                            }
                            catch (Exception err)
                            {
                                context.Response.Write("Failed to parse wms url:<hr>" + href + "<hr>" + err.Message);
                            }
                        }
                    }
                }
            }


            return var;


        }

        protected dynamic FindIdea(dynamic ideas, String id, List<string> path)
        {
            foreach (dynamic keys in ideas.Keys)
            {
                dynamic idea = ideas[keys];

                if (idea["id"].ToString().Replace(".", "_") == id)
                    return idea;

                if (idea.ContainsKey("ideas"))
                {
                    dynamic test = FindIdea(idea["ideas"], id, path);
                    if (test != null)
                    {
                        path.Add(idea["title"]);
                        return test;
                    }
                }
            }
            return null;
        }

        public string GetRegionName(int id)
        {
            String query = "SELECT fRegionName FROM TblFeature WHERE fFeatureID = @fFeatureID";
            String region = "";
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
                            region = set["fRegionName"].ToString();
                        }
                    }
                }
            }
            return region;
        }

        public int GetRegionID(String RegionName)
        {

            String url = "http://app01.saeon.ac.za/nccrdapi/api/Region/GetByType/3";
            int regionID = -1;
            using (WebClient wc = new WebClient())
            {
                String txt = wc.DownloadString(url);

                JavaScriptSerializer js = new JavaScriptSerializer();
                dynamic regions = js.DeserializeObject(txt);
                foreach (dynamic region in regions)
                {
                    String name = region["RegionName"];
                    int index = name.IndexOf('(');
                    name = name.Substring(index + 1);
                    index = name.IndexOf(')');
                    name = name.Substring(0, index);
                    if (name == RegionName)
                        regionID = region["RegionId"];
                }
            }
            return regionID;
        }


        public String GetURLVar(String url, String name)
        {
            String[] parts = url.Split('?');
            String[] args = parts[1].Split('&');
            foreach (String arg in args)
            {
                String[] stuff = arg.Split('=');
                String key = stuff[0].ToLower();
                String val = stuff[1];
                if (key == name)
                    return val;
            }
            return "";
        }


    }

    

    

    public class ProfVar
    {
        public string name = "";
        public string id = "";
        public string path = "";
        public string link = "";
        public string note = "";
        public string metalink = "";
        public string wmsurl = "";
        public string wmslayers = "";
        public string wmsstyles = "";
        public string application = "";



        public Dictionary<String, String> dict1 = new Dictionary<string, string>();
        public Dictionary<String, String> dict2 = new Dictionary<string, string>();
        public Dictionary<String, double> dictv = new Dictionary<string, double>();
        public Dictionary<String, MMBucket> dicb = new Dictionary<string, MMBucket>();
    }

    public class MMBucket
    {
        public double count = 0;
        public Dictionary<String, MMBucket> dict;
    }


}