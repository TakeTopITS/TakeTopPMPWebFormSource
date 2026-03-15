using Npgsql;

using ProjectMgt.BLL;
using ProjectMgt.DAL;
using ProjectMgt.Model;

using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Resources;
using System.Web;
using System.Web.Mail;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class TTSystemAnalystChartRelatedUserSet : System.Web.UI.Page
{
    string strUserCode, strFormType;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strFormType = Request.QueryString["FormType"];

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack != true)
        {
            LoadAllSystemAnalystChart();
            LoadUserSystemAnalystChart(strUserCode, strFormType);
        }
    }

    protected void DataGrid1_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        string strHQL;
        string strChartName;

        strChartName = ((Button)e.Item.FindControl("BT_ChartName")).Text.Trim();

        strHQL = "Select * From T_SystemAnalystChartRelatedUser Where UserCode = '" + strUserCode + "' and ChartName = '" + strChartName + "'" + " and FormType='" + strFormType + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemAnalystChartManagement");
        if (ds.Tables[0].Rows.Count > 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZYCZBNZFTJJC") + "')", true);
            return;
        }

        strHQL = "Insert Into T_SystemAnalystChartRelatedUser(UserCode,ChartName,FormType) Values('" + strUserCode + "','" + strChartName + "','" + strFormType + "')";
        ShareClass.RunSqlCommand(strHQL);

        LoadUserSystemAnalystChart(strUserCode, strFormType);
    }

    protected void DataGrid4_ItemCommand(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            string strHQL;

            string strID, strChartName;
            string strCommandName;

            strID = e.Item.Cells[0].Text;
            strChartName = e.Item.Cells[1].Text;

            strCommandName = e.CommandName.ToString();

            for (int i = 0; i < DataGrid4.Items.Count; i++)
            {
                DataGrid4.Items[i].ForeColor = Color.Black;
            }
            e.Item.ForeColor = Color.Red;

            try
            {
                if (strCommandName == "DELETE")
                {
                    strHQL = "Delete From T_SystemAnalystChartRelatedUser Where ID = " + strID;
                    ShareClass.RunSqlCommand(strHQL);

                    LoadUserSystemAnalystChart(strUserCode, strFormType);
                }

            }
            catch
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBJC") + "')", true);
            }
        }
    }

    protected void BT_Save_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strID;

        int j = 0, intSortNumber;

        try
        {
            for (j = 0; j < DataGrid4.Items.Count; j++)
            {
                strID = DataGrid4.Items[j].Cells[0].Text.Trim();

                intSortNumber = int.Parse(((TextBox)(DataGrid4.Items[j].FindControl("TB_SortNumber"))).Text.Trim());

                strHQL = "Update T_SystemAnalystChartRelatedUser Set SortNumber = " + intSortNumber.ToString() + " Where ID = " + strID;
                ShareClass.RunSqlCommand(strHQL);
            }

            //////清空用户分析图字符串表
            //SaveAnalystChartString(strUserCode);

            LoadUserSystemAnalystChart(strUserCode, strFormType);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click222", "reloadPrentPage();", true);

        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZCWBCSBJC") + "')", true);
        }
    }

    

    // <summary>
    /// 将DataSet序列化为字符串并保存到数据库表t_memberchartstringformainpage的analystchartstring字段
    /// </summary>
    /// <param name="strUserCode">用户代码</param>
    /// <param name="ds">要序列化的DataSet</param>
    protected void SaveAnalystChartString(string strUserCode)
    {
        DataSet ds = ShareClass.GetSytemChartDataSet(Session["UserCode"].ToString(), "PersonalSpacePage");// 调用函数，将DataSet序列化并存入数据库
                                                                                                                      
        string serializedDataSet = ShareClass.SerializeDataSetToString(ds);// 将DataSet序列化为字符串

        using (var conn = new NpgsqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString))
        {
            conn.Open();

            // 记录存在，更新AnalystChartString字段
            string updateSql = @"UPDATE public.t_memberchartstringformainpage 
                                            SET analystchartstring = @analystchartstring
                                            WHERE usercode = @usercode";

            using (var updateCmd = new NpgsqlCommand(updateSql, conn))
            {
                updateCmd.Parameters.AddWithValue("@analystchartstring", NpgsqlTypes.NpgsqlDbType.Text, serializedDataSet);
                updateCmd.Parameters.AddWithValue("@usercode", strUserCode);

                int rowsAffected = updateCmd.ExecuteNonQuery();
                //LogClass.WriteLogFile($"AnalystChart更新记录成功，影响行数: {rowsAffected}");
            }
        }
    }

    protected void BT_AssignToOtherMember_Click(object sender, EventArgs e)
    {
        string strHQL;

        strHQL = string.Format(@"Insert Into T_SystemAnalystChartRelatedUser('{0}',ChartName,FormType,SortNumber)
                 Select UserCode,ChartName,FormType,SortNumber From T_SystemAnalystChartRelatedUser
                 Where UserCode = 'ADMIN' 
	             and ChartName Not in (Select ChartName From T_SystemAnalystChartRelatedUser Where UserCode = '{0}')", strUserCode);

        ShareClass.RunSqlCommand(strHQL);

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZFenPaChengGong") + "')", true);
    }

    protected void LoadAllSystemAnalystChart()
    {
        string strHQL;

        strHQL = "Select * From T_SystemAnalystChartManagement Where Status = 'YES'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemAnalystChartManagement");

        DataGrid1.DataSource = ds;
        DataGrid1.DataBind();
    }

    protected void LoadUserSystemAnalystChart(string strUserCode, string strFormType)
    {
        string strHQL;
        string strSortNumber;

        strHQL = "Select ID,ChartName,SortNumber From T_SystemAnalystChartRelatedUser Where UserCode = " + "'" + strUserCode + "'" + " and FormType = " + "'" + strFormType + "'";
        strHQL += " and ChartName in (Select ChartName From t_systemanalystchartmanagement Where Status = 'YES')";
        strHQL += " Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemAnalystChartManagement");

        DataGrid4.DataSource = ds;
        DataGrid4.DataBind();

        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strSortNumber = ds.Tables[0].Rows[i][2].ToString().Trim();
            ((TextBox)DataGrid4.Items[i].FindControl("TB_SortNumber")).Text = strSortNumber;
        }
    }
}
