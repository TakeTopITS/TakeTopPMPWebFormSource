using System;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.UI;

using ProjectMgt.BLL;
using ProjectMgt.Model;

public partial class TakeTopSystemOtherCodeRunPage : System.Web.UI.Page
{
    public string strUserCode, strUserName;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strUserName = Session["UserName"].ToString();

        if (Page.IsPostBack == false)
        {
            Session["SystemName"] = System.Configuration.ConfigurationManager.AppSettings["SystemName"];

            //LogClass.WriteLogFile("OtherCodeUpgradeBegin");

            AsyncWork();
        }
    }

    protected void AsyncWork()
    {
        if (ShareClass.SystemLatestLoginUser == "")
        {
            ShareClass.SystemLatestLoginUser = "Timer";

            try
            {
                // 执行特殊代码
                RunSpecialCode(strUserCode, strUserName);

            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }

            //最后登录用户
            ShareClass.SystemLatestLoginUser = "";
        }
    }

    //执行特殊代码
    public static void RunSpecialCode(string strUserCode, string strUserName)
    {
        int intUserNumber, intRunMarkInDB;

        intUserNumber = getUserNumber();
        intRunMarkInDB = GetNormalOtherCodeRunMark();

        //设置这个值，可以决定是否执行下面的代码
        int intRunMark = 6;

        if (intRunMarkInDB < intRunMark)
        {
            //增加预警命令种类
            AddEarlyWarningOrder("DefectToHandle");

            //更改预警命令
            UpdateEaryWarningOrder("TasksToHandle");
            UpdateEaryWarningOrder("RequirementsToHandle");
            UpdateEaryWarningOrder("BidsToHandle");
            UpdateEaryWarningOrder("ApplicationToBeReviewed");
            UpdateEaryWarningOrder("DelayedProjectPlan");
            UpdateEaryWarningOrder("ContractPrepaymentWarning");
            UpdateEaryWarningOrder("MeetingToAttend");
            UpdateEaryWarningOrder("WeeklyPlanNotWritten");
            UpdateEaryWarningOrder("ApplicationToBeReviewed");

            runAlterWarningCode();

            //增加系统分析图种类
            AddSystemAnalystChart("Active project status");
            AddSystemAnalystChart("Annual project collection status");
            AddSystemAnalystChart("Delayed project status");
            AddSystemAnalystChart("Annual project hours status");
            AddSystemAnalystChart("Active task status");

            //更新系统分析图SqlCode代码
            UpdateSystemAnalystChart("Active project status");
            UpdateSystemAnalystChart("Annual project collection status");
            UpdateSystemAnalystChart("Delayed project status");
            UpdateSystemAnalystChart("Annual project hours status");
            UpdateSystemAnalystChart("Active task status");

            //给活动用户分配项目横向分析图
            addSystemHAnalystChartToActiveUser();

            //更新系统分析图表中的中文名称为英文名称
            updateSystemAnalystChartChineseNameToEnglishName();

            //更新系统分析图关联用户表中的中文名称为英文名称
            updateSystemAnalystChartChineseNameToEnglishNameForRelatedUserCode();

            //为项目宝版本更新系统分析图名称错误
            updateSystemAnalystChartNameForXMBError();

            //删除系统分析图用户关联表中的不可用和多余的数据
            deleteSystemAnalystChartRelatedUserInvalidData();

            //增加横向分析图给指定用户
            addHChartToSpecialUser(strUserCode);

            //更新系统分析图用户关联表中分析图的排序号
            updateSystemAnalystChartSortNumberForRelatedUser();

            //删除系统分析图用户关联表中的不可用和多余的数据
            deleteSystemAnalystChartRelatedUserInvalidData();

            //增加模块操作导航图模块
            ShareClass.InitializeOperateNavigationModuleForAllUserTypes();

            //初始化模块操作导航的路线定义
            ShareClass.UpdateModuleFlowDefinition();

            //设置数据库只读用户的只读密码，一般于报表设计者
            SetDBUserIDPasswordForDBOnlyReadUser();

            //设额外代码运行标记
            SetNormalOtherCodeMark(intRunMark);

            ////判断现有系统是否已经在使用，正式使用了则执行下面代码
            //if (intUserNumber > 2)
            //{
            //    //禁用实施阶段的基础数据删除功能
            //    UpdateIsCanClearBaseData(strUserCode, strUserName);
            //}
        }
    }

    //取普通额外代码运行标记
    public static int GetNormalOtherCodeRunMark()
    {
        string strHQL;
        int intMark = 0;
        strHQL = "Select NormalCodeRunMark From T_OtherCodeRunMark";
        DataSet dataSet = ShareClass.GetDataSetFromSql(strHQL, "T_OtherCodeRunMark");
        if (dataSet.Tables[0].Rows.Count > 0)
        {
            intMark = Convert.ToInt32(dataSet.Tables[0].Rows[0]["NormalCodeRunMark"].ToString());
        }
        else
        {
            intMark = 0;
        }

        return intMark;
    }

    //设额外代码运行标记
    public static void SetNormalOtherCodeMark(int intMark)
    {
        string strHQL;
        strHQL = "Update T_OtherCodeRunMark Set NormalCodeRunMark = " + intMark;
        ShareClass.RunSqlCommand(strHQL);
    }

    //增加系统分析图种类
    protected static void AddSystemAnalystChart(string strChartName)
    {
        string strHQL;
        string strChartType, strSqlCode;

        strHQL = "From SystemAnalystChartManagement as systemAnalystChartManagement Where systemAnalystChartManagement.ChartName = '" + strChartName + "'";
        SystemAnalystChartManagementBLL systemAnalystChartManagementBLL = new SystemAnalystChartManagementBLL();
        SystemAnalystChartManagement systemAnalystChartManagement = new SystemAnalystChartManagement();
        IList lst = systemAnalystChartManagementBLL.GetAllSystemAnalystChartManagements(strHQL);
        if (lst.Count > 0)
        {
            return;
        }

        if (strChartName == "Active project status")
        {
            strChartType = "HRuningProjectStatus";

            strSqlCode = @"WITH ProjectData AS (
    SELECT 
        Status,
        EXTRACT(YEAR FROM begindate) AS BeginYear
    FROM T_Project
    WHERE PMCode = '[TAKETOPUSERCODE]'
      AND Status IN ('InProgress', 'Acceptance', 'CaseClosed')
)
SELECT 
    COUNT(*) AS XName,
    (SUM(CASE WHEN Status = 'InProgress' AND BeginYear = EXTRACT(YEAR FROM CURRENT_DATE) THEN 1 ELSE 0 END) || ',' ||
     SUM(CASE WHEN Status IN ('Acceptance', 'CaseClosed') AND BeginYear = EXTRACT(YEAR FROM CURRENT_DATE) THEN 1 ELSE 0 END)) AS YNumber
FROM ProjectData
WHERE Status = 'InProgress';";

            systemAnalystChartManagement.ChartType = strChartType;
            systemAnalystChartManagement.ChartName = strChartName;
            systemAnalystChartManagement.SqlCode = strSqlCode;
            systemAnalystChartManagement.LinkURL = "";

            systemAnalystChartManagement.Status = "YES";

            try
            {
                systemAnalystChartManagementBLL.AddSystemAnalystChartManagement(systemAnalystChartManagement);
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strChartName == "Annual project collection status")
        {
            strChartType = "HAnnualPaymentStatus";

            strSqlCode = @"WITH ProjectIDs AS (
    SELECT ProjectID
    FROM T_Project
    WHERE PMCode = '[TAKETOPUSERCODE]'
),
CurrentYear AS (
    SELECT EXTRACT(YEAR FROM CURRENT_DATE) AS CurrentYear
)
SELECT 
    A.XName AS XName,
    (B.YNumber || ',' || C.ZNumber) AS YNumber
FROM (
    SELECT COALESCE(SUM(receiveraccount), 0) AS XName
    FROM public.t_constractreceivables
    WHERE RelatedType = 'Project'
      AND RelatedID IN (SELECT ProjectID FROM ProjectIDs)
      AND EXTRACT(YEAR FROM receivertime) = (SELECT CurrentYear FROM CurrentYear)
) AS A,
(
    SELECT COALESCE(SUM(RealCharge), 0) AS YNumber
    FROM v_procurrentyearrealcharge
    WHERE ProjectID IN (SELECT ProjectID FROM ProjectIDs)
      AND EXTRACT(YEAR FROM effectdate) = (SELECT CurrentYear FROM CurrentYear)
) AS B,
(
    SELECT COUNT(*) AS ZNumber
    FROM V_ProRealCharge A
    JOIN T_Project B ON A.ProjectID = B.ProjectID
    WHERE A.ProjectID IN (SELECT ProjectID FROM ProjectIDs)
      AND A.RealCharge > B.Budget
) AS C;";

            systemAnalystChartManagement.ChartType = strChartType;
            systemAnalystChartManagement.ChartName = strChartName;
            systemAnalystChartManagement.SqlCode = strSqlCode;
            systemAnalystChartManagement.LinkURL = "";

            systemAnalystChartManagement.Status = "YES";

            try
            {
                systemAnalystChartManagementBLL.AddSystemAnalystChartManagement(systemAnalystChartManagement);
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strChartName == "Delayed project status")
        {
            strChartType = "HDelayProjectStatus";

            strSqlCode = @"WITH ProjectData AS (
    SELECT
        FinishPercent,
        EndDate
    FROM T_Project
    WHERE PMCode = '[TAKETOPUSERCODE]'
)
SELECT
    (SELECT COUNT(*) FROM ProjectData WHERE FinishPercent < 100 AND now() > (EndDate + interval '30 days')) AS XName,
    (
        (SELECT COUNT(*) FROM ProjectData WHERE FinishPercent = 100 AND now() > EndDate) || ',' ||
        (SELECT COUNT(*) FROM ProjectData WHERE FinishPercent < 100 AND now() < (EndDate + interval '10 days') AND now() > EndDate)
    ) AS YNumber;";

            systemAnalystChartManagement.ChartType = strChartType;
            systemAnalystChartManagement.ChartName = strChartName;
            systemAnalystChartManagement.SqlCode = strSqlCode;
            systemAnalystChartManagement.LinkURL = "";

            systemAnalystChartManagement.Status = "YES";

            try
            {
                systemAnalystChartManagementBLL.AddSystemAnalystChartManagement(systemAnalystChartManagement);
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strChartName == "Annual project hours status")
        {
            strChartType = "HAnnualWorkHourStatus";

            strSqlCode = @"WITH ProjectIDs AS (
    SELECT ProjectID
    FROM T_Project
    WHERE PMCode = '[TAKETOPUSERCODE]'
),
FilteredDailyWork AS (
    SELECT
        ManHour,
        UserCode,
        Confirmbonus
    FROM public.T_DailyWork
    WHERE ProjectID IN (SELECT ProjectID FROM ProjectIDs)
      AND EXTRACT(YEAR FROM WorkDate) = EXTRACT(YEAR FROM CURRENT_DATE)
)
SELECT
    COALESCE(SUM(ManHour), 0) AS XName,
    (COUNT(DISTINCT UserCode) || ',' || COALESCE(SUM(Confirmbonus), 0)) AS YNumber
FROM FilteredDailyWork;";

            systemAnalystChartManagement.ChartType = strChartType;
            systemAnalystChartManagement.ChartName = strChartName;
            systemAnalystChartManagement.SqlCode = strSqlCode;
            systemAnalystChartManagement.LinkURL = "";

            systemAnalystChartManagement.Status = "YES";

            try
            {
                systemAnalystChartManagementBLL.AddSystemAnalystChartManagement(systemAnalystChartManagement);
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strChartName == "Active task status")
        {
            strChartType = "HRuningTaskStatus";

            strSqlCode = @"WITH TaskData AS (
    SELECT
        Status,
        finishpercent,
        EXTRACT(YEAR FROM begindate) AS BeginYear
    FROM T_ProjectTask
    WHERE makemancode = '[TAKETOPUSERCODE]'
      AND (
          (finishpercent < 100 AND Status = 'InProgress') OR
          (finishpercent = 100 AND Status IN ('Completed', 'Closed'))
      )
)
SELECT
    (SELECT COUNT(*) FROM TaskData WHERE finishpercent < 100 AND Status = 'InProgress') AS XName,
    (
        (SELECT COUNT(*) FROM TaskData WHERE finishpercent < 100 AND Status = 'InProgress' AND BeginYear = EXTRACT(YEAR FROM CURRENT_DATE)) || ',' ||
        (SELECT COUNT(*) FROM TaskData WHERE finishpercent = 100 AND Status IN ('Completed', 'Closed') AND BeginYear = EXTRACT(YEAR FROM CURRENT_DATE))
    ) AS YNumber;";

            systemAnalystChartManagement.ChartType = strChartType;
            systemAnalystChartManagement.ChartName = strChartName;
            systemAnalystChartManagement.SqlCode = strSqlCode;
            systemAnalystChartManagement.LinkURL = "";

            systemAnalystChartManagement.Status = "YES";

            try
            {
                systemAnalystChartManagementBLL.AddSystemAnalystChartManagement(systemAnalystChartManagement);
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }
    }

    //更新系统分析图SqlCode代码
    public static void UpdateSystemAnalystChart(string strChartName)
    {
        string strHQL;
        int intID = 0;

        strHQL = "From SystemAnalystChartManagement as systemAnalystChartManagement Where systemAnalystChartManagement.ChartName = '" + strChartName + "'";
        SystemAnalystChartManagementBLL systemAnalystChartManagementBLL = new SystemAnalystChartManagementBLL();
        IList lst = systemAnalystChartManagementBLL.GetAllSystemAnalystChartManagements(strHQL);
        if (lst.Count > 0)
        {
            SystemAnalystChartManagement systemAnalystChartManagement = (SystemAnalystChartManagement)lst[0];

            intID = systemAnalystChartManagement.ID;

            if (strChartName == "Active project status")
            {
                systemAnalystChartManagement.SqlCode = @"WITH ProjectData AS (
    SELECT 
        Status,
        EXTRACT(YEAR FROM begindate) AS BeginYear
    FROM T_Project
    WHERE PMCode = '[TAKETOPUSERCODE]'
      AND Status IN ('InProgress', 'Acceptance', 'CaseClosed')
)
SELECT 
    COUNT(*) AS XName,
    (SUM(CASE WHEN Status = 'InProgress' AND BeginYear = EXTRACT(YEAR FROM CURRENT_DATE) THEN 1 ELSE 0 END) || ',' ||
     SUM(CASE WHEN Status IN ('Acceptance', 'CaseClosed') AND BeginYear = EXTRACT(YEAR FROM CURRENT_DATE) THEN 1 ELSE 0 END)) AS YNumber
FROM ProjectData
WHERE Status = 'InProgress';";


                try
                {
                    systemAnalystChartManagementBLL.UpdateSystemAnalystChartManagement(systemAnalystChartManagement, intID);
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                }
            }

            if (strChartName == "Delayed project status")
            {
                systemAnalystChartManagement.SqlCode = @"WITH ProjectData AS (
    SELECT
        FinishPercent,
        EndDate
    FROM T_Project
    WHERE PMCode = '[TAKETOPUSERCODE]'
)
SELECT
    (SELECT COUNT(*) FROM ProjectData WHERE FinishPercent < 100 AND now() > (EndDate + interval '30 days')) AS XName,
    (
        (SELECT COUNT(*) FROM ProjectData WHERE FinishPercent = 100 AND now() > EndDate) || ',' ||
        (SELECT COUNT(*) FROM ProjectData WHERE FinishPercent < 100 AND now() < (EndDate + interval '10 days') AND now() > EndDate)
    ) AS YNumber;";


                try
                {
                    systemAnalystChartManagementBLL.UpdateSystemAnalystChartManagement(systemAnalystChartManagement, intID);
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                }
            }

            if (strChartName == "Annual project hours status")
            {
                systemAnalystChartManagement.SqlCode = @"WITH ProjectIDs AS (
    SELECT ProjectID
    FROM T_Project
    WHERE PMCode = '[TAKETOPUSERCODE]'
),
FilteredDailyWork AS (
    SELECT
        ManHour,
        UserCode,
        Confirmbonus
    FROM public.T_DailyWork
    WHERE ProjectID IN (SELECT ProjectID FROM ProjectIDs)
      AND EXTRACT(YEAR FROM WorkDate) = EXTRACT(YEAR FROM CURRENT_DATE)
)
SELECT
    COALESCE(SUM(ManHour), 0) AS XName,
    (COUNT(DISTINCT UserCode) || ',' || COALESCE(SUM(Confirmbonus), 0)) AS YNumber
FROM FilteredDailyWork;";


                try
                {
                    systemAnalystChartManagementBLL.UpdateSystemAnalystChartManagement(systemAnalystChartManagement, intID);
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                }
            }

            if (strChartName == "Annual project collection status")
            {
                systemAnalystChartManagement.SqlCode = @"WITH ProjectIDs AS (
    SELECT ProjectID
    FROM T_Project
    WHERE PMCode = '[TAKETOPUSERCODE]'
),
CurrentYear AS (
    SELECT EXTRACT(YEAR FROM CURRENT_DATE) AS CurrentYear
)
SELECT 
    A.XName AS XName,
    (B.YNumber || ',' || C.ZNumber) AS YNumber
FROM (
    SELECT COALESCE(SUM(receiveraccount), 0) AS XName
    FROM public.t_constractreceivables
    WHERE RelatedType = 'Project'
      AND RelatedID IN (SELECT ProjectID FROM ProjectIDs)
      AND EXTRACT(YEAR FROM receivertime) = (SELECT CurrentYear FROM CurrentYear)
) AS A,
(
    SELECT COALESCE(SUM(RealCharge), 0) AS YNumber
    FROM v_procurrentyearrealcharge
    WHERE ProjectID IN (SELECT ProjectID FROM ProjectIDs)
      AND EXTRACT(YEAR FROM effectdate) = (SELECT CurrentYear FROM CurrentYear)
) AS B,
(
    SELECT COUNT(*) AS ZNumber
    FROM V_ProRealCharge A
    JOIN T_Project B ON A.ProjectID = B.ProjectID
    WHERE A.ProjectID IN (SELECT ProjectID FROM ProjectIDs)
      AND A.RealCharge > B.Budget
) AS C;";


                try
                {
                    systemAnalystChartManagementBLL.UpdateSystemAnalystChartManagement(systemAnalystChartManagement, intID);
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                }
            }

            if (strChartName == "Active task status")
            {
                systemAnalystChartManagement.SqlCode = @"WITH TaskData AS (
    SELECT
        Status,
        finishpercent,
        EXTRACT(YEAR FROM begindate) AS BeginYear
    FROM T_ProjectTask
    WHERE makemancode = '[TAKETOPUSERCODE]'
      AND (
          (finishpercent < 100 AND Status = 'InProgress') OR
          (finishpercent = 100 AND Status IN ('Completed', 'Closed'))
      )
)
SELECT
    (SELECT COUNT(*) FROM TaskData WHERE finishpercent < 100 AND Status = 'InProgress') AS XName,
    (
        (SELECT COUNT(*) FROM TaskData WHERE finishpercent < 100 AND Status = 'InProgress' AND BeginYear = EXTRACT(YEAR FROM CURRENT_DATE)) || ',' ||
        (SELECT COUNT(*) FROM TaskData WHERE finishpercent = 100 AND Status IN ('Completed', 'Closed') AND BeginYear = EXTRACT(YEAR FROM CURRENT_DATE))
    ) AS YNumber;";


                try
                {
                    systemAnalystChartManagementBLL.UpdateSystemAnalystChartManagement(systemAnalystChartManagement, intID);
                }
                catch (Exception err)
                {
                    LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
                }
            }
        }
    }


    //增加横向分析图给指定用户
    public static void addHChartToSpecialUser(string strUserCode)
    {
        string strHQL;

        try
        {
            strHQL = string.Format(@"Insert Into t_systemanalystchartrelateduser(UserCode,ChartName,FormType,SortNumber) Select '{0}',ChartName,'PersonalSpacePage',1
                    From t_systemanalystchartmanagement Where ChartName In ('Active project status','Delayed project status','Annual project hours status','Annual project collection status','Active task status','Project status I lead')
                    and ChartName Not In (Select ChartName From t_systemanalystchartrelateduser Where UserCode = '{0}')
                    and ChartName Not In (Select ChartName From t_systemanalystchartmanagement Where Status = 'NO')
                    ", strUserCode);
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }


    //增加预警命令
    public static void AddEarlyWarningOrder(string strFunName)
    {
        string strHQL, strUpdateHQL;
        IList lst;

        strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
        FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
        lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
        if (lst.Count > 0)
        {
            return;
        }

        if (strFunName == "DefectToHandle")
        {
            try
            {

                FunInforDialBox funInforDialBox = new FunInforDialBox();

                strUpdateHQL = @"select * from T_DefectAssignRecord as defectAssignRecordBySystem where defectAssignRecordBySystem.OperatorCode = '[TAKETOPUSERCODE]' 
                    and defectAssignRecordBySystem.Status in ('Plan','Accepted','ToHandle') and defectAssignRecordBySystem.ID not in (select defectAssignRecord.PriorID 
                    from T_DefectAssignRecord as defectAssignRecord) and defectAssignRecordBySystem.DefectID in 
                    (select defectment.DefectID from T_Defectment as defectment where defectment.Status not in ('Closed','Hided','Deleted','Archived'))
                    Order by defectAssignRecordBySystem.ID DESC";

                funInforDialBox.Status = "Enabled";
                funInforDialBox.SQLCode = strUpdateHQL;
                funInforDialBox.InforName = strFunName;
                funInforDialBox.HomeName = strFunName;
                funInforDialBox.LangCode = HttpContext.Current.Session["LangCode"].ToString();
                funInforDialBox.CreateTime = DateTime.Now;
                funInforDialBox.BoxType = "SYS";
                funInforDialBox.UserType = "INNER";
                funInforDialBox.IsForceInfor = "NO";
                funInforDialBox.LinkAddress = "TTDefectHandlePage.aspx";
                funInforDialBox.MobileLinkAddress = "TTDefectHandlePage.aspx";
                funInforDialBox.IsSendMsg = "YES";
                funInforDialBox.IsSendEmail = "YES";

                funInforDialBoxBLL.AddFunInforDialBox(funInforDialBox);

            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }
    }


    //更改预警命令
    public static void UpdateEaryWarningOrder(string strFunName)
    {
        string strHQL, strUpdateHQL;
        IList lst;

        int intID;

        if (strFunName == "TasksToHandle")
        {
            try
            {
                strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
                FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
                lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
                FunInforDialBox funInforDialBox = (FunInforDialBox)lst[0];

                intID = funInforDialBox.ID;

                strUpdateHQL = @"select * from T_TaskAssignRecord as taskAssignRecordBySystem where taskAssignRecordBySystem.OperatorCode = '[TAKETOPUSERCODE]' 
                          and taskAssignRecordBySystem.Status in ('Plan','Accepted','InProgress','ToHandle','InProgress') and taskAssignRecordBySystem.ID not in 
                          (select taskAssignRecord.PriorID from T_TaskAssignRecord as taskAssignRecord) 
                          and taskAssignRecordBySystem.TaskID in (select projectTask.TaskID from T_ProjectTask as projectTask 
                          where projectTask.Status <> 'Closed') and taskAssignRecordBySystem.TaskID in (select projectTask.TaskID from T_ProjectTask as projectTask 
                          where (projectTask.ProjectID = 1) or (projectTask.ProjectID in (select project.ProjectID from T_Project as project
                          where project.Status not in ('New','Hided','Deleted','Archived')))) Order by taskAssignRecordBySystem.ID DESC";

                if (funInforDialBox.SQLCode != strUpdateHQL)
                {
                    funInforDialBox.SQLCode = strUpdateHQL;

                    funInforDialBoxBLL.UpdateFunInforDialBox(funInforDialBox, intID);
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strFunName == "RequirementsToHandle")
        {
            try
            {
                strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
                FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
                lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
                FunInforDialBox funInforDialBox = (FunInforDialBox)lst[0];

                intID = funInforDialBox.ID;

                strUpdateHQL = @"select * from T_ReqAssignRecord as reqAssignRecordBySystem where reqAssignRecordBySystem.OperatorCode = '[TAKETOPUSERCODE]' 
                    and reqAssignRecordBySystem.Status in ('Plan','Accepted','ToHandle') and reqAssignRecordBySystem.ID not in (select reqAssignRecord.PriorID 
                    from T_ReqAssignRecord as reqAssignRecord) and reqAssignRecordBySystem.ReqID in 
                    (select requirement.ReqID from T_Requirement as requirement where requirement.Status not in ('Closed','Hided','Deleted','Archived'))
                    Order by reqAssignRecordBySystem.ID DESC";

                if (funInforDialBox.SQLCode != strUpdateHQL)
                {
                    funInforDialBox.SQLCode = strUpdateHQL;

                    funInforDialBoxBLL.UpdateFunInforDialBox(funInforDialBox, intID);
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strFunName == "ApplicationToBeReviewed")
        {
            try
            {
                strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
                FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
                lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
                FunInforDialBox funInforDialBox = (FunInforDialBox)lst[0];

                intID = funInforDialBox.ID;


                strUpdateHQL = string.Format(@"Select * From (Select A.ID,A.StepID,A.WorkDetail,B.CreatorCode,B.CreatorName,A.Requisite,A.Operation,A.CheckingTime,A.WLID,Rtrim(cast(A.WLID as char(20))) || '. ' || B.WLName as WLName,B.Status From T_WorkFlowStepDetail A,T_WorkFlow B 
                 Where A.WLID = B.WLID And A.Status In ('InProgress','Reviewing','Signing','ReReview') 
                 And B.Status Not In ('Updating','Closed','Passed','CaseClosed') And (trim(A.OperatorCode) = '{0}' Or A.OperatorCode in ( Select UserCode From T_MemberLevel Where UnderCode <> UserCode and UnderCode = '{0}' and AgencyStatus = 1))
																 And A.IsOperator = 'YES' ) C Order By C.StepID DESC", "[TAKETOPUSERCODE]");

                if (funInforDialBox.SQLCode != strUpdateHQL)
                {
                    funInforDialBox.SQLCode = strUpdateHQL;

                    funInforDialBoxBLL.UpdateFunInforDialBox(funInforDialBox, intID);
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strFunName == "BidsToHandle")
        {
            try
            {
                strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
                FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
                lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
                FunInforDialBox funInforDialBox = (FunInforDialBox)lst[0];

                intID = funInforDialBox.ID;

                strUpdateHQL = @"Select *  From T_Tender_HYYQ Where  IsTender <> 0 and rtrim(TenderBuyTime) <= to_char(now()+(TenderBuyDay+1)* interval '1 day','yyyymmdd')  and (CreatorCode = '[TAKETOPUSERCODE]' or ID in (Select TenderID from T_TenderRelatedUser where UserCode = '[TAKETOPUSERCODE]')) and TenderCode like '%%'  and ProjectName like '%%'  
                        UNION
                        Select *  From T_Tender_HYYQ Where  IsMargin <> 0 and rtrim(MarginTime) <= to_char(now()+(MarginDay+1)* interval '1 day','yyyymmdd')  and (CreatorCode = '[TAKETOPUSERCODE]' or ID in (Select TenderID from T_TenderRelatedUser where UserCode = '[TAKETOPUSERCODE]')) and TenderCode like '%%'  and ProjectName like '%%'  
                        UNION
                        Select *  From T_Tender_HYYQ Where  IsReceiveMargin <> 0 and to_char(cast(ReceiveMarginTime as date),'yyyymmdd') <= to_char(now()+ReceiveMarginDay* interval '1 day','yyyymmdd')  and (CreatorCode = '[TAKETOPUSERCODE]' or ID in (Select TenderID from T_TenderRelatedUser where UserCode = '[TAKETOPUSERCODE]')) and TenderCode like '%%'  and ProjectName like '%%'  
                        UNION
                        Select *  From T_Tender_HYYQ Where  IsBidOpening <> 0 and rtrim(BidOpeningDate) <= to_char(now()+(BidOpeningDay+1)* interval '1 day','yyyymmdd')  and (CreatorCode = '[TAKETOPUSERCODE]' or ID in (Select TenderID from T_TenderRelatedUser where UserCode = '[TAKETOPUSERCODE]')) and TenderCode like '%%'  and ProjectName like '%%'  
                        UNION
                        Select *  From T_Tender_HYYQ Where  IsWinningFee <> 0 and rtrim(WinningFeeDate) <= to_char(now()+(WinningFeeDay+1)* interval '1 day','yyyymmdd')  and (CreatorCode = '[TAKETOPUSERCODE]' or ID in (Select TenderID from T_TenderRelatedUser where UserCode = '[TAKETOPUSERCODE]')) and TenderCode like '%%'  and ProjectName like '%%'";

                if (funInforDialBox.SQLCode != strUpdateHQL)
                {
                    funInforDialBox.SQLCode = strUpdateHQL;

                    funInforDialBoxBLL.UpdateFunInforDialBox(funInforDialBox, intID);
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strFunName == "DelayedProjectPlan")
        {
            try
            {
                strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
                FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
                lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
                FunInforDialBox funInforDialBox = (FunInforDialBox)lst[0];

                intID = funInforDialBox.ID;

                strUpdateHQL = @"------------------------本人的项目计划------------------ 
                    select distinct PlanID,PlanDetail,BeginTime,EndTime,Budget,ExpireDay,Status,ParentIDGantt,LeaderCode,Leader,
	                    PriorID,Type,VerID,Percent_Done,DefaultSchedule,Expense,DefaultCost,ProjectID,ProjectName,PMCode,PMName  
	                    from V_ProjectPlanList
	                    where PMCode =  '[TAKETOPUSERCODE]'
	                    and Expireday > 1  --拖延天数，改成你需要的天数 
	
	                    and ParentIDGantt > 0
	                    and Percent_Done < 100
	                    and PlanID not In (Select ParentIDGantt From T_ImplePlan)
	
                     UNION
                     ------------------------主管的直接成员的项目计划------------------ 
                     select distinct PlanID,PlanDetail,BeginTime,EndTime,Budget,ExpireDay,Status,ParentIDGantt,LeaderCode,Leader,
	                    PriorID,Type,VerID,Percent_Done,DefaultSchedule,Expense,DefaultCost,ProjectID,ProjectName,PMCode,PMName 
	                    from V_ProjectPlanList
	                    where PMCode in (Select UserCode From T_MemberLevel Where UserCode = '[TAKETOPUSERCODE]'  and ProjectVisible = 'YES' )  
                        and Expireday > 5   --拖延天数，改成你需要的天数 
	   
	                    and ParentIDGantt > 0
	                    and Percent_Done < 100
	                    and PlanID not In (Select ParentIDGantt From T_ImplePlan)
           
                     UNION
                     ------------------------主管的所有成员的项目计划------------------ 
                    select distinct PlanID,PlanDetail,BeginTime,EndTime,Budget,ExpireDay,Status,ParentIDGantt,LeaderCode,Leader,
	                    PriorID,Type,VerID,Percent_Done,DefaultSchedule,Expense,DefaultCost,ProjectID,ProjectName,PMCode,PMName 
	                    from V_ProjectPlanList
	                    Where PMCode in (Select UserCode From T_ProjectMember Where DepartCode in (''))
                        and Expireday > 5   --拖延天数，改成你需要的天数 
	   
	                    and ParentIDGantt > 0
	                    and Percent_Done < 100
	                    and PlanID not In (Select ParentIDGantt From T_ImplePlan)";

                if (funInforDialBox.SQLCode != strUpdateHQL)
                {
                    funInforDialBox.SQLCode = strUpdateHQL;

                    funInforDialBoxBLL.UpdateFunInforDialBox(funInforDialBox, intID);
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strFunName == "ContractPrepaymentWarning")
        {
            try
            {
                strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
                FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
                lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
                FunInforDialBox funInforDialBox = (FunInforDialBox)lst[0];

                intID = funInforDialBox.ID;

                strUpdateHQL = @"select ID from T_ConstractReceivables as constractReceivablesBySystem 
                     where constractReceivablesBySystem.Status not in ('Completed','Cancel') 
                     and to_char(constractReceivablesBySystem.ReceivablesTime,'yyyymmdd') <=to_char(now()+interval '1 day','yyyymmdd') 
                     and constractReceivablesBySystem.ConstractCode in (Select constractRelatedUser.ConstractCode from T_ConstractRelatedUser as constractRelatedUser where constractRelatedUser.UserCode = '[TAKETOPUSERCODE]') 
                     and constractReceivablesBySystem.ConstractCode not in (Select constract.ConstractCode from T_Constract as constract where constract.Status  in ('Archived','Cancel','Deleted')) 
                     union all select ID from T_ConstractPayable as constractPayableBySystem where constractPayableBySystem.Status not in ('Completed','Cancel') 
                     and to_char(constractPayableBySystem.PayableTime,'yyyymmdd') <= to_char(now()+PreDays*interval '1 day','yyyymmdd') 
                     and constractPayableBySystem.ConstractCode in (Select constractRelatedUser.ConstractCode from T_ConstractRelatedUser as constractRelatedUser 
                     where constractRelatedUser.UserCode= '[TAKETOPUSERCODE]') and constractPayableBySystem.ConstractCode 
                     not in (Select constract.ConstractCode from T_Constract as constract where constract.Status in ('Archived','Cancel','Deleted'))";

                if (funInforDialBox.SQLCode != strUpdateHQL)
                {
                    funInforDialBox.SQLCode = strUpdateHQL;

                    funInforDialBoxBLL.UpdateFunInforDialBox(funInforDialBox, intID);
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strFunName == "MeetingToAttend")
        {
            try
            {
                strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
                FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
                lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
                FunInforDialBox funInforDialBox = (FunInforDialBox)lst[0];

                intID = funInforDialBox.ID;

                strUpdateHQL = @"select * from T_Meeting as meetingBySystem where meetingBySystem.ID in (select meetingAttendant.MeetingID from T_MeetingAttendant as meetingAttendant 
                  where meetingAttendant.UserCode = '[TAKETOPUSERCODE]') and meetingBySystem.EndTime > now() order by meetingBySystem.ID DESC";

                if (funInforDialBox.SQLCode != strUpdateHQL)
                {
                    funInforDialBox.SQLCode = strUpdateHQL;

                    funInforDialBoxBLL.UpdateFunInforDialBox(funInforDialBox, intID);
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        if (strFunName == "WeeklyPlanNotWritten")
        {
            try
            {
                strHQL = "From FunInforDialBox as funInforDialBox where funInforDialBox.InforName = '" + strFunName + "'";
                FunInforDialBoxBLL funInforDialBoxBLL = new FunInforDialBoxBLL();
                lst = funInforDialBoxBLL.GetAllFunInforDialBoxs(strHQL);
                FunInforDialBox funInforDialBox = (FunInforDialBox)lst[0];

                intID = funInforDialBox.ID;

                strUpdateHQL = @"Select * From T_ProjectMember  Where UserCode = '[TAKETOPUSERCODE]' and UserCode not in 
                       (Select CreatorCode From T_Plan Where to_char(StartTime,'yyyymmdd') >= to_char(now()-(extract(DOW FROM now())-2) * interval '1 day','yyyymmdd') 
                       and to_char(EndTime,'yyyymmdd')  <=  to_char(now()+(8-extract(DOW FROM now()))* interval '1 day','yyyymmdd'));";

                if (funInforDialBox.SQLCode != strUpdateHQL)
                {
                    funInforDialBox.SQLCode = strUpdateHQL;

                    funInforDialBoxBLL.UpdateFunInforDialBox(funInforDialBox, intID);
                }
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }
    }


    //设置数据库只读用户的只读密码，一般于报表设计者
    protected static void SetDBUserIDPasswordForDBOnlyReadUser()
    {
        string strHQL1, strHQL2;
        string strDBReadOnlyUserID, strDBReadOnlyUserPassword;

        strDBReadOnlyUserID = ShareClass.getDBReadOnlyUserID();
        strDBReadOnlyUserPassword = ShareClass.genernalPassword();

        try
        {
            strHQL1 = "Select Password From T_DBReadOnlyUserInfor";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL1, "T_DBReadOnlyUserInfor");
            if (ds.Tables[0].Rows.Count == 0)
            {
                strHQL2 = string.Format("Insert Into T_DBReadOnlyUserInfor(DBUserID,Password) values('{0}','{1}')", strDBReadOnlyUserID, strDBReadOnlyUserPassword);
                ShareClass.RunSqlCommand(strHQL2);
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile(err.Message.ToString());
        }
    }


    //禁用实施阶段的基础数据删除功能
    public static void UpdateIsCanClearBaseData(string strUserCode, string strUserName)
    {
        string strHQL1, strHQL2;

        try
        {
            strHQL1 = "Select * from T_SystemDataManageForBeginer Where OperationName = 'ClearData'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL1, "T_SystemDataManageForBeginer");
            if (ds.Tables[0].Rows.Count == 0)
            {
                strHQL2 = string.Format(@"Insert Into T_SystemDataManageForBeginer(OperationName,IsForbit,OperatorCode,OperatorName,Operatetime,IsBackup)
                      Values('{0}','{1}','{2}','{3}',now(),'YES')", "ClearData", "YES", strUserCode, strUserName);

                ShareClass.RunSqlCommand(strHQL2);
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }



    //给活动用户分配分析图  
    private static void addSystemHAnalystChartToActiveUser()
    {
        string strHQL;

        strHQL = @"Insert Into public.t_systemanalystchartrelateduser(UserCode,chartName,FormType,SortNumber)
               Select B.UserCode,A.chartName,'PersonalSpacePage',1 From t_systemanalystchartmanagement A,public.t_systemactiveuser B
                 Where A.ChartName 
	             Not In (Select ChartName From t_systemanalystchartrelateduser Where UserCode = B.UserCode and FormType = 'PersonalSpacePage' )
                 and A.ChartName Not In (Select ChartName From t_systemanalystchartmanagement Where Status = 'NO')
	             and A.ChartName in ('Active project status','Delayed project status','Annual project hours status','Active task status','Annual project collection status','Project status I lead');";
        ShareClass.RunSqlCommand(strHQL);
    }

    protected static void runAlterWarningCode()
    {
        string strHQL;
        strHQL = @"UPDATE t_funinfordialbox
			SET inforname = CASE
			WHEN inforname = '要审核的申请' THEN 'ApplicationToBeReviewed'
			WHEN inforname = '要处理的协作' THEN 'CollaborationToHandle'
			WHEN inforname = '拖期的项目计划' THEN 'DelayedProjectPlan'
			WHEN inforname = '待处理的缺陷' THEN 'DefectsToHandle'
			WHEN inforname = '未写本周计划' THEN 'WeeklyPlanNotWritten'
			WHEN inforname = '要参加的会议' THEN 'MeetingToAttend'
			WHEN inforname = '待阅读的报表' THEN 'ReportsToRead'
			WHEN inforname = '待批准的计划' THEN 'PlansForApproval'
			WHEN inforname = '待批核的绩效' THEN 'PerformanceForApproval'
			WHEN inforname = '合同预付预警' THEN 'ContractPrepaymentWarning'
			WHEN inforname = '待处理的项目' THEN 'ProjectsToHandle'
			WHEN inforname = '待处理的风险' THEN 'RisksToHandle'
			WHEN inforname = '待处理的需求' THEN 'RequirementsToHandle'
			WHEN inforname = '待处理的任务' THEN 'TasksToHandle'
			WHEN inforname = '未阅读的邮件' THEN 'EmailsUnread'
			WHEN inforname = '要处理的投标' THEN 'BidsToHandle'
			ELSE inforname -- 如果没有匹配，则保留原值
			END;";
        ShareClass.RunSqlCommand(strHQL);
    }

    //更新分析图名称
    protected static void updateSystemAnalystChartChineseNameToEnglishName()
    {
        string strHQL;

        strHQL = @"Update public.t_systemanalystchartmanagement Set ChartName = 'Plan status' Where ChartName = '计划状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Task status' Where ChartName = '任务状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'My sales order status' Where ChartName = '我的销售单状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'My purchase order status' Where ChartName = '我的采购单状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'The status of the project I initiated' Where ChartName = '我立项的项目状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Direct members project status' Where ChartName = '直接成员的项目状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'All member project status' Where ChartName = '所有成员的项目状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'My production order status' Where ChartName = '我的生产单状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Direct member production order status' Where ChartName = '直接成员的生产单状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Project status I am involved in' Where ChartName = '我参与的项目状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Direct member opportunity status' Where ChartName = '直接成员的商机状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'All member opportunity status' Where ChartName = '所有成员的商机状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'My recorded opportunity status' Where ChartName = '我记录的商机状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Contract status' Where ChartName = '合同状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Contract Type' Where ChartName = '合同类型';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Direct member sales order status' Where ChartName = '直接成员的销售单状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'My opportunity status' Where ChartName = '我的商机状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Project status I lead' Where ChartName = '我主导的项目状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Workflow status' Where ChartName = '工作流状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Direct member purchase order status' Where ChartName = '直接成员的采购单状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Delayed project status' Where ChartName = '延误项目状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Annual project hours status' Where ChartName = '年度项目工时状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Active project status' Where ChartName = '在执行项目状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Annual project collection status' Where ChartName = '项目年度回款状态';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Active task status' Where ChartName = '在执行任务状态';";
        ShareClass.RunSqlCommand(strHQL);
    }

    //更新系统分析图关联用户表中的中文名称为英文名称
    protected static void updateSystemAnalystChartChineseNameToEnglishNameForRelatedUserCode()
    {
        string strHQL;

        strHQL = @"Update public.t_systemanalystchartrelateduser Set ChartName = 'Plan status' Where ChartName = '计划状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Task status' Where ChartName = '任务状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'My sales order status' Where ChartName = '我的销售单状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'My purchase order status' Where ChartName = '我的采购单状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'The status of the project I initiated' Where ChartName = '我立项的项目状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct members project status' Where ChartName = '直接成员的项目状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'All member project status' Where ChartName = '所有成员的项目状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'My production order status' Where ChartName = '我的生产单状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct member production order status' Where ChartName = '直接成员的生产单状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Project status I am involved in' Where ChartName = '我参与的项目状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct member opportunity status' Where ChartName = '直接成员的商机状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'All member opportunity status' Where ChartName = '所有成员的商机状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'My recorded opportunity status' Where ChartName = '我记录的商机状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Contract status' Where ChartName = '合同状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Contract Type' Where ChartName = '合同类型';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct member sales order status' Where ChartName = '直接成员的销售单状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'My opportunity status' Where ChartName = '我的商机状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Project status I lead' Where ChartName = '我主导的项目状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Workflow status' Where ChartName = '工作流状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct member purchase order status' Where ChartName = '直接成员的采购单状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Delayed project status' Where ChartName = '延误项目状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Annual project hours status' Where ChartName = '年度项目工时状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Active project status' Where ChartName = '在执行项目状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Annual project collection status' Where ChartName = '项目年度回款状态';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Active task status' Where ChartName = '在执行任务状态';";
        ShareClass.RunSqlCommand(strHQL);
    }


    protected static void updateSystemAnalystChartNameForXMBError()
    {
        string strHQL;

        strHQL = @"Update public.t_systemanalystchartmanagement Set ChartName = 'Direct member purchase order status' Where ChartName = 'my member purchase order status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Project status I lead' Where ChartName = 'my projects status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Direct members project status' Where ChartName = 'my member project status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Direct member opportunity statu' Where ChartName = 'my member business opportunity status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'All member project status' Where ChartName = 'all member projects status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'All member opportunity status' Where ChartName = 'all members business opportunity status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Workflow statu' Where ChartName = 'workflow status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'My recorded opportunity status' Where ChartName = 'my business opportunity status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Direct member sales order status' Where ChartName = 'my member sale order status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Contract Type' Where ChartName = 'contract type';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'My recorded opportunity status' Where ChartName = 'i recorded business opportunity status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Annual project hours status' Where ChartName = 'Aanua project workHour status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Annual project collection status' Where ChartName = 'project annual payment status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'My sales order status' Where ChartName = 'my sale order status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Plan status' Where ChartName = 'work plan status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Active task status' Where ChartName = 'running tasks status';
                    Update public.t_systemanalystchartmanagement Set ChartName = 'Delayed project status' Where ChartName = 'delay proejct status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct member purchase order status' Where ChartName = 'my member purchase order status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Project status I lead' Where ChartName = 'my projects status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct members project status' Where ChartName = 'my member project status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct member opportunity statu' Where ChartName = 'my member business opportunity status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'All member project status' Where ChartName = 'all member projects status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'All member opportunity status' Where ChartName = 'all members business opportunity status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Workflow statu' Where ChartName = 'workflow status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'My recorded opportunity status' Where ChartName = 'my business opportunity status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Direct member sales order status' Where ChartName = 'my member sale order status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Contract Type' Where ChartName = 'contract type';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'My recorded opportunity status' Where ChartName = 'i recorded business opportunity status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Annual project hours status' Where ChartName = 'Aanua project workHour status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Annual project collection status' Where ChartName = 'project annual payment status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'My sales order status' Where ChartName = 'my sale order status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Plan status' Where ChartName = 'work plan status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Active task status' Where ChartName = 'running tasks status';
                    Update public.t_systemanalystchartrelateduser Set ChartName = 'Delayed project status' Where ChartName = 'delay proejct status';";
        ShareClass.RunSqlCommand(strHQL);
    }

    //更新系统分析图用户关联表中分析图的排序号
    protected static void updateSystemAnalystChartSortNumberForRelatedUser()
    {
        try
        {
            string strHQL = @"Update public.t_systemanalystchartrelateduser Set SortNumber = 1 Where ChartName = 'Active project status';
                    Update public.t_systemanalystchartrelateduser Set SortNumber = 2 Where ChartName = 'Delayed project status';
                    Update public.t_systemanalystchartrelateduser Set SortNumber = 3 Where ChartName = 'Annual project hours status';
                    Update public.t_systemanalystchartrelateduser Set SortNumber = 4 Where ChartName = 'Annual project collection status';
                    Update public.t_systemanalystchartrelateduser Set SortNumber = 5 Where ChartName = 'Active task status';
                    Update public.t_systemanalystchartrelateduser Set SortNumber = 6 Where ChartName = 'Project status I lead';
                    Update public.t_systemanalystchartrelateduser Set SortNumber = 10 Where ChartName Not In ('Active project status','Delayed project status','Annual project hours status','Annual project collection status','Active task status','Project status I lead');";
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //删除系统分析图用户关联表中的不可用和多余的数据
    protected static void deleteSystemAnalystChartRelatedUserInvalidData()
    {
        string strHQL;
        strHQL = @"Delete From public.t_systemanalystchartrelateduser Where ChartName In (Select ChartName From public.t_systemanalystchartmanagement Where Status = 'NO')
                   or ChartName Not In (Select ChartName From public.t_systemanalystchartmanagement)";
        ShareClass.RunSqlCommand(strHQL);

        strHQL = @"Delete From T_SystemAnalystChartRelatedUser Where ID Not In 
                  (Select max(ID) From T_SystemAnalystChartRelatedUser Group By UserCode, ChartName, FormType)";
        ShareClass.RunSqlCommand(strHQL);

        strHQL = @"Delete From t_systemanalystchartmanagement Where ID Not In 
                  (Select max(ID) From t_systemanalystchartmanagement Group By ChartName)";
        ShareClass.RunSqlCommand(strHQL);
    }


    //取得模组行更新标志
    protected static int GetProModuleUpdateMark(string strModuleName, string strUserType)
    {
        string strHQL;

        strHQL = string.Format(@"Select UpdateMark From T_ProModuleLevel Where ModuleName = '{0}' and UserType = '{1}'", strModuleName, strUserType);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return int.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 0;
        }
    }

    //取得系统员工数量
    public static int getUserNumber()
    {
        string strHQL1;

        strHQL1 = "Select * from T_ProjectMember limit 3";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL1, "T_SystemDataManageForBeginer");

        return ds.Tables[0].Rows.Count;
    }


}
