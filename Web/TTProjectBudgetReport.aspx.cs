using ProjectMgt.BLL;
using ProjectMgt.Model;

using System;
using System.Collections;
using System.Data;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTProjectBudgetReport : System.Web.UI.Page
{
    string strProjectID, strProjectStatus;

    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode, strUserName, strProjectName;

        strUserCode = Session["UserCode"].ToString();
        strUserName = ShareClass.GetUserName(strUserCode);

        strProjectID = Request.QueryString["ProjectID"];
        strProjectName = ShareClass.GetProjectName(strProjectID);
        strProjectStatus = ShareClass.GetProjectStatus(strProjectID);

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            //依费用科目插入不存在预算表中预算科目数据到预算表
            InsertAccountDataToBudget(strProjectID);

            //加载项目预算数据
            LoadProjectBudget(strProjectID);

            ShareClass.InitialProjectMemberTree(TreeView1, strProjectID);

            LB_ProjectID.Text = strProjectID;
            LB_UserCode.Text = strUserCode;
            LB_UserName.Text = strUserName;

            LB_ReportName.Text = LanguageHandle.GetWord("Project") + strProjectID + " " + ShareClass.GetProjectName(strProjectID);

            //默认加载全部费用科目明细
            LoadProjectExpenseByAccount(strProjectID, "All");
        }
    }

    protected void DataGrid1_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            string strAccount = e.Item.Cells[0].Text.Trim();
            string strUserCode = LB_UserCode.Text.Trim();

            for (int i = 0; i < DataGrid1.Items.Count; i++)
            {
                DataGrid1.Items[i].ForeColor = Color.Black;
            }
            e.Item.ForeColor = Color.Red;

            LB_Account.Text = strAccount;

            if (e.CommandName == "Select")
            {
                LoadProjectExpenseByAccount(strProjectID, strAccount);
                ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popDetailWindow','true') ", true);
            }
        }
    }

    protected void BT_AllMember_Click(object sender, EventArgs e)
    {
        LB_OperatorCode.Text = "All";
        LB_OperatorName.Text = "";

        LB_Account.Text = "All";

        LoadProjectExpenseByAccount(strProjectID, "All");

        ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popDetailWindow','true') ", true);

    }

    protected void TreeView1_SelectedNodeChanged(object sender, EventArgs e)
    {
        string strHQL;
        IList lst;

        string strID;
        string strUserCode, strUserName;
        string strAccount;
        decimal deExpense = 0, deConfirmExpense = 0;

        strID = TreeView1.SelectedNode.Target.Trim();
        strAccount = LB_Account.Text.Trim();

        try
        {
            strID = int.Parse(strID).ToString();

            strHQL = "from ProRelatedUser as proRelatedUser Where proRelatedUser.ID = " + strID;
            ProRelatedUserBLL proRelatedUserBLL = new ProRelatedUserBLL();
            lst = proRelatedUserBLL.GetAllProRelatedUsers(strHQL);

            if (lst.Count > 0)
            {
                ProRelatedUser proRelatedUser = (ProRelatedUser)lst[0];

                strUserCode = proRelatedUser.UserCode.Trim();
                strUserName = proRelatedUser.UserName.Trim();

                if (strAccount == "All")
                {
                    strHQL = "from ProExpense as proExpense where proExpense.ProjectID = " + strProjectID + " and proExpense.UserCode = " + "'" + strUserCode + "'";
                    strHQL += " Order by proExpense.ID DESC";
                }
                else
                {
                    strHQL = "from ProExpense as proExpense where proExpense.ProjectID = " + strProjectID + " and proExpense.UserCode = " + "'" + strUserCode + "'";
                    strHQL += " and proExpense.Account = " + "'" + strAccount + "'";
                    strHQL += " Order by proExpense.ID DESC";
                }
                ProExpenseBLL proExpenseBLL = new ProExpenseBLL();
                lst = proExpenseBLL.GetAllProExpenses(strHQL);
                DataList1.DataSource = lst;
                DataList1.DataBind();

                ProExpense proExpense = new ProExpense();
                for (int i = 0; i < lst.Count; i++)
                {
                    proExpense = (ProExpense)lst[i];
                    deExpense += proExpense.Amount;
                }


                LB_Amount.Text = deExpense.ToString();
                LB_ConfirmAmount.Text = deConfirmExpense.ToString();

                LB_OperatorCode.Text = strUserCode;
                LB_OperatorName.Text = strUserName;

                LB_Sql.Text = strHQL;
            }
        }
        catch
        {
        }

        ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popDetailWindow','true') ", true);
    }



    protected void LoadProjectBudget(string strProjectID)
    {
        string strHQL;
        IList lst;

        decimal deBudget = 0;

        strHQL = "From ProjectBudget as projectBudget Where projectBudget.ProjectID = " + strProjectID;
        ProjectBudgetBLL projectBudgetBLL = new ProjectBudgetBLL();
        lst = projectBudgetBLL.GetAllProjectBudgets(strHQL);
        DataGrid1.DataSource = lst;
        DataGrid1.DataBind();

        ProjectBudget projectBudget = new ProjectBudget();

        for (int i = 0; i < lst.Count; i++)
        {
            projectBudget = (ProjectBudget)lst[i];
            deBudget += projectBudget.Amount;
        }

        LB_RealBudget.Text = deBudget.ToString();

        LB_ProExpense.Text = GetProjectExpense(strProjectID);

        LB_ProjectBudget.Text = ShareClass.GetProject(strProjectID).Budget.ToString();

        FinishPercentPicture(strProjectID);
    }

    protected void LoadProjectExpenseByAccount(string strProjectID, string strAccount)
    {
        string strHQL;
        IList lst;

        decimal deExpense = 0, deConfirmExpense = 0;

        if (strAccount == "All")
        {
            strHQL = "from ProExpense as proExpense where proExpense.ProjectID = " + strProjectID;
            strHQL += " Order by proExpense.ID DESC";
        }
        else
        {
            strHQL = "from ProExpense as proExpense where proExpense.ProjectID = " + strProjectID;
            strHQL += " and proExpense.Account = " + "'" + strAccount + "'";
            strHQL += " Order by proExpense.ID DESC";
        }

        ProExpenseBLL proExpenseBLL = new ProExpenseBLL();
        lst = proExpenseBLL.GetAllProExpenses(strHQL);
        DataList1.DataSource = lst;
        DataList1.DataBind();

        ProExpense proExpense = new ProExpense();
        for (int i = 0; i < lst.Count; i++)
        {
            proExpense = (ProExpense)lst[i];
            deExpense += proExpense.Amount;
            deConfirmExpense += proExpense.ConfirmAmount;
        }

        LB_Amount.Text = deExpense.ToString();
        LB_ConfirmAmount.Text = deConfirmExpense.ToString();

        LB_OperatorCode.Text = "All";
        LB_OperatorName.Text = "";
    }

    protected void FinishPercentPicture(string strProjectID)
    {
        string strAccount;
        decimal deAccountExpense, deAccountBudget;
        decimal deWidth;
        int intWidth;
        int i;

        for (i = 0; i < DataGrid1.Items.Count; i++)
        {
            strAccount = DataGrid1.Items[i].Cells[0].Text.Trim();
            deAccountBudget = decimal.Parse(DataGrid1.Items[i].Cells[1].Text.Trim());
            deAccountExpense = GetProjectAccountTotalAmount(strProjectID, strAccount);

            if (deAccountBudget == 0)
            {
                deWidth = (deAccountExpense / 1) * 100;
            }
            else
            {
                deWidth = (deAccountExpense / deAccountBudget) * 100;
            }

            deWidth = System.Decimal.Round(deWidth, 0);
            intWidth = int.Parse(deWidth.ToString());

            // 设置进度条宽度
            System.Web.UI.HtmlControls.HtmlGenericControl progressBar =
                (System.Web.UI.HtmlControls.HtmlGenericControl)DataGrid1.Items[i].FindControl("ProgressBar");

            decimal progressWidth = 0;
            // 计算进度条宽度（基于205px总宽度）
            if (deAccountBudget == 0)
            {
                progressWidth = (deAccountExpense / 1) * 205;
            }
            else
            {
                progressWidth = (deAccountExpense / deAccountBudget) * 205;
            }

            if (progressWidth > 205) progressWidth = 205;
            if (progressWidth < 0) progressWidth = 0;

            progressBar.Style["width"] = progressWidth + "px";

            // 设置费用文字 - 第一行左对齐
            Label lbFinishPercent = (Label)DataGrid1.Items[i].FindControl("LB_FinishPercent");
            lbFinishPercent.Text = LanguageHandle.GetWord("Expense") + ":" + deAccountExpense.ToString("#0.00");

            // 设置预算文字 - 第二行右对齐
            Label lbDefaultPercent = (Label)DataGrid1.Items[i].FindControl("LB_DefaultPercent");
            lbDefaultPercent.Text = LanguageHandle.GetWord("Budget") + ":" + deAccountBudget.ToString("#0.00");

            // 设置超预算颜色
            if (deAccountExpense > deAccountBudget)
            {
                progressBar.Style["background-color"] = "red";
                lbFinishPercent.Style["color"] = "black";
                lbDefaultPercent.Style["color"] = "black";
            }
            else
            {
                progressBar.Style["background-color"] = "yellowgreen";
                lbFinishPercent.Style["color"] = "black";
                lbDefaultPercent.Style["color"] = "black";
            }
        }
    }

    //依费用科目插入不存在预算表中预算科目数据到预算表
    protected void InsertAccountDataToBudget(string strProjectID)
    {
        string strHQL;

        try
        {
            strHQL = string.Format(@"INSERT INTO public.t_projectbudget(
                    accountcode, account, amount, currencytype,description, projectid,  creatorcode, creatorname, createtime)
                    SELECT DISTINCT accountcode, trim(account) as account, 0, trim(currencytype) as CurrencyType, '', {0}, '{1}', '{2}', NOW()
                    FROM public.t_proexpense 
                    WHERE trim(AccountCode)||trim(Account)||trim(CurrencyType)
		            NOT IN (SELECT trim(AccountCode)||trim(Account)||trim(CurrencyType) FROM t_projectbudget WHERE ProjectID = {0})
                    AND ProjectID = {0}",
                    strProjectID,
                    Session["UserCode"].ToString(),
                    Session["UserName"].ToString());
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    protected decimal GetProjectAccountTotalAmount(string strProjectID, string strAccount)
    {
        string strHQL;

        strHQL = "Select Sum(ConfirmAmount) From T_ProExpense Where ProjectID = " + strProjectID + " and Account = " + "'" + strAccount + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProExpense");

        try
        {
            return decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        catch
        {
            return 0;
        }
    }

    protected string GetProjectExpense(string strProjectID)
    {
        string strHQL;

        strHQL = "Select COALESCE(Sum(ConfirmAmount),0) From T_ProExpense Where ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProExpense");


        try
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        catch
        {
            return "0";
        }
    }
}
