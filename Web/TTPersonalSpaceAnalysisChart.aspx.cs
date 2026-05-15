using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Caching;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTPersonalSpaceAnalysisChart : System.Web.UI.Page
{
    // 使用 HttpRuntime.Cache 替代静态字典 - 内置缓存，自动内存管理和过期
    private const int CACHE_DURATION_MINUTES = 5;
    private const string HTML_CACHE_VERSION = "v3"; // 缓存版本号，代码更新时修改此值使缓存失效

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack == false)
        {
            AsyncWork();
        }
    }

    private void AsyncWork()
    {
        if (Session["UserCode"] == null || string.IsNullOrEmpty(Session["UserCode"].ToString()))
        {
            RP_ChartList.Visible = false;
            litSystemAnalystChartHTML.Visible = false;
            return;
        }

        string userCode = Session["UserCode"].ToString();
        string langCode = Session["LangCode"].ToString();
        string cacheKey = "ChartHTML_" + userCode + "_" + langCode + "_" + HTML_CACHE_VERSION;
        string sessionKey = "SystemAnalystChartHTML_" + HTML_CACHE_VERSION;
        
        bool needClearCache = Request.QueryString["clearCache"] == "1";
        
        if (Session["ClearChartCacheFlag"] != null)
        {
            string flagValue = Session["ClearChartCacheFlag"].ToString();
            if (flagValue.StartsWith(userCode + "_"))
            {
                needClearCache = true;
                Session["ClearChartCacheFlag"] = null;
            }
        }
        
        if (needClearCache)
        {
            HttpRuntime.Cache.Remove(cacheKey);
            Session.Remove(sessionKey);
        }
        
        // 优先从 HttpRuntime.Cache 获取（滑动过期）
        string cachedHtml = HttpRuntime.Cache.Get(cacheKey) as string;
        
        if (!needClearCache && !string.IsNullOrEmpty(cachedHtml))
        {
            RP_ChartList.Visible = false;
            litSystemAnalystChartHTML.Text = cachedHtml;
        }
        else if (!needClearCache && Session[sessionKey] != null)
        {
            RP_ChartList.Visible = false;
            litSystemAnalystChartHTML.Text = Session[sessionKey].ToString();
        }
        else
        {
            litSystemAnalystChartHTML.Visible = false;

            try
            {
                RP_ChartList.DataSource = ShareClass.GetSytemChartDataSet(userCode, "PersonalSpacePage");
                RP_ChartList.DataBind();

                StringWriter sw1 = new StringWriter();
                HtmlTextWriter hw1 = new HtmlTextWriter(sw1);
                RP_ChartList.RenderControl(hw1);
                string html = sw1.ToString();

                Session[sessionKey] = html;
                
                // 存入 HttpRuntime.Cache（滑动过期 5 分钟）
                HttpRuntime.Cache.Insert(
                    cacheKey,
                    html,
                    null,
                    Cache.NoAbsoluteExpiration,
                    TimeSpan.FromMinutes(CACHE_DURATION_MINUTES),
                    CacheItemPriority.Normal,
                    (key, value, reason) => LogClass.WriteLogFile("Chart HTML cache removed: " + key + ", Reason: " + reason)
                );
            }
            catch (Exception ex)
            {
                LogClass.WriteLogFile("TTPersonalSpaceAnalysisChart AsyncWork error: " + ex.Message);
                RP_ChartList.Visible = false;
            }
        }
    }

    /// <summary>
    /// 清除缓存的公共方法
    /// </summary>
    public static void ClearChartCache(string userCode)
    {
        string prefix = "ChartHTML_" + userCode + "_";
        List<string> keysToRemove = new List<string>();
        
        IDictionaryEnumerator enumerator = HttpRuntime.Cache.GetEnumerator();
        while (enumerator.MoveNext())
        {
            string key = enumerator.Key.ToString();
            if (key.StartsWith(prefix))
            {
                keysToRemove.Add(key);
            }
        }
        
        foreach (string key in keysToRemove)
        {
            HttpRuntime.Cache.Remove(key);
        }
    }
}

/// <summary>
/// 缓存项（保留用于兼容性）
/// </summary>
[Serializable]
public class ChartCacheItem
{
    public string HtmlContent { get; set; }
    public DateTime CacheTime { get; set; }
}
