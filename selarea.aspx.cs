using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class selarea : System.Web.UI.Page
    {
        public String description = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            String path = Server.MapPath("config.js");
            String txt = File.ReadAllText(path);
            JavaScriptSerializer js = new JavaScriptSerializer();
            dynamic config = js.DeserializeObject(txt);
            description = config["description"];

        }
    }
}