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

public partial class TTBaseDataOuter_2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode;

        strUserCode = Session["UserCode"].ToString();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {

            LoadDefectType();
            LoadProductProcess();
            LoadIndustryType();
            LoadMeetingType();
            LoadUnit();
            LoadActorGroupType();
            LoadCarType();
            LoadReportType();
            LoadOilType();
            LoadCustomerQuestionType();
            LoadCurrencyType();
            LoadCustomerQuestionStage();
            LoadCustomerQuestionCustomerStage();
        }
    }

    protected void DataGrid47_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_DefectType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_DefectType.Text = strType;
            TB_DefectTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalDefectType', document.getElementById('" + ((Button)e.Item.FindControl("BT_DefectType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid3_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strProcessName = ((Button)e.Item.FindControl("BT_ProcessName")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_ProcessName.Text = strProcessName;
            TB_ProcessSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalProductProcess', document.getElementById('" + ((Button)e.Item.FindControl("BT_ProcessName")).ClientID + "'));", true);
        }
    }

    protected void DataGrid9_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_MeetingType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_MeetingType.Text = strType;
            TB_MeetingTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalMeetingType', document.getElementById('" + ((Button)e.Item.FindControl("BT_MeetingType")).ClientID + "'));", true);
        }
    }


    protected void DataGrid14_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strUnitName = ((Button)e.Item.FindControl("BT_UnitName")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_UnitName.Text = strUnitName;
            TB_UnitSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalUnit', document.getElementById('" + ((Button)e.Item.FindControl("BT_UnitName")).ClientID + "'));", true);
        }
    }

    protected void DataGrid15_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strActorGroupType = ((Button)e.Item.FindControl("BT_ActorGroupType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_ActorGroupType.Text = strActorGroupType;
            TB_ActorGroupTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalActorGroup', document.getElementById('" + ((Button)e.Item.FindControl("BT_ActorGroupType")).ClientID + "'));", true);
        }
    }



    protected void DataGrid26_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_IndustryType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_IndustryType.Text = strType;
            TB_IndustryTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalIndustryType', document.getElementById('" + ((Button)e.Item.FindControl("BT_IndustryType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid27_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_CarType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_CarType.Text = strType;
            TB_CarTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalCarType', document.getElementById('" + ((Button)e.Item.FindControl("BT_CarType")).ClientID + "'));", true);
        }
    }


    protected void DataGrid29_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_ReportType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_ReportType.Text = strType;
            TB_ReportTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalReportType', document.getElementById('" + ((Button)e.Item.FindControl("BT_ReportType")).ClientID + "'));", true);
        }
    }


    protected void DataGrid32_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_CustomerQuestionType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_CustomerQuestionType.Text = strType;
            TB_CustomerQuestionTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalCustomerQuestionType', document.getElementById('" + ((Button)e.Item.FindControl("BT_CustomerQuestionType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid33_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strId = ((Button)e.Item.FindControl("BT_ID")).Text;
            string strOilName = e.Item.Cells[1].Text.Trim();

            txt_OilName.Text = strOilName.Substring(0, strOilName.IndexOf("@"));
            txt_OilType.Text = strOilName.Substring(strOilName.IndexOf("@"));
            txt_ID.Text = strId;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalOilType', document.getElementById('" + ((Button)e.Item.FindControl("BT_ID")).ClientID + "'));", true);
        }
    }


    protected void DataGrid45_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strStage = ((Button)e.Item.FindControl("BT_Stage")).Text.Trim();
            string strPossibility = e.Item.Cells[1].Text.Trim();

            TB_CustomerQuestionStage.Text = strStage;
            TB_CustomerQuestionPossibility.Text = strPossibility;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalCustomerQuestionStage', document.getElementById('" + ((Button)e.Item.FindControl("BT_Stage")).ClientID + "'));", true);
        }
    }

    protected void DataGrid46_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strStage = ((Button)e.Item.FindControl("BT_Stage")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_CustomerQuestionCustomerStage.Text = strStage;
            TB_CustomerQuestionCustomerStageSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalCustomerQuestionCustomerStage', document.getElementById('" + ((Button)e.Item.FindControl("BT_Stage")).ClientID + "'));", true);
        }
    }

    protected void DataGrid35_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strTypeName = ((Button)e.Item.FindControl("BT_CurrencyType")).Text.Trim();
            string strExchangeRate = e.Item.Cells[1].Text.Trim();
            string strSortNo = e.Item.Cells[2].Text.Trim();
            string strIsHome = e.Item.Cells[3].Text.Trim();

            TB_CurrencyType.Text = strTypeName;
            TB_ExchangeRate.Text = strExchangeRate;
            TB_CurrencyTypeSortNo.Text = strSortNo;
            DL_IsHomeCurrency.SelectedValue = strIsHome;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalCurrency', document.getElementById('" + ((Button)e.Item.FindControl("BT_CurrencyType")).ClientID + "'));", true);
        }
    }


    protected void BT_DefectTypeNew_Click(object sender, EventArgs e)
    {
        string strDefectType = TB_DefectType.Text.Trim();
        string strSortNumber = TB_DefectTypeSort.Text.Trim();

        DefectTypeBLL defectTypeBLL = new DefectTypeBLL();
        DefectType defectType = new DefectType();

        defectType.Type = strDefectType;
        defectType.SortNumber = int.Parse(strSortNumber);


        try
        {
            defectTypeBLL.AddDefectType(defectType);
        }
        catch
        {
            try
            {
                defectTypeBLL.UpdateDefectType(defectType, strDefectType);
            }
            catch
            {
            }

        }

        LoadDefectType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalDefectType');", true);

    }
    protected void BT_DefectTypeDelete_Click(object sender, EventArgs e)
    {
        string strDefectType = TB_DefectType.Text.Trim();
        string strSortNumber = TB_DefectTypeSort.Text.Trim();

        DefectTypeBLL defectTypeBLL = new DefectTypeBLL();
        DefectType defectType = new DefectType();

        try
        {
            defectType.Type = strDefectType;
            defectType.SortNumber = int.Parse(strSortNumber);

            defectTypeBLL.DeleteDefectType(defectType);

            LoadDefectType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalDefectType');", true);
        }
        catch
        {
        }
    }

    protected void LoadDefectType()
    {
        string strHQL = "from DefectType as defectType order by defectType.SortNumber ASC";
        DefectTypeBLL defectTypeBLL = new DefectTypeBLL();
        IList lst = defectTypeBLL.GetAllDefectTypes(strHQL);

        DataGrid47.DataSource = lst;
        DataGrid47.DataBind();
    }


    protected void LoadProductProcess()
    {
        string strHQL = "From ProductProcess as productProcess Order By productProcess.SortNumber ASC";
        ProductProcessBLL productProcessBLL = new ProductProcessBLL();
        IList lst = productProcessBLL.GetAllProductProcesss(strHQL);

        DataGrid3.DataSource = lst;
        DataGrid3.DataBind();
    }

    protected void LoadIndustryType()
    {
        string strHQL = "From IndustryType as industryType Order By industryType.SortNumber ASC";
        IndustryTypeBLL industryTypeBLL = new IndustryTypeBLL();
        IList lst = industryTypeBLL.GetAllIndustryTypes(strHQL);

        DataGrid26.DataSource = lst;
        DataGrid26.DataBind();
    }

    protected void LoadMeetingType()
    {
        string strHQL = "from MeetingType as meetingType Order by meetingType.SortNumber ASC";
        MeetingTypeBLL meetingTypeBLL = new MeetingTypeBLL();
        IList lst = meetingTypeBLL.GetAllMeetingTypes(strHQL);

        DataGrid9.DataSource = lst;
        DataGrid9.DataBind();
    }



    protected void LoadUnit()
    {
        string strHQL = "from JNUnit as jnUnit Order by jnUnit.SortNumber ASC";
        JNUnitBLL jnUnitBLl = new JNUnitBLL();
        IList lst = jnUnitBLl.GetAllJNUnits(strHQL);

        DataGrid14.DataSource = lst;
        DataGrid14.DataBind();
    }

    protected void LoadActorGroupType()
    {
        string strHQL = "from ActorGroupType as actorGroupType Order by actorGroupType.SortNumber ASC";
        ActorGroupTypeBLL actorGroupTypeBLL = new ActorGroupTypeBLL();
        IList lst = actorGroupTypeBLL.GetAllActorGroupTypes(strHQL);

        DataGrid15.DataSource = lst;
        DataGrid15.DataBind();
    }


    protected void LoadCarType()
    {
        string strHQL;
        IList lst;

        strHQL = "from CarType as carType Order By carType.SortNumber ASC";
        CarTypeBLL carTypeBLL = new CarTypeBLL();
        lst = carTypeBLL.GetAllCarTypes(strHQL);

        DataGrid27.DataSource = lst;
        DataGrid27.DataBind();
    }


    protected void LoadReportType()
    {
        string strHQL;
        IList lst;

        strHQL = "from ReportType as reportType Order By reportType.SortNumber ASC";
        ReportTypeBLL reportTypeBLL = new ReportTypeBLL();
        lst = reportTypeBLL.GetAllReportTypes(strHQL);

        DataGrid29.DataSource = lst;
        DataGrid29.DataBind();
    }


    protected void LoadCustomerQuestionType()
    {
        string strHQL;
        IList lst;

        strHQL = "from CustomerQuestionType as customerQuestionType Order By customerQuestionType.SortNumber ASC";
        CustomerQuestionTypeBLL customerQuestionTypeBLL = new CustomerQuestionTypeBLL();
        lst = customerQuestionTypeBLL.GetAllCustomerQuestionTypes(strHQL);

        DataGrid32.DataSource = lst;
        DataGrid32.DataBind();
    }

    protected void LoadCurrencyType()
    {
        string strHQL;
        IList lst;

        strHQL = "from CurrencyType as currencyType Order By currencyType.SortNo ASC";
        CurrencyTypeBLL currencyTypeBLL = new CurrencyTypeBLL();
        lst = currencyTypeBLL.GetAllCurrencyTypes(strHQL);

        DataGrid35.DataSource = lst;
        DataGrid35.DataBind();
    }

    protected void BT_MeetingTypeNew_Click(object sender, EventArgs e)
    {

        string strMeetingType = TB_MeetingType.Text.Trim();
        string strSortNumber = TB_MeetingTypeSort.Text.Trim();

        MeetingTypeBLL meetingTypeBLL = new MeetingTypeBLL();
        MeetingType meetingType = new MeetingType();

        meetingType.Type = strMeetingType;
        meetingType.SortNumber = int.Parse(strSortNumber);


        try
        {
            meetingTypeBLL.AddMeetingType(meetingType);
        }
        catch
        {
            try
            {
                meetingTypeBLL.UpdateMeetingType(meetingType, strMeetingType);
            }
            catch
            {
            }
        }

        LoadMeetingType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalMeetingType');", true);
    }


    protected void BT_MeetingTypeDelete_Click(object sender, EventArgs e)
    {
        string strMeetingType = TB_MeetingType.Text.Trim();
        string strSortNumber = TB_MeetingTypeSort.Text.Trim();

        try
        {
            MeetingTypeBLL meetingTypeBLL = new MeetingTypeBLL();
            MeetingType meetingType = new MeetingType();

            meetingType.Type = strMeetingType;
            meetingType.SortNumber = int.Parse(strSortNumber);

            meetingTypeBLL.DeleteMeetingType(meetingType);

            LoadMeetingType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalMeetingType');", true);
        }
        catch
        {
        }
    }



    protected void BT_AddCustomerQuestionStage_Click(object sender, EventArgs e)
    {
        string strStage, strPossibility;

        strStage = TB_CustomerQuestionStage.Text.Trim();
        strPossibility = TB_CustomerQuestionPossibility.Text.Trim();

        CustomerQuestionStageBLL customerQuestionStageBLL = new CustomerQuestionStageBLL();
        CustomerQuestionStage customerQuestionStage = new CustomerQuestionStage();

        customerQuestionStage.Stage = strStage;
        customerQuestionStage.Possibility = int.Parse(strPossibility);

        try
        {
            customerQuestionStageBLL.AddCustomerQuestionStage(customerQuestionStage);

            LoadCustomerQuestionStage();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCustomerQuestionStage');", true);
        }
        catch
        {

        }
    }

    protected void BT_DeleteCustomerQuestionPossibility_Click(object sender, EventArgs e)
    {
        string strStage, strPossibility;

        strStage = TB_CustomerQuestionStage.Text.Trim();
        strPossibility = TB_CustomerQuestionPossibility.Text.Trim();

        CustomerQuestionStageBLL customerQuestionStageBLL = new CustomerQuestionStageBLL();
        CustomerQuestionStage customerQuestionStage = new CustomerQuestionStage();

        customerQuestionStage.Stage = strStage;
        customerQuestionStage.Possibility = int.Parse(strPossibility);

        try
        {
            customerQuestionStageBLL.DeleteCustomerQuestionStage(customerQuestionStage);

            LoadCustomerQuestionStage();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCustomerQuestionStage');", true);
        }
        catch
        {

        }
    }

    protected void BT_AddCustomerQuestionCustomerStage_Click(object sender, EventArgs e)
    {
        string strStage, strSortNumber;

        strStage = TB_CustomerQuestionCustomerStage.Text.Trim();
        strSortNumber = TB_CustomerQuestionCustomerStageSort.Text.Trim();

        CustomerQuestionCustomerStageBLL customerQuestionCustomerStageBLL = new CustomerQuestionCustomerStageBLL();
        CustomerQuestionCustomerStage customerQuestionCustomerStage = new CustomerQuestionCustomerStage();

        customerQuestionCustomerStage.Stage = strStage;
        customerQuestionCustomerStage.SortNumber = int.Parse(strSortNumber);

        try
        {
            customerQuestionCustomerStageBLL.AddCustomerQuestionCustomerStage(customerQuestionCustomerStage);

        }
        catch
        {
            try
            {
                customerQuestionCustomerStageBLL.UpdateCustomerQuestionCustomerStage(customerQuestionCustomerStage, strStage);
            }
            catch
            {

            }
        }


        LoadCustomerQuestionCustomerStage();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCustomerQuestionCustomerStage');", true);
    }

    protected void BT_DeleteCustomerQuestionCustomerStage_Click(object sender, EventArgs e)
    {
        string strStage, strSortNumber;

        strStage = TB_CustomerQuestionCustomerStage.Text.Trim();
        strSortNumber = TB_CustomerQuestionCustomerStageSort.Text.Trim();

        CustomerQuestionCustomerStageBLL customerQuestionCustomerStageBLL = new CustomerQuestionCustomerStageBLL();
        CustomerQuestionCustomerStage customerQuestionCustomerStage = new CustomerQuestionCustomerStage();

        customerQuestionCustomerStage.Stage = strStage;
        customerQuestionCustomerStage.SortNumber = int.Parse(strSortNumber);

        try
        {
            customerQuestionCustomerStageBLL.DeleteCustomerQuestionCustomerStage(customerQuestionCustomerStage);

            LoadCustomerQuestionCustomerStage();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCustomerQuestionCustomerStage');", true);
        }
        catch
        {

        }
    }



    protected void BT_UnitNew_Click(object sender, EventArgs e)
    {
        string strUnitName, strSortNumber;

        strUnitName = TB_UnitName.Text.Trim();
        strSortNumber = TB_UnitSort.Text.Trim();

        JNUnitBLL jnUnitBLL = new JNUnitBLL();
        JNUnit jnUnit = new JNUnit();

        jnUnit.UnitName = strUnitName;
        jnUnit.SortNumber = int.Parse(strSortNumber);

        try
        {
            jnUnitBLL.AddJNUnit(jnUnit);
        }
        catch
        {
            try
            {
                jnUnitBLL.UpdateJNUnit(jnUnit, strUnitName);
            }
            catch
            {
            }
        }

        LoadUnit();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalUnit');", true);
    }

    protected void BT_UnitDelete_Click(object sender, EventArgs e)
    {
        string strUnitName, strSortNumber;

        strUnitName = TB_UnitName.Text.Trim();
        strSortNumber = TB_UnitSort.Text.Trim();

        JNUnitBLL jnUnitBLL = new JNUnitBLL();
        JNUnit jnUnit = new JNUnit();

        try
        {
            jnUnit.UnitName = strUnitName;
            jnUnit.SortNumber = int.Parse(strSortNumber);

            jnUnitBLL.DeleteJNUnit(jnUnit);

            LoadUnit();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalUnit');", true);
        }
        catch
        {
        }

    }
    protected void BT_ActorGroupNew_Click(object sender, EventArgs e)
    {

        string strType, strSortNumber;

        strType = TB_ActorGroupType.Text.Trim();
        strSortNumber = TB_ActorGroupTypeSort.Text.Trim();

        ActorGroupTypeBLL actorGroupTypeBLL = new ActorGroupTypeBLL();
        ActorGroupType actorGroupType = new ActorGroupType();
        actorGroupType.Type = strType;
        actorGroupType.SortNumber = int.Parse(strSortNumber);

        try
        {
            actorGroupTypeBLL.AddActorGroupType(actorGroupType);
        }
        catch
        {
            try
            {
                actorGroupTypeBLL.UpdateActorGroupType(actorGroupType, strType);
            }
            catch
            {
            }
        }

        LoadActorGroupType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalActorGroup');", true);
    }

    protected void BT_ActorGroupDelete_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_ActorGroupType.Text.Trim();
        strSortNumber = TB_ActorGroupTypeSort.Text.Trim();

        ActorGroupType actorGroupType = new ActorGroupType();
        actorGroupType.Type = strType;
        actorGroupType.SortNumber = int.Parse(strSortNumber);

        try
        {
            ActorGroupTypeBLL actorGroupTypeBLL = new ActorGroupTypeBLL();
            actorGroupTypeBLL.DeleteActorGroupType(actorGroupType);

            LoadActorGroupType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalActorGroup');", true);
        }
        catch
        {
        }
    }

    protected void BT_AddProductProcess_Click(object sender, EventArgs e)
    {
        string strProcessName = TB_ProcessName.Text.Trim();
        string strSortNumber = TB_ProcessSort.Text.Trim();

        ProductProcessBLL productProcessBLL = new ProductProcessBLL();
        ProductProcess productProcess = new ProductProcess();

        productProcess.ProcessName = strProcessName;
        productProcess.SortNumber = int.Parse(strSortNumber);

        try
        {
            productProcessBLL.AddProductProcess(productProcess);
        }
        catch
        {
            try
            {
                productProcessBLL.UpdateProductProcess(productProcess, strProcessName);
            }
            catch
            {
            }
        }

        LoadProductProcess();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalProductProcess');", true);
    }

    protected void BT_DeleteProductProcess_Click(object sender, EventArgs e)
    {
        string strProcessName = TB_ProcessName.Text.Trim();
        string strSortNumber = TB_ProcessSort.Text.Trim();

        ProductProcessBLL productProcessBLL = new ProductProcessBLL();
        ProductProcess productProcess = new ProductProcess();

        productProcess.ProcessName = strProcessName;
        productProcess.SortNumber = int.Parse(strSortNumber);

        try
        {
            productProcessBLL.DeleteProductProcess(productProcess);

            LoadProductProcess();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalProductProcess');", true);
        }
        catch
        {
        }
    }

    protected void BT_AddIndustryType_Click(object sender, EventArgs e)
    {
        string strType = TB_IndustryType.Text.Trim();
        string strSortNumber = TB_IndustryTypeSort.Text.Trim();

        IndustryTypeBLL industryTypeBLL = new IndustryTypeBLL();
        IndustryType industryType = new IndustryType();

        industryType.Type = strType;
        industryType.SortNumber = int.Parse(strSortNumber);

        try
        {
            industryTypeBLL.AddIndustryType(industryType);
        }
        catch
        {
            try
            {
                industryTypeBLL.UpdateIndustryType(industryType, strType);
            }
            catch
            {
            }
        }

        LoadIndustryType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalIndustryType');", true);
    }

    protected void BT_DeleteIndustryType_Click(object sender, EventArgs e)
    {
        string strType = TB_IndustryType.Text.Trim();
        string strSortNumber = TB_IndustryTypeSort.Text.Trim();

        IndustryTypeBLL industryTypeBLL = new IndustryTypeBLL();
        IndustryType industryType = new IndustryType();

        industryType.Type = strType;
        industryType.SortNumber = int.Parse(strSortNumber);

        try
        {
            industryTypeBLL.DeleteIndustryType(industryType);
            LoadIndustryType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalIndustryType');", true);
        }
        catch
        {
        }
    }

    protected void BT_AddCarType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_CarType.Text.Trim();
        strSortNumber = TB_CarTypeSort.Text.Trim();

        CarTypeBLL carTypeBLL = new CarTypeBLL();
        CarType carType = new CarType();

        carType.Type = strType;
        carType.SortNumber = int.Parse(strSortNumber);

        try
        {
            carTypeBLL.AddCarType(carType);
        }
        catch
        {
            try
            {
                carTypeBLL.UpdateCarType(carType, strType);
            }
            catch
            {
            }
        }

        LoadCarType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCarType');", true);
    }

    protected void BT_DeleteCarType_Click(object sender, EventArgs e)
    {

        string strType, strSortNumber;

        strType = TB_CarType.Text.Trim();
        strSortNumber = TB_CarTypeSort.Text.Trim();

        CarTypeBLL carTypeBLL = new CarTypeBLL();
        CarType carType = new CarType();

        carType.Type = strType;
        carType.SortNumber = int.Parse(strSortNumber);

        try
        {
            carTypeBLL.DeleteCarType(carType);

            LoadCarType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCarType');", true);
        }
        catch
        {
        }
    }

    protected void BT_AddReportType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_ReportType.Text.Trim();
        strSortNumber = TB_ReportTypeSort.Text.Trim();

        ReportTypeBLL reportTypeBLL = new ReportTypeBLL();
        ReportType reportType = new ReportType();

        reportType.Type = strType;
        reportType.SortNumber = int.Parse(strSortNumber);

        try
        {
            reportTypeBLL.AddReportType(reportType);
        }
        catch
        {
            try
            {
                reportTypeBLL.UpdateReportType(reportType, strType);
            }
            catch
            {
            }
        }

        LoadReportType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalReportType');", true);
    }

    protected void BT_DeleteReportType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_ReportType.Text.Trim();
        strSortNumber = TB_ReportTypeSort.Text.Trim();

        ReportTypeBLL reportTypeBLL = new ReportTypeBLL();
        ReportType reportType = new ReportType();

        reportType.Type = strType;
        reportType.SortNumber = int.Parse(strSortNumber);

        try
        {
            reportTypeBLL.DeleteReportType(reportType);

            LoadReportType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalReportType');", true);
        }
        catch
        {
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

    protected void BT_AddCustomerQuestionType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_CustomerQuestionType.Text.Trim();
        strSortNumber = TB_CustomerQuestionTypeSort.Text.Trim();

        CustomerQuestionTypeBLL customerQuestionTypeBLL = new CustomerQuestionTypeBLL();
        CustomerQuestionType customerQuestionType = new CustomerQuestionType();

        customerQuestionType.Type = strType;
        customerQuestionType.SortNumber = int.Parse(strSortNumber);

        try
        {
            customerQuestionTypeBLL.AddCustomerQuestionType(customerQuestionType);
        }
        catch
        {
            try
            {
                customerQuestionTypeBLL.UpdateCustomerQuestionType(customerQuestionType, strType);
            }
            catch
            {
            }
        }

        LoadCustomerQuestionType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCustomerQuestionType');", true);
    }
    protected void BT_DeleteCustomerQuestionType_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_CustomerQuestionType.Text.Trim();
        strSortNumber = TB_CustomerQuestionTypeSort.Text.Trim();

        CustomerQuestionTypeBLL customerQuestionTypeBLL = new CustomerQuestionTypeBLL();
        CustomerQuestionType customerQuestionType = new CustomerQuestionType();

        customerQuestionType.Type = strType;
        customerQuestionType.SortNumber = int.Parse(strSortNumber);

        try
        {
            customerQuestionTypeBLL.DeleteCustomerQuestionType(customerQuestionType);

            LoadCustomerQuestionType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCustomerQuestionType');", true);
        }
        catch
        {
        }
    }

    protected void btn_OilTypeAdd_Click(object sender, EventArgs e)
    {
        string strOilName = txt_OilName.Text.Trim();
        string strOilType = txt_OilType.Text.Trim();
        string strpa = strOilName + "@" + strOilType;
        if (!IsOilTypeExits(strpa))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGGSYXHYCZZXSR") + "')", true);
            return;
        }

        OilTypeBLL OilTypeBLL = new OilTypeBLL();
        OilType OilType = new OilType();
        OilType.OilName = strpa;

        try
        {
            OilTypeBLL.AddOilType(OilType);
        }
        catch
        {
            try
            {
                OilTypeBLL.UpdateOilType(OilType, int.Parse(txt_ID.Text.Trim()));
            }
            catch
            {
            }
        }

        LoadOilType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalOilType');", true);
    }

    protected void btn_OilTypeDelete_Click(object sender, EventArgs e)
    {
        string strId = txt_ID.Text.Trim();

        OilTypeBLL OilTypeBLL = new OilTypeBLL();
        OilType OilType = new OilType();

        try
        {
            OilType.ID = int.Parse(strId);
            OilTypeBLL.DeleteOilType(OilType);
            LoadOilType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalOilType');", true);
        }
        catch
        {
        }
    }

    protected void LoadOilType()
    {
        string strHQL = " from OilType as OilType order by OilType.ID ASC";
        OilTypeBLL OilTypeBLL = new OilTypeBLL();
        IList lst = OilTypeBLL.GetAllOilType(strHQL);

        DataGrid33.DataSource = lst;
        DataGrid33.DataBind();
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


    protected void LoadCustomerQuestionStage()
    {
        string strHQL;

        strHQL = "Select * From T_CustomerQuestionStage Order By Possibility ASc";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CustomerQuestionStage");

        DataGrid45.DataSource = ds;
        DataGrid45.DataBind();
    }

    protected void LoadCustomerQuestionCustomerStage()
    {
        string strHQL;

        strHQL = "Select * From T_CustomerQuestionCustomerStage Order By SortNumber ASc";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_CustomerQuestionCustomerStage");

        DataGrid46.DataSource = ds;
        DataGrid46.DataBind();
    }



    protected void BT_AddCurrencyType_Click(object sender, EventArgs e)
    {
        string strCurrencyType, strExchangeRate, strCurrencyTypeSortNo;

        strCurrencyType = TB_CurrencyType.Text.Trim();
        strExchangeRate = TB_ExchangeRate.Text.Trim();
        strCurrencyTypeSortNo = TB_CurrencyTypeSortNo.Text.Trim();

        if (!IsNumeric(strExchangeRate))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSRZDHLLXBXSSZJC") + "')", true);
            TB_ExchangeRate.Focus();
            return;
        }
        if (!IsNumeric(strCurrencyTypeSortNo))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSRZDSXYDY0DZSJC") + "')", true);
            TB_CurrencyTypeSortNo.Focus();
            return;
        }


        CurrencyTypeBLL currencyTypeBLL = new CurrencyTypeBLL();
        CurrencyType currencyType = new CurrencyType();

        currencyType.Type = strCurrencyType;
        currencyType.ExchangeRate = decimal.Parse(strExchangeRate);
        currencyType.SortNo = int.Parse(strCurrencyTypeSortNo);
        currencyType.IsHome = DL_IsHomeCurrency.SelectedValue.Trim();


        try
        {
            currencyTypeBLL.AddCurrencyType(currencyType);
        }
        catch
        {
            try
            {
                currencyTypeBLL.UpdateCurrencyType(currencyType, strCurrencyType);
            }
            catch
            {
            }
        }

        LoadCurrencyType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCurrency');", true);
    }

    protected void BT_DeleteCurrencyType_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strCurrencyType;

        strCurrencyType = TB_CurrencyType.Text.Trim();

        try
        {
            strHQL = "Delete From T_CurrencyType Where Type = " + "'" + strCurrencyType + "'";
            ShareClass.RunSqlCommand(strHQL);

            LoadCurrencyType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalCurrency');", true);
        }
        catch
        {
        }
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