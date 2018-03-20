using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace profiler
{
    public partial class search : System.Web.UI.Page
    {
        public bool hideControl = false;
        public string mode = "search";
        public bool loggedIn = false;
        public int frameHeight = 600;
        public string parentInstitute = "";
        public string childInstitutions = "";


        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void WriteInstitutions()
        {
        }

        public void WriteDefaultInstitution()
        {
        }

        public void GetValue(String key)
        {
        }

        public void WriteColumn1Classes()
        {
            if (hideControl == false)
                Response.Write("col-md-4");
            else
                Response.Write("col-md-4 hidden");

        }

        public void WriteColumn2Classes()
        {
            if (hideControl == false)
                Response.Write("col-md-8");
            else
                Response.Write("col-md-12");
        }

    }
}