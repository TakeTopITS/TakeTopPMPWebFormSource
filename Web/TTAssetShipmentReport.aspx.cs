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


using NickLee.Views.Web.UI;
using NickLee.Views.Windows.Forms.Printing;

using ProjectMgt.Model;
using ProjectMgt.DAL;
using ProjectMgt.BLL;

public partial class TTAssetShipmentReport : System.Web.UI.Page
{
    string strRelatedType, strRelatedID, strUserCode;
    private int _totalCount;

    protected void Page_Load(object sender, EventArgs e)
    {
        string strHQL;

        string strDepartString;

        strUserCode = Session["UserCode"].ToString();

        strRelatedType = Request.QueryString["RelatedType"];
        strRelatedID = Request.QueryString["RelatedID"];

        LB_ReportName.Text = LanguageHandle.GetWord("ZiChanChuKuBaoBiao");


        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickParentA", " aHandler();", true);
        if (Page.IsPostBack != true)
        {
            DLC_StartTime.Text = DateTime.Now.ToString("yyyy-MM-dd");
            DLC_EndTime.Text = DateTime.Now.ToString("yyyy-MM-dd");

            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthorityAsset(strUserCode);
        }
    }

    protected void BT_Find_Click(object sender, EventArgs e)
    {
        string strSQL;

        string strStartTime, strEndTime;
        string strApplicant;

        string strDepartString;
        strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthorityAsset(strUserCode);

        string strAssetCode = TB_AssetCode.Text.Trim();
        string strAssetName = TB_AssetName.Text.Trim();
        string strModelNumber = TB_ModelNumber.Text.Trim();
        string strSpec = TB_Spec.Text.Trim();

        strStartTime = DateTime.Parse(DLC_StartTime.Text).ToString("yyyyMMdd");
        strEndTime = DateTime.Parse(DLC_EndTime.Text).ToString("yyyyMMdd");

        strApplicant = TB_Applicant.Text.Trim();
        strApplicant = "%" + strApplicant + "%";

        strAssetCode = "%" + strAssetCode + "%";
        strAssetName = "%" + strAssetName + "%";
        strModelNumber = "%" + strModelNumber + "%";
        strSpec = "%" + strSpec + "%";

        if (strRelatedType == "Other")
        {
            strSQL = "Select * From T_AssetShipmentReport where ";
            strSQL += " OperatorName like '" + strApplicant + "'";
            strSQL += " and AssetCode Like '" + strAssetCode + "'";
            strSQL += " and AssetName like '" + strAssetName + "'";
            strSQL += " and ModelNumber Like '" + strModelNumber + "'";
            strSQL += " and Spec Like '" + strSpec + "'";
            strSQL += " and to_char(ShipTime,'yyyymmdd') >= '" + strStartTime + "' and to_char(ShipTime,'yyyymmdd') <= '" + strEndTime + "'";
            strSQL += " and OperatorCode in (Select UserCode From T_ProjectMember Where DepartCode in " + strDepartString + ")";
            strSQL += " Order by ID DESC";
        }
        else
        {
            strSQL = "Select * From T_AssetShipmentReport where ";
            strSQL += " OperatorName like '" + strApplicant + "'";
            strSQL += " and AssetCode Like '" + strAssetCode + "'";
            strSQL += " and AssetName like '" + strAssetName + "'";
            strSQL += " and ModelNumber Like '" + strModelNumber + "'";
            strSQL += " and Spec Like '" + strSpec + "'";
            strSQL += " and to_char(ShipTime,'yyyymmdd') >= '" + strStartTime + "' and to_char(ShipTime,'yyyymmdd') <= '" + strEndTime + "' and RelatedType = '" + strRelatedType + "' and RelatedID = " + strRelatedID;
            strSQL += " and OperatorCode in (Select UserCode From T_ProjectMember Where DepartCode in " + strDepartString + ")";
            strSQL += " Order by ID DESC";
        }

        // SQL分页：仅查询当前页数据，不再加载全部行
        DataGrid1.CurrentPageIndex = 0;
        DataSet ds = ShareClass.GetPagedDataSet(strSQL, "T_AssetShipmentReport", 1, DataGrid1.PageSize, out _totalCount);
        DataGrid1.DataSource = ds;
        DataGrid1.DataBind();

        LB_Sql.Text = strSQL;
    }


    protected void BT_FindShipmentNO_Click(object sender, EventArgs e)
    {
        string strSQL, strShipmentNO = "0";

        string strDepartString;
        strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthorityAsset(strUserCode);

        strSQL = "Select * From T_AssetShipmentReport where ShipmentNO = " + strShipmentNO;
        strSQL += " and OperatorCode in (Select UserCode From T_ProjectMember Where DepartCode in " + strDepartString + ")";
        strSQL += " Order by ID DESC";

        DataSet ds = ShareClass.GetPagedDataSet(strSQL, "T_AssetShipmentReport", 1, DataGrid1.PageSize, out _totalCount);
        DataGrid1.DataSource = ds;
        DataGrid1.DataBind();

        LB_Sql.Text = strSQL;
    }


    protected void DataGrid1_PageIndexChanged(object sender, DataGridPageChangedEventArgs e)
    {
        DataGrid1.CurrentPageIndex = e.NewPageIndex;
        string strSQL = LB_Sql.Text;

        // SQL分页：翻页时仅查当前页，不再全量查询
        DataSet ds = ShareClass.GetPagedDataSet(strSQL, "T_AssetShipmentReport", e.NewPageIndex + 1, DataGrid1.PageSize, out _totalCount);
        DataGrid1.DataSource = ds;
        DataGrid1.DataBind();

        LB_PageIndex.Text = (e.NewPageIndex + 1).ToString();
    }

}
