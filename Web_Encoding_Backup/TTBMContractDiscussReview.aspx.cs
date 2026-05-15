using System;
using System.Resources;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ProjectMgt.BLL;
using ProjectMgt.Model;

public partial class TTBMContractDiscussReview : System.Web.UI.Page
{
    string strUserCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack != true)
        {
            DLC_EnterDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            DLC_ReviewDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            TB_EnterPer.Text = ShareClass.GetUserName(strUserCode);
            TB_Reviewer.Text = ShareClass.GetUserName(strUserCode);
            TB_EnterUnit.Text = GetUserDepartName(strUserCode);

            LoadBMSupplierInfoName();

            LoadBMContractDiscussList();
        }
    }

    /// <summary>
    /// 获取人员所在部门
    /// </summary>
    /// <param name="strUserCode"></param>
    /// <returns></returns>
    protected string GetUserDepartName(string strUserCode)
    {
        string strHQL = " from ProjectMember as projectMember where projectMember.UserCode = '" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        if (lst.Count > 0 && lst != null)
        {
            ProjectMember projectMember = (ProjectMember)lst[0];

            strHQL = "From Department as department Where department.DepartCode = '" + projectMember.DepartCode.Trim() + "'";
            DepartmentBLL departmentBLL = new DepartmentBLL();
            lst = departmentBLL.GetAllDepartments(strHQL);
            if (lst.Count > 0 && lst != null)
            {
                Department department = (Department)lst[0];
                return department.DepartName.Trim();
            }
            else
                return "";
        }
        else
            return "";
    }

    protected void LoadBMSupplierInfoName()
    {
        string strHQL;
        IList lst;
        //绑定供应商名称Status = "Qualified"
        strHQL = "From BMSupplierInfo as bMSupplierInfo Where bMSupplierInfo.Status='Qualified' Order By bMSupplierInfo.ID Desc";
        BMSupplierInfoBLL bMSupplierInfoBLL = new BMSupplierInfoBLL();
        lst = bMSupplierInfoBLL.GetAllBMSupplierInfos(strHQL);
        DL_SupplierCode.DataSource = lst;
        DL_SupplierCode.DataBind();
        DL_SupplierCode.Items.Insert(0, new ListItem("--Select--", ""));
    }

    protected void LoadBMContractDiscussList()
    {
        string strHQL;

        strHQL = "Select * From T_BMContractDiscuss Where 1=1";

        if (!string.IsNullOrEmpty(TextBox1.Text.Trim()))
        {
            strHQL += " and (PointSummary like '%" + TextBox1.Text.Trim() + "%' or Name like '%" + TextBox1.Text.Trim() + "%' or EnterPer like '%" + TextBox1.Text.Trim() + "%' " +
            "or ReviewResult like '%" + TextBox1.Text.Trim() + "%' or DiscussFileName like '%" + TextBox1.Text.Trim() + "%') ";
        }
        if (!string.IsNullOrEmpty(TextBox2.Text.Trim()))
        {
            strHQL += " and SupplierName like '%" + TextBox2.Text.Trim() + "%' ";
        }
        if (!string.IsNullOrEmpty(TextBox3.Text.Trim()))
        {
            strHQL += " and '" + TextBox3.Text.Trim() + "'::date-EnterDate::date<=0 ";
        }
        if (!string.IsNullOrEmpty(TextBox4.Text.Trim()))
        {
            strHQL += " and '" + TextBox4.Text.Trim() + "'::date-EnterDate::date>=0 ";
        }
        strHQL += " Order By ID DESC ";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BMContractDiscuss");

        DataGrid2.CurrentPageIndex = 0;
        DataGrid2.DataSource = ds;
        DataGrid2.DataBind();
        lbl_sql.Text = strHQL;
    }

    /// <summary>
    /// 新增或更新时，合同洽谈名称是否存在，存在返回true；不存在返回false。
    /// </summary>
    /// <param name="strBarCode"></param>
    /// <param name="strId"></param>
    /// <returns></returns>
    protected bool IsBMContractDiscussName(string strName, string strID)
    {
        bool flag = true;
        string strHQL;
        if (string.IsNullOrEmpty(strID))
        {
            strHQL = "Select ID From T_BMContractDiscuss Where Name='" + strName + "' ";
        }
        else
            strHQL = "Select ID From T_BMContractDiscuss Where Name='" + strName + "' and ID<>'" + strID + "' ";
        DataTable dt = ShareClass.GetDataSetFromSql(strHQL, "T_BMContractDiscuss").Tables[0];
        if (dt.Rows.Count > 0 && dt != null)
        {
            flag = true;
        }
        else
        {
            flag = false;
        }
        return flag;
    }

    /// <summary>
    /// 新增时，获取表T_BMContractDiscuss中最大编号。
    /// </summary>
    /// <param name="strBarCode"></param>
    /// <param name="strId"></param>
    /// <returns></returns>
    protected int GetMaxBMContractDiscussID(BMContractDiscuss bmbp)
    {
        string strHQL = "Select ID From T_BMContractDiscuss where Name='" + bmbp.Name.Trim() + "' and EnterPer='" + bmbp.EnterPer.Trim() + "' Order by ID Desc";
        DataTable dt = ShareClass.GetDataSetFromSql(strHQL, "T_BMContractDiscuss").Tables[0];
        if (dt.Rows.Count > 0 && dt != null)
        {
            return int.Parse(dt.Rows[0]["ID"].ToString());
        }
        else
        {
            return 0;
        }
    }

    protected string GetBMSupplierInfoName(string strID)
    {
        string strHQL;
        IList lst;
        //绑定供应商名称
        strHQL = "From BMSupplierInfo as bMSupplierInfo Where bMSupplierInfo.Code='" + strID + "' ";
        BMSupplierInfoBLL bMSupplierInfoBLL = new BMSupplierInfoBLL();
        lst = bMSupplierInfoBLL.GetAllBMSupplierInfos(strHQL);
        if (lst.Count > 0 && lst != null)
        {
            BMSupplierInfo bMSupplierInfo = (BMSupplierInfo)lst[0];
            return bMSupplierInfo.Name.Trim();
        }
        else
            return "";
    }

    protected void BT_Update_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(TB_Name.Text.Trim()) || TB_Name.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGMCBNWKCZSBJC") + "')", true);
            TB_Name.Focus();
            return;
        }
        if (IsBMContractDiscussName(TB_Name.Text.Trim(), LB_ID.Text.Trim()))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGMCYCZCZSBJC") + "')", true);
            TB_Name.Focus();
            return;
        }

        string strHQL = "From BMContractDiscuss as bMContractDiscuss where bMContractDiscuss.ID = '" + LB_ID.Text.Trim() + "'";
        BMContractDiscussBLL bMContractDiscussBLL = new BMContractDiscussBLL();
        IList lst = bMContractDiscussBLL.GetAllBMContractDiscusss(strHQL);
        BMContractDiscuss bMContractDiscuss = (BMContractDiscuss)lst[0];

        bMContractDiscuss.ReviewDate = DateTime.Parse(DLC_ReviewDate.Text.Trim());
        bMContractDiscuss.EnterUnit = TB_EnterUnit.Text.Trim();
        bMContractDiscuss.EnterPer = TB_EnterPer.Text.Trim();
        bMContractDiscuss.Reviewer = TB_Reviewer.Text.Trim();
        bMContractDiscuss.Name = TB_Name.Text.Trim();
        bMContractDiscuss.ReviewResult = TB_ReviewResult.Text.Trim();
        bMContractDiscuss.SupplierCode = DL_SupplierCode.SelectedValue.Trim();
        bMContractDiscuss.SupplierName = GetBMSupplierInfoName(bMContractDiscuss.SupplierCode.Trim());
        bMContractDiscuss.EnterDate = DateTime.Parse(DLC_EnterDate.Text.Trim());
        bMContractDiscuss.ContractPrice = NB_ContractPrice.Amount;
        bMContractDiscuss.PointSummary = TB_PointSummary.Text.Trim();
        bMContractDiscuss.Status = "Qualified";

        try
        {
            bMContractDiscussBLL.UpdateBMContractDiscuss(bMContractDiscuss, bMContractDiscuss.ID);
            DL_Status.SelectedValue = "Qualified";
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSHHGCG") + "')", true);

            LoadBMContractDiscussList();
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSHHGSBJC") + "')", true);

            ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','false') ", true);

        }
    }

    protected void BT_Delete_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(TB_Name.Text.Trim()) || TB_Name.Text.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGMCBNWKCZSBJC") + "')", true);
            TB_Name.Focus();
            return;
        }
        if (IsBMContractDiscussName(TB_Name.Text.Trim(), LB_ID.Text.Trim()))
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGMCYCZCZSBJC") + "')", true);
            TB_Name.Focus();
            return;
        }

        string strHQL = "From BMContractDiscuss as bMContractDiscuss where bMContractDiscuss.ID = '" + LB_ID.Text.Trim() + "'";
        BMContractDiscussBLL bMContractDiscussBLL = new BMContractDiscussBLL();
        IList lst = bMContractDiscussBLL.GetAllBMContractDiscusss(strHQL);
        BMContractDiscuss bMContractDiscuss = (BMContractDiscuss)lst[0];

        bMContractDiscuss.ReviewDate = DateTime.Parse(DLC_ReviewDate.Text.Trim());
        bMContractDiscuss.EnterUnit = TB_EnterUnit.Text.Trim();
        bMContractDiscuss.EnterPer = TB_EnterPer.Text.Trim();
        bMContractDiscuss.Reviewer = TB_Reviewer.Text.Trim();
        bMContractDiscuss.Name = TB_Name.Text.Trim();
        bMContractDiscuss.ReviewResult = TB_ReviewResult.Text.Trim();
        bMContractDiscuss.SupplierCode = DL_SupplierCode.SelectedValue.Trim();
        bMContractDiscuss.SupplierName = GetBMSupplierInfoName(bMContractDiscuss.SupplierCode.Trim());
        bMContractDiscuss.EnterDate = DateTime.Parse(DLC_EnterDate.Text.Trim());
        bMContractDiscuss.ContractPrice = NB_ContractPrice.Amount;
        bMContractDiscuss.PointSummary = TB_PointSummary.Text.Trim();
        bMContractDiscuss.Status = "Unqualified";

        try
        {
            bMContractDiscussBLL.UpdateBMContractDiscuss(bMContractDiscuss, bMContractDiscuss.ID);
            DL_Status.SelectedValue = "Unqualified";
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSHBHGCG") + "')", true);

            LoadBMContractDiscussList();
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSHBHGSBJC") + "')", true);

            ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','false') ", true);

        }
    }

    /// <summary>
    /// 删除时，判断合同洽谈是否已被调用，已调用返回true；否则返回false。
    /// </summary>
    /// <param name="strBarCode"></param>
    /// <param name="strId"></param>
    /// <returns></returns>
    protected bool IsBMContractDiscuss(string strID)
    {
        string strHQL;
        bool flag = true;
        strHQL = "Select ID From T_BMContractPreparation Where ContractDiscussID='" + strID + "' ";
        DataTable dt = ShareClass.GetDataSetFromSql(strHQL, "T_BMContractPreparation").Tables[0];
        if (dt.Rows.Count > 0 && dt != null)
        {
            flag = true;
        }
        else
        {
            flag = false;
        }

        return flag;
    }

    protected void DataGrid2_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        string strId, strHQL;
        IList lst;

        if (e.CommandName != "Page")
        {
            strId = ((Button)e.Item.FindControl("BT_ID")).Text.Trim();

            for (int i = 0; i < DataGrid2.Items.Count; i++)
            {
                DataGrid2.Items[i].ForeColor = Color.Black;
            }

            e.Item.ForeColor = Color.Red;

            strHQL = "From BMContractDiscuss as bMContractDiscuss where bMContractDiscuss.ID = '" + strId + "'";
            BMContractDiscussBLL bMContractDiscussBLL = new BMContractDiscussBLL();
            lst = bMContractDiscussBLL.GetAllBMContractDiscusss(strHQL);

            BMContractDiscuss bMContractDiscuss = (BMContractDiscuss)lst[0];

            LB_ID.Text = bMContractDiscuss.ID.ToString().Trim();
            NB_ContractPrice.Amount = bMContractDiscuss.ContractPrice;
            DL_SupplierCode.SelectedValue = bMContractDiscuss.SupplierCode.ToString().Trim();
            DLC_EnterDate.Text = bMContractDiscuss.EnterDate.ToString("yyyy-MM-dd");
            TB_EnterPer.Text = bMContractDiscuss.EnterPer.Trim();
            DLC_ReviewDate.Text = bMContractDiscuss.ReviewDate.ToString("yyyy-MM-dd");
            TB_ReviewResult.Text = bMContractDiscuss.ReviewResult.Trim();
            TB_Name.Text = bMContractDiscuss.Name.Trim();
            TB_EnterUnit.Text = bMContractDiscuss.EnterUnit.Trim();
            TB_Reviewer.Text = string.IsNullOrEmpty(bMContractDiscuss.Reviewer.Trim()) ? ShareClass.GetUserName(strUserCode) : bMContractDiscuss.Reviewer.Trim();
            TB_PointSummary.Text = bMContractDiscuss.PointSummary.Trim();
            DL_Status.SelectedValue = bMContractDiscuss.Status.Trim();

            ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','false') ", true);
        }
    }

    protected void DataGrid2_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        string strHQL = lbl_sql.Text.Trim();
        DataGrid2.CurrentPageIndex = e.NewPageIndex;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BMContractDiscuss");
        DataGrid2.DataSource = ds;
        DataGrid2.DataBind();
    }

    protected void BT_Query_Click(object sender, EventArgs e)
    {
        LoadBMContractDiscussList();
    }
}