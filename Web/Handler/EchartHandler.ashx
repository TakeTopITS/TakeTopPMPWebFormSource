<%@ WebHandler Language="C#" Class="EchartHandler" %>

using System;
using System.Web;
using Newtonsoft.Json;

using System.Data.SqlClient;
using System.Data;
using System.Text;

using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using Npgsql;


public class EchartHandler : IHttpHandler, IRequiresSessionState
{
    // 静态缓存 - 比数据库查询快得多
    private static readonly Dictionary<string, CacheItem> _dataCache = new Dictionary<string, CacheItem>();
    private static readonly object _cacheLock = new object();
    private const int CACHE_DURATION_MINUTES = 3; // 3分钟缓存

    JavaScriptSerializer jsS = new JavaScriptSerializer();
    List<object> lists = new List<object>();
    //Series seriesObj = new Series();
    string result = "";

    public void ProcessRequest(HttpContext context)
    {
        ////获取一同发送过来的参数
        //string command = context.Request["cmd"];

        context.Response.ContentType = "text/plain";

        //用来传回去的内容
        //context.Response.Write("Hello World");

        Get_Data01(context);
    }

    public void Get_Data01(HttpContext context)
    {
        string strHQL, sql;

        string strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();
        string strLangCode = HttpContext.Current.Session["LangCode"].ToString();
        string strDepartString = HttpContext.Current.Session["DepartString"].ToString();

        string strFormType = context.Request["FormType"];
        string strChartName = context.Request["ChartName"];

        // 构建缓存键
        string cacheKey = strUserCode + "_" + strLangCode + "_" + strFormType + "_" + strChartName;

        // 1. 优先检查预加载数据（登录时计算）
        List<ShareClass.ChartPreloadData> preloadedData = HttpContext.Current.Session["PreloadedChartData"] as List<ShareClass.ChartPreloadData>;
        if (preloadedData != null)
        {
            ShareClass.ChartPreloadData matchedChart = null;
            foreach (ShareClass.ChartPreloadData item in preloadedData)
            {
                if (item.ChartName == strChartName && item.FormType == strFormType)
                {
                    matchedChart = item;
                    break;
                }
            }
            
            if (matchedChart != null && !string.IsNullOrEmpty(matchedChart.JsonData))
            {
                // 同时存入内存缓存供后续使用
                SetCachedData(cacheKey, matchedChart.JsonData);
                context.Response.Write(matchedChart.JsonData);
                return;
            }
        }

        // 2. 尝试从内存缓存获取
        string cachedResult = GetCachedData(cacheKey);
        if (!string.IsNullOrEmpty(cachedResult))
        {
            context.Response.Write(cachedResult);
            return;
        }

        // 3. 使用快速查询（30秒超时）
        DataSet ds = null;
        try
        {
            string strSqlCode = context.Request["SqlCode"].Trim();

            if (!string.IsNullOrEmpty(strSqlCode))
            {
                sql = ShareClass.UnEscape(strSqlCode);
                sql = sql.Replace("[TAKETOPUSERCODE]", strUserCode).Replace("[TAKETOPDEPARTSTRING]", strDepartString).Replace("[TAKETOPLANGCODE]", strLangCode);

                // 使用快速查询（30秒超时）
                ds = GetDataSetFast(sql, "T_Project", 30);

                if (ds != null && ds.Tables[0].Rows.Count > 0)
                {
                    lists = new List<object>();

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        if (strFormType == "Column1" || strFormType == "Bar1")
                        {
                            var obj1 = new { XName = dr["XName"], YNumber = dr["YNumber"] };
                            lists.Add(obj1);
                        }
                        else if (strFormType == "Column2" || strFormType == "Bar2")
                        {
                            var obj2 = new { XName = dr["XName"], YNumber = dr["YNumber"], ZNumber = dr["ZNumber"] };
                            lists.Add(obj2);
                        }
                        else if (strFormType == "Column3" || strFormType == "Bar3")
                        {
                            var obj3 = new { XName = dr["XName"], YNumber = dr["YNumber"], ZNumber = dr["ZNumber"], HNumber = dr["HNumber"] };
                            lists.Add(obj3);
                        }
                        else if (strFormType == "Column4" || strFormType == "Bar4")
                        {
                            var obj4 = new { XName = dr["XName"], YNumber = dr["YNumber"], ZNumber = dr["ZNumber"], HNumber = dr["HNumber"], KNumber = dr["KNumber"] };
                            lists.Add(obj4);
                        }
                        else
                        {
                            var obj = new { XName = dr["XName"], YNumber = dr["YNumber"] };
                            lists.Add(obj);
                        }
                    }

                    jsS = new JavaScriptSerializer();
                    result = jsS.Serialize(lists);

                    // 存入缓存
                    SetCachedData(cacheKey, result);

                    context.Response.Write(result);
                    return;
                }
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("EchartHandler FastQuery Error: " + err.Message.ToString());
        }

        // 4. 备用查询（从配置表获取SQL）
        try
        {
            if (strFormType == "Management")
            {
                strHQL = "Select * From T_SystemAnalystChartManagement Where ChartName = '" + strChartName + "'";
            }
            else
            {
                // 用 INNER JOIN 替代关联子查询，避免 N+1 子查询
                strHQL = "Select A.ChartName, C.SqlCode, C.ChartType From T_SystemAnalystChartRelatedUser A";
                strHQL += " INNER JOIN T_SystemAnalystChartManagement C ON C.ChartName = A.ChartName";
                strHQL += " Where A.UserCode = '" + strUserCode + "' and A.FormType = '" + strFormType + "' and A.ChartName = '" + strChartName + "'";
                strHQL += " Order By A.SortNumber ASC";
            }
            DataSet dsSqlCode = GetDataSetFast(strHQL, "T_SystemAnalystChartRelatedUser", 30);
            if (dsSqlCode != null && dsSqlCode.Tables[0].Rows.Count > 0)
            {
                sql = dsSqlCode.Tables[0].Rows[0]["SqlCode"].ToString();
                sql = sql.Replace("[TAKETOPUSERCODE]", strUserCode).Replace("[TAKETOPDEPARTSTRING]", strDepartString).Replace("[TAKETOPLANGCODE]", strLangCode);

                ds = GetDataSetFast(sql, "T_Project", 30);
                if (ds != null && ds.Tables[0].Rows.Count > 0)
                {
                    lists = new List<object>();
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        if (strFormType == "Column2" || strFormType == "Bar2")
                        {
                            var obj2 = new { XName = dr["XName"], YNumber = dr["YNumber"], ZNumber = dr["ZNumber"] };
                            lists.Add(obj2);
                        }
                        else if (strFormType == "Column3" || strFormType == "Bar3")
                        {
                            var obj3 = new { XName = dr["XName"], YNumber = dr["YNumber"], ZNumber = dr["ZNumber"], HNumber = dr["HNumber"] };
                            lists.Add(obj3);
                        }
                        else if (strFormType == "Column4" || strFormType == "Bar4")
                        {
                            var obj4 = new { XName = dr["XName"], YNumber = dr["YNumber"], ZNumber = dr["ZNumber"], HNumber = dr["HNumber"], KNumber = dr["KNumber"] };
                            lists.Add(obj4);
                        }
                        else
                        {
                            var obj = new { XName = dr["XName"], YNumber = dr["YNumber"] };
                            lists.Add(obj);
                        }
                    }

                    jsS = new JavaScriptSerializer();
                    result = jsS.Serialize(lists);

                    // 存入缓存
                    SetCachedData(cacheKey, result);

                    context.Response.Write(result);
                }
                else
                {
                    context.Response.Write("");
                }
            }
            else
            {
                context.Response.Write("");
            }
        }
        catch (Exception err)
        {
            LogClass.WriteLogFile("Error page: " + err.Message.ToString() + "\n" + err.StackTrace);
        }
    }

    /// <summary>
    /// 快速查询方法（带超时控制）
    /// </summary>
    private DataSet GetDataSetFast(string sql, string tableName, int timeoutSeconds)
    {
        DataSet dataSet = new DataSet();
        
        using (var connection = new Npgsql.NpgsqlConnection(
            System.Configuration.ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString))
        {
            connection.Open();
            using (var command = new Npgsql.NpgsqlCommand(sql, connection))
            {
                command.CommandTimeout = timeoutSeconds;
                using (var adapter = new Npgsql.NpgsqlDataAdapter(command))
                {
                    adapter.Fill(dataSet, tableName);
                }
            }
        }
        
        return dataSet;
    }

    /// <summary>
    /// 从缓存获取数据
    /// </summary>
    private string GetCachedData(string cacheKey)
    {
        lock (_cacheLock)
        {
            CacheItem item;
            if (_dataCache.TryGetValue(cacheKey, out item))
            {
                if (DateTime.Now.Subtract(item.CacheTime).TotalMinutes <= CACHE_DURATION_MINUTES)
                {
                    return item.Data;
                }
            }
        }
        return null;
    }

    /// <summary>
    /// 设置缓存数据
    /// </summary>
    private void SetCachedData(string cacheKey, string data)
    {
        lock (_cacheLock)
        {
            _dataCache[cacheKey] = new CacheItem
            {
                Data = data,
                CacheTime = DateTime.Now
            };
        }
    }

    /// <summary>
    /// 清除指定用户的缓存
    /// </summary>
    public static void ClearUserCache(string userCode)
    {
        lock (_cacheLock)
        {
            var keysToRemove = new List<string>();
            foreach (var key in _dataCache.Keys)
            {
                if (key.StartsWith(userCode + "_"))
                {
                    keysToRemove.Add(key);
                }
            }
            foreach (var key in keysToRemove)
            {
                _dataCache.Remove(key);
            }
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}

/// <summary>
/// 缓存项
/// </summary>
[Serializable]
public class CacheItem
{
    public string Data { get; set; }
    public DateTime CacheTime { get; set; }
}
