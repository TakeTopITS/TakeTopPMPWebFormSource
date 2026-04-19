using System;
using System.Resources;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TakeTopLRExInnerMDI : System.Web.UI.Page
{
    public string strUserCode, strUserType;

    // 左边栏宽度配置
    public string leftBarWidth = "45";
    public string leftBarExtendStatus = "NO";

    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = System.Configuration.ConfigurationManager.AppSettings["SystemName"] + " " + ShareClass.SystemVersionID + "---" + System.Configuration.ConfigurationManager.AppSettings["Slogan"];

        try
        {
            strUserCode = Session["UserCode"].ToString();
            strUserType = ShareClass.GetUserType(strUserCode);
            if (strUserType == "OUTER")
            {
                Response.Redirect("TTDisplayErrors.aspx");
                return;
            }

            // 读取左边栏展开状态
            leftBarExtendStatus = ShareClass.GetLeftBarExtendStatus(strUserCode);
            if (string.IsNullOrEmpty(leftBarExtendStatus))
            {
                leftBarExtendStatus = "NO";
            }
            Session["LeftBarExtend"] = leftBarExtendStatus;
            
            // 根据状态设置左边栏宽度
            if (leftBarExtendStatus == "YES")
            {
                leftBarWidth = "180"; // 展开状态宽度
            }
            else
            {
                leftBarWidth = "45"; // 收缩状态宽度
            }

            //预加载模组流程图数据集
            if (Session["ModuleFlowChartString"] == null)
            {
                //预加载模组流程图数据集
                Session["ModuleFlowChartString"] = ShareClass.PreLoadModuleFlowChartDataSet();
            }
        }
        catch (Exception err)
        {
            Response.Redirect("Default.aspx");
        }
    }

  

}