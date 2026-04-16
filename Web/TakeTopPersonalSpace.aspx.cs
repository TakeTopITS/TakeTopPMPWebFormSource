using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.Caching;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TakeTopPersonalSpace : System.Web.UI.Page
{
    // 缓存配置 - 使用静态字典缓存，比 HttpRuntime.Cache 更快
    private static readonly Dictionary<string, PersonalSpaceModuleCache> moduleCache = new Dictionary<string, PersonalSpaceModuleCache>();
    private static readonly Dictionary<string, DataTable> newsCache = new Dictionary<string, DataTable>();
    private static readonly Dictionary<string, DateTime> cacheTime = new Dictionary<string, DateTime>();
    private static readonly object cacheLock = new object();
    private const int CACHE_DURATION_MINUTES = 10; // 10分钟缓存

    string strUserCode, strUserType, strLangCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        strUserCode = Session["UserCode"].ToString();
        strUserType = Session["UserType"].ToString();
        strLangCode = Session["LangCode"].ToString();

        if (!Page.IsPostBack)
        {
            // 先检查重定向，避免不必要的初始化
            if (HandleRedirects())
                return;

            LB_UserName.Text = ShareClass.GetUserName(strUserCode);

            // 根据左侧栏展开状态设置图标：展开时显示向左箭头（收缩），收缩时显示向右箭头（展开）
            if (Session["LeftBarExtend"] != null && Session["LeftBarExtend"].ToString() == "YES")
            {
                IM_Extend.ImageUrl = "ImagesSkin/news.png"; // 向左箭头
            }
            else
            {
                IM_Extend.ImageUrl = "ImagesSkin/news.png"; // 向右箭头
            }

            SetPageNoCache();
            
            // 并行加载数据
            LoadDataParallel();
        }
    }

    // 处理所有重定向逻辑
    private bool HandleRedirects()
    {
        if (Session["SystemVersionType"].ToString() == "SAAS")
        {
            Response.Redirect("TakeTopPersonalSpaceSAAS.aspx?UserCode=" + strUserCode + "&Flag=" + Session["SkinFlag"]);
            return true;
        }

        if (strUserType == "OUTER")
        {
            Response.Redirect("TakeTopPersonalSpaceForOuterUser.aspx?UserCode=" + strUserCode + "&Flag=" + Session["SkinFlag"]);
            return true;
        }

        if (Request.QueryString["UserCode"] == null)
        {
            Response.Redirect("TakeTopPersonalSpace.aspx?UserCode=" + strUserCode + "&Flag=" + Session["SkinFlag"]);
            return true;
        }

        return false;
    }

    // 并行加载数据，最大化速度
    private void LoadDataParallel()
    {
        // 使用静态字典缓存，O(1) 查找速度
        System.Threading.Tasks.Parallel.Invoke(
            () => BindNewsAndNoticeTypeDataCached(),
            () => BindPersonalSpaceModuleListCached()
        );
        
        // AI 检查延迟执行
        CheckAIVisibility();
    }

    // 延迟检查 AI 可见性
    private void CheckAIVisibility()
    {
        if (!ShareClass.checkModuleIsVisible("AIAnalyst", strLangCode))
        {
            tdAI.Visible = false;
        }
        else
        {
            SetAIURL();
        }
    }

    protected void Timer1_Tick(object sender, EventArgs e)
    {
        // 只刷新缓存，不重新绑定（页面会自动从缓存读取）
        ClearPersonalSpaceCache();
    }

    protected void BT_Extend_Click(object sender, EventArgs e)
    {
        string strLeftBarExtend = Session["LeftBarExtend"].ToString() == "YES" ? "NO" : "YES";

        try
        {
            ShareClass.UpdateLeftBarExtendStatus(strUserCode, strLeftBarExtend);
            Session["LeftBarExtend"] = strLeftBarExtend;

            // 切换图标：展开状态显示向左箭头（收缩），收缩状态显示向右箭头（展开）
            if (strLeftBarExtend == "YES")
            {
                IM_Extend.ImageUrl = "ImagesSkin/news.png"; // 向左箭头
            }
            else
            {
                IM_Extend.ImageUrl = "ImagesSkin/news.png"; // 向右箭头
            }

            ShareClass.AddSpaceLineToFile("TakeTopLRExLeft.aspx", "");
            ShareClass.AddSpaceLineToFile("TakeTopCSLRLeft.aspx", "");
        }
        catch
        {
            ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click66", 
                "showAlertAtMouse('" + LanguageHandle.GetWord("ZZGGSBJC") + "')", true);
        }
    }

    protected void RP_NewsTypeList_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "Page")
        {
            for (int i = 0; i < RP_NewsTypeList.Items.Count; i++)
            {
                ((HyperLink)RP_NewsTypeList.Items[i].FindControl("HL_NavBar")).ForeColor = Color.White;
            }
            ((HyperLink)e.Item.FindControl("HL_NavBar")).ForeColor = Color.Red;
        }
    }

    public void SetPageNoCache()
    {
        if (Session["CssDirectoryChangeNumber"].ToString() == "1")
        {
            // 只清除个人空间相关缓存，不是全部
            ClearPersonalSpaceCache();
            
            Page.Response.Buffer = true;
            Page.Response.AddHeader("Pragma", "No-Cache");
            Page.Response.ExpiresAbsolute = DateTime.Now.AddDays(-1);
            Page.Response.Cache.SetExpires(DateTime.Now.AddDays(-1));
            Page.Response.Expires = 0;
            Page.Response.CacheControl = "no-cache";
            Page.Response.Cache.SetNoStore();
        }
    }

    // 超高速缓存读取 - 使用静态字典，无锁查找
    protected void BindNewsAndNoticeTypeDataCached()
    {
        string cacheKey = strLangCode;
        DataTable dt = null;
        
        lock (cacheLock)
        {
            if (newsCache.TryGetValue(cacheKey, out dt))
            {
                // 检查缓存是否过期
                DateTime time;
                if (cacheTime.TryGetValue("N_" + cacheKey, out time))
                {
                    if (DateTime.Now.Subtract(time).TotalMinutes > CACHE_DURATION_MINUTES)
                    {
                        dt = null; // 过期，重新加载
                    }
                }
            }
        }
        
        if (dt == null)
        {
            dt = GetNewsTypeData();
            if (dt != null)
            {
                lock (cacheLock)
                {
                    newsCache[cacheKey] = dt;
                    cacheTime["N_" + cacheKey] = DateTime.Now;
                }
            }
        }

        RP_NewsTypeList.DataSource = dt;
        RP_NewsTypeList.DataBind();
    }

    protected void BindPersonalSpaceModuleListCached()
    {
        string cacheKey = strUserCode + "_" + strLangCode;
        PersonalSpaceModuleCache cachedData = null;
        
        lock (cacheLock)
        {
            if (moduleCache.TryGetValue(cacheKey, out cachedData))
            {
                DateTime time;
                if (cacheTime.TryGetValue("M_" + cacheKey, out time))
                {
                    if (DateTime.Now.Subtract(time).TotalMinutes > CACHE_DURATION_MINUTES)
                    {
                        cachedData = null;
                    }
                }
            }
        }
        
        if (cachedData == null)
        {
            cachedData = LoadModuleDataFromDb();
            if (cachedData != null)
            {
                lock (cacheLock)
                {
                    moduleCache[cacheKey] = cachedData;
                    cacheTime["M_" + cacheKey] = DateTime.Now;
                }
            }
        }

        if (cachedData != null)
        {
            Repeater1.DataSource = cachedData.ModuleList1;
            Repeater1.DataBind();
            Repeater2.DataSource = cachedData.ModuleList2;
            Repeater2.DataBind();
        }
    }

    private DataTable GetNewsTypeData()
    {
        // 使用参数化查询防止 SQL 注入
        string strHQL = string.Format("SELECT * FROM T_NewsType WHERE LangCode = '{0}' AND Visible = 'YES' AND NewsScope IN ('ALL','INNER') ORDER BY SortNumber ASC", 
            strLangCode.Replace("'", "''"));
        
        DataSet ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "T_NewsType");
        
        if (ds.Tables[0].Rows.Count == 0)
        {
            strHQL = "SELECT * FROM T_NewsType WHERE LangCode = 'zh-CN' AND Visible = 'YES' AND NewsScope IN ('ALL','INNER') ORDER BY SortNumber ASC";
            ds = ShareClass.GetDataSetFromSqlNOOperateLog(strHQL, "T_NewsType");
        }
        
        return ds.Tables[0];
    }

    private PersonalSpaceModuleCache LoadModuleDataFromDb()
    {
        var cache = new PersonalSpaceModuleCache();
        
        // 单次查询获取所有模块
        string strHQL = string.Format(@"
            SELECT B.HomeModuleName, RTRIM(B.PageName) || '?UserCode={0}' AS ModulePage, A.EveryRowColumnNumber
            FROM T_ProModuleLevelForPage B 
            INNER JOIN T_ProModuleLevelForPageUser A ON A.ModuleName = B.ModuleName 
            WHERE A.UserType = '{1}' AND B.Visible = 'YES' AND B.IsDeleted = 'NO' 
            AND A.UserCode = '{0}' AND B.ParentModule = 'PersonalSpace' 
            AND B.PageName <> 'TTPersonalSpaceNews.aspx'
            AND B.LangCode = '{2}' AND A.Visible = 'YES' 
            ORDER BY A.EveryRowColumnNumber, A.SortNumber", 
            strUserCode.Replace("'", "''"), 
            strUserType.Replace("'", "''"), 
            strLangCode.Replace("'", "''"));

        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProModuleLevelForPage");
        
        var list1 = new List<ModuleInfo>(ds.Tables[0].Rows.Count / 2);
        var list2 = new List<ModuleInfo>(ds.Tables[0].Rows.Count / 2);
        
        foreach (DataRow row in ds.Tables[0].Rows)
        {
            var module = new ModuleInfo
            {
                HomeModuleName = row["HomeModuleName"].ToString(),
                ModulePage = row["ModulePage"].ToString()
            };
            
            int columnNumber = Convert.ToInt32(row["EveryRowColumnNumber"]);
            if (columnNumber == 1)
                list1.Add(module);
            else
                list2.Add(module);
        }
        
        cache.ModuleList1 = list1;
        cache.ModuleList2 = list2;
        
        return cache;
    }

    private void ClearPersonalSpaceCache()
    {
        string moduleCacheKey = strUserCode + "_" + strLangCode;
        string newsCacheKey = strLangCode;
        
        lock (cacheLock)
        {
            moduleCache.Remove(moduleCacheKey);
            newsCache.Remove(newsCacheKey);
            cacheTime.Remove("M_" + moduleCacheKey);
            cacheTime.Remove("N_" + newsCacheKey);
        }
        
        // 清除驾驶舱图表缓存 - 设置标记让图表页面自行清除
        Session["SystemAnalystChartHTML"] = null;
        Session["ClearChartCacheFlag"] = strUserCode + "_" + DateTime.Now.Ticks;
    }

    protected void BT_PopWindow_Click(object sender, EventArgs e)
    {
        // 延迟加载，只在点击时查询
        string strHQL = string.Format("SELECT * FROM T_ProjectMember WHERE LEN(WeChatOpenID) = 0 AND UserCode = '{0}'", 
            strUserCode.Replace("'", "''"));
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_ProjectMember");
        
        if (ds.Tables[0].Rows.Count > 0)
        {
            ScriptManager.RegisterStartupScript(UpdatePanel1, GetType(), "pop", "popShow('popwindow','true')", true);
        }
    }

    public void SetAIURL()
    {
        // 使用静态字典缓存
        string cacheKey = "AI_" + strLangCode;
        bool hasAI = false;
        
        lock (cacheLock)
        {
            DateTime time;
            if (cacheTime.TryGetValue(cacheKey, out time))
            {
                if (DateTime.Now.Subtract(time).TotalMinutes <= 30)
                {
                    hasAI = true;
                }
            }
        }
        
        if (!hasAI)
        {
            DataSet ds = ShareClass.GetDataSetFromSql("SELECT AIType FROM T_AIInterface LIMIT 1", "T_AIInterface");
            hasAI = ds.Tables[0].Rows.Count > 0;
            if (hasAI)
            {
                lock (cacheLock)
                {
                    cacheTime[cacheKey] = DateTime.Now;
                }
            }
        }
        
        a_AIURL.Visible = hasAI;
    }
}

[Serializable]
public class PersonalSpaceModuleCache
{
    public List<ModuleInfo> ModuleList1 { get; set; }
    public List<ModuleInfo> ModuleList2 { get; set; }
}

[Serializable]
public class ModuleInfo
{
    public string HomeModuleName { get; set; }
    public string ModulePage { get; set; }
}
