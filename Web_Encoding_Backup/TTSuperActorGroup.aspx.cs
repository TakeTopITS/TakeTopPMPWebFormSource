using ProjectMgt.BLL;
using ProjectMgt.Model;

using System;
using System.Collections;
using System.Data;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class TTSuperActorGroup : System.Web.UI.Page
{
    string strLangCode;
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode, strUserName, strDepartCode;

        strLangCode = Session["LangCode"].ToString();
        strUserCode = Session["UserCode"].ToString();
        strUserName = ShareClass.GetUserName(strUserCode);

        LB_UserCode.Text = strUserCode;
        LB_UserName.Text = strUserName;

        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", strUserCode);  //Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", "全局角色组设置", strUserCode);
        if (blVisible == false)
        {
            Response.Redirect("TTDisplayErrors.aspx");
            return;
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "ajustHeight", "AdjustDivHeight();", true);
        ScriptManager.RegisterOnSubmitStatement(this.Page, this.Page.GetType(), "SavePanelScroll", "SaveScroll();");
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            TakeTopCore.CoreShareClass.InitialAllDepartmentTree(LanguageHandle.GetWord("ZZJGT"), TreeView1);

            strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);
            ShareClass.LoadUserByDepartCodeForDataGrid(strDepartCode, DataGrid4);

            ShareClass.LoadLanguageForDropList(ddlLangSwitcher);
            ddlLangSwitcher.SelectedValue = strLangCode;

            LoadActorGroup(strLangCode);

            BT_New.Enabled = false;

            TakeTopCore.CoreShareClass.InitialDepartmentTreeByAuthority(LanguageHandle.GetWord("ZZJGT"), TreeView1, strUserCode);
        }
    }


    protected void ddlLangSwitcher_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadActorGroup(ddlLangSwitcher.SelectedValue.Trim());
    }

    protected void BT_CopyAlActorGroupForHomeLanguage_Click(object sender, EventArgs e)
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

            LoadActorGroup(ddlLangSwitcher.SelectedValue.Trim());

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZFZCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZFZSBJC") + "')", true);
        }
    }

    protected void BT_CreateActorGroup_Click(object sender, EventArgs e)
    {
        string strGroupName, strUserCode, strDepartCode, strDepartName;
        string strType;

        string strHQL;
        IList lst;

        strGroupName = TB_ActorGroup.Text.Trim();
        strUserCode = LB_UserCode.Text.Trim();
        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);
        strDepartName = ShareClass.GetDepartName(strDepartCode);

        strType = DL_Type.SelectedValue.Trim();

        if (strGroupName != "")
        {
            ActorGroupBLL actorGroupBLL = new ActorGroupBLL();
            ActorGroup actorGroup = new ActorGroup();

            strHQL = "from ActorGroup as actorGroup Where actorGroup.GroupName = " + "'" + strGroupName + "'";
            lst = actorGroupBLL.GetAllActorGroups(strHQL);
            if (lst.Count > 0)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZCZTMDJSZQJC") + "')", true);
                return;
            }

            actorGroup.GroupName = strGroupName;
            actorGroup.HomeName = strGroupName;
            actorGroup.MakeUserCode = strUserCode;
            actorGroup.Type = strType;
            actorGroup.IdentifyString = DateTime.Now.ToString("yyyyMMddHHMMssff");
            actorGroup.BelongDepartCode = strDepartCode;
            actorGroup.BelongDepartName = strDepartName;

            actorGroup.LangCode = ddlLangSwitcher.SelectedValue.Trim();
            actorGroup.MakeType = "DIY";
            actorGroup.SortNumber = int.Parse(NB_SortNumber.Amount.ToString());

            try
            {
                actorGroupBLL.AddActorGroup(actorGroup);

                LoadActorGroup(ddlLangSwitcher.SelectedValue.Trim());
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZXZSBJC") + "')", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJSZZMBNWK") + "')", true);
        }
    }


    protected void BT_FindActorGroup_Click(object sender, EventArgs e)
    {
        string strHQL;
        IList lst;

        string strGroupHomeName = "%" + TB_ActorGroup.Text.Trim() + "%";

        ActorGroupBLL actorGroupBLL = new ActorGroupBLL();
        strHQL = "from ActorGroup as actorGroup ";
        strHQL += " where actorGroup.LangCode = " + "'" +ddlLangSwitcher.SelectedValue.Trim() + "'";
        strHQL += " and actorGroup.HomeName Like '" + strGroupHomeName + "'";
        strHQL += " order by actorGroup.SortNumber ASC";
        lst = actorGroupBLL.GetAllActorGroups(strHQL);
        Repeater1.DataSource = lst;
        Repeater1.DataBind();
    }

    protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            string strGroupName, strMakeUserCode, strUserCode;
            string strHQL;
            IList lst;

            DataGrid2.CurrentPageIndex = 0;

            for (int i = 0; i < Repeater1.Items.Count; i++)
            {
                ((Button)Repeater1.Items[i].FindControl("BT_GroupName")).ForeColor = Color.White;
            }
            ((Button)e.Item.FindControl("BT_GroupName")).ForeColor = Color.Red;

            strGroupName = ((Button)e.Item.FindControl("BT_GroupName")).ToolTip.Trim();
            strMakeUserCode = GetMakeUserCode(strGroupName);
            strUserCode = LB_UserCode.Text.Trim();

            strHQL = "From ActorGroup as actorGroup Where actorGroup.GroupName = " + "'" + strGroupName + "' and actorGroup.LangCode = '" + ddlLangSwitcher.SelectedValue.Trim() + "'";
            ActorGroupBLL actorGroupBLL = new ActorGroupBLL();
            lst = actorGroupBLL.GetAllActorGroups(strHQL);
            ActorGroup actorGroup = (ActorGroup)lst[0];

            TB_HomeName.Text = actorGroup.HomeName.Trim();

            DL_Type.SelectedValue = actorGroup.Type.Trim();
            TB_BelongDepartName.Text = actorGroup.BelongDepartName;
            LB_BelongDepartCode.Text = actorGroup.BelongDepartCode;
            NB_SortNumber.Amount = actorGroup.SortNumber;

            ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
            strHQL = "from ActorGroupDetail as actorGroupDetail where actorGroupDetail.GroupName = " + "'" + strGroupName + "'";
            lst = actorGroupDetailBLL.GetAllActorGroupDetails(strHQL);
            DataGrid2.DataSource = lst;
            DataGrid2.DataBind();

            LB_SqlGM.Text = strHQL;


            LB_ActorGroupHomeName.Text = actorGroup.HomeName.Trim();

            LB_ActorGroupHomeNameForDetail.Text = actorGroup.HomeName.Trim();
            LB_ActorGroupName.Text = strGroupName;

            BT_SaveActorGroup.Enabled = true;
            BT_New.Enabled = true;

            if (strGroupName != LanguageHandle.GetWord("GeRen") & strGroupName != LanguageHandle.GetWord("QuanTi") & strGroupName != LanguageHandle.GetWord("BuMen") & strGroupName != LanguageHandle.GetWord("GongSi") & strGroupName != LanguageHandle.GetWord("JiTuan") & strGroupName != "All")
            {
                BT_DeleteActorGroup.Enabled = true;
            }
            else
            {
                BT_DeleteActorGroup.Enabled = false;
            }
        }
    }

    protected void TreeView2_SelectedNodeChanged(object sender, EventArgs e)
    {
        string strDepartCode, strDepartName;

        TreeNode treeNode = new TreeNode();
        treeNode = TreeView2.SelectedNode;

        if (treeNode.Target != "0")
        {
            strDepartCode = treeNode.Target.Trim();
            strDepartName = ShareClass.GetDepartName(strDepartCode);

            LB_BelongDepartCode.Text = strDepartCode;
            TB_BelongDepartName.Text = strDepartName;
        }
    }

    protected void BT_SaveActorGroup_Click(object sender, EventArgs e)
    {
        string strHQL;
        IList lst;

        string strGroupName, strType;
        int intID;
        strGroupName = LB_ActorGroupName.Text.Trim();
        strType = DL_Type.SelectedValue.Trim();

        try
        {
            strHQL = "From ActorGroup as actorGroup Where GroupName = " + "'" + strGroupName + "'";
            ActorGroupBLL actorGroupBLL = new ActorGroupBLL();
            lst = actorGroupBLL.GetAllActorGroups(strHQL);

            ActorGroup actorGroup = (ActorGroup)lst[0];

            intID = actorGroup.ID;
            actorGroup.HomeName = TB_HomeName.Text.Trim();
            actorGroup.Type = strType;
            actorGroup.BelongDepartCode = LB_BelongDepartCode.Text.Trim();
            actorGroup.BelongDepartName = TB_BelongDepartName.Text.Trim();
            actorGroup.SortNumber = int.Parse(NB_SortNumber.Amount.ToString());

            actorGroupBLL.UpdateActorGroup(actorGroup, intID);

            LoadActorGroup(ddlLangSwitcher.SelectedValue.Trim());

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSBJC") + "')", true);
        }
    }

    protected void BT_DeleteActorGroup_Click(object sender, EventArgs e)
    {
        string strHQL;

        string strGroupName = LB_ActorGroupName.Text.Trim();

        strHQL = "Delete From T_ActorGroup Where GroupName = " + "'" + strGroupName + "'";

        try
        {
            ShareClass.RunSqlCommand(strHQL);

            LoadActorGroup(ddlLangSwitcher.SelectedValue.Trim());

            BT_DeleteActorGroup.Enabled = false;
            BT_SaveActorGroup.Enabled = false;

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSCJSZCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGSCSBJC") + "')", true);
        }
    }

    protected void TreeView1_SelectedNodeChanged(object sender, EventArgs e)
    {
        string strDepartCode, strHQL;
        IList lst;

        TreeNode treeNode = new TreeNode();
        treeNode = TreeView1.SelectedNode;

        if (treeNode.Target != "0")
        {
            strDepartCode = treeNode.Target.Trim();

            strHQL = "from ProjectMember as projectMember where projectMember.DepartCode= " + "'" + strDepartCode + "'";
            ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
            lst = projectMemberBLL.GetAllProjectMembers(strHQL);
            DataGrid4.DataSource = lst;
            DataGrid4.DataBind();

            LB_DepartCode.Text = strDepartCode;
            LB_DepartName.Text = ShareClass.GetDepartName(strDepartCode);

            ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "SetPanelScroll", "RestoreScroll();", true);
        }

        ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','true') ", true);
    }

    protected void DataGrid2_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            string strGroupID = e.Item.Cells[2].Text.Trim();

            if (e.CommandName == "Update")
            {
                for (int i = 0; i < DataGrid2.Items.Count; i++)
                {
                    DataGrid2.Items[i].ForeColor = Color.Black;
                }

                e.Item.ForeColor = Color.Red;

                string strHQL = "from ActorGroupDetail as actorGroupDetail where actorGroupDetail.GroupID = " + strGroupID;
                ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
                IList lst = actorGroupDetailBLL.GetAllActorGroupDetails(strHQL);

                ActorGroupDetail actorGroupDetail = (ActorGroupDetail)lst[0];


                LB_ID.Text = actorGroupDetail.GroupID.ToString();
                LB_RelatedUserCode.Text = actorGroupDetail.UserCode;
                LB_RelatedUserName.Text = actorGroupDetail.UserName;

                TB_Actor.Text = actorGroupDetail.Actor;
                TB_WorkDetail.Text = actorGroupDetail.WorkDetail;

                string strGroupName = actorGroupDetail.GroupName.Trim();
                string strMakeUserCode = GetMakeUserCode(strGroupName);
                string strUserCode = LB_UserCode.Text.Trim();
                string strDepartCode = LB_DepartCode.Text.Trim();


                try
                {
                    LB_DepartCode.Text = actorGroupDetail.DepartCode;
                    LB_DepartName.Text = ShareClass.GetDepartName(LB_DepartCode.Text);
                }
                catch
                {
                    LB_DepartCode.Text = ShareClass.GetDepartCodeFromUserCode(Session["UserCode"].ToString());
                    LB_DepartName.Text = ShareClass.GetDepartName(LB_DepartCode.Text);
                }

                BT_New.Enabled = true;

                ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','true') ", true);
            }

            if (e.CommandName == "Delete")
            {
                string strHQL;

                string strGroupName = LB_ActorGroupName.Text.Trim();

                string strUserCode = LB_RelatedUserCode.Text.Trim();
                string strUserName = LB_RelatedUserName.Text.Trim();
                string strDepartCode = LB_DepartCode.Text.Trim();
                string strDepartName = ShareClass.GetDepartName(strDepartCode);
                string strActor = TB_Actor.Text.Trim();
                string strWorkDetail = TB_WorkDetail.Text.Trim();

                try
                {
                    strHQL = "Delete From T_ActorGroupDetail Where GroupID = " + strGroupID;
                    ShareClass.RunSqlCommand(strHQL);

                    LoadActorGroupDetail(strGroupName);
                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZCCJC") + "')", true);
                }
            }
        }
    }

    protected void DataGrid2_PageIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        DataGrid2.CurrentPageIndex = e.NewPageIndex;

        string strHQL = LB_SqlGM.Text;

        ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
        IList lst = actorGroupDetailBLL.GetAllActorGroupDetails(strHQL);

        DataGrid2.DataSource = lst;
        DataGrid2.DataBind();
    }

    protected void DataGrid3_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            string strDepartCode = ((Button)e.Item.FindControl("BT_DepartCode")).Text.Trim();
            string strHQL = "from ProjectMember as projectMember where projectMember.DepartCode= " + "'" + strDepartCode + "'";

            ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
            IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

            DataGrid4.DataSource = lst;
            DataGrid4.DataBind();

            ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','true') ", true);
        }
    }

    protected void DataGrid4_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        string strHQL;
        IList lst;
        string strUserCode = ((Button)e.Item.FindControl("BT_UserCode")).Text.Trim();
        string strUserName = ((Button)e.Item.FindControl("BT_UserName")).Text.Trim();
        string strGroupName = LB_ActorGroupName.Text.Trim();

        strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        ProjectMember projectMember = (ProjectMember)lst[0];

        LB_RelatedUserCode.Text = strUserCode;
        LB_RelatedUserName.Text = strUserName;
        LB_DepartCode.Text = projectMember.DepartCode;
        LB_DepartName.Text = ShareClass.GetDepartName(projectMember.DepartCode.Trim());

        BT_New.Enabled = true;

        ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','true') ", true);
    }

    protected void CB_SelectAllUser_CheckedChanged(object sender, EventArgs e)
    {
        if (CB_SelectAllUser.Checked == true)
        {
            for (int i = 0; i < DataGrid4.Items.Count; i++)
            {
                ((CheckBox)DataGrid4.Items[i].FindControl("CB_SelectUser")).Checked = true;
            }
        }
        else
        {
            for (int i = 0; i < DataGrid4.Items.Count; i++)
            {
                ((CheckBox)DataGrid4.Items[i].FindControl("CB_SelectUser")).Checked = false;
            }
        }

        ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','false') ", true);
    }


    protected void BT_AddAllSelect_Click(object sender, EventArgs e)
    {
        AddAllSelectMember();
    }

    protected void AddAllSelectMember()
    {
        string strGroupID;
        string strGroupName = LB_ActorGroupName.Text.Trim();
        string strRelatedUserCode;
        string strRelatedUserName;
        string strDepartCode, strDepartName;

        string strActor = TB_Actor.Text.Trim();
        string strWorkDetail = TB_WorkDetail.Text.Trim();

        if (strActor != "")
        {
            try
            {
                ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
                ActorGroupDetail actorGroupDetail = new ActorGroupDetail();

                for (int i = 0; i < DataGrid4.Items.Count; i++)
                {
                    if (((CheckBox)DataGrid4.Items[i].FindControl("CB_SelectUser")).Checked == true)
                    {
                        actorGroupDetail.GroupName = strGroupName;
                        strRelatedUserCode = ((Button)DataGrid4.Items[i].FindControl("BT_UserCode")).Text.Trim();
                        strRelatedUserName = ((Button)DataGrid4.Items[i].FindControl("BT_UserName")).Text.Trim();
                        actorGroupDetail.UserCode = strRelatedUserCode;
                        actorGroupDetail.UserName = strRelatedUserName;

                        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strRelatedUserCode);
                        strDepartName = ShareClass.GetDepartName(strDepartCode);
                        actorGroupDetail.DepartCode = strDepartCode;
                        actorGroupDetail.DepartName = strDepartName;
                        actorGroupDetail.Actor = strActor;
                        actorGroupDetail.WorkDetail = strWorkDetail;

                        string strHQL = string.Format(@"INSERT INTO T_ActorGroupDetail (GroupName, UserCode, UserName, DepartCode, DepartName, Actor, WorkDetail) 
                                        VALUES ('{0}','{1}', '{2}', '{3}', '{4}', '{5}', '{6}')", strGroupName, strRelatedUserCode, strRelatedUserName, strDepartCode, strDepartName, strActor, strWorkDetail);

                        try
                        {
                            ShareClass.RunSqlCommand(strHQL);

                            //actorGroupDetailBLL.AddActorGroupDetail(actorGroupDetail);
                        }
                        catch (Exception err)
                        {
                            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace + " " + strRelatedUserCode);
                        }

                        strGroupID = ShareClass.GetMyCreatedMaxActorGroupDetailID(strGroupName);
                        LB_ID.Text = strGroupID;

                        LB_RelatedUserCode.Text = strRelatedUserCode;
                        LB_RelatedUserName.Text = strRelatedUserName;
                    }
                }

                LoadActorGroupDetail(strGroupName);
            }
            catch (Exception err)
            {

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSB") + "')", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJingGaoJiaoSeBuNengWeiKongQi") + "')", true);
            ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','false') ", true);
        }
    }

    protected void BT_DeleteAllSelect_Click(object sender, EventArgs e)
    {
        DeleteAllSelectMember();
    }

    protected void DeleteAllSelectMember()
    {
        string strHQL;

        string strGroupName = LB_ActorGroupName.Text.Trim();
        string strRelatedUserCode;
        string strRelatedUserName;

        try
        {
            ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
            ActorGroupDetail actorGroupDetail = new ActorGroupDetail();

            for (int i = 0; i < DataGrid4.Items.Count; i++)
            {
                if (((CheckBox)DataGrid4.Items[i].FindControl("CB_SelectUser")).Checked == true)
                {
                    strRelatedUserCode = ((Button)DataGrid4.Items[i].FindControl("BT_UserCode")).Text.Trim();
                    strRelatedUserName = ((Button)DataGrid4.Items[i].FindControl("BT_UserName")).Text.Trim();
                    strHQL = "Delete From T_ActorGroupDetail Where GroupName = '" + strGroupName + "' and UserCode = '" + strRelatedUserCode + "'";
                    ShareClass.RunSqlCommand(strHQL);
                }
            }

            LoadActorGroupDetail(strGroupName);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSCSB") + "')", true);
        }
    }

    protected void BT_Create_Click(object sender, EventArgs e)
    {
        LB_ID.Text = "";

        ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','false') ", true);
    }

    protected void BT_New_Click(object sender, EventArgs e)
    {
        string strID;

        strID = LB_ID.Text.Trim();

        if (strID == "")
        {
            AddMember();
        }
        else
        {
            UpdateMember();
        }
    }

    protected void AddMember()
    {
        string strGroupID;
        string strGroupName = LB_ActorGroupName.Text.Trim();
        string strRelatedUserCode = LB_RelatedUserCode.Text.Trim();
        string strRelatedUserName = LB_RelatedUserName.Text.Trim();
        string strDepartCode = LB_DepartCode.Text.Trim();
        LogClass.WriteLogFile(strDepartCode);

        string strDepartName = ShareClass.GetDepartName(strDepartCode);
        string strActor = TB_Actor.Text.Trim();
        string strWorkDetail = TB_WorkDetail.Text.Trim();

        if (strActor != "")
        {
            try
            {
                ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
                ActorGroupDetail actorGroupDetail = new ActorGroupDetail();

                actorGroupDetail.GroupName = strGroupName;
                actorGroupDetail.UserCode = strRelatedUserCode;
                actorGroupDetail.UserName = strRelatedUserName;
                actorGroupDetail.DepartCode = strDepartCode;
                actorGroupDetail.DepartName = strDepartName;
                actorGroupDetail.Actor = strActor;
                actorGroupDetail.WorkDetail = strWorkDetail;

                actorGroupDetailBLL.AddActorGroupDetail(actorGroupDetail);

                strGroupID = ShareClass.GetMyCreatedMaxActorGroupDetailID(strGroupName);
                LB_ID.Text = strGroupID;

                LoadActorGroupDetail(strGroupName);
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSB") + "')", true);
        }
    }

    protected void UpdateMember()
    {
        string strHQL;
        IList lst;

        string strGroupName = LB_ActorGroupName.Text.Trim();
        string strID = LB_ID.Text.Trim();
        string strRelatedUserCode = LB_RelatedUserCode.Text.Trim();
        string strRelatedUserName = LB_RelatedUserName.Text.Trim();
        string strDepartCode = LB_DepartCode.Text.Trim();
        string strDepartName = ShareClass.GetDepartName(strDepartCode);
        string strActor = TB_Actor.Text.Trim();
        string strWorkDetail = TB_WorkDetail.Text.Trim();
        string strUserCode = LB_UserCode.Text.Trim();
        string strMakeUserCode = GetMakeUserCode(strGroupName);


        try
        {
            ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
            strHQL = "From ActorGroupDetail as actorGroupDetail Where actorGroupDetail.GroupID = " + strID;
            lst = actorGroupDetailBLL.GetAllActorGroupDetails(strHQL);
            ActorGroupDetail actorGroupDetail = (ActorGroupDetail)lst[0];

            actorGroupDetail.GroupName = strGroupName;
            actorGroupDetail.UserCode = strRelatedUserCode;
            actorGroupDetail.UserName = strRelatedUserName;
            actorGroupDetail.DepartCode = strDepartCode;
            actorGroupDetail.DepartName = strDepartName;
            actorGroupDetail.Actor = strActor;
            actorGroupDetail.WorkDetail = strWorkDetail;

            actorGroupDetailBLL.UpdateActorGroupDetail(actorGroupDetail, int.Parse(strID));

            LoadActorGroupDetail(strGroupName);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSB") + "')", true);
        }
    }

    protected void DataGrid1_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            string strGroupName, strMakeUserCode, strUserCode;
            string strHQL;
            IList lst;

            strGroupName = ((Button)e.Item.FindControl("BT_GroupName")).Text.Trim();
            strMakeUserCode = GetMakeUserCode(strGroupName);
            strUserCode = LB_UserCode.Text.Trim();

            ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
            strHQL = "from ActorGroupDetail as actorGroupDetail where actorGroupDetail.GroupName = " + "'" + strGroupName + "'";
            lst = actorGroupDetailBLL.GetAllActorGroupDetails(strHQL);

            DataGrid2.DataSource = lst;
            DataGrid2.DataBind();

            LB_ActorGroupName.Text = strGroupName;
            LB_ActorGroupName.Text = strGroupName;

            BT_New.Enabled = true;
        }
    }

    protected void LoadActorGroup(string strLangCode)
    {
        string strHQL;
        IList lst;

        strHQL = "Select GroupName,HomeName From T_ActorGroup Where ";
        strHQL += " LangCode = " + "'" + strLangCode + "'";
        strHQL += " Order by SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ActorGroup");
        Repeater1.DataSource = ds;
        Repeater1.DataBind();
    }

    protected void LoadActorGroupDetail(string strGroupName)
    {
        string strHQL = "from ActorGroupDetail as actorGroupDetail where actorGroupDetail.GroupName = " + "'" + strGroupName + "'";
        ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
        IList lst = actorGroupDetailBLL.GetAllActorGroupDetails(strHQL);
        DataGrid2.DataSource = lst;
        DataGrid2.DataBind();
    }

    protected string GetMakeUserCode(string strGroupName)
    {
        IList lst;
        string strHQL, strMakeUserCode;

        ActorGroupBLL actorGroupBLL = new ActorGroupBLL();
        ActorGroup actorGroup = new ActorGroup();
        strHQL = "from ActorGroup as actorGroup where actorGroup.GroupName = " + "'" + strGroupName + "'";
        lst = actorGroupBLL.GetAllActorGroups(strHQL);
        actorGroup = (ActorGroup)lst[0];

        strMakeUserCode = actorGroup.MakeUserCode.Trim();

        return strMakeUserCode;
    }




}