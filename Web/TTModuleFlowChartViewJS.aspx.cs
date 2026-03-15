using System;
using System.Data;
using System.Web;
using System.Web.UI;

using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

using TakeTopWF;

public partial class TTModuleFlowChartViewJS : System.Web.UI.Page
{
    private string strIdentifyString;
    string strUserCode, strUserType, strType;
    string strID;
    int intRunNumber;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strUserType = ShareClass.GetUserType(strUserCode);

        strID = Request.QueryString["IdentifyString"];
        strType = Request.QueryString["Type"];

        if (!IsPostBack)
        {
            AsyncWork();
        }
    }

    private void AsyncWork()
    {
        TB_WFXML.Text = ShareClass.PreLoadModuleFlowChartDataSet();

        TB_CopyRight.Text = System.Configuration.ConfigurationManager.AppSettings["CopyRight"];
        TB_WFIdentifyString.Text = "";
        TB_WFName.Text = "";
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "autoHeight();", true);
    }
}