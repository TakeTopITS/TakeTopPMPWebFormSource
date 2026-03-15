using System;
using System.Collections;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTPersonalSpaceAnalysisChart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            AsyncWork();
        }
    }

    private void AsyncWork()
    {
        if (Session["SystemAnalystChartHTML"] == null)
        {
            litSystemAnalystChartHTML.Visible = false;

            // 绑定第一个Repeater
            RP_ChartList.DataSource = ShareClass.GetSytemChartDataSet(Session["UserCode"].ToString(), "PersonalSpacePage");
            RP_ChartList.DataBind();


            // 将第一个Repeater的HTML内容存储到Session
            StringWriter sw1 = new StringWriter();
            HtmlTextWriter hw1 = new HtmlTextWriter(sw1);
            RP_ChartList.RenderControl(hw1);

            Session["SystemAnalystChartHTML"] = sw1.ToString();
        }
        else
        {
            RP_ChartList.Visible = false;

            // 将HTML内容赋给Literal
            litSystemAnalystChartHTML.Text = Session["SystemAnalystChartHTML"].ToString();
        }
    }
}