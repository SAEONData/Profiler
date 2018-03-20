using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace profiler
{
    public partial class indicator : System.Web.UI.Page
    {
        public List<string> covdates = new List<string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            String url = Request["src"] + "?&SERVICE=WCS&VERSION=2.0.1&REQUEST=DescribeCoverage&COVERAGEID=" + Request["cov"];
            using (WebClient wc = new WebClient())
            {
                String xml = wc.DownloadString(url);
                 // Response.ContentType = "text/xml";
                 // Response.Write(xml);
                //  Response.End();


                XmlDocument doc = new XmlDocument();
                doc.LoadXml(xml);

                XmlNode root = doc.DocumentElement;

                // bounding box
                XmlNode CoverageDescription = xmltool.getNode(root, "CoverageDescription");
                XmlNode boundedBy = xmltool.getNode(CoverageDescription, "boundedBy");
                XmlNode Envelope = xmltool.getNode(boundedBy, "Envelope");
                String lowerCorner = xmltool.getNodeText(Envelope, "lowerCorner");
                String upperCorner = xmltool.getNodeText(Envelope, "upperCorner");


                XmlNode domainSet = xmltool.getNode(CoverageDescription, "domainSet");
                XmlNode ReferenceableGridByVectors = xmltool.getNode(domainSet, "ReferenceableGridByVectors");
                XmlNode[] generalGridAxis = xmltool.getNodes(ReferenceableGridByVectors, "generalGridAxis");
                foreach (XmlNode node in generalGridAxis)
                {
                    XmlNode subnode = xmltool.getNode(node, "GeneralGridAxis");
                    if (xmltool.findNode(subnode, "coefficients"))
                    {
                        XmlNode coefficients = xmltool.getNode(subnode, "coefficients");
                        String text = coefficients.InnerText;
                        if (text.Length > 5)
                        {
                            String[] dates = text.Split(' ');
                            foreach (String date in dates)
                            {
                                String dt = date.Replace("\"", "");
                                covdates.Add(dt);


                            }
                        }
                        
                    }
                }
            }
        }
    }
}