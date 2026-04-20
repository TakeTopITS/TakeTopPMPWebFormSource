using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTPersonalSpaceAnalysisChart : System.Web.UI.Page
{
    // 静态缓存 - 比 Session 更快，所有用户共享
    private static readonly Dictionary<string, ChartCacheItem> _chartCache = new Dictionary<string, ChartCacheItem>();
    private static readonly object _cacheLock = new object();
    private const int CACHE_DURATION_MINUTES = 5; // 5分钟缓存
    private const string HTML_CACHE_VERSION = "v2"; // 缓存版本号，代码更新时修改此值使缓存失效

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            AsyncWork();
        }
    }

    private void AsyncWork()
    {
        // Session 检查：未登录时直接返回，避免 CoreShareClass 静态初始化异常
        if (Session["UserCode"] == null || string.IsNullOrEmpty(Session["UserCode"].ToString()))
        {
            RP_ChartList.Visible = false;
            litSystemAnalystChartHTML.Visible = false;
            return;
        }

        string userCode = Session["UserCode"].ToString();
        string langCode = Session["LangCode"].ToString();
        string cacheKey = userCode + "_" + langCode + "_" + HTML_CACHE_VERSION;
        string sessionKey = "SystemAnalystChartHTML_" + HTML_CACHE_VERSION;
        
        // 检查是否需要清除缓存（前端检测到数据为空时刷新页面会带此参数）
        bool needClearCache = Request.QueryString["clearCache"] == "1";
        
        // 检查是否需要清除缓存（由个人空间页面设置）
        if (Session["ClearChartCacheFlag"] != null)
        {
            string flagValue = Session["ClearChartCacheFlag"].ToString();
            if (flagValue.StartsWith(userCode + "_"))
            {
                needClearCache = true;
                Session["ClearChartCacheFlag"] = null;
            }
        }
        
        // 如果需要清除缓存，清除静态缓存和Session缓存
        if (needClearCache)
        {
            RemoveFromCache(cacheKey);
            Session.Remove(sessionKey);
            //LogClass.WriteLogFile("TTPersonalSpaceAnalysisChart: 清除缓存并重新查询 - UserCode:" + userCode);
        }
        
        // 尝试从静态缓存获取
        string cachedHtml = GetCachedHtml(cacheKey);
        
        if (!needClearCache && !string.IsNullOrEmpty(cachedHtml))
        {
            // 使用缓存的HTML
            RP_ChartList.Visible = false;
            litSystemAnalystChartHTML.Text = cachedHtml;
        }
        else if (!needClearCache && Session[sessionKey] != null)
        {
            // 使用 Session 缓存
            RP_ChartList.Visible = false;
            litSystemAnalystChartHTML.Text = Session[sessionKey].ToString();
        }
        else
        {
            // 重新生成（从数据库查询）
            litSystemAnalystChartHTML.Visible = false;

            try
            {
                // 绑定第一个Repeater
                RP_ChartList.DataSource = ShareClass.GetSytemChartDataSet(userCode, "PersonalSpacePage");
                RP_ChartList.DataBind();

                // 将第一个Repeater的HTML内容存储
                StringWriter sw1 = new StringWriter();
                HtmlTextWriter hw1 = new HtmlTextWriter(sw1);
                RP_ChartList.RenderControl(hw1);
                string html = sw1.ToString();

                // 同时存入 Session 和静态缓存
                Session[sessionKey] = html;
                SetCachedHtml(cacheKey, html);
            }
            catch (Exception ex)
            {
                LogClass.WriteLogFile("TTPersonalSpaceAnalysisChart AsyncWork error: " + ex.Message);
                RP_ChartList.Visible = false;
            }
        }
    }

    /// <summary>
    /// 从静态缓存获取HTML
    /// </summary>
    private string GetCachedHtml(string cacheKey)
    {
        lock (_cacheLock)
        {
            ChartCacheItem item;
            if (_chartCache.TryGetValue(cacheKey, out item))
            {
                if (DateTime.Now.Subtract(item.CacheTime).TotalMinutes <= CACHE_DURATION_MINUTES)
                {
                    return item.HtmlContent;
                }
            }
        }
        return null;
    }

    /// <summary>
    /// 设置静态缓存
    /// </summary>
    private void SetCachedHtml(string cacheKey, string html)
    {
        lock (_cacheLock)
        {
            _chartCache[cacheKey] = new ChartCacheItem
            {
                HtmlContent = html,
                CacheTime = DateTime.Now
            };
        }
    }

    /// <summary>
    /// 从缓存中移除指定键
    /// </summary>
    private void RemoveFromCache(string cacheKey)
    {
        lock (_cacheLock)
        {
            _chartCache.Remove(cacheKey);
        }
    }

    /// <summary>
    /// 清除缓存的公共方法
    /// </summary>
    public static void ClearChartCache(string userCode)
    {
        lock (_cacheLock)
        {
            List<string> keysToRemove = new List<string>();
            foreach (string key in _chartCache.Keys)
            {
                if (key.StartsWith(userCode + "_"))
                {
                    keysToRemove.Add(key);
                }
            }
            foreach (string key in keysToRemove)
            {
                _chartCache.Remove(key);
            }
        }
    }
}

/// <summary>
/// 缓存项
/// </summary>
[Serializable]
public class ChartCacheItem
{
    public string HtmlContent { get; set; }
    public DateTime CacheTime { get; set; }
}
