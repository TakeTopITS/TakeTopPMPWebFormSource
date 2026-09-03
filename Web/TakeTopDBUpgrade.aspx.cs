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
                        ShareClass.SystemDBer = "DBer";
                    }
                }
                else
                {
                    //LogClass.WriteLogFile("Database upgraded successfully on application End");
                    Response.Redirect("Outer/TakeTopSystemOtherCodeRunPage.aspx");
                }
            }
            catch (ThreadAbortException)
            {
                // Response.Redirect 会抛出 ThreadAbortException，这是 ASP.NET 的正常重定向机制，
                // 绝不能在这里 RegisterStartupScript/reload，否则会陷入无限 reload 循环导致页面永远转圈。
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Database upgrade error:  " + err.Message.ToString());
                ClientScript.RegisterStartupScript(this.GetType(), "3", "<script>location.reload();</script>");
            }
        }
    }
}