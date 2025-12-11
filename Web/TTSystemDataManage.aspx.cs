using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Resources;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;

public partial class TTSystemDataManage : System.Web.UI.Page
{
    string strUserCode, strUserName, strLangCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strUserName = ShareClass.GetUserName(strUserCode);
        strLangCode = Session["LangCode"].ToString();

        Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", strUserCode);  //Label1.Text = ShareClass.GetPageTitle(this.GetType().BaseType.Name + ".aspx"); bool blVisible = TakeTopSecurity.TakeTopLicense.GetAuthobility(this.GetType().BaseType.Name + ".aspx", "系统数据管理", strUserCode);
        if (blVisible == false)
        {
            Response.Redirect("TTDisplayErrors.aspx");
            return;
        }

        //this.Title = "系统数据管理---" + System.Configuration.ConfigurationManager.AppSettings["SystemName"];

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clickA", "aHandler();", true);
        if (Page.IsPostBack == false)
        {
            DLC_EventStart.Text = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
            DLC_PlanStart.Text = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");
            DLC_WorkflowStart.Text = DateTime.Now.AddMonths(-12).ToString("yyyy-MM-dd");
            DLC_CollaborationStart.Text = DateTime.Now.AddMonths(-3).ToString("yyyy-MM-dd");


            TXT_DataName.Text = ShareClass.GetSystemDBName();
            BindBackDBPrame();

            BindBackDocPrame();

            BindBackDBReadOnlyUserInformation();

            HL_ErrorLog.NavigateUrl = "Doc\\Log\\LogFile.txt";

            //取得前次备份数据时间
            LB_LastestBackupDBTime.Text = ShareClass.GetAllreadyBackupDBLastestTime();
            LB_LastestBackupDocTime.Text = ShareClass.GetAllreadyBackupDocLastestTime();


            ShareClass.LoadLanguageForDropList(ddlLangSwitcher);
            ddlLangSwitcher.SelectedValue = strLangCode;
        }
    }


    protected void BT_ExportLoginLog_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                Random a = new Random();
                string fileName = LanguageHandle.GetWord("YongHuDengLuRiZhi") + DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss") + "-" + a.Next(100, 999) + ".xls";

                CreateExcel(fileName);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGDCDSJYWJC") + "')", true);
            }
        }
    }

    private void CreateExcel(string fileName)
    {
        string strHQL;

        strHQL = string.Format(@"Select ID ""{0}"", UserCode ""{1}"",UserName ""{2}"",UserIP ""{3}"",UserHostName ""{4}"",LoginTime ""{5}"",LastestTime ""{6}"", Position ""{7}"" From T_LogonLog",
              LanguageHandle.GetWord("BianHao"),
              LanguageHandle.GetWord("DaiMa"),
              LanguageHandle.GetWord("XingMing"),
              LanguageHandle.GetWord("IP"),
              LanguageHandle.GetWord("DianNaoMingCheng"),
              LanguageHandle.GetWord("DengLuShiJian"),
              LanguageHandle.GetWord("ZuiHouCaoZuoShiJian"),
              LanguageHandle.GetWord("WeiZhi"));

        strHQL += " Order by ID DESC";

        MSExcelHandler.DataTableToExcel(strHQL, fileName);
    }

    protected void BT_ClearLogoLog_Click(object sender, EventArgs e)
    {
        string strHQL;

        strHQL = "TrunCate Table T_LogonLog";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZYKRZB") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBJC") + "')", true);
        }
    }

    protected void BT_ClearSMSSent_Click(object sender, EventArgs e)
    {
        string strHQL;

        strHQL = "TrunCate Table Sms_Send";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZYKXXFSB") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBJC") + "')", true);
        }
    }

    protected void BT_ClearLeftBar_Click(object sender, EventArgs e)
    {
        try
        {
            //给相关页面文件添加空行以刷新页面缓存
            ShareClass.AddSpaceLineToFile("TakeTopLRExLeft.aspx", "");
            ShareClass.AddSpaceLineToFile("TakeTopCSLRLeft.aspx", "");

            ////完成更新之后，此存储过程将报告已为所有的表更新了统计信息
            //ShareClass.RunSqlCommand("exec sp_updatestats");

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZQingChuWanCheng") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZQingChuShiBaiQJC") + "')", true);
        }
    }

    protected void BT_ClearSystemCache_Click(object sender, EventArgs e)
    {
        try
        {
            //给相关页面文件添加空行以刷新页面缓存
            ShareClass.AddSpaceLineToFileForRefreshCache();

            ////完成更新之后，此存储过程将报告已为所有的表更新了统计信息
            //ShareClass.RunSqlCommand("exec sp_updatestats");

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZQingChuWanCheng") + "')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZQingChuShiBaiQJC") + "')", true);
        }
    }

    //数据库数据保存为文本的示例代码
    public static void CreateRTXAccountDataToTXT(string strFileName)
    {
        string strPath = strFileName;
        string strSql = "Select RTXCode,UserName,DepartNameString,RTXNumber,EMail,MBPhoneNumber From T_RTXAccountData Order By ID ASC";


        //FileStream fsobj = new FileStream(path, FileMode.OpenOrCreate);
        StreamWriter sw = new StreamWriter(strPath, true, System.Text.Encoding.GetEncoding("GB2312"));


        sw.Write(LanguageHandle.GetWord("YongHuMing") + "\t" + LanguageHandle.GetWord("XingMing") + "\t" + LanguageHandle.GetWord("BuMenMingChen") + "\t" + LanguageHandle.GetWord("RTXFenJiHao") + "\t" + LanguageHandle.GetWord("DianZiYouXiang") + "\t" + LanguageHandle.GetWord("ShouJiHao") + "\r\n");

        DataSet ds = ShareClass.GetDataSetFromSql(strSql, "T_RTXAccountData");
        DataTable dt = ds.Tables[0];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i < dt.Rows.Count - 1)
            {
                sw.Write(dt.Rows[i]["RTXCode"].ToString().Trim() + "\t" + dt.Rows[i]["UserName"].ToString().Trim() + "\t" + dt.Rows[i]["DepartNameString"].ToString().Trim() + "\t" + dt.Rows[i]["RTXNumber"].ToString().Trim() + "\t" + dt.Rows[i]["EMail"].ToString().Trim() + "\t" + dt.Rows[i]["MBPhoneNumber"].ToString().Trim() + "\r\n");
            }
            else
            {
                sw.Write(dt.Rows[i]["RTXCode"].ToString().Trim() + "\t" + dt.Rows[i]["UserName"].ToString().Trim() + "\t" + dt.Rows[i]["DepartNameString"].ToString().Trim() + "\t" + dt.Rows[i]["RTXNumber"].ToString().Trim() + "\t" + dt.Rows[i]["EMail"].ToString().Trim() + "\t" + dt.Rows[i]["MBPhoneNumber"].ToString().Trim());
            }
        }
        sw.Close();
    }

    protected void BT_BackupSchedule_Click(object sender, EventArgs e)
    {
        string strHQL;
        TimeSpan ts;

        string strScheduleStart = DLC_EventStart.Text;
        ts = DateTime.Now - DateTime.Parse(strScheduleStart);

        if (ts.Days >= 90)
        {
            try
            {
                strHQL = "Insert Into T_ScheduleEventBackup Select * From T_ScheduleEvent";
                strHQL += " Where to_char( EventStart, 'yyyymmdd') <= '" + DateTime.Parse(strScheduleStart).ToString("yyyyMMdd") + "'";
                strHQL += " and ID not in (Select ID From T_ScheduleEventBackup)";
                strHQL += " Order By ID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_ScheduleEvent_LeaderReviewBackup Select * From T_ScheduleEvent_LeaderReview";
                strHQL += " Where ScheduleID in (Select ID From T_ScheduleEvent";
                strHQL += " Where to_char( EventStart, 'yyyymmdd') <= '" + DateTime.Parse(strScheduleStart).ToString("yyyyMMdd") + "')";
                strHQL += " and ReviewID Not In (Select ReviewID From T_ScheduleEvent_LeaderReviewBackup)";
                strHQL += " Order By ReviewID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_ScheduleEvent";
                strHQL += " Where ID in (Select ID From T_ScheduleEventBackup)";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_ScheduleEvent_LeaderReview";
                strHQL += " Where ReviewID In (Select ReviewID From T_ScheduleEvent_LeaderReviewBackup)";

                ShareClass.RunSqlCommand(strHQL);

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZShuJiZhuanYuChenGong") + "')", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message.ToString() + "')", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBZNZYSGYZQDSJQJC") + "')", true);
        }
    }

    protected void BT_BackupPlan_Click(object sender, EventArgs e)
    {
        string strHQL;
        TimeSpan ts;

        string strPlanStart = DLC_PlanStart.Text;

        ts = DateTime.Now - DateTime.Parse(strPlanStart);

        if (ts.Days >= 90)
        {
            try
            {
                strHQL = "Insert Into T_PlanBackup Select * From T_Plan";
                strHQL += " Where to_char( StartTime, 'yyyymmdd') <= '" + DateTime.Parse(strPlanStart).ToString("yyyyMMdd") + "'";
                strHQL += " and PlanID Not In (Select PlanID From T_PlanBackup)";
                strHQL += " Order By PlanID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_Plan_LeaderReviewBackup Select * From T_Plan_LeaderReview";
                strHQL += " Where PlanID in (Select PlanID From T_Plan";
                strHQL += " Where to_char( StartTime, 'yyyymmdd') <= '" + DateTime.Parse(strPlanStart).ToString("yyyyMMdd") + "')";
                strHQL += " and ID Not In (Select ID From T_Plan_LeaderReviewBackup)";
                strHQL += " Order By ID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_Plan_WorkLogBackup Select * From T_Plan_WorkLog";
                strHQL += " Where PlanID in (Select PlanID From T_Plan";
                strHQL += " Where to_char( StartTime, 'yyyymmdd') <= '" + DateTime.Parse(strPlanStart).ToString("yyyyMMdd") + "')";
                strHQL += " Order By ID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_Plan";
                strHQL += " Where PlanID In (Select PlanID From T_PlanBackup)";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_Plan_LeaderReview";
                strHQL += " Where ID In (Select ID From T_Plan_LeaderReviewBackup)";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_Plan_WorkLog";
                strHQL += " Where ID In (Select ID From T_Plan_WorkLogBackup)";
                ShareClass.RunSqlCommand(strHQL);

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZShuJiZhuanYuChenGong") + "')", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message.ToString() + "')", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBZNZYSGYZQDSJQJC") + "')", true);
        }
    }

    protected void BT_BackupCollaboration_Click(object sender, EventArgs e)
    {
        string strHQL;
        TimeSpan ts;

        string strCollaborationStart = DLC_CollaborationStart.Text;

        ts = DateTime.Now - DateTime.Parse(strCollaborationStart);

        if (ts.Days >= 90)
        {
            try
            {
                strHQL = "Insert Into T_CollaborationBackup Select * From T_Collaboration";
                strHQL += " Where to_char( CreateTime, 'yyyymmdd') <= '" + DateTime.Parse(strCollaborationStart).ToString("yyyyMMdd") + "'";
                strHQL += " and CoID Not In (Select CoID From T_CollaborationBackup)";
                strHQL += " Order By CoID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_CollaborationLogBackup Select * From T_CollaborationLog";
                strHQL += " Where LogID Not In (Select LogID From T_CollaborationLogBackup) ";
                strHQL += " and CoID In (Select CoID From T_Collaboration Where to_char( CreateTime, 'yyyymmdd') <= '" + DateTime.Parse(strCollaborationStart).ToString("yyyyMMdd") + "')";
                strHQL += " Order By LogID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_CollaborationMemberBackup Select * From T_CollaborationMember";
                strHQL += " Where MemID Not In (Select MemID From T_CollaborationMemberBackup )";
                strHQL += " and CoID In (Select CoID From T_Collaboration Where to_char( CreateTime, 'yyyymmdd') <= '" + DateTime.Parse(strCollaborationStart).ToString("yyyyMMdd") + "')";
                strHQL += " Order By MemID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_Collaboration";
                strHQL += " Where CoID In (Select CoID From T_CollaborationBackup)";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_CollaborationLog";
                strHQL += " Where LogID in (Select LogID From T_CollaborationLogBackup)";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_CollaborationMember";
                strHQL += " Where MemID in (Select MemID From T_CollaborationMemberBackup)";
                ShareClass.RunSqlCommand(strHQL);

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZShuJiZhuanYuChenGong") + "')", true);
            }
            catch (Exception ex)
            {
                //LogClass.WriteLogFile(this.GetType().BaseType.Name + ":" + LanguageHandle.GetWord("ZZJGDRSBJC") + " : " + LanguageHandle.GetWord("HangHao") + ": " + (lineNumber + 2).ToString() + " , " + LanguageHandle.GetWord("DaiMa") + ": " + strObjectCode + " : " + err.Message.ToString());
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message.ToString() + "')", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBZNZYSGYZQDSJQJC") + "')", true);
        }
    }

    protected void BT_BackupWorkflow_Click(object sender, EventArgs e)
    {
        string strHQL = "";
        TimeSpan ts;

        string strWorkflowStart = DLC_WorkflowStart.Text;

        ts = DateTime.Now - DateTime.Parse(strWorkflowStart);

        if (ts.Days >= 365)
        {
            try
            {
                strHQL = @"Insert Into T_WorkFlowBackup Select WLID
                              ,WLName
                              ,WLType
                              ,RelatedType
                              ,RelatedID
                              ,XMLFile
                              ,XSNFile
                              ,TemName
                              ,CreatorCode
                              ,CreatorName
                              ,CreateTime
                              ,Description
                              ,ReceiveSMS
                              ,ReceiveEMail
                              ,Status
                              ,DIYNextStep
                              ,WFXMLData
                              ,FieldList
                              ,EditFieldList
                              ,RelatedCode
                              ,CanNotNullFieldList
                              ,MainTableID
                              ,IsPlanMainWorkflow
                              ,Expense
                              ,ManHour
                              ,BusinessType
                              ,BusinessCode
                            From T_WorkFlow";
                strHQL += " Where to_char(CreateTime,'yyyymmdd') <= '" + DateTime.Parse(strWorkflowStart).ToString("yyyyMMdd") + "'";
                strHQL += " and WLID Not In (Select WLID From T_WorkflowBackup)";
                strHQL += " Order By WLID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_WorkFlowStepBackup Select * From T_WorkFlowStep";
                strHQL += " Where WLID In (Select WLID From T_WorkFlowBackup)";
                strHQL += " and StepID Not In (Select StepID From T_WorkflowStepBackup )";
                strHQL += " Order By StepID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_WorkFlowStepDetailBackup Select * From T_WorkFlowStepDetail";
                strHQL += " Where WLID In (Select WLID From T_WorkFlowBackup)";
                strHQL += " and ID Not In (Select ID From T_WorkflowStepDetailBackup)";
                strHQL += " Order By ID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_WorkFlowStepOperationBackup Select * From T_WorkFlowStepOperation";
                strHQL += " Where StepID in (Select StepID From T_WorkFlowStepBackup)";
                strHQL += " and OperationID Not In (Select OperationID From T_WorkFlowStepOperationBackup)";
                strHQL += " Order By OperationID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_WorkFlowStepBusinessMemberBackup Select * From T_WorkFlowStepBusinessMember";
                strHQL += " Where StepID in (Select StepID From T_WorkFlowStepBackup)";
                strHQL += " and ID Not In (Select ID From T_WorkFlowStepBusinessMemberBackup)";
                strHQL += " Order By ID ASC";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Insert Into T_ApproveFlowBackup Select * From T_ApproveFlow ";
                strHQL += " Where Type = 'Workflow'";
                strHQL += " and RelatedID In (Select WLID From T_WorkFlowBackup)";
                strHQL += " and ID Not In (Select ID From T_ApproveFlowBackup)";
                strHQL += " Order By ID ASC";
                ShareClass.RunSqlCommand(strHQL);

                try
                {
                    //删除已转移的记录
                    strHQL = "Delete From T_WorkFlow Where WLID in (Select WLID From T_WorkFlowBackup)";
                    ShareClass.RunSqlCommand(strHQL);

                    strHQL = "Delete From T_WorkFlowStep";
                    strHQL += " Where StepID In (Select StepID From T_WorkflowStepBackup)";
                    ShareClass.RunSqlCommand(strHQL);

                    strHQL = "Delete From T_WorkFlowStepDetail";
                    strHQL += " Where ID In (Select ID From T_WorkflowStepDetailBackup)";
                    ShareClass.RunSqlCommand(strHQL);

                    strHQL = "Delete From T_WorkFlowStepOperation";
                    strHQL += " Where OperationID In (Select OperationID From T_WorkFlowStepOperationBackup)";
                    ShareClass.RunSqlCommand(strHQL);

                    strHQL = "Delete From T_WorkFlowStepBusinessMember";
                    strHQL += " Where ID In (Select ID From T_WorkFlowStepBusinessMemberBackup)";
                    ShareClass.RunSqlCommand(strHQL);

                    strHQL = "Delete From T_ApproveFlow ";
                    strHQL += " Where Type = 'Workflow'";
                    strHQL += " and ID In (Select ID From T_ApproveFlowBackup)";
                    ShareClass.RunSqlCommand(strHQL);
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                    Label1.Text = strHQL;
                }

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZShuJiZhuanYuChenGong") + "')", true);
            }
            catch (Exception ex)
            {
                //LogClass.WriteLogFile(this.GetType().BaseType.Name + ":" + LanguageHandle.GetWord("ZZJGDRSBJC") + " : " + LanguageHandle.GetWord("HangHao") + ": " + (lineNumber + 2).ToString() + " , " + LanguageHandle.GetWord("DaiMa") + ": " + strObjectCode + " : " + err.Message.ToString());
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + ex.Message.ToString() + "')", true);
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSBZNZYSEGYZQDSJQJC") + "')", true);
        }
    }

    //导入自定义表单工作流数据到数据库
    protected void BT_ImportDIYWFXMLData_Click(object sender, EventArgs e)
    {
        string strHQL;
        string strWLID, strXMLFile, strTemName;

        int intRowCount;

        try
        {
            strHQL = "Truncate Table T_WorkFlowFormData";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
        }

        strHQL = "Select WLID,XMLFile,TemName From T_WorkFlowBackup Where COALESCE(XSNFile,'0') <> '0' AND ltrim(rtrim(XSNFile)) <> ''";
        strHQL += " Union ";
        strHQL += "Select WLID,XMLFile,TemName From T_WorkFlow Where COALESCE(XSNFile,'0') <> '0' AND ltrim(rtrim(XSNFile)) <> ''";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");

        intRowCount = ds.Tables[0].Rows.Count;

        for (int i = 0; i < intRowCount; i++)
        {
            strWLID = ds.Tables[0].Rows[i]["WLID"].ToString().Trim();
            strXMLFile = ds.Tables[0].Rows[i]["XMLFile"].ToString().Trim();
            strTemName = ds.Tables[0].Rows[i]["TemName"].ToString().Trim();

            if (File.Exists(Server.MapPath(strXMLFile)))
            {
                try
                {
                    //把流程XML数据保存在WFXMLData列 
                    ShareClass.UpdateWFXMLData(Server.MapPath(strXMLFile), strWLID);
                }
                catch
                {
                }

                try
                {
                    //把流程XML数据保存在流程数据分析表 
                    XmlDbWorker.AddFormFromXml(Server.MapPath(strXMLFile), int.Parse(strWLID), strTemName);
                }
                catch
                {
                }
            }
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZDRWC") + "')", true);
    }

    protected void BT_CopyData_Click(object sender, EventArgs e)
    {
        string strDBName, strBackupDBName, strBackupDBSavePath, strDirectory, strBackupDirectory, strBackupDirectorySavePath;
        string strBackupPeriodDay;
        int intResult;

        try
        {
            strBackupPeriodDay = int.Parse(NB_BackDBPeriodDay.Amount.ToString()).ToString();
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click111", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGBFJGTSBXWSZJC") + "')", true);
            return;
        }

        if (strBackupPeriodDay == "0" | int.Parse(strBackupPeriodDay) < 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click222", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGBFJGTSBXDYLWZSJC") + "')", true);
            return;
        }


        strDirectory = TXT_BackDBUrl.Text.Trim();
        strBackupDirectory = DateTime.Now.ToString("yyyyMMdd");
        strBackupDirectorySavePath = strDirectory + "\\" + strBackupDirectory;

        strDBName = TXT_DataName.Text.Trim();
        strBackupDBName = strDBName + DateTime.Now.ToString("yyyyMMddHHMMssff") + ".bak";
        strBackupDBSavePath = strBackupDirectorySavePath + "\\" + strBackupDBName;

        if (strBackupDirectorySavePath != "")
        {
            intResult = ShareClass.CreateDirectory(strBackupDirectorySavePath);
            if (intResult == 2)
            {
                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" +LanguageHandle.GetWord("ZZJingGaoBeiFenMuLuChuangJianL")+"')", true);
                return;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click333", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGBFMLBNWKJC") + "')", true);
            return;
        }

        FileInfo fi = new FileInfo(strBackupDBSavePath);

        if (!fi.Exists)
        {
            try
            {
                //先查询是否存在，如果不存在，则插入，存在，则更新
                string strSelectBackDBHQL = "select * from T_BackDBPrame";
                DataTable dtBackDB = ShareClass.GetDataSetFromSql(strSelectBackDBHQL, "strSelectBackDBHQL").Tables[0];
                if (dtBackDB != null && dtBackDB.Rows.Count > 0)
                {
                    //把路径改为最新
                    string strIsertBackDBHQL = string.Format(@"update T_BackDBPrame set BackDBUrl = '{0}',BackPeriodDay = {1}", strDirectory, strBackupPeriodDay);
                    ShareClass.RunSqlCommand(strIsertBackDBHQL);
                }
                else
                {
                    //把路径改为最新
                    string strIsertBackDBHQL = string.Format(@"insert into T_BackDBPrame(BackDBUrl,BackPeriodDay) values('{0}', {1})", strDirectory, strBackupPeriodDay);
                    ShareClass.RunSqlCommand(strIsertBackDBHQL);
                }

                //备份数据库
                ShareClass.BackupCurrentSiteDB(ShareClass.GetSystemDBName(), ShareClass.GetSystemDBBackupSaveDir(), strUserName, "SELF");

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click444", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSJKBFWC") + "')", true);
            }
            catch (Exception err)
            {
                //写日志
                LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click555", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSJKBFSBKNSJKMCYCJC") + "')", true);
            }
        }
        else
        {
            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("BFSBCZTMWJJC") + "')", true);
        }
    }

    protected void BT_CopyDirectory_Click(object sender, EventArgs e)
    {
        string strBackupDirectorySavePath, strDirectory, strBackupDirectory;
        string strBackupPeriodDay;

        try
        {
            if (ShareClass.GetBackupDBLastestTimeDifferMonth() > 1)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click099", "showAlertAtMouse('" + LanguageHandle.GetWord("CGLYWBFQBSCBFSJDSYZQDSJZYCZTBF") + "')", true);
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }

        try
        {
            strBackupPeriodDay = int.Parse(NB_BackDocPeriodDay.Amount.ToString()).ToString();
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click011", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGBFJGTSBXWSZJC") + "')", true);
            return;
        }

        if (strBackupPeriodDay == "0" | int.Parse(strBackupPeriodDay) < 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click022", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGBFJGTSBXDYLWZSJC") + "')", true);
            return;
        }

        strDirectory = TXT_BackDocUrl.Text.Trim();
        strBackupDirectory = DateTime.Now.ToString("yyyyMMdd");
        strBackupDirectorySavePath = strDirectory + "\\" + strBackupDirectory;

        try
        {
            //先查询是否存在，如果不存在，则插入，存在，则更新
            string strSelectBackDocHQL = "select * from T_BackDocPrame";
            DataTable dtBackDoc = ShareClass.GetDataSetFromSql(strSelectBackDocHQL, "strSelectBackDocHQL").Tables[0];
            if (dtBackDoc != null && dtBackDoc.Rows.Count > 0)
            {
                //把路径改为最新
                string strIsertBackDocHQL = string.Format(@"update T_BackDocPrame set BackDocUrl = '{0}',BackPeriodDay = {1}", strDirectory, strBackupPeriodDay);
                ShareClass.RunSqlCommand(strIsertBackDocHQL);
            }
            else
            {
                //把路径改为最新
                string strIsertBackDocHQL = string.Format(@"insert into T_BackDocPrame(BackDocUrl,BackPeriodDay) values('{0}', {1})", strDirectory, strBackupPeriodDay);
                ShareClass.RunSqlCommand(strIsertBackDocHQL);
            }

            ShareClass.BackupCurrentSiteDoc(strUserName);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click044", "showAlertAtMouse('" + LanguageHandle.GetWord("WenDang") + LanguageHandle.GetWord("ZZBeiFenChengGong") + "')", true);
        }
        catch (Exception err)
        {
            //写日志
            LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click066", "showAlertAtMouse('" + LanguageHandle.GetWord("WenDang") + LanguageHandle.GetWord("ZZBeiFenShiBaiQingJianCha") + ": " + err.Message.ToString() + "')", true);
        }
    }

    protected void BT_SaveDBPath_Click(object sender, EventArgs e)
    {
        string strDirectory, strBackPeriodDay;
        strDirectory = TXT_BackDBUrl.Text.Trim();
        strBackPeriodDay = NB_BackDBPeriodDay.Amount.ToString();

        //先查询是否存在，如果不存在，则插入，存在，则更新
        string strSelectBackDBHQL = "select * from T_BackDBPrame";
        DataTable dtBackDB = ShareClass.GetDataSetFromSql(strSelectBackDBHQL, "strSelectBackDBHQL").Tables[0];
        if (dtBackDB != null && dtBackDB.Rows.Count > 0)
        {
            //把路径改为最新
            string strIsertBackDBHQL = string.Format(@"update T_BackDBPrame set BackDBUrl = '{0}',BackPeriodDay= {1}", strDirectory, strBackPeriodDay);
            ShareClass.RunSqlCommand(strIsertBackDBHQL);
        }
        else
        {
            //把路径改为最新
            string strIsertBackDBHQL = string.Format(@"insert into T_BackDBPrame(BackDBUrl,BackPeriodDay) values('{0}',{1})", strDirectory, strBackPeriodDay);
            ShareClass.RunSqlCommand(strIsertBackDBHQL);
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click066", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
    }

    protected void BT_SaveDocPath_Click(object sender, EventArgs e)
    {
        string strDirectory, strBackPeriodDay;
        strDirectory = TXT_BackDocUrl.Text.Trim();
        strBackPeriodDay = NB_BackDocPeriodDay.Amount.ToString();
        //先查询是否存在，如果不存在，则插入，存在，则更新
        string strSelectBackDocHQL = "select * from T_BackDocPrame";
        DataTable dtBackDoc = ShareClass.GetDataSetFromSql(strSelectBackDocHQL, "strSelectBackDocHQL").Tables[0];
        if (dtBackDoc != null && dtBackDoc.Rows.Count > 0)
        {
            //把路径改为最新
            string strIsertBackDocHQL = string.Format(@"update T_BackDocPrame set BackDocUrl = '{0}', BackPeriodDay={1}", strDirectory, strBackPeriodDay);
            ShareClass.RunSqlCommand(strIsertBackDocHQL);
        }
        else
        {
            //把路径改为最新
            string strIsertBackDocHQL = string.Format(@"insert into T_BackDocPrame(BackDocUrl,BackPeriodDay) values('{0}',{1})", strDirectory, strBackPeriodDay);
            ShareClass.RunSqlCommand(strIsertBackDocHQL);
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click066", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
    }

    protected void BT_SaveDBUserIDPassword_Click(object sender, EventArgs e)
    {
        string strHQL;

        string strDBUserID = LB_DBUserID.Text.Trim();
        string strPassword = TB_ReadOnlyUserPassword.Text.Trim();

        if (strPassword != "")
        {
            strHQL = "truncate table t_dbreadonlyuserinfor";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = string.Format("Insert Into T_DBReadOnlyUserInfor(DBUserID,Password) values('{0}','{1}')", strDBUserID, strPassword);
            ShareClass.RunSqlCommand(strHQL);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click066", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBCCG") + "')", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click066", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZMMBNWKJC") + "')", true);
        }
    }

    protected void BT_DeleteDBUserIDPassword_Click(object sender, EventArgs e)
    {
        string strHQL;

        strHQL = "truncate table t_dbreadonlyuserinfor";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click066", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSCCG") + "')", true);

            BindBackDBReadOnlyUserInformation();
        }
        catch (Exception err)
        {
            //写日志
            LogClass.WriteLogFile("Error page: " + Request.Url.ToString() + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click066", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSCSBJC") + "')", true);
        }

    }

    private void BindBackDBPrame()
    {
        string strBackDBHQL = "select * from T_BackDBPrame";
        DataTable dtBackDB = ShareClass.GetDataSetFromSql(strBackDBHQL, "strBackDBHQL").Tables[0];

        if (dtBackDB != null && dtBackDB.Rows.Count > 0)
        {
            DataRow dr = dtBackDB.Rows[0];
            TXT_BackDBUrl.Text = dr["BackDBUrl"] == DBNull.Value ? "" : dr["BackDBUrl"].ToString();
            NB_BackDBPeriodDay.Amount = int.Parse(dr["BackPeriodDay"] == DBNull.Value ? "" : dr["BackPeriodDay"].ToString());
        }
    }

    private void BindBackDocPrame()
    {
        string strBackDocHQL = "select * from T_BackDocPrame";
        DataTable dtBackDoc = ShareClass.GetDataSetFromSql(strBackDocHQL, "strBackDocHQL").Tables[0];

        if (dtBackDoc != null && dtBackDoc.Rows.Count > 0)
        {
            DataRow dr = dtBackDoc.Rows[0];
            TXT_BackDocUrl.Text = dr["BackDocUrl"] == DBNull.Value ? "" : dr["BackDocUrl"].ToString();
            NB_BackDocPeriodDay.Amount = int.Parse(dr["BackPeriodDay"] == DBNull.Value ? "" : dr["BackPeriodDay"].ToString());
        }
    }

    private void BindBackDBReadOnlyUserInformation()
    {
        LB_DBUserID.Text = ShareClass.getDBReadOnlyUserID();
    }

    protected void BT_CopyAllModuleForHomeLanguage_Click(object sender, EventArgs e)
    {
        try
        {
            CopyAllPageModuleForHomeLanguage();
            CopyAllLeftModuleForHomeLanguage();

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZFZCG") + "')", true);
        }
        catch (System.Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZFZSBJC") + "')", true);
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click1", "displayWaitingIcon('none');", true);

        return;
    }

    protected void BT_SynchronizeModuleDataFromExcel_Click(object sender, EventArgs e)
    {
        string strToLangCode;

        try
        {
            strToLangCode = ddlLangSwitcher.SelectedValue.Trim();

            UpdateLeftBarModules(strToLangCode);
            UpdatePageBarModules(strToLangCode);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click11", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZTBMZYYSJCG") + "')", true);
        }

        catch (System.Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click22", "showAlertAtMouse('" + LanguageHandle.GetWord("SBKNWJGSBDHLCDBGQJC") + "')", true);
        }

        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click1", "displayWaitingIcon('none');", true);

        return;
    }

    protected void BT_ExportToExcelForLeftModules_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            Random a = new Random();

            // 立即清除可能残留的脚本
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "clearWaiting", "setTimeout(function(){ displayWaitingIcon('none'); }, 100);", true);

         
            try
            {

                CreateLeftBarModuleExcel("LeftModules.xls");

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGDCDSJYWJC") + "')", true);
            }


            try
            {
                CreatePageBarModuleExcel("PageModules.xls");

            }
            catch (System.Exception err)
            {
                LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGDCDSJYWJC") + "')", true);
            }


            return;

        }
    }

    protected void BT_ExportToExcelForPageModules_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            Random a = new Random();


            try
            {
                CreatePageBarModuleExcel("PageModules.xls");
            }
            catch (System.Exception err)
            {
                LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);

                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGDCDSJYWJC") + "')", true);
            }


            return;
        }
    }


    //更新左边样模组
    protected void UpdateLeftBarModules(string strToLangCode)
    {
        string strHQL1 = "";
        string strModuleName, strParentModule, strLangCode, strHomeModuleName, strPageName, strModuleType, strUserType, strVisible, strIsDeleted, strSortNUmber, strIconURL;

        DataSet ds1;
        DataTable dt1;

        dt1 = new DataTable();

        string strpath = Server.MapPath("UpdateCode\\Language\\Module\\LeftModules.xls");
        dt1 = MSExcelHandler.ReadExcelToDataTable(strpath, "");

        DataRow[] dr = dt1.Select();  //定义一个DataRow数组
        int rowsnum = dt1.Rows.Count;
        if (rowsnum == 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGEXCELBWKBWSJ") + "')", true);
        }
        else
        {
            for (int i = 0; i < dr.Length; i++)
            {
                try
                {
                    strModuleName = dr[i]["ModuleName"].ToString().Trim();
                    strParentModule = dr[i]["ParentModule"].ToString().Trim();
                    strLangCode = dr[i]["LangCode"].ToString().Trim();
                    strHomeModuleName = dr[i]["HomeModuleName"].ToString().Trim();
                    strPageName = dr[i]["PageName"].ToString().Trim();
                    strModuleType = dr[i]["ModuleType"].ToString().Trim();
                    strUserType = dr[i]["UserType"].ToString().Trim();
                    strVisible = dr[i]["Visible"].ToString().Trim();
                    strIsDeleted = dr[i]["IsDeleted"].ToString().Trim();
                    strSortNUmber = dr[i]["SortNumber"].ToString().Trim();
                    strIconURL = dr[i]["IconURL"].ToString().Trim();
                    strIconURL = strIconURL.Replace("//", "/");
                    strIconURL = strIconURL.Replace("\\", "/");

                    if (strLangCode == strToLangCode)
                    {
                        strHQL1 = "Select * From T_ProModuleLevel Where ParentModule = '" + strParentModule + "' and ModuleName = '" + strModuleName + "' and ModuleType = '" + strModuleType + "' and LangCode='" + strLangCode + "' and UserType = '" + strUserType + "'";
                        ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_ProModuleLevel");
                        if (ds1.Tables[0].Rows.Count > 0)
                        {
                            strHQL1 = "Update T_ProModuleLevel Set HomeModuleName = '" + strHomeModuleName.Replace("'", "").Replace("\"", "").Replace("\\", "") + "'" + ",IconURL = " + "'" + strIconURL + "'";
                            strHQL1 += " Where ParentModule = '" + strParentModule + "' and ModuleName = '" + strModuleName + "' and LangCode='" + strLangCode + "' and ModuleType = '" + strModuleType + "' and UserType = '" + strUserType + "'";
                         
                            ShareClass.RunSqlCommand(strHQL1);
                        }
                    }
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace + " :" + strHQL1);
                }
            }

            string strDefaultLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            strHQL1 = string.Format(@"UPDATE T_ProModuleLevel B
                        SET SortNumber = A.SortNumber
                        FROM T_ProModuleLevel A
                        WHERE A.ModuleName = B.ModuleName 
                        AND A.ModuleType = B.ModuleType 
                        AND A.UserType = B.UserType 
                        AND A.LangCode <> B.LangCode 
                        AND A.LangCode = '{0}'", strDefaultLangCode);
            ShareClass.RunSqlCommand(strHQL1);
        }
    }

    //更新页面模组
    protected void UpdatePageBarModules(string strToLangCode)
    {
        string strHQL1 = "";
        string strModuleName, strParentModule, strLangCode, strHomeModuleName, strPageName, strModuleType, strUserType, strVisible, strIsDeleted, strSortNUmber, strIconURL;

        DataSet ds1;

        string strpath = Server.MapPath("UpdateCode\\Language\\Module\\PageModules.xls");

        DataTable dt1;
        dt1 = new DataTable();
        dt1 = MSExcelHandler.ReadExcelToDataTable(strpath, "");
        DataRow[] dr = dt1.Select();  //定义一个DataRow数组
        int rowsnum = dt1.Rows.Count;

        if (rowsnum == 0)
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGEXCELBWKBWSJ") + "')", true);
        }
        else
        {
            for (int i = 0; i < dr.Length; i++)
            {
                try
                {
                    strModuleName = dr[i]["ModuleName"].ToString().Trim();
                    strParentModule = dr[i]["ParentModule"].ToString().Trim();
                    strLangCode = dr[i]["LangCode"].ToString().Trim();
                    strHomeModuleName = dr[i]["HomeModuleName"].ToString().Trim();
                    strPageName = dr[i]["PageName"].ToString().Trim();
                    strModuleType = dr[i]["ModuleType"].ToString().Trim();
                    strUserType = dr[i]["UserType"].ToString().Trim();
                    strVisible = dr[i]["Visible"].ToString().Trim();
                    strIsDeleted = dr[i]["IsDeleted"].ToString().Trim();
                    strSortNUmber = dr[i]["SortNumber"].ToString().Trim();
                    strIconURL = dr[i]["IconURL"].ToString().Trim();
                    strIconURL = strIconURL.Replace("//", "/");
                    strIconURL = strIconURL.Replace("\\", "/");

                    if (strLangCode == strToLangCode)
                    {
                        strHQL1 = "Select * From T_ProModuleLevelForPage  Where ParentModule = '" + strParentModule + "' and ModuleName = '" + strModuleName + "' and ModuleType = '" + strModuleType + "' and LangCode='" + strLangCode + "' and UserType = '" + strUserType + "'";
                        ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_ProModuleLevel");
                        if (ds1.Tables[0].Rows.Count > 0)
                        {
                            strHQL1 = "Update T_ProModuleLevelForPage Set HomeModuleName = '" + strHomeModuleName.Replace("'", "").Replace("\"", "").Replace("\\", "") + "'" + ",IconURL = " + "'" + strIconURL + "'";
                            strHQL1 += " Where ParentModule = '" + strParentModule + "' and ModuleName = '" + strModuleName + "' and LangCode='" + strLangCode + "' and ModuleType = '" + strModuleType + "' and UserType = " + "'" + strUserType + "'";

                            ShareClass.RunSqlCommand(strHQL1);
                        }
                    }
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace + " :" + strHQL1);
                }
            }

            string strDefaultLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            strHQL1 = string.Format(@"UPDATE T_ProModuleLevelForPage B
                        SET SortNumber = A.SortNumber
                        FROM T_ProModuleLevelForPage A
                        WHERE A.ModuleName = B.ModuleName 
                        AND A.ModuleType = B.ModuleType 
                        AND A.UserType = B.UserType 
                        AND A.LangCode <> B.LangCode 
                        AND A.LangCode = '{0}'", strDefaultLangCode);
            ShareClass.RunSqlCommand(strHQL1);
        }
    }


    //复制所有左边栏模组
    protected void CopyAllLeftModuleForHomeLanguage()
    {
        string strHQL, strLangHQL;

        string strModuleName, strModuleType;
        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];

        //strUserType = DL_ForUserType.SelectedValue.Trim();
        strModuleType = GetLeftModuleType("0");
        strModuleName = GetLeftModuleName("0");

        strLangHQL = "Select LangCode From T_SystemLanguage Where LangCode <> " + "'" + strFromLangCode + "'";
        strLangHQL += " Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strLangHQL, "T_SystemLanguage");


        for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            strLangCode = ds.Tables[0].Rows[i][0].ToString().Trim();

            strHQL = "Insert Into T_ProModuleLevel(ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible,LangCode,HomeModuleName,IsDeleted,IconURL,ModuleDefinition)";
            strHQL += " SELECT ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible," + "'" + strLangCode + "'" + ",HomeModuleName,IsDeleted,IconURL,ModuleDefinition FROM T_ProModuleLevel";
            strHQL += " Where LangCode = '" + strFromLangCode + "' and trim(ModuleName) || trim(ParentModule) || trim(ModuleType) || trim(UserType)  Not in (Select rtrim(ModuleName) || trim(ParentModule) || trim(ModuleType) || trim(UserType) From T_ProModuleLevel Where LangCode = " + "'" + strLangCode + "'" + ")";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Update T_ProModuleLevel B Set SortNumber = A.SortNumber From T_ProModuleLevel A Where A.ModuleName = B.ModuleName and A.LangCode = '" + strFromLangCode + "' AND B.LangCode =" + "'" + strLangCode + "'";
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Delete From T_ProModuleLevel Where LangCode = " + "'" + strLangCode + "'" + " and ModuleType in ('SYSTEM','APP')";
            strHQL += " and trim(ModuleName) || trim(ParentModule) || trim(ModuleType) || trim(UserType)  Not in (Select trim(ModuleName) || trim(ParentModule) || trim(ModuleType) || trim(UserType) From T_ProModuleLevel Where LangCode = '" + strFromLangCode + "')";
            ShareClass.RunSqlCommand(strHQL);
        }
    }


    //复制所有页面模组
    protected void CopyAllPageModuleForHomeLanguage()
    {
        string strHQL, strLangHQL;

        string strModuleName, strModuleType;
        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];


        strModuleType = GetPageModuleType("0");
        strModuleName = GetPageModuleName("0");

        strLangHQL = "Select LangCode From T_SystemLanguage Where LangCode <> " + "'" + strFromLangCode + "'";
        strLangHQL += " Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strLangHQL, "T_SystemLanguage");

        try
        {
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                strLangCode = ds.Tables[0].Rows[i][0].ToString().Trim();

                strHQL = "Insert Into T_ProModuleLevelForPage(ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible,LangCode,HomeModuleName,IsDeleted,IconURL)";
                strHQL += " SELECT ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible," + "'" + strLangCode + "'" + ",HomeModuleName,IsDeleted,IconURL FROM T_ProModuleLevelForPage";
                strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType))  Not in (Select ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType)) From T_ProModuleLevelForPage Where LangCode = " + "'" + strLangCode + "'" + ")";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Update T_ProModuleLevelForPage B Set SortNumber = A.SortNumber,Visible = A.Visible,IsDeleted = A.IsDeleted From T_ProModuleLevelForPage A Where A.ModuleName = B.ModuleName and A.ParentModule = B.ParentModule and A.LangCode = '" + strFromLangCode + "' AND B.LangCode =" + "'" + strLangCode + "'";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_ProModuleLevelForPage Where LangCode = " + "'" + strLangCode + "'" + " and ModuleType in ('SYSTEM','APP')";
                strHQL += " and ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType))  Not in (Select ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType)) From T_ProModuleLevelForPage Where LangCode = '" + strFromLangCode + "')";
                ShareClass.RunSqlCommand(strHQL);
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile(ex.Message.ToString());
        }
    }

    private void CreateLeftBarModuleExcel(string fileName)
    {
        string strHQL;

        strHQL = "Select ModuleName,ParentModule,PageName,ModuleType,LangCode,cast(HomeModuleName as varchar(2000)) as HomeModuleName,UserType,Visible,IsDeleted,SortNumber,IconURL,ModuleDefinition From T_ProModuleLevel";
        strHQL += " Order By LangCode ASC,HomeModuleName ASC";

        MSExcelHandler.DataTableToExcel(strHQL, fileName);
    }

    private void CreatePageBarModuleExcel(string fileName)
    {
        string strHQL;

        strHQL = "Select ModuleName,ParentModule,PageName,ModuleType,LangCode,cast(HomeModuleName as varchar(2000)) as HomeModuleName,UserType,Visible,IsDeleted,SortNumber,IconURL From T_ProModuleLevelForPage";
        strHQL += " Order By LangCode ASC,HomeModuleName ASC";

        MSExcelHandler.DataTableToExcel(strHQL, fileName);
    }

    protected string GetLeftModuleType(string strModuleID)
    {
        string strHQL = "Select ModuleType From T_ProModuleLevel Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    protected string GetLeftModuleUserType(string strModuleID)
    {
        string strHQL = "Select UserType From T_ProModuleLevel Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    protected string GetLeftModulePageName(string strModuleID)
    {
        string strHQL;

        strHQL = "Select PageName From T_ProModuleLevel Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    protected string GetLeftModuleName(string strModuleID)
    {
        string strHQL = "Select ModuleName From T_ProModuleLevel Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    protected string GetPageModuleType(string strModuleID)
    {
        string strHQL = "Select ModuleType From T_ProModuleLevelForPage Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    protected string GetPageModuleName(string strModuleID)
    {
        string strHQL = "Select ModuleName From T_ProModuleLevelForPage Where ID = " + strModuleID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }


    protected void BT_CompareByHomeLanguage_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            string strHQL;
            string strHomeLangCode;

            strHomeLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];

            strLangCode = ddlLangSwitcher.SelectedValue.Trim();

            strHQL = "Truncate Table T_LanguageResourceHome";
            ShareClass.RunSqlCommand(strHQL);
            strHQL = "Truncate Table T_LanguageResourceOther";
            ShareClass.RunSqlCommand(strHQL);

            string strOtherLangResxFile = Server.MapPath("App_GlobalResources\\lang." + strLangCode + ".resx");
            ResXResourceReader rrOther = new ResXResourceReader(strOtherLangResxFile);
            IDictionaryEnumerator ideOther = rrOther.GetEnumerator();
            while (ideOther.MoveNext())
            {
                try
                {
                    strHQL = "Insert Into T_LanguageResourceOther(KeyName,KeyValue) Values('" + ideOther.Key + "','" + ideOther.Value.ToString().Replace("'", "") + "')";
                    ShareClass.RunSqlCommand(strHQL);
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: Key:" + ideOther.Key + " ," + err.Message.ToString() + "\n" + err.StackTrace);
                }
            }
            rrOther.Close();

            string strHomeLangResxFile = Server.MapPath("App_GlobalResources\\lang.resx");
            ResXResourceReader rrHome = new ResXResourceReader(strHomeLangResxFile);
            IDictionaryEnumerator ideHome = rrHome.GetEnumerator();
            while (ideHome.MoveNext())
            {
                if (ideHome.Value.ToString().Trim() == "")
                {
                    strHQL = "Delete From T_LanguageResourceHome Where KeyName = '" + ideHome.Key + "'";
                    continue;
                }
                strHQL = "Insert Into T_LanguageResourceHome(KeyName,KeyValue) Values('" + ideHome.Key + "','" + ideHome.Value.ToString().Replace("'", "") + "')";
                ShareClass.RunSqlCommand(strHQL);
            }
            rrHome.Close();

            strHQL = "Select KeyName,KeyValue From T_LanguageResourceHome Where KeyName Not In (Select KeyName From T_LanguageResourceOther)";

            MSExcelHandler.DataTableToExcel(strHQL, "lang." + strLangCode + ".xls");


            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click2", "showAlertAtMouse('OK！');", true);

            return;
        }
    }

    protected void BT_ImportLanguageData_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            string directoryPath = Server.MapPath("UpdateCode\\Language\\Skin\\");

            // 调用方法遍历目录并导入Excel数据到对应的.resx文件
            ImportExcelFilesInDirectory(directoryPath);

            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('OK！')", true);
        }
    }

    public static void ImportExcelFilesInDirectory(string directoryPath)
    {
        // 获取目录下所有的Excel文件（.xls 和 .xlsx）
        var excelFiles = Directory.GetFiles(directoryPath, "*.xls*");

        foreach (var excelFilePath in excelFiles)
        {
            // 获取Excel文件名（不带扩展名）
            string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(excelFilePath);

            // 构建对应的.resx文件路径
            string resxFilePath = Path.Combine(directoryPath, $"{fileNameWithoutExtension}.resx");

            // 调用方法将Excel数据导入到.resx文件
            ImportExcelToResx(excelFilePath, resxFilePath);

            LogClass.WriteLogFile($"Handle file: {excelFilePath} -> {resxFilePath}");
        }
    }

    public static void ImportExcelToResx(string excelFilePath, string resxFilePath)
    {
        // 打开Excel文件
        IWorkbook workbook;
        using (var fileStream = new FileStream(excelFilePath, FileMode.Open, FileAccess.Read))
        {
            if (excelFilePath.EndsWith(".xlsx"))
            {
                workbook = new XSSFWorkbook(fileStream); // 读取 .xlsx 文件
            }
            else
            {
                workbook = new HSSFWorkbook(fileStream); // 读取 .xls 文件
            }
        }

        // 获取第一个工作表
        ISheet worksheet = workbook.GetSheetAt(0);

        // 创建一个字典来存储Excel中的KeyName和KeyValue
        var keyValuePairs = new Dictionary<string, string>();

        // 遍历Excel表中的每一行（从第二行开始，假设第一行是标题）
        for (int row = 1; row <= worksheet.LastRowNum; row++)
        {
            IRow currentRow = worksheet.GetRow(row);
            if (currentRow == null) continue; // 跳过空行

            string keyName = currentRow.GetCell(0)?.ToString(); // KeyName列（第一列）
            string keyValue = currentRow.GetCell(1)?.ToString(); // KeyValue列（第二列）

            if (!string.IsNullOrEmpty(keyName))
            {
                keyValuePairs[keyName] = keyValue;
            }
        }

        // 如果.resx文件已存在，读取现有资源
        var existingResources = new Dictionary<string, string>();
        if (File.Exists(resxFilePath))
        {
            using (ResXResourceReader resxReader = new ResXResourceReader(resxFilePath))
            {
                foreach (System.Collections.DictionaryEntry entry in resxReader)
                {
                    existingResources[entry.Key.ToString()] = entry.Value?.ToString();
                }
            }
        }

        // 将数据写入.resx文件（新增时跳过已存在的KeyName）
        using (ResXResourceWriter resxWriter = new ResXResourceWriter(resxFilePath))
        {
            // 先写入现有资源
            foreach (var kvp in existingResources)
            {
                resxWriter.AddResource(kvp.Key, kvp.Value);
            }

            // 再写入Excel中的新资源（跳过已存在的KeyName）
            foreach (var kvp in keyValuePairs)
            {
                if (!existingResources.ContainsKey(kvp.Key))
                {
                    resxWriter.AddResource(kvp.Key, kvp.Value);
                }
                else
                {
                    Console.WriteLine($"Passed be existed KeyName: {kvp.Key}");
                }
            }
        }
    }


    protected void BT_CreateRTXAccountData_Click(object sender, EventArgs e)
    {
        try
        {
            ShareClass.RunSqlCommand("Exec Pr_CreateRTXAccountData");
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSJCCG") + "')", true);
        }
        catch
        {
            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+LanguageHandle.GetWord("ZZSJCSBKNYGRSTDYSCSZSJKLZJZXPR")+"')", true);
        }
    }

    protected void BT_CreateRTXDataToTXT_Click(object sender, EventArgs e)
    {
        string strExtName, strFileName, strDocURL, strDocSavePath;

        strExtName = ".txt";

        strFileName = "RTXAccountData" + DateTime.Now.ToString("yyyyMMddHHMMssff") + strExtName;

        strDocURL = "Doc\\" + "RTXAccount\\" + strFileName;

        strDocSavePath = Server.MapPath("Doc") + "\\RTXAccount\\" + strFileName;

        try
        {
            CreateRTXAccountDataToTXT(strDocSavePath);

            HL_RTXAccountDataFile.NavigateUrl = strDocURL;
            HL_RTXAccountDataFile.Target = "_blank";

            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('"+LanguageHandle.GetWord("ZZSCWJCG")+"')", true);
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZSCWJSBKNYHSTDYSCSJC") + "')", true);
        }
    }

}