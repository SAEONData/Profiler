using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;

namespace profiler
{
    public class xmltool
    {
        public static XmlNode getNode(XmlNode root, String name)
        {
            foreach (XmlNode node in root.ChildNodes)
            {
                if (node.LocalName == name)
                    return node;
            }
            throw new Exception("node: '" + name + "' not found under '" + root.LocalName + "'");
        }

        public static bool findNode(XmlNode root, String name)
        {
            foreach (XmlNode node in root.ChildNodes)
            {
                if (node.LocalName == name)
                    return true;
            }
            return false;
        }
        


        public static string getNodeText(XmlNode root, String name)
        {
            return getNode(root, name).InnerText;
        }

        public static XmlNode[] getNodes(XmlNode root, String name)
        {
            List<XmlNode> nodes = new List<XmlNode>();
            foreach (XmlNode node in root.ChildNodes)
            {
                if (node.LocalName == name)
                    nodes.Add(node);
            }
            return nodes.ToArray();
        }
    }
}