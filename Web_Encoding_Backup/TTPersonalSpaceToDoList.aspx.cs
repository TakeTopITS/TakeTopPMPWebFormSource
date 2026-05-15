using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.IO;
using System.Resources;
using System.ServiceModel.Security;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class TTPersonalSpaceToDoList : System.Web.UI.Page
{
    int intRunNumber;

    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickParentA", "aHandlerForSpecialPopWindow();", true);
        if (Page.IsPostBack == false)
        {
            //LB_SuperDepartString.Text = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(Session["UserCode"].ToString());

            //清空页面缓存，用于改变皮肤
            SetPageNoCache();

            intRunNumber = 0;

            AsyncWork();
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
            LoadFunInforDialBoxList(strLangCode);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile(err.Message.ToString());
        }
    }


    protected void LoadFunInforDialBoxList(string strLangCode)
    {
        try
        {
            //string strHQL = string.Format(@"
            //WITH UserAccessiblePages AS (
            //    SELECT DISTINCT l.PageName
            //    FROM T_ProModuleLevel l
            //    WHERE l.LangCode = '{0}'
            //        AND l.Visible = 'YES' 
            //        AND l.IsDeleted = 'NO'
            //        AND (
            //            EXISTS (
            //                SELECT 1 FROM T_ProModule m 
            //                WHERE m.Visible = 'YES' 
            //                    AND m.UserCode = '{1}'
            //                    AND m.ModuleName = l.ModuleName
            //            )
            //            OR EXISTS (
            //                SELECT 1 FROM T_ProModule m 
            //                WHERE m.Visible = 'YES' 
            //                    AND m.UserCode = '{1}'
            //                    AND m.ModuleName = l.ParentModule
            //            )
            //            OR l.ParentModule = ''
            //        )
            //)
            //SELECT f.* 
            //FROM T_FunInforDialBox f
            //INNER JOIN UserAccessiblePages p ON f.LinkAddress = p.PageName
            //WHERE f.Status = 'Enabled' 
            //    AND f.LangCode = '{0}'
            //ORDER BY f.SortNumber ASC", strLangCode, Session["UserCode"]?.ToString());

            string strHQL = string.Format(@"
        SELECT DISTINCT f.* 
        FROM T_FunInforDialBox f
        INNER JOIN T_ProModuleLevel l ON f.LinkAddress = l.PageName 
            AND f.LangCode = l.LangCode
        WHERE f.Status = 'Enabled' 
            AND f.LangCode = '{0}'
            AND l.LangCode = '{0}'
            AND l.Visible = 'YES' 
            AND l.IsDeleted = 'NO'
            AND EXISTS (
                SELECT 1 FROM T_ProModule m 
                WHERE m.Visible = 'YES' 
                    AND m.UserCode = '{1}'
                    AND (
                        m.ModuleName = l.ModuleName 
                        OR m.ModuleName = l.ParentModule
                    )
            )
        ORDER BY f.SortNumber ASC", strLangCode, Session["UserCode"]?.ToString());

            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_FunInforDialBox");

            RP_ToDoList.DataSource = ds;
            RP_ToDoList.DataBind();
        }
        catch (Exception ex)
        {
            // 记录日志
            LogClass.WriteLogFile($"LoadFunInforDialBoxList Error: {ex.Message}");
            RP_ToDoList.DataSource = null;
            RP_ToDoList.DataBind();
        }
    }

    protected string GetNumberCount(string strSQLCode)
    {
        string strHQL;
        string strSuperDepartString;
        string strUserCode;
        strUserCode = Session["UserCode"].ToString();

        strSuperDepartString = LB_SuperDepartString.Text.Trim();

        try
        {
            strHQL = strSQLCode.Trim().Replace("[TAKETOPUSERCODE]", strUserCode);
            //strHQL = strHQL.Replace("[TAKETOPSUPERDEPARTSTRING]", strSuperDepartString);

            DataSet ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "FunInforDialBoxList");

            return ds.Tables[0].Rows.Count.ToString();
        }
        catch
        {
            return "0";
        }
    }
}