using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TakeTopDatabaseHandler : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Page.IsPostBack != true)
        {
            if (ShareClass.SystemDBer == "")
            {
                //ClientScript.RegisterStartupScript(this.GetType(), "1", "<script>displayBTLogin('NONE');</script>");
                //ClientScript.RegisterStartupScript(this.GetType(), "2", "<script>displayLBMessage('BLOCK');</script>");

                //LogClass.WriteLogFile("location.reload");

                //等待15000毫秒
                System.Threading.Thread.Sleep(15000);

                ClientScript.RegisterStartupScript(this.GetType(), "3", "<script>location.reload();</script>");
            }
        }

    }
}