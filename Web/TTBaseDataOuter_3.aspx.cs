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

public partial class TTBaseDataOuter_3 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode;

        strUserCode = Session["UserCode"].ToString();

        //ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        //Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", strUserCode);  //Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", "基础数据(外置)", strUserCode);
        //if (blVisible == false)
        //{
        //    Response.Redirect("TTDisplayErrors.aspx");
        //    return;
        //}

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            LoadAssetType();
            LoadMTType();
            LoadChangeType();
            LoadConstractType();
            LoadStockCountMethod();//出入库存算法
            LoadConststactBigType();//合同大类
            LoadReceivePayWay();
            LoadBank();
            LoadSiteCustomerServiceOperator();
            LoadGoodsShipmentType();
            LoadGoodsCheckInType();
            LoadPackingType();
            LoadSaleType();
            LoadConstractRadio();
            LoadInvoiceType();
        }
    }

    protected void DL_StockCountMethod_SelectedIndexChanged(object sender, EventArgs e)
    {
        string strHQL;
        string strMethod;

        strMethod = DL_StockCountMethod.SelectedValue.Trim();

        try
        {
            strHQL = "Update T_GoodsStockCountMethod Set Method = '" + strMethod + "'";
            ShareClass.RunSqlCommand(strHQL);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGGCG") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGGSBJC") + "')", true);
        }
    }

    protected void DataGrid4_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_AssetType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_AssetType.Text = strType;
            TB_AssetTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalAssetType', document.getElementById('" + ((Button)e.Item.FindControl("BT_AssetType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid10_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_MTType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_MTType.Text = strType;
            TB_MTTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalMTType', document.getElementById('" + ((Button)e.Item.FindControl("BT_MTType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid12_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_SaleType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_SaleType.Text = strType;
            TB_SaleTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalSaleType', document.getElementById('" + ((Button)e.Item.FindControl("BT_SaleType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid11_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_ChangeType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_ChangeType.Text = strType;
            TB_ChangeTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalChangeType', document.getElementById('" + ((Button)e.Item.FindControl("BT_ChangeType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid22_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_ConstractType")).Text.Trim();
            string strKeyWord = e.Item.Cells[1].Text.Trim();
            string strSortNumber = e.Item.Cells[2].Text.Trim();

            TB_ConstractType.Text = strType;
            TB_ConstractTypeKeyWord.Text = strKeyWord;
            TB_ConstractTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalConstractType', document.getElementById('" + ((Button)e.Item.FindControl("BT_ConstractType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid37_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_ConstractBigType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_ConstractBigType.Text = strType;
            TB_ConstractBigTypeSortNo.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalConstractBigType', document.getElementById('" + ((Button)e.Item.FindControl("BT_ConstractBigType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid38_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_ReceivePayType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_ReceivePayType.Text = strType;
            TB_ReceivePayTypeSort.Text = strSortNumber;

            // 修正模态框ID为 modalReceivePay
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal",
                "showModal('modalReceivePay', document.getElementById('" + ((Button)e.Item.FindControl("BT_ReceivePayType")).ClientID + "'));", true);
        }
    }
    protected void DataGrid39_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strBankName = ((Button)e.Item.FindControl("BT_BankName")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_BankName.Text = strBankName;
            TB_BankSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalBank', document.getElementById('" + ((Button)e.Item.FindControl("BT_BankName")).ClientID + "'));", true);
        }
    }

    protected void DataGrid41_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strWebSite = ((Button)e.Item.FindControl("BT_WebSite")).Text;
            string strUserCode = e.Item.Cells[1].Text.Trim();
            string strUserName = e.Item.Cells[2].Text.Trim();
            string strSortNumber = e.Item.Cells[3].Text.Trim();

            if (e.CommandName != "Page")
            {
                for (int i = 0; i < DataGrid41.Items.Count; i++)
                {
                    DataGrid41.Items[i].ForeColor = Color.Black;
                }

                e.Item.ForeColor = Color.Red;

                TB_WebSite.Text = strWebSite;
                TB_SiteUserCode.Text = strUserCode;
                TB_SiteUserName.Text = strUserName;
                TB_WebSiteSort.Text = strSortNumber;
            }

            // 修正模态框ID为 modalWebSiteOperator
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal",
                "showModal('modalWebSiteOperator', document.getElementById('" + ((Button)e.Item.FindControl("BT_WebSite")).ClientID + "'));", true);
        }
    }

    protected void DataGrid42_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_GoodsShipmentType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_GoodsShipmentType.Text = strType;
            TB_GoodsShipmentSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalGoodsShipmentType', document.getElementById('" + ((Button)e.Item.FindControl("BT_GoodsShipmentType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid43_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_GoodsCheckInType")).Text.Trim();
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_GoodsCheckInType.Text = strType;
            TB_GoodsCheckInSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalGoodsCheckInType', document.getElementById('" + ((Button)e.Item.FindControl("BT_GoodsCheckInType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid48_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_PackingType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_PackingType.Text = strType;
            TB_PackingTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalPackingType', document.getElementById('" + ((Button)e.Item.FindControl("BT_PackingType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid49_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_InvoiceType")).Text;
            string strSortNumber = e.Item.Cells[1].Text.Trim();

            TB_InvoiceType.Text = strType;
            TB_InvoiceTypeSort.Text = strSortNumber;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalInvoiceType', document.getElementById('" + ((Button)e.Item.FindControl("BT_InvoiceType")).ClientID + "'));", true);
        }
    }

    protected void DataGrid21_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            string strType = ((Button)e.Item.FindControl("BT_ConstractRadio")).Text;

            TB_ConstractRadio.Text = strType;

            // 打开编辑模态框
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "openModal", "showModal('modalConstractRadio', document.getElementById('" + ((Button)e.Item.FindControl("BT_ConstractRadio")).ClientID + "'));", true);
        }
    }

    protected void BT_AssetTypeNew_Click(object sender, EventArgs e)
    {
        string strAssetType = TB_AssetType.Text.Trim();
        string strSortNumber = TB_AssetTypeSort.Text.Trim();

        AssetTypeBLL assetTypeBLL = new AssetTypeBLL();
        AssetType assetType = new AssetType();


        assetType.Type = strAssetType;
        assetType.SortNumber = int.Parse(strSortNumber);


        try
        {
            assetTypeBLL.AddAssetType(assetType);
        }
        catch
        {
            try
            {
                assetTypeBLL.UpdateAssetType(assetType, strAssetType);
            }
            catch
            {
            }
        }


        LoadAssetType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalAssetType');", true);
    }

    protected void BT_AssetTypeDelete_Click(object sender, EventArgs e)
    {
        string strAssetType = TB_AssetType.Text.Trim();
        string strSortNumber = TB_AssetTypeSort.Text.Trim();

        AssetTypeBLL assetTypeBLL = new AssetTypeBLL();
        AssetType assetType = new AssetType();

        try
        {
            assetType.Type = strAssetType;
            assetType.SortNumber = int.Parse(strSortNumber);

            assetTypeBLL.DeleteAssetType(assetType);

            LoadAssetType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalAssetType');", true);
        }
        catch
        {
        }
    }

    protected void BT_PackingTypeNew_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strType, strSortNumber;

        strType = TB_PackingType.Text.Trim();
        strSortNumber = TB_PackingTypeSort.Text.Trim();

        try
        {
            strHQL = "Insert Into T_PackingType Values('" + strType + "'," + strSortNumber + ")";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL= "Update T_PackingType Set SortNumber = " + strSortNumber + " Where Type = '" + strType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadPackingType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalPackingType');", true);
    }

    protected void BT_PackingTypeDelete_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strType, strSortNumber;

        strType = TB_PackingType.Text.Trim();
        strSortNumber = TB_PackingTypeSort.Text.Trim();

        try
        {
            strHQL = "Delete From  T_PackingType Where Type = '" + strType + "'";
            ShareClass.RunSqlCommand(strHQL);

            LoadPackingType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalPackingType');", true);
        }
        catch
        {
        }
    }

    protected void LoadStockCountMethod()
    {
        string strHQL = "Select Method From T_GoodsStockCountMethod";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsStockCountMethod");

        if (ds.Tables[0].Rows.Count > 0)
        {
            try
            {
                DL_StockCountMethod.SelectedValue = ds.Tables[0].Rows[0][0].ToString().Trim();
            }
            catch
            {
            }
        }
    }

    protected void LoadAssetType()
    {
        string strHQL = "from AssetType as assetType order by assetType.SortNumber ASC";
        AssetTypeBLL assetTypeBLL = new AssetTypeBLL();
        IList lst = assetTypeBLL.GetAllAssetTypes(strHQL);

        DataGrid4.DataSource = lst;
        DataGrid4.DataBind();
    }

    protected void LoadMTType()
    {
        string strHQL = "from MTType as mtType Order by mtType.SortNumber ASC";
        MTTypeBLL mtTypeBLL = new MTTypeBLL();
        IList lst = mtTypeBLL.GetAllMTTypes(strHQL);

        DataGrid10.DataSource = lst;
        DataGrid10.DataBind();
    }

    protected void LoadChangeType()
    {
        string strHQL = "from ChangeType as changeType Order by changeType.SortNumber ASC";
        ChangeTypeBLL changeTypeBLL = new ChangeTypeBLL();
        IList lst = changeTypeBLL.GetAllChangeTypes(strHQL);

        DataGrid11.DataSource = lst;
        DataGrid11.DataBind();
    }

    protected void LoadConstractType()
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractType as constractType Order By constractType.SortNumber ASC";
        ConstractTypeBLL constractTypeBLL = new ConstractTypeBLL();
        lst = constractTypeBLL.GetAllConstractTypes(strHQL);

        DataGrid22.DataSource = lst;
        DataGrid22.DataBind();
    }

    protected void LoadGoodsShipmentType()
    {
        string strHQL;

        strHQL = "Select * from T_GoodsShipmentType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsShipmentType");

        DataGrid42.DataSource = ds;
        DataGrid42.DataBind();
    }

    protected void LoadGoodsCheckInType()
    {
        string strHQL;

        strHQL = "Select * from T_GoodsCheckInType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_GoodsCheckInType");

        DataGrid43.DataSource = ds;
        DataGrid43.DataBind();
    }

    protected void LoadPackingType()
    {
        string strHQL;

        strHQL = "Select * From T_PackingType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_PackingType");

        DataGrid48.DataSource = ds;
        DataGrid48.DataBind();
    }

    protected void LoadSaleType()
    {
        string strHQL;

        strHQL = "Select * From T_SaleType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SaleType");

        DataGrid12.DataSource = ds;
        DataGrid12.DataBind();
    }

    protected void LoadConstractRadio()
    {
        string strHQL;

        strHQL = "Select * From T_ConstractRadio ";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ConstractRadio");

        DataGrid21.DataSource = ds;
        DataGrid21.DataBind();
    }

    protected void LoadInvoiceType()
    {
        string strHQL;

        strHQL = "Select * From T_InvoiceType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_InvoiceType");

        DataGrid49.DataSource = ds;
        DataGrid49.DataBind();
    }

    protected void BT_MTTypeNew_Click(object sender, EventArgs e)
    {
        string strMTType, strSortNumber;

        strMTType = TB_MTType.Text.Trim();
        strSortNumber = TB_MTTypeSort.Text.Trim();

        MTTypeBLL mtTypeBLL = new MTTypeBLL();
        MTType mtType = new MTType();

        mtType.Type = strMTType;
        mtType.SortNumber = int.Parse(strSortNumber);

        try
        {
            mtTypeBLL.AddMTType(mtType);
        }
        catch
        {
            try
            {
                mtTypeBLL.UpdateMTType(mtType, strMTType);
            }
            catch
            {
            }
        }

        LoadMTType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalMTType');", true);
    }

    protected void BT_MTTypeDelete_Click(object sender, EventArgs e)
    {
        string strMTType, strSortNumber;

        strMTType = TB_MTType.Text.Trim();
        strSortNumber = TB_MTTypeSort.Text.Trim();

        MTTypeBLL mtTypeBLL = new MTTypeBLL();
        MTType mtType = new MTType();

        mtType.Type = strMTType;
        mtType.SortNumber = int.Parse(strSortNumber);

        try
        {
            mtTypeBLL.DeleteMTType(mtType);
            LoadMTType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalMTType');", true);
        }
        catch
        {
        }
    }

    protected void BT_ChangeTypeNew_Click(object sender, EventArgs e)
    {
        string strChangeType, strSortNumber;

        strChangeType = TB_ChangeType.Text.Trim();
        strSortNumber = TB_ChangeTypeSort.Text.Trim();

        ChangeTypeBLL changeTypeBLL = new ChangeTypeBLL();
        ChangeType changeType = new ChangeType();

        changeType.Type = strChangeType;
        changeType.SortNumber = int.Parse(strSortNumber);

        try
        {
            changeTypeBLL.AddChangeType(changeType);
        }
        catch
        {
            try
            {
                changeTypeBLL.UpdateChangeType(changeType, strChangeType);
            }
            catch
            {
            }
        }

        LoadChangeType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalChangeType');", true);
    }

    protected void BT_ChangeTypeDelete_Click(object sender, EventArgs e)
    {
        string strChangeType, strSortNumber;

        strChangeType = TB_ChangeType.Text.Trim();
        strSortNumber = TB_ChangeTypeSort.Text.Trim();

        ChangeTypeBLL changeTypeBLL = new ChangeTypeBLL();
        ChangeType changeType = new ChangeType();

        changeType.Type = strChangeType;
        changeType.SortNumber = int.Parse(strSortNumber);

        try
        {
            changeTypeBLL.DeleteChangeType(changeType);
            LoadChangeType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalChangeType');", true);
        }
        catch
        {
        }
    }

    protected void BT_ConstractAdd_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber, strKeyWord;

        strType = TB_ConstractType.Text.Trim();
        strKeyWord = TB_ConstractTypeKeyWord.Text.Trim();
        strSortNumber = TB_ConstractTypeSort.Text.Trim();

        ConstractTypeBLL constractTypeBLL = new ConstractTypeBLL();
        ConstractType constractType = new ConstractType();

        constractType.Type = strType;
        constractType.KeyWord = strKeyWord;
        constractType.SortNumber = int.Parse(strSortNumber);

        try
        {
            constractTypeBLL.AddConstractType(constractType);
        }
        catch
        {
            try
            {
                constractTypeBLL.UpdateConstractType(constractType, strType);
            }
            catch
            {
            }
        }

        LoadConstractType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalConstractType');", true);
    }

    protected void BT_ConstractDelete_Click(object sender, EventArgs e)
    {
        string strType, strSortNumber;

        strType = TB_ConstractType.Text.Trim();
        strSortNumber = TB_ConstractTypeSort.Text.Trim();

        ConstractTypeBLL constractTypeBLL = new ConstractTypeBLL();
        ConstractType constractType = new ConstractType();

        constractType.Type = strType;
        constractType.SortNumber = int.Parse(strSortNumber);

        try
        {
            constractTypeBLL.DeleteConstractType(constractType);
            LoadConstractType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalConstractType');", true);
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

    protected void BT_AddReceivePayWay_Click(object sender, EventArgs e)
    {
        string strWay, strSortNumber;

        strWay = TB_ReceivePayType.Text.Trim();
        strSortNumber = TB_ReceivePayTypeSort.Text.Trim();

        ReceivePayWayBLL receivePayWayBLL = new ReceivePayWayBLL();
        ReceivePayWay receivePayWay = new ReceivePayWay();

        receivePayWay.Type = strWay;
        receivePayWay.SortNumber = int.Parse(strSortNumber);

        try
        {
            receivePayWayBLL.AddReceivePayWay(receivePayWay);
        
        }
        catch
        {
            try
            {
                receivePayWayBLL.UpdateReceivePayWay(receivePayWay, strWay);
            }
            catch
            {
            }
        }

        LoadReceivePayWay();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalReceivePayType');", true);
    }

    protected void BT_DeleteReceivePayWay_Click(object sender, EventArgs e)
    {
        string strWay, strSortNumber;

        strWay = TB_ReceivePayType.Text.Trim();
        strSortNumber = TB_ReceivePayTypeSort.Text.Trim();

        ReceivePayWayBLL receivePayWayBLL = new ReceivePayWayBLL();
        ReceivePayWay receivePayWay = new ReceivePayWay();

        receivePayWay.Type = strWay;
        receivePayWay.SortNumber = int.Parse(strSortNumber);

        try
        {
            receivePayWayBLL.DeleteReceivePayWay(receivePayWay);
            LoadReceivePayWay();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalReceivePayType');", true);
        }
        catch
        {
        }
    }

    protected void BT_AddBank_Click(object sender, EventArgs e)
    {
        string strBankName, strSortNumber;

        strBankName = TB_BankName.Text.Trim();
        strSortNumber = TB_BankSort.Text.Trim();

        BankBLL bankBLL = new BankBLL();
        Bank bank = new Bank();
        bank.BankName = strBankName;
        bank.SortNumber = int.Parse(strSortNumber);

        try
        {
            bankBLL.AddBank(bank);
        }
        catch
        {
            try
            {
                bankBLL.UpdateBank(bank, strBankName);
            }
            catch
            {
            }
        }

        LoadBank();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalBank');", true);
    }

    protected void BT_DeleteBank_Click(object sender, EventArgs e)
    {
        string strBankName, strSortNumber;

        strBankName = TB_BankName.Text.Trim();
        strSortNumber = TB_BankSort.Text.Trim();

        BankBLL bankBLL = new BankBLL();
        Bank bank = new Bank();
        bank.BankName = strBankName;
        bank.SortNumber = int.Parse(strSortNumber);

        try
        {
            bankBLL.DeleteBank(bank);
            LoadBank();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalBank');", true);
        }
        catch
        {
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

    protected void BT_AddWebSiteOperator_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strWebSite, strUserCode, strUserName, strSortNumber;

        strWebSite = TB_WebSite.Text.Trim();
        strUserCode = TB_SiteUserCode.Text.Trim();
        strUserName = TB_SiteUserName.Text.Trim();
        strSortNumber = TB_WebSiteSort.Text.Trim();

        strHQL = "Select * From T_ProjectMember Where UserCode = " + "'" + strUserCode + "'" + " and UserName = " + "'" + strUserName + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
        if (ds.Tables[0].Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGCYHDMHXMBCZJC") + "')", true);
            return;
        }

        try
        {
            strHQL = "Insert Into T_SiteCustomerServiceOperator(WebSite,UserCode,UserName,SortNumber) Values(" + "'" + strWebSite + "'" + "," + "'" + strUserCode + "'" + "," + "'" + strUserName + "'" + "," + strSortNumber + ")";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = "Update T_SiteCustomerServiceOperator Set UserCode = " + "'" + strUserCode + "'" + "," + "UserName = " + "'" + strUserName + "'" + "," + "SortNumber = " + strSortNumber + " Where WebSite = " + "'" + strWebSite + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadSiteCustomerServiceOperator();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalSiteCustomerServiceOperator');", true);
    }

    protected void BT_DeleteWebSiteOperator_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strWebSite;

        strWebSite = TB_WebSite.Text.Trim();

        try
        {
            strHQL = "Delete From T_SiteCustomerServiceOperator Where WebSite = " + "'" + strWebSite + "'";
            ShareClass.RunSqlCommand(strHQL);

            LoadSiteCustomerServiceOperator();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalSiteCustomerServiceOperator');", true);
        }
        catch
        {
        }
    }

    protected void BT_GoodsShipmentAdd_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strType = TB_GoodsShipmentType.Text.Trim();
        string strSort = TB_GoodsShipmentSort.Text.Trim();

        try
        {
            strHQL = "Insert Into T_GoodsShipmentType(TypeName,SortNumber) Values (" + "'" + strType + "'" + "," + strSort + ")";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL= "Update T_GoodsShipmentType Set SortNumber = " + strSort + " Where TypeName = '" + strType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadGoodsShipmentType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalGoodsShipmentType');", true);
    }

    protected void BT_GoodsShipmentDelete_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strType = TB_GoodsShipmentType.Text.Trim();
        string strSort = TB_GoodsShipmentSort.Text.Trim();

        try
        {
            strHQL = "Delete From T_GoodsShipmentType Where TypeName = " + "'" + strType + "'";
            ShareClass.RunSqlCommand(strHQL);

            LoadGoodsShipmentType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalGoodsShipmentType');", true);
        }
        catch
        {
        }
    }

    protected void BT_GoodsCheckInAdd_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strType = TB_GoodsCheckInType.Text.Trim();
        string strSort = TB_GoodsCheckInSort.Text.Trim();

        try
        {
            strHQL = "Insert Into T_GoodsCheckInType(TypeName,SortNumber) Values (" + "'" + strType + "'" + "," + strSort + ")";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = "Update T_GoodsCheckInType Set SortNumber = " + strSort + " Where TypeName = '" + strType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }


        LoadGoodsCheckInType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalGoodsCheckInType');", true);
    }

    protected void BT_GoodsCheckInDelete_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strType = TB_GoodsCheckInType.Text.Trim();
        string strSort = TB_GoodsCheckInSort.Text.Trim();

        try
        {
            strHQL = "Delete From T_GoodsCheckInType Where TypeName = " + "'" + strType + "'";
            ShareClass.RunSqlCommand(strHQL);

            LoadGoodsCheckInType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalGoodsCheckInType');", true);
        }
        catch
        {
        }
    }

    protected void BT_AddConstractBigType_Click(object sender, EventArgs e)
    {
        string strBigType = TB_ConstractBigType.Text.Trim();
        string strSortNo = TB_ConstractBigTypeSortNo.Text.Trim();

        string strHQL;

        try
        {
            strHQL = "Insert Into T_ConstractBigType(BigType,SortNumber) VAlues (" + "'" + strBigType + "'" + "," + "'" + strSortNo + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);
       
        }
        catch
        {
            try
            {
                strHQL = "Update T_ConstractBigType Set SortNumber = " + "'" + strSortNo + "'" + " Where BigType = " + "'" + strBigType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadConststactBigType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalConstractBigType');", true);
    }

    protected void BT_DeleteConstractType_Click(object sender, EventArgs e)
    {
        string strBigType = TB_ConstractBigType.Text.Trim();
        string strSortNo = TB_ConstractBigTypeSortNo.Text.Trim();

        string strHQL = "Delete From T_ConstractBigType Where BigType = " + "'" + strBigType + "'";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadConststactBigType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalConstractBigType');", true);
        }
        catch
        {
        }
    }

    protected void BT_SaleTypeNew_Click(object sender, EventArgs e)
    {
        string strType = TB_SaleType.Text.Trim();
        string strSortNo = TB_SaleTypeSort.Text.Trim();

        string strHQL;

        try
        {
             strHQL = "Insert Into T_SaleType(Type,SortNumber) VAlues (" + "'" + strType + "'" + "," + "'" + strSortNo + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = "Update T_SaleType Set SortNumber = " + "'" + strSortNo + "'" + " Where Type = " + "'" + strType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadSaleType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalSaleType');", true);
    }

    protected void BT_SaleTypeDelete_Click(object sender, EventArgs e)
    {
        string strType = TB_SaleType.Text.Trim();
        string strSortNo = TB_SaleTypeSort.Text.Trim();

        string strHQL = "Delete From T_SaleType Where Type =  '" + strType + "'";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadSaleType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalSaleType');", true);
        }
        catch
        {
        }
    }

    protected void BT_ConstractRadioNew_Click(object sender, EventArgs e)
    {
        string strRadio = TB_ConstractRadio.Text.Trim();

        string strHQL = "Insert Into T_ConstractRadio(Radio) VAlues (" + "'" + strRadio + "')";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = "Update T_ConstractRadio Set Radio = " + "'" + strRadio + "'" + " Where Radio = " + "'" + strRadio + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadConstractRadio();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalConstractRadio');", true);
    }

    protected void BT_ConstractRadioDelete_Click(object sender, EventArgs e)
    {
        string strRadio = TB_ConstractRadio.Text.Trim();
        string strHQL = "Delete From T_ConstractRadio Where Radio =  '" + strRadio + "'";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadConstractRadio();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalConstractRadio');", true);
        }
        catch
        {
        }
    }

    protected void BT_InvoiceTypeNew_Click(object sender, EventArgs e)
    {
        string strType = TB_InvoiceType.Text.Trim();
        string strSortNo = TB_InvoiceTypeSort.Text.Trim();

        string strHQL = "Insert Into T_InvoiceType(Type,SortNumber) VAlues (" + "'" + strType + "'" + "," + "'" + strSortNo + "'" + ")";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            try
            {
                strHQL = "Update T_InvoiceType Set SortNumber = " + "'" + strSortNo + "'" + " Where Type = " + "'" + strType + "'";
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        LoadInvoiceType();
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalInvoiceType');", true);
    }

    protected void BT_InvoiceTypeDelete_Click(object sender, EventArgs e)
    {
        string strType = TB_InvoiceType.Text.Trim();
        string strSortNo = TB_InvoiceTypeSort.Text.Trim();

        string strHQL = "Delete From T_InvoiceType Where Type =  '" + strType + "'";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            LoadInvoiceType();
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "closeModal", "hideModal('modalInvoiceType');", true);
        }
        catch
        {
        }
    }

    /// <summary>
    /// 合同大类
    /// </summary>
    protected void LoadConststactBigType()
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractBigType as constractBigType Order by constractBigType.SortNumber ASC";
        ConstractBigTypeBLL constractBigTypeBLL = new ConstractBigTypeBLL();
        lst = constractBigTypeBLL.GetAllConstractBigTypes(strHQL);

        DataGrid37.DataSource = lst;
        DataGrid37.DataBind();
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

    protected void LoadReceivePayWay()
    {
        string strHQL;
        IList lst;

        strHQL = "From ReceivePayWay as receivePayWay Order By receivePayWay.SortNumber ASC";
        ReceivePayWayBLL receivePayWayBLL = new ReceivePayWayBLL();
        lst = receivePayWayBLL.GetAllReceivePayWays(strHQL);

        DataGrid38.DataSource = lst;
        DataGrid38.DataBind();
    }

    protected void LoadBank()
    {
        string strHQL;
        IList lst;

        strHQL = "From Bank as bank Order By bank.SortNumber ASC";
        BankBLL bankBLL = new BankBLL();
        lst = bankBLL.GetAllBanks(strHQL);

        DataGrid39.DataSource = lst;
        DataGrid39.DataBind();
    }

    protected void LoadSiteCustomerServiceOperator()
    {
        string strHQL;

        strHQL = "Select * From T_SiteCustomerServiceOperator Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SiteCustomerServiceOperator");

        DataGrid41.DataSource = ds;
        DataGrid41.DataBind();
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