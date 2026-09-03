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
/// ShareClass partial - SQL_XML
/// </summary>
public static partial class ShareClass
{
    
    #region SQL函数\XML函数\WebService调用方法

    //执行一般处理程序
    //当content-type:  application/x-www-from-urlencode时，参数格式为:name="zzzz"&id="aaaaa"
    /// <summary>
    /// 执行一般处理程序
    /// 调用方法:string strResult = GetPostDataPage("http://localhost:16422/Web/Handler/test.ashx", "");
    /// </summary>
    /// <param name="posturl"></param>
    /// <param name="postData"></param>
    /// <returns></returns>
    public static string GetPostDataPage(string posturl, string postData)
    {
        Stream outstream = null;
        Stream instream = null;
        StreamReader sr = null;
        //HttpWebResponse response = null;
        HttpWebRequest defectuest = null;
        Encoding encoding = Encoding.UTF8;
        byte[] data = encoding.GetBytes(postData);
        // 准备请求...
        try
        {
            // 设置参数
            defectuest = WebRequest.Create(posturl) as HttpWebRequest;
            CookieContainer cookieContainer = new CookieContainer();
            defectuest.CookieContainer = cookieContainer;
            defectuest.AllowAutoRedirect = true;
            defectuest.Method = "POST";
            //defectuest.ContentType = "application/x-www-form-urlencoded";
            defectuest.ContentType = "text/xml";
            defectuest.ContentLength = data.Length;
            outstream = defectuest.GetRequestStream();
            outstream.Write(data, 0, data.Length);
            outstream.Close();
            //发送请求并获取相应回应数据

            //response = defectuest.GetResponse() as HttpWebResponse;
            HttpWebResponse res;
            try
            {
                res = (HttpWebResponse)defectuest.GetResponse();
            }
            catch (WebException ex)
            {
                res = (HttpWebResponse)ex.Response;
            }

            //直到defectuest.GetResponse()程序才开始向目标网页发送Post请求
            instream = res.GetResponseStream();
            sr = new StreamReader(instream, encoding);
            //返回结果网页（html）代码
            string content = sr.ReadToEnd();
            string err = string.Empty;

            return content;
        }
        catch (Exception ex)
        {
            string err = ex.Message;
            return string.Empty;
        }
    }

    //序列化SQL
    public static string Escape(string str)
    {
        StringBuilder sb = new StringBuilder();
        foreach (char c in str)
        {
            sb.Append((Char.IsLetterOrDigit(c)
            || c == '-' || c == '_' || c == '\\'
            || c == '/' || c == '.') ? c.ToString() : Uri.HexEscape(c));
        }
        return sb.ToString();
    }

    //反序列化SQL
    public static string UnEscape(string str)
    {
        StringBuilder sb = new StringBuilder();
        int len = str.Length;
        int i = 0;
        while (i != len)
        {
            if (Uri.IsHexEncoding(str, i))
                sb.Append(Uri.HexUnescape(str, ref i));
            else
                sb.Append(str[i++]);
        }
        return sb.ToString();
    }

    //创建数据库用户
    public static bool CreateDBUserAccount(string loginUser, string password, string strIsSecurityadmin)
    {
        string cmdText1, cmdText2;

        try
        {
            ////创建登陆帐户（create login）
            cmdText1 = string.Format(@"create user {0} with password '{1}';", loginUser, password);
            ShareClass.RunSqlCommand(cmdText1);
        }
        catch (Exception err)
        {
            //LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }

        try
        {
            cmdText2 = string.Format(@"alter user {0} with password '{1}'; ", loginUser, password);
            ShareClass.RunSqlCommand(cmdText2);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }


        return true;
    }

    //授予用户数据库权限
    public static bool AuthorizationDBToUser(string loginUser, string password, string databasename, string strIsSecurityadmin)
    {
        string cmdText1;
        try
        {
            if (strIsSecurityadmin == "NO")
            {
                ////将数据库只读权限赋予loginuser
                cmdText1 = string.Format(@"REVOKE CREATE ON SCHEMA public from public;
                    GRANT SELECT ON ALL TABLES IN SCHEMA public TO {0};
                    ALTER DEFAULT PRIVILEGES IN SCHEMA public grant select on tables to {0}; ", loginUser, password);
                ShareClass.RunSqlCommand(cmdText1);
            }
            else
            {
                ////将数据库的所有权限赋予loginuser，否则只能登录psql，没有任何数据库操作权限
                cmdText1 = string.Format(@"REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM {1};
                                 grant all privileges on database {2}{0}{2} to {1};
                                 alter database {2}{0}{2} owner to {1};
                                 ", databasename, loginUser, "\"");
                ShareClass.RunSqlCommand(cmdText1);

                //授予自建站点用户所有权限
                GanttAllPrivilegesToSiteUser(databasename, loginUser);
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }

        return true;
    }

    //授予自建站点用户所有权限
    public static void GanttAllPrivilegesToSiteUser(string strSiteDBName, string strSiteUser)
    {
        string strConnectString;

        try
        {
            // 获取连接字符串
            strConnectString = ShareClass.GetSiteConnectString(strSiteDBName);
            using (var conn = new NpgsqlConnection(strConnectString))
            {
                conn.Open();

                // 运行 SQL 命令
                string sql = string.Format(@"ALTER USER {0} WITH CREATEROLE;GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO {0};ALTER USER {0} WITH SUPERUSER;", strSiteUser);
                using (var cmd = new NpgsqlCommand(sql, conn))
                {
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //取得自建站点的数据库连接串
    public static string GetSiteConnectString(string strSiteDBName)
    {
        string strConnectString, strDBName;

        strConnectString = ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;
        strDBName = ShareClass.GetSystemDBName();

        strConnectString = strConnectString.Replace("=" + strDBName, "=" + strSiteDBName);

        return strConnectString;
    }


    //直接删除指定目录下的所有文件
    public static void DeleteFileUnderDirectory(string strDirectory)
    {
        try
        {
            //去除文件夹和子文件的只读属性
            //去除文件夹的只读属性
            System.IO.DirectoryInfo fileInfo = new DirectoryInfo(strDirectory);
            fileInfo.Attributes = FileAttributes.Normal & FileAttributes.Directory;

            //去除文件的只读属性
            System.IO.File.SetAttributes(strDirectory, System.IO.FileAttributes.Normal);

            //判断文件夹是否还存在
            if (Directory.Exists(strDirectory))
            {
                foreach (string f in Directory.GetFileSystemEntries(strDirectory))
                {
                    if (File.Exists(f))
                    {
                        try
                        {
                            //如果有子文件删除文件
                            File.Delete(f);
                        }
                        catch
                        {
                        }
                    }
                    else
                    {
                        try
                        {
                            //循环递归删除子文件夹
                            DeleteFileUnderDirectory(f);
                        }
                        catch
                        {
                        }
                    }
                }
            }
        }
        catch (Exception ex) // 异常处理
        {
        }
    }

    public static DataSet LoadSytemChart(string strUserCode, string strFormType, Repeater RP_ChartList)
    {
        string strHQL, strSql;
        string strLangCode = HttpContext.Current.Session["LangCode"].ToString();
        string strDepartString;
        if (HttpContext.Current.Session["DepartString"] == null)
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
            HttpContext.Current.Session["DepartString"] = strDepartString;
        }
        else
        {
            strDepartString = HttpContext.Current.Session["DepartString"].ToString();
        }

        strHQL = string.Format(@"
            SELECT s.* 
            FROM T_SystemAnalystChartRelatedUser s 
            INNER JOIN t_systemanalystchartmanagement c ON s.ChartName = c.ChartName 
            WHERE s.UserCode = '{0}' 
                AND s.FormType = '{1}' 
                AND c.Status = 'YES'",
              strUserCode, strFormType);
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemAnalystChartManagement");
        if (ds.Tables[0].Rows.Count > 0)
        {
            strHQL = string.Format(@"
                SELECT 
                    TRIM(A.FormType) as FormType,
                    TRIM(A.ChartName) as ChartName,
                    TRIM(C.SqlCode) as SqlCode,
                    TRIM(C.ChartType) as ChartType
                FROM T_SystemAnalystChartRelatedUser A
                INNER JOIN T_SystemAnalystChartManagement C ON A.ChartName = C.ChartName
                WHERE A.UserCode = '{0}' 
                    AND A.FormType = '{1}' 
                    AND C.Status = 'YES'
                ORDER BY A.SortNumber ASC",
                  strUserCode, strFormType);
        }
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemAnalystChartManagement");

        DataSet dsBackup = ds;

        for (int i = 0; i < dsBackup.Tables[0].Rows.Count; i++)
        {
            strSql = dsBackup.Tables[0].Rows[i]["SqlCode"].ToString();
            strSql = strSql.Replace("[TAKETOPUSERCODE]", strUserCode).Replace("[TAKETOPDEPARTSTRING]", strDepartString).Replace("[TAKETOPLANGCODE]", strLangCode);
            if (strSql.Trim() != "")
            {
                DataSet dsSql = ShareClass.GetDataSetFromSql(strSql, "T_Sql");
                if (dsSql.Tables[0].Rows.Count == 0)
                {
                    try
                    {
                        ds.Tables[0].Rows[i].Delete();
                    }
                    catch
                    {
                    }
                }
            }
            else
            {
                try
                {
                    ds.Tables[0].Rows[i].Delete();
                }
                catch
                {
                }
            }
        }



        RP_ChartList.DataSource = ds;
        RP_ChartList.DataBind();

        return ds;
    }

    //取得形成分析图的DataSet
    public static DataSet GetSytemChartDataSet(string strUserCode, string strFormType)
    {
        string cacheKey = "ChartConfig_" + strUserCode + "_" + strFormType;

        // 尝试从 HttpRuntime.Cache 获取
        DataSet cached = GetChartCache(cacheKey);
        if (cached != null)
        {
            return cached;
        }

        string strLangCode = HttpContext.Current.Session["LangCode"].ToString();
        string strDepartString;
        if (HttpContext.Current.Session["DepartString"] == null)
        {
            strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
            HttpContext.Current.Session["DepartString"] = strDepartString;
        }
        else
        {
            strDepartString = HttpContext.Current.Session["DepartString"].ToString();
        }

        // 优化：合并两次查询为一次，直接获取最终结果
        string strHQL = string.Format(@"
            SELECT 
                TRIM(A.FormType) as FormType,
                TRIM(A.ChartName) as ChartName,
                TRIM(C.SqlCode) as SqlCode,
                TRIM(C.ChartType) as ChartType
            FROM T_SystemAnalystChartRelatedUser A
            INNER JOIN T_SystemAnalystChartManagement C ON A.ChartName = C.ChartName
            WHERE A.UserCode = '{0}' 
                AND A.FormType = '{1}' 
                AND C.Status = 'YES'
            ORDER BY A.SortNumber ASC",
               strUserCode, strFormType);
        
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_SystemAnalystChartManagement");

        // 存入 HttpRuntime.Cache（滑动过期 5 分钟）
        SetChartCache(cacheKey, ds);

        return ds;
    }

    /// <summary>
    /// 预计算个人空间分析图数据 - 登录时调用
    /// </summary>
    public static void PreCalculatePersonalSpaceCharts(string strUserCode)
    {
        try
        {
            string strLangCode = HttpContext.Current.Session["LangCode"].ToString();
            string strDepartString;
            if (HttpContext.Current.Session["DepartString"] == null)
            {
                strDepartString = TakeTopCore.CoreShareClass.InitialDepartmentStringByAuthoritySuperUser(strUserCode);
                HttpContext.Current.Session["DepartString"] = strDepartString;
            }
            else
            {
                strDepartString = HttpContext.Current.Session["DepartString"].ToString();
            }

            // 获取用户的分析图配置
            DataSet dsConfig = GetSytemChartDataSet(strUserCode, "PersonalSpacePage");
            if (dsConfig == null || dsConfig.Tables[0].Rows.Count == 0)
            {
                return;
            }

            // 预计算每个图表的数据并缓存到 Session
            List<ChartPreloadData> preloadedData = new List<ChartPreloadData>();
            
            foreach (DataRow row in dsConfig.Tables[0].Rows)
            {
                try
                {
                    string chartName = row["ChartName"].ToString().Trim();
                    string chartType = row["ChartType"].ToString().Trim();
                    string sqlCode = row["SqlCode"].ToString();
                    string formType = row["FormType"].ToString().Trim();
                    
                    if (string.IsNullOrEmpty(sqlCode))
                    {
                        continue;
                    }
                    
                    // 执行 SQL 获取数据
                    string strSql = sqlCode.Replace("[TAKETOPUSERCODE]", strUserCode)
                                           .Replace("[TAKETOPDEPARTSTRING]", strDepartString)
                                           .Replace("[TAKETOPLANGCODE]", strLangCode);
                    
                    DataSet dsData = GetDataSetFromSql(strSql, "T_ChartData");
                    
                    if (dsData != null && dsData.Tables[0].Rows.Count > 0)
                    {
                        // 构建数据对象
                        List<object> dataList = new List<object>();
                        foreach (DataRow dataRow in dsData.Tables[0].Rows)
                        {
                            if (formType == "Column2" || formType == "Bar2")
                            {
                                dataList.Add(new { 
                                    XName = dataRow["XName"].ToString(), 
                                    YNumber = dataRow["YNumber"].ToString(), 
                                    ZNumber = dataRow["ZNumber"].ToString() 
                                });
                            }
                            else if (formType == "Column3" || formType == "Bar3")
                            {
                                dataList.Add(new { 
                                    XName = dataRow["XName"].ToString(), 
                                    YNumber = dataRow["YNumber"].ToString(), 
                                    ZNumber = dataRow["ZNumber"].ToString(),
                                    HNumber = dataRow["HNumber"].ToString()
                                });
                            }
                            else if (formType == "Column4" || formType == "Bar4")
                            {
                                dataList.Add(new { 
                                    XName = dataRow["XName"].ToString(), 
                                    YNumber = dataRow["YNumber"].ToString(), 
                                    ZNumber = dataRow["ZNumber"].ToString(),
                                    HNumber = dataRow["HNumber"].ToString(),
                                    KNumber = dataRow["KNumber"].ToString()
                                });
                            }
                            else
                            {
                                // 卡片类型或其他 - YNumber 可能包含逗号分隔的多个值
                                dataList.Add(new { 
                                    XName = dataRow["XName"].ToString(), 
                                    YNumber = dataRow["YNumber"].ToString() 
                                });
                            }
                        }
                        
                        // 序列化为 JSON
                        System.Web.Script.Serialization.JavaScriptSerializer serializer = 
                            new System.Web.Script.Serialization.JavaScriptSerializer();
                        string jsonData = serializer.Serialize(dataList);
                        
                        preloadedData.Add(new ChartPreloadData
                        {
                            ChartName = chartName,
                            ChartType = chartType,
                            FormType = formType,
                            JsonData = jsonData
                        });
                    }
                }
                catch (Exception ex)
                {
                    // 单个图表失败不影响其他图表
                    LogClass.WriteLogFile("PreCalculate chart error: " + ex.Message);
                }
            }
            
            // 存入 Session - 个人空间页面会使用这个缓存
            HttpContext.Current.Session["PreloadedChartData"] = preloadedData;
            HttpContext.Current.Session["PreloadedChartTime"] = DateTime.Now;
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("PreCalculatePersonalSpaceCharts error: " + err.Message);
        }
    }

    /// <summary>
    /// 预加载的图表数据项
    /// </summary>
    [Serializable]
    public class ChartPreloadData
    {
        public string ChartName { get; set; }
        public string ChartType { get; set; }
        public string FormType { get; set; }
        public string JsonData { get; set; }
    }

    //自动备份系统数据
    public static void AutoBackupDataBySystem()
    {
        string strHQL1, strHQL2;
        strHQL1 = "Select * From T_BackDBLog Where to_char(BackTime,'yyyymmdd') = to_char(now(),'yyyymmdd')";
        DataSet ds1 = ShareClass.GetDataSetFromSql(strHQL1, "T_BackDBLog");
        if (ds1.Tables[0].Rows.Count == 0)
        {
            try
            {
                //备份数据库
                ShareClass.BackupCurrentSiteDB(ShareClass.GetSystemDBName(), ShareClass.GetSystemDBBackupSaveDir(), "Timer", "SELF");
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }

        strHQL2 = "Select * From T_BackDocLog Where to_char(BackTime,'yyyymmdd') = to_char(now(),'yyyymmdd')";
        DataSet ds2 = ShareClass.GetDataSetFromSql(strHQL2, "T_BackDocLog");
        if (ds2.Tables[0].Rows.Count == 0)
        {
            try
            {
                //备份文档
                ShareClass.BackupCurrentSiteDoc("Timer");
            }
            catch (Exception err)
            {
                LogClass.WriteLogFile("Error page: " + "\n" + err.Message.ToString() + "\n" + err.StackTrace);
            }
        }
    }


    //备份平台文档
    public static int BackupCurrentSiteDoc(string strBackupUser)
    {
        string strDirectory, strBackupPeriodDay, strBackupDirectorySavePath, strBackupDirectory;
        string strDocDirectory;
        int intResult;

        string strBackDocHQL = "select BackDocUrl,BackPeriodDay from T_BackDocPrame";
        DataSet ds = ShareClass.GetDataSetFromSql(strBackDocHQL, "strBackDocHQL");
        if (ds.Tables[0].Rows.Count == 0)
        {
            return -1;
        }
        else
        {
            try
            {
                strDirectory = ds.Tables[0].Rows[0][0].ToString().Trim();
            }
            catch
            {
                strDirectory = "";
            }

            if (strDirectory == "")
            {
                return -1;
            }

            try
            {
                strBackupPeriodDay = int.Parse(ds.Tables[0].Rows[0][1].ToString()).ToString();
            }
            catch
            {
                strBackupPeriodDay = "0";
            }
        }

        strBackupDirectory = DateTime.Now.ToString("yyyyMMdd");
        strBackupDirectorySavePath = strDirectory + "\\" + strBackupDirectory;

        if (strDirectory != "")
        {
            intResult = ShareClass.CreateDirectory(strBackupDirectorySavePath);
            if (intResult == 2)
            {
                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('警告，备份目录创建"+LanguageHandle.GetWord("ZZSBJC").ToString().Trim()+"')", true);
                return -1;
            }
        }
        else
        {
            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click033", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGBFMLBNWKJC").ToString().Trim() + "')", true);
            return 1;
        }

        bool blCopy;
        string strFromDirectory, strToDirectory;
        string strErrorMsg = "";

        try
        {
            try
            {
                //判断当月是不是第一次备份
                if (GetCurrentMonthBackupNumber() == 0)
                {
                    strDocDirectory = DateTime.Now.AddMonths(-1).ToString("yyyyMM");
                    strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\" + strDocDirectory + "\\";
                    strToDirectory = strBackupDirectorySavePath + "\\" + strDocDirectory;
                    blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
                }
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy Doc directory Error: " + err.Message.ToString() + ";";
            }

            try
            {
                //copy Doc
                strDocDirectory = DateTime.Now.ToString("yyyyMM");
                strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\" + strDocDirectory + "\\";
                strToDirectory = strBackupDirectorySavePath + "\\" + strDocDirectory;
                blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy Doc directory Error: " + err.Message.ToString() + ";";
            }

            try
            {
                //copy WorkflowTemplate
                strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\WorkFlowTemplate\\";
                strToDirectory = strBackupDirectorySavePath + "\\" + "WorkFlowTemplate";
                blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy WorkflowTemplateL directory Error: " + err.Message.ToString() + ";";
            }

            try
            {
                //copy XML
                strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\XML\\";
                strToDirectory = strBackupDirectorySavePath + "\\" + "XML";
                blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy XML directory Error: " + err.Message.ToString() + ";";
            }

            try
            {
                //copy UserPhoto
                strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\UserPhoto\\";
                strToDirectory = strBackupDirectorySavePath + "\\" + "UserPhoto";
                blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy UserPhoto directory Error: " + err.Message.ToString() + ";";
            }

            try
            {
                //copy Report
                strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\Report\\";
                strToDirectory = strBackupDirectorySavePath + "\\" + "Report";
                blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy Report directory Error: " + err.Message.ToString() + ";";
            }

            try
            {
                //copy Bar
                strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\Bar\\";
                strToDirectory = strBackupDirectorySavePath + "\\" + "Bar";
                blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy Bar directory Error: " + err.Message.ToString() + ";";
            }

            try
            {
                //copy RTXAccount
                strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\RTXAccount\\";
                strToDirectory = strBackupDirectorySavePath + "\\" + "RTXAccount";
                blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy RTXAccount directory Error: " + err.Message.ToString() + ";";
            }

            try
            {
                //copy Log
                strFromDirectory = HttpContext.Current.Server.MapPath("Doc") + "\\Log\\";
                strToDirectory = strBackupDirectorySavePath + "\\" + "Log";
                blCopy = ShareClass.CopyDirectory(strFromDirectory, strToDirectory + "\\", false);
            }
            catch (Exception err)
            {
                strErrorMsg += "Copy Log directory Error: " + err.Message.ToString() + ";";
            }

            //写日志
            string strInsertBackLogHQL = string.Format(@"insert into T_BackDocLog(BackTime,BackDocUrl,UserCode,UserName,IsSucc) values(now(),'{0}','{1}','{2}',1)",
                 strBackupDirectorySavePath, strBackupUser, strBackupUser);
            ShareClass.RunSqlCommand(strInsertBackLogHQL);

            if (strErrorMsg == "")
            {
                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click044", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBeiFenChengGong").ToString().Trim() + "')", true);
                return 1;
            }
            else
            {
                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click055", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBeiFenShiBaiQingJianCha").ToString().Trim() + ": " + strErrorMsg + "')", true);
                return -1;
            }
        }
        catch (Exception err)
        {
            //写日志
            string strInsertBackLogHQL = string.Format(@"insert into T_BackDocLog(BackTime,BackDocUrl,UserCode,UserName,IsSucc) values(now(),'{0}','{2}','{2}',0)",
                 strBackupDirectorySavePath, strBackupUser, strBackupUser);
            ShareClass.RunSqlCommand(strInsertBackLogHQL);

            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click066", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZBeiFenShiBaiQingJianCha").ToString().Trim() + ": " + err.Message.ToString() + "')", true);
            return -1;
        }
    }

    //取得当月备份次数
    public static int GetCurrentMonthBackupNumber()
    {
        string strHQL;
        strHQL = "Select * From T_BackDocLog Where extract(year from BackTime) = extract(year from now()) And extract(month from BackTime) = extract(month from now())";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BackDocLog");

        return ds.Tables[0].Rows.Count;
    }

    //取得最新备份文档时间
    public static string GetAllreadyBackupDocLastestTime()
    {
        string strHQL;
        strHQL = "Select Max(BackTime) From T_BackDocLog";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BackDocLog");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    //取得最新备份文档时间
    public static string GetAllreadyBackupDBLastestTime()
    {
        string strHQL;
        strHQL = "Select Max(BackTime) From T_BackDBLog";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BackDBLog");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0].Rows[0][0].ToString();
        }
        else
        {
            return "";
        }
    }

    //取得上次备份时间到现在的月份
    public static int GetBackupDBLastestTimeDifferMonth()
    {
        string strHQL;
        strHQL = "Select * From T_BackDocLog";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_BackDBLog");
        if (ds.Tables[0].Rows.Count == 0)
        {
            return 10;
        }

        strHQL = "Select (DATE_PART('year', now()::date) - DATE_PART('year', Max(BackTime)::date)) * 12 +(DATE_PART('month', now()::date) - DATE_PART('month', Max(BackTime)::date)) From T_BackDocLog";
        ds = ShareClass.GetDataSetFromSql(strHQL, "T_BackDBLog");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return int.Parse(ds.Tables[0].Rows[0][0].ToString());
        }
        else
        {
            return 10;
        }
    }

    //取得语言资源文件的KEY值
    public static string GetLanguageResourceKeyValue(string strLangCode, string strKey)
    {
        string strResouceFile = "lang." + strLangCode.Trim() + ".resx";
        if (!String.IsNullOrEmpty(strKey))
        {
            return HttpContext.GetGlobalResourceObject(strResouceFile, strKey).ToString();
        }
        else
        {
            return null;
        }
    }

    //异步执行页面
    public static void SyncProjectPlanSchedule(string strURL)
    {
        string strSPInterfaceURL;

        new System.Threading.Thread(delegate ()
        {
            strSPInterfaceURL = strURL;
            HttpWebRequest req = (HttpWebRequest)HttpWebRequest.Create(strSPInterfaceURL);
            req.Method = "GET";
            req.ContentType = "application/x-www-form-urlencoded";
            try
            {
                using (WebResponse wr = req.GetResponse())
                {
                    //在这里对接收到的页面内容进行处理
                }
            }
            catch
            {
            }

        }).Start();
    }


    /*  动态调用WebService示例
        //string url = "http://www.webxml.com.cn/WebServices/WeatherWebservice.asmx";
        //string[] args = new string[1];
        //args[0] = "杭州";
        //object result = ShareClass.InvokeWebService(url, "getWeatherbyCityName", args);
        //Response.Write(result.ToString());
        //ClientScript.RegisterStartupScript(this.GetType(), "", "<script>showAlertAtMouse('" + result.ToString() + "！');</script>");
    */

    //执行一般处理程序
    //当content-type:  application/x-www-from-urlencode时，参数格式为:name="zzzz"&id="aaaaa"
    public static string GetResponseByPost(string apiUrl, string queryString)
    {
        string responseString = string.Empty;
        HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(apiUrl + queryString);
        request.ContentType = "text/html";
        request.Method = "POST";
        request.ContentLength = queryString.Length;
        request.Timeout = 20000;
        byte[] bytes = Encoding.UTF8.GetBytes(queryString);
        Stream os = null;
        try
        { // send the Post
            request.ContentLength = bytes.Length;   //Count bytes to send
            os = request.GetRequestStream();
            os.Write(bytes, 0, bytes.Length);         //Send it
        }
        catch (WebException ex)
        {
            throw ex;
        }
        finally
        {
            if (os != null)
            {
                os.Close();
            }
        }

        HttpWebResponse response = null;
        try
        {
            response = (HttpWebResponse)request.GetResponse();
            using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8))
            {
                responseString = reader.ReadToEnd();
            }
        }
        catch (Exception ex2)
        {
            throw ex2;
        }
        finally
        {
            if (response != null)
                response.Close();
        }
        return responseString;
    }

    #region InvokeWebService

    /// < summary>
    /// 动态调用web服务
    /// < /summary>
    /// < param name="url">WSDL服务地址< /param>
    /// < param name="methodname">方法名< /param>
    /// < param name="args">参数< /param>
    /// < returns>< /returns>
    public static object InvokeWebService(string url, string methodname, object[] args)
    {
        return InvokeWebService(url, null, methodname, args);
    }

    /// < summary>
    /// 动态调用web服务
    /// < /summary>
    /// < param name="url">WSDL服务地址< /param>
    /// < param name="classname">类名< /param>
    /// < param name="methodname">方法名< /param>
    /// < param name="args">参数< /param>
    /// < returns>< /returns>
    public static object InvokeWebService(string url, string classname, string methodname, object[] args)
    {
        string @namespace = "EnterpriseServerBase.WebService.DynamicWebCalling";
        if ((classname == null) || (classname == ""))
        {
            classname = GetWsClassName(url);
        }

        try
        {
            //获取WSDL
            WebClient wc = new WebClient();
            Stream stream = wc.OpenRead(url + "?WSDL");
            ServiceDescription sd = ServiceDescription.Read(stream);
            ServiceDescriptionImporter sdi = new ServiceDescriptionImporter();
            sdi.AddServiceDescription(sd, "", "");
            CodeNamespace cn = new CodeNamespace(@namespace);

            //生成客户端代理类代码
            CodeCompileUnit ccu = new CodeCompileUnit();
            ccu.Namespaces.Add(cn);
            sdi.Import(cn, ccu);
            CSharpCodeProvider icc = new CSharpCodeProvider();

            //设定编译参数
            CompilerParameters cplist = new CompilerParameters();
            cplist.GenerateExecutable = false;
            cplist.GenerateInMemory = true;
            cplist.ReferencedAssemblies.Add("System.dll");
            cplist.ReferencedAssemblies.Add("System.XML.dll");
            cplist.ReferencedAssemblies.Add("System.Web.Services.dll");
            cplist.ReferencedAssemblies.Add("System.Data.dll");

            //编译代理类
            CompilerResults cr = icc.CompileAssemblyFromDom(cplist, ccu);
            if (true == cr.Errors.HasErrors)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                foreach (System.CodeDom.Compiler.CompilerError ce in cr.Errors)
                {
                    sb.Append(ce.ToString());
                    sb.Append(System.Environment.NewLine);
                }
                throw new Exception(sb.ToString());
            }

            //生成代理实例，并调用方法
            System.Reflection.Assembly assembly = cr.CompiledAssembly;
            Type t = assembly.GetType(@namespace + "." + classname, true, true);
            object obj = Activator.CreateInstance(t);
            System.Reflection.MethodInfo mi = t.GetMethod(methodname);

            return mi.Invoke(obj, args);

            /*
            PropertyInfo propertyInfo = type.GetProperty(propertyname);
            return propertyInfo.GetValue(obj, null);
            */
        }
        catch (Exception ex)
        {
            throw new Exception(ex.InnerException.Message, new Exception(ex.InnerException.StackTrace));
        }
    }

    private static string GetWsClassName(string wsUrl)
    {
        string[] parts = wsUrl.Split('/');
        string[] pps = parts[parts.Length - 1].Split('.');

        return pps[0];
    }

    #endregion InvokeWebService

    //保存工作流XML数据到工作流表
    public static bool UpdateWFXMLData(string strXMLName, string strWFID)
    {
        string strHQL;
        int intStart, intLength;
        string strWFXMLData;
        string strNameSpacePrefix, strNameSpaceURI;
        string strRootName, strChildNodeName;

        try
        {
            //把流程XML数据保存在WFXMLData列
            XmlDocument document = new XmlDocument();
            document.Load(strXMLName);

            XmlElement root = document.DocumentElement;

            strRootName = root.Name;

            root.RemoveAttribute("xmlns:xsi");
            root.RemoveAttribute("xmlns:xd");
            root.RemoveAttribute("xmlns:my");

            strNameSpacePrefix = root.Prefix;
            strNameSpaceURI = root.NamespaceURI;

            strChildNodeName = root.ChildNodes[0].Name;

            strWFXMLData = xmlDocument2String(document);
            intStart = strWFXMLData.IndexOf("<" + strChildNodeName);
            intLength = strWFXMLData.Length - intStart;
            strWFXMLData = strWFXMLData.Substring(intStart, intLength);

            strWFXMLData = "<" + strRootName + ">" + strWFXMLData;

            strWFXMLData = strWFXMLData.Replace(strNameSpacePrefix + ":", "");

            strHQL = "Update T_WorkFlow Set WFXMLData = " + "'" + strWFXMLData + "'" + " Where WLID = " + strWFID;
            RunSqlCommand(strHQL);

            return true;
        }
        catch
        {
            return false;
        }
    }

    //把XML文档转成字符串
    public static string xmlDocument2String(XmlDocument doc)
    {
        MemoryStream stream = new MemoryStream();
        XmlTextWriter writer = new XmlTextWriter(stream, System.Text.Encoding.UTF8);
        writer.Formatting = Formatting.Indented;
        doc.Save(writer);
        StreamReader sr = new StreamReader(stream, System.Text.Encoding.UTF8);
        stream.Position = 0;
        string xmlstring = sr.ReadToEnd();
        sr.Close();
        stream.Close();
        return xmlstring;
    }
    // SQL取得数据集
    public static DataSet GetDataSetFromSql(string strHQL, string strTableName)
    {
        return GetDataSetInternal(strHQL, strTableName, true);
    }

    // SQL取得数据集,执行操作日志不存入日志表
    public static DataSet GetDataSetFromSqlNOOperateLog(string strHQL, string strTableName)
    {
        return GetDataSetInternal(strHQL, strTableName, false);
    }

    // 剥离SQL末尾顶层(不在括号内、不在字符串内)的 ORDER BY 子句，用于 COUNT 子查询。
    // 若未找到或不安全则返回原 SQL（行为等价）。
    private static string RemoveTopLevelOrderBy(string sql)
    {
        if (string.IsNullOrEmpty(sql))
            return sql;

        int n = sql.Length;
        int depth = 0;
        int orderByIndex = -1;

        for (int i = 0; i < n; i++)
        {
            char c = sql[i];
            // 字符串字面量：跳过，避免误判字符串内的 order by
            if (c == '\'')
            {
                i++;
                while (i < n && sql[i] != '\'')
                {
                    if (sql[i] == '\\') i++;
                    i++;
                }
                continue;
            }
            // 不区分大小写地匹配关键字边界
            if (c == 'o' || c == 'O')
            {
                if (depth == 0 && i + 8 < n &&
                    string.Compare(sql, i + 1, "rder", 0, 4, StringComparison.OrdinalIgnoreCase) == 0)
                {
                    // 其后应为空白，保证是独立关键字
                    if (i + 5 < n && char.IsWhiteSpace(sql[i + 5]))
                    {
                        orderByIndex = i;
                    }
                }
            }
            if (c == '(')
            {
                depth++;
            }
            else if (c == ')')
            {
                depth--;
            }
        }

        if (orderByIndex < 0)
            return sql;

        return sql.Substring(0, orderByIndex);
    }

    /// <summary>
    /// SQL分页查询：自动包装 LIMIT/OFFSET，返回当前页数据 + 总行数
    /// </summary>
    /// <param name="sql">原始SQL（SELECT ... FROM ... WHERE ... ORDER BY ...）</param>
    /// <param name="tableName">表名</param>
    /// <param name="pageIndex">页码（1-based）</param>
    /// <param name="pageSize">每页行数</param>
    /// <param name="totalCount">输出：总行数</param>
    /// <returns>当前页的DataSet</returns>
    public static DataSet GetPagedDataSet(string sql, string tableName, int pageIndex, int pageSize, out int totalCount)
    {
        totalCount = 0;

        // 1. 获取总行数（COUNT 子查询无需 ORDER BY，剥离以加快执行，结果不受影响）
        string countSql = "SELECT COUNT(*) FROM (" + RemoveTopLevelOrderBy(sql) + ") AS _paged_count";
        DataSet dsCount = GetDataSetFromSql(countSql, "_Count");
        totalCount = Convert.ToInt32(dsCount.Tables[0].Rows[0][0]);

        if (totalCount == 0)
            return new DataSet();

        // 2. 获取当前页数据
        int offset = (pageIndex - 1) * pageSize;
        string pagedSql = sql + " LIMIT " + pageSize + " OFFSET " + offset;
        return GetDataSetFromSql(pagedSql, tableName);
    }

    /// <summary>
    /// SQL分页查询（不记录操作日志版本）
    /// </summary>
    public static DataSet GetPagedDataSetNOOperateLog(string sql, string tableName, int pageIndex, int pageSize, out int totalCount)
    {
        totalCount = 0;

        string countSql = "SELECT COUNT(*) FROM (" + RemoveTopLevelOrderBy(sql) + ") AS _paged_count";
        DataSet dsCount = GetDataSetFromSqlNOOperateLog(countSql, "_Count");
        totalCount = Convert.ToInt32(dsCount.Tables[0].Rows[0][0]);

        if (totalCount == 0)
            return new DataSet();

        int offset = (pageIndex - 1) * pageSize;
        string pagedSql = sql + " LIMIT " + pageSize + " OFFSET " + offset;
        return GetDataSetFromSqlNOOperateLog(pagedSql, tableName);
    }

    // 运行SQL语句
    public static void RunSqlCommand(string strCmdText)
    {
        RunSqlCommandInternal(strCmdText, true);
    }

    // 运行SQL语句,执行操作日志不存入日志表
    public static void RunSqlCommandForNOOperateLog(string strCmdText)
    {
        RunSqlCommandInternal(strCmdText, false);
    }

    // 内部实现方法 - 数据集查询
    private static DataSet GetDataSetInternal(string sql, string tableName, bool writeOperateLog)
    {
        DataSet dataSet = new DataSet();

        // 纯读取查询：不需要事务。避免 SELECT 失败时在损坏的连接上执行 Rollback
        //（原实现 BeginTransaction+Commit+Rollback 会在 SQL 报错后二次触发 Npgsql 协议异常，
        //  即常见报错 Unknown message code: 150，掩盖真实错误）
        using (var connection = CreateConnection())
        {
            try
            {
                var parameters = ExtractParametersFromSql(ref sql);

                using (var command = CreateCommand(sql, connection, null, parameters))
                using (var adapter = new NpgsqlDataAdapter(command))
                {
                    adapter.SelectCommand.CommandTimeout = 1000;
                    adapter.Fill(dataSet, tableName);
                }

                if (writeOperateLog)
                {
                    ShareClass.InsertUserOperateLog(sql);
                }
            }
            catch (Exception ex)
            {
                HandleException(ex, sql);
                throw;
            }
        }

        return dataSet;
    }

    // 内部实现方法 - 执行命令
    private static void RunSqlCommandInternal(string sql, bool writeOperateLog)
    {
        using (var connection = CreateConnection())
        using (var transaction = connection.BeginTransaction())
        {
            try
            {
                var parameters = ExtractParametersFromSql(ref sql);

                using (var command = CreateCommand(sql, connection, transaction, parameters))
                {
                    command.CommandTimeout = 600;
                    command.ExecuteNonQuery();
                }

                transaction.Commit();

                // 写操作完成后清空查询缓存，确保缓存不与数据库不一致
                ShareClass.ClearQueryCache();

                if (writeOperateLog)
                {
                    InsertUserOperateLog(sql);
                }
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                HandleException(ex, sql);
                throw;
            }
        }
    }


    //运行SQL语句,执行操作日志不存入日志表
    public static void RunSqlCommandForNOOperateLogCommon(string strCmdText)
    {
        using (NpgsqlConnection myConnection = new NpgsqlConnection(GetConnectionString()))
        using (NpgsqlCommand myCommand = new NpgsqlCommand(strCmdText, myConnection))
        {
            myCommand.CommandTimeout = 600;

            myConnection.Open();

            myCommand.ExecuteNonQuery();

            // 写操作完成后清空查询缓存，确保缓存不与数据库不一致
            ShareClass.ClearQueryCache();
        }
    }

    // 创建数据库连接
    // 缓存数据库连接字符串，避免每次调用重复读取配置
    private static string _connectionString;
    private static readonly object _connectionStringLock = new object();

    private static string GetConnectionString()
    {
        if (_connectionString == null)
        {
            lock (_connectionStringLock)
            {
                if (_connectionString == null)
                {
                    _connectionString = ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;
                }
            }
        }
        return _connectionString;
    }

    private static NpgsqlConnection CreateConnection()
    {
        var connection = new NpgsqlConnection(GetConnectionString());
        connection.Open();
        return connection;
    }

    // 创建命令对象
    private static NpgsqlCommand CreateCommand(string sql, NpgsqlConnection connection, NpgsqlTransaction transaction, Dictionary<string, object> parameters)
    {
        var command = new NpgsqlCommand(sql, connection, transaction);

        if (parameters?.Count > 0)
        {
            foreach (var param in parameters)
            {
                // 修复：正确处理 null 值
                command.Parameters.AddWithValue(param.Key, param.Value ?? DBNull.Value);
            }
        }

        return command;
    }

    // 异常处理统一方法
    private static void HandleException(Exception ex, string sql)
    {
        LogClass.WriteLogFile($"Error page: {ex.Message}\n{ex.StackTrace}\nAn error occurred while executing the query: {ex.Message}, Sql: \n{sql}");
    }

    // 参数提取优化版本
    private static Dictionary<string, object> ExtractParametersFromSql(ref string sql)
    {
        // 快速检查：如果SQL中没有单引号，直接返回
        if (string.IsNullOrEmpty(sql) || sql.IndexOf('\'') == -1)
        {
            return null;
        }

        // 使用编译的正则表达式（静态字段，避免重复编译）
        var matches = SqlParameterRegex.Matches(sql);
        if (matches.Count == 0)
        {
            return null;
        }

        var parameters = new Dictionary<string, object>(matches.Count);
        var replacements = new List<SqlReplacement>(matches.Count);

        for (int i = 0; i < matches.Count; i++)
        {
            var match = matches[i];
            if (match.Success && match.Groups.Count >= 3)
            {
                string fieldName = match.Groups[1].Value.Trim();
                string paramValue = match.Groups[2].Value;

                // 优化：避免不必要的Trim操作
                string processedValue = ProcessMultiLineValueFast(paramValue);
                string paramName = "@autoParam" + i;

                // 修复：正确处理 null 值
                parameters[paramName] = processedValue != null ? processedValue : (object)DBNull.Value;

                replacements.Add(new SqlReplacement
                {
                    Index = match.Index,
                    Length = match.Length,
                    NewText = fieldName + " = " + paramName
                });
            }
        }

        // 执行替换
        if (replacements.Count > 0)
        {
            sql = ReplaceSqlFragments(sql, replacements);
        }

        return parameters.Count > 0 ? parameters : null;
    }

    // 编译的正则表达式，提高性能
    private static readonly System.Text.RegularExpressions.Regex SqlParameterRegex =
        new System.Text.RegularExpressions.Regex(
            @"(\w+)\s*=\s*'([\s\S]*?)'",
            System.Text.RegularExpressions.RegexOptions.Multiline |
            System.Text.RegularExpressions.RegexOptions.Compiled);

    // 优化的多行值处理方法
    private static string ProcessMultiLineValueFast(string value)
    {
        if (string.IsNullOrEmpty(value))
            return value;

        // 快速检查是否需要Trim
        int start = 0;
        int end = value.Length - 1;

        // 跳过前导空白
        while (start <= end && char.IsWhiteSpace(value[start]))
            start++;

        // 跳过尾部空白
        while (end >= start && char.IsWhiteSpace(value[end]))
            end--;

        // 如果不需要Trim，直接返回原字符串
        if (start == 0 && end == value.Length - 1)
            return value;

        // 需要Trim，创建新字符串
        return value.Substring(start, end - start + 1);
    }

    // 优化的字符串替换方法
    private static string ReplaceSqlFragments(string sql, List<SqlReplacement> replacements)
    {
        // 如果只有一个替换，直接使用Replace
        if (replacements.Count == 1)
        {
            var replacement = replacements[0];
            return sql.Remove(replacement.Index, replacement.Length)
                      .Insert(replacement.Index, replacement.NewText);
        }

        // 多个替换使用StringBuilder，从后往前替换避免索引变化
        var sqlBuilder = new System.Text.StringBuilder(sql);
        for (int i = replacements.Count - 1; i >= 0; i--)
        {
            var replacement = replacements[i];
            sqlBuilder.Remove(replacement.Index, replacement.Length);
            sqlBuilder.Insert(replacement.Index, replacement.NewText);
        }
        return sqlBuilder.ToString();
    }

    // 自定义类来存储替换信息
    private class SqlReplacement
    {
        public int Index { get; set; }
        public int Length { get; set; }
        public string NewText { get; set; }
    }

    ////SQL取得数据集
    //public static DataSet GetDataSetFromSql(string strHQL, string strTableName)
    //{
    //    NpgsqlConnection myConnection = new NpgsqlConnection(
    //      ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString);
    //    NpgsqlCommand myCommand = new NpgsqlCommand(strHQL, myConnection);
    //    myCommand.CommandTimeout = 1000;

    //    DataSet ds = new DataSet();

    //    NpgsqlDataAdapter sda = new NpgsqlDataAdapter(strHQL, myConnection);
    //    sda.SelectCommand.CommandTimeout = 1000;
    //    sda.Fill(ds, strTableName);
    //    myConnection.Close();

    //    //---保存用户操作日志到日志表-------
    //    InsertUserOperateLog(strHQL);

    //    if (myCommand != null)
    //    {
    //        myCommand.Dispose();
    //    }

    //    return ds;
    //}

    ////SQL取得数据集,执行操作日志不存入日志表
    //public static DataSet GetDataSetFromSqlNOOperateLog(string strHQL, string strTableName)
    //{
    //    NpgsqlConnection myConnection = new NpgsqlConnection(
    //      ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString);
    //    NpgsqlCommand myCommand = new NpgsqlCommand(strHQL, myConnection);
    //    myCommand.CommandTimeout = 600;

    //    DataSet ds = new DataSet();
    //    NpgsqlDataAdapter sda = new NpgsqlDataAdapter(strHQL, myConnection);
    //    sda.SelectCommand.CommandTimeout = 600;

    //    sda.Fill(ds, strTableName);

    //    myConnection.Close();

    //    if (myCommand != null)
    //    {
    //        myCommand.Dispose();
    //    }

    //    return ds;
    //}

    ////运行SQL语句
    //public static void RunSqlCommand(string strCmdText)
    //{
    //    NpgsqlConnection myConnection = new NpgsqlConnection(
    //           ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString);

    //    ///创建Command
    //    NpgsqlCommand myCommand = new NpgsqlCommand(strCmdText, myConnection);
    //    myCommand.CommandTimeout = 600;

    //    ///打开链接
    //    myConnection.Open();

    //    myCommand.ExecuteNonQuery();

    //    myConnection.Close();

    //    //---保存用户操作日志到日志表-------
    //    InsertUserOperateLog(strCmdText);

    //    if (myCommand != null)
    //    {
    //        myCommand.Dispose();
    //    }
    //}

    ////运行SQL语句,执行操作日志不存入日志表
    //public static void RunSqlCommandForNOOperateLog(string strCmdText)
    //{
    //    NpgsqlConnection myConnection = new NpgsqlConnection(
    //           ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString);

    //    ///创建Command
    //    NpgsqlCommand myCommand = new NpgsqlCommand(strCmdText, myConnection);
    //    myCommand.CommandTimeout = 600;

    //    ///打开链接
    //    myConnection.Open();

    //    myCommand.ExecuteNonQuery();

    //    myConnection.Close();

    //    if (myCommand != null)
    //    {
    //        myCommand.Dispose();
    //    }
    //}

    //运行带返回参数的存储过程
    public static void RunSQLProcedure(string pro, List<NpgsqlParameter> values, ref Hashtable htReturn)
    {
        NpgsqlConnection myConnection = null;
        NpgsqlTransaction transaction = null;

        try
        {
            // 创建连接
            myConnection = new NpgsqlConnection(
                ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString);
            myConnection.Open();

            // 开始事务
            transaction = myConnection.BeginTransaction();

            // 创建命令并关联事务
            using (NpgsqlCommand myCommand = new NpgsqlCommand(pro, myConnection, transaction))
            {
                myCommand.CommandTimeout = 600;
                myCommand.CommandType = CommandType.StoredProcedure; // 设置为存储过程

                // 添加参数
                foreach (NpgsqlParameter sp in values)
                {
                    myCommand.Parameters.Add(sp);
                }

                // 执行存储过程
                myCommand.ExecuteNonQuery();

                // 提交事务
                transaction.Commit();

                // 写操作完成后清空查询缓存，确保缓存不与数据库不一致
                ShareClass.ClearQueryCache();

                // 获取输出参数的值
                List<string> keys = new List<string>();
                foreach (string key in htReturn.Keys)
                {
                    keys.Add(key);
                }
                foreach (string key in keys)
                {
                    if (myCommand.Parameters.Contains(key))
                    {
                        htReturn[key] = myCommand.Parameters[key].Value?.ToString();
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // 回滚事务
            transaction?.Rollback();
            // 记录错误日志或抛出异常
            throw new Exception("An error occurred while executing the stored procedure.", ex);
        }
        finally
        {
            // 关闭连接
            myConnection?.Close();
            // 释放事务资源
            transaction?.Dispose();
            myConnection?.Dispose();
        }
    }


    //运行带返回参数的存储过程
    public static DataSet RunSQLProcedure(string pro, List<NpgsqlParameter> values)
    {
        DataSet ds = new DataSet();
        NpgsqlConnection myConnection = null;
        NpgsqlTransaction transaction = null;

        try
        {
            // 创建连接
            myConnection = new NpgsqlConnection(
                ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString);
            myConnection.Open();

            // 开始事务
            transaction = myConnection.BeginTransaction();

            // 创建命令并关联事务
            using (NpgsqlCommand myCommand = new NpgsqlCommand(pro, myConnection, transaction))
            {
                myCommand.CommandTimeout = 600;
                myCommand.CommandType = CommandType.StoredProcedure; // 设置为存储过程

                // 添加参数
                foreach (NpgsqlParameter sp in values)
                {
                    myCommand.Parameters.Add(sp);
                }

                // 创建数据适配器
                using (NpgsqlDataAdapter sda = new NpgsqlDataAdapter(myCommand))
                {
                    sda.SelectCommand.CommandTimeout = 600; // 设置超时时间
                    sda.Fill(ds); // 填充数据集
                }

                // 提交事务
                transaction.Commit();
            }
        }
        catch (Exception ex)
        {
            // 回滚事务
            transaction?.Rollback();
            // 记录错误日志或抛出异常
            throw new Exception("An error occurred while executing the stored procedure.", ex);
        }
        finally
        {
            // 关闭连接
            myConnection?.Close();
            // 释放事务资源
            transaction?.Dispose();
            myConnection?.Dispose();
        }

        return ds;
    }



    //保存用户操作日志到日志表
    public static void InsertUserOperateLog(string strHQL)
    {
        try
        {
            // 检查是否启用日志记录
            if (System.Configuration.ConfigurationManager.AppSettings["SaveOperateLog"] != "YES")
            {
                return;
            }

            // 检查是否为系统操作
            if (strHQL.IndexOf("BySystem") != -1)
            {
                return;
            }

            // 获取用户信息
            if (HttpContext.Current.Session["UserCode"] == null || HttpContext.Current.Session["UserName"] == null)
            {
                return;
            }

            string strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();
            string strUserName = HttpContext.Current.Session["UserName"].ToString();
            string strUserIP = HttpContext.Current.Request.UserHostAddress.Trim();

            // 转义 SQL 中的单引号
            string escapedHQL = strHQL.Replace("'", "''");

            // 使用 Task 异步执行日志插入操作
            Task.Run(() => InsertLogAsync(strUserCode, strUserName, strUserIP, escapedHQL));
        }
        catch (Exception ex)
        {
            // 记录日志插入失败的错误
            LogError("Failed to insert user operate log.", ex);
        }
    }

    private static void InsertLogAsync(string userCode, string userName, string userIP, string operateContent)
    {
        try
        {
            // 使用参数化查询避免 SQL 注入
            string strSQL = @"
            INSERT INTO T_UserOperateLog (UserCode, UserName, UserIP, OperateContent, OperateTime)
            VALUES (@UserCode, @UserName, @UserIP, @OperateContent, NOW())";

            // 创建参数列表
            var parameters = new List<NpgsqlParameter>
        {
            new NpgsqlParameter("@UserCode", userCode),
            new NpgsqlParameter("@UserName", userName),
            new NpgsqlParameter("@UserIP", userIP),
            new NpgsqlParameter("@OperateContent", operateContent)
        };

            // 执行 SQL 命令
            RunSqlCommandForNOOperateLog(strSQL, parameters);
        }
        catch (Exception ex)
        {
            // 记录日志插入失败的错误
            LogError("Failed to insert user operate log asynchronously.", ex);
        }
    }

    private static void RunSqlCommandForNOOperateLog(string sql, List<NpgsqlParameter> parameters = null)
    {
        using (var myConnection = new NpgsqlConnection(
            ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString))
        {
            myConnection.Open();

            using (var myCommand = new NpgsqlCommand(sql, myConnection))
            {
                if (parameters != null)
                {
                    myCommand.Parameters.AddRange(parameters.ToArray());
                }

                myCommand.ExecuteNonQuery();

                // 写操作完成后清空查询缓存，确保缓存不与数据库不一致
                ShareClass.ClearQueryCache();
            }
        }
    }

    private static void LogError(string message, Exception ex)
    {
        // 这里可以实现日志记录逻辑，例如写入文件、数据库或日志系统
        Console.Error.WriteLine($"[ERROR] {DateTime.Now}: {message} - {ex.Message}");
    }


    //过滤非法字符，防止注入式攻攻击
    public static bool SqlFilter(string InText)
    {
        string word = "and|exec|insert|select|delete|update|chr|mid|master|or|truncate|char|declare|join|or|;|-|+|*|%|";
        if (InText == null)
            return false;

        foreach (string i in word.Split('|'))
        {
            if ((InText.ToLower().IndexOf(i + " ") > -1) || (InText.ToLower().IndexOf(" " + i) > -1))
            {
                return true;
            }
        }
        return false;
    }

    //从EXCEL读取到数据集
    public static DataSet ExcelToDataSet(string filenameurl, string table)
    {
        string strConn;
        string extension = Path.GetExtension(filenameurl);

        if (extension.ToLower() == ".xlsx")
        {
            //2013版及以上版本导入
            strConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filenameurl + ";Extended Properties='Excel 12.0;IMEX=1'";
        }
        else
        {
            strConn = "Provider=Microsoft.Jet.OleDb.4.0;" + "data source=" + filenameurl + ";Extended Properties='Excel 8.0; HDR=YES; IMEX=1'";
        }
        OleDbConnection conn = new OleDbConnection(strConn);
        OleDbDataAdapter odda = new OleDbDataAdapter("select * from [Sheet1$]", conn);
        DataSet ds = new DataSet();
        odda.Fill(ds, table);
        return ds;
    }

    //倒出EXCEL文件
    public static void CreateExcel(string strHQL, string fileName, Page page)
    {
        int i = 0, j = 0;
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_Excel");
        DataTable dt = ds.Tables[0];

        DataGrid dg = new DataGrid();
        dg.DataSource = dt;
        dg.DataBind();
        for (i = 0; i < dg.Items.Count; i++)
        {
            for (j = 0; j < dg.Items[i].Cells.Count; j++)
            {
                dg.Items[i].Cells[j].Attributes.Add("style", "vnd.ms-excel.numberformat:@");
            }
        }

        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.Buffer = true;
        HttpContext.Current.Response.AppendHeader("Content-Disposition", "attachment;filename=" + fileName);
        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("UTF-8");
        HttpContext.Current.Response.ContentType = "application/vnd.ms-excel";
        HttpContext.Current.Response.Charset = "UTF-8";
        page.EnableViewState = false;
        System.Globalization.CultureInfo mycitrad = new System.Globalization.CultureInfo("ZH-CN", true);
        System.IO.StringWriter ostrwrite = new System.IO.StringWriter(mycitrad);
        System.Web.UI.HtmlTextWriter ohtmt = new HtmlTextWriter(ostrwrite);
        dg.RenderControl(ohtmt);
        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.Write("<meta http-equiv=\"content-type\" content=\"application/ms-excel; charset=UTF-8\"/>" + ostrwrite.ToString());
        HttpContext.Current.Response.End();
    }

    //DataGrid导出为EXCEL
    public static void DataGridExportToExecl(DataGrid dataGrid, string strTableTitle, string strFileName, DataSet ds)
    {
        dataGrid.AllowPaging = false;
        dataGrid.DataSource = ds;

        HttpContext.Current.Response.Charset = "GB2312 ";
        HttpContext.Current.Response.AppendHeader("Content-Disposition ", "attachment;filename= " + strFileName);

        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.UTF8;
        HttpContext.Current.Response.ContentType = "application/ms-excel ";

        //dataGrid.Page.EnableViewState = false;

        System.IO.StringWriter tw = new System.IO.StringWriter();

        System.Web.UI.HtmlTextWriter hw = new HtmlTextWriter(tw);

        dataGrid.RenderControl(hw);


        HttpContext.Current.Response.Write(" <form runat=server> " + strTableTitle + tw.ToString() + " </form> ");
        HttpContext.Current.Response.End();
    }


    //ModifyWebConfigDBConnectionString 修改web.config的连接数据库的字符串、平台名称和是否OEM版
    public static bool ModifyWebConfigDBConnectionStringAndSystemName(string strSiteDirectory, string NhibernateConnectionString, string SQLConnectionString, string GanttSQLConnectionString, string strDBOwerID, string strPassword, string strDBName, string strSysteName, string strSiteAppURL, string strRentProductType, string strRentProductVersionType, string strIsOEM)
    {
        try
        {
            string strDBServerName;

            string strWebConfigFile = strSiteDirectory + "\\web.config";

            System.IO.FileInfo FileInfo = new System.IO.FileInfo(strWebConfigFile);
            if (!FileInfo.Exists)
            {
                //throw new InstallException("Missing config file :" + config);
            }
            System.Xml.XmlDocument xmlDocument = new System.Xml.XmlDocument();
            xmlDocument.Load(FileInfo.FullName);

            bool FoundIt = false;

            //修改NHibernate数据库连接参数
            strDBServerName = GetDBServerName("connection.connection_string");
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["hibernate-configuration"]["session-factory"])
            {
                if (Node.Name == "property")
                {
                    if (Node.Attributes.GetNamedItem("name").Value == NhibernateConnectionString)
                    {
                        Node.InnerText = String.Format("Server={0};Database={1};User ID={2};Password={3};Enlist=true;Pooling=true;Minimum Pool Size=100;Maximum Pool Size=1024;Timeout=1000;", strDBServerName, strDBName, strDBOwerID, strPassword);
                        FoundIt = true;
                    }
                }
            }
            if (!FoundIt)
            {
                //throw new InstallException("Error when writing the config file: web.config");
            }



            //修改平台名称
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["appSettings"])
            {
                if (Node.Name == "add")
                {
                    if (Node.Attributes.GetNamedItem("key").Value == "SystemName")
                    {
                        Node.Attributes.GetNamedItem("value").Value = strSysteName;
                        FoundIt = true;
                    }
                }
            }
            if (!FoundIt)
            {
                //throw new InstallException("Error when writing the config file: web.config");
            }

            //修改平台URL
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["appSettings"])
            {
                if (Node.Name == "add")
                {
                    if (Node.Attributes.GetNamedItem("key").Value == "CurrentSite")
                    {
                        Node.Attributes.GetNamedItem("value").Value = strSiteAppURL;
                        FoundIt = true;
                    }
                }
            }
            if (!FoundIt)
            {
                //throw new InstallException("Error when writing the config file: web.config");
            }

            //修改产品类型
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["appSettings"])
            {
                if (Node.Name == "add")
                {
                    if (Node.Attributes.GetNamedItem("key").Value == "ProductType")
                    {
                        Node.Attributes.GetNamedItem("value").Value = strRentProductType;
                        FoundIt = true;
                    }
                }
            }
            if (!FoundIt)
            {
                //throw new InstallException("Error when writing the config file: web.config");
            }

            //修改产品版本
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["appSettings"])
            {
                if (Node.Name == "add")
                {
                    if (Node.Attributes.GetNamedItem("key").Value == "GroupVersion")
                    {
                        Node.Attributes.GetNamedItem("value").Value = strRentProductVersionType;
                        FoundIt = true;
                    }
                }
            }
            if (!FoundIt)
            {
                //throw new InstallException("Error when writing the config file: web.config");
            }

            //修改Identity节点ADMINISTRATOR 密码
            string strIdentityPassword = GetIdentityUserPassword();
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["system.web"])
            {
                if (Node.Name == "identity")
                {
                    Node.Attributes.GetNamedItem("password").Value = strIdentityPassword;
                    FoundIt = true;
                }
            }
            if (!FoundIt)
            {
                //throw new InstallException("Error when writing the config file: web.config");
            }

            //修改OEM版本类型
            if (strIsOEM == "YES")
            {
                foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["appSettings"])
                {
                    if (Node.Name == "add")
                    {

                        if (Node.Attributes.GetNamedItem("key").Value == "IsOEMVersion")
                        {
                            Node.Attributes.GetNamedItem("value").Value = strIsOEM;
                            FoundIt = true;
                        }

                    }
                }
                if (!FoundIt)
                {
                    //throw new InstallException("Error when writing the config file: web.config");
                }
            }
            xmlDocument.Save(FileInfo.FullName);


            //修改SQl数据库连接参数
            strDBServerName = GetDBServerName("connectionString");
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["connectionStrings"])
            {
                if (Node.Name == "add")
                {
                    if (Node.Attributes.GetNamedItem("name").Value == SQLConnectionString)
                    {
                        Node.Attributes.GetNamedItem("connectionString").Value = String.Format("Server={0};Port=5432;User Id={1};Password={2};Database={3};Pooling=true;Minimum Pool Size=100;Maximum Pool Size=1024;Timeout=1000;", strDBServerName, strDBOwerID, strPassword, strDBName);
                        FoundIt = true;

                        xmlDocument.Save(FileInfo.FullName);
                    }

                    if (Node.Attributes.GetNamedItem("name").Value == GanttSQLConnectionString)
                    {
                        Node.Attributes.GetNamedItem("connectionString").Value = String.Format("User Id={0};Password={1};Host={2};Database={3};Unicode=True;Persist Security Info=True;Initial Schema=public;", strDBOwerID, strPassword, strDBServerName, strDBName);
                        FoundIt = true;

                        xmlDocument.Save(FileInfo.FullName);
                    }
                }
            }
            if (!FoundIt)
            {
                //throw new InstallException("Error when writing the config file: web.config");
            }

            return FoundIt;
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);

            return false;
        }
    }

    //配置POSTGRESQL
    public static void ConfigPostgreSqlPGPassFile(string strDBName)
    {
        try
        {
            string strDBUser = ShareClass.GetSystemDBUser();
            string strDBPassword = ShareClass.GetSystemDBPassword();
            string strDBServer = ShareClass.GetSystemDBServer();
            string strDBServerPort = ShareClass.GetSystemDBServerPort();
            if (strDBServer == "127.0.0.1")
            {
                strDBServer = "localhost";
            }

            string strConfigString = strDBServer + ":" + strDBServerPort + ":" + strDBName + ":" + strDBUser + ":" + strDBPassword;

            WriteDataToTextFile.WriteTextFile("PGConfig", "pgpass.conf", strConfigString);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //备份OEM站点数据库
    public static void BackupOEMSiteDB(string strSiteDBName, string strBackupDBSavePath, string strBackupOperatorName)
    {
        int intResult;

        intResult = ShareClass.CreateDirectory(strBackupDBSavePath);
        if (intResult == 2)
        {
            return;
        }

        try
        {
            BackupCurrentSiteDB(strSiteDBName, strBackupDBSavePath, strBackupOperatorName, "OEM");
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //备份平台数据库
    public static int BackupCurrentSiteDB(string strDBName, string strBackupDirectory, string strBackupOperatorName, string strBackupType)
    {
        string strBackupDBName, strBackupDBSavePathName, strBackupDirectorySavePath, strAppDBServer, strAppDBPort, strAppDBPassword;
        int intResult;

        strAppDBServer = ShareClass.GetSystemDBServer();
        strAppDBPort = ShareClass.GetSystemDBServerPort();
        strAppDBPassword = ShareClass.GetSystemDBPassword();

        if (strBackupType == "OEM")
        {
            strBackupDirectorySavePath = strBackupDirectory;
        }
        else
        {
            strBackupDirectorySavePath = strBackupDirectory + "\\" + DateTime.Now.ToString("yyyyMMdd");
        }

        strBackupDBName = strDBName + DateTime.Now.ToString("yyyyMMddHHMMssff") + ".bak";
        strBackupDBSavePathName = strBackupDirectorySavePath + "\\" + strBackupDBName;

        if (strBackupDirectorySavePath != "")
        {
            intResult = ShareClass.CreateDirectory(strBackupDirectorySavePath);
            if (intResult == 2)
            {
                //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('警告，备份目录创建"+LanguageHandle.GetWord("ZZSBJC").ToString().Trim()+"')", true);
                return 2;
            }
        }
        else
        {
            //ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click", "showAlertAtMouse('" + LanguageHandle.GetWord("ZZJGBFMLBNWKJC").ToString().Trim() + "')", true);
            return -4;
        }

        //生成批处理
        string bat = string.Format("set PGPASSWORD={5}\r\necho on\r\n{0} -h {1} -p {2} -U postgres -F c -b -v -f \"{3}\" {4}",
           HttpContext.Current.Server.MapPath("PGTools") + "\\pg_dump.exe",
            strAppDBServer,
            strAppDBPort,
            strBackupDBSavePathName,
            strDBName.ToLower(),
            strAppDBPassword
            );

        System.IO.File.WriteAllText(strBackupDirectorySavePath + "\\backup.bat", bat);

        Process theProcess = new Process();
        theProcess.StartInfo.FileName = strBackupDirectorySavePath + "\\backup.bat";
        //theProcess.StartInfo.Arguments = arguments;
        theProcess.StartInfo.CreateNoWindow = true;
        theProcess.Start();//启动程序
        theProcess.WaitForExit();

        //写日志
        string strInsertBackLogHQL = string.Format(@"insert into T_BackDBLog(BackTime,BackDBUrl,UserCode,UserName,IsSucc) values(now(),'{0}','{1}','{2}',1)",
            strBackupDBSavePathName, strBackupOperatorName, strBackupOperatorName);
        ShareClass.RunSqlCommand(strInsertBackLogHQL);

        return 0;
    }

    //取得数据库备份路径
    public static string GetSystemDBBackupSaveDir()
    {
        string strDirectory = "";
        string strBackDBHQL = "select BackDBUrl,BackPeriodDay from T_BackDBPrame";
        DataSet ds = ShareClass.GetDataSetFromSql(strBackDBHQL, "strBackDBHQL");
        if (ds.Tables[0].Rows.Count == 0)
        {
            return strDirectory;
        }
        else
        {
            try
            {
                strDirectory = ds.Tables[0].Rows[0][0].ToString().Trim();
            }
            catch
            {
                strDirectory = "";
            }
        }

        return strDirectory;
    }

    //-------------从模板站点恢复数据库--------------------------------------------------------------------
    public static bool RestoreDatabaseFromTemplateDB(string strDBName, string strDBRestoreFile)
    {
        return RestoreDatabase(strDBName, strDBRestoreFile);
    }

    //-------------从OEM用户站点恢复数据库--------------------------------------------------------------------
    public static bool RestoreDatabaseFromOEMUserDB(string strDBName, string strDBRestoreFile)
    {
        return RestoreDatabase(strDBName, strDBRestoreFile);
    }

    //-------------从模板站点恢复数据库(备用）--------------------------------------------------------------------
    public static bool RestoreDatabase(string strDBName, string strDBRestoreFile)
    {
        string strAppDBPasswd, strAppDBServer, strAppDBPort;

        strAppDBPasswd = ShareClass.GetSystemDBPassword();
        strAppDBServer = ShareClass.GetSystemDBServer();
        strAppDBPort = ShareClass.GetSystemDBServerPort();

        string strDirectory = strDBRestoreFile.Substring(0, strDBRestoreFile.LastIndexOf("\\"));

        //生成批处理
        string bat = string.Format("set PGPASSWORD={0}\r\necho on\r\n{5} -h {1} -p {2} -U postgres -w -d {3} -v {4}",
            strAppDBPasswd,
            strAppDBServer,
            strAppDBPort,
            strDBName.ToLower(),
            strDBRestoreFile,
            HttpContext.Current.Server.MapPath("PGTools") + "\\pg_restore.exe");

        System.IO.File.WriteAllText(strDirectory + @"\restore.bat", bat);

        try
        {
            string strHQL;
            //判断是否存在同名数据库
            strHQL = "SELECT u.datname  FROM pg_catalog.pg_database u where u.datname='" + strDBName.ToLower() + "'";
            if (!IsExistedSqlServerInstanceOrDB(strHQL))
            {
                //create database
                strHQL = string.Format(@"create database {0} ", strDBName.ToLower());
                ShareClass.RunSqlCommand(strHQL);
            }
            Process theProcess = new Process();

            theProcess.StartInfo.FileName = strDirectory + @"\restore.bat";
            //theProcess.StartInfo.Arguments = arguments;
            theProcess.StartInfo.CreateNoWindow = true;
            theProcess.Start();//启动程序
            theProcess.WaitForExit();

            return true;
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);

            return false;
        }
    }

    //判断是否存在数据库实例或数据库
    public static bool IsExistedSqlServerInstanceOrDB(string strHQL)
    {
        try
        {
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ServerOrDBName");

            if (ds.Tables[0].Rows.Count <= 0)
            {
                return false;
            }
        }
        catch
        {
            return false;
        }

        return true;
    }

    public static void DeleteSiteDBAndDBLoginUserID(string strDBName, string strDBLoginUserID)
    {
        string strHQL;

        try
        {
            strHQL = string.Format(@"alter database {0} owner to postgres;
                 revoke all on database {0} from {1};", strDBName, strDBLoginUserID);
            ShareClass.RunSqlCommand(strHQL);

            strHQL = string.Format(@"SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = '{0}' AND pid<>pg_backend_pid();", strDBName);
            ShareClass.RunSqlCommand(strHQL);

            try
            {
                strHQL = string.Format(@"drop database if exists {0};", strDBName);
                ShareClass.RunSqlCommand(strHQL);
            }
            catch
            {
            }

            strHQL = string.Format(@"DROP OWNED BY {0};", strDBLoginUserID);
            ShareClass.RunSqlCommand(strHQL);

            strHQL = string.Format(@"DROP user {0};", strDBLoginUserID);
            ShareClass.RunSqlCommand(strHQL);
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    //取得当前数据库服务器实例名称
    public static string GetDBServerName(string strConfigKeyType)
    {
        string strConfigKeyValue;
        string[] strConnectStringList;
        string strServerNameString;
        string strDBServerName = "";

        string strWebConfigFile = HttpContext.Current.Server.MapPath("~/web.config");

        System.IO.FileInfo FileInfo = new System.IO.FileInfo(strWebConfigFile);
        if (!FileInfo.Exists)
        {
            return "";
        }
        System.Xml.XmlDocument xmlDocument = new System.Xml.XmlDocument();
        xmlDocument.Load(FileInfo.FullName);

        if (strConfigKeyType == "connection.connection_string")
        {
            //修改数据库连接参数
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["hibernate-configuration"]["session-factory"])
            {
                if (Node.Name == "property")
                {
                    if (Node.Attributes.GetNamedItem("name").Value == "connection.connection_string")
                    {
                        //strConfigKeyValue = Node.Attributes.GetNamedItem("value").Value;

                        strConfigKeyValue = Node.InnerText;

                        strConnectStringList = strConfigKeyValue.Split(";".ToCharArray());
                        strServerNameString = strConnectStringList[0];

                        strDBServerName = strServerNameString.Replace("Server=", "");
                    }
                }
            }
        }
        else
        {
            foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["connectionStrings"])
            {
                if (Node.Name == "add")
                {
                    if (Node.Attributes.GetNamedItem("name").Value == "SQLCONNECTIONSTRING")
                    {
                        strConfigKeyValue = Node.Attributes.GetNamedItem("connectionString").Value;
                        strConnectStringList = strConfigKeyValue.Split(";".ToCharArray());
                        strServerNameString = strConnectStringList[0];

                        strDBServerName = strServerNameString.Replace("Server=", "");
                    }
                }
            }
        }


        return strDBServerName.Trim();
    }

    //取得Identity节ADMINISTRATOR PASSWORD
    public static string GetIdentityUserPassword()
    {
        string strIdentityUserPassword = "";
        string strWebConfigFile = HttpContext.Current.Server.MapPath("~/web.config");

        System.IO.FileInfo FileInfo = new System.IO.FileInfo(strWebConfigFile);
        if (!FileInfo.Exists)
        {
            return "";
        }
        System.Xml.XmlDocument xmlDocument = new System.Xml.XmlDocument();
        xmlDocument.Load(FileInfo.FullName);

        //修改数据库连接参数
        foreach (System.Xml.XmlNode Node in xmlDocument["configuration"]["system.web"])
        {
            if (Node.Name == "identity")
            {
                strIdentityUserPassword = Node.Attributes.GetNamedItem("password").Value;
            }
        }

        return strIdentityUserPassword;
    }


    //取得数据库名
    public static string GetSystemDBName()
    {
        string strConnectString, strDBName;
        string[] strConnectStringList;

        strConnectString = ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;
        strConnectStringList = strConnectString.Split(";".ToCharArray());
        strDBName = strConnectStringList[4];

        strDBName = strDBName.Substring(strDBName.IndexOf("=") + 1, strDBName.Length - strDBName.IndexOf("=") - 1);

        return strDBName;
    }

    //取得数据库用户
    public static string GetSystemDBUser()
    {
        string strConnectString, strDBUser;
        string[] strConnectStringList;

        strConnectString = ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;
        strConnectStringList = strConnectString.Split(";".ToCharArray());
        strDBUser = strConnectStringList[2];

        strDBUser = strDBUser.Substring(strDBUser.IndexOf("=") + 1, strDBUser.Length - strDBUser.IndexOf("=") - 1);

        return strDBUser;
    }

    //取得数据库密码
    public static string GetSystemDBPassword()
    {
        string strConnectString, strDBPassword;
        string[] strConnectStringList;

        strConnectString = ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;
        strConnectStringList = strConnectString.Split(";".ToCharArray());
        strDBPassword = strConnectStringList[3];

        strDBPassword = strDBPassword.Substring(strDBPassword.IndexOf("=") + 1, strDBPassword.Length - strDBPassword.IndexOf("=") - 1);

        return strDBPassword;
    }

    //取得数据库服务器名称
    public static string GetSystemDBServer()
    {
        string strConnectString, strDBServer;
        string[] strConnectStringList;

        strConnectString = ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;
        strConnectStringList = strConnectString.Split(";".ToCharArray());
        strDBServer = strConnectStringList[0];

        strDBServer = strDBServer.Substring(strDBServer.IndexOf("=") + 1, strDBServer.Length - strDBServer.IndexOf("=") - 1);

        return strDBServer;
    }

    //取得数据库服务器端口
    public static string GetSystemDBServerPort()
    {
        string strConnectString, strDBServerPort;
        string[] strConnectStringList;

        strConnectString = ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;
        strConnectStringList = strConnectString.Split(";".ToCharArray());
        strDBServerPort = strConnectStringList[1];

        strDBServerPort = strDBServerPort.Substring(strDBServerPort.IndexOf("=") + 1, strDBServerPort.Length - strDBServerPort.IndexOf("=") - 1);

        return strDBServerPort;
    }

    //取得租用站点的数据库连接串
    public static string GetRentSiteConnecting(string strRentSiteDBName)
    {
        string strConnectString, strDBName;

        strConnectString = ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString;
        strDBName = ShareClass.GetSystemDBName();

        strConnectString = strConnectString.Replace("=" + strDBName, "=" + strRentSiteDBName);

        return strConnectString;
    }

    //授予租用站点用户所有权限
    public static void GanttAllPrivilegesToUser(string strRentSiteDBName, string strRentSiteUser)
    {
        string strConnectString;

        try
        {
            // 获取连接字符串
            strConnectString = GetRentSiteConnecting(strRentSiteDBName);
            using (var conn = new NpgsqlConnection(strConnectString))
            {
                conn.Open();

                // 运行 SQL 命令
                string sql = "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO " + strRentSiteUser;
                using (var cmd = new NpgsqlCommand(sql, conn))
                {
                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }


    #endregion SQL函数\XML函数\WebService调用方法

}
