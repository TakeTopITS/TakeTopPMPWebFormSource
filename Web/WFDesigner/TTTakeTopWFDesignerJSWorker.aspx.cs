using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class WFDesigner_TTTakeToPWFDesignerJSWorker : System.Web.UI.Page
{
    public string licenseKey;
    protected void Page_Load(object sender, EventArgs e)
    {
        //licenseKey = System.Configuration.ConfigurationManager.AppSettings["CopyRight"];
        //Session["LicenseKey"] = licenseKey;

    }

    public static string getUrl()
    {
        return "www.taketopits.com";
    }
}