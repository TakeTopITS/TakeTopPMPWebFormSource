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
/// Summary description for ShareClass
/// </summary>
public static partial class ShareClass
{
    static ShareClass()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static string SystemVersionID = "V2026.9.3";

    public static string SystemLatestLoginUser = "";
    public static string SystemDBer = "";
    public static DateTime systemStartupTime = DateTime.Now;

    private const int CHART_CACHE_MINUTES = 5;

    // 使用 HttpRuntime.Cache 进行图表配置缓存（滑动过期，自动内存管理）
    private static void SetChartCache(string cacheKey, DataSet ds)
    {
        HttpRuntime.Cache.Insert(
            cacheKey,
            ds,
            null,
            Cache.NoAbsoluteExpiration,
            TimeSpan.FromMinutes(CHART_CACHE_MINUTES),
            CacheItemPriority.Normal,
            new CacheItemRemovedCallback(OnChartCacheRemoved)
        );
    }

    private static void OnChartCacheRemoved(string key, object value, CacheItemRemovedReason reason)
    {
        try
        {
            LogClass.WriteLogFile("Chart cache removed: " + key + ", Reason: " + reason);
        }
        catch { }
    }

    private static DataSet GetChartCache(string cacheKey)
    {
        return HttpRuntime.Cache.Get(cacheKey) as DataSet;
    }

    private static void RemoveChartCache(string cacheKey)
    {
        HttpRuntime.Cache.Remove(cacheKey);
    }

    // ===== 只读查询结果缓存 =====
    // 缓存键前缀：所有通过 GetDataSetFromSqlCached 缓存的数据集统一使用该前缀。
    // 任何写操作（RunSqlCommandInternal）提交后都会调用 ClearQueryCache() 清空这些缓存，
    // 因此不会读取到脏数据（写完成后立即失效，下次查询重新查库）。
    private const string QUERY_CACHE_PREFIX = "TTQueryCache_";

    // 根据 SQL 文本生成稳定的缓存键（区分大小写、忽略空白，避免同一查询不同缩进产生多个缓存）
    private static string BuildQueryCacheKey(string sql)
    {
        string normalized = System.Text.RegularExpressions.Regex.Replace(sql, @"\s+", " ");
        int hash = normalized.GetHashCode();
        return QUERY_CACHE_PREFIX + hash.ToString("X8");
    }

    // 获取只读查询数据集，优先从缓存读取，未命中则查库并缓存。
    // 过期策略：绝对过期（minutes 分钟后失效），且任何写操作后缓存被全局清除。
    /// <param name="sql">只读 SQL</param>
    /// <param name="tableName">表名（DataSet 表名）</param>
    /// <param name="minutes">缓存有效分钟数</param>
    public static DataSet GetDataSetFromSqlCached(string sql, string tableName, int minutes)
    {
        DataSet cached = HttpRuntime.Cache.Get(BuildQueryCacheKey(sql)) as DataSet;
        if (cached != null)
        {
            return cached;
        }

        DataSet ds = GetDataSetFromSql(sql, tableName);

        HttpRuntime.Cache.Insert(
            BuildQueryCacheKey(sql),
            ds,
            null,
            DateTime.Now.AddMinutes(minutes),
            Cache.NoSlidingExpiration,
            CacheItemPriority.Normal,
            null);

        return ds;
    }

    // 清空所有查询缓存（写操作后调用，保证缓存不与数据不一致）
    public static void ClearQueryCache()
    {
        var enumerator = HttpRuntime.Cache.GetEnumerator();
        var keys = new System.Collections.ArrayList();
        while (enumerator.MoveNext())
        {
            string key = enumerator.Key as string;
            if (key != null && key.StartsWith(QUERY_CACHE_PREFIX, StringComparison.Ordinal))
            {
                keys.Add(key);
            }
        }
        foreach (string key in keys)
        {
            HttpRuntime.Cache.Remove(key);
        }
    }

}
