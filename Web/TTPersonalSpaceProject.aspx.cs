using System;
using System.Resources;
using System.Drawing;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Caching;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Text;

using System.Security.Cryptography;
using System.Security.Permissions;
using Npgsql;//using System.Data.SqlClient;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

public partial class TTPersonalSpaceProject : System.Web.UI.Page
{
    int intRunNumber;


    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickParentA", "aHandlerForSpecialPopWindow();", true);
        if (Page.IsPostBack == false)
        {
            //���ҳ�滺�棬���ڸı�Ƥ��
            SetPageNoCache();

            intRunNumber = 0;

            AsyncWork();
        }
    }

    //���ҳ�滺�棬���ڸı�Ƥ��
    public void SetPageNoCache()
    {
        if (Session["CssDirectoryChangeNumber"].ToString() == "1")
        {
            //���ȫ������
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

    protected void Timer1_Tick(object sender, EventArgs e)
    {
        if (intRunNumber == 0)
        {
            AsyncWork();

            Timer1.Interval = 3600000;

            intRunNumber = 1;
        }
    }

    private void AsyncWork()
    {
        string strUserInfo, strUserName;

        string strUserCode;
        String strLangCode;
        strUserCode = Session["UserCode"].ToString();
        strLangCode = Session["LangCode"].ToString();

        strUserName = Session["UserName"].ToString();
        strUserInfo = LanguageHandle.GetWord("YongHu") + ": " + strUserCode + "  " + strUserName;


        try
        {
            LoadMyProjectList(strUserCode);
            LoadInvolvedProjectList(strUserCode);
            LoadCreateProjectList(strUserCode);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile(err.Message.ToString());
        }
    }

    protected void LoadMyProjectList(string strUserCode)
    {
        string strHQL;

        string strCacheKey = "PS_Pro_My_" + strUserCode;
        DataSet dsCached = HttpRuntime.Cache[strCacheKey] as DataSet;
        if (dsCached != null)
        {
            DataGrid2.DataSource = dsCached;
            DataGrid2.DataBind();
            return;
        }

        strHQL = "Select * from T_Project as project where project.PMCode = " + "'" + strUserCode + "'" + " and project.Status not in ('New',  'Hided','Deleted','Archived')  Order by project.ProjectID DESC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        HttpRuntime.Cache.Insert(strCacheKey, ds, null,
            System.Web.Caching.Cache.NoAbsoluteExpiration,
            TimeSpan.FromMinutes(3));

        DataGrid2.DataSource = ds;
        DataGrid2.DataBind();
    }

    protected void LoadInvolvedProjectList(string strUserCode)
    {
        string strHQL;
        IList lst;

        string strCacheKey = "PS_Pro_Involved_" + strUserCode;
        IList lstCached = HttpRuntime.Cache[strCacheKey] as IList;
        if (lstCached != null)
        {
            DataGrid4.DataSource = lstCached;
            DataGrid4.DataBind();
            return;
        }

        strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.UserCode = " + "'" + strUserCode + "'" + " and proRelatedUser.PMCode <> " + "'" + strUserCode + "'" + "  and proRelatedUser.ProStatus not in ('New','Review','Hided','Deleted','Archived','Pause','Stop') Order by proRelatedUser.ProjectID DESC";
        ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
        lst = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

        HttpRuntime.Cache.Insert(strCacheKey, lst, null,
            System.Web.Caching.Cache.NoAbsoluteExpiration,
            TimeSpan.FromMinutes(3));

        DataGrid4.DataSource = lst;
        DataGrid4.DataBind();
    }

    protected void LoadCreateProjectList(string strUserCode)
    {
        string strHQL;

        string strCacheKey = "PS_Pro_Create_" + strUserCode;
        DataSet dsCached = HttpRuntime.Cache[strCacheKey] as DataSet;
        if (dsCached != null)
        {
            DataGrid8.DataSource = dsCached;
            DataGrid8.DataBind();
            return;
        }

        strHQL = "select C.*,COALESCE(D.TotalBL,0) PercentRea from T_Project C left join (select A.ProjectID,COALESCE(B.TotalRea,0)/CASE WHEN A.Total = 0 Then 1 END as TotalBL from (select " +
                "ProjectID,SUM(Total) Total from T_ProjectCostManage Where Type='Base' group by ProjectID) A left join (select ProjectID,SUM(Total) TotalRea from " +
                "T_ProjectCostManage where Type='Operation' group by ProjectID) B on A.ProjectID=B.ProjectID) D on C.ProjectID=D.ProjectID where C.UserCode='" + strUserCode + "' and " +
                "C.Status not in ('New','Hided','Deleted','Archived') Order by C.ProjectID DESC";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectCost");

        HttpRuntime.Cache.Insert(strCacheKey, ds, null,
            System.Web.Caching.Cache.NoAbsoluteExpiration,
            TimeSpan.FromMinutes(3));

        DataGrid8.DataSource = ds;
        DataGrid8.DataBind();
    }

    protected void DataGrid2_PageIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        DataGrid2.CurrentPageIndex = e.NewPageIndex;

        string strUserCode;

        strUserCode = Session["UserCode"].ToString();


        string strHQL = "from Project as project where project.PMCode = " + "'" + strUserCode + "'" + " and project.Status not in ('New',  'Hided','Deleted','Archived')  Order by project.ProjectID DESC";

        ProjectBLL projectBLL = new ProjectBLL();
        IList lst = projectBLL.GetAllProjects(strHQL);

        DataGrid2.DataSource = lst;
        DataGrid2.DataBind();
    }

    protected void DataGrid4_PageIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        DataGrid4.CurrentPageIndex = e.NewPageIndex;

        string strUserCode;

        strUserCode = Session["UserCode"].ToString();


        string strHQL = "from ProRelatedUser as proRelatedUser where proRelatedUser.UserCode = " + "'" + strUserCode + "'" + " and proRelatedUser.PMCode <> " + "'" + strUserCode + "'" + "  and proRelatedUser.ProStatus not in ('New','Review','Hided','Deleted','Archived','Pause','Stop') Order by proRelatedUser.ProjectID DESC";

        ProjectBLL projectBLL = new ProjectBLL();
        IList lst = projectBLL.GetAllProjects(strHQL);

        DataGrid4.DataSource = lst;
        DataGrid4.DataBind();
    }

    protected void DataGrid8_PageIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        DataGrid8.CurrentPageIndex = e.NewPageIndex;

        string strUserCode;
        strUserCode = Session["UserCode"].ToString();


        string strHQL;
        strHQL = "select C.*,COALESCE(D.TotalBL,0) PercentRea from T_Project C left join (select A.ProjectID,COALESCE(B.TotalRea,0)/CASE WHEN A.Total = 0 Then 1 END as TotalBL from (select " +
                "ProjectID,SUM(Total) Total from T_ProjectCostManage Where Type='Base' group by ProjectID) A left join (select ProjectID,SUM(Total) TotalRea from " +
                "T_ProjectCostManage where Type='Operation' group by ProjectID) B on A.ProjectID=B.ProjectID) D on C.ProjectID=D.ProjectID where C.UserCode='" + strUserCode + "' and " +
                "C.Status not in ('New','Hided','Deleted','Archived') Order by C.ProjectID DESC";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectCost");
        DataGrid8.DataSource = ds;
        DataGrid8.DataBind();
    }


}

