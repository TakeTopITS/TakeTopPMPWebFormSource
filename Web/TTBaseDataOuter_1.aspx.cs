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

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;
using Stimulsoft.Base.Gauge.GaugeGeoms;

public partial class TTBaseDataOuter_1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode;

        strUserCode = Session["UserCode"].ToString();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            LoadKPIType();
            LoadAttendanceRule();
            LoadBookReaderType();//用工类型
            LoadLeaveType();//请假类型
            LoadDayHourNum();//一天工作时间设置
            LoadDepartPosition();
            LoadUserDuty();
            LoadKPICheckTypeWeight();
            LoadOvertimeType();
            LoadFestivalsType();

            NB_ScheduleLimitedDays.Amount = GetScheduleLimitedDays();

            NB_WeekendFirstDay.Amount = decimal.Parse(ShareClass.GetWeekendFirstDay());
            NB_WeekendSecondDay.Amount = decimal.Parse(ShareClass.GetWeekendSecondDay());
            DL_WeekendsAreWorkdays.SelectedValue = ShareClass.GetWeekendsAreWorkdays();
        }
    }

    protected void DataGrid1_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strDuty = ((Button)e.Item.FindControl("BT_Duty")).Text;
            string strKeyWord = e.Item.Cells[1].Text.Trim();
            string strSortNumber = e.Item.Cells[2].Text.Trim();

            TB_Duty.Text = strDuty;
            LB_Duty_Backup.Text = strDuty;
            TB_DutyKeyWord.Text = strKeyWord;
            LB_DutyKeyWord_Backup.Text = strKeyWord;
            TB_DutySort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalDuty', document.getElementById('" + ((Button)e.Item.FindControl("BT_Duty")).ClientID + "'));", true);
        }
    }

    protected void DataGrid16_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strOvertimeType = ((Button)e.Item.FindControl("BT_OvertimeType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_OvertimeType.Text = strOvertimeType;
            TB_OvertimeTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalOvertimeType', document.getElementById('" + ((Button)e.Item.FindControl("BT_OvertimeType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid17_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_LeaveType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_LeaveType.Text = strType;
            TB_LeaveSortNumber.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalLeaveType', document.getElementById('" + ((Button)e.Item.FindControl("BT_LeaveType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid24_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strID = ((Button)e.Item.FindControl("BT_ID")).Text.Trim();

            string strHQL = " From AttendanceRule as attendanceRule where attendanceRule.ID = " + strID;
            AttendanceRuleBLL attendanceRuleBLL = new AttendanceRuleBLL();
            IList lst = attendanceRuleBLL.GetAllAttendanceRules(strHQL);

            AttendanceRule attendanceRule = (AttendanceRule)lst[0];

            LogClass.WriteLogFile(lst.Count.ToString() + " :" + strID);

            LB_AttendanceRuleID.Text = strID;

            TB_MCheckInStart.Text = attendanceRule.MCheckInStart.Trim();
            TB_MCheckInEnd.Text = attendanceRule.MCheckInEnd.Trim();
            DDL_MCheckInIsMust.SelectedValue = attendanceRule.MCheckInIsMust.Trim();

            TB_MCheckOutStart.Text = attendanceRule.MCheckOutStart.Trim();
            TB_MCheckOutEnd.Text = attendanceRule.MCheckOutEnd.Trim();
            DDL_MCheckOutIsMust.SelectedValue = attendanceRule.MCheckOutIsMust.Trim();

            TB_ACheckInStart.Text = attendanceRule.ACheckInStart.Trim();
            TB_ACheckInEnd.Text = attendanceRule.ACheckInEnd.Trim();
            DDL_ACheckInIsMust.SelectedValue = attendanceRule.ACheckInIsMust.Trim();

            TB_ACheckOutStart.Text = attendanceRule.ACheckOutStart.Trim();
            TB_AChectOutEnd.Text = attendanceRule.ACheckOutEnd.Trim();
            DDL_ACheckOutIsMust.SelectedValue = attendanceRule.ACheckOutIsMust.Trim();

            TB_NCheckInStart.Text = attendanceRule.NCheckInStart.Trim();
            TB_NCheckInEnd.Text = attendanceRule.NCheckInEnd.Trim();
            DDL_NCheckInIsMust.SelectedValue = attendanceRule.NCheckInIsMust.Trim();

            TB_NCheckOutStart.Text = attendanceRule.NCheckOutStart.Trim();
            TB_NCheckOutEnd.Text = attendanceRule.NCheckOutEnd.Trim();
            DDL_NCheckOutIsMust.SelectedValue = attendanceRule.NCheckOutIsMust.Trim();

            TB_OCheckInStart.Text = attendanceRule.OCheckInStart.Trim();
            TB_OCheckInEnd.Text = attendanceRule.OCheckInEnd.Trim();
            DDL_OCheckInIsMust.SelectedValue = attendanceRule.OCheckInIsMust.Trim();

            TB_OCheckOutStart.Text = attendanceRule.OCheckOutStart.Trim();
            TB_OCheckOutEnd.Text = attendanceRule.OCheckOutEnd.Trim();
            DDL_OCheckOutIsMust.SelectedValue = attendanceRule.OCheckOutIsMust.Trim();

            NB_LargestDistance.Amount = attendanceRule.LargestDistance;

            TB_Longitude.Text = attendanceRule.OfficeLongitude.Trim();
            TB_Latitude.Text = attendanceRule.OfficeLatitude.Trim();

            TB_Address.Text = attendanceRule.Address;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalAttendanceRule', document.getElementById('" + ((Button)e.Item.FindControl("BT_ID")).ClientID + "'));", true);
        }
    }

    protected void DataGrid30_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_KPIType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_KPIType.Text = strType;
            TB_KPITypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalKPIType', document.getElementById('" + ((Button)e.Item.FindControl("BT_KPIType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid34_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strTypeName = ((Button)e.Item.FindControl("BT_TypeName")).Text.Trim();
            string strSortNo = e.Item.Cells[1].Text.Trim();

            TB_TypeName.Text = strTypeName;
            TB_TypeSortNo.Text = strSortNo;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalWorkType', document.getElementById('" + ((Button)e.Item.FindControl("BT_TypeName")).ClientID + "'));", true);
        }
    }

    protected void DataGrid40_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strID = ((Button)e.Item.FindControl("BT_PositionID")).Text;
            string strPosition = e.Item.Cells[1].Text.Trim();
            string strSortNumber = e.Item.Cells[2].Text.Trim();

            if (e.CommandName != "Page")
            {
                for (int i = 0; i < DataGrid40.Items.Count; i++)
                {
                    DataGrid40.Items[i].ForeColor = Color.Black;
                }

                e.Item.ForeColor = Color.Red;

                LB_PositionID.Text = strID;
                TB_Position.Text = strPosition;
                TB_DepartPositionSort.Text = strSortNumber;

                // 打开编辑模态框
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalPosition', document.getElementById('" + ((Button)e.Item.FindControl("BT_PositionID")).ClientID + "'));", true);
            }
        }
    }

    protected void DataGrid50_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_FestivalsType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_FestivalsType.Text = strType;
            TB_FestivalsTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalFestivalsType', document.getElementById('" + ((Button)e.Item.FindControl("BT_FestivalsType")).ClientID + "'));", true);
        }
    }

    protected void LoadAttendanceRule()
    {
        string strHQL;
        IList lst;

        strHQL = "from AttendanceRule as attendanceRule Order by attendanceRule.ID ASC";
        AttendanceRuleBLL attendanceRuleBLL = new AttendanceRuleBLL();
        lst = attendanceRuleBLL.GetAllAttendanceRules(strHQL);

        DataGrid24.DataSource = lst;
        DataGrid24.DataBind();
    }

    protected void LoadOvertimeType()
    {
        string strHQL;

        strHQL = "Select * From T_OvertimeType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_OvertimeType");

        DataGrid16.DataSource = ds;
        DataGrid16.DataBind();
    }

    protected void LoadFestivalsType()
    {
        string strHQL;

        strHQL = "Select * From T_FestivalsType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_FestivalsType");

        DataGrid50.DataSource = ds;
        DataGrid50.DataBind();
    }

    protected void BT_NewAttendanceRule_Click(object sender, EventArgs e)
    {
        LB_AttendanceRuleID.Text = "";

        // 通过其他方式获取坐标，或者不使用坐标
        string script = @"
        (function() {
            // 创建基本的事件对象
            var simulatedEvent = {
                stopPropagation: function() { },
                preventDefault: function() { },
                target: document.getElementById('" + ((WebControl)sender).ClientID + @"')
            };
            handleAddClick('modalAttendanceRule', simulatedEvent);
        })();";

        ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "click_" + DateTime.Now.Ticks, script, true);
    }

    protected void BT_AddAttendanceRule_Click(object sender, EventArgs e)
    {
        string strMCheckInStart, strMCheckInEnd, strMCheckOutStart, strMCheckOutEnd;
        string strACheckInStart, strACheckInEnd, strACheckOutStart, strACheckOutEnd;
        string strNCheckInStart, strNCheckInEnd, strNCheckOutStart, strNCheckOutEnd;
        string strOCheckInStart, strOCheckInEnd, strOCheckOutStart, strOCheckOutEnd;

        strMCheckInStart = TB_MCheckInStart.Text.Trim();
        strMCheckInEnd = TB_MCheckInEnd.Text.Trim();
        strMCheckOutStart = TB_MCheckOutStart.Text.Trim();
        strMCheckOutEnd = TB_MCheckOutEnd.Text.Trim();

        strACheckInStart = TB_ACheckInStart.Text.Trim();
        strACheckInEnd = TB_ACheckInEnd.Text.Trim();
        strACheckOutStart = TB_ACheckOutStart.Text.Trim();
        strACheckOutEnd = TB_AChectOutEnd.Text.Trim();

        strNCheckInStart = TB_NCheckInStart.Text.Trim();
        strNCheckInEnd = TB_NCheckInEnd.Text.Trim();
        strNCheckOutStart = TB_NCheckOutStart.Text.Trim();
        strNCheckOutEnd = TB_NCheckOutEnd.Text.Trim();

        strOCheckInStart = TB_OCheckInStart.Text.Trim();
        strOCheckInEnd = TB_OCheckInEnd.Text.Trim();
        strOCheckOutStart = TB_OCheckOutStart.Text.Trim();
        strOCheckOutEnd = TB_OCheckOutEnd.Text.Trim();

        if (strMCheckInStart == "" || strMCheckInEnd == "" || strMCheckOutStart == "" || strMCheckOutEnd == ""
           || strACheckInStart == "" || strACheckInEnd == "" || strACheckOutStart == "" || strACheckOutEnd == ""
           || strNCheckInStart == "" || strNCheckInEnd == "" || strNCheckOutStart == "" || strNCheckOutEnd == ""
           || strOCheckInStart == "" || strOCheckInEnd == "" || strOCheckOutStart == "" || strOCheckOutEnd == "")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZYSGXDBNWKQJC") + "')", true);
            return;
        }

        AttendanceRuleBLL attendanceRuleBLL = new AttendanceRuleBLL();
        AttendanceRule attendanceRule = new AttendanceRule();

        attendanceRule.MCheckInStart = strMCheckInStart;
        attendanceRule.MCheckInEnd = strMCheckInEnd;
        attendanceRule.MCheckInIsMust = DDL_MCheckInIsMust.SelectedValue.Trim();

        attendanceRule.MCheckOutStart = strMCheckOutStart;
        attendanceRule.MCheckOutEnd = strMCheckOutEnd;
        attendanceRule.MCheckOutIsMust = DDL_MCheckOutIsMust.SelectedValue.Trim();

        attendanceRule.ACheckInStart = strACheckInStart;
        attendanceRule.ACheckInEnd = strACheckInEnd;
        attendanceRule.ACheckInIsMust = DDL_ACheckInIsMust.SelectedValue.Trim();

        attendanceRule.ACheckOutStart = strACheckOutStart;
        attendanceRule.ACheckOutEnd = strACheckOutEnd;
        attendanceRule.ACheckOutIsMust = DDL_ACheckOutIsMust.SelectedValue.Trim();

        attendanceRule.NCheckInStart = strNCheckInStart;
        attendanceRule.NCheckInEnd = strNCheckInEnd;
        attendanceRule.NCheckInIsMust = DDL_NCheckInIsMust.SelectedValue.Trim();

        attendanceRule.NCheckOutStart = strNCheckOutStart;
        attendanceRule.NCheckOutEnd = strNCheckOutEnd;
        attendanceRule.NCheckOutIsMust = DDL_NCheckOutIsMust.SelectedValue.Trim();

        attendanceRule.OCheckInStart = strOCheckInStart;
        attendanceRule.OCheckInEnd = strOCheckInEnd;
        attendanceRule.OCheckInIsMust = DDL_OCheckInIsMust.SelectedValue.Trim();

        attendanceRule.OCheckOutStart = strOCheckOutStart;
        attendanceRule.OCheckOutEnd = strOCheckOutEnd;
        attendanceRule.OCheckOutIsMust = DDL_OCheckOutIsMust.SelectedValue.Trim();

        attendanceRule.LargestDistance = NB_LargestDistance.Amount;

        attendanceRule.OfficeLatitude = TB_Latitude.Text.Trim();
        attendanceRule.OfficeLongitude = TB_Longitude.Text.Trim();

        attendanceRule.Address = TB_Address.Text.Trim();

       
       
        try
        {
            if (LB_AttendanceRuleID.Text == "")
            {
                attendanceRuleBLL.AddAttendanceRule(attendanceRule);
            }
            else
            {
                attendanceRuleBLL.UpdateAttendanceRule(attendanceRule, int.Parse(LB_AttendanceRuleID.Text.Trim()));
            }
          
        }
        catch
        {
            try
            {
                attendanceRuleBLL.UpdateAttendanceRule(attendanceRule, int.Parse(LB_AttendanceRuleID.Text.Trim()));
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSBJC") + "')", true);
            }
        }

        LoadAttendanceRule();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalAttendanceRule');", true);
    }

    protected void BT_DeleteAttendanceRule_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strID;

        strID = LB_AttendanceRuleID.Text.Trim();

        if (string.IsNullOrEmpty(strID))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('请选择要删除的记录')", true);
            return;
        }

        strHQL = "Delete From T_AttendanceRule Where ID = " + strID;
        ShareClass.RunSqlCommand(strHQL);

        LoadAttendanceRule();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalAttendanceRule');", true);
    }

    protected void BT_ScheduleLimitedDaysUpdate_Click(object sender, EventArgs e)
    {
        string strHQL;
        int intLimitedDays;

        intLimitedDays = int.Parse(NB_ScheduleLimitedDays.Amount.ToString());

        try
        {
            strHQL = "Delete From T_ScheduleLimitedDays ";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_ScheduleLimitedDays(LimitedDays) Values(" + intLimitedDays.ToString() + ")";
            ShareClass.RunSqlCommand(strHQL);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSB") + "')", true);
        }
    }

    protected void BT_WorkingDayRuleUpdate_Click(object sender, EventArgs e)
    {
        string strHQL;
        int intWeekendFirstDay, intWeekendSecondDay;
        string strWeekendsAreWorkdays;

        intWeekendFirstDay = int.Parse(NB_WeekendFirstDay.Amount.ToString());
        intWeekendSecondDay = int.Parse(NB_WeekendSecondDay.Amount.ToString());
        strWeekendsAreWorkdays = DL_WeekendsAreWorkdays.SelectedValue;

        if (intWeekendFirstDay < 0 | intWeekendFirstDay > 6 | intWeekendSecondDay < 0 | intWeekendSecondDay > 6)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBaoCunShiBaiZhouMoKaiShiRiJi") + "')", true);
            return;
        }

        try
        {
            strHQL = "Delete From T_WorkingDayRule ";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Insert Into T_WorkingDayRule(WeekendFirstDay,WeekendSecondDay,WeekendsAreWorkdays) Values(" + intWeekendFirstDay.ToString() + "," + intWeekendSecondDay + ",'" + strWeekendsAreWorkdays + "')";
            ShareClass.RunSqlCommand(strHQL);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSB") + "')", true);
        }
    }

    protected int GetScheduleLimitedDays()
    {
        string strHQL;

        strHQL = "Select LimitedDays From T_ScheduleLimitedDays";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ScheduleLimitedDays");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return int.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 0;
        }
    }

    protected void BT_NewPosition_Click(object sender, EventArgs e)
    {
        string strPositon;
        string strSortNumber;

        strPositon = TB_Position.Text.Trim();
        strSortNumber = TB_DepartPositionSort.Text.Trim();

        DepartPositionBLL departPositionBLL = new DepartPositionBLL();
        DepartPosition departPosition = new DepartPosition();

        departPosition.Position = strPositon;
        departPosition.SortNumber = int.Parse(strSortNumber);

        try
        {
            departPositionBLL.AddDepartPosition(departPosition);
        }
        catch
        {
            try
            {
                departPositionBLL.UpdateDepartPosition(departPosition, int.Parse(LB_PositionID.Text.Trim()));
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
            }
        }

        LoadDepartPosition();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalPosition');", true);
    }

    protected void BT_UpdatePosition_Click(object sender, EventArgs e)
    {
        string strID, strPositon, strSortNumber;

        strID = LB_PositionID.Text.Trim();
        strPositon = TB_Position.Text.Trim();
        strSortNumber = TB_DepartPositionSort.Text.Trim();

        if (string.IsNullOrEmpty(strID))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('请选择要更新的记录')", true);
            return;
        }

        DepartPositionBLL departPositionBLL = new DepartPositionBLL();
        DepartPosition departPosition = new DepartPosition();

        departPosition.ID = int.Parse(strID);
        departPosition.Position = strPositon;
        departPosition.SortNumber = int.Parse(strSortNumber);

        try
        {
            departPositionBLL.UpdateDepartPosition(departPosition, int.Parse(strID));

            LoadDepartPosition();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalPosition');", true);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
        }
    }

    protected void BT_DeletePosition_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strID = LB_PositionID.Text.Trim();

        if (string.IsNullOrEmpty(strID))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('请选择要删除的记录')", true);
            return;
        }

        strHQL = "Delete From T_DepartPosition Where ID = " + strID;
        ShareClass.RunSqlCommand(strHQL);

        LoadDepartPosition();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalPosition');", true);
    }

    protected void BT_AddKPIType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_KPIType.Text.Trim();
        strSortNumber = TB_KPITypeSort.Text.Trim();

        KPITypeBLL kpiTypeBLL = new KPITypeBLL();
        KPIType kpiType = new KPIType();

        kpiType.Type = strType;
        kpiType.SortNumber = int.Parse(strSortNumber);

        try
        {
            kpiTypeBLL.AddKPIType(kpiType);
        }
        catch
        {
            try
            {
                kpiTypeBLL.UpdateKPIType(kpiType, strType);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
            }
        }


        LoadKPIType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalKPIType');", true);
    }

    protected void BT_DeleteKPIType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_KPIType.Text.Trim();
        strSortNumber = TB_KPITypeSort.Text.Trim();

        KPITypeBLL kpiTypeBLL = new KPITypeBLL();
        KPIType kpiType = new KPIType();

        kpiType.Type = strType;
        kpiType.SortNumber = int.Parse(strSortNumber);

        try
        {
            kpiTypeBLL.DeleteKPIType(kpiType);

            LoadKPIType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalKPIType');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
        }
    }

    protected void BT_KPICheckWeight_Click(object sender, EventArgs e)
    {
        string strHQL;

        decimal deSelfCheckWeight, deLeaderCheckWeight, deThirdPartCheckWeight, deSqlCheckWeight, deHRCheckWeight;
        decimal deSum;

        deSelfCheckWeight = NB_KPISelfCheckWeight.Amount;
        deLeaderCheckWeight = NB_KPILeaderCheckWeight.Amount;
        deThirdPartCheckWeight = NB_KPIThirdPartCheckWeight.Amount;
        deSqlCheckWeight = NB_KPISqlCheckWeight.Amount;
        deHRCheckWeight = NB_KPIHRCheckWeight.Amount;

        deSum = deSelfCheckWeight + deLeaderCheckWeight + deThirdPartCheckWeight + deSqlCheckWeight + deHRCheckWeight;

        if (deSum > 1)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGZZHBNDY1JC") + "')", true);
            return;
        }

        strHQL = " Select * From T_KPICheckTypeWeight ";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_KPICheckTypeWeight");
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "Insert Into T_KPICheckTypeWeight(SelfCheckWeight,LeaderCheckWeight,ThirdPartCheckWeight,SqlCheckWeight,HRCheckWeight)";
            strHQL += " Values(" + deSelfCheckWeight.ToString() + "," + deLeaderCheckWeight.ToString() + "," + deThirdPartCheckWeight.ToString() + "," + deSqlCheckWeight.ToString() + "," + deHRCheckWeight.ToString() + ")";

            try
            {
                ShareClass.RunSqlCommand(strHQL);
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
            }
            catch
            {
            }
        }
        else
        {
            strHQL = " Update T_KPICheckTypeWeight Set SelfCheckWeight = " + deSelfCheckWeight.ToString() + ",LeaderCheckWeight = " + deLeaderCheckWeight.ToString() + ",ThirdPartCheckWeight = " + deThirdPartCheckWeight.ToString() + ",SqlCheckWeight = " + deSelfCheckWeight.ToString() + ",HRCheckWeight = " + deHRCheckWeight.ToString();

            try
            {
                ShareClass.RunSqlCommand(strHQL);
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
            }
            catch
            {
            }
        }
    }

    protected void LoadKPIType()
    {
        string strHQL;
        IList lst;

        strHQL = "from KPIType as kpiType Order By kpiType.SortNumber ASC";
        KPITypeBLL kpiTypeBLL = new KPITypeBLL();
        lst = kpiTypeBLL.GetAllKPITypes(strHQL);

        DataGrid30.DataSource = lst;
        DataGrid30.DataBind();
    }

    protected void BT_NewDuty_Click(object sender, EventArgs e)
    {
        string strDuty, strKeyWord;
        string strSortNumber;

        strDuty = TB_Duty.Text.Trim();
        strKeyWord = TB_DutyKeyWord.Text.Trim();
        strSortNumber = TB_DutySort.Text.Trim();

        UserDutyBLL userDutyBLL = new UserDutyBLL();
        UserDuty userDuty = new UserDuty();

        userDuty.Duty = strDuty;
        userDuty.KeyWord = strKeyWord;
        userDuty.SortNumber = int.Parse(strSortNumber);
        LB_Duty_Backup.Text = strDuty;

        if (strKeyWord == "DRIVER" | strKeyWord == "GUARD")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGSJHMWZWYJCZJC") + "')", true);
            return;
        }

        try
        {
            userDutyBLL.AddUserDuty(userDuty);
        }
        catch
        {
            try
            {
                userDutyBLL.UpdateUserDuty(userDuty, strDuty);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
            }
        }


        LoadUserDuty();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalDuty');", true);
    }

    protected void BT_UpdateDuty_Click(object sender, EventArgs e)
    {
        string strHQL;

        string strDuty, strDuty_Backup;
        string strSortNumber;
        string strKeyWord, strKeyWord_Backup;

        strDuty = TB_Duty.Text.Trim();
        strDuty_Backup = LB_Duty_Backup.Text.Trim();
        strKeyWord = TB_DutyKeyWord.Text.Trim();
        strKeyWord_Backup = LB_DutyKeyWord_Backup.Text.Trim();
        strSortNumber = TB_DutySort.Text.Trim();

        try
        {
            if (strKeyWord_Backup != "DRIVER" & strKeyWord_Backup != "GUARD")
            {
                strHQL = "Update T_UserDuty Set Duty = " + "'" + strDuty + "'" + ",KeyWord=" + "'" + strKeyWord + "'" + ",SortNumber = " + strSortNumber;
            }
            else
            {
                strHQL = "Update T_UserDuty Set Duty = " + "'" + strDuty + "'" + ",SortNumber = " + strSortNumber;
            }
            strHQL += " Where Duty = " + "'" + strDuty_Backup + "'";

            ShareClass.RunSqlCommand(strHQL);
            LoadUserDuty();

            LB_Duty_Backup.Text = strDuty;
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalDuty');", true);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
        }
    }

    protected void BT_DeleteDuty_Click(object sender, EventArgs e)
    {
        string strHQL;
        IList lst;

        string strDuty;
        string strSortNumber;
        string strKeyWord;

        strDuty = TB_Duty.Text.Trim();
        strSortNumber = TB_DutySort.Text.Trim();

        strHQL = "From UserDuty as userDuty Where userDuty.Duty = " + "'" + strDuty + "'";
        UserDutyBLL userDutyBLL = new UserDutyBLL();
        lst = userDutyBLL.GetAllUserDutys(strHQL);

        try
        {
            UserDuty userDuty = (UserDuty)lst[0];

            strKeyWord = userDuty.KeyWord.Trim();
            if (strKeyWord == "DRIVER" | strKeyWord == "GUARD")
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGSJHMWZWBNSC") + "')", true);
                return;
            }
            userDutyBLL.DeleteUserDuty(userDuty);

            LoadUserDuty();

            LB_Duty_Backup.Text = "";
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalDuty');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
        }
    }

    protected bool IsOilTypeExits(string strP)
    {
        bool flag = true;
        string strHQL = " from OilType as OilType where OilType.OilName = '" + strP + "' ";
        OilTypeBLL OilTypeBLL = new OilTypeBLL();
        IList lst = OilTypeBLL.GetAllOilType(strHQL);
        if (lst.Count > 0)
        {
            flag = false;
        }
        else
            flag = true;

        return flag;
    }

    protected void BT_AddBookReaderType_Click(object sender, EventArgs e)
    {
        string strTypeName = TB_TypeName.Text.Trim();
        string strSortNo = string.IsNullOrEmpty(TB_TypeSortNo.Text.Trim()) ? "0" : TB_TypeSortNo.Text.Trim();
        if (!IsNumeric(strSortNo))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSRZDSXYDY0DZSJC") + "')", true);
            TB_TypeSortNo.Focus();
            return;
        }
        if (strSortNo.Contains(".") || strSortNo.Contains("-"))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSRZDSXYDY0DZSJC") + "')", true);
            TB_TypeSortNo.Focus();
            return;
        }
        if (IsBookReaderType(strTypeName))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGLXMCZSJBZYCZJC") + "')", true);
            TB_TypeName.Focus();
            return;
        }

        WorkTypeBLL workTypeBLL = new WorkTypeBLL();
        WorkType workType = new WorkType();
        workType.TypeName = strTypeName;
        workType.SortNo = int.Parse(strSortNo);


        try
        {
            workTypeBLL.AddWorkType(workType);
        }
        catch
        {
            try
            {
                workTypeBLL.UpdateWorkType(workType, strTypeName);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
            }
        }

        LoadBookReaderType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalWorkType');", true);
    }

    protected void BT_DeleteBookReaderType_Click(object sender, EventArgs e)
    {
        string strTypeName = TB_TypeName.Text.Trim();
        string strSortNo = string.IsNullOrEmpty(TB_TypeSortNo.Text.Trim()) ? "0" : TB_TypeSortNo.Text.Trim();

        WorkTypeBLL workTypeBLL = new WorkTypeBLL();
        WorkType workType = new WorkType();

        try
        {
            workType.TypeName = strTypeName;
            workType.SortNo = int.Parse(strSortNo);

            workTypeBLL.DeleteWorkType(workType);

            LoadBookReaderType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalWorkType');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
        }
    }

    protected void BT_OvertimeTypeNew_Click(object sender, EventArgs e)
    {
        string strType = TB_OvertimeType.Text.Trim();
        string strSortNo = TB_OvertimeTypeSort.Text.Trim();

        try
        {
            string strHQL = "Insert Into T_OvertimeType(Type,SortNumber) VAlues (" + "'" + strType + "'" + "," + "'" + strSortNo + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                string updateHQL = " Update T_OvertimeType Set SortNumber = " + strSortNo + " Where Type = '" + strType + "'";
                ShareClass.RunSqlCommand(updateHQL);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
            }
        }

        LoadOvertimeType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalOvertimeType');", true);

    }

    protected void BT_OvertimeTypeDelete_Click(object sender, EventArgs e)
    {
        string strType = TB_OvertimeType.Text.Trim();
        string strSortNo = TB_OvertimeTypeSort.Text.Trim();

        string strHQL = "Delete From T_OvertimeType Where Type =  '" + strType + "'";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadOvertimeType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalOvertimeType');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
        }
    }

    protected void BT_FestivalsTypeNew_Click(object sender, EventArgs e)
    {
        string strType = TB_FestivalsType.Text.Trim();
        string strSortNo = TB_FestivalsTypeSort.Text.Trim();

        string strHQL = "Insert Into T_FestivalsType(Type,SortNumber) VAlues (" + "'" + strType + "'" + "," + "'" + strSortNo + "'" + ")";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                string updateHQL = " Update T_FestivalsType Set SortNumber = " + strSortNo + " Where Type = '" + strType + "'";
                ShareClass.RunSqlCommand(updateHQL);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
            }
        }

        LoadFestivalsType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalFestivalsType');", true);
    }

    protected void BT_FestivalsTypeDelete_Click(object sender, EventArgs e)
    {
        string strType = TB_FestivalsType.Text.Trim();
        string strSortNo = TB_FestivalsTypeSort.Text.Trim();

        string strHQL = "Delete From T_FestivalsType Where Type =  '" + strType + "'";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadFestivalsType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalFestivalsType');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
        }
    }

    /// <summary>
    /// 读者类型数据
    /// </summary>
    protected void LoadBookReaderType()
    {
        string strHQL = "from WorkType as workType order by workType.SortNo ASC";
        WorkTypeBLL workTypeBLL = new WorkTypeBLL();
        IList lst = workTypeBLL.GetAllWorkType(strHQL);

        DataGrid34.DataSource = lst;
        DataGrid34.DataBind();
    }

    /// <summary>
    /// 判断读者类型是否存在  存在返回true；不存在则返回false
    /// </summary>
    protected bool IsBookReaderType(string strtypename)
    {
        bool flag = true;
        string strHQL = "from WorkType as workType Where workType.TypeName='" + strtypename + "' ";
        WorkTypeBLL workTypeBLL = new WorkTypeBLL();
        IList lst = workTypeBLL.GetAllWorkType(strHQL);
        if (lst.Count > 0 && lst != null)
        {
            flag = true;
        }
        else
            flag = false;
        return flag;
    }

    //判断输入的字符是否是数字
    private bool IsNumeric(string str)
    {
        System.Text.RegularExpressions.Regex reg1
            = new System.Text.RegularExpressions.Regex(@"^[-]?\d+[.]?\d*$");
        return reg1.IsMatch(str);
    }

    protected void LoadLeaveType()
    {
        string strHQL;
        IList lst;

        strHQL = "from LeaveType as leaveType Order By leaveType.SortNumber ASC";
        LeaveTypeBLL leaveTypeBLL = new LeaveTypeBLL();
        lst = leaveTypeBLL.GetAllLeaveTypes(strHQL);

        DataGrid17.DataSource = lst;
        DataGrid17.DataBind();
    }

    protected void LoadDepartPosition()
    {
        string strHQL;
        IList lst;

        strHQL = "From DepartPosition as departPosition Order By departPosition.SortNumber ASC";
        DepartPositionBLL departPositionBLL = new DepartPositionBLL();
        lst = departPositionBLL.GetAllDepartPositions(strHQL);

        DataGrid40.DataSource = lst;
        DataGrid40.DataBind();
    }

    protected void LoadUserDuty()
    {
        string strHQL;
        IList lst;

        strHQL = "From UserDuty as userDuty Order By userDuty.SortNumber ASC";
        UserDutyBLL userDutyBLL = new UserDutyBLL();
        lst = userDutyBLL.GetAllUserDutys(strHQL);

        DataGrid1.DataSource = lst;
        DataGrid1.DataBind();
    }

    protected void LoadKPICheckTypeWeight()
    {
        string strHQL;

        strHQL = "Select SelfCheckWeight,LeaderCheckWeight,ThirdPartCheckWeight,SqlCheckWeight,HRCheckWeight From T_KPICheckTypeWeight";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_KPICheckTypeWeight");

        if (ds.Tables[0].Rows.Count > 0)
        {
            NB_KPISelfCheckWeight.Amount = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            NB_KPILeaderCheckWeight.Amount = decimal.Parse(ds.Tables[0].Rows[0][1].ToString());
            NB_KPIThirdPartCheckWeight.Amount = decimal.Parse(ds.Tables[0].Rows[0][2].ToString());
            NB_KPISqlCheckWeight.Amount = decimal.Parse(ds.Tables[0].Rows[0][3].ToString());
            NB_KPIHRCheckWeight.Amount = decimal.Parse(ds.Tables[0].Rows[0][4].ToString());
        }
    }

    protected void BT_AddLeaveType_Click(object sender, EventArgs e)
    {
        if (TB_LeaveType.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJLXWBTSJJC") + "')", true);
            TB_LeaveType.Focus();
            return;
        }
        if (TB_LeaveSortNumber.Text.Trim() != "")
        {
            if (!IsNumeric(TB_LeaveSortNumber.Text.Trim()))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSRZDSXYDY0DZSJC") + "')", true);
                TB_LeaveSortNumber.Focus();
                return;
            }
        }
        string strType, strSortNumber;

        strType = TB_LeaveType.Text.Trim();
        strSortNumber = TB_LeaveSortNumber.Text.Trim() == "" ? "0" : TB_LeaveSortNumber.Text.Trim();

        LeaveTypeBLL leaveTypeBLL = new LeaveTypeBLL();
        LeaveType leaveType = new LeaveType();

        leaveType.Type = strType;
        leaveType.SortNumber = int.Parse(strSortNumber);

        try
        {
            leaveTypeBLL.AddLeaveType(leaveType);
        }
        catch
        {
            try
            {
                leaveTypeBLL.UpdateLeaveType(leaveType, strType);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
            }
        }

        LoadLeaveType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalLeaveType');", true);
    }

    protected void BT_DeleteLeaveType_Click(object sender, EventArgs e)
    {
        if (TB_LeaveType.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJLXWBTSJJC") + "')", true);
            TB_LeaveType.Focus();
            return;
        }
        if (TB_LeaveSortNumber.Text.Trim() != "")
        {
            if (!IsNumeric(TB_LeaveSortNumber.Text.Trim()))
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSRZDSXYDY0DZSJC") + "')", true);
                TB_LeaveSortNumber.Focus();
                return;
            }
        }
        string strType, strSortNumber;

        strType = TB_LeaveType.Text.Trim();
        strSortNumber = TB_LeaveSortNumber.Text.Trim() == "" ? "0" : TB_LeaveSortNumber.Text.Trim();

        LeaveTypeBLL leaveTypeBLL = new LeaveTypeBLL();
        LeaveType leaveType = new LeaveType();

        leaveType.Type = strType;
        leaveType.SortNumber = int.Parse(strSortNumber);

        try
        {
            leaveTypeBLL.DeleteLeaveType(leaveType);

            LoadLeaveType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalLeaveType');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message + "')", true);
        }
    }

    protected void LoadDayHourNum()
    {
        string strHQL = "Select * From T_DayHourNum Order By ID Asc ";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_DayHourNum");

        try
        {
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                lbl_DayHourNumID.Text = ds.Tables[0].Rows[0]["ID"].ToString().Trim();
                TB_HourNum.Text = ds.Tables[0].Rows[0]["HourNum"].ToString().Trim();
                DL_StartHour.SelectedValue = ds.Tables[0].Rows[0]["StartTime"].ToString().Trim().Substring(0, 2);
                DL_StartMin.SelectedValue = ds.Tables[0].Rows[0]["StartTime"].ToString().Trim().Substring(3, 2);
                DL_EndHour.SelectedValue = ds.Tables[0].Rows[0]["EndTime"].ToString().Trim().Substring(0, 2);
                DL_EndMin.SelectedValue = ds.Tables[0].Rows[0]["EndTime"].ToString().Trim().Substring(3, 2);

                DL_RestStartTimeHour.SelectedValue = ds.Tables[0].Rows[0]["RestStartTime"].ToString().Trim().Substring(0, 2);
                DL_RestStartTimeMin.SelectedValue = ds.Tables[0].Rows[0]["RestStartTime"].ToString().Trim().Substring(3, 2);
                DL_RestEndTimeHour.SelectedValue = ds.Tables[0].Rows[0]["RestEndTime"].ToString().Trim().Substring(0, 2);
                DL_RestEndTimeMin.SelectedValue = ds.Tables[0].Rows[0]["RestEndTime"].ToString().Trim().Substring(3, 2);
            }
            else
            {
                lbl_DayHourNumID.Text = "";
                TB_HourNum.Text = "8";
                DL_StartHour.SelectedValue = "08";
                DL_StartMin.SelectedValue = "30";
                DL_EndHour.SelectedValue = "18";
                DL_EndMin.SelectedValue = "30";

                DL_RestStartTimeHour.SelectedValue = "12";
                DL_RestStartTimeMin.SelectedValue = "00";
                DL_RestEndTimeHour.SelectedValue = "14";
                DL_RestEndTimeMin.SelectedValue = "00";
            }
        }
        catch
        {

        }
    }

    protected void BT_DayHourNum_Click(object sender, EventArgs e)
    {
        DayHourNumBLL dayHourNumBLL = new DayHourNumBLL();
        try
        {
            if (lbl_DayHourNumID.Text.Trim() == "")//增加
            {
                DayHourNum dayHourNum = new DayHourNum();

                dayHourNum.HourNum = decimal.Parse(TB_HourNum.Text.Trim() == "" ? "8" : TB_HourNum.Text.Trim());
                dayHourNum.EndTime = DL_EndHour.SelectedValue.Trim() + ":" + DL_EndMin.SelectedValue.Trim();
                dayHourNum.StartTime = DL_StartHour.SelectedValue.Trim() + ":" + DL_StartMin.SelectedValue.Trim();
                dayHourNum.RestStartTime = DL_RestStartTimeHour.SelectedValue.Trim() + ":" + DL_RestStartTimeMin.SelectedValue.Trim();
                dayHourNum.RestEndTime = DL_RestEndTimeHour.SelectedValue.Trim() + ":" + DL_RestEndTimeMin.SelectedValue.Trim();
                DateTime dt1 = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dayHourNum.StartTime.Trim());
                DateTime dt2 = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dayHourNum.EndTime.Trim());
                DateTime dt3 = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dayHourNum.RestStartTime.Trim());
                DateTime dt4 = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dayHourNum.RestEndTime.Trim());
                if (dt1 >= dt2)
                {
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZKSSJYXYJSSJJC") + "')", true);
                    return;
                }
                if (dt3 >= dt4)
                {
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZXXSD1YXYXXSD2JC") + "')", true);
                    return;
                }
                if (dt3 < dt1)
                {
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZXXSD1BNXYKSSJJC") + "')", true);
                    return;
                }
                if (dt4 > dt2)
                {
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZXXSD2BNDYJSSJJC") + "')", true);
                    return;
                }
                TimeSpan ts1 = dt2.Subtract(dt1);
                TimeSpan ts2 = dt4.Subtract(dt3);
                if (double.Parse(dayHourNum.HourNum.ToString()) + ts2.TotalHours > ts1.TotalHours)
                {
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGZSJXXSJCCSBSJJC") + "')", true);
                    return;
                }
                dayHourNumBLL.AddDayHourNum(dayHourNum);
                lbl_DayHourNumID.Text = GetDayHourNumID();
            }
            else//更新
            {
                string strHQL = "From DayHourNum as dayHourNum Where dayHourNum.ID='" + lbl_DayHourNumID.Text.Trim() + "' ";
                IList lst = dayHourNumBLL.GetAllDayHourNums(strHQL);
                if (lst.Count > 0 && lst != null)
                {
                    DayHourNum dayHourNum = (DayHourNum)lst[0];
                    dayHourNum.HourNum = decimal.Parse(TB_HourNum.Text.Trim() == "" ? "8" : TB_HourNum.Text.Trim());
                    dayHourNum.EndTime = DL_EndHour.SelectedValue.Trim() + ":" + DL_EndMin.SelectedValue.Trim();
                    dayHourNum.StartTime = DL_StartHour.SelectedValue.Trim() + ":" + DL_StartMin.SelectedValue.Trim();
                    dayHourNum.RestStartTime = DL_RestStartTimeHour.SelectedValue.Trim() + ":" + DL_RestStartTimeMin.SelectedValue.Trim();
                    dayHourNum.RestEndTime = DL_RestEndTimeHour.SelectedValue.Trim() + ":" + DL_RestEndTimeMin.SelectedValue.Trim();
                    DateTime dt1 = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dayHourNum.StartTime.Trim());
                    DateTime dt2 = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dayHourNum.EndTime.Trim());
                    DateTime dt3 = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dayHourNum.RestStartTime.Trim());
                    DateTime dt4 = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dayHourNum.RestEndTime.Trim());
                    if (dt1 >= dt2)
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZKSSJYXYJSSJJC") + "')", true);
                        return;
                    }
                    if (dt3 >= dt4)
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZXXSD1YXYXXSD2JC") + "')", true);
                        return;
                    }
                    if (dt3 < dt1)
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZXXSD1BNXYKSSJJC") + "')", true);
                        return;
                    }
                    if (dt4 > dt2)
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZXXSD2BNDYJSSJJC") + "')", true);
                        return;
                    }
                    TimeSpan ts1 = dt2.Subtract(dt1);
                    TimeSpan ts2 = dt4.Subtract(dt3);
                    if (double.Parse(dayHourNum.HourNum.ToString()) + ts2.TotalHours > ts1.TotalHours)
                    {
                        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGZSJXXSJCCSBSJJC") + "')", true);
                        return;
                    }
                    dayHourNumBLL.UpdateDayHourNum(dayHourNum, dayHourNum.ID);
                }
            }

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCSB") + "')", true);
        }
    }

    protected string GetDayHourNumID()
    {
        string flag = "0";
        string strHQL = "From DayHourNum as dayHourNum Order By dayHourNum.ID Desc ";
        DayHourNumBLL dayHourNumBLL = new DayHourNumBLL();
        IList lst = dayHourNumBLL.GetAllDayHourNums(strHQL);
        if (lst.Count > 0 && lst != null)
        {
            DayHourNum dayHourNum = (DayHourNum)lst[0];
            flag = dayHourNum.ID.ToString();
        }
        return flag;
    }
}