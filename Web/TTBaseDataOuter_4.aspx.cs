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

public partial class TTBaseDataOuter_4 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode;

        strUserCode = Session["UserCode"].ToString();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            LoadBarType();
            LoadReqType();
            LoadTaskType();
            LoadTaskOperation();
            LoadTaskRecordType();
            LoadDailyWorkUnitBonus();
            LoadPlanType();
            LoadCodeRule();
            LoadSupplierBigType();
            LoadSupplierSmallType();
            LoadBMBidType();
            LoadTenderContent();
            LoadFundingSource();
        }
    }

    protected void DL_BarType_SelectedIndexChanged(object sender, EventArgs e)
    {
        string strHQL;
        string strBarType;

        strBarType = DL_BarType.SelectedValue.Trim();

        try
        {
            strHQL = "Update T_BarType Set Type = '" + strBarType + "'";
            ShareClass.RunSqlCommand(strHQL);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGGCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGGSBJC") + "')", true);
        }
    }

    protected void DataGrid2_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_ReqType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_ReqType.Text = strType;
            TB_ReqTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalReqType', document.getElementById('" + ((Button)e.Item.FindControl("BT_ReqType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid5_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_SupplierBigType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_SupplierBigType.Text = strType;
            TB_SupplierBigTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalSupplierBigType', document.getElementById('" + ((Button)e.Item.FindControl("BT_SupplierBigType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid6_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_SupplierSmallType")).Text.Trim();
            string strBigType = e.Item.Cells[1].Text;
            string strSortNumber = e.Item.Cells[2].Text.Trim();

            TB_SupplierSmallType.Text = strType;
            TB_SupplierSmallTypeSort.Text = strSortNumber;
            DL_SupplierBigType.SelectedValue = strBigType;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalSupplierSmallType', document.getElementById('" + ((Button)e.Item.FindControl("BT_SupplierSmallType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid7_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strOperation = ((Button)e.Item.FindControl("BT_Operation")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_TaskOperation.Text = strOperation;
            TB_OperationSortNumber.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalTaskOperation', document.getElementById('" + ((Button)e.Item.FindControl("BT_Operation")).ClientID + "'));", true);
        }
    }

    protected void DataGrid8_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_BMBidType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_BMBidType.Text = strType;
            TB_BMBidTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalBMBidType', document.getElementById('" + ((Button)e.Item.FindControl("BT_BMBidType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid18_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_TaskType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_TaskType.Text = strType;
            TB_TaskTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalTaskType', document.getElementById('" + ((Button)e.Item.FindControl("BT_TaskType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid19_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_TaskRecordType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_TaskRecordType.Text = strType;
            TB_TaskRecordTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalTaskRecordType', document.getElementById('" + ((Button)e.Item.FindControl("BT_TaskRecordType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid23_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strID = ((Button)e.Item.FindControl("BT_ID")).Text.Trim();
            string strEveryCharPrice = e.Item.Cells[1].Text.Trim();
            string strCharUpper = e.Item.Cells[2].Text.Trim();
            string strEveryDocPrice = e.Item.Cells[3].Text.Trim();
            string strDocUpper = e.Item.Cells[4].Text.Trim();

            LB_DailyWorkUnitBonusID.Text = strID;
            NB_EveryCharPrice.Amount = decimal.Parse(strEveryCharPrice);
            NB_EveryDocPrice.Amount = decimal.Parse(strEveryDocPrice);
            NB_CharUpper.Amount = int.Parse(strCharUpper);
            NB_DocUpper.Amount = int.Parse(strDocUpper);

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalDailyWorkUnitBonus', document.getElementById('" + ((Button)e.Item.FindControl("BT_ID")).ClientID + "'));", true);
        }
    }

    protected void DataGrid28_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_PlanType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_PlanType.Text = strType;
            TB_PlanTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalPlanType', document.getElementById('" + ((Button)e.Item.FindControl("BT_PlanType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid44_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strID = ((Button)e.Item.FindControl("BT_CodeRuleID")).Text.Trim();

            string strHQL;

            strHQL = "Select CodeType,HeadChar,FieldName,FlowIDWidth,IsStartup From T_CodeRule Where ID = " + strID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CodeRule");

            LB_CodeRuleID.Text = strID;
            DL_CodeType.SelectedValue = ds.Tables[0].Rows[0][0].ToString().Trim();
            TB_HeadChar.Text = ds.Tables[0].Rows[0][1].ToString();
            DL_FieldRule.SelectedValue = ds.Tables[0].Rows[0][2].ToString().Trim();
            TB_FlowIDWidth.Text = ds.Tables[0].Rows[0][3].ToString();
            DL_IsStartup.SelectedValue = ds.Tables[0].Rows[0][4].ToString().Trim();

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalCodeRule', document.getElementById('" + ((Button)e.Item.FindControl("BT_CodeRuleID")).ClientID + "'));", true);
        }
    }

    protected void DataGrid13_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strTenderContent = ((Button)e.Item.FindControl("BT_TenderContent")).Text;
            TB_TenderContent.Text = strTenderContent;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalTenderContent', document.getElementById('" + ((Button)e.Item.FindControl("BT_TenderContent")).ClientID + "'));", true);
        }
    }

    protected void DataGrid20_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strFundingSource = ((Button)e.Item.FindControl("BT_FundingSource")).Text;
            TB_FundingSource.Text = strFundingSource;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalFundingSource', document.getElementById('" + ((Button)e.Item.FindControl("BT_FundingSource")).ClientID + "'));", true);
        }
    }

    protected void BT_ReqTypeNew_Click(object sender, EventArgs e)
    {
        string strReqType = TB_ReqType.Text.Trim();
        string strSortNumber = TB_ReqTypeSort.Text.Trim();

        ReqTypeBLL reqTypeBLL = new ReqTypeBLL();
        ReqType reqType = new ReqType();

        reqType.Type = strReqType;
        reqType.SortNumber = int.Parse(strSortNumber);

        try
        {
            reqTypeBLL.AddReqType(reqType);
        }
        catch
        {
            try
            {
                reqTypeBLL.UpdateReqType(reqType, strReqType);
            }
            catch
            {
            }
        }

        LoadReqType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalReqType');", true);
    }

    protected void BT_ReqTypeDelete_Click(object sender, EventArgs e)
    {
        string strReqType = TB_ReqType.Text.Trim();
        string strSortNumber = TB_ReqTypeSort.Text.Trim();

        ReqTypeBLL reqTypeBLL = new ReqTypeBLL();
        ReqType reqType = new ReqType();

        try
        {
            reqType.Type = strReqType;
            reqType.SortNumber = int.Parse(strSortNumber);

            reqTypeBLL.DeleteReqType(reqType);

            LoadReqType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalReqType');", true);
        }
        catch
        {
        }
    }

    protected void LoadBarType()
    {
        string strHQL = "Select Type From T_BarType";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BarType");

        if (ds.Tables[0].Rows.Count > 0)
        {
            try
            {
                DL_BarType.SelectedValue = ds.Tables[0].Rows[0][0].ToString().Trim();
            }
            catch
            {
            }
        }
    }

    protected void LoadReqType()
    {
        string strHQL = "from ReqType as reqType order by reqType.SortNumber ASC";
        ReqTypeBLL reqTypeBLL = new ReqTypeBLL();
        IList lst = reqTypeBLL.GetAllReqTypes(strHQL);

        DataGrid2.DataSource = lst;
        DataGrid2.DataBind();
    }

    protected void LoadTaskOperation()
    {
        string strHQL = "from TaskOperation as taskOperation order by taskOperation.SortNumber ASC";
        TaskOperationBLL taskOperationBLL = new TaskOperationBLL();
        IList lst = taskOperationBLL.GetAllTaskOperations(strHQL);

        DataGrid7.DataSource = lst;
        DataGrid7.DataBind();
    }

    protected void LoadTaskType()
    {
        string strHQl = "from TaskType as taskType order by taskType.SortNumber ASC";
        TaskTypeBLL taskTypeBLL = new TaskTypeBLL();
        IList lst = taskTypeBLL.GetAllTaskTypes(strHQl);

        DataGrid18.DataSource = lst;
        DataGrid18.DataBind();
    }

    protected void LoadTaskRecordType()
    {
        string strHQL = "from TaskRecordType as taskRecordType order by taskRecordType.SortNumber ASC";
        TaskRecordTypeBLL taskRecordTypeBLL = new TaskRecordTypeBLL();
        IList lst = taskRecordTypeBLL.GetAllTaskRecordTypes(strHQL);

        DataGrid19.DataSource = lst;
        DataGrid19.DataBind();
    }

    protected void LoadDailyWorkUnitBonus()
    {
        string strHQL;
        IList lst;

        strHQL = "from DailyWorkUnitBonus as dailyWorkUnitBonus Order by dailyWorkUnitBonus.ID ASC";
        DailyWorkUnitBonusBLL dailyWorkUnitBonusBLL = new DailyWorkUnitBonusBLL();
        lst = dailyWorkUnitBonusBLL.GetAllDailyWorkUnitBonuss(strHQL);

        DataGrid23.DataSource = lst;
        DataGrid23.DataBind();
    }

    protected void LoadPlanType()
    {
        string strHQL;
        IList lst;

        strHQL = "from PlanType as planType Order By planType.SortNumber ASC";
        PlanTypeBLL planTypeBLL = new PlanTypeBLL();
        lst = planTypeBLL.GetAllPlanTypes(strHQL);

        DataGrid28.DataSource = lst;
        DataGrid28.DataBind();
    }

    protected void LoadSupplierBigType()
    {
        string strHQL;

        strHQL = "Select * From T_BMSupplierBigType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BMSupplierBigType");

        DataGrid5.DataSource = ds;
        DataGrid5.DataBind();

        DL_SupplierBigType.DataSource = ds;
        DL_SupplierBigType.DataBind();
    }

    protected void LoadSupplierSmallType()
    {
        string strHQL;

        strHQL = "Select * From T_BMSupplierSmallType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BMSupplierSmallType");

        DataGrid6.DataSource = ds;
        DataGrid6.DataBind();
    }

    protected void LoadBMBidType()
    {
        string strHQL;

        strHQL = "Select * From T_BMBidType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BMBidType");

        DataGrid8.DataSource = ds;
        DataGrid8.DataBind();
    }

    protected void BT_OperationNew_Click(object sender, EventArgs e)
    {
        string strOperation = TB_TaskOperation.Text.Trim();
        string strSortNumber = TB_OperationSortNumber.Text.Trim();

        TaskOperationBLL taskOperationBLL = new TaskOperationBLL();
        TaskOperation taskOperation = new TaskOperation();

        taskOperation.Operation = strOperation;
        taskOperation.SortNumber = int.Parse(strSortNumber);


        try
        {
            taskOperationBLL.AddTaskOperation(taskOperation);
        }
        catch
        {
            try
            {
                taskOperationBLL.UpdateTaskOperation(taskOperation, strOperation);
            }
            catch
            {
            }
        }


        LoadTaskOperation();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalTaskOperation');", true);
    }

    protected void BT_OperationDelete_Click(object sender, EventArgs e)
    {
        string strOperation = TB_TaskOperation.Text.Trim();
        string strSortNumber = TB_OperationSortNumber.Text.Trim();

        TaskOperationBLL taskOperationBLL = new TaskOperationBLL();
        TaskOperation taskOperation = new TaskOperation();


        taskOperation.Operation = strOperation;
        taskOperation.SortNumber = int.Parse(strSortNumber);


        try
        {
            taskOperationBLL.DeleteTaskOperation(taskOperation);
        }
        catch
        {
            try
            {
                taskOperationBLL.UpdateTaskOperation(taskOperation, strOperation);
            }
            catch
            {
            }
        }

        LoadTaskOperation();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalTaskOperation');", true);
    }

    protected void BT_TaskTypeNew_Click(object sender, EventArgs e)
    {
        string strType = TB_TaskType.Text.Trim();
        string strSortNumber = TB_TaskTypeSort.Text.Trim();

        TaskTypeBLL taskTypeBLL = new TaskTypeBLL();
        TaskType taskType = new TaskType();

        taskType.Type = strType;
        taskType.SortNumber = int.Parse(strSortNumber);

        try
        {
            taskTypeBLL.AddTaskType(taskType);
        }
        catch
        {
            try
            {
                taskTypeBLL.UpdateTaskType(taskType, strType);
            }
            catch
            {
            }
        }

        LoadTaskType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalTaskType');", true);
    }

    protected void BT_TaskTypeDelete_Click(object sender, EventArgs e)
    {
        string strType = TB_TaskType.Text.Trim();
        string strSortNumber = TB_TaskTypeSort.Text.Trim();

        TaskTypeBLL taskTypeBLL = new TaskTypeBLL();
        TaskType taskType = new TaskType();

        taskType.Type = strType;
        taskType.SortNumber = int.Parse(strSortNumber);

        try
        {
            taskTypeBLL.DeleteTaskType(taskType);
            LoadTaskType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalTaskType');", true);
        }
        catch
        {
        }
    }

    protected void BT_TaskRecordNew_Click(object sender, EventArgs e)
    {
        string strType = TB_TaskRecordType.Text.Trim();
        string strSortNumber = TB_TaskRecordTypeSort.Text.Trim();

        TaskRecordTypeBLL taskRecordTypeBLL = new TaskRecordTypeBLL();
        TaskRecordType taskRecordType = new TaskRecordType();

        taskRecordType.Type = strType;
        taskRecordType.SortNumber = int.Parse(strSortNumber);

        try
        {
            taskRecordTypeBLL.AddTaskRecordType(taskRecordType);
        }
        catch
        {
            try
            {
                taskRecordTypeBLL.UpdateTaskRecordType(taskRecordType, strType);
            }
            catch
            {
            }
        }

        LoadTaskRecordType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalTaskRecordType');", true);
    }

    protected void BT_TaskRecordDelete_Click(object sender, EventArgs e)
    {
        string strType = TB_TaskRecordType.Text.Trim();
        string strSortNumber = TB_TaskRecordTypeSort.Text.Trim();

        TaskRecordTypeBLL taskRecordTypeBLL = new TaskRecordTypeBLL();
        TaskRecordType taskRecordType = new TaskRecordType();

        taskRecordType.Type = strType;
        taskRecordType.SortNumber = int.Parse(strSortNumber);

        try
        {
            taskRecordTypeBLL.DeleteTaskRecordType(taskRecordType);
            LoadTaskRecordType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalTaskRecordType');", true);
        }
        catch
        {
        }
    }


    protected void BT_NewEveryCharPrice_Click(object sender, EventArgs e)
    {
        LB_DailyWorkUnitBonusID.Text = "";

        // 通过其他方式获取坐标，或者不使用坐标
        string script = @"
        (function() {
            // 创建基本的事件对象
            var simulatedEvent = {
                stopPropagation: function() { },
                preventDefault: function() { },
                target: document.getElementById('" + ((WebControl)sender).ClientID + @"')
            };
            handleAddClick('modalDailyWorkUnitBonus', simulatedEvent);
        })();";

        ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "click_" + DateTime.Now.Ticks, script, true);
    }

    protected void BT_AddEveryCharPrice_Click(object sender, EventArgs e)
    {
        decimal deEveryCharPrice = NB_EveryCharPrice.Amount;
        decimal deEveryDocPrice = NB_EveryDocPrice.Amount;
        int intCharUpper = int.Parse(NB_CharUpper.Amount.ToString());
        int intDocUpper = int.Parse(NB_DocUpper.Amount.ToString());

        DailyWorkUnitBonusBLL dailyWorkUnitBonusBLL = new DailyWorkUnitBonusBLL();
        DailyWorkUnitBonus dailyWorkUnitBonus = new DailyWorkUnitBonus();

        dailyWorkUnitBonus.EveryCharPrice = deEveryCharPrice;
        dailyWorkUnitBonus.EveryDocPrice = deEveryDocPrice;
        dailyWorkUnitBonus.CharUpper = intCharUpper;
        dailyWorkUnitBonus.DocUpper = intDocUpper;

        try
        {
            if (LB_DailyWorkUnitBonusID.Text == "")
            {
                dailyWorkUnitBonusBLL.AddDailyWorkUnitBonus(dailyWorkUnitBonus);
            }
            else
            {
                dailyWorkUnitBonusBLL.UpdateDailyWorkUnitBonus(dailyWorkUnitBonus, int.Parse(LB_DailyWorkUnitBonusID.Text.Trim()));
            }
        }
        catch
        {
            try
            {
                dailyWorkUnitBonusBLL.UpdateDailyWorkUnitBonus(dailyWorkUnitBonus, int.Parse(LB_DailyWorkUnitBonusID.Text.Trim()));
            }
            catch
            {
            }
        }

        LoadDailyWorkUnitBonus();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalDailyWorkUnitBonus');", true);
    }

    protected void BT_DeleteEveryDocPrice_Click(object sender, EventArgs e)
    {
        string strID = LB_DailyWorkUnitBonusID.Text.Trim();

        DailyWorkUnitBonusBLL dailyWorkUnitBonusBLL = new DailyWorkUnitBonusBLL();
        DailyWorkUnitBonus dailyWorkUnitBonus = new DailyWorkUnitBonus();
        dailyWorkUnitBonus.ID = int.Parse(strID);

        try
        {
            dailyWorkUnitBonusBLL.DeleteDailyWorkUnitBonus(dailyWorkUnitBonus);
            LoadDailyWorkUnitBonus();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalDailyWorkUnitBonus');", true);
        }
        catch
        {
        }
    }

    protected void BT_AddPlanType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_PlanType.Text.Trim();
        strSortNumber = TB_PlanTypeSort.Text.Trim();

        PlanTypeBLL planTypeBLL = new PlanTypeBLL();
        PlanType planType = new PlanType();

        planType.Type = strType;
        planType.SortNumber = int.Parse(strSortNumber);

        try
        {
            planTypeBLL.AddPlanType(planType);
        }
        catch
        {
            try
            {
                planTypeBLL.UpdatePlanType(planType, strType);
            }
            catch
            {
            }
        }

        LoadPlanType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalPlanType');", true);
    }

    protected void BT_DeletePlanType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_PlanType.Text.Trim();
        strSortNumber = TB_PlanTypeSort.Text.Trim();

        PlanTypeBLL planTypeBLL = new PlanTypeBLL();
        PlanType planType = new PlanType();

        planType.Type = strType;
        planType.SortNumber = int.Parse(strSortNumber);

        try
        {
            planTypeBLL.DeletePlanType(planType);
            LoadPlanType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalPlanType');", true);
        }
        catch
        {
        }
    }

    protected void BT_CodeRuleAdd_Click(object sender, EventArgs e)
    {
        string strHQL;

        string strCodeType, strHeadChar, strFieldName, strIsStartup;
        int intFlowIDWidth;

        strCodeType = DL_CodeType.SelectedValue.Trim();
        strHeadChar = TB_HeadChar.Text.Trim();
        strFieldName = DL_FieldRule.SelectedValue.Trim();
        strIsStartup = DL_IsStartup.SelectedValue.Trim();

        try
        {
            intFlowIDWidth = int.Parse(TB_FlowIDWidth.Text.Trim());
        }
        catch
        {
            return;
        }

        try
        {
            strHQL = string.Format(@"Select * From T_CodeRule Where CodeType ='{0}'", strCodeType);
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CodeRule");
            if (ds.Tables[0].Rows.Count == 0)
            {
                strHQL = "Insert Into T_CodeRule(CodeType,HeadChar,FieldName,FlowIDWidth,IsStartup) Values(" + "'" + strCodeType + "'" + "," + "'" + strHeadChar + "'" + "," + "'" + strFieldName + "'" + "," + intFlowIDWidth.ToString() + "," + "'" + strIsStartup + "'" + ")";
                ShareClass.RunSqlCommand(strHQL);
            }
            else
            {
                strHQL = "Update T_CodeRule Set CodeType = '" + strCodeType + "', HeadChar = '" + strHeadChar + "', FieldName = '" + strFieldName + "', FlowIDWidth = " + intFlowIDWidth.ToString() + ", IsStartup = '" + strIsStartup + "' Where ID = " + LB_CodeRuleID.Text.Trim();
                ShareClass.RunSqlCommand(strHQL);
            }
        }
        catch
        {
            try
            {
                strHQL = "Update T_CodeRule Set CodeType = '" + strCodeType + "', HeadChar = '" + strHeadChar + "', FieldName = '" + strFieldName + "', FlowIDWidth = " + intFlowIDWidth.ToString() + ", IsStartup = '" + strIsStartup + "' Where ID = " + LB_CodeRuleID.Text.Trim();
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }


        LoadCodeRule();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCodeRule');", true);
    }

    protected void BT_CodeRuleDelete_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strCodeRuleID;

        strCodeRuleID = LB_CodeRuleID.Text.Trim();

        strHQL = "Delete From T_CodeRule Where ID = " + strCodeRuleID;
        ShareClass.RunSqlCommand(strHQL);

        LoadCodeRule();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCodeRule');", true);
    }

    protected void LoadCodeRule()
    {
        string strHQL;

        strHQL = "Select * From T_CodeRule Order By ID ASc";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CodeRule");
        DataGrid44.DataSource = ds;
        DataGrid44.DataBind();
    }

    protected void BT_SupplierBigTypeAdd_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_SupplierBigType.Text.Trim();
        strSortNumber = TB_SupplierBigTypeSort.Text.Trim();

        string strHQL = "Insert Into T_BMSupplierBigType(Type,SortNumber) Values('" + strType + "','" + strSortNumber + "')";
        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = "Update T_BMSupplierBigType Set SortNumber = '" + strSortNumber + "' Where Type = '" + strType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadSupplierBigType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalSupplierBigType');", true);
    }

    protected void BT_SupplierBigTypeDelete_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_SupplierBigType.Text.Trim();
        strSortNumber = TB_SupplierBigTypeSort.Text.Trim();

        string strHQL = "Delete From T_BMSupplierBigType Where Type = '" + strType + "'";
        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadSupplierBigType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalSupplierBigType');", true);
        }
        catch
        {
        }
    }

    protected void BT_SupplierSmallTypeAdd_Click(object sender, EventArgs e)
    {
        string strType, strBigType, strSortNumber;

        strType = TB_SupplierSmallType.Text.Trim();
        strBigType = DL_SupplierBigType.SelectedValue.Trim();
        strSortNumber = TB_SupplierSmallTypeSort.Text.Trim();

        string strHQL = "Insert Into T_BMSupplierSmallType(Type,BigType,SortNumber) Values('" + strType + "','" + strBigType + "','" + strSortNumber + "')";
        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = "Update T_BMSupplierSmallType Set BigType = '" + strBigType + "', SortNumber = '" + strSortNumber + "' Where Type = '" + strType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadSupplierSmallType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalSupplierSmallType');", true);
    }

    protected void BT_SupplierSmallTypeDelete_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_SupplierSmallType.Text.Trim();
        strSortNumber = TB_SupplierBigTypeSort.Text.Trim();

        string strHQL = "Delete From T_BMSupplierSmallType Where Type = '" + strType + "'";
        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadSupplierSmallType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalSupplierSmallType');", true);
        }
        catch
        {
        }
    }

    protected void BT_BMBidTypeAdd_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_BMBidType.Text.Trim();
        strSortNumber = TB_BMBidTypeSort.Text.Trim();

        string strHQL = "Insert Into T_BMBidType(Type,SortNumber) Values('" + strType + "','" + strSortNumber + "')";
        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = "Update T_BMBidType Set SortNumber = '" + strSortNumber + "' Where Type = '" + strType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadBMBidType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalBMBidType');", true);
    }

    protected void BT_BMBidTypeDelete_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_BMBidType.Text.Trim();
        strSortNumber = TB_BMBidTypeSort.Text.Trim();

        string strHQL = "Delete From T_BMBidType Where Type = '" + strType + "'";
        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadBMBidType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalBMBidType');", true);
        }
        catch
        {
        }
    }

    protected void BT_TenderContentAdd_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strTenderContent;

        strTenderContent = TB_TenderContent.Text.Trim();

        strHQL = string.Format(@"Insert Into T_Tender_Content(TenderContent) values('{0}')", strTenderContent);

        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = string.Format(@"Update T_Tender_Content Set TenderContent = '{0}' Where TenderContent = '{0}'", strTenderContent);
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadTenderContent();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalTenderContent');", true);
    }

    protected void BT_TenderContentDelete_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strTenderContent;

        strTenderContent = TB_TenderContent.Text.Trim();

        strHQL = string.Format(@"Delete From T_Tender_Content Where TenderContent= '{0}'", strTenderContent);
        ShareClass.RunSqlCommand(strHQL);

        LoadTenderContent();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalTenderContent');", true);
    }

    protected void LoadTenderContent()
    {
        string strHQL;

        strHQL = "Select TenderContent from t_tender_content";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Tender_Content");

        DataGrid13.DataSource = ds;
        DataGrid13.DataBind();
    }

    protected void BT_FundingSourceAdd_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strFundingSource;

        strFundingSource = TB_FundingSource.Text.Trim();

        try
        {
            strHQL = string.Format(@"Insert Into T_FundingSource(FundingSource) values('{0}')", strFundingSource);
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = string.Format(@"Update T_FundingSource Set FundingSource = '{0}' Where FundingSource = '{0}'", strFundingSource);
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadFundingSource();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalFundingSource');", true);
    }

    protected void BT_FundingSourceDelete_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strFundingSource;

        strFundingSource = TB_FundingSource.Text.Trim();

        strHQL = string.Format(@"Delete From T_FundingSource Where FundingSource= '{0}'", strFundingSource);
        ShareClass.RunSqlCommand(strHQL);

        LoadFundingSource();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalFundingSource');", true);
    }

    protected void LoadFundingSource()
    {
        string strHQL;

        strHQL = "Select FundingSource from t_FundingSource";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_FundingSource");

        DataGrid20.DataSource = ds;
        DataGrid20.DataBind();
    }
}