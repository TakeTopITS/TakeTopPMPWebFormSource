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
        strUserType = Session["UserType"].ToString();

        strID = Request.QueryString["IdentifyString"];
        strType = Request.QueryString["Type"];

        if (!IsPostBack)
        {
            AsyncWork();
        }
    }

    private void AsyncWork()
    {
        try
        {
            if (Session["ModuleFlowChartString"] == null)
            {
                //预加载模组流程图数据集
                Session["ModuleFlowChartString"] = ShareClass.PreLoadModuleFlowChartDataSet();
                LogClass.WriteLogFile("TTModuleFlowChartViewJS.aspx.cs AsyncWork() Session[\"ModuleFlowChartString\"] is null, start to preload data.");
            }
            TB_WFXML.Text = Session["ModuleFlowChartString"].ToString();
        }
        catch(Exception ex) 
        {
            try
            {
                Session["ModuleFlowChartString"] = ShareClass.PreLoadModuleFlowChartDataSet();
                TB_WFXML.Text = Session["ModuleFlowChartString"].ToString();
            }
            catch 
            {
            }

            LogClass.WriteLogFile("TTModuleFlowChartViewJS.aspx.cs AsyncWork() Exception: " + ex.Message);
        }

        TB_CopyRight.Text = System.Configuration.ConfigurationManager.AppSettings["CopyRight"];
        TB_WFIdentifyString.Text = "";
        TB_WFName.Text = "";
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "autoHeight();", true);
    }
}