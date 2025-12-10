<%@ WebHandler Language="C#" Class="DataUpdateHandler" %>

using System;
using System.Web;
using System.Web.Script.Serialization;

public class DataUpdateHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        
        string action = context.Request["action"];
        string currentVersion = context.Request["version"];
        
        switch (action)
        {
            case "check":
                CheckDataUpdates(context, currentVersion);
                break;
            default:
                ReturnNoUpdate(context);
                break;
        }
    }
    
    private void CheckDataUpdates(HttpContext context, string currentVersion)
    {
        string userCode = context.Session?["UserCode"]?.ToString();
        if (string.IsNullOrEmpty(userCode))
        {
            // 尝试从请求中获取用户代码
            userCode = context.Request.QueryString["userCode"];
            if (string.IsNullOrEmpty(userCode))
            {
                ReturnNoUpdate(context);
                return;
            }
        }
        
        string cacheKey = $"DataVersion_{userCode}";
        string latestVersion = context.Cache[cacheKey] as string;
        
        // 检查是否有更新
        if (!string.IsNullOrEmpty(latestVersion) && latestVersion != currentVersion)
        {
            var result = new
            {
                hasUpdate = true,
                newVersion = latestVersion,
                timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
            };
            
            context.Response.Write(new JavaScriptSerializer().Serialize(result));
        }
        else
        {
            ReturnNoUpdate(context);
        }
    }
    
    private void ReturnNoUpdate(HttpContext context)
    {
        var result = new { hasUpdate = false };
        context.Response.Write(new JavaScriptSerializer().Serialize(result));
    }
    
    public bool IsReusable
    {
        get { return false; }
    }
}