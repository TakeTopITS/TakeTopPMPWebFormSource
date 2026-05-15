using System;
using System.Collections;
using System.Collections.Generic;

using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using ProjectMgt.BLL;
using ProjectMgt.Model;

using Stimulsoft.Base.Gauge.GaugeGeoms;

public partial class TakeTopMainSkinSelect : System.Web.UI.Page
{
    private string strUserType;

    protected void Page_Load(object sender, EventArgs e)
    {
        string strHQL;

        string strUserCode = Session["UserCode"].ToString();

        strUserType = ShareClass.GetUserType(strUserCode);

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            strHQL = "Select * From T_SystemLanguage Order By SortNumber ASC";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Language");

            RP_Language.DataSource = ds;
            RP_Language.DataBind();
        }
    }

    protected void RP_Language_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            string strHQL;
            string strLangCode;

            DataSet ds;

            string strUserCode = Session["UserCode"].ToString();
            strLangCode = ((Button)e.Item.FindControl("BT_Language")).ToolTip.Trim();

            try
            {
                strHQL = string.Format(@"SELECT Count(*) FROM T_ProModuleLevel Where LangCode = '{0}'", strLangCode);
                ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");
                if (Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString()) == 0)
                {
                    CopyAllLeftModuleForHomeLanguage(strLangCode);
                    UpdateLeftBarModules(strLangCode);
                }

                CopyBaseDataInnerFromHomeLanguage(strLangCode);
                CopyNewTypeFromHomeLanguage(strLangCode);
                CopyAlActorGroupForHomeLanguage(strLangCode);
                CopyCommonWorkflowRelatedPageForHomeLanguage(strLangCode);
            }
            catch (System.Exception err)
            {
                LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
            }

            try
            {
                strHQL = string.Format(@"SELECT Count(*) FROM T_ProModuleLevelForPage Where LangCode = '{0}'", strLangCode);
                ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");
                if (Convert.ToInt32(ds.Tables[0].Rows[0][0].ToString()) == 0)
                {
                    CopyAllPageModuleForHomeLanguage(strLangCode);
                    UpdatePageBarModules(strLangCode);
                }
            }
            catch (System.Exception err)
            {
                LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
            }


            ((Button)e.Item.FindControl("BT_Language")).ForeColor = System.Drawing.Color.Black;

            strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
            ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
            IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

            ProjectMember projectMember = (ProjectMember)lst[0];

            projectMember.LangCode = strLangCode;
            try
            {
                projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

                Session["CssDirectory"] = projectMember.CssDirectory.Trim();
                Session["LangCode"] = strLangCode;
                Response.SetCookie(new HttpCookie("LangCode", strLangCode));


                //保存模组流程图到数据库中，供模组设计或修改页面调用
                Session["ModuleFlowChartString"] = ShareClass.SaveModuleFlowchartToDatabaseForDesignOrChangePage();

                //设置缓存更改标志
                ChangePageCache("Language");

                //重新打开相应的主页，以刷新页面
                OpenTopMDIPage(strUserType, projectMember.CssDirectory.Trim() + projectMember.LangCode.Trim());
            }
            catch
            {
            }
        }
    }

    protected void BT_Black_Click(object sender, EventArgs e)
    {
        string strUserCode = Session["UserCode"].ToString();

        string strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        ProjectMember projectMember = (ProjectMember)lst[0];

        projectMember.CssDirectory = BT_Black.ToolTip;

        try
        {
            projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

            Session["CssDirectory"] = BT_Black.ToolTip;

            //设置缓存更改标志
            ChangePageCache("Skin");

            //重新打开相应的主页，以刷新页面
            OpenTopMDIPage(strUserType, projectMember.CssDirectory.Trim() + projectMember.LangCode.Trim());
        }
        catch
        {
        }
    }

    protected void BT_Green_Click(object sender, EventArgs e)
    {
        string strUserCode = Session["UserCode"].ToString();

        string strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        ProjectMember projectMember = (ProjectMember)lst[0];

        projectMember.CssDirectory = BT_Green.ToolTip;

        try
        {
            projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

            Session["CssDirectory"] = BT_Green.ToolTip;

            //设置缓存更改标志
            ChangePageCache("Skin");

            //重新打开相应的主页，以刷新页面
            OpenTopMDIPage(strUserType, projectMember.CssDirectory.Trim() + projectMember.LangCode.Trim());
        }
        catch
        {
        }
    }

    protected void BT_Grey_Click(object sender, EventArgs e)
    {
        string strUserCode = Session["UserCode"].ToString();

        string strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        ProjectMember projectMember = (ProjectMember)lst[0];

        projectMember.CssDirectory = BT_Grey.ToolTip;

        try
        {
            projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

            Session["CssDirectory"] = BT_Grey.ToolTip;

            //设置缓存更改标志
            ChangePageCache("Skin");

            //重新打开相应的主页，以刷新页面
            OpenTopMDIPage(strUserType, projectMember.CssDirectory.Trim() + projectMember.LangCode.Trim());
        }
        catch
        {
        }
    }

    protected void BT_Red_Click(object sender, EventArgs e)
    {
        string strUserCode = Session["UserCode"].ToString();

        string strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        ProjectMember projectMember = (ProjectMember)lst[0];

        projectMember.CssDirectory = BT_Red.ToolTip;

        try
        {
            projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

            Session["CssDirectory"] = BT_Red.ToolTip;

            //设置缓存更改标志
            ChangePageCache("Skin");

            //重新打开相应的主页，以刷新页面
            OpenTopMDIPage(strUserType, projectMember.CssDirectory.Trim() + projectMember.LangCode.Trim());
        }
        catch
        {
        }
    }

    //protected void BT_Gradient_Click(object sender, EventArgs e)
    //{
    //    string strUserCode = Session["UserCode"].ToString();

    //    string strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
    //    ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
    //    IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

    //    ProjectMember projectMember = (ProjectMember)lst[0];

    //    projectMember.CssDirectory = BT_Gradient.ToolTip;

    //    try
    //    {
    //        projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

    //        Session["CssDirectory"] = BT_Gradient.ToolTip;

    //        //设置缓存更改标志
    //        ChangePageCache("Skin");

    //        //重新打开相应的主页，以刷新页面
    //        OpenTopMDIPage(strUserType, projectMember.CssDirectory.Trim() + projectMember.LangCode.Trim());
    //    }
    //    catch
    //    {
    //    }
    //}

    //protected void BT_Blue_Click(object sender, EventArgs e)
    //{
    //    string strUserCode = Session["UserCode"].ToString();

    //    string strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
    //    ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
    //    IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

    //    ProjectMember projectMember = (ProjectMember)lst[0];

    //    projectMember.CssDirectory = BT_Blue.ToolTip;

    //    try
    //    {
    //        projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

    //        Session["CssDirectory"] = BT_Blue.ToolTip;

    //        //设置缓存更改标志
    //        ChangePageCache("Skin");

    //        //重新打开相应的主页，以刷新页面
    //        OpenTopMDIPage(strUserType, projectMember.CssDirectory.Trim() + projectMember.LangCode.Trim());
    //    }
    //    catch
    //    {
    //    }
    //}

    //protected void BT_Gold_Click(object sender, EventArgs e)
    //{
    //    string strUserCode = Session["UserCode"].ToString();

    //    string strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
    //    ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
    //    IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

    //    ProjectMember projectMember = (ProjectMember)lst[0];

    //    projectMember.CssDirectory = BT_Gold.ToolTip;

    //    try
    //    {
    //        projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

    //        Session["CssDirectory"] = BT_Gold.ToolTip;

    //        //设置缓存更改标志
    //        ChangePageCache("Skin");

    //        //重新打开相应的主页，以刷新页面
    //        OpenTopMDIPage(strUserType, projectMember.CssDirectory.Trim() + projectMember.LangCode.Trim());
    //    }
    //    catch
    //    {
    //    }
    //}

    //复制所有左边栏模组
    protected void CopyAllLeftModuleForHomeLanguage(string strLangCode)
    {
        string strHQL;

        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];

        strHQL = "Insert Into T_ProModuleLevel(ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible,LangCode,HomeModuleName,IsDeleted,IconURL,ModuleDefinition)";
        strHQL += " SELECT ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible," + "'" + strLangCode + "'" + ",HomeModuleName,IsDeleted,IconURL,ModuleDefinition FROM T_ProModuleLevel";
        strHQL += " Where LangCode = '" + strFromLangCode + "' and trim(ModuleName) || trim(ParentModule) || trim(ModuleType) || trim(UserType)  Not in (Select rtrim(ModuleName) || trim(ParentModule) || trim(ModuleType) || trim(UserType) From T_ProModuleLevel Where LangCode = " + "'" + strLangCode + "'" + ")";
        ShareClass.RunSqlCommand(strHQL);

        strHQL = "Update T_ProModuleLevel B Set SortNumber = A.SortNumber From T_ProModuleLevel A Where A.ModuleName = B.ModuleName and A.LangCode = '" + strFromLangCode + "' AND B.LangCode =" + "'" + strLangCode + "'";
        ShareClass.RunSqlCommand(strHQL);

        strHQL = "Delete From T_ProModuleLevel Where LangCode = " + "'" + strLangCode + "'" + " and ModuleType in ('SYSTEM','APP')";
        strHQL += " and trim(ModuleName) || trim(ParentModule) || trim(ModuleType) || trim(UserType)  Not in (Select trim(ModuleName) || trim(ParentModule) || trim(ModuleType) || trim(UserType) From T_ProModuleLevel Where LangCode = '" + strFromLangCode + "')";
        ShareClass.RunSqlCommand(strHQL);
    }


    //复制所有页面模组
    protected void CopyAllPageModuleForHomeLanguage(string strLangCode)
    {
        string strHQL;
        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];

        strHQL = "Insert Into T_ProModuleLevelForPage(ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible,LangCode,HomeModuleName,IsDeleted,IconURL)";
        strHQL += " SELECT ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible," + "'" + strLangCode + "'" + ",HomeModuleName,IsDeleted,IconURL FROM T_ProModuleLevelForPage";
        strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType))  Not in (Select ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType)) From T_ProModuleLevelForPage Where LangCode = " + "'" + strLangCode + "'" + ")";
        ShareClass.RunSqlCommand(strHQL);

        strHQL = "Update T_ProModuleLevelForPage B Set SortNumber = A.SortNumber,Visible = A.Visible,IsDeleted = A.IsDeleted From T_ProModuleLevelForPage A Where A.ModuleName = B.ModuleName and A.ParentModule = B.ParentModule and A.LangCode = '" + strFromLangCode + "' AND B.LangCode =" + "'" + strLangCode + "'";
        ShareClass.RunSqlCommand(strHQL);

        strHQL = "Delete From T_ProModuleLevelForPage Where LangCode = " + "'" + strLangCode + "'" + " and ModuleType in ('SYSTEM','APP')";
        strHQL += " and ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType))  Not in (Select ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType)) From T_ProModuleLevelForPage Where LangCode = '" + strFromLangCode + "')";
        ShareClass.RunSqlCommand(strHQL);
    }

    //更新左边样模组
    protected void UpdateLeftBarModules(string strLangCode)
    {
        string strHQL1 = "";
        string strExcelLangCode, strModuleName, strParentModule, strHomeModuleName, strPageName, strModuleType, strUserType, strVisible, strIsDeleted, strSortNUmber, strIconURL;

        DataSet ds1;
        DataTable dt1;

        dt1 = new DataTable();

        string strpath = Server.MapPath("UpdateCode\\Language\\Module\\LeftModules.xls");
        dt1 = MSExcelHandler.ReadExcelToDataTable(strpath, "");

        DataRow[] dr = dt1.Select();  //定义一个DataRow数组
        int rowsnum = dt1.Rows.Count;
        if (rowsnum == 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGEXCELBWKBWSJ") + "')", true);
        }
        else
        {
            for (int i = 0; i < dr.Length; i++)
            {
                try
                {
                    strModuleName = dr[i]["ModuleName"].ToString().Trim();
                    strParentModule = dr[i]["ParentModule"].ToString().Trim();
                    strExcelLangCode = dr[i]["LangCode"].ToString().Trim();
                    strHomeModuleName = dr[i]["HomeModuleName"].ToString().Trim();
                    strPageName = dr[i]["PageName"].ToString().Trim();
                    strModuleType = dr[i]["ModuleType"].ToString().Trim();
                    strUserType = dr[i]["UserType"].ToString().Trim();
                    strVisible = dr[i]["Visible"].ToString().Trim();
                    strIsDeleted = dr[i]["IsDeleted"].ToString().Trim();
                    strSortNUmber = dr[i]["SortNumber"].ToString().Trim();
                    strIconURL = dr[i]["IconURL"].ToString().Trim();
                    strIconURL = strIconURL.Replace("//", "/");
                    strIconURL = strIconURL.Replace("\\", "/");

                    if (strLangCode == strExcelLangCode)
                    {
                        strHQL1 = "Select * From T_ProModuleLevel Where ParentModule = '" + strParentModule + "' and ModuleName = '" + strModuleName + "' and ModuleType = '" + strModuleType + "' and LangCode='" + strLangCode + "' and UserType = '" + strUserType + "'";
                        ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_ProModuleLevel");
                        if (ds1.Tables[0].Rows.Count > 0)
                        {
                            strHQL1 = "Update T_ProModuleLevel Set HomeModuleName = '" + strHomeModuleName.Replace("'", "").Replace("\"", "").Replace("\\", "") + "'" + ",IconURL = " + "'" + strIconURL + "'";
                            strHQL1 += " Where ParentModule = '" + strParentModule + "' and ModuleName = '" + strModuleName + "' and LangCode='" + strLangCode + "' and ModuleType = '" + strModuleType + "' and UserType = '" + strUserType + "'";

                            ShareClass.RunSqlCommand(strHQL1);
                        }
                    }
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace + " :" + strHQL1);
                }
            }

            string strDefaultLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            strHQL1 = string.Format(@"UPDATE T_ProModuleLevel B
                        SET SortNumber = A.SortNumber
                        FROM T_ProModuleLevel A
                        WHERE A.ModuleName = B.ModuleName 
                        AND A.ModuleType = B.ModuleType 
                        AND A.UserType = B.UserType 
                        AND A.LangCode <> B.LangCode 
                        AND A.LangCode = '{0}'", strDefaultLangCode);
            ShareClass.RunSqlCommand(strHQL1);
        }
    }

    //更新页面模组
    protected void UpdatePageBarModules(string strLangCode)
    {
        string strHQL1 = "";
        string strModuleName, strParentModule, strExcelLangCode, strHomeModuleName, strPageName, strModuleType, strUserType, strVisible, strIsDeleted, strSortNUmber, strIconURL;

        DataSet ds1;

        string strpath = Server.MapPath("UpdateCode\\Language\\Module\\PageModules.xls");

        DataTable dt1;
        dt1 = new DataTable();
        dt1 = MSExcelHandler.ReadExcelToDataTable(strpath, "");
        DataRow[] dr = dt1.Select();  //定义一个DataRow数组
        int rowsnum = dt1.Rows.Count;

        if (rowsnum == 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGEXCELBWKBWSJ") + "')", true);
        }
        else
        {
            for (int i = 0; i < dr.Length; i++)
            {
                try
                {
                    strModuleName = dr[i]["ModuleName"].ToString().Trim();
                    strParentModule = dr[i]["ParentModule"].ToString().Trim();
                    strExcelLangCode = dr[i]["LangCode"].ToString().Trim();
                    strHomeModuleName = dr[i]["HomeModuleName"].ToString().Trim();
                    strPageName = dr[i]["PageName"].ToString().Trim();
                    strModuleType = dr[i]["ModuleType"].ToString().Trim();
                    strUserType = dr[i]["UserType"].ToString().Trim();
                    strVisible = dr[i]["Visible"].ToString().Trim();
                    strIsDeleted = dr[i]["IsDeleted"].ToString().Trim();
                    strSortNUmber = dr[i]["SortNumber"].ToString().Trim();
                    strIconURL = dr[i]["IconURL"].ToString().Trim();
                    strIconURL = strIconURL.Replace("//", "/");
                    strIconURL = strIconURL.Replace("\\", "/");

                    if (strLangCode == strExcelLangCode)
                    {
                        strHQL1 = "Select * From T_ProModuleLevelForPage  Where ParentModule = '" + strParentModule + "' and ModuleName = '" + strModuleName + "' and ModuleType = '" + strModuleType + "' and LangCode='" + strLangCode + "' and UserType = '" + strUserType + "'";
                        ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_ProModuleLevel");
                        if (ds1.Tables[0].Rows.Count > 0)
                        {
                            strHQL1 = "Update T_ProModuleLevelForPage Set HomeModuleName = '" + strHomeModuleName.Replace("'", "").Replace("\"", "").Replace("\\", "") + "'" + ",IconURL = " + "'" + strIconURL + "'";
                            strHQL1 += " Where ParentModule = '" + strParentModule + "' and ModuleName = '" + strModuleName + "' and LangCode='" + strLangCode + "' and ModuleType = '" + strModuleType + "' and UserType = " + "'" + strUserType + "'";

                            ShareClass.RunSqlCommand(strHQL1);
                        }
                    }
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace + " :" + strHQL1);
                }
            }

            string strDefaultLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            strHQL1 = string.Format(@"UPDATE T_ProModuleLevelForPage B
                        SET SortNumber = A.SortNumber
                        FROM T_ProModuleLevelForPage A
                        WHERE A.ModuleName = B.ModuleName 
                        AND A.ModuleType = B.ModuleType 
                        AND A.UserType = B.UserType 
                        AND A.LangCode <> B.LangCode 
                        AND A.LangCode = '{0}'", strDefaultLangCode);
            ShareClass.RunSqlCommand(strHQL1);
        }
    }

    protected void CopyBaseDataInnerFromHomeLanguage(string strLangCode)
    {
        string strHQL;

        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
        try
        {
            strHQL = "Insert Into T_WLType(Type,SortNumber ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT Type,SortNumber ,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_WLType";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Type)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(Type)) || ltrim(rtrim(LangCode))  From T_WLType Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_ProjectStatus(Status,SortNumber ,ReviewControl ,ProjectType ,IdentityString ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT Status,SortNumber ,ReviewControl ,ProjectType ,IdentityString,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_ProjectStatus";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Status)) || " + "'" + strLangCode + "'" + " || ltrim(rtrim(ProjectType)) Not in (Select ltrim(rtrim(Status)) || ltrim(rtrim(LangCode)) || ltrim(rtrim(ProjectType)) From T_ProjectStatus Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_ReqStatus(Status,SortNumber ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT Status,SortNumber ,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_ReqStatus";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Status)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(Status)) || ltrim(rtrim(LangCode))  From T_ReqStatus Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_PlanStatus(Status,SortNumber ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT Status,SortNumber ,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_PlanStatus";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Status)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(Status)) || ltrim(rtrim(LangCode))  From T_PlanStatus Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_TaskStatus(Status,SortNumber ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT Status,SortNumber ,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_TaskStatus";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Status)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(Status)) || ltrim(rtrim(LangCode))  From T_TaskStatus Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_TestStatus(Status,SortNumber ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT Status,SortNumber ,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_TestStatus";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Status)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(Status)) || ltrim(rtrim(LangCode))  From T_TestStatus Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_WLStatus(Status,SortNumber ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT Status,SortNumber ,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_WLStatus";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Status)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(Status)) || ltrim(rtrim(LangCode))  From T_WLStatus Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_ActorGroup(GroupName,MakeUserCode,Type,IdentifyString,BelongDepartCode,BelongDepartName,SortNumber ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT GroupName,MakeUserCode,Type,IdentifyString,BelongDepartCode,BelongDepartName,SortNumber ,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_ActorGroup";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(GroupName)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(GroupName)) || ltrim(rtrim(LangCode))  From T_ActorGroup Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_OtherStatus(Status,SortNumber ,MakeType,LangCode,HomeName )";
            strHQL += " SELECT Status,SortNumber ,MakeType ," + "'" + strLangCode + "'" + ",HomeName FROM T_OtherStatus";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Status)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(Status)) || ltrim(rtrim(LangCode))  From T_OtherStatus Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_FunInforDialBox(InforName,SQLCode ,Status,CreateTime,BoxType,LinkAddress ,IsSendMsg ,IsSendEmail,SortNumber,MobileLinkAddress ,IsForceInfor,UserType,HomeName,LangCode)";
            strHQL += " Select InforName,SQLCode ,Status,CreateTime,BoxType,LinkAddress ,IsSendMsg ,IsSendEmail,SortNumber,MobileLinkAddress ,IsForceInfor,UserType,HomeName," + "'" + strLangCode + "'" + " From T_FunInforDialBox";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(InforName)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(InforName)) || ltrim(rtrim(LangCode))  From T_FunInforDialBox Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = string.Format(@"INSERT INTO T_RentProductType(Type, ENType, HomeTypeName, DemoURL, SortNumber,LangCode) 
                SELECT Type ,ENType ,HomeTypeName,DemoURL,SortNumber,'{1}' From T_RentProductType
                   Where LangCode = '{0}' and Type Not In (Select Type From T_RentProductType Where LangCode = '{1}')", strFromLangCode, strLangCode);
            ShareClass.RunSqlCommand(strHQL);

            strHQL = string.Format(@"INSERT INTO t_rentproductvertype(Type, HomeTypeName, SortNumber,LangCode) 
                SELECT Type ,HomeTypeName,SortNumber,'{1}' From t_rentproductvertype
                   Where LangCode = '{0}' and Type Not In (Select Type From t_rentproductvertype Where LangCode = '{1}')", strFromLangCode, strLangCode);
            ShareClass.RunSqlCommand(strHQL);

            strHQL = string.Format(@"INSERT INTO T_TryProductResontype(Type, HomeTypeName,  SortNumber,LangCode) 
                SELECT Type ,HomeTypeName,SortNumber,'{1}' From T_TryProductResontype
                   Where LangCode = '{0}' and Type Not In (Select Type From T_TryProductResontype Where LangCode = '{1}')", strFromLangCode, strLangCode);
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (System.Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    protected void CopyNewTypeFromHomeLanguage(string strLangCode)
    {
        string strHQL;
        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
        try
        {
            strHQL = "Insert Into T_NewsType(Type,SortNumber,PageName,LangCode,HomeName,Visible,NewsScope)";
            strHQL += " SELECT Type,SortNumber ,PageName," + "'" + strLangCode + "'" + ",HomeName,Visible,NewsScope FROM T_NewsType";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(Type)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(Type)) || ltrim(rtrim(LangCode))  From T_NewsType Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    protected void CopyAlActorGroupForHomeLanguage(string strLangCode)
    {
        string strHQL, strLangHQL;
        string strToLangCode;

        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];

        strLangHQL = "Select LangCode From T_SystemLanguage Where LangCode <> " + "'" + strFromLangCode + "'";
        strLangHQL += " Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strLangHQL, "T_SystemLanguage");

        try
        {
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                strToLangCode = ds.Tables[0].Rows[i][0].ToString().Trim();

                strHQL = string.Format(@"INSERT INTO public.t_actorgroup(
	                    groupname, makeusercode, type, identifystring, belongdepartcode, belongdepartname, langcode, homename, maketype, sortnumber)
	                    Select groupname, makeusercode, type, identifystring, belongdepartcode, belongdepartname, '{1}', homename, maketype, sortnumber
	                    FRom t_actorgroup Where LangCode = '{0}' and GroupName Not In (Select GroupName From T_Actorgroup Where LangCode = '{1}');", strFromLangCode, strToLangCode);

                ShareClass.RunSqlCommand(strHQL);
            }

        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    protected void CopyCommonWorkflowRelatedPageForHomeLanguage(string strLangCode)
    {
        string strHQL;

        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
        try
        {
            strHQL = "Insert Into T_CommonWorkflowRelatedPage(FormName,SortNumber ,PageName,LangCode,HomeName )";
            strHQL += " SELECT FormName,SortNumber ,PageName ," + "'" + strLangCode + "'" + ",HomeName FROM T_CommonWorkflowRelatedPage";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(FormName)) || " + "'" + strLangCode + "'" + " Not in (Select ltrim(rtrim(FormName)) || ltrim(rtrim(LangCode))  From T_CommonWorkflowRelatedPage Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }



    //设置缓存更改标志，并刷新页面缓存
    protected void ChangePageCache(string strClickType)
    {
        ////设置缓存更改标志
        //ShareClass.SetPageCacheMark("1");
        //Session["CssDirectoryChangeNumber"] = "1";

        //临时用法，设为上面的1才会刷新页面级存
        ShareClass.SetPageCacheMark("2");
        Session["CssDirectoryChangeNumber"] = "2";

        ShareClass.ChangePageCache();
    }

    //打开相应的主页
    protected void OpenTopMDIPage(string strUserType, string strSkinFlag)
    {
        //设置主界面链接的URL参数，以刷新缓存
        Session["SkinFlag"] = strSkinFlag;

        if (Session["SystemVersionType"].ToString() == "SAAS")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "redirectToSAASTopPage();", true);
        }
        else
        {
            if (strUserType == "INNER")
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "redirectToInnerTopPage();", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "redirectToOuterTopPage();", true);
            }
        }
    }


}