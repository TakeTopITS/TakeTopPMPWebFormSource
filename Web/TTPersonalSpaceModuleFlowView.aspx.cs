using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTPersonalSpaceModuleFlowView : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            if (Session["iframeModuleFlowHTML"] == null)
            {
                litIframeModuleFlowHTML.Visible = false;

                DataSet dsModuleFlow = ShareClass.GetSystemModuleFlowDataSet("OperateNavigation", Session["UserCode"].ToString(), Session["UserType"].ToString(), Session["LangCode"].ToString());
                RP_iframeModuleFlow.DataSource = dsModuleFlow;
                RP_iframeModuleFlow.DataBind();
                // 将第二个Repeater的HTML内容存储到Session
                StringWriter sw2 = new StringWriter();
                HtmlTextWriter hw2 = new HtmlTextWriter(sw2);
                RP_iframeModuleFlow.RenderControl(hw2);

                Session["iframeModuleFlowHTML"] = sw2.ToString();
            }
            else
            {
                RP_iframeModuleFlow.Visible = false;

                // 将HTML内容赋给Literal
                litIframeModuleFlowHTML.Text = Session["iframeModuleFlowHTML"].ToString();
            }
        }

    }

}