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
/// ShareClass partial - Project
/// </summary>
public static partial class ShareClass
{
    
    #region 项目相关操作函数

    //列出可用的工作流模板
    public static void LoadProjectPlanStartupRelatedWorkflowTemplate(string strUserCode, DropDownList DL_TemName)
    {
        string strHQL;

        string strUserParentDepartmentString = TakeTopCore.CoreShareClass.InitialParentDepartmentStringByAuthority(strUserCode);
        string strUserUnderDepartmentString = TakeTopCore.CoreShareClass.InitialUnderDepartmentStringByAuthority(strUserCode);

        strHQL = "Select TemName From T_WorkFlowTemplate Where Visible = 'YES' and Authority = 'All'";
        strHQL += " and (BelongDepartCode in " + strUserParentDepartmentString;
        strHQL += " Or BelongDepartCode in " + strUserUnderDepartmentString + ")";
        strHQL += " Order by SortNumber ASC";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkflowTemplate");

        DL_TemName.DataSource = ds;
        DL_TemName.DataBind();

        DL_TemName.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //判断当前用户有没有修改用户计划的权限
    public static string CheckUserIsCanUpdatePlan(string strProjectID, string strVerID)
    {
        string strHQL;
        string strPlanVerType, strCurrentUserCode;

        strCurrentUserCode = HttpContext.Current.Session["UserCode"].ToString();

        if (strVerID == null)
        {
            return "False";
        }

        //依项目属性是否锁定已启动的项目计划判断能否修改计划
        if (CheckProjectPlanCanBeUpdate(strProjectID) == "NO")
        {
            return "False";
        }

        //如果项目已经验收\结案\归档，那么不能更改计划信息
        if (CheckProjectIsFinish(strProjectID))
        {
            return "False";
        }

        try
        {
            strHQL = "Select Type From T_ProjectPlanVersion Where ProjectID = " + strProjectID + " and VerID = " + strVerID;
            DataSet ds0 = GetDataSetFromSql(strHQL, "T_ProjectPlanVersion");
            strPlanVerType = ds0.Tables[0].Rows[0][0].ToString().Trim();

            if (strPlanVerType != "Baseline")
            {
                strHQL = "Select * From T_Project Where ProjectID = " + strProjectID;
                strHQL += " and (PMCode = " + "'" + strCurrentUserCode + "'";
                strHQL += " or UserCode = " + "'" + strCurrentUserCode + "')";
                DataSet ds1 = GetDataSetFromSql(strHQL, "T_Project");

                strHQL = "Select * From T_RelatedUser Where ProjectID = " + strProjectID;
                strHQL += " and CanUpdatePlan = 'YES'";
                strHQL += " and UserCode = " + "'" + strCurrentUserCode + "'";
                DataSet ds2 = GetDataSetFromSql(strHQL, "T_RelatedUser");

                if (ds1.Tables[0].Rows.Count > 0 | ds2.Tables[0].Rows.Count > 0)
                {
                    return "True";
                }
                else
                {
                    return "False";
                }
            }
            else
            {
                strHQL = "Select * From T_Project Where ProjectID = " + strProjectID;
                strHQL += " and UserCode = " + "'" + strCurrentUserCode + "'";
                DataSet ds3 = GetDataSetFromSql(strHQL, "T_Project");
                if (ds3.Tables[0].Rows.Count > 0)
                {
                    return "True";
                }
                else
                {
                    return "False";
                }
            }
        }
        catch
        {
            return "False";
        }
    }

    //依项目属性是否锁定已启动的项目计划判断能否修改计划
    public static string CheckProjectPlanCanBeUpdate(string strProjectID)
    {
        //判断能否更改计划
        if (ShareClass.CheckStartupPlanIsLock(strProjectID) == "YES" & ShareClass.CheckProjectPlanIsStartup(strProjectID) == "YES")
        {
            return "NO";
        }
        else
        {
            return "YES";
        }
    }

    //判断能否更改项目计划
    public static string CheckProjectPlanIsStartup(string strProjectID)
    {
        string strHQL;

        strHQL = string.Format(@"Select ProjectPlanStartupStatus From T_Project Where ProjectID = {0}", strProjectID);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0]["ProjectPlanStartupStatus"].ToString().Trim();
        }
        else
        {
            return "NO";
        }
    }

    //判断是否锁定已启动的项目计划
    public static string CheckStartupPlanIsLock(string strProjectID)
    {
        string strHQL;

        strHQL = "Select LockStartupedPlan From T_Project Where ProjectID =" + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "NO";
        }
    }

    //检查项目成员是否已存在
    public static int CheckProjectMemberIsExisted(string strProjectID, string strUserCode)
    {
        string strHQL;

        strHQL = "Select * From T_RelatedUser Where ProjectID = " + strProjectID + " and UserCode = '" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");

        return ds.Tables[0].Rows.Count;
    }

    //设置风险文本颜色
    public static void SetRiskLabelColor(DataGrid dataGrid, int intCellNumber)
    {
        string strProjectID;
        int i;

        for (i = 0; i < dataGrid.Items.Count; i++)
        {
            strProjectID = dataGrid.Items[i].Cells[intCellNumber].Text.Trim();

            if (GetRiskUnFinishNumber(strProjectID) > 0)
            {
                ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_RiskNumber")).BackColor = Color.Red;
            }
        }
    }

    //取得没有按时完成的风险数量
    public static int GetRiskUnFinishNumber(string strProjectID)
    {
        string strHQL;

        strHQL = "Select * From T_ProjectRisk Where EffectDate < now() and Status <> 'Resolved' and ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectRisk");

        return ds.Tables[0].Rows.Count;
    }

    //设置缺陷文本颜色
    public static void SetDefectLabelColor(DataGrid dataGrid, int intCellNumber)
    {
        string strProjectID;
        int i;

        for (i = 0; i < dataGrid.Items.Count; i++)
        {
            strProjectID = dataGrid.Items[i].Cells[intCellNumber].Text.Trim();

            if (GetDefectUnFinishNumber(strProjectID) > 0)
            {
                ((System.Web.UI.WebControls.Label)dataGrid.Items[i].FindControl("LB_DefectNumber")).BackColor = Color.Red;
            }
        }
    }

    //取得没有按时完成的缺陷数量
    public static int GetDefectUnFinishNumber(string strProjectID)
    {
        string strHQL;

        strHQL = "Select * From T_Defectment Where DefectFinishedDate < now() and  Status <> 'Closed' and DefectID Not In (Select DefectId From T_RelatedDefect Where ProjectID = " + strProjectID + ") ";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectRisk");

        return ds.Tables[0].Rows.Count;
    }


    //取得项目总确认工时
    public static string GetProjectTotalConfirmWorkHour(string strProjectID)
    {
        string strHQL;

        strHQL = "Select Sum(ConfirmManHour) From V_ProjectMemberManHourSummary";
        strHQL += " Where ProjectID = " + strProjectID;

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_DailyWork");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得项目未解决风险总数
    public static string GetProjectTotalUNFinishRiskNumber(string strProjectID)
    {
        string strCmdText;

        strCmdText = "select count(*) from T_ProjectRisk ";
        strCmdText += " where ProjectID = " + strProjectID;
        strCmdText += " and Status <> 'Resolved'";

        DataSet ds = ShareClass.GetDataSetFromSql(strCmdText, "T_ProjectRisk");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得项目风险总数
    public static string GetProjectTotalRiskNumber(string strProjectID)
    {
        string strCmdText;

        strCmdText = "select count(*) from T_ProjectRisk ";
        strCmdText += " where ProjectID = " + strProjectID;

        DataSet ds = ShareClass.GetDataSetFromSql(strCmdText, "T_ProjectRisk");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得项目未解决风险总数/项目风险总数
    public static string GetProjectRiskUnFinishAndFinishNumber(string strProjectID)
    {
        return GetProjectTotalUNFinishRiskNumber(strProjectID) + "/" + GetProjectTotalRiskNumber(strProjectID);
    }

    //取得项目未关闭缺陷总数
    public static string GetProjectTotalUNFinishDefectNumber(string strProjectID)
    {
        string strCmdText;

        strCmdText = "select count(*) from T_Defectment ";
        strCmdText += " where DefectID in (Select DefectID From T_RelatedDefect Where ProjectID = " + strProjectID + ")";
        strCmdText += " and Status <> 'Closed'";

        DataSet ds = ShareClass.GetDataSetFromSql(strCmdText, "T_Defectment");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得项目缺陷总数
    public static string GetProjectTotalDefectNumber(string strProjectID)
    {
        string strCmdText;

        strCmdText = "select count(*) from T_Defectment ";
        strCmdText += " where DefectID in (Select DefectID From T_RelatedDefect Where ProjectID = " + strProjectID + ")";

        DataSet ds = ShareClass.GetDataSetFromSql(strCmdText, "T_Defectment");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得项目未关闭缺陷总数/项目缺陷总数
    public static string GetProjectDefectUnFinishAndFinishNumber(string strProjectID)
    {
        return GetProjectTotalUNFinishDefectNumber(strProjectID) + "/" + GetProjectTotalDefectNumber(strProjectID);
    }

    //取得项目文档总数
    public static string GetProjectDocumentNumber(string strProjectID)
    {
        string strHQL;

        string strUserCode = HttpContext.Current.Session["UserCode"].ToString();
        string strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = string.Format(@"Select  DocName  from T_Document as document where ((document.RelatedType = 'Project' and document.RelatedID = {0})
                   or (((document.RelatedType = 'Requirement' and document.RelatedID in (select relatedReq.ReqID from T_RelatedReq as relatedReq where relatedReq.ProjectID = {0}))
                   or (document.RelatedType = 'Workflow' and document.RelatedID in (Select workFlow.WLID From T_WorkFlow as workFlow Where workFlow.RelatedType = 'Project' and workFlow.RelatedID = {0}))
                   or (document.RelatedType = '风险' and document.RelatedID in (select projectRisk.ID from T_ProjectRisk as projectRisk where projectRisk.ProjectID = {0}))
                   or (document.RelatedType = 'Task' and document.RelatedID in (select projectTask.TaskID from T_ProjectTask as projectTask where projectTask.ProjectID = {0}))
                   or (document.RelatedType = 'Plan' and document.RelatedID in (select workPlan.ID From T_ImplePlan as workPlan where workPlan.ProjectID = {0}))
                   or (document.RelatedType = 'Workflow' and document.RelatedID in (Select workFlow.WLID From T_WorkFlow as workFlow Where workFlow.RelatedType = 'Plan' and workFlow.RelatedID in (select workPlan.ID From T_ImplePlan as workPlan where workPlan.ProjectID = {0})))
                   or (document.RelatedType = '会议' and document.RelatedID in (select meeting.ID from T_Meeting as meeting where meeting.RelatedID = {0}))
                   )))
                   and rtrim(ltrim(document.Status)) <> 'Deleted'", strProjectID, strUserCode, strDepartCode);

        //

        DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_Document");

        return ds1.Tables[0].Rows.Count.ToString();
    }

    //取得项目计划按模板实际提交的文档数和模板规定应提交的文档数
    public static string GetProjectDocmentNumberAndRequiseDocument(string strProjectID)
    {
        string strHQL1, strHQL2;

        strHQL1 = string.Format(@"select t1.DocName,t2.MustUploadDoc FROM  t_documentForProjectPlanTemplate t1,T_Document t2
            where t1.RelatedType='Plan' and t1.Status<> 'Deleted' and t1.RelatedID in (Select ID From T_ImplePlan Where ProjectID = {0})
			and t2.RelatedType='Plan' and t2.Status<> 'Deleted' and t2.RelatedID in (Select ID From T_ImplePlan Where ProjectID = {0})
			and trim(t1.DocName) = trim(t2.MustUploadDoc)", strProjectID);
        DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_Document");

        strHQL2 = string.Format(@"select * FROM   
            t_documentForProjectPlanTemplate
            where RelatedType='Plan' and Status <> 'Deleted' and RelatedID in (Select ID From T_ImplePlan Where ProjectID = {0})", strProjectID);
        DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL2, "T_Document");

        return ds1.Tables[0].Rows.Count.ToString() + "/" + ds2.Tables[0].Rows.Count.ToString();
    }


    //列出项目里程碑状态图
    public static void DisplayRelatedMileStoneStepDump(string strProjectID, string strVerID, Repeater Repeater1)
    {
        string strHQL;
        int intPercentDone;
        string strPlanDetail;

        DataSet ds;

        strHQL = "Select trim(Name) as Name,Percent_Done From T_ImplePlan Where ProjectID = " + strProjectID + " and VerID = " + strVerID;
        strHQL += " And to_char(Start_Date,'yyyymmdd') >= to_char(End_Date,'yyyymmdd')";
        strHQL += " Order By Start_Date ASC";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");
        Repeater1.DataSource = ds;
        Repeater1.DataBind();

        if (ds.Tables[0].Rows.Count > 0)
        {
            try
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    strPlanDetail = ds.Tables[0].Rows[i]["Name"].ToString().Trim();
                    intPercentDone = int.Parse(ds.Tables[0].Rows[i]["Percent_Done"].ToString().Trim());

                    if (intPercentDone == 100)
                    {
                        ((ImageButton)Repeater1.Items[i].FindControl("IBT_MileStone")).ImageUrl = "Images/GreenDumpLarge.jpg";
                    }
                    else
                    {
                        ((ImageButton)Repeater1.Items[i].FindControl("IBT_MileStone")).ImageUrl = "Images/RegDumpLarge.jpg";
                    }
                }
            }
            catch
            {
            }
        }
    }



    //列出项目类型 
    public static void LoadProjectType(DropDownList DL_ProjectType)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectType as projectType Order by projectType.SortNumber ASC";
        ProjectTypeBLL projectTypeBLL = new ProjectTypeBLL();
        lst = projectTypeBLL.GetAllProjectTypes(strHQL);
        DL_ProjectType.DataSource = lst;
        DL_ProjectType.DataBind();
    }

    //列出项目状态
    public static void LoadProjectForPMStatus(string strProjectType, string strLangCode, DropDownList DL_Status)
    {
        string strHQL;
        IList lst;

        if (strProjectType != "")
        {
            string strSystemVersionType = HttpContext.Current.Session["SystemVersionType"].ToString();
            string strProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];
            if (strSystemVersionType == "SAAS" || strProductType.IndexOf("SAAS") > -1)
            {
                strHQL = "from ProjectStatus as projectStatus";
                strHQL += " Where projectStatus.ProjectType = " + "'" + strProjectType + "'";
                strHQL += " and projectStatus.Status not in ('New','Review','Plan','Accepted')";
            }
            else
            {
                strHQL = "from ProjectStatus as projectStatus";
                strHQL += " Where projectStatus.ProjectType = " + "'" + strProjectType + "'";
            }

            strHQL += " And projectStatus.LangCode =" + "'" + strLangCode + "'";
            strHQL += " Order by projectStatus.SortNumber ASC";

            ProjectStatusBLL projectStatusBLL = new ProjectStatusBLL();
            lst = projectStatusBLL.GetAllProjectStatuss(strHQL);
            DL_Status.DataSource = lst;
            DL_Status.DataBind();
        }
    }

    //列出项目状态
    public static void LoadProjectStatusForDataGrid(string strLangCode, DataGrid dataGrid)
    {
        string strHQL;
        strHQL = string.Format(@"select distinct A.Status, rtrim(A.HomeName) as HomeName,A.SortNumber from T_ProjectStatus A 
                Where A.LangCode ='{0}' 
                and A.SortNumber in (Select min(B.SortNumber) From T_ProjectStatus B Where B.LangCode = '{0}' and A.Status = B.Status)
                and Status not in ('Archived')
                Order By A.SortNumber ASC", strLangCode);

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectStatus");
        dataGrid.DataSource = ds;
        dataGrid.DataBind();
    }

    //列出参与的项目状态
    public static void LoadInvolvedProjectStatusForDataGrid(string strLangCode, DataGrid dataGrid)
    {
        string strHQL;
        strHQL = string.Format(@"select distinct A.Status, rtrim(A.HomeName) as HomeName,A.SortNumber from T_ProjectStatus A 
                Where A.LangCode ='{0}' 
                and A.SortNumber in (Select min(B.SortNumber) From T_ProjectStatus B Where B.LangCode = '{0}' and A.Status = B.Status)
                and Status not in ('New','Review', 'Hided','Deleted','Archived','Pause','Stop')
                Order By A.SortNumber ASC", strLangCode);

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectStatus");
        dataGrid.DataSource = ds;
        dataGrid.DataBind();
    }

    //列出项目状态
    public static void LoadProjectStatusForDropDownList(string strLangCode, DropDownList DL_Status)
    {
        string strHQL;

        strHQL = string.Format(@"select distinct A.Status, rtrim(A.HomeName) as HomeName,A.SortNumber from T_ProjectStatus A 
                Where A.LangCode ='{0}' 
                and A.SortNumber in (Select min(B.SortNumber) From T_ProjectStatus B Where B.LangCode = '{0}' and A.Status = B.Status)
                and Status not in ('Archived')
                Order By A.SortNumber ASC", strLangCode);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectStatus");
        DL_Status.DataSource = ds;
        DL_Status.DataBind();

        DL_Status.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //添加项目成员
    public static void AddProjectMember(string strProjectID, string strActorCode, string strActor, string strWorkDetail, string strStatus)
    {
        string strProjectName = ShareClass.GetProjectName(strProjectID);

        string strActorName = ShareClass.GetUserName(strActorCode);
        string strDepartCode = ShareClass.GetDepartCodeFromUserCode(strActorCode);
        string strDepartName = ShareClass.GetDepartName(strDepartCode);

        string strJoinDate = DateTime.Now.ToString("yyyy-MM-dd");
        string strLeaveDate = DateTime.Now.ToString("yyyy-MM-dd");
        string strSalaryMethod = "工时";
        decimal dePromissionScale = 0;
        decimal deHourSalary = 0;
        string strCanUpdatePlan = "YES";

        string strHQL;
        strHQL = "Select * From T_RelatedUser Where UserCode = '" + strActorCode + "' and Actor = '" + strActor + "' and ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return;
        }

        try
        {
            RelatedUserBLL relatedUserBLL = new RelatedUserBLL();
            RelatedUser relatedUser = new RelatedUser();

            relatedUser.ProjectID = int.Parse(strProjectID);
            relatedUser.ProjectName = strProjectName;
            relatedUser.UserCode = strActorCode;
            relatedUser.UserName = strActorName;
            relatedUser.DepartCode = strDepartCode;
            relatedUser.DepartName = ShareClass.GetDepartName(strDepartCode);
            relatedUser.Actor = strActor;
            relatedUser.JoinDate = DateTime.Parse(strJoinDate);
            relatedUser.LeaveDate = DateTime.Parse(strLeaveDate);
            relatedUser.Status = strStatus;
            relatedUser.WorkDetail = strWorkDetail;
            relatedUser.SMSCount = 0;
            relatedUser.SalaryMethod = strSalaryMethod;
            relatedUser.PromissionScale = dePromissionScale;
            relatedUser.UnitHourSalary = deHourSalary;
            relatedUser.CanUpdatePlan = strCanUpdatePlan;

            relatedUserBLL.AddRelatedUser(relatedUser);
        }
        catch
        {
        }
    }


    //依计划ID取得项目类型
    public static string GetProjectTypeByPlanID(string strPlanID)
    {
        string strHQL;

        strHQL = "Select ProjectType From T_Project where ProjectID in (Select ProjectID From T_ImplePlan Where ID = " + strPlanID + ")";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "Other Projects";
        }
    }

    //依计划ID取得项目ID
    public static string GetProjectIDByPlanID(string strPlanID)
    {
        string strHQL;

        strHQL = "Select ProjectID From T_ImplePlan Where ID = " + strPlanID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "0";
        }
    }

    //判断是否要计划员确认任务时度才能影响计划进度
    public static string GetPlanProgressNeedPlanerConfirmByProject(string strProjectID)
    {
        string strHQL = "Select PlanProgressNeedPlanerConfirm From T_Project Where ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectType");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "NO";
        }
    }

    //取得项目计划的KEY ID
    public static string GetProjectPlanKeyIDByVerID(string strProjectID, string strVerID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectPlanVersion as projectPlanVersion where projectPlanVersion.ProjectID = " + strProjectID + " and projectPlanVersion.VerID = " + "'" + strVerID + "'";

        ProjectPlanVersionBLL projectPlanVersionBLL = new ProjectPlanVersionBLL();
        lst = projectPlanVersionBLL.GetAllProjectPlanVersions(strHQL);

        if (lst.Count > 0)
        {
            ProjectPlanVersion projectPlanVersion = (ProjectPlanVersion)lst[0];
            return projectPlanVersion.ID.ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得项目状态值
    public static string GetProjectStatusValue(string strProjectID)
    {
        string strHQL = "from Project as project where project.ProjectID = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        IList lst = projectBLL.GetAllProjects(strHQL);
        Project project = (Project)lst[0];

        return project.StatusValue.Trim();
    }

    //取得项目大类
    public static string GetProjectClass(string strProjectID)
    {
        string strHQL = "from Project as project where project.ProjectID = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        IList lst = projectBLL.GetAllProjects(strHQL);
        Project project = (Project)lst[0];
        string strProjectClass = project.ProjectClass.Trim();
        return strProjectClass;
    }

    //取昨立项者代码
    public static string GetProjectCreatorCode(string strProjectID)
    {
        string strHQL = "from Project as project where project.ProjectID = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        IList lst = projectBLL.GetAllProjects(strHQL);
        Project project = (Project)lst[0];

        return project.UserCode.Trim();
    }

    //如果项目已经验收\结案\归档，那么不能更改计划信息
    public static bool CheckProjectIsFinish(string strProjectID)
    {
        string strHQL;

        strHQL = "Select * From T_Project Where Status in ('Suspended','Cancel','Acceptance','CaseClosed','Archived') and ProjectId = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //检查用户是否计划员
    public static bool CheckMemberIsProjectPlanOperator(string strProjectID, string strUserCode)
    {
        string strHQL;

        strHQL = "Select * From T_RelatedUser Where ProjectID = " + strProjectID;
        strHQL += " and CanUpdatePlan = 'YES'";
        strHQL += " and UserCode = " + "'" + strUserCode + "'";
        DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");

        if (ds2.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //更新流程的工时
    public static void UpdateWorkFlowManHour(string strRelatedType, string strRelatedID, string strWLID, string strID, decimal deManHour)
    {
        string strHQL;
        decimal deTotalManHour;

        try
        {
            strHQL = "Update T_WorkFlowStepDetail Set ManHour = " + deManHour.ToString() + " Where ID = " + strID;
            ShareClass.RunSqlCommand(strHQL);

            deTotalManHour = GetWorkflowTotalManHour(strWLID);
            strHQL = "Update T_WorkFlow Set ManHour = " + deTotalManHour.ToString() + " Where WLID = " + strWLID;
            ShareClass.RunSqlCommand(strHQL);

            if (strRelatedType == "Plan")
            {
                strHQL = "update T_ImplePlan Set ActualHour = " + ShareClass.GetTotalRealManHourByPlan(strRelatedID);
                strHQL += " Where PID = " + strRelatedID;
                ShareClass.RunSqlCommand(strHQL);
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //取得流程的工时总额
    public static decimal GetWorkflowTotalManHour(string strWLID)
    {
        string strHQL;

        strHQL = "Select COALESCE(Sum(ManHour),0) From T_WorkFlowStepDetail Where WLID = " + strWLID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStepDetail");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 0;
        }
    }

    //更新流程的工时
    public static void UpdateWorkFlowExpense(string strRelatedType, string strRelatedID, string strWLID, string strID)
    {
        string strHQL;
        decimal deExpense, deTotalExpense;

        deExpense = GetWorkflowStepDetailTotalExpense(strID);
        try
        {
            strHQL = "Update T_WorkFlowStepDetail Set Expense = " + deExpense.ToString() + " Where ID = " + strID;
            ShareClass.RunSqlCommand(strHQL);

            deTotalExpense = GetWorkflowTotalExpense(strWLID);
            strHQL = "Update T_WorkFlow Set Expense = " + deTotalExpense.ToString() + " Where WLID = " + strWLID;
            ShareClass.RunSqlCommand(strHQL);

            if (strRelatedType == "Plan")
            {
                strHQL = "update T_ImplePlan Set Expense = " + ShareClass.GetTotalRealExpenseByPlan(strRelatedID);
                strHQL += " Where ID = " + strRelatedID;

                ShareClass.RunSqlCommand(strHQL);
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //取得流程审批记录的费用总额
    public static decimal GetWorkflowStepDetailTotalExpense(string strID)
    {
        string strHQL;

        strHQL = "Select COALESCE(Sum(ConfirmAmount),0) From T_ProExpense Where WorkflowID = " + strID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProExpense");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 0;
        }
    }

    //取得流程的费用总额
    public static decimal GetWorkflowTotalExpense(string strWLID)
    {
        string strHQL;

        strHQL = "Select COALESCE(Sum(Expense),0) From T_WorkFlowStepDetail Where WLID = " + strWLID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStepDetail");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 0;
        }
    }

    public static string GetProjectAllowPMChangeStatus(string strProjectID)
    {
        string strHQL;
        string strAllowPMChangeStatus;

        strHQL = "Select AllowPMChangeStatus From T_Project Where ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
        if (ds.Tables[0].Rows.Count > 0)
        {
            strAllowPMChangeStatus = ds.Tables[0].Rows[0][0].ToString().Trim();
            return strAllowPMChangeStatus;
        }
        else
        {
            return "NO";
        }
    }

    //取得计划负责人名称
    public static string getProjectPlanLeaderName(string strPlanID)
    {
        string strHQL;

        strHQL = "Select Leader From T_ImplePlan Where ID = " + strPlanID;
        DataSet ds = CoreShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");

        try
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                return ds.Tables[0].Rows[0][0].ToString().Trim();
            }
            else
            {
                return "";
            }
        }
        catch
        {
            return "";
        }
    }

    //把负责人代码为空更新为不为空
    public static void UpdateProjectWorkPlanLeaderCodeToNotNull(string strProjectID, string strVerID)
    {
        string strHQL;
        string strPMCode, strPMName;

        strHQL = "Update T_ImplePlan Set LeaderCode = F_GetUserCodeByUserName(Leader) Where ProjectID = " + strProjectID + " and VerID = " + strVerID + " and COALESCE(LeaderCode,'') = ''";
        ShareClass.RunSqlCommand(strHQL);

        strPMCode = ShareClass.GetProjectPMCode(strProjectID);
        strPMName = ShareClass.GetUserName(strPMCode);

        strHQL = "Update T_ImplePlan Set Leader = '" + strPMName + "',LeaderCode = '" + strPMCode + "'  Where ProjectID = " + strProjectID + " and VerID = " + strVerID + " and LeaderCode = 'SAMPLE'";
        ShareClass.RunSqlCommand(strHQL);
    }

    //只有立项者，项目经理，计划创建员，才能分派计划资源
    public static bool CheckUserCanAssignRecourceForPlan(string strPlanID, string strCurrentUserCode)
    {
        string strHQL;
        string strVerID;

        try
        {
            string strProjectID = ShareClass.getProjectIDByPlanID(strPlanID);
            strVerID = getProjectWorkPlanVerIDByPlanID(strPlanID);

            string strPlanVerType, strPlanCreatorCode;

            strPlanCreatorCode = GetProjectPlanCreatorCode(strPlanID);

            strHQL = "Select Type From T_ProjectPlanVersion Where ProjectID = " + strProjectID + " and VerID = " + strVerID;
            DataSet ds0 = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectPlanVersion");
            strPlanVerType = ds0.Tables[0].Rows[0][0].ToString().Trim();

            if (strPlanVerType != "Baseline")
            {
                strHQL = "Select * From T_Project Where ProjectID = " + strProjectID;
                strHQL += " and (PMCode = " + "'" + strCurrentUserCode + "'";
                strHQL += " or UserCode = " + "'" + strCurrentUserCode + "')";
                DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

                strHQL = "Select * From T_RelatedUser Where ProjectID = " + strProjectID;
                strHQL += " and CanUpdatePlan = 'YES'";
                strHQL += " and UserCode = " + "'" + strCurrentUserCode + "'";
                DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");

                if (ds1.Tables[0].Rows.Count > 0 | ds2.Tables[0].Rows.Count > 0 | strPlanCreatorCode == strCurrentUserCode)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                strHQL = "Select * From T_Project Where ProjectID = " + strProjectID;
                strHQL += " and UserCode = " + "'" + strCurrentUserCode + "'";
                DataSet ds3 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
                if (ds3.Tables[0].Rows.Count > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
        catch
        {
            return false;
        }
    }

    //只有立项者，项目经理，计划创建员，项目负责人，计划负责人才能发起流程和任务
    public static bool CheckUserCanControlProjectPlan(string strPlanID, string strCurrentUserCode)
    {
        string strHQL;
        string strVerID;

        try
        {
            string strProjectID = ShareClass.getProjectIDByPlanID(strPlanID);
            strVerID = ShareClass.getProjectWorkPlanVerIDByPlanID(strPlanID);

            string strPlanVerType, strPlanCreatorCode, strPlanLeaderCode, strPlanLeaderName, strCurrentUserName, strDepartString;

            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strCurrentUserCode);
            strPlanCreatorCode = ShareClass.GetProjectPlanCreatorCode(strPlanID);
            strPlanLeaderCode = ShareClass.GetProjectPlanLeaderCode(strPlanID);
            strPlanLeaderName = ShareClass.GetProjectPlanLeaderName(strPlanID);
            strCurrentUserName = ShareClass.GetUserName(strCurrentUserCode);

            strHQL = "Select Type From T_ProjectPlanVersion Where ProjectID = " + strProjectID + " and VerID = " + strVerID;
            DataSet ds0 = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectPlanVersion");
            strPlanVerType = ds0.Tables[0].Rows[0][0].ToString().Trim();

            if (strPlanVerType != "Baseline")
            {
                strHQL = "Select * From T_Project Where ProjectID = " + strProjectID;
                strHQL += " and (PMCode = " + "'" + strCurrentUserCode + "'";
                strHQL += " or UserCode = " + "'" + strCurrentUserCode + "')";
                DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

                strHQL = "Select * From T_RelatedUser Where ProjectID = " + strProjectID;
                strHQL += " and CanUpdatePlan = 'YES'";
                strHQL += " and UserCode = " + "'" + strCurrentUserCode + "'";
                DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");

                strHQL = "Select * from T_Project ";
                strHQL += " Where ProjectID = " + strProjectID + " and PMCode in (select UnderCode from T_MemberLevel where ProjectVisible = 'YES' and UserCode = " + "'" + strCurrentUserCode + "'" + ")";
                DataSet ds3 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

                strHQL = "Select * from T_Project ";
                strHQL += " Where ProjectID = " + strProjectID + " and PMCode in (Select UserCode From T_ProjectMember Where DepartCode in " + strDepartString + ")";
                DataSet ds4 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

                if (ds1.Tables[0].Rows.Count > 0 | ds2.Tables[0].Rows.Count > 0 | ds3.Tables[0].Rows.Count > 0 | ds4.Tables[0].Rows.Count > 0 | strPlanCreatorCode == strCurrentUserCode | strPlanLeaderCode == strCurrentUserCode | strPlanLeaderName == strCurrentUserName)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                strHQL = "Select * From T_Project Where ProjectID = " + strProjectID;
                strHQL += " and UserCode = " + "'" + strCurrentUserCode + "'";
                DataSet ds3 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
                if (ds3.Tables[0].Rows.Count > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
        catch
        {
            return false;
        }
    }

    //只有立项者，项目经理，计划创建员，项目负责人，计划负责人才能浏览计划数据
    public static bool CheckUserCanViewProjectPlan(string strPlanID, string strCurrentUserCode)
    {
        string strHQL;
        string strVerID;

        try
        {
            string strProjectID = ShareClass.getProjectIDByPlanID(strPlanID);
            strVerID = ShareClass.getProjectWorkPlanVerIDByPlanID(strPlanID);

            string strPlanVerType, strPlanCreatorCode, strPlanLeaderCode, strPlanLeaderName, strCurrentUserName, strDepartString;

            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strCurrentUserCode);
            strPlanCreatorCode = ShareClass.GetProjectPlanCreatorCode(strPlanID);
            strPlanLeaderCode = ShareClass.GetProjectPlanLeaderCode(strPlanID);
            strPlanLeaderName = ShareClass.GetProjectPlanLeaderName(strPlanID);
            strCurrentUserName = ShareClass.GetUserName(strCurrentUserCode);

            strHQL = "Select Type From T_ProjectPlanVersion Where ProjectID = " + strProjectID + " and VerID = " + strVerID;
            DataSet ds0 = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectPlanVersion");
            strPlanVerType = ds0.Tables[0].Rows[0][0].ToString().Trim();

            if (strPlanVerType != "Baseline")
            {
                strHQL = "Select * From T_Project Where ProjectID = " + strProjectID;
                strHQL += " and (PMCode = " + "'" + strCurrentUserCode + "'";
                strHQL += " or UserCode = " + "'" + strCurrentUserCode + "')";
                DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

                strHQL = "Select * From T_RelatedUser Where ProjectID = " + strProjectID;
                strHQL += " and CanUpdatePlan = 'YES'";
                strHQL += " and UserCode = " + "'" + strCurrentUserCode + "'";
                DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");

                strHQL = "Select * from T_Project ";
                strHQL += " Where ProjectID = " + strProjectID + " and PMCode in (select UnderCode from T_MemberLevel where ProjectVisible = 'YES' and UserCode = " + "'" + strCurrentUserCode + "'" + ")";
                DataSet ds3 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

                strHQL = "Select * from T_Project ";
                strHQL += " Where ProjectID = " + strProjectID + " and PMCode in (Select UserCode From T_ProjectMember Where DepartCode in " + strDepartString + ")";
                DataSet ds4 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

                if (ds1.Tables[0].Rows.Count > 0 | ds2.Tables[0].Rows.Count > 0 | ds3.Tables[0].Rows.Count > 0 | ds4.Tables[0].Rows.Count > 0 | strPlanCreatorCode == strCurrentUserCode | strPlanLeaderCode == strCurrentUserCode | strPlanLeaderName == strCurrentUserName)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                strHQL = "Select * From T_Project Where ProjectID = " + strProjectID;
                strHQL += " and UserCode = " + "'" + strCurrentUserCode + "'";
                DataSet ds3 = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
                if (ds3.Tables[0].Rows.Count > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
        catch
        {
            return false;
        }
    }

    //取得计划创建者
    public static string GetProjectPlanCreatorCode(string strPlanID)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkPlan as workPlan where workPlan.ID = " + strPlanID;
        WorkPlanBLL workPlanBLL = new WorkPlanBLL();
        lst = workPlanBLL.GetAllWorkPlans(strHQL);

        WorkPlan workPlan = (WorkPlan)lst[0];

        return workPlan.CreatorCode.Trim();
    }

    //取得任务关联计划的计划的负责人代码
    public static string GetProjectPlanLeaderCode(string strPlanID)
    {
        string strHQL;
        string strLeaderCode;

        strHQL = "Select LeaderCode From T_ImplePlan Where ID = " + strPlanID;

        try
        {
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");
            strLeaderCode = ds.Tables[0].Rows[0][0].ToString().Trim();

            return strLeaderCode;
        }
        catch
        {
            return "";
        }
    }

    //取得任务内容
    public static string GetProjectPlanDetail(string strPlanID)
    {
        string strHQL;
        string strPlanDetail;

        strHQL = "Select Name From T_ImplePlan Where ID = " + strPlanID;

        try
        {
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");
            strPlanDetail = ds.Tables[0].Rows[0][0].ToString().Trim();

            return strPlanDetail;
        }
        catch
        {
            return "";
        }
    }

    //取得任务关联计划的计划的负责人名称
    public static string GetProjectPlanLeaderName(string strPlanID)
    {
        string strHQL;
        string strLeaderName;

        strHQL = "Select Leader From T_ImplePlan Where ID = " + strPlanID;

        try
        {
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");
            strLeaderName = ds.Tables[0].Rows[0][0].ToString().Trim();

            return strLeaderName;
        }
        catch
        {
            return "";
        }
    }

    //依计划号取得此计划的版本号
    public static string getProjectWorkPlanVerIDByPlanID(string strPlanID)
    {
        string strHQL;

        strHQL = "Select VerID From T_ImplePlan Where ID = " + strPlanID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");

        return ds.Tables[0].Rows[0][0].ToString().Trim();
    }

    //取得项目计划最大的版本号
    public static string GetLargestProjectPlanVerID(string strProjectID)
    {
        string strHQL;

        strHQL = "Select Max(VerID) from T_ImplePlan Where ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得版本号ID
    public static int GetProjectPlanVersionID(string strProjectID, string strType)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectPlanVersion as projectPlanVersion where projectPlanVersion.ProjectID = " + strProjectID + " and projectPlanVersion.Type = " + "'" + strType + "'";

        ProjectPlanVersionBLL projectPlanVersionBLL = new ProjectPlanVersionBLL();
        lst = projectPlanVersionBLL.GetAllProjectPlanVersions(strHQL);

        if (lst.Count > 0)
        {
            ProjectPlanVersion projectPlanVersion = (ProjectPlanVersion)lst[0];
            return projectPlanVersion.ID;
        }
        else
        {
            return 0;
        }
    }

    //依计划类型取得版本号
    public static int GetProjectPlanVersionIDByType(string strProjectID, string strType)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectPlanVersion as projectPlanVersion where projectPlanVersion.ProjectID = " + strProjectID + " and projectPlanVersion.Type = " + "'" + strType + "'";

        ProjectPlanVersionBLL projectPlanVersionBLL = new ProjectPlanVersionBLL();
        lst = projectPlanVersionBLL.GetAllProjectPlanVersions(strHQL);

        if (lst.Count > 0)
        {
            ProjectPlanVersion projectPlanVersion = (ProjectPlanVersion)lst[0];
            return projectPlanVersion.VerID;
        }
        else
        {
            return 0;
        }
    }

    //取得版本号
    public static int GetProjectPlanVerID(string strProjectID, string strType)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectPlanVersion as projectPlanVersion where projectPlanVersion.ProjectID = " + strProjectID + " and projectPlanVersion.Type = " + "'" + strType + "'";

        ProjectPlanVersionBLL projectPlanVersionBLL = new ProjectPlanVersionBLL();
        lst = projectPlanVersionBLL.GetAllProjectPlanVersions(strHQL);

        if (lst.Count > 0)
        {
            ProjectPlanVersion projectPlanVersion = (ProjectPlanVersion)lst[0];
            return projectPlanVersion.VerID;
        }
        else
        {
            return 0;
        }
    }

    //取得项目计划相关的项目ID号
    public static string getProjectIDByPlanID(string strPlanID)
    {
        string strHQL;

        strHQL = "Select ProjectID From T_ImplePlan Where ID = " + strPlanID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");

        return ds.Tables[0].Rows[0][0].ToString().Trim();
    }

    //更新任务的工时和费用
    public static void UpdateTaskExpenseManHourSummary(string strTaskID)
    {
        string strHQL;
        IList lst;
        decimal deExpenseSum = 0, deManHourSum = 0;

        strHQL = "from TaskAssignRecord as taskAssignRecord where taskAssignRecord.TaskID = " + strTaskID;
        TaskAssignRecordBLL taskAssignRecordBLL = new TaskAssignRecordBLL();
        lst = taskAssignRecordBLL.GetAllTaskAssignRecords(strHQL);

        TaskAssignRecord taskAssignRecord = new TaskAssignRecord();

        for (int i = 0; i < lst.Count; i++)
        {
            taskAssignRecord = (TaskAssignRecord)lst[i];

            deExpenseSum += taskAssignRecord.Expense;
            deManHourSum += taskAssignRecord.ManHour;
        }

        strHQL = "from ProjectTask as projectTask where projectTask.TaskID = " + strTaskID;
        ProjectTaskBLL projectTaskBLL = new ProjectTaskBLL();
        lst = projectTaskBLL.GetAllProjectTasks(strHQL);
        ProjectTask projectTask = (ProjectTask)lst[0];

        projectTask.Expense = deExpenseSum;
        projectTask.RealManHour = deManHourSum;

        projectTaskBLL.UpdateProjectTask(projectTask, projectTask.TaskID);
    }

    //当更改任务进度
    public static decimal UpdateTaskProgress(string strTaskID)
    {
        string strHQL;
        decimal deProgress = 0;

        try
        {
            strHQL = "Select avg(FinishPercent) From T_TaskAssignRecord Where TaskID = " + strTaskID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_TaskAssignRecord");

            if (ds.Tables[0].Rows.Count > 0)
            {
                deProgress = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                deProgress = 0;
            }

            strHQL = "Update T_ProjectTask Set FinishPercent = " + deProgress.ToString();
            strHQL += " Where TaskID = " + strTaskID;
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
        }

        return deProgress;
    }

    //更新工作流关联项目计划完成程度
    public static void UpdateProjectPlanSchedule(string strRelatedType, string strRelatedID)
    {
        try
        {
            if (strRelatedType == "Plan")
            {
                UpdateTaskOrWorkflowPlanProgressAndExpenseWorkHour(strRelatedID);
            }
        }
        catch
        {
        }
    }

    //依计划相关工作流和任务，更新项目此计划进度和总进度
    public static void UpdateTaskOrWorkflowPlanProgressAndExpenseWorkHour(string strPlanID)
    {
        string strHQL;
        string strProjectID, strVerID;
        decimal deProgress = 0, deProjectProgress = 0;

        try
        {
            strProjectID = ShareClass.getProjectIDByPlanID(strPlanID);
            strVerID = ShareClass.getProjectWorkPlanVerIDByPlanID(strPlanID);

            deProgress = ShareClass.GetTaskOrWorkflowPlanProgress(strPlanID);

            strHQL = "Update T_ImplePlan Set Percent_Done = " + deProgress.ToString();
            strHQL += " Where ID = " + strPlanID;
            ShareClass.RunSqlCommand(strHQL);

            strHQL = "Select COALESCE(Avg(Percent_Done),0) From T_ImplePlan Where ProjectID = " + strProjectID + " And VerID = " + strVerID;
            strHQL += " and ID Not In (Select COALESCE(ParentID,0) From T_ImplePlan Where ProjectID = " + strProjectID + " And VerID = " + strVerID + ")";
            strHQL += " and Parent_ID > 0";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");
            deProjectProgress = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());

            strHQL = "Update T_ImplePlan Set Percent_Done = " + deProjectProgress.ToString();
            strHQL += " Where Parent_ID = 0 and ProjectID =" + strProjectID + " and VerID = " + strVerID;
            ShareClass.RunSqlCommand(strHQL);

            //如果任务是项目计划产生的，那么更改计划工时和费用
            strHQL = "update T_ImplePlan Set ActualHour = " + ShareClass.GetTotalRealManHourByPlan(strPlanID);
            strHQL += ",Expense = " + ShareClass.GetTotalRealExpenseByPlan(strPlanID);
            strHQL += " Where ID = " + strPlanID;
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //取得关联任务的未完成量
    public static decimal GetTaskUnFinishedNumber(string strTaskID)
    {
        string strHQL;

        strHQL = "Select (RequireNumber -FinishedNumber) as UnFinishedNumber From T_ ProjectTask Where TaskID = " + strTaskID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectTask");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 0;
        }
    }

    //当更改任务完成量
    public static decimal UpdateTaskFinishedNumber(string strTaskID)
    {
        string strHQL;
        decimal deFinishedNumber = 0;

        try
        {
            strHQL = "Select Sum(FinishedNumber) From T_TaskAssignRecord Where TaskID = " + strTaskID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_TaskAssignRecord");

            if (ds.Tables[0].Rows.Count > 0)
            {
                deFinishedNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                deFinishedNumber = 0;
            }

            strHQL = "Update T_ProjectTask Set FinishedNumber = " + deFinishedNumber.ToString();
            strHQL += " Where TaskID = " + strTaskID;
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
        }

        return deFinishedNumber;
    }

    //更新工作流关联项目计划已完成量
    public static void UpdateProjectPlanFinishedNumber(string strRelatedType, string strRelatedID)
    {
        try
        {
            if (strRelatedType == "Plan")
            {
                UpdateTaskPlanFinishedNumber(strRelatedID);
            }
        }
        catch
        {
        }
    }

    //依计划相关任务，更新项目此计划的已完成量
    public static void UpdateTaskPlanFinishedNumber(string strPlanID)
    {
        string strHQL;
        decimal deFinishedNumber = 0;

        try
        {
            strHQL = "Select sum(COALESCE(FinishedNumber,0)) From T_ProjectTask Where PlanID = " + strPlanID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectTask");
            if (ds.Tables[0].Rows.Count > 0)
            {
                deFinishedNumber = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                deFinishedNumber = 0;
            }

            strHQL = "Update T_ImplePlan Set FinishedNumber = " + deFinishedNumber.ToString();
            strHQL += " Where ID = " + strPlanID;
            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
        }
    }


    //如果流程是由项目或项目计划发起的，那么增加项目日志到项目中
    public static void UpdateProjectDaiyWorkByWorkflow(string strRelatedType, string strRelatedID, string strWLID, string strContent, string strUserCode)
    {
        if (strRelatedType == "Project" || strRelatedType == "Plan")
        {
            string strProjectID;
            string strWorkflowName;



            try
            {
                strWorkflowName = ShareClass.GetWorkFlowName(strWLID);

                if (strRelatedType == "Project")
                {
                    ShareClass.UpdateDailyWork(strUserCode, strRelatedID, "Workflow", strWLID, strWorkflowName, strContent);
                }
                if (strRelatedType == "Plan")
                {
                    strProjectID = ShareClass.getProjectIDByPlanID(strRelatedID);
                    if (strProjectID != "")
                    {
                        ShareClass.UpdateDailyWork(strUserCode, strProjectID, "Workflow", strWLID, strWorkflowName, strContent);
                    }
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }
    }

    //取得关联任务和流程的计划总进度
    public static decimal GetTaskOrWorkflowPlanProgress(string strPlanID)
    {
        decimal deProgress, deTaskProgress, deWorkflowProgress;

        deTaskProgress = GetTaskPlanProgress(strPlanID);
        deWorkflowProgress = GetWorkflowtPlanProgress(strPlanID);

        if (deTaskProgress == 0 | deWorkflowProgress == 0)
        {
            deProgress = deTaskProgress + deWorkflowProgress;
        }
        else
        {
            deProgress = (deTaskProgress + deWorkflowProgress) / 2;
        }

        return deProgress;
    }

    //取得计划相关任务进度
    public static decimal GetTaskPlanProgress(string strPlanID)
    {
        string strHQL;
        decimal deTaskProgress;

        try
        {
            strHQL = "Select avg(COALESCE(FinishPercent,0)) From T_ProjectTask Where PlanID = " + strPlanID;
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectTask");
            if (ds.Tables[0].Rows.Count > 0)
            {
                deTaskProgress = decimal.Parse(ds.Tables[0].Rows[0][0].ToString());
            }
            else
            {
                deTaskProgress = 0;
            }

            return deTaskProgress;
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);

            return 0;
        }
    }

    //取得计划相关工作流的平均进度
    public static decimal GetWorkflowtPlanProgress(string strPlanID)
    {
        string strHQL1, strHQL;
        DataSet ds1, ds;

        string strWLID, strStepID, strTemName;
        int intSortNumber, i = 0;
        decimal deTotalFinishPercent = 0;

        try
        {
            strHQL = "Select WLID From T_WorkFlowStep Where WLID In ( Select WLID From T_WorkFlow Where RelatedType = 'Plan' and RelatedID = " + strPlanID + ")";
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStep");

            for (i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                strWLID = ds.Tables[0].Rows[i][0].ToString();
                strHQL1 = "Select max(StepID) From T_WorkFlowStep Where Status = 'Passed' and WLID = " + strWLID;
                ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_WorkflowStep");
                if (ds1.Tables[0].Rows.Count > 0)
                {
                    strStepID = ds1.Tables[0].Rows[0][0].ToString().Trim();
                    if (strStepID.Length > 0)
                    {
                        intSortNumber = ShareClass.GetWorkFlowCurrentStepSortNumber(strStepID);
                        strTemName = ShareClass.GetWorkflowTemNameByWLID(strWLID);

                        deTotalFinishPercent += ShareClass.GetWorkFlowTStep(strTemName, intSortNumber).FinishPercent;
                    }
                }
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                return deTotalFinishPercent / ds.Tables[0].Rows.Count;
            }
            else
            {
                return 0;
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
            return 0;
        }
    }

    //取得项目进度，工时，费用的相关数据，用于项目经理
    public static string getCurrentDateTaskTotalForPM(string strProjectID, string strUserCode, string strWorkDate)
    {
        return LanguageHandle.GetWord("DangRiRenWu").ToString().Trim() + ":" + LanguageHandle.GetWord("JingDu").ToString().Trim() + ":" + getCurrentDateTotalProgressForPM(strProjectID) + "%," + LanguageHandle.GetWord("ManHour").ToString().Trim() + ":" + getCurrentDateTotalManHourByOneOperator(strProjectID, strUserCode, strWorkDate) + "," + LanguageHandle.GetWord("FeiYong").ToString().Trim() + ":" + getCurrentDateTotalExpenseByOneOperator(strProjectID, strUserCode, strWorkDate);
    }

    //取得项目进度，工时，费用的相关数据，用于项目成员
    public static string getCurrentDateTaskTotalForMember(string strProjectID, string strUserCode, string strWorkDate)
    {
        return LanguageHandle.GetWord("DangRiRenWu").ToString().Trim() + ":" + LanguageHandle.GetWord("JingDu").ToString().Trim() + ":" + getCurrentDateTotalProgressForMember(strProjectID, strUserCode) + "%," + LanguageHandle.GetWord("ManHour").ToString().Trim() + ":" + getCurrentDateTotalManHourByOneOperator(strProjectID, strUserCode, strWorkDate) + "," + LanguageHandle.GetWord("FeiYong").ToString().Trim() + ":" + getCurrentDateTotalExpenseByOneOperator(strProjectID, strUserCode, strWorkDate);
    }

    //取得项目至当日时的总进度，用于项目经理
    public static string getCurrentDateTotalProgressForPM(string strProjectID)
    {
        if (decimal.Parse(getCurrentDateTaskTotalProgressForPM(strProjectID)) == 0 || decimal.Parse(getCurrentDateWorkflowTotalProgressForPM(strProjectID)) == 0)
        {
            return (decimal.Parse(getCurrentDateTaskTotalProgressForPM(strProjectID)) + decimal.Parse(getCurrentDateWorkflowTotalProgressForPM(strProjectID))).ToString();
        }
        else
        {
            return ((decimal.Parse(getCurrentDateTaskTotalProgressForPM(strProjectID)) + decimal.Parse(getCurrentDateWorkflowTotalProgressForPM(strProjectID))) / 2).ToString();
        }
    }

    //取得项目至当日时的总进度，用于项目成员
    public static string getCurrentDateTotalProgressForMember(string strProjectID, string strUserCode)
    {
        if (decimal.Parse(getCurrentDateTaskTotalProgressForMember(strProjectID, strUserCode)) == 0 || decimal.Parse(getCurrentDateWorkflowTotalProgressForMember(strProjectID, strUserCode)) == 0)
        {
            return (decimal.Parse(getCurrentDateTaskTotalProgressForMember(strProjectID, strUserCode)) + decimal.Parse(getCurrentDateWorkflowTotalProgressForMember(strProjectID, strUserCode))).ToString();
        }
        else
        {
            return ((decimal.Parse(getCurrentDateTaskTotalProgressForMember(strProjectID, strUserCode)) + decimal.Parse(getCurrentDateWorkflowTotalProgressForMember(strProjectID, strUserCode))) / 2).ToString();
        }
    }

    //取得当日实施项目总工时
    public static string getCurrentDateTotalManHourByOneOperator(string strProjectID, string strUserCode, string strWorkDate)
    {
        string strHQL;
        DataSet ds1, ds2;

        strHQL = "Select COALESCE(Sum(ManHour),0) From T_TaskAssignRecord Where ID In ";
        strHQL += "(Select ID from T_TaskAssignRecord ";
        strHQL += " where ((TaskID in (select TaskID from T_ProjectTask where ProjectID = " + strProjectID + ")) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where PlanID In (Select ID From T_ImplePlan Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where ReqID In (Select ReqID From T_RelatedReq Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where DefectID In (Select DefectID From T_RelatedDefect Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where RiskID In (Select ID From T_ProjectRisk Where ProjectID = " + strProjectID + ")))) ";
        strHQL += " and OperatorCode = " + "'" + strUserCode + "'";
        strHQL += " and to_char(MakeDate,'yyyymmdd') = " + "'" + strWorkDate + "')";

        ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_TaskAssignRecord");

        strHQL = "Select COALESCE(Sum(ManHour),0) From T_WorkFlowStepDetail Where WLID In ";
        strHQL += " (Select WLID From T_WorkFlow Where ((RelatedType = 'Project' and RelatedID = " + strProjectID + ")";
        strHQL += " Or (RelatedType = 'Plan' and RelatedID In (Select ID From T_ImplePlan Where ProjectID = " + strProjectID + "))))";
        strHQL += " and OperatorCode = " + "'" + strUserCode + "'";
        strHQL += " and to_char(CheckingTime,'yyyymmdd') = " + "'" + strWorkDate + "'";

        ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStepDetail");

        return (decimal.Parse(ds1.Tables[0].Rows[0][0].ToString()) + decimal.Parse(ds2.Tables[0].Rows[0][0].ToString())).ToString();
    }

    //取得当日实施项目总费用
    public static string getCurrentDateTotalExpenseByOneOperator(string strProjectID, string strUserCode, string strWorkDate)
    {
        string strHQL;
        DataSet ds1, ds2;

        strHQL = "Select COALESCE(Sum(Expense),0) From T_TaskAssignRecord Where ID In ";
        strHQL += "(Select ID from T_TaskAssignRecord ";
        strHQL += " where ((TaskID in (select TaskID from T_ProjectTask where ProjectID = " + strProjectID + ")) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where PlanID In (Select ID From T_ImplePlan Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where ReqID In (Select ReqID From T_RelatedReq Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where DefectID In (Select DefectID From T_RelatedDefect Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where RiskID In (Select ID From T_ProjectRisk Where ProjectID = " + strProjectID + ")))) ";
        strHQL += " and OperatorCode = " + "'" + strUserCode + "'";
        strHQL += " and to_char(MakeDate,'yyyymmdd') = " + "'" + strWorkDate + "')";
        ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_TaskAssignRecord");

        strHQL = "Select COALESCE(Sum(Expense),0) From T_WorkFlowStepDetail Where WLID In ";
        strHQL += " (Select WLID From T_WorkFlow Where ((RelatedType = 'Project' and RelatedID = " + strProjectID + ")";
        strHQL += " Or (RelatedType = 'Plan' and RelatedID In (Select ID From T_ImplePlan Where ProjectID = " + strProjectID + "))))";
        strHQL += " and OperatorCode = " + "'" + strUserCode + "'";
        strHQL += " and to_char(CheckingTime,'yyyymmdd') = " + "'" + strWorkDate + "'";

        ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStepDetail");

        return (decimal.Parse(ds1.Tables[0].Rows[0][0].ToString()) + decimal.Parse(ds2.Tables[0].Rows[0][0].ToString())).ToString();
    }

    //取得当日实施项目任务总进度，用于项目经理
    public static string getCurrentDateTaskTotalProgressForPM(string strProjectID)
    {
        string strHQL;
        DataSet ds1;

        strHQL = "Select COALESCE(Avg(FinishPercent),0) From T_TaskAssignRecord Where ID In ";
        strHQL += "(Select ID from T_TaskAssignRecord ";
        strHQL += " where ((TaskID in (select TaskID from T_ProjectTask where ProjectID = " + strProjectID + ")) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where PlanID In (Select ID From T_ImplePlan Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where ReqID In (Select ReqID From T_RelatedReq Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where DefectID In (Select DefectID From T_RelatedDefect Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where RiskID In (Select ID From T_ProjectRisk Where ProjectID = " + strProjectID + "))))) ";
        ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_TaskAssignRecord");

        if (ds1.Tables[0].Rows.Count > 0)
        {
            return ds1.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得当日实施项目总进度，用于项目成员
    public static string getCurrentDateTaskTotalProgressForMember(string strProjectID, string strUserCode)
    {
        string strHQL;
        DataSet ds1;

        strHQL = "Select COALESCE(Avg(FinishPercent),0) From T_TaskAssignRecord Where ID In ";
        strHQL += "(Select ID from T_TaskAssignRecord ";
        strHQL += " where ((TaskID in (select TaskID from T_ProjectTask where ProjectID = " + strProjectID + ")) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where PlanID In (Select ID From T_ImplePlan Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where ReqID In (Select ReqID From T_RelatedReq Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where DefectID In (Select DefectID From T_RelatedDefect Where ProjectID = " + strProjectID + "))) ";
        strHQL += " Or (TaskID in (select TaskID from T_ProjectTask where RiskID In (Select ID From T_ProjectRisk Where ProjectID = " + strProjectID + ")))) ";
        strHQL += " and OperatorCode = " + "'" + strUserCode + "')";
        ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_TaskAssignRecord");

        if (ds1.Tables[0].Rows.Count > 0)
        {
            return ds1.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得计划相关工作流的平均进度，用于项目经理
    public static string getCurrentDateWorkflowTotalProgressForPM(string strProjectID)
    {
        string strHQL1, strHQL;
        DataSet ds1, ds;

        string strWLID, strStepID, strTemName;
        int intSortNumber, i = 0;
        decimal deTotalFinishPercent = 0;

        try
        {
            strHQL = string.Format(@" Select Distinct WLID From T_WorkFlowStep Where WLID In 
                ((Select WLID From T_WorkFlow Where RelatedType = 'Plan' and RelatedID In (Select ID From T_ImplePlan Where ProjectID = {0}))
                 UNION 
                 (Select WLID From T_WorkFlow Where RelatedType = 'Project' and RelatedID = {0}))", strProjectID);
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStep");

            for (i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                strWLID = ds.Tables[0].Rows[i][0].ToString();
                strHQL1 = "Select max(StepID) From T_WorkFlowStep Where Status = 'Passed' and WLID = " + strWLID;
                ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_WorkflowStep");
                if (ds1.Tables[0].Rows.Count > 0)
                {
                    strStepID = ds1.Tables[0].Rows[0][0].ToString().Trim();
                    if (strStepID.Length > 0)
                    {
                        intSortNumber = ShareClass.GetWorkFlowCurrentStepSortNumber(strStepID);
                        strTemName = ShareClass.GetWorkflowTemNameByWLID(strWLID);

                        deTotalFinishPercent += ShareClass.GetWorkFlowTStep(strTemName, intSortNumber).FinishPercent;

                    }
                }

            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                return (deTotalFinishPercent / ds.Tables[0].Rows.Count).ToString();
            }
            else
            {
                return "0";
            }
        }
        catch
        {
            return "0";
        }
    }

    //取得计划相关工作流的平均进度，用于项目成员
    public static string getCurrentDateWorkflowTotalProgressForMember(string strProjectID, string strUserCode)
    {
        string strHQL1, strHQL;
        DataSet ds1, ds;

        string strWLID, strStepID, strTemName;
        int intSortNumber, i = 0;
        decimal deTotalFinishPercent = 0;

        try
        {
            strHQL = string.Format(@"SELECT Distinct WLID 
                    FROM T_WorkFlowStep 
                    WHERE WLID IN (
                        SELECT WLID FROM T_WorkFlow 
                        WHERE RelatedType = 'Plan' 
                        AND RelatedID IN (SELECT ID FROM T_ImplePlan WHERE ProjectID = {0})
    
                        UNION
    
                        SELECT WLID FROM T_WorkFlow 
                        WHERE RelatedType = 'Project' 
                        AND RelatedID = {0}
                    ) 
                    AND StepID IN (
                        SELECT StepID FROM T_WorkflowStepDetail 
                        WHERE OperatorCode = '{1}'
                    )", strProjectID, strUserCode);

            ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStep");

            for (i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                strWLID = ds.Tables[0].Rows[i][0].ToString();
                strHQL1 = "Select max(StepID) From T_WorkFlowStep Where Status = 'Passed' and WLID = " + strWLID;
                ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_WorkflowStep");
                if (ds1.Tables[0].Rows.Count > 0)
                {
                    strStepID = ds1.Tables[0].Rows[0][0].ToString().Trim();
                    if (strStepID.Length > 0)
                    {
                        intSortNumber = ShareClass.GetWorkFlowCurrentStepSortNumber(strStepID);
                        strTemName = ShareClass.GetWorkflowTemNameByWLID(strWLID);
                        deTotalFinishPercent += ShareClass.GetWorkFlowTStep(strTemName, intSortNumber).FinishPercent;
                    }
                }
            }

            if (ds.Tables[0].Rows.Count > 0)
            {
                return (deTotalFinishPercent / ds.Tables[0].Rows.Count).ToString();
            }
            else
            {
                return "0";
            }
        }
        catch
        {
            return "0";
        }
    }

    //取得周末开始时间
    public static string GetWeekendFirstDay()
    {
        string strHQL;

        strHQL = "Select WeekendFirstDay From T_WorkingDayRule";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkingDayRule");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "6";
        }
    }

    //取得周末结束时间
    public static string GetWeekendSecondDay()
    {
        string strHQL;

        strHQL = "Select WeekendSecondDay From T_WorkingDayRule";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkingDayRule");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得周末是否工作日
    public static string GetWeekendsAreWorkdays()
    {
        string strHQL;

        strHQL = "Select WeekendsAreWorkdays From T_WorkingDayRule";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkingDayRule");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "false";
        }
    }

    //依招标类型添加关联的工作流模板
    public static string AddRelatedWorkFlowTemplateByBMBidType(string strBMBidType, string strBMBidPlanID)
    {
        string strHQL;

        strHQL = "Insert Into T_RelatedWorkFlowTemplate(RelatedType,RelatedID,WFTemplateName,IdentifyString,RelatedName)";
        strHQL += " Select 'BMBidType'," + strBMBidPlanID + ",WFTemplateName,IdentifyString,RelatedName From T_RelatedWorkFlowTemplate";
        strHQL += " Where RelatedType = 'BMBidType' and RelatedName = '" + strBMBidType + "'";
        strHQL += " and WFTemplateName Not In (Select WFTemplateName From T_RelatedWorkFlowTemplate Where RelatedType = 'BMBidType' and RelatedID = " + strBMBidPlanID + ")";
        ShareClass.RunSqlCommand(strHQL);

        return strHQL;
    }

    //依项目类型添加关联的工作流模板
    public static void AddRelatedWorkFlowTemplateByProjectType(string strRelatedType, string strRelatedID, string strKeyWord, string strKeyType, string strKeyRelatedType)
    {
        string strHQL;


        strHQL = "Insert Into T_RelatedWorkFlowTemplate(RelatedType,RelatedID,WFTemplateName,IdentifyString,RelatedName)";
        strHQL += " Select '" + strKeyWord + "'," + strRelatedID + ",WFTemplateName,IdentifyString,RelatedName From T_RelatedWorkFlowTemplate";
        strHQL += " Where RelatedType = '" + strKeyRelatedType + "' and RelatedName = '" + strRelatedType + "'";
        strHQL += " and WFTemplateName Not In (Select WFTemplateName From T_RelatedWorkFlowTemplate Where RelatedType = '" + strKeyWord + "' and RelatedID = " + strRelatedID + ")";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace + " Sql: " + strHQL);
        }
    }

    //依项目类型添加关联的文档模板
    public static void AddRelatedDocumentTemplateByProjectType(string strRelatedType, string strRelatedID, string strKeyWord, string strKeyType)
    {
        string strHQL;

        strHQL = "Insert Into T_Document(RelatedType,DocTypeID,DocType,RelatedID,DocName,Description,Address,Author,";
        strHQL += "DepartCode ,DepartName,UploadManCode,UploadManName,UploadTime,Visible  ,Status ,RelatedName)";
        strHQL += " Select '" + strKeyWord + "',DocTypeID,DocType," + strRelatedID + ",DocName,Description,Address,Author,";
        strHQL += "DepartCode ,DepartName,UploadManCode,UploadManName,UploadTime,Visible,Status,RelatedName";
        strHQL += " From T_Document";
        strHQL += " Where RelatedType = '" + strKeyType + "' and RelatedName = '" + strRelatedType + "'";
        strHQL += " and DocName Not In (Select DocName From T_Document Where RelatedType = '" + strKeyType + "' and RelatedID = " + strRelatedID + ")";

        try
        {
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace + " Sql : " + strHQL);
        }

    }

    //取得MRP计划单据类型
    public static string GetRelatedBusinessTypeAndName(string strRelatedType, string strRelatedID)
    {
        string strHQL;

        DataSet ds;

        strRelatedType = strRelatedType.Trim();

        if (strRelatedType != "Other")
        {
            if (strRelatedType == "SaleOrder")
            {
                try
                {
                    strHQL = "Select SOID,SOName From T_GoodsSaleOrder Where SOID = " + strRelatedID; ;
                    ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedBusinessObject");
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        return "SaleOrder: Name: " + ds.Tables[0].Rows[0][1].ToString().Trim();
                    }
                    else
                    {
                        return "SaleOrder:0";
                    }
                }
                catch
                {
                    return "SaleOrder:0";
                }
            }

            if (strRelatedType == "Project")
            {
                try
                {
                    strHQL = "Select ProjectID,ProjectName From T_Project Where ProjectID =" + strRelatedID; ;
                    ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedBusinessObject");
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        return "Project: Name: " + ds.Tables[0].Rows[0][1].ToString().Trim();
                    }
                    else
                    {
                        return "Project:0";
                    }
                }
                catch
                {
                    return "Project:0";
                }
            }

            return "Other:0";
        }
        else
        {
            return "Other:0";
        }
    }

    //取得MRP计划单据类型
    public static string GetMRPFormTypeAndName(string strSourceType, string strSourceRecordID)
    {
        string strHQL;

        DataSet ds;

        strSourceType = strSourceType.Trim();

        if (strSourceType != "Other")
        {
            if (strSourceType == "GoodsSORecord")
            {
                strHQL = "Select SOID,SOName From T_GoodsSaleOrder Where SOID in (Select SOID From T_GoodsSaleRecord Where ID = " + strSourceRecordID + ")";
                ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedBusinessObject");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return "SaleOrder: ID: " + ds.Tables[0].Rows[0][0].ToString().Trim() + " Name: " + ds.Tables[0].Rows[0][1].ToString().Trim();
                }
                else
                {
                    return "SaleOrder:0";
                }
            }

            if (strSourceType == "GoodsAORecord")
            {
                strHQL = "Select AAID,GAAName From T_GoodsApplication Where AAID in (Select AAID From T_GoodsApplicationDetail Where ID = " + strSourceRecordID + ")";
                ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedBusinessObject");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return "SaleApplication:ID: " + ds.Tables[0].Rows[0][0].ToString().Trim() + " Name: " + ds.Tables[0].Rows[0][1].ToString().Trim();
                }
                else
                {
                    return "SaleApplication:0";
                }
            }

            if (strSourceType == "GoodsPJRecord")
            {
                strHQL = "Select ProjectID,ProjectName From T_Project Where ProjectID in (Select ProjectID From T_ProjectRelatedItem Where ID = " + strSourceRecordID + ")";
                ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedBusinessObject");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return "Project:ID: " + ds.Tables[0].Rows[0][0].ToString().Trim() + " Name: " + ds.Tables[0].Rows[0][1].ToString().Trim();
                }
                else
                {
                    return "Project:0";
                }
            }

            return "Other:0";
        }
        else
        {
            return "Other:0";
        }
    }

    //取得其它共用状态的本语
    public static string GetStatusHomeNameByOtherStatus(string strStatus)
    {
        string strHQL;
        string strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strHQL = "Select HomeName From T_OtherStatus Where Status = " + "'" + strStatus.Trim() + "'";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_OtherStatus");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return strStatus;
        }
    }

    //取得计划状态的本语
    public static string GetStatusHomeNameByPlanStatus(string strStatus)
    {
        string strHQL;
        string strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strHQL = "Select HomeName From T_PlanStatus Where Status = " + "'" + strStatus.Trim() + "'";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_PlanStatus");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return strStatus;
        }
    }

    //取得需求状态的本语
    public static string GetStatusHomeNameByRequirementStatus(string strStatus)
    {
        string strHQL;
        string strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strHQL = "Select HomeName From T_ReqStatus Where Status = " + "'" + strStatus.Trim() + "'";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_RequireStatus");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return strStatus;
        }
    }

    //取得需求状态的本语
    public static string GetStatusHomeNameByDefectmentStatus(string strStatus)
    {
        string strHQL;
        string strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strHQL = "Select HomeName From T_DefectStatus Where Status = " + "'" + strStatus.Trim() + "'";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_DefectStatus");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return strStatus;
        }
    }

    //取得工作流状态的本语
    public static string GetStatusHomeNameByTaskStatus(string strStatus)
    {
        string strHQL;
        string strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strHQL = "Select HomeName From T_TaskStatus Where Status = " + "'" + strStatus.Trim() + "'";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_TaskStatus");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return strStatus;
        }
    }

    //取得工作流状态的本语
    public static string GetStatusHomeNameByWorkflowStatus(string strStatus)
    {
        string strHQL;
        string strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strHQL = "Select HomeName From T_WLStatus Where Status = " + "'" + strStatus.Trim() + "'";
        strHQL += " and LangCode = " + "'" + strLangCode + "'";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkflowStatus");

        if (ds.Tables[0].Rows.Count > 0)
        {

            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return strStatus;
        }
    }

    //判断是否时是超时自动审批通过的步骤
    public static string GetWorkflowStepStatusByAuto(string strStepID)
    {
        string strHQL;

        strHQL = "Select * From T_ApproveFlow Where StepID = " + strStepID + " and UserName = 'Timer'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ApproveFlow");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return LanguageHandle.GetWord("CaoShi").ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    //判断是否时是超时自动审批通过的工作流
    public static string GetWorkflowStatusByAuto(string strWLID)
    {
        string strHQL;

        strHQL = "Select * From T_ApproveFlow Where Type = 'Workflow' and RelatedID = " + strWLID + " and UserName = 'Timer'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ApproveFlow");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return LanguageHandle.GetWord("CaoShi").ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    //取得项目状态的本语
    public static string GetStatusHomeNameByProjectStatus(string strStatus, string strProjectType)
    {
        string strHQL;
        string strLangCode;

        strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        strHQL = string.Format(@"Select HomeName From T_ProjectStatus Where Status = '{0}' and LangCode = '{1}' and ProjectType = '{2}'", strStatus.Trim(), strLangCode, strProjectType.Trim());
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectStatus");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return strStatus;
        }
    }

    //检查用户是否是项目项目成员
    public static bool CheckUserIsProjectMember(string strProjectID, string strUserCode)
    {
        string strHQL;

        strHQL = "Select * From T_RelatedUser Where ProjectID = " + strProjectID + " And UserCode = '" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //检查用户是否是项目经理
    public static bool CheckUserIsProjectManager(string strProjectID, string strUserCode)
    {
        string strHQL;

        strHQL = "Select * From T_Project Where PMCode = '" + strUserCode + "'" + " and ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //检查用户是否是立项者
    public static bool CheckUserIsProjectCreator(string strProjectID, string strUserCode)
    {
        string strHQL;

        strHQL = "Select * From T_Project Where UserCode = '" + strUserCode + "'" + " and ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //检查用户是否能改项目计划
    public static bool CheckMemberCanUpdatePlanByUserCode(string strProjectID, string strUserCode)
    {
        string strHQL;

        strHQL = "Select * From T_RelatedUser Where UserCode = " + "'" + strUserCode + "'" + " and ProjectID = " + strProjectID;
        strHQL += " and (UserCode in (Select PMCode From T_Project Where ProjectID = " + strProjectID + ")";
        strHQL += " or UserCode in (Select UserCode From T_Project Where ProjectID = " + strProjectID + ")";
        strHQL += " Or CanUpdatePlan = 'YES')";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //取得项目成员列表
    public static void LoadProjectMember(string strProjectID, DropDownList DL_OperatorCode)
    {
        string strHQL;

        strHQL = "Select UserCode,UserName From T_RelatedUser Where ProjectID = " + strProjectID;

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");
        DL_OperatorCode.DataSource = ds;
        DL_OperatorCode.DataBind();

        DL_OperatorCode.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //取得项目成员和下属成员的列表
    public static void LoadProjectMemberAndDirectMember(string strProjectID, string strUserCode, DropDownList DL_OperatorCode)
    {
        string strHQL;

        string strOperatorCode, strOperatorName;
        strOperatorCode = HttpContext.Current.Session["UserCode"].ToString();
        strOperatorName = ShareClass.GetUserName(strUserCode);

        strHQL = "Select distinct UserCode,UserName From T_ProjectMember Where UserCode in (Select UnderCode From T_MemberLevel Where Usercode = " + "'" + strUserCode + "'" + ")";
        if (strProjectID != null | strProjectID != "")
        {
            strHQL += " Or UserCode in ( Select UserCode From T_RelatedUser Where ProjectID = " + strProjectID + ")";
        }
        strHQL += " and UserCode <> '" + strOperatorCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_RelatedUser");
        DL_OperatorCode.DataSource = ds;
        DL_OperatorCode.DataBind();

        DL_OperatorCode.Items.Insert(0, new ListItem(strOperatorName, strOperatorCode));
    }

    //取得下属成员列表
    public static void LoadMemberList(string strUserCode, DropDownList DL_OperatorCode)
    {
        string strHQL;

        string strOperatorCode, strOperatorName;
        strOperatorCode = HttpContext.Current.Session["UserCode"].ToString();
        strOperatorName = ShareClass.GetUserName(strUserCode);

        string strSystemVersionType, strProductType;

        strSystemVersionType = HttpContext.Current.Session["SystemVersionType"].ToString();
        strProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];
        if (strProductType == "LOCALSAAS" | strProductType == "SERVERSAAS")
        {
            strHQL = string.Format(@"Select Distinct UserCode,UserName From(Select OperatorCode as UserCode,OperatorName as UserName ,1 as SortNumber From T_TaskAssignRecord Where AssignManCode = '{0}'
                 Union Select UserCode, UserName, 2 as SortNumber From T_ProjectMember Where UserCode Not In(Select OperatorCode From T_TaskAssignRecord Where AssignManCode = '{0}')) A
                 ", strUserCode);
        }
        else
        {
            strHQL = "Select Distinct UserCode, UserName From T_ProjectMember Where UserCode in (select UnderCode from T_MemberLevel  where UserCode = " + "'" + strUserCode + "')";
            strHQL += "and UserCode <> '" + strOperatorCode + "'";
        }

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
        DL_OperatorCode.DataSource = ds;
        DL_OperatorCode.DataBind();

        DL_OperatorCode.Items.Insert(0, new ListItem(strOperatorName, strOperatorCode));
    }

    public static void LoadTaskType(DropDownList DL_Type)
    {
        string strHQL;
        IList lst;

        strHQL = "from TaskType as taskType order by taskType.SortNumber ASC";
        TaskTypeBLL taskTypeBLL = new TaskTypeBLL();
        lst = taskTypeBLL.GetAllTaskTypes(strHQL);
        DL_Type.DataSource = lst;
        DL_Type.DataBind();
        //DL_Type.Items.Insert(0, new ListItem("--Select--", ""));
    }

    public static void LoadTaskStatus(DropDownList DL_Status, string strLangCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from TaskStatus as taskStatus";
        strHQL += " Where taskStatus.LangCode = " + "'" + strLangCode + "'";
        strHQL += " order by taskStatus.SortNumber ASC";
        TaskStatusBLL taskStatusBLL = new TaskStatusBLL();
        lst = taskStatusBLL.GetAllTaskStatuss(strHQL);
        DL_Status.DataSource = lst;
        DL_Status.DataBind();
    }

    public static void LoadTaskWorkRequest(DropDownList DL_WorkRequest)
    {
        string strHQL;
        IList lst;

        strHQL = "from TaskOperation as taskOperation order by taskOperation.SortNumber ASC";
        TaskOperationBLL taskOperationBLL = new TaskOperationBLL();
        lst = taskOperationBLL.GetAllTaskOperations(strHQL);
        DL_WorkRequest.DataSource = lst;
        DL_WorkRequest.DataBind();

        DL_WorkRequest.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //取得任务记录类型列表
    public static void LoadTaskRecordType(DropDownList DL_RecordType)
    {
        string strHQL;

        strHQL = "Select Type From T_TaskRecordType Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_TaskRecordType");

        DL_RecordType.DataSource = ds;
        DL_RecordType.DataBind();

        //DL_RecordType.Items.Insert(0, new ListItem("--Select--", ""));
    }

    //取得当前时间项目应完成的进度
    public static int GetProjectDefaultFinishPercent(string strProjectID)
    {
        string strHQL;
        int intVerID;
        string strWidth;
        int intDefaultSchedule = 0, intRealSchedule = 0;

        intVerID = GetProjectPlanVersionVerID(strProjectID, "Baseline");

        if (intVerID > 0)
        {
            DataSet ds;

            strHQL = "Select DefaultSchedule From T_ImplePlan Where ProjectID = " + strProjectID + " And VerID = " + intVerID.ToString();
            strHQL += " And  End_Date <= now()";
            strHQL += " Order By DefaultSchedule DESC limit 1 ";
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strWidth = ds.Tables[0].Rows[0][0].ToString().Trim();

                try
                {
                    intDefaultSchedule = Decimal.ToInt32(decimal.Parse(strWidth));
                }
                catch (OverflowException e)
                {
                    intDefaultSchedule = 0;
                }
            }
            else
            {
                intDefaultSchedule = 0;
            }

            strHQL = string.Format(@"Select Percent_Done From T_ImplePlan Where Parent_ID = 0 and ProjectID = {0}
                       and VerID In(Select VerID From T_ProjectPlanVersion Where ProjectID = {0} and Type = 'Baseline')", strProjectID);
            ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strWidth = ds.Tables[0].Rows[0][0].ToString().Trim();

                try
                {
                    intRealSchedule = Decimal.ToInt32(decimal.Parse(strWidth));
                }
                catch (OverflowException e)
                {
                    intRealSchedule = 0;
                }
            }
            else
            {
                intRealSchedule = 0;
            }

            if (intDefaultSchedule > intRealSchedule)
            {
                return intDefaultSchedule;
            }
            else
            {
                return intRealSchedule;
            }
        }
        else
        {
            return 0;
        }
    }

    //取得当前时间项目应完成的成本
    public static Decimal GetProjectDefaultFinishCost(string strProjectID)
    {
        string strHQL;
        int intVerID;
        string strCost;

        intVerID = GetProjectPlanVersionVerID(strProjectID, "Baseline");

        if (intVerID > 0)
        {
            strHQL = "Select DefaultCost From T_ImplePlan Where ProjectID = " + strProjectID + " And VerID = " + intVerID.ToString();
            strHQL += " And  End_Date <= now()";
            strHQL += " Order By DefaultCost DESC limit 1";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ImplePlan");

            if (ds.Tables[0].Rows.Count > 0)
            {
                strCost = ds.Tables[0].Rows[0][0].ToString().Trim();

                try
                {
                    return Decimal.ToInt32(decimal.Parse(strCost));
                }
                catch (OverflowException e)
                {
                    // decimal 值超出int值范围
                    return 0;
                }
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }

    //取得项目活动计划版本的版本号
    public static int GetProjectPlanVersionVerID(string strProjectID, string strType)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectPlanVersion as projectPlanVersion where projectPlanVersion.ProjectID = " + strProjectID + " and projectPlanVersion.Type = " + "'" + strType + "'";

        ProjectPlanVersionBLL projectPlanVersionBLL = new ProjectPlanVersionBLL();
        lst = projectPlanVersionBLL.GetAllProjectPlanVersions(strHQL);

        if (lst.Count > 0)
        {
            ProjectPlanVersion projectPlanVersion = (ProjectPlanVersion)lst[0];
            return projectPlanVersion.VerID;
        }
        else
        {
            return 0;
        }
    }

    //判断是否存在同代码项目
    public static int GetProjecCountByProjectCodeAndID(string strProjectCode, string strProjectID)
    {
        string strHQL;

        strHQL = "Select ProjectName From T_Project Where ProjectCode = " + "'" + strProjectCode + "'" + " and  ProjectID <> " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        return ds.Tables[0].Rows.Count;
    }

    //取得项目直接发起的工作流的实际工时
    public static string GetTotalRealManHourByProjectWorkflowStepDetail(string strWLID, string strWorkDate)
    {
        string strHQL;
        DataSet ds2;

        strHQL = "Select COALESCE(Sum(ManHour),0) From T_WorkFlowStepDetail Where WLID = " + strWLID;
        strHQL += " and to_char(CheckingTime,'yyyymmdd') = '" + strWorkDate + "'";
        ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStepDetail");

        return decimal.Parse(ds2.Tables[0].Rows[0][0].ToString()).ToString();
    }

    //取得项目直接发起的工作流的实际费用
    public static string GetTotalRealExpenseByProjectWorkflowStepDetail(string strWLID, string strWorkDate)
    {
        string strHQL;
        DataSet ds2;

        strHQL = "Select COALESCE(Sum(Expense),0) From T_WorkFlowStepDetail Where WLID = " + strWLID;
        strHQL += " and to_char(CheckingTime,'yyyymmdd') = '" + strWorkDate + "'";
        ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStepDetail");

        return decimal.Parse(ds2.Tables[0].Rows[0][0].ToString()).ToString();
    }

    //取得计划相关任务和工作流的实际工时
    public static string GetTotalRealManHourByPlan(string strPlanID)
    {
        string strHQL;

        DataSet ds1, ds2;

        strHQL = "Select COALESCE(Sum(RealManHour),0) From T_ProjectTask Where PlanID = " + strPlanID;
        ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectTask");

        strHQL = "Select COALESCE(Sum(ManHour),0) From T_WorkFlow Where RelatedType = 'Plan' and RelatedID = " + strPlanID;
        ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");

        return (decimal.Parse(ds1.Tables[0].Rows[0][0].ToString()) + decimal.Parse(ds2.Tables[0].Rows[0][0].ToString())).ToString();
    }

    //取得计划相关任务和工作流的实际费用
    public static string GetTotalRealExpenseByPlan(string strPlanID)
    {
        string strHQL;

        DataSet ds1, ds2;

        strHQL = "Select COALESCE(Sum(Expense),0) From T_ProjectTask Where PlanID = " + strPlanID;
        ds1 = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectTask");

        strHQL = "Select COALESCE(Sum(Expense),0) From T_WorkFlow Where RelatedType = 'Plan' and RelatedID = " + strPlanID;
        ds2 = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlow");

        return (decimal.Parse(ds1.Tables[0].Rows[0][0].ToString()) + decimal.Parse(ds2.Tables[0].Rows[0][0].ToString())).ToString();
    }

    public static void AddConstractPayAmountToProExpense(string strProjectID, string strPayID, string strAccountCode, string strAccount, string strDecription, decimal deAmount, string strCurrencyType, string strUserCode, string strUserName)
    {
        string strProjectCurrency;
        decimal deProjectCurrencyExchangeRate = 1, deConstractCurrencyExchangeRate = 1;

        ProExpenseBLL proExpenseBLL = new ProExpenseBLL();
        ProExpense proExpense = new ProExpense();

        strProjectCurrency = ShareClass.GetProject(strProjectID).CurrencyType.Trim();
        deProjectCurrencyExchangeRate = ShareClass.GetExchangeRateByCurrencyType(strProjectCurrency);

        deConstractCurrencyExchangeRate = ShareClass.GetExchangeRateByCurrencyType(strCurrencyType);

        proExpense.ProjectID = int.Parse(strProjectID);
        proExpense.TaskID = 0;
        proExpense.RecordID = 0;
        proExpense.BMPUPayID = int.Parse(strPayID);
        proExpense.UserCode = strUserCode;
        proExpense.UserName = strUserName;
        proExpense.AccountCode = strAccountCode;
        proExpense.Account = strAccount;
        proExpense.Description = strDecription;
        proExpense.Amount = (deAmount * deConstractCurrencyExchangeRate) / deProjectCurrencyExchangeRate;
        proExpense.ConfirmAmount = (deAmount * deConstractCurrencyExchangeRate) / deProjectCurrencyExchangeRate;
        proExpense.CurrencyType = strProjectCurrency;
        proExpense.EffectDate = DateTime.Now;
        proExpense.RegisterDate = DateTime.Now;
        proExpense.FinancialStaffCode = "";
        proExpense.FinancialStaffName = "";

        try
        {
            proExpenseBLL.AddProExpense(proExpense);
        }
        catch
        {
        }
    }

    public static void UpdateConstractPayAmountToProExpense(string strProjectID, string strPayID, string strAccountCode, string strAccount, string strDecription, decimal deAmount, string strCurrencyType, string strUserCode, string strUserName)
    {
        string strHQL;

        strHQL = "Delete From T_ProExpense Where ConstractPayID = " + strPayID;
        ShareClass.RunSqlCommand(strHQL);

        ProExpenseBLL proExpenseBLL = new ProExpenseBLL();
        ProExpense proExpense = new ProExpense();

        proExpense.ProjectID = int.Parse(strProjectID);
        proExpense.TaskID = 0;
        proExpense.RecordID = 0;
        proExpense.BMPUPayID = int.Parse(strPayID);
        proExpense.UserCode = strUserCode;
        proExpense.UserName = strUserName;
        proExpense.AccountCode = strAccountCode;
        proExpense.Account = strAccount;
        proExpense.CurrencyType = strCurrencyType;
        proExpense.Description = strDecription;
        proExpense.Amount = deAmount;
        proExpense.ConfirmAmount = deAmount;
        proExpense.EffectDate = DateTime.Now;
        proExpense.RegisterDate = DateTime.Now;
        proExpense.FinancialStaffCode = "";
        proExpense.FinancialStaffName = "";

        try
        {
            proExpenseBLL.AddProExpense(proExpense);
        }
        catch
        {
        }
    }

    #endregion 项目相关操作函数

}
