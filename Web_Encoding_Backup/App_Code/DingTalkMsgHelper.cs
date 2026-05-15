using System;
using System.Data;
using System.Web;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

/// <summary>
/// 钉钉消息发送辅助类（实时根据手机号获取UserId）
/// </summary>
public class DingTalkMsgHelper
{
    // AccessToken 缓存（应用级别）
    private static string _accessToken = "";
    private static DateTime _tokenExpireTime = DateTime.MinValue;

    #region 钉钉配置获取（从 t_dingtalkconfig 表读取）

    /// <summary>
    /// 获取默认的钉钉配置（取第一个启用的企业内部应用）
    /// </summary>
    private static DingTalkConfig GetDefaultDingTalkConfig()
    {
        string sql = @"SELECT id, configname, appkey, appsecret, agentid, corpid, robotcode, apptype 
                       FROM t_dingtalkconfig 
                       WHERE isenabled = TRUE AND apptype = 1 
                       ORDER BY id LIMIT 1";  // PostgreSQL 语法
        // SQL Server 请替换为：
        // string sql = @"SELECT TOP 1 id, configname, appkey, appsecret, agentid, corpid, robotcode, apptype 
        //                FROM t_dingtalkconfig 
        //                WHERE isenabled = 1 AND apptype = 1 
        //                ORDER BY id";

        DataSet ds = ShareClass.GetDataSetFromSql(sql, "Config");
        if (ds != null && ds.Tables[0].Rows.Count > 0)
        {
            DataRow row = ds.Tables[0].Rows[0];
            return new DingTalkConfig
            {
                Id = Convert.ToInt32(row["id"]),
                ConfigName = row["configname"].ToString(),
                AppKey = row["appkey"].ToString(),
                AppSecret = row["appsecret"].ToString(),
                AgentId = row["agentid"]?.ToString(),
                CorpId = row["corpid"]?.ToString(),
                RobotCode = row["robotcode"]?.ToString(),
                AppType = Convert.ToInt32(row["apptype"])
            };
        }
        return null;
    }

    #endregion

    #region AccessToken 获取（带缓存）

    /// <summary>
    /// 获取钉钉 access_token
    /// </summary>
    private static string GetAccessToken(string appKey, string appSecret)
    {
        // 如果 token 还在有效期内（提前5分钟失效），直接返回缓存
        if (!string.IsNullOrEmpty(_accessToken) && DateTime.Now < _tokenExpireTime.AddMinutes(-5))
        {
            return _accessToken;
        }

        string url = $"https://oapi.dingtalk.com/gettoken?appkey={appKey}&appsecret={appSecret}";
        string response = HttpHelper.Get(url);
        JObject result = JObject.Parse(response);
        int errcode = result["errcode"].Value<int>();
        if (errcode == 0)
        {
            _accessToken = result["access_token"].Value<string>();
            int expiresIn = result["expires_in"].Value<int>(); // 一般为7200秒
            _tokenExpireTime = DateTime.Now.AddSeconds(expiresIn);
            return _accessToken;
        }
        else
        {
            LogError($"获取AccessToken失败：{result["errmsg"]}");
            _accessToken = "";
            _tokenExpireTime = DateTime.MinValue;
            return null;
        }
    }

    #endregion

    #region 根据手机号获取钉钉UserId

    /// <summary>
    /// 根据手机号获取钉钉UserId（实时调用钉钉接口）
    /// </summary>
    /// <param name="phone">手机号</param>
    /// <returns>钉钉UserId，若失败返回null</returns>
    public static string GetUserIdByPhone(string phone)
    {
        try
        {
            // 获取配置和token
            DingTalkConfig config = GetDefaultDingTalkConfig();
            if (config == null)
            {
                LogError("未找到可用的钉钉配置");
                return null;
            }

            string accessToken = GetAccessToken(config.AppKey, config.AppSecret);
            if (string.IsNullOrEmpty(accessToken)) return null;

            // 调用钉钉接口：根据手机号获取userId
            string url = "https://oapi.dingtalk.com/topapi/v2/user/getbymobile?access_token=" + accessToken;
            var postData = new { mobile = phone };
            string jsonData = JsonConvert.SerializeObject(postData);
            string response = HttpHelper.Post(url, jsonData);

            JObject result = JObject.Parse(response);
            int errcode = result["errcode"].Value<int>();
            if (errcode == 0)
            {
                string userId = result["result"]["userid"].Value<string>();
                return userId;
            }
            else
            {
                LogError($"根据手机号获取UserId失败：{result["errmsg"]}，手机号：{phone}");
                return null;
            }
        }
        catch (Exception ex)
        {
            LogError($"根据手机号获取UserId异常：{ex.Message}");
            return null;
        }
    }

    #endregion

    #region 发送文本消息

    /// <summary>
    /// 发送文本消息给钉钉用户（企业内部应用工作通知）
    /// </summary>
    /// <param name="userId">钉钉用户的 userid（单个）</param>
    /// <param name="text">消息内容</param>
    /// <returns>是否发送成功</returns>
    public static bool SendTextMessage(string userId, string text)
    {
        try
        {
            // 1. 获取钉钉配置
            DingTalkConfig config = GetDefaultDingTalkConfig();
            if (config == null)
            {
                LogError("未找到可用的钉钉配置");
                return false;
            }

            // 2. 获取 access_token
            string accessToken = GetAccessToken(config.AppKey, config.AppSecret);
            if (string.IsNullOrEmpty(accessToken)) return false;

            // 3. 构造消息体
            var msgObj = new
            {
                agent_id = config.AgentId,
                userid_list = userId,  // 单个userId，也可用逗号分隔多个
                msg = new
                {
                    msgtype = "text",
                    text = new { content = text }
                }
            };
            string jsonData = JsonConvert.SerializeObject(msgObj);

            // 4. 调用钉钉接口
            string url = "https://oapi.dingtalk.com/topapi/message/corpconversation/asyncsend_v2?access_token=" + accessToken;
            string response = HttpHelper.Post(url, jsonData);

            // 5. 解析返回结果
            JObject result = JObject.Parse(response);
            int errcode = result["errcode"].Value<int>();
            if (errcode == 0)
            {
                return true;
            }
            else
            {
                LogError($"钉钉消息发送失败：{result["errmsg"]}，userId：{userId}");
                return false;
            }
        }
        catch (Exception ex)
        {
            LogError($"钉钉消息发送异常：{ex.Message}");
            return false;
        }
    }

    #endregion

    #region 日志辅助（可根据项目实际日志工具替换）

    private static void LogError(string msg)
    {
        // 示例：输出到调试窗口，请根据项目情况替换为 log4net 或写入文件
        System.Diagnostics.Debug.WriteLine("[钉钉错误] " + msg);
        // 也可以使用 HttpContext.Current.Response.Write 在调试时查看
    }

    #endregion

    #region 钉钉配置实体类

    private class DingTalkConfig
    {
        public int Id { get; set; }
        public string ConfigName { get; set; }
        public string AppKey { get; set; }
        public string AppSecret { get; set; }
        public string AgentId { get; set; }
        public string CorpId { get; set; }
        public string RobotCode { get; set; }
        public int AppType { get; set; }
    }

    #endregion
}