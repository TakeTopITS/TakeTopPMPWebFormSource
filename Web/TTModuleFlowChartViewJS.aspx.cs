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
        string strTemName;

        if (Session["iframeModuleFlowDataSet"] == null)
        {
            ShareClass.PreLoadModuleFlowChartDataSet();
        }

        DataSet ds = (DataSet)Session["iframeModuleFlowDataSet"];
        if (ds.Tables[0].Rows.Count > 0)
        {
            strTemName = ds.Tables[0].Rows[0]["ModuleName"].ToString().Trim();

            TB_CopyRight.Text = System.Configuration.ConfigurationManager.AppSettings["CopyRight"];
            TB_WFIdentifyString.Text = strIdentifyString;
            TB_WFName.Text = strTemName;

            if (Session["WFModuleFlowChartXML"] == null)
            {
                TB_WFXML.Text = WFMFFlowDefinitionHandle.GetModuleFlowDefinition(strID, strType, ds);
                Session["WFModuleFlowChartXML"] = TB_WFXML.Text;
            }
            else
            {
                TB_WFXML.Text = Session["WFModuleFlowChartXML"].ToString();
            }
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "autoHeight();", true);
    }
}