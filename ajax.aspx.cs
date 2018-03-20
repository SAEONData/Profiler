using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace profiler
{
    public partial class ajax : System.Web.UI.Page
    {
        public double x1 = 16;
        public double y1 = -35;
        public double x2 = 33;
        public double y2 = -22;

        ajaxRet ret = new ajaxRet();
        protected void Page_Load(object sender, EventArgs e)
        {
            String mode = Request["mode"];
            switch (mode)
            {
                case "parseGetCapabilities":
                    parseGetCapabilities();
                    break;

                case "parseDescribeCoverage":
                    parseDescribeCoverage();
                    break;

                case "grab":
                    grab();
                    break;

                case "tabulate":
                    tabulate();
                    break;
            }

        }

        protected void parseGetCapabilities()
        {
            ajaxRetGetCap ret = new ajaxRetGetCap();

            try
            {
                String url = Request["url"] + "?&SERVICE=WCS&VERSION=2.0.1&REQUEST=GetCapabilities";
                // Response.Write(url);
                // return;

                using (WebClient wc = new WebClient())
                {
                    String xml = wc.DownloadString(url);

                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(xml);

                    XmlNode root = doc.DocumentElement;

                    // service provider
                    XmlNode serviceProvider = xmltool.getNode(root, "ServiceProvider");
                    ret.serviceProvider = xmltool.getNode(serviceProvider, "ProviderName").InnerText;

                    // ServiceMetadata
                    //XmlNode ServiceMetadata = xmltool.getNode(root, "ServiceMetadata");
                    //XmlNode[] formatSupported = xmltool.getNodes(ServiceMetadata, "formatSupported");
                    //foreach (XmlNode node in formatSupported)
                    //    ret.formats.Add(node.InnerText);

                    // Contents
                    XmlNode Contents = xmltool.getNode(root, "Contents");
                    XmlNode[] CoverageSummaries = xmltool.getNodes(Contents, "CoverageSummary");
                    foreach (XmlNode node in CoverageSummaries)
                        ret.coverages.Add(xmltool.getNode(node, "CoverageId").InnerText);

                }
            }
            catch (Exception err)
            {
                ret.success = false;
                ret.message = err.Message;
            }
            finally
            {
                JavaScriptSerializer js = new JavaScriptSerializer();
                Response.Write(js.Serialize(ret));
            }
        }

        string DownloadCoverage(String src, String cov, String format, String date)
        {
            String imgPath = Path.GetTempFileName() + "." + format;
            String url = src + "?&SERVICE=WCS&VERSION=2.0.1&REQUEST=GetCoverage&COVERAGEID=" + Server.UrlEncode(cov) + "&SUBSET=Lat(" + y1 + "," + y2 + ")&SUBSET=Long(" + x1 + "," + x2 + ")&SUBSET=ansi(\"" + Server.UrlEncode(date) + "\")&FORMAT=image/" + format;
            using (WebClient wc = new WebClient())
            {
                wc.DownloadFile(url, imgPath);
            }
            return imgPath;
        }

        protected void tabulate()
        {
            String src = Request["src"];
            String cov = Request["cov"];
            String format = Request["fmt"];
            String classMode = Request["classMode"];
            String clCont = Request["clCont"];
            String scale = Request["scale"];
            String offset = Request["offset"];
            String disc = Request["disc"];
            String date = Request["date"];
            String layer = Request["layer"];
            String field = Request["field"];

            String image = DownloadCoverage(src, cov, format, date);
            Bitmap bmp = new Bitmap(image);


            String shapePath = Server.MapPath("data/meso_base_LL.shp");
            /*
            var sf = new SharpMap.Data.Providers.ShapeFile(shapePath, true);
            sf.Open();

            var ext = sf.GetExtents();
            if (ext == null)
                throw new Exception("fuuuu");

            System.Diagnostics.Debugger.Launch();



            FeatureDataSet ds = new FeatureDataSet();
            sf.ExecuteIntersectionQuery(ext, ds);
            */

            Response.Write("ok");


        }

        protected void grab()
        {
            String url = Request["url"];
            try
            {
                using (WebClient wc = new WebClient())
                {
                    String html = wc.DownloadString(url);
                    Response.Write(html);
                }
            }
            catch (Exception err)
            {
                Response.Write(err.Message);
            }


        }

        protected void parseDescribeCoverage()
        {
            ajaxRetDescCov ret = new ajaxRetDescCov();

            try
            {
                String url = Request["url"] + "?&SERVICE=WCS&VERSION=2.0.1&REQUEST=DescribeCoverage&COVERAGEID=" + Request["cov"];
                using (WebClient wc = new WebClient())
                {
                    String xml = wc.DownloadString(url);

                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(xml);

                    XmlNode root = doc.DocumentElement;

                    // bounding box
                    XmlNode CoverageDescription = xmltool.getNode(root, "CoverageDescription");
                    XmlNode boundedBy = xmltool.getNode(CoverageDescription, "boundedBy");
                    XmlNode Envelope = xmltool.getNode(boundedBy, "Envelope");
                    String lowerCorner = xmltool.getNodeText(Envelope, "lowerCorner");
                    String upperCorner = xmltool.getNodeText(Envelope, "upperCorner");



                }
            }
            catch (Exception err)
            {
                ret.success = false;
                ret.message = err.Message;
            }
            finally
            {
                JavaScriptSerializer js = new JavaScriptSerializer();
                Response.Write(js.Serialize(ret));
            }
        }



        class ajaxRet
        {
            public bool success = true;
            public string message = "";
        }

        class ajaxRetGetCap : ajaxRet
        {
            public string serviceProvider;
            public List<String> formats = new List<string>();
            public List<String> coverages = new List<string>();
        }

        class ajaxRetDescCov : ajaxRet
        {
            public string serviceProvider = "";
            public List<String> formats = new List<string>();
            public List<String> coverages = new List<string>();
        }

    }
}