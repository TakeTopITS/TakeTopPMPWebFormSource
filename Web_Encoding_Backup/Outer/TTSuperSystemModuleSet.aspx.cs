using System;
using System.Resources;
using System.Drawing;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using System.Data.SqlClient;
using System.Data.OleDb;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

using TakeTopSecurity;
using System.IO;
using jdk.nashorn.@internal.objects.annotations;
using Microsoft.Web.Management.Client.Win32;
using net.sf.mpxj.primavera.schema;
using static org.apache.poi.poifs.macros.Module;

public partial class TTSuperSystemModuleSet : System.Web.UI.Page
{
    string strLangCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode = Session["UserCode"].ToString();

        strLangCode = Session["LangCode"].ToString();

        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility("TTSystemModuleSet.aspx", strUserCode);  //bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility("TTSystemModuleSet", "SystemModuleSettings", strUserCode);
        if (blVisible == false)
        {
            Response.Redirect("TTDisplayErrors.aspx");
            return;
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            ShareClass.LoadLanguageForDropList(ddlLangSwitcher);
            ddlLangSwitcher.SelectedValue = strLangCode;

            InitialModuleTree("INNER", ddlLangSwitcher.SelectedValue.Trim());
        }
    }

    protected void DL_ForUserType_SelectedIndexChanged(object sender, EventArgs e)
    {
        string strUserType;

        strUserType = DL_ForUserType.SelectedValue.Trim();

        InitialModuleTree(strUserType, ddlLangSwitcher.SelectedValue.Trim());
    }

    protected void InitialModuleTree(string strUserType, string strLangCode)
    {
        string strHQL;

        string strModuleID, strModuleName, strModuleType, strHomeModuleName;

        //添加根节点
        TreeView1.Nodes.Clear();
        TreeNode node1 = new TreeNode();
        TreeNode node2 = new TreeNode();

        node1.Text = "<b>" + LanguageHandle.GetWord("XiTongMoZu") + "<b>";
        node1.Target = "0";
        node1.Expanded = true;
        TreeView1.Nodes.Add(node1);

        strHQL = "Select ID,ModuleName,HomeModuleName,ModuleType From T_ProModuleLevel Where UserType = " + "'" + strUserType + "'" + " and char_length(ParentModule) = 0 ";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";
        strHQL += " Order By ModuleType DESC,SortNumber ASC";
        DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
        {
            strModuleID = ds1.Tables[0].Rows[i][0].ToString();
            strModuleName = ds1.Tables[0].Rows[i][1].ToString();
            strHomeModuleName = ds1.Tables[0].Rows[i][2].ToString();
            strModuleType = ds1.Tables[0].Rows[i][3].ToString().Trim();

            node2 = new TreeNode();

            node2.Text = (i + 1).ToString() + "." + strHomeModuleName;
            node2.Target = strModuleID;
            node2.Expanded = false;

            node1.ChildNodes.Add(node2);

            ModuleTreeShow(strUserType, strModuleType, strModuleName, node2, strLangCode);

            TreeView1.DataBind();
        }
    }

    public static void ModuleTreeShow(string strParentUserType, string strParentModuleType, string strParentModule, TreeNode treeNode, string strLangCode)
    {
        string strHQL;

        string strModuleID, strModuleName, strModuleType, strHomeModuleName;
        TreeNode node1 = new TreeNode();

        if (strParentModuleType == "APP" | strParentModuleType == "DIYAPP")
        {
            strHQL = "Select ID,ModuleName,HomeModuleName,ModuleType From T_ProModuleLevel Where UserType = " + "'" + strParentUserType + "'" + " and ParentModule = " + "'" + strParentModule + "' and ModuleType in ( 'APP','DIYAPP')";
        }
        else
        {
            strHQL = "Select ID,ModuleName,HomeModuleName,ModuleType From T_ProModuleLevel Where UserType = " + "'" + strParentUserType + "'" + " and ParentModule = " + "'" + strParentModule + "'";
        }
        strHQL += " and LangCode = " + "'" + strLangCode + "'";
        strHQL += " Order By SortNumber ASC";
        DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        for (int i = 0; i < ds1.Tables[0].Rows.Count; i++)
        {
            strModuleID = ds1.Tables[0].Rows[i]["ID"].ToString();
            strModuleName = ds1.Tables[0].Rows[i]["ModuleName"].ToString();
            strHomeModuleName = ds1.Tables[0].Rows[i]["HomeModuleName"].ToString();
            strModuleType = ds1.Tables[0].Rows[i]["ModuleType"].ToString().Trim();

            node1 = new TreeNode();
            node1.Text = (i + 1).ToString() + "." + strHomeModuleName;
            node1.Target = strModuleID;

            node1.Expanded = false;

            treeNode.ChildNodes.Add(node1);

            ModuleTreeShow(strParentUserType, strModuleType, strModuleName, node1, strLangCode);
        }
    }

    protected void TreeView1_SelectedNodeChanged(object sender, EventArgs e)
    {
        string strHQL;
        string strModuleID, strModuleName, strModuleType, strUserType;
        int intLevel;

        strUserType = DL_ForUserType.SelectedValue.Trim();
        strLangCode = ddlLangSwitcher.SelectedValue.Trim();

        TreeNode treeNode = new TreeNode();
        treeNode = TreeView1.SelectedNode;

        intLevel = treeNode.Depth;
        LB_Level.Text = intLevel.ToString();

        strModuleID = treeNode.Target.Trim();
        strModuleType = GetLeftModuleType(strModuleID);
        strModuleName = GetLeftModuleName(strModuleID);

        if (strModuleID == "0")
        {
            LB_SelectedModuleName.Text = "";
            LB_HomeSelectedModuleName.Text = "";

            LoadChildModule("", strModuleType, strUserType, strLangCode);
        }
        else
        {
            strHQL = "Select ID,ParentModule,ModuleName,PageName,SortNumber,ModuleType,UserType,Visible,HomeModuleName From T_ProModuleLevel Where ID = " + strModuleID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

            strModuleType = ds.Tables[0].Rows[0][5].ToString().Trim();

            LB_SelectedModuleName.Text = strModuleName;
            LB_HomeSelectedModuleName.Text = ShareClass.GetHomeModuleName(strModuleName, strLangCode);
            LB_ModuleType.Text = strModuleType;

            LoadChildModule(strModuleName, strModuleType, strUserType, strLangCode);
        }
    }

    protected void BT_CheckPWD_Click(object sender, EventArgs e)
    {
        string strPassword = TB_Password.Text.Trim();

        if (strPassword == "TAKETOPZXCZXJXYYZLY@#!")
        {
            LB_Password.Text = strPassword;
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBMYCWJC") + "')", true);
        }

        return;
    }

    protected void ddlLangSwitcher_SelectedIndexChanged(object sender, EventArgs e)
    {
        string strModuleName, strModuleType, strUserType;

        strLangCode = ddlLangSwitcher.SelectedValue.Trim();

        strUserType = DL_ForUserType.SelectedValue.Trim();
        strModuleType = GetLeftModuleType("0");
        strModuleName = GetLeftModuleName("0");

        InitialModuleTree(strUserType, ddlLangSwitcher.SelectedValue.Trim());

        LoadChildModule("", strModuleType, strUserType, strLangCode);
    }


    protected void BT_DeleteUnVisibleModule_Click(object sender, EventArgs e)
    {
        string strHQL;

        if (Page.IsValid)
        {
            Random a = new Random();

            string strPassword = LB_Password.Text.Trim();


            if (strPassword == "TAKETOPZXCZXJXYYZLY@#!")
            {

                strHQL = "Update T_ProModuleLevel Set IsDeleted = 'YES' Where Visible = 'NO'";
                ShareClass.RunSqlCommand(strHQL);

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZYinCangChengGong") + "')", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZMiMaBuDuiYinCangShiBaiQingJi") + "')", true);
            }

            return;
        }
    }


    protected void BT_ClearSystemBeginnerData_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            Random a = new Random();

            string strPassword = LB_Password.Text.Trim();

            if (strPassword == "TAKETOPZXCZXJXYYZLY@#!")
            {
                string strHQL2 = "Update T_SystemDataManageForBeginer Set IsForbit = 'NO' Where OperationName = 'ClearData'";
                ShareClass.RunSqlCommand(strHQL2);

                ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop11", "top.frames[0].frames[2].parent.frames[\"rightTabFrame\"].popShowByURL('Outer/TTSystemDataManageForImplementationBeginner.aspx','SystemDataManage','99%','99%',window.location);", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBMYCWJC") + "')", true);
            }

            return;
        }
    }

    protected void DataGrid4_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            string strHQL;

            string strModuleID, strModuleName, strModuleType, strUserType, strParentModule;
            string strCommandName, strPageName, strOldPageName, strOldModuleType;

            strModuleID = e.Item.Cells[0].Text;
            strModuleName = e.Item.Cells[1].Text;
            strParentModule = e.Item.Cells[4].Text;

            strCommandName = e.CommandName.ToString();

            strOldPageName = GetLeftModulePageName(strModuleID);
            strPageName = ((TextBox)(e.Item.FindControl("TB_PageName"))).Text.Trim();

            strOldModuleType = GetLeftModuleType(strModuleID);
            strModuleType = ((DropDownList)(e.Item.FindControl("DL_ModuleType"))).SelectedValue.Trim();

            strUserType = e.Item.Cells[9].Text;

            for (int i = 0; i < DataGrid4.Items.Count; i++)
            {
                DataGrid4.Items[i].ForeColor = Color.Black;
            }
            e.Item.ForeColor = Color.Red;

            try
            {
                string strPassword = LB_Password.Text.Trim();

                if (strCommandName == "SAVE")
                {
                    if (strPassword == "TAKETOPZXCZXJXYYZLY@#!")
                    {
                        try
                        {
                            strHQL = "Update T_ProModuleLevel Set PageName = '" + strPageName + "',ModuleType = '" + strModuleType + "'";
                            strHQL += " Where PageName = '" + strOldPageName + "'" + " and ModuleType = '" + strOldModuleType + "'";
                            ShareClass.RunSqlCommand(strHQL);

                            strHQL = "Update T_ProModule Set ModuleType = '" + strModuleType + "'";
                            strHQL += " Where ModuleName = '" + strModuleName + "' and ModuleType = '" + strOldModuleType + "' and UserType = '" + strUserType + "'";
                            ShareClass.RunSqlCommand(strHQL);

                            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
                        }
                        catch
                        {
                            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSB") + "')", true);
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBMYCWJC") + "')", true);
                        return;
                    }
                }


                if (strCommandName == "DELETE")
                {
                    if (strPassword == "TAKETOPZXCZXJXYYZLY@#!")
                    {
                        strHQL = "Update T_ProModuleLevel Set IsDeleted = 'YES',Visible ='NO' ";
                        strHQL += " Where ModuleName = '" + strModuleName + "' and ParentModule = '" + strParentModule + "' and ModuleType = '" + strModuleType + "'";
                        ShareClass.RunSqlCommand(strHQL);

                        e.Item.Cells[8].Text = "YES";
                        e.Item.Cells[6].Text = "NO";
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBMYCWJC") + "')", true);
                        return;
                    }
                }

                if (strCommandName == "CancelDelete")
                {
                    if (strPassword == "TAKETOPZXCZXJXYYZLY@#!")
                    {
                        strHQL = "Update T_ProModuleLevel Set IsDeleted = 'NO',Visible ='YES' ";
                        strHQL += " Where ModuleName = '" + strModuleName + "' and ParentModule = '" + strParentModule + "' and ModuleType = '" + strModuleType + "'";
                        ShareClass.RunSqlCommand(strHQL);

                        e.Item.Cells[8].Text = "NO";
                        e.Item.Cells[6].Text = "YES";
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBMYCWJC") + "')", true);
                        return;
                    }
                }

                //设置缓存更改标志，并刷新页面缓存
                ShareClass.ChangePageCache();
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBJC") + "')", true);
            }
        }
    }

    protected void LoadChildModule(string strParentModuleName, string strModuleType, string strUserType, string strLangCode)
    {
        string strHQL;
        string strModuleName, strPageName;

        strLangCode = ddlLangSwitcher.SelectedValue.Trim();

        if (strModuleType != "APP")
        {
            strHQL = " select ID,ParentModule, ModuleName,PageName,SortNumber,ModuleType,UserType,Visible,HomeModuleName,LangCode,IsDeleted,IconURL from T_ProModuleLevel ";
            strHQL += " where UserType = " + "'" + strUserType + "'" + " and ltrim(rtrim(ParentModule)) = " + "'" + strParentModuleName + "'";
            strHQL += " and ModuleType <> 'APP'";
            strHQL += " and LangCode = " + "'" + strLangCode + "'";
            strHQL += " Order By ModuleType DESC";
        }
        else
        {
            strHQL = " select ID,ParentModule, ModuleName,PageName,SortNumber,ModuleType,UserType,Visible,HomeModuleName,LangCode,IsDeleted,IconURL from T_ProModuleLevel ";
            strHQL += " where UserType = " + "'" + strUserType + "'" + " and ltrim(rtrim(ParentModule)) = " + "'" + strParentModuleName + "'";
            strHQL += " and ModuleType = 'APP'";
            strHQL += " and LangCode = " + "'" + strLangCode + "'";
            strHQL += " Order By ModuleType DESC";
        }

        if (strParentModuleName == "")
        {
            strHQL = " select ID,ParentModule, ModuleName,PageName,SortNumber,ModuleType,UserType,Visible,HomeModuleName,LangCode,IsDeleted,IconURL from T_ProModuleLevel ";
            strHQL += " where UserType = " + "'" + strUserType + "'" + " and ltrim(rtrim(ParentModule)) = " + "'" + strParentModuleName + "'";
            strHQL += " and LangCode = " + "'" + strLangCode + "'";
            strHQL += " Order By ModuleType DESC";
        }
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        DataGrid4.DataSource = ds;
        DataGrid4.DataBind();

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strModuleName = ds.Tables[0].Rows[i]["ModuleName"].ToString().Trim();
            strPageName = ds.Tables[0].Rows[i]["PageName"].ToString().Trim();
            strModuleType = ds.Tables[0].Rows[i]["ModuleType"].ToString().Trim();

            ((TextBox)DataGrid4.Items[i].FindControl("TB_PageName")).Text = strPageName;
            ((DropDownList)DataGrid4.Items[i].FindControl("DL_ModuleType")).SelectedValue = strModuleType.Trim();

            if (TakeTopSecurity.TakeTopLicense.IsCanNotDeletedModule(strModuleName))
            {
                ((Button)DataGrid4.Items[i].FindControl("BT_DeleteModule")).Enabled = false;
                ((Button)DataGrid4.Items[i].FindControl("BT_CancelDeleteModule")).Enabled = false;
            }
        }

        LB_ModuleNumber.Text = ds.Tables[0].Rows.Count.ToString();
    }

    protected string GetLeftModuleType(string strModuleID)
    {
        string strHQL = "Select ModuleType From T_ProModuleLevel Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    protected string GetLeftModuleUserType(string strModuleID)
    {
        string strHQL = "Select UserType From T_ProModuleLevel Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    protected string GetLeftModulePageName(string strModuleID)
    {
        string strHQL;

        strHQL = "Select PageName From T_ProModuleLevel Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    protected string GetLeftModuleName(string strModuleID)
    {
        string strHQL = "Select ModuleName From T_ProModuleLevel Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    protected string GetPageModuleType(string strModuleID)
    {
        string strHQL = "Select ModuleType From T_ProModuleLevelForPage Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    protected string GetPageModuleName(string strModuleID)
    {
        string strHQL = "Select ModuleName From T_ProModuleLevelForPage Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }
}
