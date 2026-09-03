using LumiSoft.Net.Mail;
using LumiSoft.Net.MIME;
using LumiSoft.Net.POP3.Client;

using Microsoft.CSharp;

using MSXML2;

using net.sf.mpxj.primavera.schema;

using Npgsql;

using ProjectMgt.BLL;
using ProjectMgt.Model;

using RTXSAPILib;

using RTXServerApi;

using System;
using System.Activities.DurableInstancing;
using System.Activities.Statements;
using System.CodeDom;
using System.CodeDom.Compiler;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
//using NPOI.SS.Formula.Functions;
//using Microsoft.Office.Interop.MSProject;
//using AjaxControlToolkit.HTMLEditor.ToolbarButton;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.Caching;
using System.Web.Security;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

using TakeTopCore;

using TakeTopGantt;

using TakeTopWF;

using ZXing;
using ZXing.QrCode;

/// <summary>
/// ShareClass partial - ProjectCost
/// </summary>
public static partial class ShareClass
{
    
    #region 项目费用计算

    //删除更多文档
    public static void DeleteMoreDocByDataGrid(DataGrid dataGrid1)
    {
        string strHQL;

        string strDocID;

        for (int i = 0; i < dataGrid1.Items.Count; i++)
        {
            if (((CheckBox)(dataGrid1.Items[i].FindControl("CB_Select"))).Checked == true)
            {
                strDocID = dataGrid1.Items[i].Cells[0].Text.Trim();

                try
                {
                    strHQL = "Update T_Document Set Status = 'Deleted' Where DocID = " + strDocID;
                    ShareClass.RunSqlCommand(strHQL);
                }
                catch
                {
                }
            }
        }
    }

    //检查相应科目项目预算有没有超支
    public static bool CheckProjectExpenseBudget(string strProjectID, string strAccount, decimal deExpense)
    {
        string strHQL;
        IList lst;

        decimal deProBudget, deProAccountBudget, deSumAccountAmount;

        if (strProjectID == "1")
        {
            return true;
        }

        try
        {
            strHQL = "from Project as project where project.ProjectID = " + strProjectID;
            ProjectBLL projectBLL = new ProjectBLL();
            lst = projectBLL.GetAllProjects(strHQL);

            Project project = (Project)lst[0];
            deProBudget = project.Budget;

            strHQL = "From ProjectBudget as projectBudget Where projectBudget.ProjectID = " + strProjectID + " and projectBudget.Account = " + "'" + strAccount + "'";
            ProjectBudgetBLL projectBudgetBLL = new ProjectBudgetBLL();
            lst = projectBudgetBLL.GetAllProjectBudgets(strHQL);
            if (lst.Count > 0)
            {
                ProjectBudget projectBudget = (ProjectBudget)lst[0];
                deProAccountBudget = projectBudget.Amount;
            }
            else
            {
                deProAccountBudget = 0;
            }

            strHQL = "Select COALESCE(Sum(ConfirmAmount),0) From T_ProExpense Where ProjectID = " + strProjectID + " and Account = " + "'" + strAccount + "'";
            strHQL += " Group By Account";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProExpense");
            if (ds.Tables[0].Rows.Count > 0)
            {
                deSumAccountAmount = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                deSumAccountAmount = 0;
            }
            deSumAccountAmount += deExpense;

            if (deSumAccountAmount > deProAccountBudget & deProAccountBudget != 0)
            {
                return false;
            }

            if (deSumAccountAmount > deProBudget)
            {
                return false;
            }

            return true;
        }
        catch
        {
            return false;
        }
    }

    //检查项目物资付款申请单相对应科目项目预算有没有超支
    public static bool CheckProjectExpenseBudgetByProjectMaterialPayApplicant(string strProjectID, string strAccount, decimal deExpense)
    {
        string strHQL;
        IList lst;

        decimal deProBudget, deProAccountBudget, deSumAccountAmount;

        if (strProjectID == "1")
        {
            return true;
        }

        try
        {
            strHQL = "from Project as project where project.ProjectID = " + strProjectID;
            ProjectBLL projectBLL = new ProjectBLL();
            lst = projectBLL.GetAllProjects(strHQL);

            Project project = (Project)lst[0];
            deProBudget = project.Budget;

            strHQL = "From ProjectBudget as projectBudget Where projectBudget.ProjectID = " + strProjectID + " and projectBudget.Account = " + "'" + strAccount + "'";
            ProjectBudgetBLL projectBudgetBLL = new ProjectBudgetBLL();
            lst = projectBudgetBLL.GetAllProjectBudgets(strHQL);
            if (lst.Count > 0)
            {
                ProjectBudget projectBudget = (ProjectBudget)lst[0];
                deProAccountBudget = projectBudget.Amount;
            }
            else
            {
                deProAccountBudget = 0;
            }

            strHQL = "Select COALESCE(Sum(Amount),0) From T_ProjectMaterialPaymentApplicantDetail Where AOID In (Select AOID From T_ProjectMaterialPaymentApplicant Where ProjectID = " + strProjectID + ")";
            strHQL += " and AccountName = " + "'" + strAccount + "'";
            strHQL += " Group By AccountName";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMaterialPaymentApplicantDetail");
            if (ds.Tables[0].Rows.Count > 0)
            {
                deSumAccountAmount = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                deSumAccountAmount = 0;
            }
            deSumAccountAmount += deExpense;

            if (deSumAccountAmount > deProAccountBudget & deProAccountBudget != 0)
            {
                return false;
            }

            if (deSumAccountAmount > deProBudget)
            {
                return false;
            }

            return true;
        }
        catch
        {
            return false;
        }
    }


    //依在用版项目计划进度更改当前时间项目完成进度
    public static void UpdateProjectScheduleByActivityPlanSchedule(string strProjectID)
    {
        string strHQL;
        int intVerID;
        string strProjectType, strImpact, strSchedule;
        DataSet ds1, ds2;

        intVerID = GetProjectPlanVersionVerID(strProjectID, "InUse");

        if (intVerID > 0)
        {
            strHQL = string.Format(@"Select Percent_Done From T_ImplePlan Where ProjectID = {0} and VerID = {1} and Parent_ID = 0", strProjectID, intVerID);
            ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");

            if (ds1.Tables[0].Rows.Count > 0)
            {
                strSchedule = ds1.Tables[0].Rows[0][0].ToString().Trim();

                Project project = ShareClass.GetProject(strProjectID);
                strProjectType = project.ProjectType.Trim();

                strHQL = string.Format(@"Select ProgressByDetailImpact From T_Project Where ProjectID = {0}", strProjectID);
                ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectType");
                if (ds2.Tables[0].Rows.Count > 0)
                {
                    strImpact = ds2.Tables[0].Rows[0][0].ToString().Trim();

                    if (strImpact == "YES")
                    {
                        try
                        {
                            strHQL = string.Format(@"Update T_Project Set FinishPercent = {0} Where ProjectID = {1}", strSchedule, strProjectID);
                            ShareClass.RunSqlCommand(strHQL);
                        }
                        catch (Exception err)
                        {
                            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                        }
                    }
                }
            }
        }

    }

    //计算项目进度
    public static void FinishPercentPicture(DataGrid dataGrid, int intCellNumber)
    {
        string strProjectID;
        int intWidthCurrent, intWidthBase;
        int i;

        try
        {

            for (i = 0; i < dataGrid.Items.Count; i++)
            {
                strProjectID = dataGrid.Items[i].Cells[intCellNumber].Text.Trim();

                intWidthCurrent = int.Parse((((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_FinishPercent")).Text));

                if (intWidthCurrent > 30)
                {
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_FinishPercent")).Width = (Unit)intWidthCurrent;
                }
                else
                {
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_FinishPercent")).Width = (Unit)(intWidthCurrent + 30);
                }

                ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_FinishPercent")).Text = "  " + intWidthCurrent.ToString() + "%";

                intWidthBase = ShareClass.GetProjectDefaultFinishPercent(strProjectID);
                ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DefaultPercent")).Width = (Unit)(intWidthBase);

                if (decimal.Parse(((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DefaultPercent")).Width.ToString().Replace("px", "")) > 100)
                {
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DefaultPercent")).Width = (Unit)100;
                }

                ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DefaultPercent")).ToolTip = LanguageHandle.GetWord("XianZhuang") + ":" + intWidthCurrent.ToString() + "%" + "--" + LanguageHandle.GetWord("JiZhun") + ":" + intWidthBase.ToString() + "%";

                ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DefaultPercent")).Width = (Unit)100;
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + HttpContext.Current.Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //计算项目费用与预算进度
    public static void FinChargePercentByRow(DataGrid dataGrid, int intCellNumber)
    {
        string strProjectID;
        decimal deBudget, deRealCharge;
        decimal deChargePercent;
        int i;
        string strHQL;
        IList lst;

        try
        {
            ProjectBLL projectBLL = new ProjectBLL();
            Project project = new Project();

            ProRealChargeBLL proRealChargeBLL = new ProRealChargeBLL();
            ProRealCharge proRealCharge = new ProRealCharge();

            for (i = 0; i < dataGrid.Items.Count; i++)
            {
                strProjectID = dataGrid.Items[i].Cells[intCellNumber].Text.Trim();

                strHQL = "from Project as project where project.ProjectID = " + strProjectID;
                lst = projectBLL.GetAllProjects(strHQL);
                project = (Project)lst[0];

                deBudget = project.Budget;

                //实际费用和预算对比
                strHQL = "from ProRealCharge as proRealCharge where proRealCharge.ProjectID = " + strProjectID;
                lst = proRealChargeBLL.GetAllProRealCharges(strHQL);
                if (lst.Count == 0)
                {
                    deRealCharge = 0;
                    deChargePercent = 0;
                }
                else
                {
                    proRealCharge = (ProRealCharge)lst[0];
                    deRealCharge = proRealCharge.RealCharge;

                    if (deBudget == 0)
                    {
                        deChargePercent = deRealCharge;
                    }
                    else
                    {
                        deChargePercent = (deRealCharge / deBudget) * 100;
                    }
                }

                // 设置进度条宽度 - 直接使用实际百分比
                System.Web.UI.HtmlControls.HtmlGenericControl progressContainer =
                    (System.Web.UI.HtmlControls.HtmlGenericControl)dataGrid.Items[i].FindControl("ProgressContainer");

                // 直接使用实际费用百分比，限制在0-100%之间
                decimal widthPercent = deChargePercent;
                if (widthPercent < 0) widthPercent = 0;
                if (widthPercent > 100) widthPercent = 100;

                // 设置进度条宽度
                if (widthPercent > 0)
                {
                    progressContainer.Style["width"] = widthPercent + "%";
                    progressContainer.Style["display"] = "block";
                }
                else
                {
                    progressContainer.Style["width"] = "0%";
                    progressContainer.Style["display"] = "none";
                }

                // 设置原有Label的文字和样式 - 保持原有逻辑
                Label lbRealCharge = (Label)dataGrid.Items[i].FindControl("LB_RealChargePercent");
                Label lbBudget = (Label)dataGrid.Items[i].FindControl("LB_BudgetPercent");
                lbBudget.Width = (Unit)100;

                // 保持原有的文字设置逻辑
                decimal displayPercent = deChargePercent;
                if (deChargePercent > 100)
                {
                    displayPercent = 100;
                }

                if (deBudget == 0)
                {
                    lbRealCharge.Text = "0%";
                    progressContainer.Style["width"] = "0%";
                    progressContainer.Style["display"] = "block";
                }
                else
                {
                    lbRealCharge.Text = int.Parse(displayPercent.ToString("#0")) + "%";
                }


                lbBudget.ToolTip = LanguageHandle.GetWord("Expense") + ":" + deRealCharge.ToString("#0.00") + "--" + LanguageHandle.GetWord("Budget") + ":" + deBudget.ToString("#0.00");

                // 设置超预算的颜色
                if (deRealCharge > deBudget)
                {
                    if (deBudget == 0)
                    {
                        progressContainer.Style["background-color"] = "yellowgreen";
                        lbRealCharge.BackColor = Color.Transparent;
                        lbBudget.BackColor = Color.Transparent;
                        lbRealCharge.ForeColor = Color.Black;
                        lbBudget.ForeColor = Color.Black;
                    }
                    else
                    {
                        progressContainer.Style["background-color"] = "red";
                        lbRealCharge.BackColor = Color.Transparent;
                        lbBudget.BackColor = Color.Transparent;
                        lbRealCharge.ForeColor = Color.Black;
                        lbBudget.ForeColor = Color.Black;
                    }
                }
                else
                {
                    progressContainer.Style["background-color"] = "yellowgreen";
                    lbRealCharge.BackColor = Color.Transparent;
                    lbBudget.BackColor = Color.Transparent;
                    lbRealCharge.ForeColor = Color.Black;
                    lbBudget.ForeColor = Color.Black;
                }
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + HttpContext.Current.Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //设置项目时间和超期天数
    public static void SetProjectStartAndEndTime(DataGrid dataGrid, int intCellNumber)
    {
        int i;
        DateTime dtNowDate, dtBeginDate, dtEndDate;
        string strProjectID, strProjectStatus, strProjectStatusValue;

        for (i = 0; i < dataGrid.Items.Count; i++)
        {
            strProjectID = dataGrid.Items[i].Cells[intCellNumber].Text.Trim();

            Project Project = ShareClass.GetProject(strProjectID);

            strProjectStatus = Project.Status.Trim();
            strProjectStatusValue = Project.StatusValue.Trim();

            dtBeginDate = Project.BeginDate;
            dtEndDate = Project.EndDate;
            dtNowDate = DateTime.Now;

            TimeSpan sp = dtNowDate.Subtract(dtEndDate);
            int intDays = sp.Days;

            ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_BeginDate")).Text = dtBeginDate.ToString("yyyy-MM-dd");
            ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_EndDate")).Text = dtEndDate.ToString("yyyy-MM-dd");

            if (intDays > 0)
            {
                if (strProjectStatus == "CaseClosed" | strProjectStatus == "Cancel")
                {
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).Text = LanguageHandle.GetWord("ChaoQi").ToString().Trim();
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DelayDays")).Text = "0";
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).BackColor = Color.White;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).ForeColor = Color.Green;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DelayDays")).ForeColor = Color.Green;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DayUnit")).ForeColor = Color.Green;
                }
                else
                {
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).Text = LanguageHandle.GetWord("ChaoQi").ToString().Trim();
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DelayDays")).Text = intDays.ToString();
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_BeginDate")).BackColor = Color.Red;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_EndDate")).BackColor = Color.Red;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_BeginDate")).ForeColor = Color.Yellow;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_EndDate")).ForeColor = Color.Yellow;
                }
            }
            else
            {
                if (strProjectStatus == "CaseClosed" | strProjectStatus == "Cancel")
                {
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).Text = LanguageHandle.GetWord("ShengYu").ToString().Trim();
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DelayDays")).Text = "0";
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).BackColor = Color.White;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).ForeColor = Color.Green;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DelayDays")).ForeColor = Color.Green;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DayUnit")).ForeColor = Color.Green;
                }
                else
                {
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).Text = LanguageHandle.GetWord("ShengYu").ToString().Trim();
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DelayDays")).Text = (0 - intDays).ToString();
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).BackColor = Color.White;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_MoreTime")).ForeColor = Color.Green;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DelayDays")).ForeColor = Color.Green;
                    ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DayUnit")).ForeColor = Color.Green;
                }
            }
        }
    }

    //替换HTML标记
    public static string NoHTML(string Htmlstring)
    {
        //删除脚本
        Htmlstring = Regex.Replace(Htmlstring, @"<script[^>]*?>.*?</script>", "", RegexOptions.IgnoreCase);

        //删除HTML
        Htmlstring = Regex.Replace(Htmlstring, @"<(.[^>]*)>", "", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"([\r\n])[\s]+", "", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"-->", "", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"<!--.*", "", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(quot|#34);", "\"", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(amp|#38);", "&", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(lt|#60);", "<", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(gt|#62);", ">", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(nbsp|#160);", " ", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(iexcl|#161);", "\xa1", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(cent|#162);", "\xa2", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(pound|#163);", "\xa3", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&(copy|#169);", "\xa9", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"&#(\d+);", "", RegexOptions.IgnoreCase);
        Htmlstring = Regex.Replace(Htmlstring, @"<img[^>]*>;", "", RegexOptions.IgnoreCase);
        Htmlstring.Replace("<", "");
        Htmlstring.Replace(">", "");
        Htmlstring.Replace("\r\n", "");
        Htmlstring = HttpContext.Current.Server.HtmlEncode(Htmlstring).Trim();
        return Htmlstring;
    }

    //得到项目日志长度(超过上限值设为上限值）
    public static int GetDailyWorkLogLength(string strWorkLog)
    {
        int intLength, intCharUpper;

        intCharUpper = GetCharUpper();

        intLength = NoHTML(strWorkLog).Length;

        if (intLength > intCharUpper)
        {
            intLength = intCharUpper;
        }

        return intLength;
    }

    //得到用户每日上传的项目文档数(超过上限值设为上限值）
    public static int GetDailyUploadDocNumber(string strUserCode, string strProjectID)
    {
        string strHQL;
        IList lst;
        int intCount = 0, intDocUpper = 0;

        string strCurrentDate = DateTime.Now.ToString("yyyyMMdd");
        string strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = "from Document as document where (((document.RelatedType = 'Project' and document.RelatedID = " + strProjectID + ")";
        strHQL += " and ((document.UploadManCode = " + "'" + strUserCode + "'" + " and document.DepartCode = " + "'" + strDepartCode + "'" + ")";
        strHQL += " or (document.Visible in ( 'Department','Entire'))))";
        strHQL += " or (((document.RelatedType = 'Requirement' and document.RelatedID in (select relatedDefect.DefectID from RelatedDefect as relatedDefect where relatedDefect.ProjectID = " + strProjectID + "))";
        strHQL += " or (document.RelatedType = '风险' and document.RelatedID in (select projectRisk.ID from ProjectRisk as projectRisk where projectRisk.ProjectID = " + strProjectID + "))";
        strHQL += " or (document.RelatedType = 'Task' and document.RelatedID in (select projectTask.TaskID from ProjectTask as projectTask where projectTask.ProjectID = " + strProjectID + "))";
        strHQL += " or (document.RelatedType = 'Plan' and document.RelatedID in (select workPlan.ID from WorkPlan as workPlan where workPlan.ProjectID = " + strProjectID + "))";
        strHQL += " or (document.RelatedType = '会议' and document.RelatedID in (select meeting.ID from Meeting as meeting where meeting.RelatedType='Project' and  meeting.RelatedID = " + strProjectID + "))";
        strHQL += " and ((document.Visible in ('会议','Department') and document.DepartCode = " + "'" + strDepartCode + "'" + " ) ";
        strHQL += " or (document.Visible = 'Entire' )))))";
        strHQL += " and to_char(document.UploadTime,'yyyymmdd') = " + "'" + strCurrentDate + "'";
        strHQL += " and rtrim(ltrim(document.Status)) <> 'Deleted' Order by document.DocID DESC";

        DocumentBLL documentBLL = new DocumentBLL();
        lst = documentBLL.GetAllDocuments(strHQL);

        intCount = lst.Count;

        intDocUpper = GetDocUpper();

        if (intCount > intDocUpper)
        {
            intCount = intDocUpper;
        }

        return intCount;
    }

    public static Decimal GetEveryCharPrice()
    {
        string strHQL;
        IList lst;
        decimal decWorkUnitBonus = 0;

        strHQL = "from DailyWorkUnitBonus as dailyWorkUnitBonus Order By dailyWorkUnitBonus.ID DESC";
        DailyWorkUnitBonusBLL dailyWorkUnitBonusBLL = new DailyWorkUnitBonusBLL();
        lst = dailyWorkUnitBonusBLL.GetAllDailyWorkUnitBonuss(strHQL);

        if (lst.Count > 0)
        {
            DailyWorkUnitBonus dailyWorkUnitBonus = (DailyWorkUnitBonus)lst[0];
            decWorkUnitBonus = dailyWorkUnitBonus.EveryCharPrice;
        }
        else
        {
            decWorkUnitBonus = 0;
        }

        return decWorkUnitBonus;
    }

    public static int GetCharUpper()
    {
        string strHQL;
        IList lst;
        int intCharUpper = 0;

        strHQL = "from DailyWorkUnitBonus as dailyWorkUnitBonus Order By dailyWorkUnitBonus.ID DESC";
        DailyWorkUnitBonusBLL dailyWorkUnitBonusBLL = new DailyWorkUnitBonusBLL();
        lst = dailyWorkUnitBonusBLL.GetAllDailyWorkUnitBonuss(strHQL);

        if (lst.Count > 0)
        {
            DailyWorkUnitBonus dailyWorkUnitBonus = (DailyWorkUnitBonus)lst[0];
            intCharUpper = dailyWorkUnitBonus.CharUpper;
        }
        else
        {
            intCharUpper = 0;
        }

        return intCharUpper;
    }

    public static Decimal GetEveryDocPrice()
    {
        string strHQL;
        IList lst;
        decimal decEverDocPrice = 0;

        strHQL = "from DailyWorkUnitBonus as dailyWorkUnitBonus Order By dailyWorkUnitBonus.ID DESC";
        DailyWorkUnitBonusBLL dailyWorkUnitBonusBLL = new DailyWorkUnitBonusBLL();
        lst = dailyWorkUnitBonusBLL.GetAllDailyWorkUnitBonuss(strHQL);

        if (lst.Count > 0)
        {
            DailyWorkUnitBonus dailyWorkUnitBonus = (DailyWorkUnitBonus)lst[0];
            decEverDocPrice = dailyWorkUnitBonus.EveryDocPrice;
        }
        else
        {
            decEverDocPrice = 0;
        }

        return decEverDocPrice;
    }

    public static int GetDocUpper()
    {
        string strHQL;
        IList lst;
        int intDocUpper = 0;

        strHQL = "from DailyWorkUnitBonus as dailyWorkUnitBonus Order By dailyWorkUnitBonus.ID DESC";
        DailyWorkUnitBonusBLL dailyWorkUnitBonusBLL = new DailyWorkUnitBonusBLL();
        lst = dailyWorkUnitBonusBLL.GetAllDailyWorkUnitBonuss(strHQL);

        if (lst.Count > 0)
        {
            DailyWorkUnitBonus dailyWorkUnitBonus = (DailyWorkUnitBonus)lst[0];
            intDocUpper = dailyWorkUnitBonus.DocUpper;
        }
        else
        {
            intDocUpper = 0;
        }

        return intDocUpper;
    }

    //取得项目类型名称
    public static string GetDocTypeName(string strDocTypeID)
    {
        DocTypeBLL docTypeBLL = new DocTypeBLL();

        string strHQL = "from DocType as docType where docType.ID = " + strDocTypeID;
        IList lst = docTypeBLL.GetAllDocTypes(strHQL);

        DocType docType = (DocType)lst[0];

        return docType.Type.Trim();
    }

    #endregion 项目费用计算

}
