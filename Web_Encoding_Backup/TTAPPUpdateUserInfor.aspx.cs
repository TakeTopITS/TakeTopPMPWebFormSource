using System;
using System.Resources;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

public partial class TTAPPUpdateUserInfor : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode = Session["UserCode"].ToString();
        string strHQL;
        IList lst;

        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        //bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", strUserCode);  //Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", "我的档案", strUserCode);
        //if (blVisible == false)
        //{
        //    Response.Redirect("TTDisplayErrors.aspx");
        //    return;
        //}

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            try
            {
                TB_Password.Focus();
                ShareClass.LoadLanguageForDropList(ddlLangSwitcher);

                strHQL = "from WorkType as workType Order by workType.SortNo ASC";
                BookReaderTypeBLL bookReaderTypeBLL = new BookReaderTypeBLL();
                lst = bookReaderTypeBLL.GetAllBookReaderType(strHQL);
                DL_WorkType.DataSource = lst;
                DL_WorkType.DataBind();
                DL_WorkType.Items.Insert(0, new ListItem("--Select--", ""));

                DLLoadDepartMent();
                LoadSystemMDIStyle();

                strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
                projectMemberBLL = new ProjectMemberBLL();
                lst = projectMemberBLL.GetAllProjectMembers(strHQL);

                ProjectMember projectMember = (ProjectMember)lst[0];

                TB_UserCode.Text = projectMember.UserCode.Trim();
                TB_UserName.Text = projectMember.UserName.Trim();
                DL_Gender.SelectedValue = projectMember.Gender.Trim();
                TB_Age.Amount = projectMember.Age;

                TB_Duty.Text = projectMember.Duty;
                TB_JobTitle.Text = projectMember.JobTitle;

                IM_MemberPhoto.ImageUrl = projectMember.PhotoURL.Trim();

                DL_Department.SelectedValue = projectMember.DepartCode;
                TB_ChildDepartment.Text = projectMember.ChildDepartment;
                TB_OfficePhone.Text = projectMember.OfficePhone;
                TB_MobilePhone.Text = projectMember.MobilePhone;
                TB_EMail.Text = projectMember.EMail;
                TB_WorkScope.Text = projectMember.WorkScope;
                TB_JoinDate.Text = projectMember.JoinDate.ToString("yyyy-MM-dd");
                DL_Status.SelectedValue = projectMember.Status.Trim();

                DL_UserType.SelectedValue = projectMember.UserType.Trim();
                TB_RefUserCode.Text = projectMember.RefUserCode.Trim();
                TB_UserRTXCode.Text = projectMember.UserRTXCode.Trim();
                NB_SortNumber.Amount = projectMember.SortNumber;
                try
                {
                    DL_WorkType.SelectedValue = projectMember.WorkType.Trim();
                }
                catch
                {
                }
                DL_SystemMDIStyle.SelectedValue = projectMember.MDIStyle.Trim();
                DL_CssDirectory.SelectedValue = projectMember.CssDirectory.Trim();
                DL_AllowDevice.SelectedValue = projectMember.AllowDevice.Trim();

                try
                {
                    ddlLangSwitcher.SelectedValue = projectMember.LangCode.Trim();
                }
                catch
                {
                    ddlLangSwitcher.SelectedValue = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }
    }

    protected void BT_Update_Click(object sender, EventArgs e)
    {
        string strUserCode = Session["UserCode"].ToString();
        string strPassword = TB_Password.Text.Trim();
        string strStatus = DL_Status.SelectedValue.Trim();


        string strHQL = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);

        ProjectMember projectMember = (ProjectMember)lst[0];

        if (strPassword != "")
        {
            if (ShareClass.SqlFilter(strPassword))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZZHHYFFZHDLSB") + "')", true);
                return;
            }

            #region 判断输入的密码是否是字母与数字的结合，且长度要大于或等于8位 2013-09-03 By LiuJianping
            if (!ShareClass.IsPassword(strPassword))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGGSBMMCDBXDYHDY8WBXBHSZJZMJC") + "')", true);
                TB_Password.Focus();
                return;
            }
          
            strPassword = ShareClass.EncryptPassword(strPassword, "MD5");
            projectMember.Password = strPassword;
            #endregion
        }

        projectMember.Age = int.Parse(TB_Age.Amount.ToString());
        projectMember.OfficePhone = TB_OfficePhone.Text.Trim();
        projectMember.MobilePhone = TB_MobilePhone.Text.Trim();
        projectMember.EMail = TB_EMail.Text.Trim();
        projectMember.MDIStyle = DL_SystemMDIStyle.SelectedValue.Trim();
        projectMember.LangCode = ddlLangSwitcher.SelectedValue.Trim();
        projectMember.CssDirectory = DL_CssDirectory.SelectedValue.Trim();

        try
        {
            projectMemberBLL.UpdateProjectMember(projectMember, strUserCode);

            //Session["CssDirectory"] = DL_CssDirectory.SelectedValue.Trim();

            //设置缓存更改标志
            ShareClass.ChangePageCache();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSB") + "')", true);
        }
    }

    protected void DLLoadDepartMent()
    {
        string strHQL = "from Department as department";

        DepartmentBLL departmentBLL = new DepartmentBLL();


        IList lst = departmentBLL.GetAllDepartments(strHQL);

        DL_Department.DataSource = lst;
        DL_Department.DataBind();
    }

    protected void LoadSystemMDIStyle()
    {
        string strHQL = "from SystemMDIStyle as systemMDIStyle Order By systemMDIStyle.SortNumber ASC";

        SystemMDIStyleBLL systemMDIStyleBLL = new SystemMDIStyleBLL();
        IList lst = systemMDIStyleBLL.GetAllSystemMDIStyles(strHQL);

        DL_SystemMDIStyle.DataSource = lst;
        DL_SystemMDIStyle.DataBind();
    }


   
}
