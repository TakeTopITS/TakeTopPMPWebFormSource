using System;
using System.Resources;
using System.Drawing;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Text;

using System.Security.Cryptography;
using System.Security.Permissions;
using System.Data.SqlClient;

public partial class TakeTopPersonalSpaceSAAS : System.Web.UI.Page
{
    int intRunNumber;

    string strUserCode, strUserType, strLangCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strUserType = Session["UserType"].ToString();
        strLangCode = Session["LangCode"].ToString();

        if (Page.IsPostBack == false)
        {
            if (!ShareClass.checkModuleIsVisible("AIAnalyst", strLangCode))
            {
                tdAI.Visible = false;
            }
            else
            {
                //设置AI接口URL
                SetAIURL();
            }

            LB_UserName.Text = ShareClass.GetUserName(strUserCode);

            string strProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];

            if (Request.QueryString["UserCode"] == null)
            {
                Response.Redirect("TakeTopPersonalSpaceSAAS.aspx?UserCode=" + strUserCode + "&Flag=" + Session["SkinFlag"].ToString());
            }

            string strLeftBarExtend = ShareClass.GetLeftBarExtendStatus(strUserCode);
            if (strLeftBarExtend == "YES")
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickLeftBar", "clickLeftBarExtend();", true);
            }

            //清空页面缓存，用于改变皮肤
            SetPageNoCache();

            intRunNumber = 0;

            BindNewsAndNoticeTypeData();
            BindPersonalSpaceModuleList();

            //RegisterAsyncTask(new PageAsyncTask(AsyncWork));
        }
    }

    protected void BT_Extend_Click(object sender, EventArgs e)
    {
        string strLeftBarExtend;
     
        if (Session["LeftBarExtend"].ToString() == "YES")
        {
            strLeftBarExtend = "NO";
        }
        else
        {
            strLeftBarExtend = "YES";
        }

        try
        {
            //更新左边栏展开状态
            ShareClass.UpdateLeftBarExtendStatus(strUserCode, strLeftBarExtend);

            Session["LeftBarExtend"] = strLeftBarExtend;

            ShareClass.AddSpaceLineToFile("TakeTopLRExLeft.aspx", "");
            ShareClass.AddSpaceLineToFile("TakeTopCSLRLeft.aspx", "");

            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click55", "changeLeftBarExtend('" + strLeftBarExtend + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click66", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGGSBJC") + "')", true);
        }
    }
   
    protected void Timer1_Tick(object sender, EventArgs e)
    {
        if (intRunNumber == 0)
        {
            BindNewsAndNoticeTypeData();
            BindPersonalSpaceModuleList();

            //Timer1.Interval = 36000000;

            intRunNumber = 1;
        }
    }

    private async System.Threading.Tasks.Task AsyncWork()
    {
        await System.Threading.Tasks.Task.Delay(1000);
      
        BindNewsAndNoticeTypeData();
        BindPersonalSpaceModuleList();
    }

    protected void BindPersonalSpaceModuleList()
    {
        string strHQL;
        DataSet ds;

        // 优化第一个查询 - EveryRowColumnNumber = 1
        strHQL = String.Format(@"SELECT Distinct B.HomeModuleName, (RTRIM(B.PageName)||'?UserCode={0}') as ModulePage, A.SortNumber  
        FROM T_ProModuleLevelForPage B 
        INNER JOIN T_ProModuleLevelForPageUser A ON A.ModuleName = B.ModuleName 
        WHERE A.UserType = '{1}' AND A.UserCode = '{0}' AND A.Visible = 'YES' AND A.EveryRowColumnNumber = 1
        AND B.Visible = 'YES' AND B.IsDeleted = 'NO' AND B.ParentModule = 'PersonalSpaceSaaS'
        AND B.LangCode = '{2}' AND B.PageName <> 'TTPersonalSpaceNews.aspx'
        ORDER BY A.SortNumber ASC", strUserCode, strUserType, strLangCode);
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");

        Repeater1.DataSource = ds;
        Repeater1.DataBind();

        // 优化第二个查询 - EveryRowColumnNumber = 2
        strHQL = String.Format(@"SELECT Distinct B.HomeModuleName, (RTRIM(B.PageName)||'?UserCode={0}') as ModulePage, A.SortNumber  
        FROM T_ProModuleLevelForPage B 
        INNER JOIN T_ProModuleLevelForPageUser A ON A.ModuleName = B.ModuleName 
        WHERE A.UserType = '{1}' AND A.UserCode = '{0}' AND A.Visible = 'YES' AND A.EveryRowColumnNumber = 2
        AND B.Visible = 'YES' AND B.IsDeleted = 'NO' AND B.ParentModule = 'PersonalSpaceSaaS'
        AND B.LangCode = '{2}' AND B.PageName <> 'TTPersonalSpaceNews.aspx'
        ORDER BY A.SortNumber ASC", strUserCode, strUserType, strLangCode);
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");

        Repeater2.DataSource = ds;
        Repeater2.DataBind();
    }

    protected void BindNewsAndNoticeTypeData()
    {
        string strHtml = string.Empty;
        string strHQL;
        DataSet ds;

        strHQL = "Select Distinct * From T_NewsType Where LangCode = " + "'" + strLangCode + "' and Visible = 'YES' and NewsScope in ('ALL','INNER') Order By SortNumber ASC";
        ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "T_NewsType");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select Distinct * From T_NewsType Where LangCode = 'zh-CN' and Visible = 'YES' and NewsScope in ('ALL','INNER') Order By SortNumber ASC";
            ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "T_NewsType");
        }

        RP_NewsTypeList.DataSource = ds;
        RP_NewsTypeList.DataBind();
    }

    //清空页面缓存，用于改变皮肤
    public void SetPageNoCache()
    {
        if (Session["CssDirectoryChangeNumber"].ToString() == "1")
        {
            //清除全部缓存
            IDictionaryEnumerator allCaches = Page.Cache.GetEnumerator();
            while (allCaches.MoveNext())
            {
                Page.Cache.Remove(allCaches.Key.ToString());
            }

            Page.Response.Buffer = true;
            Page.Response.AddHeader("Pragma", "No-Cache");

            Page.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1);
            Page.Response.Cache.SetExpires(DateTime.Now.AddDays(-1));
            Page.Response.Expires = 0;
            Page.Response.CacheControl = "no-cache";
            Page.Response.Cache.SetNoStore();
        }
    }

    //设置AI接口URL
    public void SetAIURL()
    {
        string strAIType, strAIURL;
        string strHQL;

        strHQL = "Select AIType,URL,Model From T_AIInterface";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");
        if (ds.Tables[0].Rows.Count > 0)
        {
            strAIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim();
            strAIURL = ds.Tables[0].Rows[0]["URL"].ToString().Trim();

            if (strAIType == "Outer")
            {
                HL_AIURL.Visible = true;
                //HL_AIURL.NavigateUrl = strAIURL;

                a_AIURL.Visible = false;
            }
            else
            {
                a_AIURL.Visible = true;

                HL_AIURL.Visible = false;
            }
        }
    }

}
