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
/// ShareClass partial - Auth
/// </summary>
public static partial class ShareClass
{
    
    #region 用户登录机制

    //检查用户是否有使用模组的权限
    public static bool checkUserHasModuleRight(string strModuleName, string strUserCode)
    {
        string strHQL = "Select * From T_ProModule B Where UserCode='" + strUserCode + "' And ModuleName='" + strModuleName + "' and Visible = 'YES'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModule");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //检查模组的是否可用
    public static bool checkModuleIsVisible(string strModuleName, string strLangCode)
    {
        string strHQL = "Select * From T_ProModuleLevel B Where LangCode='" + strLangCode + "' And ModuleName='" + strModuleName + "' and Visible = 'YES' and IsDeleted = 'NO'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");
        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //预加载模组流程图数据集
    /// <summary>
    /// 预加载模块流程图数据集，返回ModuleFlowchartXML值
    /// </summary>
    /// <param name="userCode">用户代码</param>
    /// <param name="userType">用户类型</param>
    /// <param name="langCode">语言代码</param>
    /// <returns>ModuleFlowchartXML字符串</returns>
    public static string PreLoadModuleFlowChartDataSet()
    {
        string userCode = HttpContext.Current.Session["UserCode"].ToString();
        string userType = HttpContext.Current.Session["UserType"].ToString();
        string langCode = HttpContext.Current.Session["LangCode"].ToString();

        try
        {
            // 确保表存在
            CreateMemberChartStringTableIfNotExists();
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("Error in PreLoadModuleFlowChartDataSet while creating table: " + ex.Message + "\n" + ex.StackTrace);
            return null;
        }

        try
        {
            if (string.IsNullOrEmpty(userCode))
            {
                LogClass.WriteLogFile("Error in PreLoadModuleFlowChartDataSet: UserCode is null or empty");
                return null;
            }

            // 1. 首先从 t_MemberChartStringForMainPage 表获取 ModuleFlowchartString
            string checkFlowchartSQL = string.Format(@"
                    SELECT ModuleFlowchartString 
                    FROM public.t_MemberChartStringForMainPage 
                    WHERE usercode = '{0}' 
                    AND ModuleFlowchartString IS NOT NULL 
                    AND CHAR_LENGTH(ModuleFlowchartString) > 0",
                        userCode.Trim());

            DataSet dsFlowchart = ShareClass.GetDataSetFromSql(checkFlowchartSQL, "t_MemberChartStringForMainPage");

            //LogClass.WriteLogFile(dsFlowchart.ToString());

            // 如果找到了 ModuleFlowchartString，直接返回
            if (dsFlowchart?.Tables.Count > 0 && dsFlowchart.Tables[0].Rows.Count > 0)
            {
                string moduleFlowchartString = dsFlowchart.Tables[0].Rows[0]["ModuleFlowchartString"].ToString();
                //LogClass.WriteLogFile(moduleFlowchartString);

                if (!string.IsNullOrEmpty(moduleFlowchartString))
                {
                    //LogClass.WriteLogFile($"Info: Using ModuleFlowchartString from t_MemberChartStringForMainPage for user {userCode.Trim()}");
                    return moduleFlowchartString;
                }
            }

            // 2. 如果没有找到 ModuleFlowchartString，执行原有的逻辑
            DataSet dsModuleFlow = ShareClass.GetSystemModuleFlowDataSet("OperateNavigation", userCode, userType, langCode);
            if (dsModuleFlow?.Tables.Count > 0 && dsModuleFlow.Tables[0].Rows.Count > 0)
            {
                string strModuleFlowID = ShareClass.GetSystemModuleID(dsModuleFlow);

                //LogClass.WriteLogFile($"Info: Loaded system module flow dataset for user {userCode.Trim()}, ModuleFlowID: {strModuleFlowID}");  

                if (!string.IsNullOrEmpty(strModuleFlowID))
                {
                    string strHQL = string.Format(@"SELECT DISTINCT 
                        B.ID,
                        A.ID AS SystemModuleID,
                        A.ModuleName,
                        A.HomeModuleName,
                        A.ParentModule,
                        A.PageName,
                        A.ModuleType,
                        B.ModuleDefinition AS UserModuleDefinition,
                        A.ModuleDefinition AS SystemModuleDefinition,
                        A.UserType,
                        A.IconURL,
                        A.SortNumber,
                        A.DIYFlow
                    FROM T_ProModuleLevel A
                    INNER JOIN T_ProModule B ON
                        A.ModuleName = B.ModuleName AND A.ModuleType = B.ModuleType AND A.UserType = B.UserType
                    WHERE (LENGTH(B.ModuleDefinition) > 0 OR LENGTH(A.ModuleDefinition) > 0)
                        AND B.ID = {0}", strModuleFlowID, HttpContext.Current.Session["LangCode"].ToString());
                    //LogClass.WriteLogFile(strHQL);

                    DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

                    if (ds?.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        string strID = ds.Tables[0].Rows[0]["ID"].ToString().Trim();

                        // 获取或生成XML数据
                        string moduleFlowchartXML = WFMFFlowDefinitionHandle.GetModuleFlowDefinition(strID, "UserModule", ds);

                        // 3. 将XML数据保存到 t_MemberChartStringForMainPage 表
                        SaveModuleFlowchartToDatabase(userCode.Trim(), moduleFlowchartXML);

                        return moduleFlowchartXML;
                    }
                }
            }

            //// 没有找到数据，返回null
            //LogClass.WriteLogFile($"Info: No module flow definition found for user {userCode.Trim()}");
            return null;
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error in PreLoadModuleFlowChartDataSet: " + err.Message + "\n" + err.StackTrace);
            return null;
        }
    }

    /// <summary>
    /// 将模块流程图XML保存到数据库
    /// </summary>
    public static void SaveModuleFlowchartToDatabase(string userCode, string moduleFlowchartXML)
    {
        try
        {
            if (string.IsNullOrEmpty(userCode) || string.IsNullOrEmpty(moduleFlowchartXML))
            {
                LogClass.WriteLogFile("Warning in SaveModuleFlowchartToDatabase: UserCode or XML is empty");
                return;
            }

            // 使用UPSERT (INSERT ... ON CONFLICT) 语法
            string saveSQL = string.Format(@"
                    INSERT INTO public.t_MemberChartStringForMainPage (usercode, ModuleFlowchartString)
                    VALUES (TRIM('{0}'), '{1}')
                    ON CONFLICT (usercode) 
                    DO UPDATE SET 
                        ModuleFlowchartString = EXCLUDED.ModuleFlowchartString",
                        userCode,
                        moduleFlowchartXML.Replace("'", "''")); // 处理XML中的单引号
        
            try
            {
                ShareClass.RunSqlCommand(saveSQL);

                //LogClass.WriteLogFile($"Success: Saved ModuleFlowchartString to database for user {userCode}---" + saveSQL);
            }
            catch
            {
                LogClass.WriteLogFile($"Error: Failed to save ModuleFlowchartString for user {userCode}");
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile($"Error in SaveModuleFlowchartToDatabase: {ex.Message}\n{ex.StackTrace}");
        }
    }

    /// <summary>
    /// 将模块流程图XML保存到数据库,用于设计或修改页面调用，确保每次设计或修改后都能保存最新的流程图数据
    /// </summary>
    public static string SaveModuleFlowchartToDatabaseForDesignOrChangePage()
    {
        string userCode = HttpContext.Current.Session["UserCode"].ToString();
        string userType = HttpContext.Current.Session["UserType"].ToString();
        string langCode = HttpContext.Current.Session["LangCode"].ToString();

        // 2. 如果没有找到 ModuleFlowchartString，执行原有的逻辑
        DataSet dsModuleFlow = ShareClass.GetSystemModuleFlowDataSet("OperateNavigation", userCode, userType, langCode);
        if (dsModuleFlow?.Tables.Count > 0 && dsModuleFlow.Tables[0].Rows.Count > 0)
        {
            string strModuleFlowID = ShareClass.GetSystemModuleID(dsModuleFlow);

            if (!string.IsNullOrEmpty(strModuleFlowID))
            {
                string strHQL = string.Format(@"SELECT DISTINCT 
                        B.ID,
                        A.ID AS SystemModuleID,
                        A.ModuleName,
                        A.HomeModuleName,
                        A.ParentModule,
                        A.PageName,
                        A.ModuleType,
                        B.ModuleDefinition AS UserModuleDefinition,
                        A.ModuleDefinition AS SystemModuleDefinition,
                        A.UserType,
                        A.IconURL,
                        A.SortNumber,
                        A.DIYFlow
                    FROM T_ProModuleLevel A
                    INNER JOIN T_ProModule B ON
                        A.ModuleName = B.ModuleName AND A.ModuleType = B.ModuleType AND A.UserType = B.UserType
                    WHERE (LENGTH(B.ModuleDefinition) > 0 OR LENGTH(A.ModuleDefinition) > 0)
                        AND B.ID = {0}", strModuleFlowID, HttpContext.Current.Session["LangCode"].ToString());

                DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");

                if (ds?.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    string strID = ds.Tables[0].Rows[0]["ID"].ToString().Trim();

                    // 获取或生成XML数据
                    string moduleFlowchartXML = WFMFFlowDefinitionHandle.GetModuleFlowDefinition(strID, "UserModule", ds);

                    //LogClass.WriteLogFile($"Info: Loaded module flow definition for user {userCode.Trim()}");

                    // 3. 将XML数据保存到 t_MemberChartStringForMainPage 表
                    SaveModuleFlowchartToDatabase(userCode.Trim(), moduleFlowchartXML);

                    return moduleFlowchartXML;
                }
                else
                {
                    return null;
                }
            }
            else
            {
                return null;    
            }
        }
        else
        {
            return null;
        }
    }


    // 获取系统模组流程数据集
    public static DataSet GetSystemModuleFlowDataSet(string strModuleName, string strUserCode, string strUserType, string strLangCode)
    {
        string strHQL;

        try
        {
            // 0. 首先检查T_ProModuleLevel中是否有该模组记录，如果没有则初始化
            EnsureModuleLevelExists(strModuleName, strUserType);

            // 1. 先查询用户是否有该模组记录（不管ModuleDefinition是否有值）
            string checkUserSQL = string.Format(@"
                SELECT B.ID, CHAR_LENGTH(RTRIM(COALESCE(B.ModuleDefinition, ''))) as DefLength
                FROM T_ProModule B 
                INNER JOIN T_ProModuleLevel A ON 
                    A.ModuleName || A.ModuleType || A.UserType = 
                    B.ModuleName || B.ModuleType || B.UserType
                WHERE B.ModuleName = '{0}' 
                AND B.UserCode = '{1}' 
                AND B.UserType = '{2}'",
                strModuleName.Trim(), strUserCode.Trim(), strUserType.Trim());

            DataSet dsUser = ShareClass.GetDataSetFromSql(checkUserSQL, "T_ProModule");
            bool hasUserRecord = dsUser != null && dsUser.Tables.Count > 0 && dsUser.Tables[0].Rows.Count > 0;
            bool hasModuleDefinition = false;
            string userModuleID = "";

            if (hasUserRecord)
            {
                int defLength = Convert.ToInt32(dsUser.Tables[0].Rows[0]["DefLength"]);
                hasModuleDefinition = defLength > 0;
                userModuleID = dsUser.Tables[0].Rows[0]["ID"].ToString().Trim();
            }

            // 2. 如果用户没有记录，或者ModuleDefinition为空，需要从T_ProModuleLevel复制
            if (!hasUserRecord || !hasModuleDefinition)
            {
                // 检查T_ProModuleLevel中是否有该模组的定义
                string checkLevelSQL = string.Format(@"
                    SELECT ModuleName, ModuleType, UserType, ModuleDefinition
                    FROM T_ProModuleLevel 
                    WHERE ModuleName = '{0}' AND UserType = '{1}'
                    AND CHAR_LENGTH(ModuleDefinition) > 0",
                    strModuleName.Trim(), strUserType.Trim());

                DataSet dsLevel = ShareClass.GetDataSetFromSql(checkLevelSQL, "T_ProModuleLevel");

                if (dsLevel != null && dsLevel.Tables.Count > 0 && dsLevel.Tables[0].Rows.Count > 0)
                {
                    if (!hasUserRecord)
                    {
                        // 用户没有记录，插入新记录
                        string insertSQL = string.Format(@"
                            INSERT INTO T_ProModule (ModuleName, UserCode, Visible, ModuleType, UserType, ModuleDefinition)
                            SELECT ModuleName, '{2}', 'YES', ModuleType, UserType, ModuleDefinition
                            FROM T_ProModuleLevel 
                            WHERE ModuleName = '{0}' AND UserType = '{1}'",
                            strModuleName.Trim(), strUserType.Trim(), strUserCode.Trim());

                        try
                        {
                            ShareClass.RunSqlCommand(insertSQL);
                        }
                        catch (Exception ex)
                        {
                            LogClass.WriteLogFile("Error in GetSystemModuleFlowDataSet while inserting to T_ProModule: " + ex.Message);
                        }
                    }
                    else if (!hasModuleDefinition)
                    {
                        // 用户有记录但ModuleDefinition为空，更新ModuleDefinition
                        // 使用 LIMIT 1 确保子查询只返回一行
                        string updateSQL = string.Format(@"
                            UPDATE T_ProModule 
                            SET ModuleDefinition = (
                                SELECT ModuleDefinition 
                                FROM T_ProModuleLevel 
                                WHERE ModuleName = '{0}' AND UserType = '{1}'
                                AND CHAR_LENGTH(ModuleDefinition) > 0
                                LIMIT 1
                            )
                            WHERE ID = {2}",
                            strModuleName.Trim(), strUserType.Trim(), userModuleID);

                        try
                        {
                            ShareClass.RunSqlCommand(updateSQL);
                        }
                        catch (Exception ex)
                        {
                            LogClass.WriteLogFile("Error in GetSystemModuleFlowDataSet while updating T_ProModule: " + ex.Message);
                        }
                    }
                }
            }

            // 3. 最终查询返回结果
            // 已规范化数据（无首尾空格），去掉 RTRIM 以便使用索引
            strHQL = string.Format(@"Select distinct B.ID From T_ProModuleLevel A, T_ProModule B Where A.ModuleName
                ||A.ModuleType||A.UserType = B.ModuleName ||B.ModuleType 
                ||B.UserType and B.ModuleName = '{0}' and B.UserCode ='{1}' and B.UserType = '{2}' and CHAR_LENGTH(B.ModuleDefinition) > 0", strModuleName, strUserCode, strUserType, strLangCode);

            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevel");
            return ds;
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("Error in GetSystemModuleFlowDataSet: " + ex.Message + "\n" + ex.StackTrace);
            return null;
        }
    }

    /// <summary>
    /// 确保T_ProModuleLevel中存在指定的模组记录，如果不存在则初始化
    /// </summary>
    private static void EnsureModuleLevelExists(string strModuleName, string strUserType)
    {
        try
        {
            // 检查T_ProModuleLevel中是否有该模组记录
            string checkSQL = string.Format(@"
                SELECT ID, CHAR_LENGTH(RTRIM(COALESCE(ModuleDefinition, ''))) as DefLength
                FROM T_ProModuleLevel 
                WHERE ModuleName = '{0}' AND UserType = '{1}'",
                strModuleName.Trim(), strUserType.Trim());

            DataSet ds = ShareClass.GetDataSetFromSql(checkSQL, "T_ProModuleLevel");
            bool hasLevelRecord = ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;
            bool hasLevelDefinition = false;

            if (hasLevelRecord)
            {
                int defLength = Convert.ToInt32(ds.Tables[0].Rows[0]["DefLength"]);
                hasLevelDefinition = defLength > 0;
            }

            // 如果是OperateNavigation模组且没有记录或没有定义，需要初始化
            if (strModuleName.Trim() == "OperateNavigation" && (!hasLevelRecord || !hasLevelDefinition))
            {
                InitializeOperateNavigationModule(strUserType);
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("Error in EnsureModuleLevelExists: " + ex.Message);
        }
    }

    /// <summary>
    /// 初始化OperateNavigation模组（插入记录并设置流程图定义）
    /// </summary>
    private static void InitializeOperateNavigationModule(string strUserType)
    {
        try
        {
            string strSystemProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];
            string strMFXML = GetOperateNavigationFlowDefinition(strSystemProductType, strUserType);

            if (string.IsNullOrEmpty(strMFXML))
            {
                LogClass.WriteLogFile("InitializeOperateNavigationModule: No flow definition found for ProductType=" + strSystemProductType + ", UserType=" + strUserType);
                return;
            }

            // 检查是否已存在记录
            string checkSQL = string.Format(@"
                SELECT ID FROM T_ProModuleLevel 
                WHERE ModuleName = 'OperateNavigation' AND UserType = '{0}'",
                strUserType.Trim());

            DataSet ds = ShareClass.GetDataSetFromSql(checkSQL, "T_ProModuleLevel");
            bool hasRecord = ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;

            if (!hasRecord)
            {
                // 插入新记录
                string insertSQL = string.Format(@"
                    INSERT INTO T_ProModuleLevel(ModuleName, HomeModuleName, ParentModule, PageName, ModuleType, UserType, LangCode, IconURL, ModuleDefinition, DiyFlow, UpdateMark, SortNumber, IsDeleted, Visible)
                    VALUES('OperateNavigation', 'OperateNavigation', '', '', 'SYSTEM', '{0}', 'en', 'ImagesSkin/OperateGuide.png', '{1}', 'YES', 3, 0, 'NO', 'YES')",
                    strUserType.Trim(), strMFXML.Replace("'", "''"));

                ShareClass.RunSqlCommand(insertSQL);
                LogClass.WriteLogFile("InitializeOperateNavigationModule: Inserted new record for UserType=" + strUserType);
            }
            else
            {
                // 更新现有记录的ModuleDefinition
                string updateSQL = string.Format(@"
                    UPDATE T_ProModuleLevel 
                    SET ModuleDefinition = '{1}', UpdateMark = 3
                    WHERE ModuleName = 'OperateNavigation' AND UserType = '{0}'",
                    strUserType.Trim(), strMFXML.Replace("'", "''"));

                ShareClass.RunSqlCommand(updateSQL);
                LogClass.WriteLogFile("InitializeOperateNavigationModule: Updated ModuleDefinition for UserType=" + strUserType);
            }

            // 同时初始化T_ProModule中的SAMPLE用户记录
            InitializeSampleUserModule(strUserType);
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("Error in InitializeOperateNavigationModule: " + ex.Message + "\n" + ex.StackTrace);
        }
    }

    /// <summary>
    /// 初始化SAMPLE用户的OperateNavigation模组记录
    /// </summary>
    private static void InitializeSampleUserModule(string strUserType)
    {
        try
        {
            string checkSQL = string.Format(@"
                SELECT ID FROM T_ProModule 
                WHERE ModuleName = 'OperateNavigation' AND UserCode = 'SAMPLE' AND UserType = '{0}'",
                strUserType.Trim());

            DataSet ds = ShareClass.GetDataSetFromSql(checkSQL, "T_ProModule");
            bool hasRecord = ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0;

            if (!hasRecord)
            {
                string insertSQL = string.Format(@"
                    INSERT INTO T_ProModule(UserCode, ModuleName, ModuleType, UserType, ModuleDefinition, DiyFlow, Visible)
                    VALUES('SAMPLE', 'OperateNavigation', 'SYSTEM', '{0}', '', 'YES', 'YES')",
                    strUserType.Trim());

                ShareClass.RunSqlCommand(insertSQL);
            }
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("Error in InitializeSampleUserModule: " + ex.Message);
        }
    }

    /// <summary>
    /// 初始化所有用户类型的OperateNavigation模组（供TakeTopSystemOtherCodeRunPage调用）
    /// 插入基础记录（ModuleDefinition为空），由UpdateModuleFlowDefinition填充流程图定义
    /// </summary>
    public static void InitializeOperateNavigationModuleForAllUserTypes()
    {
        try
        {
            string strSystemProductType = System.Configuration.ConfigurationManager.AppSettings["ProductType"];

            // 检查T_ProModuleLevel中是否已有OperateNavigation记录
            string checkSQL = "SELECT COUNT(*) FROM T_ProModuleLevel WHERE ModuleName = 'OperateNavigation'";
            DataSet ds = ShareClass.GetDataSetFromSql(checkSQL, "T_ProModuleLevel");
            int count = 0;
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                count = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            }

            if (count > 0)
            {
                LogClass.WriteLogFile("OperateNavigation module already exists in T_ProModuleLevel.");
                return;
            }

            // 删除旧记录（如果有）
            ShareClass.RunSqlCommand("Delete From T_ProModuleLevel Where ModuleName = 'OperateNavigation'");

            // 插入INNER用户类型记录
            string insertInnerSQL = @"
                Insert Into T_ProModuleLevel(ModuleName, HomeModuleName, ParentModule, PageName, ModuleType, UserType, LangCode, IconURL, ModuleDefinition, DiyFlow, UpdateMark, SortNumber, IsDeleted, Visible)
                values('OperateNavigation', '操作导航', '', '', 'SYSTEM', 'INNER', 'zh-CN', 'ImagesSkin/OperateGuide.png', '', 'YES', 0, 0, 'NO', 'YES');";
            ShareClass.RunSqlCommand(insertInnerSQL);

            // 插入OUTER用户类型记录
            string insertOuterSQL = @"
                Insert Into T_ProModuleLevel(ModuleName, HomeModuleName, ParentModule, PageName, ModuleType, UserType, LangCode, IconURL, ModuleDefinition, DiyFlow, UpdateMark, SortNumber, IsDeleted, Visible)
                values('OperateNavigation', 'OperateNavigation', '', '', 'SYSTEM', 'OUTER', 'en', 'ImagesSkin/OperateGuide.png', '', 'YES', 0, 0, 'NO', 'YES');";
            ShareClass.RunSqlCommand(insertOuterSQL);

            // 插入SAMPLE用户记录
            InitializeSampleUserModule("INNER");
            InitializeSampleUserModule("OUTER");

            LogClass.WriteLogFile("InitializeOperateNavigationModuleForAllUserTypes: Inserted OperateNavigation records for INNER and OUTER.");
        }
        catch (Exception ex)
        {
            LogClass.WriteLogFile("Error in InitializeOperateNavigationModuleForAllUserTypes: " + ex.Message + "\n" + ex.StackTrace);
        }
    }

    /// <summary>
    /// 获取OperateNavigation的流程图定义
    /// </summary>
    private static string GetOperateNavigationFlowDefinition(string strSystemProductType, string strUserType)
    {
        // OUTER用户类型的定义（所有产品类型共用）
        if (strUserType.Trim().ToUpper() == "OUTER")
        {
            return @"{states:{rect1:{type:'task',text:{text:'我的协作'}, attr:{ x:89, y:114, width:100, height:50}, props:{guid:{value:'9cf167e5-eaa0-2a0a-d046-f9b95f20a18f'},text:{value:'我的协作',url:'TTCollaborationManage.aspx'}}},rect2:{type:'task',text:{text:'我的流程'}, attr:{ x:292, y:114, width:100, height:50}, props:{guid:{value:'d453b354-38bd-d4f2-5bd2-d052ce6757d0'},text:{value:'我的流程',url:'TTWLManage.aspx'}}},rect3:{type:'task',text:{text:'项目管理'}, attr:{ x:486, y:116, width:100, height:50}, props:{guid:{value:'4d13368a-8662-46bb-2302-30f0ec9ab00b'},text:{value:'项目管理',url:'TTProjectManageOuter.aspx'}}},rect4:{type:'task',text:{text:'我的客服'}, attr:{ x:677, y:116, width:100, height:50}, props:{guid:{value:'97c25bff-5352-fc37-8ae7-cb421fcdf7cc'},text:{value:'我的客服',url:'TTCustomerQuestionManage.aspx'}}},rect5:{type:'task',text:{text:'我的缺陷'}, attr:{ x:386, y:225, width:100, height:50}, props:{guid:{value:'7bfb19b8-ba4b-9be7-9af6-a3037cd27a1c'},text:{value:'我的缺陷',url:'TTDefectHandlePageThirdPart.aspx'}}},rect6:{type:'task',text:{text:'我的需求'}, attr:{ x:583, y:223, width:100, height:50}, props:{guid:{value:'463cef82-59b2-a9ad-134c-3b446afe71a9'},text:{value:'我的需求',url:'TTReqHandlePageThirdPart.aspx'}}},rect7:{type:'task',text:{text:'我的考勤'}, attr:{ x:873, y:117, width:100, height:50}, props:{guid:{value:'c6ab08dc-af3e-84c8-b0d6-094f352580cc'},text:{value:'我的考勤',url:'TTUserAttendanceRecordForMe.aspx'}}},rect8:{type:'task',text:{text:'项目任务'}, attr:{ x:486, y:11, width:100, height:50}, props:{guid:{value:'907e7f31-cd94-309a-bdf6-95313362f7c1'},text:{value:'项目任务',url:'TTProjectTaskManageMain.aspx'}}}},paths:{path9:{from:'rect2',to:'rect3', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path10:{from:'rect3',to:'rect4', dots:[],text:{text:'TO 我的客服'},textPos:{x:0,y:-10}, props:{text:{value:'TO 我的客服'}}},path11:{from:'rect4',to:'rect7', dots:[],text:{text:'TO 我的考勤'},textPos:{x:0,y:-10}, props:{text:{value:'TO 我的考勤'}}},path12:{from:'rect6',to:'rect3', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path13:{from:'rect5',to:'rect3', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path14:{from:'rect1',to:'rect2', dots:[],text:{text:'TO 我的流程'},textPos:{x:0,y:-10}, props:{text:{value:''}}},path15:{from:'rect8',to:'rect3', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}}},props:{props:{name:{value:'新建流程'},key:{value:''},desc:{value:''}}}}";
        }

        // INNER用户类型的定义（根据ProductType返回不同定义）
        if (strUserType.Trim().ToUpper() == "INNER")
        {
            // ECMP, DEMO 产品类型
            if ("ECMP,DEMO".IndexOf(strSystemProductType) > -1)
            {
                return @"{states:{rect1:{type:'task',text:{text:'项目立项'}, attr:{ x:105, y:127, width:100, height:50}, props:{guid:{value:'02899d0f-472c-063f-f67e-c6b9d45c8d29'},text:{value:'项目立项',url:'TTMakeProject.aspx'}}},rect2:{type:'task',text:{text:'项目管理'}, attr:{ x:313, y:127, width:100, height:50}, props:{guid:{value:'5fe585ee-cf14-5681-46eb-e0f32e23b369'},text:{value:'项目管理',url:'TTProjectManage.aspx'}}},rect3:{type:'task',text:{text:'项目任务管理'}, attr:{ x:313, y:8, width:100, height:50}, props:{guid:{value:'e2637d3e-2cdb-2369-c06d-febd974c8af5'},text:{value:'项目任务管理',url:'TTProjectTaskManageMain.aspx'}}},rect4:{type:'task',text:{text:'工作流管理'}, attr:{ x:541, y:128, width:100, height:50}, props:{guid:{value:'7c6325be-8337-ec12-76ed-1a03b86afab4'},text:{value:'工作流管理',url:'TTWLManage.aspx'}}},rect5:{type:'task',text:{text:'项目需求管理'}, attr:{ x:313, y:243, width:100, height:50}, props:{guid:{value:'54404d63-2600-e15e-81e4-d73382f0c4be'},text:{value:'项目需求管理',url:'TTProjectReqManageMain.aspx'}}},rect6:{type:'task',text:{text:'供应链管理'}, attr:{ x:733, y:130, width:100, height:50}, props:{guid:{value:'1c96be8a-74f3-4245-8410-1e644295853b'},text:{value:'供应链管理',url:'TTGoodsManage.aspx'}}},rect7:{type:'task',text:{text:'知识管理'}, attr:{ x:1142, y:132, width:100, height:50}, props:{guid:{value:'5d7924f1-d30f-8e77-f9c2-bbff046fc474'},text:{value:'知识管理',url:'TTDocumentManage.aspx'}}},rect8:{type:'task',text:{text:'财务管理'}, attr:{ x:940, y:131, width:100, height:50}, props:{guid:{value:'1d88fb65-7ead-3211-578a-ca3f51f6d5c4'},text:{value:'财务管理',url:'TTReceivablesPayableAlert.aspx'}}},rect9:{type:'task',text:{text:'入库单'}, attr:{ x:733, y:7, width:100, height:50}, props:{guid:{value:'7f67e5bf-6b78-d79c-9ef3-b2858f7293b0'},text:{value:'入库单',url:'TTMakeGoods.aspx'}}},rect10:{type:'task',text:{text:'出库单'}, attr:{ x:733, y:244, width:100, height:50}, props:{guid:{value:'ca55c30d-c204-9183-baea-4629fb52ef33'},text:{value:'出库单',url:'TTGoodsShipmentOrder.aspx'}}},rect11:{type:'task',text:{text:'收款'}, attr:{ x:940, y:6, width:100, height:50}, props:{guid:{value:'bb49d768-afb5-6148-bad3-a10a1f4e47db'},text:{value:'收款',url:'TTAccountReceivablesRecord.aspx'}}},rect12:{type:'task',text:{text:'付款'}, attr:{ x:940, y:243, width:100, height:50}, props:{guid:{value:'40067ae4-3ada-306f-0e3a-33f00532c494'},text:{value:'付款',url:'TTAccountPayableRecord.aspx'}}}},paths:{path13:{from:'rect1',to:'rect2', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path14:{from:'rect2',to:'rect3', dots:[],text:{text:'TO 项目任务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目任务管理'}}},path15:{from:'rect2',to:'rect4', dots:[],text:{text:'TO 工作流管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 工作流管理'}}},path16:{from:'rect2',to:'rect5', dots:[],text:{text:'TO 项目需求管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目需求管理'}}},path17:{from:'rect4',to:'rect6', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path18:{from:'rect6',to:'rect8', dots:[],text:{text:'TO 财务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 财务管理'}}},path19:{from:'rect8',to:'rect7', dots:[],text:{text:'TO 知识管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 知识管理'}}},path20:{from:'rect9',to:'rect6', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path21:{from:'rect10',to:'rect6', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path22:{from:'rect11',to:'rect8', dots:[],text:{text:'TO 财务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 财务管理'}}},path23:{from:'rect12',to:'rect8', dots:[],text:{text:'TO 财务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 财务管理'}}}},props:{props:{name:{value:'新建流程'},key:{value:''},desc:{value:''}}}}";
            }

            // EDPMP 产品类型
            if (strSystemProductType == "EDPMP")
            {
                return @"{states:{rect1:{type:'task',text:{text:'项目立项'}, attr:{ x:105, y:127, width:100, height:50}, props:{guid:{value:'02899d0f-472c-063f-f67e-c6b9d45c8d29'},text:{value:'项目立项',url:'TTMakeProject.aspx'}}},rect2:{type:'task',text:{text:'项目管理'}, attr:{ x:313, y:127, width:100, height:50}, props:{guid:{value:'5fe585ee-cf14-5681-46eb-e0f32e23b369'},text:{value:'项目管理',url:'TTProjectManage.aspx'}}},rect3:{type:'task',text:{text:'项目任务管理'}, attr:{ x:539, y:30, width:100, height:50}, props:{guid:{value:'e2637d3e-2cdb-2369-c06d-febd974c8af5'},text:{value:'项目任务管理',url:'TTProjectTaskManageMain.aspx'}}},rect4:{type:'task',text:{text:'工作流管理'}, attr:{ x:541, y:128, width:100, height:50}, props:{guid:{value:'7c6325be-8337-ec12-76ed-1a03b86afab4'},text:{value:'工作流管理',url:'TTWLManage.aspx'}}},rect5:{type:'task',text:{text:'知识管理'}, attr:{ x:1150, y:129, width:100, height:50}, props:{guid:{value:'cc37c28e-3f87-c548-408e-c5404815c2f6'},text:{value:'知识管理',url:'TTDocumentManage.aspx'}}},rect6:{type:'task',text:{text:'投标管理'}, attr:{ x:741, y:128, width:100, height:50}, props:{guid:{value:'7afdc1c7-86a7-86f0-f1f4-27080c5a5e12'},text:{value:'投标管理',url:'TTTenderUNHandleList.aspx'}}},rect7:{type:'task',text:{text:'投标登记'}, attr:{ x:741, y:32, width:100, height:50}, props:{guid:{value:'a156bfcc-cc20-8067-f531-88166371239c'},text:{value:'投标登记',url:'TTTenderList.aspx'}}},rect8:{type:'task',text:{text:'投标确认'}, attr:{ x:742, y:234, width:100, height:50}, props:{guid:{value:'ed594496-0b83-c6d3-5922-8efad984eee1'},text:{value:'投标确认',url:'TTTenderFinanceList.aspx'}}},rect9:{type:'task',text:{text:'所有成员项目状态'}, attr:{ x:935, y:130, width:120, height:50}, props:{guid:{value:'016de4e1-1aa6-e650-cd13-261b951d2066'},text:{value:'所有成员项目状态',url:'TTAllProjectsRunStatus.aspx'}}},rect10:{type:'task',text:{text:'项目风险管理'}, attr:{ x:542, y:234, width:100, height:50}, props:{guid:{value:'273b9704-371f-e2aa-41ae-d3a94c29ae6c'},text:{value:'项目风险管理',url:'TTProjectRiskManageMain.aspx'}}}},paths:{path11:{from:'rect1',to:'rect2', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path12:{from:'rect2',to:'rect3', dots:[],text:{text:'TO 项目任务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目任务管理'}}},path13:{from:'rect2',to:'rect4', dots:[],text:{text:'TO 工作流管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 工作流管理'}}},path14:{from:'rect4',to:'rect6', dots:[],text:{text:'TO 投标管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 投标管理'}}},path15:{from:'rect7',to:'rect6', dots:[],text:{text:'TO 投标管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 投标管理'}}},path16:{from:'rect8',to:'rect6', dots:[],text:{text:'TO 投标管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 投标管理'}}},path17:{from:'rect6',to:'rect9', dots:[],text:{text:'TO 所有成员项目状态'},textPos:{x:0,y:-10}, props:{text:{value:'TO 所有成员项目状态'}}},path18:{from:'rect9',to:'rect5', dots:[],text:{text:'TO 知识管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 知识管理'}}},path19:{from:'rect2',to:'rect10', dots:[],text:{text:'TO 项目风险管理'},textPos:{x:0,y:-10}, props:{text:{value:''}}}},props:{props:{name:{value:'新建流程'},key:{value:''},desc:{value:''}}}}";
            }

            // RDPMP 产品类型
            if (strSystemProductType == "RDPMP")
            {
                return @"{states:{rect1:{type:'task',text:{text:'项目立项'}, attr:{ x:146, y:125, width:100, height:50}, props:{guid:{value:'02899d0f-472c-063f-f67e-c6b9d45c8d29'},text:{value:'项目立项',url:'TTMakeProject.aspx'}}},rect2:{type:'task',text:{text:'项目管理'}, attr:{ x:405, y:126, width:100, height:50}, props:{guid:{value:'5fe585ee-cf14-5681-46eb-e0f32e23b369'},text:{value:'项目管理',url:'TTProjectManage.aspx'}}},rect3:{type:'task',text:{text:'项目任务管理'}, attr:{ x:320, y:18, width:100, height:50}, props:{guid:{value:'e2637d3e-2cdb-2369-c06d-febd974c8af5'},text:{value:'项目任务管理',url:'TTProjectTaskManageMain.aspx'}}},rect4:{type:'task',text:{text:'供应链管理'}, attr:{ x:795, y:127, width:100, height:50}, props:{guid:{value:'2c43e892-71ba-f826-f0df-5393bdd20173'},text:{value:'供应链管理',url:'TTGoodsManage.aspx'}}},rect5:{type:'task',text:{text:'领料单'}, attr:{ x:795, y:11, width:100, height:50}, props:{guid:{value:'ee0e9c61-2ba9-f307-2ca5-45ca1e58345f'},text:{value:'领料单',url:'TTGoodsApplicationOrder.aspx'}}},rect6:{type:'task',text:{text:'出库单'}, attr:{ x:795, y:244, width:100, height:50}, props:{guid:{value:'d0018ba6-ef5d-b0ba-5e9c-97e001e698c5'},text:{value:'出库单',url:'TTGoodsShipmentOrder.aspx'}}},rect7:{type:'task',text:{text:'工作流管理'}, attr:{ x:607, y:127, width:100, height:50}, props:{guid:{value:'39e45ece-447c-72ff-eb5f-bd5d40217313'},text:{value:'工作流管理',url:'TTWLManage.aspx'}}},rect8:{type:'task',text:{text:'项目需求管理'}, attr:{ x:323, y:241, width:100, height:50}, props:{guid:{value:'77cdd84c-a60a-7777-2611-114303e65439'},text:{value:'项目需求管理',url:'TTProjectReqManageMain.aspx'}}},rect9:{type:'task',text:{text:'知识管理'}, attr:{ x:1040, y:128, width:100, height:50}, props:{guid:{value:'ed1042f6-938a-dbc6-d876-5b0adbeffecc'},text:{value:'知识管理',url:'TTDocumentManage.aspx'}}},rect10:{type:'task',text:{text:'项目缺陷管理'}, attr:{ x:498, y:243, width:100, height:50}, props:{guid:{value:'e7016fa9-7391-8ca2-4f7d-d528cf302d8d'},text:{value:'项目缺陷管理',url:'TTProjectDefectManageMain.aspx'}}},rect11:{type:'task',text:{text:'项目风险管理'}, attr:{ x:496, y:19, width:100, height:50}, props:{guid:{value:'960e6089-9bbb-4f27-a14f-acc8acc0fce4'},text:{value:'项目风险管理',url:'TTProjectRiskManageMain.aspx'}}}},paths:{path12:{from:'rect1',to:'rect2', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path13:{from:'rect5',to:'rect4', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path14:{from:'rect6',to:'rect4', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path15:{from:'rect2',to:'rect7', dots:[],text:{text:'TO 工作流管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 工作流管理'}}},path16:{from:'rect7',to:'rect4', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path17:{from:'rect3',to:'rect2', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path18:{from:'rect8',to:'rect2', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path19:{from:'rect4',to:'rect9', dots:[],text:{text:'TO 知识管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 知识管理'}}},path20:{from:'rect10',to:'rect2', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path21:{from:'rect11',to:'rect2', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:''}}}},props:{props:{name:{value:'新建流程'},key:{value:''},desc:{value:''}}}}";
            }

            // SIPMP 产品类型
            if (strSystemProductType == "SIPMP")
            {
                return @"{states:{rect1:{type:'task',text:{text:'项目立项'}, attr:{ x:105, y:127, width:100, height:50}, props:{guid:{value:'02899d0f-472c-063f-f67e-c6b9d45c8d29'},text:{value:'项目立项',url:'TTMakeProject.aspx'}}},rect2:{type:'task',text:{text:'项目管理'}, attr:{ x:313, y:127, width:100, height:50}, props:{guid:{value:'5fe585ee-cf14-5681-46eb-e0f32e23b369'},text:{value:'项目管理',url:'TTProjectManage.aspx'}}},rect3:{type:'task',text:{text:'项目任务管理'}, attr:{ x:539, y:32, width:100, height:50}, props:{guid:{value:'e2637d3e-2cdb-2369-c06d-febd974c8af5'},text:{value:'项目任务管理',url:'TTProjectTaskManageMain.aspx'}}},rect4:{type:'task',text:{text:'收款明细汇总表'}, attr:{ x:972, y:32, width:100, height:50}, props:{guid:{value:'6f8c99c9-3fcd-297d-1fa8-19811a07312b'},text:{value:'收款明细汇总表',url:'TTAccountReceiveRecordSummary.aspx'}}},rect5:{type:'task',text:{text:'付款明细汇总表'}, attr:{ x:971, y:233, width:100, height:50}, props:{guid:{value:'5a1f8b2b-c6f3-ce0b-7604-f7a986a65be7'},text:{value:'付款明细汇总表',url:'TTAccountPayRecordSummary.aspx'}}},rect6:{type:'task',text:{text:'工作流管理'}, attr:{ x:541, y:128, width:100, height:50}, props:{guid:{value:'7c6325be-8337-ec12-76ed-1a03b86afab4'},text:{value:'工作流管理',url:'TTWLManage.aspx'}}},rect7:{type:'task',text:{text:'项目需求管理'}, attr:{ x:539, y:233, width:100, height:50}, props:{guid:{value:'cc37c28e-3f87-c548-408e-c5404815c2f6'},text:{value:'项目需求管理',url:'TTProjectReqManageMain.aspx'}}},rect8:{type:'task',text:{text:'知识管理'}, attr:{ x:1192, y:127, width:100, height:50}, props:{guid:{value:'28fad06e-abdf-9e5c-5dcc-83cf8e31b868'},text:{value:'知识管理',url:'TTDocumentManage.aspx'}}},rect9:{type:'task',text:{text:'供应链管理'}, attr:{ x:734, y:126, width:100, height:50}, props:{guid:{value:'97a9836e-9bfd-0785-186c-82b045d4c045'},text:{value:'供应链管理',url:'TTGoodsManage.aspx'}}},rect10:{type:'task',text:{text:'采购订单'}, attr:{ x:681, y:35, width:100, height:50}, props:{guid:{value:'2885595e-3090-94cf-dcbb-eeec21743fd1'},text:{value:'采购订单',url:'TTMakeGoodsPurchase.aspx'}}},rect11:{type:'task',text:{text:'入库单'}, attr:{ x:831, y:33, width:100, height:50}, props:{guid:{value:'ff012f74-eb6a-ece7-07d0-802a93ac8630'},text:{value:'入库单',url:'TTMakeGoods.aspx'}}},rect12:{type:'task',text:{text:'领料单'}, attr:{ x:681, y:232, width:100, height:50}, props:{guid:{value:'d6a96f3c-4232-b23a-5d98-851660ee72e3'},text:{value:'领料单',url:'TTGoodsApplicationOrder.aspx'}}},rect13:{type:'task',text:{text:'出库单'}, attr:{ x:831, y:231, width:100, height:50}, props:{guid:{value:'8552f52f-2566-d548-b15d-b482a47f9c59'},text:{value:'出库单',url:'TTGoodsShipmentOrder.aspx'}}},rect14:{type:'task',text:{text:'财务管理'}, attr:{ x:972, y:126, width:100, height:50}, props:{guid:{value:'fdfcecbb-2f46-87c3-73ba-3264fee27d42'},text:{value:'财务管理',url:'TTReceivablesPayableAlert.aspx'}}}},paths:{path15:{from:'rect1',to:'rect2', dots:[],text:{text:'TO 项目管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目管理'}}},path16:{from:'rect2',to:'rect3', dots:[],text:{text:'TO 项目任务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目任务管理'}}},path17:{from:'rect2',to:'rect6', dots:[],text:{text:'TO 工作流管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 工作流管理'}}},path18:{from:'rect6',to:'rect9', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path19:{from:'rect9',to:'rect14', dots:[],text:{text:'TO 财务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 财务管理'}}},path20:{from:'rect10',to:'rect9', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path21:{from:'rect11',to:'rect9', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path22:{from:'rect12',to:'rect9', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path23:{from:'rect13',to:'rect9', dots:[],text:{text:'TO 供应链管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 供应链管理'}}},path24:{from:'rect4',to:'rect14', dots:[],text:{text:'TO 财务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 财务管理'}}},path25:{from:'rect5',to:'rect14', dots:[],text:{text:'TO 财务管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 财务管理'}}},path26:{from:'rect2',to:'rect7', dots:[],text:{text:'TO 项目需求管理'},textPos:{x:0,y:-10}, props:{text:{value:'TO 项目需求管理'}}},path27:{from:'rect14',to:'rect8', dots:[],text:{text:'TO 知识管理'},textPos:{x:0,y:-10}, props:{text:{value:''}}}},props:{props:{name:{value:'新建流程'},key:{value:''},desc:{value:''}}}}";
            }

            // 其他产品类型可以继续添加...
            // SOPMP, GAPMP, ERP, CMP, CRM, SAAS等
        }

        return null;
    }


        /// <summary>
    /// 初始化模块操作导航的路线定义
    /// 根据ProductType为T_ProModuleLevel中的OperateNavigation模组填充流程图定义
    /// </summary>
    public static void UpdateModuleFlowDefinition()
    {
        try
        {
            // 为INNER用户类型初始化（根据ProductType获取对应流程图）
            InitializeOperateNavigationModule("INNER");

            // 为OUTER用户类型初始化（所有产品类型共用同一套OUTER流程图）
            InitializeOperateNavigationModule("OUTER");
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error in UpdateModuleFlowDefinition: " + err.Message + "\n" + err.StackTrace);
        }
    }

    /// <summary>
    /// 保存模组流程图定义
    /// </summary>
    /// <param name="strModuleName">模组名称</param>
    /// <param name="strMFXML">流程图XML定义</param>
    /// <param name="intUpdateMark">更新标记</param>
    /// <param name="strUserType">用户类型</param>
    public static void SaveModuleFlowDefinition(string strModuleName, string strMFXML, int intUpdateMark, string strUserType)
    {
        string strHQL;
        IList lst;

        string strID;
        int i;

        try
        {
            ProModuleLevelBLL proModuleLevelBLL = new ProModuleLevelBLL();
            strHQL = string.Format(@"from ProModuleLevel as proModuleLevel where proModuleLevel.ModuleName = '{0}' and proModuleLevel.UserType ='{1}' and proModuleLevel.ModuleType = 'SYSTEM'", strModuleName, strUserType);
            lst = proModuleLevelBLL.GetAllProModuleLevels(strHQL);

            ProModuleLevel proModuleLevel;

            for (i = 0; i < lst.Count; i++)
            {
                proModuleLevel = (ProModuleLevel)lst[i];

                strID = proModuleLevel.ID.ToString();
                proModuleLevel.ModuleDefinition = strMFXML;
                proModuleLevelBLL.UpdateProModuleLevel(proModuleLevel, int.Parse(strID));
            }

            strHQL = string.Format(@"Update T_ProModuleLevel Set UpdateMark = {0} Where ModuleName = '{1}' and UserType ='{2}' and ModuleType = 'SYSTEM'", intUpdateMark, strModuleName, strUserType);
            ShareClass.RunSqlCommand(strHQL);

            //设置缓存更改标志，并刷新页面缓存
            ShareClass.ChangePageCache();
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }



    public static string GetSystemModuleID(DataSet ds)
    {
        try
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                return ds.Tables[0].Rows[0][0].ToString().Trim();
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

    // 创建表（如果不存在）- PostgreSQL 版本
    private static bool _memberChartTableChecked = false;
    private static readonly object _memberChartTableLock = new object();

    public static  void CreateMemberChartStringTableIfNotExists()
    {
        // 只在进程首次调用时检查一次，避免每次请求都查询 information_schema 元数据
        if (_memberChartTableChecked)
        {
            return;
        }

        lock (_memberChartTableLock)
        {
            if (_memberChartTableChecked)
            {
                return;
            }

            string checkTableSql = "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 't_memberchartstringformainpage'";
            DataSet dsCheck = ShareClass.GetDataSetFromSql(checkTableSql, "CheckTable");
            int tableCount = Convert.ToInt32(dsCheck.Tables[0].Rows[0][0]);
            if (tableCount == 0)
            {
                string createTableSql = @"
                CREATE TABLE IF NOT EXISTS public.t_MemberChartStringForMainPage
                (
                    usercode character(20) COLLATE pg_catalog.""default"" PRIMARY KEY,
                    AnalystChartString TEXT COLLATE pg_catalog.""default"",
                    ModuleFlowchartString TEXT COLLATE pg_catalog.""default""
                );";
                ShareClass.RunSqlCommand(createTableSql);
            }

            _memberChartTableChecked = true;
        }
    }

    //运行一些特殊的代码
    public static void RunSpecificalCodeForLogin()
    {
        //复制ADMIN用户的关联分析图给用户
        copyChartToUserFromADMIN(HttpContext.Current.Session["UserCode"].ToString());

        //更新页面关联模组个人空间里的类型为WorkGuide的每行列数
        UpdateEveryRowColumnNumberForWorkGuide();
    }

    //Copy 管理员ADMIN用户的分析图给其它用户
    public static void copyChartToUserFromADMIN(string strUserCode)
    {
        string strHQL;

        try
        {
            strHQL = string.Format(@"Insert Into t_systemanalystchartrelateduser(UserCode,ChartName,FormType,SortNumber) 
              Select '{0}',ChartName,FormType,SortNumber From t_systemanalystchartrelateduser 
                Where UserCode = 'ADMIN' and ChartName Not In (Select ChartName From t_systemanalystchartmanagement Where Status = 'NO')
                and ChartName Not In (Select ChartName From t_systemanalystchartrelateduser Where UserCode = '{0}') Order By SortNumber ASC
               ", strUserCode);

            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
        }
    }

    //更新页面关联模组个人空间里的类型为WorkGuide的每行列数
    public static void UpdateEveryRowColumnNumberForWorkGuide()
    {
        if (HttpContext.Current.Session["UserType"].ToString() == "INNER")
        {
            try
            {
                string strHQL;
                strHQL = string.Format(@"Insert Into T_ProModuleLevelForPageUser(ModuleName,UserCode,UserType,Visible,SortNumber,EveryRowColumnNumber)
                Select ModuleName,'{1}','{2}',Visible,SortNumber,2 From t_promodulelevelforpage
	            Where ParentModule = 'PersonalSpace'  and LangCode = '{0}' and Visible = 'YES' and IsDeleted = 'NO'
		        and ModuleName Not In (Select ModuleName From T_ProModuleLevelForPageUser Where UserCode = '{1}' and UserType='{2}');", HttpContext.Current.Session["LangCode"].ToString(), HttpContext.Current.Session["UserCode"].ToString(), HttpContext.Current.Session["UserType"].ToString());
                ShareClass.RunSqlCommand(strHQL);

                strHQL = string.Format(@"Update t_promodulelevelforpageuser Set EveryRowColumnNumber = 1 Where ModuleName = 'WorkGuide' and  EveryRowColumnNumber <> 1 and UserCode ='{0}';", HttpContext.Current.Session["UserCode"].ToString());
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }

        if (HttpContext.Current.Session["UserType"].ToString() == "OUTER")
        {
            try
            {
                string strHQL;
                strHQL = string.Format(@"Insert Into T_ProModuleLevelForPageUser(ModuleName,UserCode,UserType,Visible,SortNumber,EveryRowColumnNumber)
                Select ModuleName,'{1}','{2}',Visible,SortNumber,2 From t_promodulelevelforpage
	            Where ParentModule = 'ExternalPersonalSpace'  and LangCode = '{0}' and Visible = 'YES' and IsDeleted = 'NO'
		        and ModuleName Not In (Select ModuleName From T_ProModuleLevelForPageUser Where UserCode = '{1}' and UserType = '{2}');", HttpContext.Current.Session["LangCode"].ToString(), HttpContext.Current.Session["UserCode"].ToString(), HttpContext.Current.Session["UserType"].ToString());
                ShareClass.RunSqlCommand(strHQL);

                strHQL = string.Format(@"Update t_promodulelevelforpageuser Set EveryRowColumnNumber = 1 Where ModuleName = 'WorkGuide' and  EveryRowColumnNumber <> 1 and UserCode ='{0}';", HttpContext.Current.Session["UserCode"].ToString());
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }
        }
    }


    //获取左边栏展开状态
    public static string GetLeftBarExtendStatus(string strUserCode)
    {
        string strHQL;

        strHQL = "Select LeftBarExtend From T_ProjectMember Where UserCode ='" + strUserCode + "'";
        try
        {
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
            return ds.Tables[0].Rows[0]["LeftBarExtend"].ToString().Trim();
        }
        catch
        {
            return "NO";
        }
    }

    //更新左边栏展开状态
    public static void UpdateLeftBarExtendStatus(string strUserCode, string strLeftBarExtend)
    {
        string strHQL;

        strHQL = "Update T_ProjectMember Set LeftBarExtend = '" + strLeftBarExtend + "' Where UserCode ='" + strUserCode + "'";
        ShareClass.RunSqlCommand(strHQL);
    }

    //重定向页面到指定框架
    public static void Redirect(this HttpResponse response, string url, string target, string windowFeatures)
    {
        if ((String.IsNullOrEmpty(target) ||
        target.Equals("_self", StringComparison.OrdinalIgnoreCase)) &&
        String.IsNullOrEmpty(windowFeatures))
        {
            response.Redirect(url);
        }
        else
        {
            Page page = (Page)HttpContext.Current.Handler; if (page == null)
            {
                throw new
                InvalidOperationException("Cannot redirect to new window .");
            }
            url = page.ResolveClientUrl(url);
            string script;
            if (!String.IsNullOrEmpty(windowFeatures))
            {
                script = @"window.open(""{0}"", ""{1}"", ""{2}"");";
            }
            else
            {
                script = @"window.open(""{0}"", ""{1}"");";
            }
            script = String.Format(script, url, target, windowFeatures);
            ScriptManager.RegisterStartupScript(page,
            typeof(Page), "Redirect", script, true);
        }
    }


    //执行定时器页
    public static void ExecuteTakeTopTimer()
    {
        if (ShareClass.SystemLatestLoginUser == "")
        {
            ShareClass.SystemLatestLoginUser = "Timer";

            try
            {
                string strUrl = ShareClass.GetCurrentSiteRootPath() + "TakeTopTimer.aspx";

                System.Net.HttpWebRequest _HttpWebRequest = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(strUrl);
                _HttpWebRequest.Timeout = 30000;
                using (System.Net.HttpWebResponse _HttpWebResponse = (System.Net.HttpWebResponse)_HttpWebRequest.GetResponse())
                using (System.IO.Stream _Stream = _HttpWebResponse.GetResponseStream())
                {
                }
            }
            catch (Exception err)
            {
            }

            ShareClass.SystemLatestLoginUser = "";
        }
    }

    //执行数据库升级页
    public static void ExecuteTakeTopDBUpgrade()
    {
        try
        {
            string strUrl = ShareClass.GetCurrentSiteRootPath() + "TakeTopDBUpgrade.aspx";

            // 只使用HttpWebRequest方式，避免Server.Execute导致的线程冲突
            System.Net.HttpWebRequest _HttpWebRequest = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(strUrl);
            _HttpWebRequest.Timeout = 300000; // 5分钟超时
            _HttpWebRequest.ReadWriteTimeout = 300000;

            using (System.Net.HttpWebResponse _HttpWebResponse = (System.Net.HttpWebResponse)_HttpWebRequest.GetResponse())
            {
                // 读取响应确保请求完成
                using (System.IO.StreamReader reader = new System.IO.StreamReader(_HttpWebResponse.GetResponseStream()))
                {
                    string responseText = reader.ReadToEnd();
                }
            }
        }
        catch (ThreadAbortException)
        {
            // 忽略线程中止异常
            Thread.ResetAbort();
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("ExecuteTakeTopDBUpgrade Error: " + err.Message.ToString());
        }
    }


    //初始化用户模组
    public static void InitialUserModules(string strSampleUserCode, string strCurrentUserCode)
    {
        string strHQL;

        strHQL = string.Format(@"insert into t_promodule(modulename, usercode, visible, moduletype, usertype,ModuleDefinition,DiyFlow)
            select a.modulename,'{0}','NO',a.moduletype,a.usertype,a.ModuleDefinition,a.DiyFlow from t_promodule a
            where a.usercode = 'ADMIN' and a.modulename || a.moduletype || a.usertype
                not in (select b.modulename || b.moduletype || b.usertype from t_promodule b where b.usercode = '{0}' and b.moduletype = a.moduletype and b.usertype = a.usertype)", strSampleUserCode);
        ShareClass.RunSqlCommand(strHQL);

        strHQL = string.Format(@"insert into t_promodule(modulename, usercode, visible, moduletype, usertype,ModuleDefinition,DiyFlow)
            select a.modulename,'{0}',a.visible,a.moduletype,a.usertype,a.ModuleDefinition,a.DiyFlow from t_promodule a
            where a.usercode = '{1}'
                and(a.modulename || a.moduletype || a.usertype not in (select b.modulename || b.moduletype || b.usertype from t_promodule b where b.usercode = '{0}' and b.moduletype = a.moduletype and b.usertype = a.usertype)
                and a.modulename || a.moduletype || a.usertype in (select c.modulename || c.moduletype || c.usertype from t_promodulelevel c where c.moduletype = a.moduletype and c.usertype = a.usertype  and c.visible = 'YES' and c.isdeleted = 'NO'))", strCurrentUserCode, strSampleUserCode);
        ShareClass.RunSqlCommand(strHQL);
    }

    //取得服务器操作系统类型:UNIX Or WIN
    public static string GetSystemType()
    {
        //获取系统信息
        System.OperatingSystem osInfo = System.Environment.OSVersion;
        //获取操作系统ID
        System.PlatformID platformID = osInfo.Platform;

        return platformID.ToString();
    }

    public static string URLEncode(string strURL)
    {
        return System.Web.HttpUtility.UrlEncode(strURL);
    }

    public static string UrlDecode(string strURL)
    {
        return System.Web.HttpUtility.UrlDecode(strURL);
    }

    //取得当前模组的当前语言名称
    public static string GetPageTitle(string strPageName)
    {
        string strHQL;
        try
        {
            string strModuleName = HttpContext.Current.Request.QueryString["ModuleName"];
            string strModuleType = HttpContext.Current.Request.QueryString["ModuleType"];

            string strUserType = HttpContext.Current.Session["UserType"].ToString();
            string strLangCode = HttpContext.Current.Session["LangCode"].ToString();

            if (strModuleName != null & strModuleType != null)
            {
                strHQL = "Select HomeModuleName From T_ProModuleLevel Where ModuleName = '" + strModuleName + "' and ModuleType = '" + strModuleType + "' and UserType = '" + strUserType + "' and PageName = '" + strPageName + "' and LangCode = '" + strLangCode + "' limit 1";

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
            else
            {
                return "";
            }

        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            return "";
        }
    }

    //设置缓存更改标志，并刷新页面缓存
    public static void ChangePageCache()
    {
        //设置缓存更改标志
        ShareClass.SetPageCacheMark("1");
        HttpContext.Current.Session["CssDirectoryChangeNumber"] = "1";
    }

    //给指定页面添加空行以刷新页面缓存
    public static void AddSpaceLineToPageRefreshCache(string strPageName)
    {
        //页面文件加注释字符，以刷新缓存
        ShareClass.AddSpaceLineToFile(strPageName, "");
    }


    //设置缓存更改标志
    public static void SetPageCacheMark(string strMark)
    {
        string strHQL;
        strHQL = "Update T_ProjectMember Set CssDirectoryChangeNumber = " + strMark + " Where UserCode = '" + HttpContext.Current.Session["UserCode"].ToString() + "'";
        ShareClass.RunSqlCommand(strHQL);
    }

    //给相关页面文件添加空行以刷新页面缓存
    public static void AddSpaceLineToFileForRefreshCache()
    {
        //在平台左边栏增加一行注释
        ShareClass.AddSpaceLineToFile("TakeTopLRTop.aspx", "");
        ShareClass.AddSpaceLineToFile("TakeTopLRExLeft.aspx", "");
        ShareClass.AddSpaceLineToFile("TakeTopCSLRLeft.aspx", "");
        ShareClass.AddSpaceLineToFile("TakeTopMainTab.aspx", "");
        ShareClass.AddSpaceLineToFile("TakeTopMainTop.aspx", "");

        ShareClass.AddSpaceLineToFile("TakeTopPersonalSpace.aspx", "");
        ShareClass.AddSpaceLineToFile("TakeTopPersonalSpaceForOuterUser.aspx", "");
        ShareClass.AddSpaceLineToFile("TakeTopPersonalSpaceSAAS.aspx", "");

        ShareClass.AddSpaceLineToFile("TTPersonalSpaceAnalysisChart.aspx", "");
        ShareClass.AddSpaceLineToFile("TTPersonalSpaceMembersWebAddress.aspx", "");
        ShareClass.AddSpaceLineToFile("TTPersonalSpaceMembersWebAddressForOuter.aspx", "");

        ShareClass.AddSpaceLineToFile("TTPersonalSpaceMyMonthSchedule.aspx", "");
        ShareClass.AddSpaceLineToFile("TTPersonalSpaceNewsList.aspx", "");

        ShareClass.AddSpaceLineToFile("TTPersonalSpaceNewsNotice.aspx", "");
        ShareClass.AddSpaceLineToFile("TTPersonalSpaceNewsNoticeForSAAS.aspx", "");
        ShareClass.AddSpaceLineToFile("TTPersonalSpaceNoticeList.aspx", "");

        ShareClass.AddSpaceLineToFile("TTPersonalSpaceProject.aspx", "");
        ShareClass.AddSpaceLineToFile("TTPersonalSpaceTask.aspx", "");

        ShareClass.AddSpaceLineToFile("TTPersonalSpaceToDoNewsForOuter.aspx", "");
        ShareClass.AddSpaceLineToFile("TTPersonalSpaceToDoList.aspx", "");

        ShareClass.AddSpaceLineToFile("TTPersonalSpaceWorkflow.aspx", "");
        ShareClass.AddSpaceLineToFile("TTPersonalSpaceWorkflowForOuter.aspx", "");
    }

    //给主界面个人空间相关页面文件添加空行以刷新页面缓存
    public static void AddSpaceLineToPersonalSpaceForRefreshCache()
    {
        //页面文件加注释字符，以刷新缓存
        ShareClass.AddSpaceLineToFile("TakeTopPersonalSpace.aspx", "");
        ShareClass.AddSpaceLineToFile("TakeTopPersonalSpaceForOuterUser.aspx", "");
        ShareClass.AddSpaceLineToFile("TakeTopPersonalSpaceSAAS.aspx", "");
    }

    //给主界面左边栏相关页面文件添加空行以刷新页面缓存
    public static void AddSpaceLineToLeftColumnForRefreshCache()
    {
        ////在平台左边栏增加一行注释
        //ShareClass.AddSpaceLineToFile("TakeTopLRExLeft.aspx", "");
        //ShareClass.AddSpaceLineToFile("TakeTopCSLRLeft.aspx", "");
        //ShareClass.AddSpaceLineToFile("TakeTopLRTop.aspx", "");
    }

    //初始化实体类，以加快后续的操作速度
    public static void InitialNhibernateEntryClass()
    {
        try
        {
            string strHQL;
            strHQL = "From UserDuty as userDuty";
            UserDutyBLL userDutyBLL = new UserDutyBLL();
            IList lst = userDutyBLL.GetAllUserDutys(strHQL);
        }
        catch
        {
        }
    }

    //根据用户登录IP和用户名判断是否阻止此用户登录系统
    public static bool CheckUserLoginManage(string strUserCode, string strUserName)
    {
        //根据用户登录IP判断是否阻止用户登录系统
        string strHQL;
        string strLoginID, strIsAllMember, strIsForbidLogin, strLoginUserCode;
        string strMsg, strIP, strUserHostAddress;

        strUserHostAddress = HttpContext.Current.Request.UserHostAddress.Trim();

        if (strUserCode != "ADMIN")
        {
            DataSet ds = ShareClass.GetUserLoginManageDataSet(strUserCode);
            if (ds.Tables[0].Rows.Count > 0)
            {
                strLoginID = ds.Tables[0].Rows[0][0].ToString().Trim();
                strIsAllMember = ds.Tables[0].Rows[0][1].ToString().Trim();
                strIsForbidLogin = ds.Tables[0].Rows[0][2].ToString().Trim();
                strMsg = ds.Tables[0].Rows[0][3].ToString().Trim();
                strLoginUserCode = ds.Tables[0].Rows[0][4].ToString().Trim();
                strIP = ds.Tables[0].Rows[0][5].ToString().Trim();

                if (strIP == "" | strIP.IndexOf(strUserHostAddress) >= 0)
                {
                    if (strIsForbidLogin == "YES")
                    {
                        if (strMsg != "")
                        {
                            //ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + strMsg + "');</script>");

                            strHQL = "Insert Into T_UserLoginManageMsgRelatedUser(LoginID,UserCode,UserName)";
                            strHQL += " Values(" + strLoginID + ",'" + strUserCode + "','" + strUserName + "')";
                            ShareClass.RunSqlCommand(strHQL);
                        }

                        return false;
                    }
                    else
                    {
                        if (strMsg != "")
                        {
                            strHQL = "Select LoginID From T_UserLoginManageMsgRelatedUser Where LoginID = " + strLoginID + " and UserCode Like " + "'" + strUserCode + "'";
                            ds = ShareClass.GetDataSetFromSql(strHQL, "T_UserLoginManage");
                            if (ds.Tables[0].Rows.Count == 0)
                            {
                                //ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + strMsg + "');</script>");

                                strHQL = "Insert Into T_UserLoginManageMsgRelatedUser(LoginID,UserCode,UserName)";
                                strHQL += " Values(" + strLoginID + ",'" + strUserCode + "','" + strUserName + "')";
                                ShareClass.RunSqlCommand(strHQL);
                            }
                        }

                        return true;
                    }
                }
                else
                {
                    return true;
                }
            }
            else
            {
                return true;
            }
        }
        else
        {
            return true;
        }
    }

    public static DataSet GetSystemMDIStyle(string strMDIStyle)
    {
        string strHQL;

        strHQL = "Select * From T_SystemMDIStyle Where MDIStyle = " + "'" + strMDIStyle + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemMDIStyle");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds;
        }
        else
        {
            return null;
        }
    }

    //初始化页面链接模组
    public static void CopyAllModuleForHomeLanguage()
    {
        string strHQL, strLangHQL;
        string strLangCode;

        string strFromLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];

        strLangHQL = "Select LangCode From T_SystemLanguage Where LangCode <> " + "'" + strFromLangCode + "'";
        strLangHQL += " Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strLangHQL, "T_SystemLanguage");
        try
        {
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                strLangCode = ds.Tables[0].Rows[i][0].ToString().Trim();

                strHQL = "Insert Into T_ProModuleLevelForPage(ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible,LangCode,HomeModuleName,IsDeleted)";
                strHQL += " SELECT ModuleName,ParentModule,SortNumber,PageName ,ModuleType ,UserType ,Visible," + "'" + strLangCode + "'" + ",HomeModuleName,IsDeleted FROM T_ProModuleLevelForPage";
                strHQL += " Where LangCode = '" + strFromLangCode + "' and ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) ||ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType))  Not in (Select ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) ||ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType)) From T_ProModuleLevelForPage Where LangCode = " + "'" + strLangCode + "'" + ")";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Update B Set B.SortNumber = A.SortNumber From T_ProModuleLevelForPage A,T_ProModuleLevelForPage B Where A.ModuleName = B.ModuleName and A.LangCode = '" + strFromLangCode + "' AND B.LangCode =" + "'" + strLangCode + "'";
                ShareClass.RunSqlCommand(strHQL);

                strHQL = "Delete From T_ProModuleLevelForPage Where LangCode = " + "'" + strLangCode + "'" + " and ModuleType in ('SYSTEM','APP')";
                strHQL += " and ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType))  Not in (Select ltrim(rtrim(ModuleName)) || ltrim(rtrim(ParentModule)) || ltrim(rtrim(ModuleType)) || ltrim(rtrim(UserType)) From T_ProModuleLevelForPage Where LangCode = '" + strFromLangCode + "')";
                ShareClass.RunSqlCommand(strHQL);
            }
        }
        catch
        {
        }
    }

    //判断用户是否有此模组
    public static bool IsExistModuleByUserCode(string strUserCode, string strModuleName, string strModuleType, string strUserType)
    {
        string strHQL = "Select * From T_ProModule Where UserCode = " + "'" + strUserCode + "'" + " and ModuleName = " + "'" + strModuleName + "'" + " and ModuleType = " + "'" + strModuleType + "'";
        strHQL += " and UserType = " + "'" + strUserType + "'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModule");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    //取得模组HOME名称
    public static string GetHomeModuleName(string strModuleName, string strLangCode)
    {
        string strHQL;

        strHQL = "Select HomeModuleName From T_ProModuleLevel Where ModuleName = " + "'" + strModuleName + "'" + " and LangCode = " + "'" + strLangCode + "'";
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

    //根据用户代码和登录IP判断是否阻止用户登录系统
    public static DataSet GetUserLoginManageDataSet(string strUserCode)
    {
        string strHQL;

        strUserCode = "%" + strUserCode + "%";

        strHQL = "Select ID, IsAllMember,IsForbidLogin,Message,UserCode,IP From T_UserLoginManage Where ";
        strHQL += " ((UserCode Like " + "'" + strUserCode + "'" + ")";
        strHQL += " Or (IsAllMember = 'YES'))";
        strHQL += " And Status = 'InUse'";
        strHQL += " Order By ID DESC";
        DataSet ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "T_UserLoginManage");

        return ds;
    }

    //取用户登录定制消息
    public static string GetUserLoginMessage(string strUserCode)
    {
        string strHQL;
        string strUserHostAddress, strMessage;

        strUserCode = "%" + strUserCode + "%";

        strUserHostAddress = HttpContext.Current.Request.UserHostAddress.Trim();
        strUserHostAddress = "%" + strUserHostAddress + "%";

        strHQL = "Select Message From T_UserLoginManage Where UserCode Like " + "'" + strUserCode + "'" + " and IP Like " + "'" + strUserHostAddress + "'";
        strHQL += " and Status = 'InUse'";
        strHQL += " Order By ID DESC";
        DataSet ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "T_UserLoginManage");

        if (ds.Tables[0].Rows.Count > 0)
        {
            strMessage = ds.Tables[0].Rows[0][0].ToString().Trim();

            return strMessage;
        }
        else
        {
            return "";
        }
    }

    //插入用户日志
    public static void InsertUserLogonLog(string strUserCode, string strUserName, string strDeviceType)
    {
        string strUserHostAddress = HttpContext.Current.Request.UserHostAddress.Trim();
        string strUserHostName = HttpContext.Current.Request.UserHostName.Trim();

        try
        {
            string strHQL;
            strHQL = "Insert Into T_LogonLog(UserIP,UserHostName,Position,LoginTime,UserCode,UserName,LastestTime,DeviceType)";
            strHQL += " Values('" + strUserHostAddress + "','" + strUserHostName + "','" + ShareClass.GetIPinArea(strUserHostAddress) + "',now(),";
            strHQL += " '" + strUserCode + "','" + strUserName + "',now(),'" + strDeviceType + "')";

            ShareClass.RunSqlCommand(strHQL);
        }
        catch
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('警告，用户登录日志或详细操作日志记录已超过21亿，请及时清空登录日志表！');</script>");
        }
    }

    public static void InsertUserLogonLogForHandler(string strUserCode, string strUserName, string strUserHostAddress, string strUserHostName, string strPosition, string strDeviceType)
    {
        LogonLogBLL logonLogBLL = new LogonLogBLL();
        LogonLog logonLog = new LogonLog();

        logonLog.UserIP = strUserHostAddress;
        logonLog.UserHostName = strUserHostName;
        logonLog.Position = strPosition;
        logonLog.LoginTime = DateTime.Now;
        logonLog.UserCode = strUserCode;
        logonLog.UserName = strUserName;
        logonLog.LastestTime = DateTime.Now;
        logonLog.DeviceType = strDeviceType;

        try
        {
            logonLogBLL.AddLogonLog(logonLog);
        }
        catch
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('警告，用户登录日志或详细操作日志记录已超过21亿，请及时清空登录日志表！');</script>");
        }
    }

    public static void LoadSystemMDIStyle(DropDownList DL_SystemMDIStyle)
    {
        string strHQL = "from SystemMDIStyle as systemMDIStyle Order By systemMDIStyle.SortNumber ASC";

        SystemMDIStyleBLL systemMDIStyleBLL = new SystemMDIStyleBLL();
        IList lst = systemMDIStyleBLL.GetAllSystemMDIStyles(strHQL);

        DL_SystemMDIStyle.DataSource = lst;
        DL_SystemMDIStyle.DataBind();
    }

    public static void LoadLanguageForDropList(DropDownList DL_Language)
    {
        string strHQL;

        strHQL = "Select trim(LangCode) as LangCode,Language From T_SystemLanguage Order By SortNumber ASC";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemLanguage");
        DL_Language.DataSource = ds;
        DL_Language.DataBind();
    }

    public static string GetDayPilotLanguage()
    {
        string strLangCode = HttpContext.Current.Session["LangCode"].ToString();

        if (strLangCode == "zh-CN")
        {
            return "zh-CN";
        }

        if (strLangCode == "en")
        {
            return "en-US";
        }

        if (strLangCode == "fr")
        {
            return "fr-FR";
        }

        if (strLangCode == "de")
        {
            return "de-DE";
        }

        if (strLangCode == "ja")
        {
            return "ja-JP";
        }

        if (strLangCode == "ru")
        {
            return "ru-RU";
        }

        if (strLangCode == "es")
        {
            return "es-ES";
        }

        if (strLangCode == "zh-tw")
        {
            return "zh-CN";
        }

        return "en-US";
    }

    public static void MakeUserDirectory(string strUserCode)
    {
        string strDirectory, strDocSavePath, strYearMonth;
        int intResult;

        //创建私人文件目录
        strDocSavePath = HttpContext.Current.Server.MapPath("Doc");
        strYearMonth = DateTime.Now.ToString("yyyyMM");

        strDirectory = strDocSavePath + "\\" + strYearMonth + "\\" + strUserCode + "\\Doc";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create Doc Director ！')", true);

        strDirectory = strDocSavePath + "\\" + strYearMonth + "\\" + strUserCode + "\\Images";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create Images Director ！')", true);

        strDirectory = strDocSavePath + "\\" + strYearMonth + "\\" + strUserCode + "\\MailAttachments";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create  MailAttachments Director ！')", true);

        strDirectory = strDocSavePath + "\\XML";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create  XML Director ！')", true);

        strDirectory = strDocSavePath + "\\Log";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create  XML Director ！')", true);

        strDirectory = strDocSavePath + "\\WorkFlowTemplate";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create  WorkFlowTemplate Director ！')", true);

        strDirectory = strDocSavePath + "\\UserPhoto";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create  UserPhoto Director ！')", true);

        strDirectory = strDocSavePath + "\\Report";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create  Report Director ！')", true);

        strDirectory = strDocSavePath + "\\RTXAccount";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create RTXAccount Director ！')", true);

        strDirectory = strDocSavePath + "\\BackupDB";
        intResult = CreateDirectory(strDirectory);
        //if (intResult == 2)
        //    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create RTXAccount Director ！')", true);

        //strDirectory = strDocSavePath + "\\" + strYearMonth + "\\BackupDB";
        //intResult = CreateDirectory(strDirectory);
        ////if (intResult == 2)
        ////    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('Failed to create  BackupDB Director ！')", true);
    }

    public static int CreateDirectory(string strDirectory)
    {
        DirectoryInfo NewDirInfo;

        if (!Directory.Exists(strDirectory))
        {
            try
            {
                Directory.CreateDirectory(strDirectory);
                NewDirInfo = new DirectoryInfo(strDirectory);
                NewDirInfo.Attributes = FileAttributes.Normal;
                return 1;
            }
            catch
            {
                return 2;
            }
        }
        else
        {
            return 3;
        }
    }

    //   /****************************************
    // * 函数名称:GetDirectoryLength(string dirPath)
    // * 功能说明:获取文件夹大小
    // * 参    数:dirPath:文件夹详细路径
    // * 调用示列:
    // *           string Path = Server.MapPath("templates");
    // *           Response.Write(EC.FileObj.GetDirectoryLength(Path));
    //*****************************************/
    /// <summary>
    /// 获取文件夹大小
    /// </summary>
    /// <param name="dirPath">文件夹路径</param>
    /// <returns></returns>
    public static long GetDirectoryLength(string dirPath)
    {
        if (!Directory.Exists(dirPath))
            return 0;
        long len = 0;
        DirectoryInfo di = new DirectoryInfo(dirPath);
        foreach (FileInfo fi in di.GetFiles())
        {
            len += fi.Length;
        }
        DirectoryInfo[] dis = di.GetDirectories();
        if (dis.Length > 0)
        {
            for (int i = 0; i < dis.Length; i++)
            {
                len += GetDirectoryLength(dis[i].FullName);
            }
        }
        return len;
    }

    //获取某个文件夹的大小（方法一）
    public static long GetFoldSize(string dirPath)
    {
        FileInfo info = new FileInfo(dirPath);

        return info.Length;
    }

    //生成数据库只读用户ID，一般于报表设计者
    public static string getDBReadOnlyUserID()
    {
        string[] strConnectStringList;

        strConnectStringList = HttpContext.Current.Request.Url.AbsolutePath.Split("/".ToCharArray());
        return (strConnectStringList[1].Replace(".aspx", "") + "DBReadOnlyUser").ToLower();
    }

    //密码生成器
    public static string genernalPassword()
    {
        string chars = "0123456789ABCDEFGHIJKLMNOPQSTUVWXYZabcdefghijklmnpqrstuvwxyz@*";
        Random randrom = new Random(getNewSeed());

        string str = "";
        for (int j = 0; j < 50; j++)
        {
            str = "";
            for (int i = 0; i < 8; i++)
            {
                str += chars[randrom.Next(chars.Length)];//randrom.Next(int i)返回一个小于所指定最大值的非负随机数
            }
            //不符合正则，重新生成
            if (!Regex.IsMatch(str, @"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$"))
            {
                continue;
            }
            else
            {
                break;
            }
        }

        return str;
    }

    public static int getNewSeed()
    {
        byte[] rndBytes = new byte[4];
        System.Security.Cryptography.RNGCryptoServiceProvider rng = new System.Security.Cryptography.RNGCryptoServiceProvider();
        rng.GetBytes(rndBytes);
        return BitConverter.ToInt32(rndBytes, 0);
    }

    #endregion 用户登录机制

}
