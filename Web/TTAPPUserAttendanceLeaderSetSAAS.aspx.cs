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
using System.Data.SqlClient;
using System.IO;
using System.Drawing;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

public partial class TTAPPUserAttendanceLeaderSetSAAS : System.Web.UI.Page
{
    string strUserCode, strUserName;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strUserName = ShareClass.GetUserName(strUserCode);

        if (Page.IsPostBack == false)
        {
            LoadUserAttendanceRule(strUserCode);
        }
    }

    protected void BT_AddLeaderCode_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strUserCode, strUserName, strLeaderCode;

        strUserCode = Session["UserCode"].ToString();
        strUserName = Session["UserName"].ToString();

        strLeaderCode = TB_LeaderCode.Text.Trim();
        if (strLeaderCode == "")
        {
            return;
        }

        strHQL = string.Format(@"Select * From T_ContactInfor Where UserCode = '{0}' and MobilePhone = '{1}'", strLeaderCode, strUserCode);
        DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_ContactInfor");
        if (ds1.Tables[0].Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGNBZCZGKQYQZLBNJRQJC") + "')", true);
            return;
        }

        strHQL = string.Format(@"Select * From T_MemberLevel Where UserCode = '{0}' and UnderCode = '{1}'", strLeaderCode, strUserCode);
        DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_MemberLevel");
        if (ds2.Tables[0].Rows.Count == 0)
        {
            strHQL = string.Format(@"Insert Into T_MemberLevel(UserCode, UnderCode, AgencyStatus, ProjectVisible, PlanVisible, KPIVisible, WorkloadVisible, ScheduleVisible, WorkflowVisible, CustomerServiceVisible, ConstractVisible, PositionVisible, SortNumber) 
                                     values('{0}', '{1}', 1, 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 'YES', 1)", strLeaderCode, strUserCode);
            ShareClass.RunSqlCommand(strHQL);
        }

        strHQL = string.Format(@"Insert Into T_UserAttendanceRule(UserCode, UserName, CreateDate, MCheckInStart, MCheckInEnd, MCheckOutStart, MCheckOutEnd,
                                ACheckInStart, ACheckInEnd, ACheckOutStart, ACheckOutEnd, NCheckInStart, NCheckInEnd, NCheckOutStart, NCheckOutEnd,
                                OCheckInStart, OCheckInEnd, OCheckOutStart, OCheckOutEnd, Status, MCheckInIsMust, MCheckOutIsMust, ACheckInIsMust, ACheckOutIsMust, NCheckInIsMust, NCheckOutIsMust, OCheckInIsMust, OCheckOutIsMust, LargestDistance, LeaderCode, LeaderName, OfficeLongitude, OfficeLatitude)
                                Select '{0}', '{1}', now(), B.MCheckInStart, B.MCheckInEnd, B.MCheckOutStart, B.MCheckOutEnd,
                                B.ACheckInStart, B.ACheckInEnd, B.ACheckOutStart, B.ACheckOutEnd, B.NCheckInStart, B.NCheckInEnd, B.NCheckOutStart, B.NCheckOutEnd,
                                B.OCheckInStart, B.OCheckInEnd, B.OCheckOutStart, B.OCheckOutEnd, 'InProgress', B.MCheckInIsMust, B.MCheckOutIsMust, B.ACheckInIsMust, B.ACheckOutIsMust, B.NCheckInIsMust, B.NCheckOutIsMust, B.OCheckInIsMust, B.OCheckOutIsMust, B.LargestDistance, '{2}', '{3}', B.OfficeLongitude, B.OfficeLatitude
                                From T_UserAttendanceRule B
                                Where B.LeaderCode = '{2}'
                                And B.LeaderCode not in (Select LeaderCode From T_UserAttendanceRule Where UserCode = '{0}')",
                                strUserCode, strUserName, strLeaderCode, ShareClass.GetUserName(strLeaderCode));
        ShareClass.RunSqlCommand(strHQL);

        LoadUserAttendanceRule(strUserCode);
    }

    protected void DataGrid3_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        string strHQL;
        string strID = e.Item.Cells[0].Text;

        for (int i = 0; i < DataGrid3.Items.Count; i++)
        {
            DataGrid3.Items[i].ForeColor = Color.Black;
        }

        e.Item.ForeColor = Color.Red;

        strHQL = string.Format(@"Delete From T_UserAttendanceRule Where ID = {0}", strID);
        ShareClass.RunSqlCommand(strHQL);

        LoadUserAttendanceRule(strUserCode);
    }

    protected void LoadUserAttendanceRule(string strMemberCode)
    {
        string strHQL;
        IList lst;

        strHQL = string.Format(@"From UserAttendanceRule as userAttendanceRule Where userAttendanceRule.UserCode = '{0}' 
                                and char_length(rtrim(userAttendanceRule.LeaderCode)) > 0 
                                and userAttendanceRule.UserCode <> userAttendanceRule.LeaderCode 
                                Order by userAttendanceRule.ID DESC", strMemberCode);
        UserAttendanceRuleBLL userAttendanceRuleBLL = new UserAttendanceRuleBLL();
        lst = userAttendanceRuleBLL.GetAllUserAttendanceRules(strHQL);

        DataGrid3.DataSource = lst;
        DataGrid3.DataBind();
    }
}