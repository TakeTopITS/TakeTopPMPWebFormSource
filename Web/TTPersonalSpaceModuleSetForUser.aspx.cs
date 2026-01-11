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
using System.IO;

using System.Data.SqlClient;
using System.Data.OleDb;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

using TakeTopSecurity;
using NPOI.SS.Formula.Functions;

public partial class TTPersonalSpaceModuleSetForUser : System.Web.UI.Page
{
    string strLangCode, strUserCode, strUserType;
    string strForbitModule;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strUserType = Session["UserType"].ToString();
        strLangCode = Session["LangCode"].ToString();


        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            LoadUserModule(strUserCode, strUserType, strLangCode);

            if (ShareClass. checkUserHasModuleRight("NewsTypeSetting", strUserCode))
            {
                LoadNewsTypeList(strLangCode);
                DataGrid4.Visible = true;
            }
            else
            {
                DataGrid4.Visible = false;
            }
        }
    }

    protected void BT_ModuleSave_Click(object sender, EventArgs e)
    {
        try
        {
            SaveNewsTypeList();
            SavePersonalSpaceModuleList();

            Session["IsUpdatePersonalSpace"] = "YES";


            ////为刷新个人空间缓存，添加空行
            //ShareClass.AddSpaceLineToPersonalSpaceForRefreshCache();

            //设置缓存更改标志，并刷新页面缓存
            ShareClass.ChangePageCache();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click111", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click222", "reloadPrentPage();", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSBJC") + "')", true);
        }
    }


    protected void SaveNewsTypeList()
    {
        string strHQL;
        string strID,strType, strVisible, strNewsScoope;
        int j = 0, intSortNumber;


        for (j = 0; j < DataGrid1.Items.Count; j++)
        {
            strID = DataGrid1.Items[j].Cells[0].Text;
            strType = DataGrid1.Items[j].Cells[1].Text.Trim();

            if (((CheckBox)DataGrid1.Items[j].FindControl("CB_Visible")).Checked)
            {
                strVisible = "YES";
            }
            else
            {
                strVisible = "NO";
            }

            strNewsScoope = ((DropDownList)DataGrid1.Items[j].FindControl("DL_NewsScope")).SelectedValue;
            intSortNumber = int.Parse(((TextBox)(DataGrid1.Items[j].FindControl("TB_SortNumber"))).Text.Trim());

            strHQL = string.Format(@"Update T_NewsType Set Visible = '{0}',NewsScope='{1}',SortNumber = {2} Where type = '{3}'", strVisible, strNewsScoope, intSortNumber.ToString(), strType);
            ShareClass.RunSqlCommand(strHQL);
        }
    }


    protected void SavePersonalSpaceModuleList()
    {
        string strHQL;
        string strID,strModuleName, strVisible;

        int j = 0, intSortNumber, intEveryRowColumnNumber;


        for (j = 0; j < DataGrid4.Items.Count; j++)
        {
            strModuleName = DataGrid4.Items[j].Cells[0].Text.Trim();

            intSortNumber = int.Parse(((TextBox)(DataGrid4.Items[j].FindControl("TB_SortNumber"))).Text.Trim());

            intEveryRowColumnNumber = int.Parse(((DropDownList)(DataGrid4.Items[j].FindControl("DL_EveryRowColumnNumber"))).SelectedValue.Trim());

            strHQL = "Update T_ProModuleLevelForPageUser Set SortNumber = " + intSortNumber.ToString() + ",EveryRowColumnNumber = " + intEveryRowColumnNumber.ToString() + " Where ModuleName = " + "'" + strModuleName + "'" + " And userCode = " + "'" + strUserCode + "'";
            ShareClass.RunSqlCommand(strHQL);

            if (((CheckBox)DataGrid4.Items[j].FindControl("CB_ModuleVisible")).Checked)
            {
                strVisible = "YES";
            }
            else
            {
                strVisible = "NO";
            }

            strHQL = "Update T_ProModuleLevelForPageUser Set Visible = " + "'" + strVisible + "'" + " Where ModuleName = " + "'" + strModuleName + "'" + " And userCode = " + "'" + strUserCode + "'";
            ShareClass.RunSqlCommand(strHQL);
        }
    }

    protected void LoadNewsTypeList(string strLangCode)
    {
        string strVisible, strNewsScope;

        string strHQL = "Select * From T_NewsType  Where LangCode = " + "'" + strLangCode + "'";
        strHQL += " Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_NewsType");
        DataGrid1.DataSource = ds;
        DataGrid1.DataBind();


        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strVisible = ds.Tables[0].Rows[i]["Visible"].ToString().Trim();

            if (strVisible == "YES")
            {
                ((CheckBox)DataGrid1.Items[i].FindControl("CB_Visible")).Checked = true;
            }
            else
            {
                ((CheckBox)DataGrid1.Items[i].FindControl("CB_Visible")).Checked = false;
            }

            strNewsScope = ds.Tables[0].Rows[i]["NewsScope"].ToString().Trim();
            ((DropDownList)DataGrid1.Items[i].FindControl("DL_NewsScope")).SelectedValue = strNewsScope;
        }
    }

    protected void LoadUserModule(string strUserCode, string strUserType, string strLangCode)
    {
        string strHQL;
        string strSortNumber, strEveryRowColumnNumber, strVisible, strModuleName;

        if (Session["SystemVersionType"].ToString() != "SAAS")
        {
            if (strUserType == "INNER")
            {
                strHQL = string.Format(@"Insert Into T_ProModuleLevelForPageUser(ModuleName,UserCode,UserType,Visible,SortNumber,EveryRowColumnNumber)
                Select ModuleName,'{1}','{2}',Visible,SortNumber,2 From t_promodulelevelforpage
	            Where ParentModule = 'PersonalSpace'  and LangCode = '{0}' and Visible = 'YES' and IsDeleted = 'NO'
		        and ModuleName Not In (Select ModuleName From T_ProModuleLevelForPageUser Where UserCode = '{1}' And UserType ='{2}');", strLangCode, strUserCode, strUserType);
                ShareClass.RunSqlCommand(strHQL);

                strHQL = string.Format(@"select distinct A.ModuleName,B.homemodulename,A.SortNumber,A.Visible,A.EveryRowColumnNumber from T_ProModuleLevelForPageUser A,T_ProModuleLevelForPage B 
                       where A.ModuleName = B.ModuleName and B.Visible = 'YES' and B.IsDeleted = 'NO' and A.UserCode = '{0}' and A.UserType = '{1}' and B.LangCode = '{2}' 
                       and B.ParentModule = 'PersonalSpace' Order By SortNumber ASC", strUserCode, strUserType, strLangCode);
            }
            else
            {
                strHQL = string.Format(@"Insert Into T_ProModuleLevelForPageUser(ModuleName,UserCode,UserType,Visible,SortNumber,EveryRowColumnNumber)
                Select ModuleName,'{1}','{2}',Visible,SortNumber,2 From t_promodulelevelforpage
	            Where ParentModule = 'ExternalPersonalSpace'  and LangCode = '{0}' and Visible = 'YES' and IsDeleted = 'NO'
		        and ModuleName Not In (Select ModuleName From T_ProModuleLevelForPageUser Where UserCode = '{1}' And UserType ='{2}');", strLangCode, strUserCode,strUserType);
                ShareClass.RunSqlCommand(strHQL);

                strHQL = string.Format(@"select distinct A.ModuleName,B.homemodulename,A.SortNumber,A.Visible,A.EveryRowColumnNumber from T_ProModuleLevelForPageUser A,T_ProModuleLevelForPage B 
                       where A.ModuleName = B.ModuleName and B.Visible = 'YES' and B.IsDeleted = 'NO' and A.UserCode = '{0}' and A.UserType = '{1}' and B.LangCode = '{2}' 
                       and B.ParentModule = 'ExternalPersonalSpace' Order By SortNumber ASC", strUserCode, strUserType, strLangCode);
            }
        }
        else
        {
            strHQL = string.Format(@"Insert Into T_ProModuleLevelForPageUser(ModuleName,UserCode,UserType,Visible,SortNumber,EveryRowColumnNumber)
                Select ModuleName,'{1}','{2}',Visible,SortNumber,2 From t_promodulelevelforpage
	            Where ParentModule = 'PersonalSpaceSaaS'  and LangCode = '{0}' and Visible = 'YES' and IsDeleted = 'NO'
		        and ModuleName Not In (Select ModuleName From T_ProModuleLevelForPageUser Where UserCode = '{1}' And UserType ='{2}');", strLangCode, strUserCode, strUserType);
            ShareClass.RunSqlCommand(strHQL);

            strHQL = string.Format(@"select distinct A.ModuleName,B.homemodulename,A.SortNumber,A.Visible,A.EveryRowColumnNumber from T_ProModuleLevelForPageUser A,T_ProModuleLevelForPage B 
                       where A.ModuleName = B.ModuleName and B.Visible = 'YES' and B.IsDeleted = 'NO' and A.UserCode = '{0}' and A.UserType = '{1}' and B.LangCode = '{2}' 
                       and B.ParentModule = 'PersonalSpaceSaaS' Order By SortNumber ASC", strUserCode, strUserType, strLangCode);
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");

        DataGrid4.DataSource = ds;
        DataGrid4.DataBind();

        BT_ModuleSave.Enabled = true;

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strSortNumber = ds.Tables[0].Rows[i]["SortNumber"].ToString().Trim();
            ((TextBox)DataGrid4.Items[i].FindControl("TB_SortNumber")).Text = strSortNumber;

            strEveryRowColumnNumber = ds.Tables[0].Rows[i]["EveryRowColumnNumber"].ToString().Trim();
            ((DropDownList)DataGrid4.Items[i].FindControl("DL_EveryRowColumnNumber")).Text = strEveryRowColumnNumber;


            strModuleName = ds.Tables[0].Rows[i]["ModuleName"].ToString().Trim();
            strVisible = ds.Tables[0].Rows[i]["Visible"].ToString().Trim();

            if (strVisible == "YES")
            {
                ((CheckBox)DataGrid4.Items[i].FindControl("CB_ModuleVisible")).Checked = true;
            }
            else
            {
                ((CheckBox)DataGrid4.Items[i].FindControl("CB_ModuleVisible")).Checked = false;
            }
        }

        LB_ModuleNumber.Text = ds.Tables[0].Rows.Count.ToString();
    }

}
