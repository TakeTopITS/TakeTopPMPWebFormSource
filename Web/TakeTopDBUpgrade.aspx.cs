using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class TakeTopDBUpgrade : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack != true)
        {
            //数据库升级代码
            try
            {
                if (ShareClass.SystemDBer == "")
                {
                    if (DatabaseUpdateHandle.UpgradeDataBase())
                    {

                        LogClass.WriteLogFile("Database upgraded successfully on application start");
                    }

                    ShareClass.SystemDBer = "DBer";
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Database upgrade ThreadAbortException" + err.Message.ToString());

                ClientScript.RegisterStartupScript(this.GetType(), "3", "<script>location.reload();</script>");
            }
        }
    }
}