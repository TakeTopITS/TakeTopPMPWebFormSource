using System;
using System.Collections;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TakeTopPersonalSpace : System.Web.UI.Page
{
    int intBegin;
    int intRunNumber;

    string strUserCode, strUserType, strLangCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strUserType = Session["UserType"].ToString();
        strLangCode = Session["LangCode"].ToString();


        if (Page.IsPostBack == false)
        {
            //if (Session["IsUpdatePersonalSpace"] != null)
            //{
            //    // 强制清除缓存
            //    Response.Cache.SetCacheability(HttpCacheability.NoCache);
            //    Response.Cache.SetExpires(DateTime.UtcNow.AddDays(-1));
            //    Response.Cache.SetValidUntilExpires(false);
            //    Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
            //    Response.Cache.SetNoStore();

            //    Session["IsUpdatePersonalSpace"] = null;
            //}

            LB_UserName.Text = ShareClass.GetUserName(strUserCode);

            string strProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];

            //设置AI接口URL
            SetAIURL();

            if (Session["SystemVersionType"].ToString() == "SAAS")
            {
                Response.Redirect("TakeTopPersonalSpaceSAAS.aspx?UserCode=" + strUserCode + "&Flag=" + Session["SkinFlag"].ToString());
            }

            if (strUserType == "OUTER")
            {
                Response.Redirect("TakeTopPersonalSpaceForOuterUser.aspx?UserCode=" + strUserCode + "&Flag=" + Session["SkinFlag"].ToString());
            }

            if (Request.QueryString["UserCode"] == null)
            {
                Response.Redirect("TakeTopPersonalSpace.aspx?UserCode=" + strUserCode + "&Flag=" + Session["SkinFlag"].ToString());
            }

            //清空页面缓存，用于改变皮肤
            SetPageNoCache();

            intRunNumber = 0;

            BindNewsAndNoticeTypeData();
            BindPersonalSpaceModuleList();

            //RegisterAsyncTask(new PageAsyncTask(AsyncWork));
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

    protected void BT_Extend_Click(object sender, EventArgs e)
    {
        string strUserCode;
        string strLeftBarExtend;


        strUserCode = Session["UserCode"].ToString();

        strUserCode = Session["UserCode"].ToString();
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

    protected void RP_NewsTypeList_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            for (int i = 0; i < RP_NewsTypeList.Items.Count; i++)
            {
                ((HyperLink)RP_NewsTypeList.Items[i].FindControl("HL_NavBar")).ForeColor = Color.White;
            }

            ((HyperLink)e.Item.FindControl("HL_NavBar")).ForeColor = Color.Red;
        }
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

    private async System.Threading.Tasks.Task AsyncWork()
    {
        await System.Threading.Tasks.Task.Delay(8000);

        BindNewsAndNoticeTypeData();
        BindPersonalSpaceModuleList();
    }

    protected void BT_PopWindow_Click(object sender, EventArgs e)
    {
        string strHQL;

        strHQL = "Select * From T_ProjectMember Where char_length(WeChatOpenID) = 0 and UserCode = '" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
        if (ds.Tables[0].Rows.Count > 0)
        {
            ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','true') ", true);
        }
    }

    protected void BindNewsAndNoticeTypeData()
    {
        string strHtml = string.Empty;
        string strHQL;
        DataSet ds;

        strHQL = "Select Distinct * From T_NewsType Where LangCode = " + "'" + strLangCode + "' and Visible = 'YES' and NewsScope in ('ALL','INNER')  Order By SortNumber ASC";
        ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "T_NewsType");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Select Distinct * From T_NewsType Where LangCode = 'zh-CN' and Visible = 'YES' and NewsScope in ('ALL','INNER') Order By SortNumber ASC";
            ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "T_NewsType");
        }

        RP_NewsTypeList.DataSource = ds;
        RP_NewsTypeList.DataBind();
    }

    protected void BindPersonalSpaceModuleList()
    {
        string strHQL;
        DataSet ds;
        // 优化第一个查询 - EveryRowColumnNumber = 1
        strHQL = String.Format(@"SELECT DISTINCT B.HomeModuleName, (RTRIM(B.PageName)||'?UserCode={0}') as ModulePage, A.SortNumber  
        FROM T_ProModuleLevelForPage B 
        INNER JOIN T_ProModuleLevelForPageUser A ON A.ModuleName = B.ModuleName 
        WHERE A.UserType = '{1}' AND B.Visible = 'YES' AND B.IsDeleted = 'NO' 
        AND A.UserCode = '{0}' AND B.ParentModule = 'PersonalSpace' 
        AND B.PageName <> 'TTPersonalSpaceNews.aspx' AND A.EveryRowColumnNumber = 1 
        AND B.LangCode = '{2}' AND A.Visible = 'YES' 
        ORDER BY A.SortNumber ASC", strUserCode, strUserType, strLangCode);
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");
        //LogClass.WriteLogFile(strHQL);

        Repeater1.DataSource = ds;
        Repeater1.DataBind();

        // 优化第二个查询 - EveryRowColumnNumber = 2
        strHQL = String.Format(@"SELECT DISTINCT B.HomeModuleName, (RTRIM(B.PageName)||'?UserCode={0}') as ModulePage, A.SortNumber  
        FROM T_ProModuleLevelForPage B 
        INNER JOIN T_ProModuleLevelForPageUser A ON A.ModuleName = B.ModuleName 
        WHERE A.UserType = '{1}' AND B.Visible = 'YES' AND B.IsDeleted = 'NO' 
        AND A.UserCode = '{0}' AND B.ParentModule = 'PersonalSpace' 
        AND B.PageName <> 'TTPersonalSpaceNews.aspx' AND A.EveryRowColumnNumber = 2 
        AND B.LangCode = '{2}' AND A.Visible = 'YES' 
        ORDER BY A.SortNumber ASC", strUserCode, strUserType, strLangCode);
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");
        Repeater2.DataSource = ds;
        Repeater2.DataBind();
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