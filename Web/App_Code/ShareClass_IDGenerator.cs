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
/// ShareClass partial - IDGenerator
/// </summary>
public static partial class ShareClass
{
    
    #region 取得用户创建的对象的最大ID号

    //取得用户创建的模组最大模组号
    public static string GetMyCreatedMaxModuleID()
    {
        string strHQL;

        strHQL = "Select max(ID) From T_ProModuleLevel ";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的项目最大项目号
    public static string GetMyCreatedMaxUserLoginManageID()
    {
        string strHQL;

        strHQL = "Select max(ID) From T_UserLoginManage ";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_UserLoginManage");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大分析图形号
    public static string GetMyCreatedMaxSystemAnalystChartID()
    {
        string strHQL;

        strHQL = "Select max(ID) From T_SystemAnalystChartManagement ";

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemAnalystChartManagement");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的项目最大项目号
    public static string GetMyCreatedMaxProjectID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from Project as project where project.UserCode = " + "'" + strUserCode + "'" + " Order by project.ProjectID DESC";
        ProjectBLL projectBLL = new ProjectBLL();
        lst = projectBLL.GetAllProjects(strHQL);

        Project project = (Project)lst[0];

        return project.ProjectID.ToString();
    }

    //取得用户创建的需求最大需求号
    public static string GetMyCreatedMaxDefectID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from Defectment as defectment where defectment.ApplicantCode = " + "'" + strUserCode + "'" + " Order by defectment.DefectID DESC";
        DefectmentBLL defectmentBLL = new DefectmentBLL();
        lst = defectmentBLL.GetAllDefectments(strHQL);

        Defectment defectment = (Defectment)lst[0];

        return defectment.DefectID.ToString();
    }

    //取得用户创建的需求最大需求号
    public static string GetMyCreatedMaxReqID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from Requirement as requirement where requirement.ApplicantCode = " + "'" + strUserCode + "'" + " Order by requirement.ReqID DESC";
        RequirementBLL requirementBLL = new RequirementBLL();
        lst = requirementBLL.GetAllRequirements(strHQL);

        Requirement requirement = (Requirement)lst[0];

        return requirement.ReqID.ToString();
    }

    //取得用户创建的会议最大会议号
    public static string GetMyCreatedMaxMeetingID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from Meeting as meeting where meeting.BuilderCode = " + "'" + strUserCode + "'" + " Order by meeting.ID DESC";
        MeetingBLL meetingBLL = new MeetingBLL();
        lst = meetingBLL.GetAllMeetings(strHQL);

        Meeting meeting = (Meeting)lst[0];

        return meeting.ID.ToString();
    }

    //取得用户创建的最大会议室编号
    public static string GetMyCreatedMaxMeetingRoomID()
    {
        string strHQL;
        IList lst;

        strHQL = "from MeetingRoom as meetingRoom";
        MeetingRoomBLL meetingRoomBLL = new MeetingRoomBLL();
        lst = meetingRoomBLL.GetAllMeetingRooms(strHQL);

        MeetingRoom meetingRoom = (MeetingRoom)lst[0];

        return meetingRoom.ID.ToString();
    }

    //取得用户创建的最大项目任务号:
    public static string GetMyCreatedMaxTaskID(string strProjectID, string strUserCode)
    {
        string strHQL = "from ProjectTask as projectTask where projectTask.ProjectID = " + strProjectID + " Order by projectTask.TaskID DESC";

        ProjectTaskBLL projectTaskBLL = new ProjectTaskBLL();
        IList lst = projectTaskBLL.GetAllProjectTasks(strHQL);

        ProjectTask projectTask = (ProjectTask)lst[0];

        return projectTask.TaskID.ToString();
    }

    //取得用户创建的最大项目风险号:
    public static string GetMyCreatedMaxRiskID(string strProjectID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectRisk as projectRisk where projectRisk.ProjectID = " + strProjectID + " order by projectRisk.ID DESC";
        ProjectRiskBLL projectRiskBLL = new ProjectRiskBLL();
        lst = projectRiskBLL.GetAllProjectRisks(strHQL);

        ProjectRisk projectRisk = (ProjectRisk)lst[0];

        return projectRisk.ID.ToString();
    }

    //取得用户创建的最大项目分派记录号:
    public static string GetMyCreatedMaxTaskAssignRecordID(string strTaskID, string strUserCode)
    {
        string strHQL = "from TaskAssignRecord as taskAssignRecord where taskAssignRecord.TaskID = " + strTaskID + " and taskAssignRecord.AssignManCode = " + "'" + strUserCode + "'" + " Order by taskAssignRecord.ID Desc";
        TaskAssignRecordBLL taskAssignRecordBLL = new TaskAssignRecordBLL();
        IList lst = taskAssignRecordBLL.GetAllTaskAssignRecords(strHQL);

        TaskAssignRecord taskAssignRecord = (TaskAssignRecord)lst[0];

        return taskAssignRecord.ID.ToString();
    }

    //取得用户创建的最大缺陷分派记录号:
    public static string GetMyCreatedMaxDefectAssignRecordID(string strDefectID, string strUserCode)
    {
        string strHQL = "from DefectAssignRecord as defectAssignRecord where defectAssignRecord.DefectID = " + strDefectID + " and defectAssignRecord.AssignManCode = " + "'" + strUserCode + "'" + " Order by defectAssignRecord.ID Desc";
        DefectAssignRecordBLL defectAssignRecordBLL = new DefectAssignRecordBLL();
        IList lst = defectAssignRecordBLL.GetAllDefectAssignRecords(strHQL);

        DefectAssignRecord defectAssignRecord = (DefectAssignRecord)lst[0];

        return defectAssignRecord.ID.ToString();
    }

    //取得用户创建的最大需求分派记录号:
    public static string GetMyCreatedMaxReqAssignRecordID(string strReqID, string strUserCode)
    {
        string strHQL = "from ReqAssignRecord as reqAssignRecord where reqAssignRecord.ReqID = " + strReqID + " and reqAssignRecord.AssignManCode = " + "'" + strUserCode + "'" + " Order by reqAssignRecord.ID Desc";
        ReqAssignRecordBLL reqAssignRecordBLL = new ReqAssignRecordBLL();
        IList lst = reqAssignRecordBLL.GetAllReqAssignRecords(strHQL);

        ReqAssignRecord reqAssignRecord = (ReqAssignRecord)lst[0];

        return reqAssignRecord.ID.ToString();
    }

    //取得用户创建的最大合同号
    public static string GetMyCreatedMaxConstractID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from Constract as constract where constract.RecorderCode = " + "'" + strUserCode + "'" + " Order by constract.ConstractID DESC";
        ConstractBLL constractBLL = new ConstractBLL();
        lst = constractBLL.GetAllConstracts(strHQL);

        Constract constract = (Constract)lst[0];

        return constract.ConstractID.ToString();
    }

    //取得用户创建的合同业务员最大的ID号
    public static string GetMyCreatedMaxConstractSalesID(string strConstractCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_ConstractSales Where ConstractCode = " + "'" + strConstractCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ConstractSales");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的合同变更后最大的ID号
    public static string GetMyCreatedMaxConstractChangeRecordID(string strConstractCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_ConstractChangeRecord Where ConstractCode = " + "'" + strConstractCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ConstractChangeRecord");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的合同报关单最大的ID号
    public static string GetMyCreatedMaxConstractEntryID(string strConstractCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_ConstractRelatedEntryOrder Where ConstractCode = " + "'" + strConstractCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ConstractRelatedEntryOrder");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大的合同付款号
    public static string GetMyCreatedMaxConstractPayableID(string strConstractCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractPayable as constractPayable where constractPayable.ConstractCode = " + "'" + strConstractCode + "'" + " Order by constractPayable.ID DESC";
        ConstractPayableBLL constractPayableBLL = new ConstractPayableBLL();
        lst = constractPayableBLL.GetAllConstractPayables(strHQL);

        ConstractPayable constractPayable = (ConstractPayable)lst[0];

        return constractPayable.ID.ToString();
    }

    //取得用户创建的最大的合同付款号
    public static string GetMyCreatedMaxConstractPayablePlanID(string strRelatedType, string strRelatedID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractPayable as constractPayable where constractPayable.RelatedType = " + "'" + strRelatedType + "'" + " and constractPayable.RelatedID = " + strRelatedID;
        strHQL += " Order By constractPayable.ID DESC";
        ConstractPayableBLL constractPayableBLL = new ConstractPayableBLL();
        lst = constractPayableBLL.GetAllConstractPayables(strHQL);

        ConstractPayable constractPayable = (ConstractPayable)lst[0];

        return constractPayable.ID.ToString();
    }

    //取得用户创建的最大的合同付款记录号
    public static string GetMyCreatedMaxConstractPayableRecordID(string strPayableID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractPayableRecord as constractPayableRecord where constractPayableRecord.PayableID = " + strPayableID + " Order by constractPayableRecord.ID DESC";
        ConstractPayableRecordBLL constractPayableRecordBLL = new ConstractPayableRecordBLL();
        lst = constractPayableRecordBLL.GetAllConstractPayableRecords(strHQL);

        ConstractPayableRecord constractPayableRecord = (ConstractPayableRecord)lst[0];

        return constractPayableRecord.ID.ToString();
    }

    //取得用户创建的最大的合同收款号
    public static string GetMyCreatedMaxConstractReceivableID(string strConstractCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractReceivables as constractReceivables where constractReceivables.ConstractCode = " + "'" + strConstractCode + "'" + "Order by constractReceivables.ID DESC";
        ConstractReceivablesBLL constractReceivablesBLL = new ConstractReceivablesBLL();
        lst = constractReceivablesBLL.GetAllConstractReceivabless(strHQL);

        ConstractReceivables constractReceivables = (ConstractReceivables)lst[0];

        return constractReceivables.ID.ToString();
    }

    //取得用户创建的最大的合同收款号
    public static string GetMyCreatedMaxConstractReceivablePlanID(string strRelatedType, string strRelatedID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractReceivables as constractReceivables where constractReceivables.RelatedType = " + "'" + strRelatedType + "'" + " and constractReceivables.RelatedID = " + strRelatedID;
        strHQL += " Order By constractReceivables.ID DESC";
        ConstractReceivablesBLL constractReceivablesBLL = new ConstractReceivablesBLL();
        lst = constractReceivablesBLL.GetAllConstractReceivabless(strHQL);

        ConstractReceivables constractReceivables = (ConstractReceivables)lst[0];

        return constractReceivables.ID.ToString();
    }

    //取得用户创建的最大的合同收款记录号
    public static string GetMyCreatedMaxConstractReceivableRecordID(string strReceivablesID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractReceivablesRecord as constractReceivablesRecord where constractReceivablesRecord.ReceivablesID = " + strReceivablesID + " Order by constractReceivablesRecord.ID DESC";
        ConstractReceivablesRecordBLL constractReceivablesRecordBLL = new ConstractReceivablesRecordBLL();
        lst = constractReceivablesRecordBLL.GetAllConstractReceivablesRecords(strHQL);

        ConstractReceivablesRecord constractReceivablesRecord = (ConstractReceivablesRecord)lst[0];

        return constractReceivablesRecord.ID.ToString();
    }

    //取得用户创建的最大协作号
    public static string GetMyCreatedMaxColloaborationID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(CoID) From T_Collaboration Where CreatorCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Collaboration");

        return ds.Tables[0].Rows[0][0].ToString().Trim();
    }

    //取得用户创建的短信编号
    public static string GetMyCreatedMaxSMSID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_SMSSendDIY Where UserCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SMSSendDIY");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得组织级信息推送的编号
    public static string GetMyCreatedMaxDepartmentMsgPushID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(MsgID) From T_DepartmentMsgPush Where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_DepartmentMsgPush");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大工作流编号
    public static string GetMyCreatedWorkFlowID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlow as workFlow where workFlow.CreatorCode = " + "'" + strUserCode + "'" + " Order by workFlow.WLID DESC";
        WorkFlowBLL workFlowBLL = new WorkFlowBLL();
        lst = workFlowBLL.GetAllWorkFlows(strHQL);

        WorkFlow workFlow = (WorkFlow)lst[0];

        return workFlow.WLID.ToString();
    }

    //取得用户创建的最大工作流步骤编号
    public static string GetMyCreatedWorkFlowStepID(string strWLID)
    {
        string strHQL;

        strHQL = "Select Max(StepID) From T_WorkFlowStep Where WLID = " + strWLID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WorkFlowStep");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得用户创建的最大工作流模板步骤号
    public static string GetMyCreatedWorkFlowTStepID(string strTemName)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlowTStep as workFlowTStep where workFlowTStep.TemName = " + "'" + strTemName + "'" + " Order by workFlowTStep.StepID DESC";
        WorkFlowTStepBLL workFlowTStepBLL = new WorkFlowTStepBLL();
        lst = workFlowTStepBLL.GetAllWorkFlowTSteps(strHQL);

        WorkFlowTStep workFlowTStep = (WorkFlowTStep)lst[0];

        return workFlowTStep.StepID.ToString();
    }

    //取得用户创建的最大工作流步骤细节号
    public static string GetMyCreatedMaxWorkFlowTStepOperatorID(string strStepID)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkFlowTStepOperator as workFlowTStepOperator where workFlowTStepOperator.StepID = " + strStepID + " Order by workFlowTStepOperator.ID DESC";
        WorkFlowTStepOperatorBLL workFlowTStepOperatorBLL = new WorkFlowTStepOperatorBLL();
        lst = workFlowTStepOperatorBLL.GetAllWorkFlowTStepOperators(strHQL);

        WorkFlowTStepOperator workFlowTStepOperator = (WorkFlowTStepOperator)lst[0];

        return workFlowTStepOperator.ID.ToString();
    }

    ////取得用户创建的最大工作流步骤操作号
    //public static string GetMyCreatedMaxWorkFlowTStepOperationID(string strStepID)
    //{
    //    string strHQL = "from WorkFlowTStepOperation as workFlowTStepOperation where workFlowTStepOperation.StepID = " + strStepID + " Order by workFlowTStepOperation.OperationID DESC";
    //    WorkFlowTStepOperationBLL workFlowTStepOperationBLL = new WorkFlowTStepOperationBLL();
    //    IList lst = workFlowTStepOperationBLL.GetAllWorkFlowTStepOperations(strHQL);

    //    WorkFlowTStepOperation workFlowTStepOperation = (WorkFlowTStepOperation)lst[0];

    //    return workFlowTStepOperation.OperationID.ToString();
    //}

    //取得用户创建的最大工作流模板XML节点关联变量ID号
    public static string GetMyCreatedMaxWFTemplateXMLNodeGlobalVariableID()
    {
        string strHQL;

        strHQL = "Select MAX(ID) From T_WFTemplateXMLNodeGlobalVariable";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WFTemplateXMLNodeGlobalVariable");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大工作流步骤条件号
    public static string GetMyCreatedMaxWorkFlowTStepConditionID()
    {
        string strHQL;
        IList lst;

        strHQL = "from WLTStepCondition as wlTStepCondition Order by wlTStepCondition.ConID DESC";
        WLTStepConditionBLL wlTStepConditionBLL = new WLTStepConditionBLL();
        lst = wlTStepConditionBLL.GetAllWLTStepConditions(strHQL);

        WLTStepCondition wlTStepCondition = (WLTStepCondition)lst[0];

        return wlTStepCondition.ConID.ToString();
    }

    //取得用户创建的最大工作流步骤条件表达式号
    public static string GetMyCreatedMaxWorkFlowTStepConditionExpressionID()
    {
        string strHQL;
        IList lst;

        strHQL = "from WLTStepConditionExpression as wlTStepConditionExpression Order by wlTStepConditionExpression.ID DESC";
        WLTStepConditionExpressionBLL wlTStepConditionExpressionBLL = new WLTStepConditionExpressionBLL();
        lst = wlTStepConditionExpressionBLL.GetAllWLTStepConditionExpressions(strHQL);

        WLTStepConditionExpression wlTStepConditionExpression = (WLTStepConditionExpression)lst[0];

        return wlTStepConditionExpression.ID.ToString();
    }

    //取得用户创建的最大工作流步骤条件表达式号
    public static string GetMyCreatedMaxWFTStepRelatedTem(string strStepID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From  T_WFTStepRelatedTem Where RelatedStepID = " + strStepID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_WFTStepRElatedTem");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大角色组成员号
    public static string GetMyCreatedMaxActorGroupDetailID(string strGroupName)
    {
        string strHQL;
        IList lst;

        strHQL = "from ActorGroupDetail as actorGroupDetail where actorGroupDetail.GroupName= " + "'" + strGroupName + "'" + " Order by actorGroupDetail.GroupID DESC";
        ActorGroupDetailBLL actorGroupDetailBLL = new ActorGroupDetailBLL();
        lst = actorGroupDetailBLL.GetAllActorGroupDetails(strHQL);

        ActorGroupDetail actorGroupDetail = (ActorGroupDetail)lst[0];

        return actorGroupDetail.GroupID.ToString();
    }

    public static string GetMyCreatedMaxSitemContentID()
    {
        string strHQL;
        IList lst;

        strHQL = "Select max(ID) From T_SiteModuleContent";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SiteModuleContent");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大项目成员ID号
    public static string GetMyCreatedMaxProjectRelatedUserID(string strProjectID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_RelatedUser Where ProjectID = " + strProjectID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_RelatedUser");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大项目费用号
    public static string GetMyCreatedMaxProExpenseID(string strProjectID, string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProExpense as proExpense where proExpense.ProjectID = " + strProjectID + " and proExpense.UserCode = " + "'" + strUserCode + "'" + " order by proExpense.ID DESC";
        ProExpenseBLL proExpenseBLL = new ProExpenseBLL();
        lst = proExpenseBLL.GetAllProExpenses(strHQL);

        ProExpense proExpense = (ProExpense)lst[0];

        return proExpense.ID.ToString();
    }

    //取得用户创建的最大项目费用号
    public static string GetMyCreatedMaxProBudgetID(string strProjectID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectBudget as projectBudget where projectBudget.ProjectID = " + strProjectID + " order by projectBudget.ID DESC";
        ProjectBudgetBLL projectBudgetBLL = new ProjectBudgetBLL();
        lst = projectBudgetBLL.GetAllProjectBudgets(strHQL);

        ProjectBudget projectBudget = (ProjectBudget)lst[0];

        return projectBudget.ID.ToString();
    }

    //取得用户创建的最大项目费用号
    public static string GetMyCreatedMaxAllProBudgetID(string strProjectID)
    {
        string strHQL;
        IList lst;

        strHQL = "Select Max(ID) from t_ProjectBudget where ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectBudgetByAll");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大项目计划号
    public static string GetMyCreatedMaxProPlanID(string strProjectID, string strVerID)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkPlan as workPlan where workPlan.ProjectID = " + strProjectID + " and workPlan.VerID = " + strVerID + " Order by workPlan.ID DESC";
        WorkPlanBLL workPlanBLL = new WorkPlanBLL();
        lst = workPlanBLL.GetAllWorkPlans(strHQL);

        WorkPlan workPlan = (WorkPlan)lst[0];

        return workPlan.ID.ToString();
    }

    //取得用户创建的项目计划成员的最大ID号
    public static string GetMyCreatedMaxPlanMemberID(string strPlanID)
    {
        string strHQL;
        IList lst;

        strHQL = "from PlanMember as planMember where planMember.PlanID = " + strPlanID + " Order by planMember.ID DESC";
        PlanMemberBLL planMemberBLL = new PlanMemberBLL();
        lst = planMemberBLL.GetAllPlanMembers(strHQL);

        PlanMember planMember = (PlanMember)lst[0];

        return planMember.ID.ToString();
    }

    //取得用户创建的费用申请最大ID号
    public static string GetMyCreatedMaxExpenseApplyWLID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ExpenseApplyWL as expenseApplyWL where  expenseApplyWL.ApplicantCode = " + "'" + strUserCode + "'" + " Order by expenseApplyWL.ID DESC";
        ExpenseApplyWLBLL expenseApplyWLBLL = new ExpenseApplyWLBLL();
        lst = expenseApplyWLBLL.GetAllExpenseApplyWLs(strHQL);

        ExpenseApplyWL expenseApplyWL = (ExpenseApplyWL)lst[0];

        return expenseApplyWL.ID.ToString();
    }

    //取得用户创建的费用报销最大ID号
    public static string GetMyCreatedMaxExpenseClaimWLID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ExpenseClaim as expenseClaim where expenseClaim.ApplicantCode=" + "'" + strUserCode + "'" + " Order by expenseClaim.ECID DESC";
        ExpenseClaimBLL expenseClaimBLL = new ExpenseClaimBLL();
        lst = expenseClaimBLL.GetAllExpenseClaims(strHQL);

        ExpenseClaim expenseClaim = (ExpenseClaim)lst[0];

        return expenseClaim.ECID.ToString();
    }

    //取得用户创建的费用报销名细的最大ID号
    public static string GetMyCreatedMaxExpenseClaimDetailID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_ExpenseClaimDetail Where UserCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ExpenseClaimDetail");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "0";
        }
    }

    //取得最大的测试用例号
    public static string GetMyCreatedMaxTaskTestCaseID()
    {
        string strHQL;
        IList lst;

        strHQL = "from TaskTestCase as taskTestCase Order by taskTestCase.ID DESC";
        TaskTestCaseBLL taskTestCaseBLL = new TaskTestCaseBLL();
        lst = taskTestCaseBLL.GetAllTaskTestCases(strHQL);

        TaskTestCase taskTestCase = (TaskTestCase)lst[0];

        return taskTestCase.ID.ToString();
    }

    //取得用户创建的资产采购单最大ID号
    public static string GetMyCreatedMaxAssetPurchaseOrderID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from AssetPurchaseOrder as assetPurchaseOrder where assetPurchaseOrder.OperatorCode = " + "'" + strUserCode + "'" + " Order by assetPurchaseOrder.POID DESC";
        AssetPurchaseOrderBLL assetPurchaseOrderBLL = new AssetPurchaseOrderBLL();
        lst = assetPurchaseOrderBLL.GetAllAssetPurchaseOrders(strHQL);

        AssetPurchaseOrder assetPurchaseOrder = (AssetPurchaseOrder)lst[0];

        return assetPurchaseOrder.POID.ToString();
    }

    //取得用户创建的项目物资费用申请单最大ID号
    public static string GetMyCreatedMaxProjectMaterialPaymentApplicantID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectMaterialPaymentApplicant as projectMaterialPaymentApplicant where projectMaterialPaymentApplicant.UserCode = " + "'" + strUserCode + "'" + " Order by projectMaterialPaymentApplicant.AOID DESC";
        ProjectMaterialPaymentApplicantBLL projectMaterialPaymentApplicantBLL = new ProjectMaterialPaymentApplicantBLL();
        lst = projectMaterialPaymentApplicantBLL.GetAllProjectMaterialPaymentApplicants(strHQL);

        ProjectMaterialPaymentApplicant projectMaterialPaymentApplicant = (ProjectMaterialPaymentApplicant)lst[0];

        return projectMaterialPaymentApplicant.AOID.ToString();
    }

    //取得用户创建的项目物资费用申请单明细最大ID号
    public static string GetMyCreatedMaxProjectMaterialPaymentApplicantDetailID(string strAOID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectMaterialPaymentApplicantDetail as projectMaterialPaymentApplicantDetail where projectMaterialPaymentApplicantDetail.AOID = " + "'" + strAOID + "'" + " Order by projectMaterialPaymentApplicantDetail.ID DESC";
        ProjectMaterialPaymentApplicantDetailBLL projectMaterialPaymentApplicantDetailBLL = new ProjectMaterialPaymentApplicantDetailBLL();
        lst = projectMaterialPaymentApplicantDetailBLL.GetAllProjectMaterialPaymentApplicantDetails(strHQL);

        ProjectMaterialPaymentApplicantDetail projectMaterialPaymentApplicantDetail = (ProjectMaterialPaymentApplicantDetail)lst[0];

        return projectMaterialPaymentApplicantDetail.ID.ToString();
    }

    //取得用户创建的资产费用申请单最大ID号
    public static string GetMyCreatedMaxSupplierAssetPaymentApplicantID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from SupplierAssetPaymentApplicant as supplierAssetPaymentApplicant where supplierAssetPaymentApplicant.UserCode = " + "'" + strUserCode + "'" + " Order by supplierAssetPaymentApplicant.AOID DESC";
        SupplierAssetPaymentApplicantBLL supplierAssetPaymentApplicantBLL = new SupplierAssetPaymentApplicantBLL();
        lst = supplierAssetPaymentApplicantBLL.GetAllSupplierAssetPaymentApplicants(strHQL);

        SupplierAssetPaymentApplicant supplierAssetPaymentApplicant = (SupplierAssetPaymentApplicant)lst[0];

        return supplierAssetPaymentApplicant.AOID.ToString();
    }

    //取得用户创建的资产费用申请单明细最大ID号
    public static string GetMyCreatedMaxSupplierAssetPaymentApplicantDetailID(string strAOID)
    {
        string strHQL;
        IList lst;

        strHQL = "from SupplierAssetPaymentApplicantDetail as supplierAssetPaymentApplicantDetail where supplierAssetPaymentApplicantDetail.AOID = " + "'" + strAOID + "'" + " Order by supplierAssetPaymentApplicantDetail.ID DESC";
        SupplierAssetPaymentApplicantDetailBLL supplierAssetPaymentApplicantDetailBLL = new SupplierAssetPaymentApplicantDetailBLL();
        lst = supplierAssetPaymentApplicantDetailBLL.GetAllSupplierAssetPaymentApplicantDetails(strHQL);

        SupplierAssetPaymentApplicantDetail supplierAssetPaymentApplicantDetail = (SupplierAssetPaymentApplicantDetail)lst[0];

        return supplierAssetPaymentApplicantDetail.ID.ToString();
    }

    //取得用户创建的物料采购单最大ID号
    public static string GetMyCreatedMaxGoodsPurchaseOrderID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from GoodsPurchaseOrder as goodsPurchaseOrder where goodsPurchaseOrder.OperatorCode = " + "'" + strUserCode + "'" + " Order by goodsPurchaseOrder.POID DESC";
        GoodsPurchaseOrderBLL goodsPurchaseOrderBLL = new GoodsPurchaseOrderBLL();
        lst = goodsPurchaseOrderBLL.GetAllGoodsPurchaseOrders(strHQL);

        GoodsPurchaseOrder goodsPurchaseOrder = (GoodsPurchaseOrder)lst[0];

        return goodsPurchaseOrder.POID.ToString();
    }

    //取得物料供货单的最大ID
    public static string GetMyCreatedMaxGoodsSupplyOrderID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(SUID) From T_GoodsSupplyOrder where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsSupplyOrder");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得物料生产单的最大ID
    public static string GetMyCreatedMaxGoodsProductionOrderID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(PDID) From T_GoodsProductionOrder where CreatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsProductionOrder");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得物料生产单明细的最大ID
    public static string GetMyCreatedMaxGoodsProductionOrderDetailID(string strPDID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsProductionOrderDetail Where PDID = " + strPDID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsProductionOrderDetail");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得资产入库单的最大ID
    public static string GetMyCreatedMaxAssetCheckInID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(CheckInID) From T_AssetCheckInOrder where CreatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_AssetCheckInOrder");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的资产采购明细最大ID号
    public static string GetMyCreatedMaxAssetPurRecordID(string strPOID)
    {
        string strHQL;
        IList lst;

        strHQL = "from AssetPurRecord as assetPurRecord where assetPurRecord.POID = " + "'" + strPOID + "'" + " Order by assetPurRecord.ID DESC";
        AssetPurRecordBLL assetPurRecordBLL = new AssetPurRecordBLL();
        lst = assetPurRecordBLL.GetAllAssetPurRecords(strHQL);

        AssetPurRecord assetPurRecord = (AssetPurRecord)lst[0];

        return assetPurRecord.ID.ToString();
    }

    //取得用户创建的物料采购明细最大ID号
    public static string GetMyCreatedMaxGoodsPurRecordID(string strPOID)
    {
        string strHQL;
        IList lst;

        strHQL = "from GoodsPurRecord as goodsPurRecord where goodsPurRecord.POID = " + "'" + strPOID + "'" + " Order by goodsPurRecord.ID DESC";
        GoodsPurRecordBLL goodsPurRecordBLL = new GoodsPurRecordBLL();
        lst = goodsPurRecordBLL.GetAllGoodsPurRecords(strHQL);

        GoodsPurRecord goodsPurRecord = (GoodsPurRecord)lst[0];

        return goodsPurRecord.ID.ToString();
    }

    //取得物料供货单明细的最大ID
    public static string GetMyCreatedMaxGoodsSupplyOrderDetailID(string strSUID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsSupplyOrderDetail Where SUID = " + strSUID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsSupplyOrderDetail");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的合同物料明细表最大ID号
    public static string GetMyCreatedMaxConstractRelatedGoodsID(string strConstractCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractRelatedGoods as constractRelatedGoods where constractRelatedGoods.ConstractCode = " + "'" + strConstractCode + "'" + " Order by constractRelatedGoods.ID DESC";
        ConstractRelatedGoodsBLL constractRelatedGoodsBLL = new ConstractRelatedGoodsBLL();
        lst = constractRelatedGoodsBLL.GetAllConstractRelatedGoodss(strHQL);

        ConstractRelatedGoods constractRelatedGoods = (ConstractRelatedGoods)lst[0];

        return constractRelatedGoods.ID.ToString();
    }

    //取得用户创建的客户物料明细表最大ID号
    public static string GetMyCreatedMaxCustomerRelatedGoodsInforID(string strCustomerCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from CustomerRelatedGoodsInfor as customerRelatedGoodsInfor where customerRelatedGoodsInfor.CustomerCode = " + "'" + strCustomerCode + "'" + " Order by customerRelatedGoodsInfor.ID DESC";
        CustomerRelatedGoodsInforBLL customerRelatedGoodsInforBLL = new CustomerRelatedGoodsInforBLL();
        lst = customerRelatedGoodsInforBLL.GetAllCustomerRelatedGoodsInfors(strHQL);

        CustomerRelatedGoodsInfor customerRelatedGoodsInfor = (CustomerRelatedGoodsInfor)lst[0];

        return customerRelatedGoodsInfor.ID.ToString();
    }

    //取得用户创建的供应商物料明细表最大ID号
    public static string GetMyCreatedMaxVendorRelatedGoodsInforID(string strVendorCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from VendorRelatedGoodsInfor as vendorRelatedGoodsInfor where vendorRelatedGoodsInfor.VendorCode = " + "'" + strVendorCode + "'" + " Order by vendorRelatedGoodsInfor.ID DESC";
        VendorRelatedGoodsInforBLL vendorRelatedGoodsInforBLL = new VendorRelatedGoodsInforBLL();
        lst = vendorRelatedGoodsInforBLL.GetAllVendorRelatedGoodsInfors(strHQL);

        VendorRelatedGoodsInfor vendorRelatedGoodsInfor = (VendorRelatedGoodsInfor)lst[0];

        return vendorRelatedGoodsInfor.ID.ToString();
    }

    //取得用户创建的合同收货计划明细表最大ID号
    public static string GetMyCreatedMaxConstractGoodsReceiptPlanID(string strConstractCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractGoodsReceiptPlan as constractGoodsReceiptPlan where constractGoodsReceiptPlan.ConstractCode = " + "'" + strConstractCode + "'" + " Order by constractGoodsReceiptPlan.ID DESC";
        ConstractGoodsReceiptPlanBLL constractGoodsReceiptPlanBLL = new ConstractGoodsReceiptPlanBLL();
        lst = constractGoodsReceiptPlanBLL.GetAllConstractGoodsReceiptPlans(strHQL);

        ConstractGoodsReceiptPlan constractGoodsReceiptPlan = (ConstractGoodsReceiptPlan)lst[0];

        return constractGoodsReceiptPlan.ID.ToString();
    }

    //取得用户创建的合同收货记录明细表最大ID号
    public static string GetMyCreatedMaxConstractGoodsReceiptRecordID(string strReceiptPlanID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractGoodsReceiptRecord as constractGoodsReceiptRecord where constractGoodsReceiptRecord.ReceiptPlanID = " + strReceiptPlanID + " Order by constractGoodsReceiptRecord.ID DESC";
        ConstractGoodsReceiptRecordBLL constractGoodsReceiptRecordBLL = new ConstractGoodsReceiptRecordBLL();
        lst = constractGoodsReceiptRecordBLL.GetAllConstractGoodsReceiptRecords(strHQL);

        ConstractGoodsReceiptRecord constractGoodsReceiptRecord = (ConstractGoodsReceiptRecord)lst[0];

        return constractGoodsReceiptRecord.ID.ToString();
    }

    //取得用户创建的合同发货计划明细表最大ID号
    public static string GetMyCreatedMaxConstractGoodsDeliveryPlanID(string strConstractCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractGoodsDeliveryPlan as constractGoodsDeliveryPlan where constractGoodsDeliveryPlan.ConstractCode = " + "'" + strConstractCode + "'" + " Order by constractGoodsDeliveryPlan.ID DESC";
        ConstractGoodsDeliveryPlanBLL constractGoodsDeliveryPlanBLL = new ConstractGoodsDeliveryPlanBLL();
        lst = constractGoodsDeliveryPlanBLL.GetAllConstractGoodsDeliveryPlans(strHQL);

        ConstractGoodsDeliveryPlan constractGoodsDeliveryPlan = (ConstractGoodsDeliveryPlan)lst[0];

        return constractGoodsDeliveryPlan.ID.ToString();
    }

    //取得用户创建的合同发货记录明细表最大ID号
    public static string GetMyCreatedMaxConstractGoodsDeliveryRecordID(string strDeliveryPlanID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ConstractGoodsDeliveryRecord as constractGoodsDeliveryRecord where constractGoodsDeliveryRecord.DeliveryPlanID = " + strDeliveryPlanID + " Order by constractGoodsDeliveryRecord.ID DESC";
        ConstractGoodsDeliveryRecordBLL constractGoodsDeliveryRecordBLL = new ConstractGoodsDeliveryRecordBLL();
        lst = constractGoodsDeliveryRecordBLL.GetAllConstractGoodsDeliveryRecords(strHQL);

        ConstractGoodsDeliveryRecord constractGoodsDeliveryRecord = (ConstractGoodsDeliveryRecord)lst[0];

        return constractGoodsDeliveryRecord.ID.ToString();
    }

    //取得用户创建的资产申请表最大ID号
    public static string GetMyCreatedMaxAssetApplicationID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from AssetApplication as assetApplication where assetApplication.ApplicantCode = " + "'" + strUserCode + "'" + " Order by assetApplication.AAID DESC";
        AssetApplicationBLL assetApplicationBLL = new AssetApplicationBLL();
        lst = assetApplicationBLL.GetAllAssetApplications(strHQL);

        AssetApplication assetApplication = (AssetApplication)lst[0];

        return assetApplication.AAID.ToString();
    }

    //取得用户创建的资产申请表明细最大ID号
    public static string GetMyCreatedMaxAssetApplicationDetailID(string strAAID)
    {
        string strHQL;
        IList lst;

        strHQL = "from AssetApplicationDetail as assetApplicationDetail where assetApplicationDetail.AAID = " + strAAID;
        AssetApplicationDetailBLL assetApplicationDetailBLL = new AssetApplicationDetailBLL();
        lst = assetApplicationDetailBLL.GetAllAssetApplicationDetails(strHQL);

        AssetApplicationDetail assetApplicationDetail = (AssetApplicationDetail)lst[0];

        return assetApplicationDetail.ID.ToString();
    }

    //取得资产入库单最大的单号
    public static int GetMyCreatedMaxAssetCheckInDetailID(string strCIOID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_AssetCheckInOrderDetail where CheckInID = " + strCIOID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_AssetCheckInOrderDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得资产出库单最大的单号
    public static int GetMyCreatedMaxAssetShipmentNO(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ShipmentNO) From T_AssetShipmentOrder Where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_AssetShipmentOrder");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得资产出库单明细的最大ID
    public static int GetMyCreatedMaxAssetShipmentDetailID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_AssetShipmentDetail ";
        DataSet ds = GetDataSetFromSql(strHQL, "T_AssetShipmentDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得用户建立的最新的资产
    public static string GetMyCreatedMaxAssetCode(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from Asset as asset where asset.OwnerCode = " + "'" + strUserCode + "'" + " Order by asset.Number DESC,asset.ID DESC";
        AssetBLL assetBLL = new AssetBLL();
        lst = assetBLL.GetAllAssets(strHQL);

        Asset asset = (Asset)lst[0];

        return asset.AssetCode.Trim();
    }

    //取得用户建立的资产最新调配记录ID
    public static string GetMyCreatedMaxAssetuserRecordID(string strAssetCode)
    {
        string strHQL = "from AssetUserRecord as assetUserRecord where assetUserRecord.AssetCode = " + "'" + strAssetCode + "'" + " Order by assetUserRecord.ID DESC";
        AssetUserRecordBLL assetUserRecordBLL = new AssetUserRecordBLL();
        IList lst = assetUserRecordBLL.GetAllAssetUserRecords(strHQL);
        AssetUserRecord assetUserRecord = (AssetUserRecord)lst[0];

        return assetUserRecord.ID.ToString();
    }

    //取得用户建立的资产维护最新记录ID
    public static string GetMyCreatedMaxAssetMtRecordID(string strAssetCode)
    {
        string strHQL = "from AssetMTRecord as assetMTRecord where assetMTRecord.AssetCode = " + "'" + strAssetCode + "'" + " Order by assetMTRecord.ID DESC";

        AssetMTRecordBLL assetMTRecordBLL = new AssetMTRecordBLL();
        IList lst = assetMTRecordBLL.GetAllAssetMTRecords(strHQL);

        AssetMTRecord assetMTRecord = (AssetMTRecord)lst[0];

        return assetMTRecord.ID.ToString();
    }

    //取得物料销售单最大的记录号
    public static string GetMyCreatedMaxScheduleDailyWorkID()
    {
        string strHQL;

        strHQL = "Select Max(ReviewID) From T_ScheduleEvent_LeaderReview ";
        DataSet ds = GetDataSetFromSql(strHQL, "T_ScheduleEvent_LeaderReview ");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得猎聘人员的最大ID
    public static string GetMyCreatedMaxCandidateID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_LTCandidateInformation where CreatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_LTCandidateInformation");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得物料入库单的最大ID
    public static string GetMyCreatedMaxGoodsCheckInID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(CheckInID) From T_GoodsCheckInOrder where CreatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsCheckInOrder");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得物料销售单的最大ID
    public static string GetMyCreatedMaxGoodsSaleOrderID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(SOID) From T_GoodsSaleOrder where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsSaleOrder");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得物料销售单最大的记录号
    public static string GetMyCreatedMaxGoodsSaleRecordID(string strSOID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsSaleRecord where SOID = " + strSOID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsSaleRecord");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得物料销售报价单的最大ID
    public static string GetMyCreatedMaxGoodsSaleQuotationOrderID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(QOID) From T_GoodsSaleQuotationOrder where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsSaleQuotationOrder");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得物料销售单最大的记录号
    public static string GetMyCreatedMaxGoodsSaleQuotationOrderDetailID(string strQOID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsSaleQuotationOrderDetail where QOID = " + strQOID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsSaleQuotationOrderDetail");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的物料出货通知表最大ID号
    public static string GetMyCreatedMaxGoodsCheckOutNoticeOrderID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from GoodsCheckOutNoticeOrder as goodsCheckOutNoticeOrder where goodsCheckOutNoticeOrder.ApplicantCode = " + "'" + strUserCode + "'" + " Order by goodsCheckOutNoticeOrder.COOID DESC";
        GoodsCheckOutNoticeOrderBLL goodsCheckOutNoticeOrderBLL = new GoodsCheckOutNoticeOrderBLL();
        lst = goodsCheckOutNoticeOrderBLL.GetAllGoodsCheckOutNoticeOrders(strHQL);

        GoodsCheckOutNoticeOrder goodsCheckOutNoticeOrder = (GoodsCheckOutNoticeOrder)lst[0];

        return goodsCheckOutNoticeOrder.COOID.ToString();
    }

    //取得用户创建的物料出货通知表明细最大ID号
    public static string GetMyCreatedMaxGoodsCheckOutNoticeOrderDetailID(string strAAID)
    {
        string strHQL;
        IList lst;

        strHQL = "from GoodsCheckOutNoticeOrderDetail as goodsCheckOutNoticeOrderDetail where goodsCheckOutNoticeOrderDetail.COOID = " + strAAID;
        GoodsCheckOutNoticeOrderDetailBLL goodsCheckOutNoticeOrderDetailBLL = new GoodsCheckOutNoticeOrderDetailBLL();
        lst = goodsCheckOutNoticeOrderDetailBLL.GetAllGoodsCheckOutNoticeOrderDetails(strHQL);

        GoodsCheckOutNoticeOrderDetail goodsCheckOutNoticeOrderDetail = (GoodsCheckOutNoticeOrderDetail)lst[0];

        return goodsCheckOutNoticeOrderDetail.ID.ToString();
    }

    //取得用户创建的物料申请表最大ID号
    public static string GetMyCreatedMaxGoodsApplicationID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from GoodsApplication as goodsApplication where goodsApplication.ApplicantCode = " + "'" + strUserCode + "'" + " Order by goodsApplication.AAID DESC";
        GoodsApplicationBLL goodsApplicationBLL = new GoodsApplicationBLL();
        lst = goodsApplicationBLL.GetAllGoodsApplications(strHQL);

        GoodsApplication goodsApplication = (GoodsApplication)lst[0];

        return goodsApplication.AAID.ToString();
    }

    //取得用户创建的物料申请表明细最大ID号
    public static string GetMyCreatedMaxGoodsApplicationDetailID(string strAAID)
    {
        string strHQL;
        IList lst;

        strHQL = "from GoodsApplicationDetail as goodsApplicationDetail where goodsApplicationDetail.AAID = " + strAAID;
        GoodsApplicationDetailBLL goodsApplicationDetailBLL = new GoodsApplicationDetailBLL();
        lst = goodsApplicationDetailBLL.GetAllGoodsApplicationDetails(strHQL);

        GoodsApplicationDetail goodsApplicationDetail = (GoodsApplicationDetail)lst[0];

        return goodsApplicationDetail.ID.ToString();
    }

    //取得物料MRP计划最大的单号
    public static int GetMyCreatedMaxGoodsMrpMainPlanVerID(string strCreatorCode)
    {
        string strHQL;

        strHQL = "Select Max(PlanVerID) From T_ItemMainPlan where CreatorCode = " + "'" + strCreatorCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_ItemMainPlan");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料MRP计划明细最大的单号
    public static int GetMyCreatedMaxGoodsMrpMainPlanVerDetailID(string strPlanVerID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_ItemMainPlanDetail where PlanVerID = " + strPlanVerID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_ItemMainPlanDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料入库单最大的单号
    public static int GetMyCreatedMaxGoodsCheckInDetailID(string strCIOID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsCheckInOrderDetail where CheckInID = " + strCIOID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsCheckInOrderDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得入库存物料最大的ID
    public static int GetMyCreatedMaxGoodsID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_Goods";
        DataSet ds = GetDataSetFromSql(strHQL, "T_Goods");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料出库单最大的单号
    public static int GetMyCreatedMaxGoodsShipmentNO(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ShipmentNO) From T_GoodsShipmentOrder Where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsShipmentOrder");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料出库单最大的单号
    public static int GetMyCreatedMaxGoodsBorrowNO(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(BorrowNO) From T_GoodsBorrowOrder Where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsBorrowOrder");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料退货单最大的单号
    public static int GetMyCreatedMaxGoodsROID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ROID) From T_GoodsReturnOrder Where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsReturnOrder");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料送货单最大的单号
    public static int GetMyCreatedMaxGoodsDeliveryOrderID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(DOID) From T_GoodsDeliveryOrder Where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsDeliveryOrder");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料送货单明细表最大的记录号
    public static int GetMyCreatedMaxGoodsDeliveryOrderDetailID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsDeliveryOrderDetail ";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsDeliveryOrderDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得资产退货单最大的单号
    public static int GetMyCreatedMaxAssetROID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ROID) From T_AssetReturnOrder Where OperatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_AssetReturnOrder");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料退货单明细的最大ID
    public static int GetMyCreatedMaxGoodsReturnDetailID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsReturnDetail ";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsReturnDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得资产退库单明细的最大ID
    public static int GetMyCreatedMaxAssetReturnDetailID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_AssetReturnDetail ";
        DataSet ds = GetDataSetFromSql(strHQL, "T_AssetReturnDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料出库单明细的最大ID
    public static int GetMyCreatedMaxGoodsShipmentDetailID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsShipmentDetail ";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsShipmentDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得物料出库单明细的最大ID
    public static int GetMyCreatedMaxGoodsBorrowOrderDetailID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_GoodsBorrowOrderDetail ";
        DataSet ds = GetDataSetFromSql(strHQL, "T_GoodsBorrowOrderDetail");

        return int.Parse(ds.Tables[0].Rows[0][0].ToString());
    }

    //取得用户建立的最新的物料
    public static string GetMyCreatedMaxGoodsCode(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from Goods as goods where goods.OwnerCode = " + "'" + strUserCode + "'" + " Order by goods.Number DESC,goods.ID DESC";
        GoodsBLL goodsBLL = new GoodsBLL();
        lst = goodsBLL.GetAllGoodss(strHQL);

        Goods goods = (Goods)lst[0];

        return goods.GoodsCode.Trim();
    }

    //取得用户建立的物料最新调配记录ID
    public static string GetMyCreatedMaxGoodsuserRecordID(string strGoodsCode)
    {
        string strHQL = "from GoodsUserRecord as goodsUserRecord where goodsUserRecord.GoodsCode = " + "'" + strGoodsCode + "'" + " Order by goodsUserRecord.ID DESC";
        GoodsUserRecordBLL goodsUserRecordBLL = new GoodsUserRecordBLL();
        IList lst = goodsUserRecordBLL.GetAllGoodsUserRecords(strHQL);
        GoodsUserRecord goodsUserRecord = (GoodsUserRecord)lst[0];

        return goodsUserRecord.ID.ToString();
    }

    //取得用户建立的物料维护最新记录ID
    public static string GetMyCreatedMaxGoodsMtRecordID(string strGoodsCode)
    {
        string strHQL = "from GoodsMTRecord as goodsMTRecord where goodsMTRecord.GoodsCode = " + "'" + strGoodsCode + "'" + " Order by goodsMTRecord.ID DESC";

        GoodsMTRecordBLL goodsMTRecordBLL = new GoodsMTRecordBLL();
        IList lst = goodsMTRecordBLL.GetAllGoodsMTRecords(strHQL);

        GoodsMTRecord goodsMTRecord = (GoodsMTRecord)lst[0];

        return goodsMTRecord.ID.ToString();
    }

    //取得用户建立的最大的客户问题号
    public static string GetMyCreatedMaxCustomerQuestionID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from CustomerQuestion as customerQuestion where customerQuestion.RecorderCode = " + "'" + strUserCode + "'" + " Order by customerQuestion.ID DESC";
        CustomerQuestionBLL customerQuestionBLL = new CustomerQuestionBLL();
        lst = customerQuestionBLL.GetAllCustomerQuestions(strHQL);

        CustomerQuestion customerQuestion = (CustomerQuestion)lst[0];

        return customerQuestion.ID.ToString();
    }

    //取得用户建立的客户问题记录最大的记录号
    public static string GetMyCreatedMaxcustomerQuestionDetailID(string strQuestionID)
    {
        string strHQL;
        IList lst;

        strHQL = "from CustomerQuestionHandleRecord as customerQuestionHandleRecord where customerQuestionHandleRecord.QuestionID = " + strQuestionID + " Order by customerQuestionHandleRecord.ID DESC";
        CustomerQuestionHandleRecordBLL customerQuestionHandleRecordBLL = new CustomerQuestionHandleRecordBLL();
        lst = customerQuestionHandleRecordBLL.GetAllCustomerQuestionHandleRecords(strHQL);

        CustomerQuestionHandleRecord customerQuestionHandleRecord = (CustomerQuestionHandleRecord)lst[0];

        return customerQuestionHandleRecord.ID.ToString();
    }

    //取得用户建立的员工资料教育经历最大记录号
    public static string GetMyCreatedMaxEducationExpericenceID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from EducationExperience as educationExperience where educationExperience.UserCode = " + "'" + strUserCode + "'" + " Order by educationExpericence.ID DESC";
        EducationExperienceBLL educationExperienceBLL = new EducationExperienceBLL();
        lst = educationExperienceBLL.GetAllEducationExperiences(strHQL);

        EducationExperience educationExperience = (EducationExperience)lst[0];

        return educationExperience.ID.ToString();
    }

    //取得用户建立的员工资料工作经历最大记录号
    public static string GetMyCreatedMaxWorkExperienceID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from WorkExperience as workExperience where workExperience.UserCode = " + "'" + strUserCode + "'" + " Order by workExperience.ID DESC";

        WorkExperienceBLL workExperienceBLL = new WorkExperienceBLL();
        lst = workExperienceBLL.GetAllWorkExperiences(strHQL);

        WorkExperience workExperience = (WorkExperience)lst[0];

        return workExperience.ID.ToString();
    }

    //取得用户建立的员工资料家庭成员最大ID号
    public static string GetMyCreatedMaxFamilyMemberID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from FamilyMember as familyMember where familyMember.UserCode = " + "'" + strUserCode + "'" + " Order by familyMember.ID DESC";
        FamilyMemberBLL familyMemberBLL = new FamilyMemberBLL();
        lst = familyMemberBLL.GetAllFamilyMembers(strHQL);

        FamilyMember familyMember = (FamilyMember)lst[0];

        return familyMember.ID.ToString();
    }

    //取得用户建立的员工资料异动记录最大ID号
    public static string GetMyCreatedMaxUserTransactionRecordID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_UserTransactionRecord Where UserCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_UserTransactionRecord");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户考勤规则最大ID号
    public static string GetMyCreatedMaxUserAttendanceRule(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From UserAttendanceRule as userAttendanceRule Where userAttendanceRule.UserCode = " + "'" + strUserCode + "'";
        strHQL += " Order by userAttendanceRule.ID DESC";
        UserAttendanceRuleBLL userAttendanceRuleBLL = new UserAttendanceRuleBLL();
        lst = userAttendanceRuleBLL.GetAllUserAttendanceRules(strHQL);

        UserAttendanceRule userAttendanceRule = (UserAttendanceRule)lst[0];

        return userAttendanceRule.ID.ToString();
    }

    //取得用户建立的日程最大ID号
    public static string GetMyCreatedMaxScheduleID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from Schedule as schedule where schedule.UserCode = " + "'" + strUserCode + "'" + " Order by schedule.ID DESC";
        ScheduleBLL scheduleBLL = new ScheduleBLL();
        lst = scheduleBLL.GetAllSchedules(strHQL);

        ProjectMgt.Model.Schedule schedule = (ProjectMgt.Model.Schedule)lst[0];

        return schedule.ID.ToString();
    }

    // 取得用户创建的最大新闻ID号
    public static string GetMyCreatedMaxHeadLineID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from HeadLine as headLine where headLine.PublisherCode =" + "'" + strUserCode + "'" + " Order by headLine.ID DESC";
        HeadLineBLL headLineBLL = new HeadLineBLL();
        lst = headLineBLL.GetAllHeadLines(strHQL);

        HeadLine headLine = (HeadLine)lst[0];

        return headLine.ID.ToString();
    }

    // 取得用户创建的最大公文ID号
    public static string GetMyCreatedMaxOfficialDocumentID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from OfficialDocument as officialDocument where officialDocument.PublisherCode =" + "'" + strUserCode + "'" + " Order by officialDocument.ID DESC";
        OfficialDocumentBLL officialDocumentBLL = new OfficialDocumentBLL();
        lst = officialDocumentBLL.GetAllOfficialDocuments(strHQL);

        OfficialDocument officialDocument = (OfficialDocument)lst[0];

        return officialDocument.ID.ToString();
    }

    // 取得用户创建的最大新闻ID号
    public static string GetMyCreatedMaxMailSignInfoID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_MailSignInfo Where UserCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_MailSignInfo");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户创建的最大联系人编号
    public static string GetMyCreatedMaxContactInforID(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "from ContactInfor as contactInfor where contactInfor.UserCode = " + "'" + strUserCode + "'" + " Order by contactInfor.ID DESC";
        ContactInforBLL contactInforBLL = new ContactInforBLL();
        lst = contactInforBLL.GetAllContactInfors(strHQL);

        ContactInfor contactInfor = (ContactInfor)lst[0];

        return contactInfor.ID.ToString();
    }

    //取得用户层次的最大的ID号
    public static string GetMyCreatedMaxMemberLevelID()
    {
        string strHQL;
        IList lst;

        strHQL = "from MemberLevel as memberLevel Order by memberLevel.ID DESC ";
        MemberLevelBLL memberLevelBLL = new MemberLevelBLL();
        lst = memberLevelBLL.GetAllMemberLevels(strHQL);

        MemberLevel memberLevel = (MemberLevel)lst[0];

        return memberLevel.ID.ToString();
    }

    //取得车辆申请的最大的ID号
    public static string GetMyCreatedMaxCarApplyFormID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_CarApplyForm";
        DataSet ds = GetDataSetFromSql(strHQL, "T_CarApplyForm");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得车辆申请的最大的ID号
    public static string GetMyCreatedMaxCarAssignFormID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_CarAssignForm";
        DataSet ds = GetDataSetFromSql(strHQL, "T_CarAssignForm");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得员工兼职最大的ID号
    public static string GetMyCreatedMaxPartTimeJobID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_PartTimeJob";
        DataSet ds = GetDataSetFromSql(strHQL, "T_PartTimeJob");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得计划最大的ID号
    public static string GetMyCreatedMaxPlanID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(PlanID) From T_Plan Where CreatorCode = " + "'" + strUserCode + "'";
        DataSet ds = GetDataSetFromSql(strHQL, "T_Plan");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得计划目标最大的ID号
    public static string GetMyCreatedMaxPlanTargetID(string strPlanID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_Plan_Target Where PlanID = " + strPlanID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_Plan");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得计划领导最大的ID号
    public static string GetMyCreatedMaxPlanRelatedLeaderID(string strPlanID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_Plan_RelatedLeader Where PlanID = " + strPlanID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_Plan");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得计划领导评论最大的ID号
    public static string GetMyCreatedMaxPlanLeaderReviewID(string strPlanID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_Plan_LeaderReview Where PlanID = " + strPlanID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_PlanLeaderReview");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得计划日志的最大的ID号
    public static string GetMyCreatedMaxPlanWorkLogID(string strPlanID)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_Plan_WorkLog Where PlanID = " + strPlanID;
        DataSet ds = GetDataSetFromSql(strHQL, "T_PlanWorkLog");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得KPI最大的ID号
    public static string GetMyCreatedMaxKPIID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_KPILibrary";
        DataSet ds = GetDataSetFromSql(strHQL, "T_KPILibrary");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得KPI职称模板最大的ID号
    public static string GetMyCreatedMaxKPIDepartPositionTemplateID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_KPITemplateForDepartPosition";
        DataSet ds = GetDataSetFromSql(strHQL, "T_KPITemplateForDepartPosition");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得员工KPI考核最大的ID号
    public static string GetMyCreatedMaxUserKPICheckID()
    {
        string strHQL;

        strHQL = "Select Max(KPICheckID) From T_UserKPICheck";
        DataSet ds = GetDataSetFromSql(strHQL, "T_UserKPICheck");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得员工KPI考核最大的ID号
    public static string GetMyCreatedMaxUserKPICheckDetailID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_UserKPICheckDetail";
        DataSet ds = GetDataSetFromSql(strHQL, "T_UserKPICheckDetail");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用网站地址的编号
    public static string GetMyCreatedMaxWebSiteID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_WebSite Where UserCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_WebSite");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得报表模板的最大ID号
    public static string GetMyCreatedMaxReportTemplateID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_ReportTemplate Where CreatorCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ReportTemplate");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得上传文档的最大ID号
    public static string GetMyCreatedMaxDocID(string strUserCode)
    {
        string strHQL;

        strHQL = "Select Max(DocID) From T_Document Where UploadManCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Document");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得数据交命令的最大ID号
    public static string GetMyCreatedSystemExchangeDBSqlOrderID()
    {
        string strHQL;

        strHQL = "Select Max(ID) From T_SystemExchangeOrder";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemExchangeOrder");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    #endregion 取得用户创建的对象的最大ID号

    #region 取得各种对象ID号或名称

    //取得项目ID（根据项目名称）
    public static string GetProjectID(string strProjectName)
    {
        string strHQL;
        IList lst;

        strHQL = "from Project as project where rtrim(ltrim(project.ProjectName)) = " + "'" + strProjectName + "'";
        ProjectBLL projectBLL = new ProjectBLL();
        lst = projectBLL.GetAllProjects(strHQL);

        Project project = (Project)lst[0];

        return project.ProjectID.ToString();
    }

    //取得项目名称（根据项目号）
    public static string GetProjectName(string strProjectID)
    {
        string strHQL = "from Project as project where project.ProjectID = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        IList lst = projectBLL.GetAllProjects(strHQL);
        Project project = (Project)lst[0];

        string strProjectName = project.ProjectName.Trim();
        return strProjectName;
    }

    //取得项目实施（根据项目号）
    public static Project GetProject(string strProjectID)
    {
        string strHQL = "from Project as project where project.ProjectID = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        IList lst = projectBLL.GetAllProjects(strHQL);
        Project project = (Project)lst[0];

        return project;
    }

    //取是项目状态（根据项目号）
    public static string GetProjectStatus(string strProjectID)
    {
        string strHQL;
        IList lst;

        strHQL = "from Project as project where project.ProjectID = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        lst = projectBLL.GetAllProjects(strHQL);

        Project project = (Project)lst[0];

        return project.Status.Trim();
    }

    //取得项目经理代码（根据项目号）
    public static string GetProjectPMCode(string strProjectID)
    {
        string strHQL = "from Project as project where project.ProjectID = " + strProjectID;
        ProjectBLL projectBLL = new ProjectBLL();
        IList lst = projectBLL.GetAllProjects(strHQL);
        Project project = (Project)lst[0];

        return project.PMCode.Trim();
    }

    //取得项目计划版本
    public static int GetProjectPlanVersion(string strProjectID, string strType)
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

    //取得此项目类型的项目是否受细节（计划，任务，工作流）影响
    public static string GetProjectTypeImpactByDetail(string strProjectID)
    {
        string strHQL;

        strHQL = "Select ProgressByDetailImpact From T_Project Where ProjectID = " + strProjectID;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Project");

        if (ds.Tables[0].Rows.Count > 0)
        {

            return ds.Tables[0].Rows[0]["ProgressByDetailImpact"].ToString().Trim();

        }
        else
        {
            return "NO";
        }
    }

    //取得项目任务名称
    public static string GetProjectTaskName(string strTaskID)
    {
        string strHQL;
        IList lst;

        strHQL = "from ProjectTask as projectTask where projectTask.TaskID = " + strTaskID;
        ProjectTaskBLL projectTaskBLL = new ProjectTaskBLL();
        lst = projectTaskBLL.GetAllProjectTasks(strHQL);

        ProjectTask projectTask = (ProjectTask)lst[0];
        return projectTask.Task.Trim();
    }

    //取得需求对象（根据需求号）
    public static Defectment GetDefectment(string strDefectID)
    {
        string strHQL = "from Defectment as defectment where defectment.DefectID = " + strDefectID;
        DefectmentBLL defectmentBLL = new DefectmentBLL();

        IList lst = defectmentBLL.GetAllDefectments(strHQL);

        Defectment defectment = (Defectment)lst[0];

        return defectment;
    }

    //取得需求对象（根据需求号）
    public static Requirement GetRequirement(string strReqID)
    {
        string strHQL = "from Requirement as requirement where requirement.ReqID = " + strReqID;
        RequirementBLL requirementBLL = new RequirementBLL();

        IList lst = requirementBLL.GetAllRequirements(strHQL);

        Requirement requirement = (Requirement)lst[0];

        return requirement;
    }

    //取得部门名称
    public static string GetDepartName(string strDepartCode)
    {
        string strHQL;
        IList lst;

        strHQL = "Select DepartName From T_Department Where DepartCode = " + "'" + strDepartCode + "'";
        DataSet ds = GetDataSetFromSqlNOOperateLog(strHQL, "T_Department");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    //取得用户部门代码(根据用户代码）
    public static string GetParentDepartCodeFromDepartCode(string strDepartCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From Department as department where department.DepartCode = " + "'" + strDepartCode + "'";
        DepartmentBLL departmentBLL = new DepartmentBLL();
        lst = departmentBLL.GetAllDepartments(strHQL);

        Department department = (Department)lst[0];

        return department.ParentCode.Trim();
    }

    //取得用户部门代码(根据用户代码）
    public static string GetDepartCodeFromUserCode(string strUserCode)
    {
        string strDepartCode, strHQL;

        strHQL = " from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        ProjectMember projectMember = (ProjectMember)lst[0];
        strDepartCode = projectMember.DepartCode;
        return strDepartCode.Trim();
    }

    //取得客户归属部门代码(根据客户代码）
    public static string GetDepartCodeFromCustomerCode(string strCustomerCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From Customer as customer Where customer.CustomerCode = " + "'" + strCustomerCode + "'";
        CustomerBLL customerBLL = new CustomerBLL();
        lst = customerBLL.GetAllCustomers(strHQL);
        Customer customer = (Customer)lst[0];

        return customer.BelongDepartCode.Trim();
    }

    //取得用户部门产品线相关(根据用户代码）
    public static string GetDepartRelatedProductLineFromUserCode(string strUserCode)
    {
        string strHQL;
        IList lst;

        string strDepartCode;
        strDepartCode = ShareClass.GetDepartCodeFromUserCode(strUserCode);

        strHQL = " From Department as department Where department.DepartCode = " + "'" + strDepartCode + "'";
        DepartmentBLL departmentBLL = new DepartmentBLL();
        lst = departmentBLL.GetAllDepartments(strHQL);
        Department department = (Department)lst[0];

        try
        {
            return department.ProductLineRelated.Trim();
        }
        catch
        {
            return "NO";
        }
    }

    //取得用户部门超级用户产品线相关(根据用户代码）
    public static string GetDepartSuperUserRelatedProductLineFromUserCode(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From DepartRelatedSuperUser as departRelatedSuperUser Where departRelatedSuperUser.UserCode = " + "'" + strUserCode + "'";
        DepartRelatedSuperUserBLL departRelatedSuperUserBLL = new DepartRelatedSuperUserBLL();
        lst = departRelatedSuperUserBLL.GetAllDepartRelatedSuperUsers(strHQL);

        if (lst.Count > 0)
        {
            DepartRelatedSuperUser departRelatedSuperUser = (DepartRelatedSuperUser)lst[0];

            return departRelatedSuperUser.ProductLineRelated.Trim();
        }
        else
        {
            return "NO";
        }
    }

    public static string GetUserSMSCode(string strUserCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From SMSCode as smsCode Where smsCode.UserCode = " + "'" + strUserCode + "'" + " and to_char(smsCode.SendTime,'yyyymmdd') = " + "'" + DateTime.Now.ToString("yyyyMMdd") + "'";
        SMSCodeBLL smsCodeBLL = new SMSCodeBLL();
        lst = smsCodeBLL.GetAllSMSCodes(strHQL);

        SMSCode smsCode = new SMSCode();

        if (lst.Count > 0)
        {
            smsCode = (SMSCode)lst[0];

            return smsCode.RandomCode.Trim();
        }
        else
        {
            return "";
        }
    }

    public static string GetWebSiteCustomerServiceOperatorCode(string strWebSite)
    {
        string strHQL;

        if (strWebSite == null)
        {
            strWebSite = "NULL";
        }

        strHQL = "Select UserCode From T_SiteCustomerServiceOperator Where Upper(WebSite) = " + "'" + strWebSite.ToUpper() + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SiteCustomerServiceOperator");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "ADMIN";
        }
    }

    public static string GetUserName(string strUserCode)
    {
        string strHQL;
        string strUserName;

        strHQL = "Select UserName From T_ProjectMember Where UserCode = " + "'" + strUserCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
        strUserName = ds.Tables[0].Rows[0][0].ToString().Trim();

        return strUserName;
    }

    //依用户代码取得用户名
    public static string GetUserCodeByUserName(string strUserName)
    {
        string strHQL;

        strHQL = "Select UserCode From T_ProjectMember Where UserName = " + "'" + strUserName + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString().Trim();
        }
        else
        {
            return "";
        }
    }

    public static string GetUserStatus(string strUserCode)
    {
        string strStatus, strHQL;

        strHQL = " from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        ProjectMember projectMember = (ProjectMember)lst[0];

        strStatus = projectMember.Status.Trim();

        return strStatus;
    }

    public static string GetUserDuty(string strUserCode)
    {
        string strDuty;

        string strHQL = " from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        ProjectMember projectMember = (ProjectMember)lst[0];

        strDuty = projectMember.Duty.Trim();
        return strDuty;
    }

    public static string GetUserLangCode(string strUserCode)
    {
        string strLangCode;

        string strHQL = " from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        if (lst.Count > 0)
        {
            ProjectMember projectMember = (ProjectMember)lst[0];

            try
            {
                strLangCode = projectMember.LangCode.Trim();
            }
            catch
            {
                strLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            }

            if (strLangCode == "")
            {
                strLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
            }
        }
        else
        {
            strLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];
        }

        return strLangCode;
    }

    public static string GetUserJobTitle(string strUserCode)
    {
        string strJobTitle;

        string strHQL = " from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        ProjectMember projectMember = (ProjectMember)lst[0];

        try
        {
            strJobTitle = projectMember.JobTitle.Trim();
            return strJobTitle;
        }
        catch
        {
            return "";
        }
    }

    public static string GetUserType(string strUserCode)
    {
        string strUserType, strHQL;

        strHQL = " from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
        ProjectMemberBLL projectMemberBLL = new ProjectMemberBLL();
        IList lst = projectMemberBLL.GetAllProjectMembers(strHQL);
        if (lst.Count > 0)
        {
            ProjectMember projectMember = (ProjectMember)lst[0];
            strUserType = projectMember.UserType.Trim();

            return strUserType;
        }
        else
        {
            return "";
        }
    }

    public static Asset GetAsset(string strAssetCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From Asset as asset Where asset.AssetCode = " + "'" + strAssetCode + "'";
        AssetBLL assetBLL = new AssetBLL();
        lst = assetBLL.GetAllAssets(strHQL);
        Asset asset = (Asset)lst[0];

        return asset;
    }

    public static string GetAssetName(string strAssetCode)
    {
        string strHQL;
        IList lst;

        string strAssetName;

        strHQL = "From Asset as asset Where asset.AssetCode = " + "'" + strAssetCode + "'";
        AssetBLL assetBLL = new AssetBLL();
        lst = assetBLL.GetAllAssets(strHQL);
        Asset asset = (Asset)lst[0];

        strAssetName = asset.AssetName;

        return strAssetName;
    }

    public static string GetItemName(string strItemCode)
    {
        string strHQL;
        IList lst;

        string strItemName;

        strHQL = "From Item as item Where item.ItemCode = " + "'" + strItemCode + "'";
        ItemBLL itemBLL = new ItemBLL();
        lst = itemBLL.GetAllItems(strHQL);
        Item item = (Item)lst[0];

        strItemName = item.ItemName.Trim();

        return strItemName;
    }

    public static string GetItemSmallType(string strItemCode)
    {
        string strHQL;

        strHQL = "Select SmallType From T_Item Where ItemCode = " + "'" + strItemCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Item");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    //取得商品对象
    public static Goods GetGoods(string strGoodsCode)
    {
        string strHQL;
        IList lst;

        strHQL = "From Goods as goods Where goods.GoodsCode = " + "'" + strGoodsCode + "'";
        GoodsBLL goodsBLL = new GoodsBLL();
        lst = goodsBLL.GetAllGoodss(strHQL);
        Goods goods = (Goods)lst[0];

        return goods;
    }

    public static string GetGoodsName(string strGoodsCode)
    {
        string strHQL;
        IList lst;

        string strGoodsName;

        strHQL = "From Goods as goods Where goods.GoodsCode = " + "'" + strGoodsCode + "'";
        GoodsBLL goodsBLL = new GoodsBLL();
        lst = goodsBLL.GetAllGoodss(strHQL);
        Goods goods = (Goods)lst[0];

        strGoodsName = goods.GoodsName;

        return strGoodsName;
    }

    //取得物料库存量
    public static string GetMaterialsStockNumber(string strGoodsCode)
    {
        string strHQL;

        strHQL = "Select COALESCE(Sum(Number),0) From T_Goods Where GoodsCode = " + "'" + strGoodsCode + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Goods");

        return ds.Tables[0].Rows[0][0].ToString();
    }

    #endregion 取得各种对象ID号或名称

}
