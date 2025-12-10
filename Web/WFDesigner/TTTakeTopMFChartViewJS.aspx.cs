using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class WFDesigner_TTTakeTopMFChartViewJS : System.Web.UI.Page
{
    public string licenseKey;

    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode, strUserType;
        strUserCode = Session["UserCode"].ToString();
        strUserType = Session["UserType"].ToString();

        string strID = GetSystemModuleID("OperateNavigation", strUserCode, strUserType, Session["LangCode"].ToString());

        divMFDesign.Attributes["onclick"] = "javascript:top.frames[0].frames[2].parent.frames['rightTabFrame'].popShowByURL('TTModuleFlowDesignerJS.aspx?Type=UserModule&IdentifyString=" + strID + "', 'ModuleFlowDesigner', 800, 600, window.location);";
    }

    protected string GetSystemModuleID(string strModuleName, string strUserCode, string strUserType, string strLangCode)
    {
        string strHQL;

        strHQL = string.Format(@"Select B.ID From T_ProModuleLevel A, T_ProModule B Where rtrim(A.ModuleName)
                ||rtrim(A.ModuleType)||rtrim(A.UserType) = rtrim(B.ModuleName) ||rtrim(B.ModuleType) 
                ||rtrim(B.UserType) and B.ModuleName = '{0}' and B.UserCode ='{1}' and B.UserType = '{2}' and (CHAR_LENGTH(B.ModuleDefinition) > 0 Or CHAR_LENGTH(A.ModuleDefinition) > 0) ", strModuleName, strUserCode, strUserType, strLangCode);

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "0";
        }
    }
}