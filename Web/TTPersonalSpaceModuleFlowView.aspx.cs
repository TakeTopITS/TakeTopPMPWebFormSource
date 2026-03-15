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
            litIframeModuleFlowHTML.Visible = false;

            DataSet dsModuleFlow = ShareClass.GetSystemModuleFlowDataSet("OperateNavigation", Session["UserCode"].ToString(), Session["UserType"].ToString(), Session["LangCode"].ToString());
            RP_iframeModuleFlow.DataSource = dsModuleFlow;
            RP_iframeModuleFlow.DataBind();
        }

    }

}