using System;
using System.Data;
using System.Web;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

/// <summary>
/// 钉钉用户同步辅助类（自动将平台用户添加到钉钉通讯录）
/// </summary>
public class DingTalkUserHelper
{
    // AccessToken 缓存
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
                       ORDER BY id LIMIT 1";  // PostgreSQL
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

    #region 根据手机号查询钉钉用户是否存在

    /// <summary>
    /// 根据手机号查询钉钉用户信息
    /// </summary>
    /// <param name="accessToken">access_token</param>
    /// <param name="mobile">手机号</param>
    /// <returns>如果存在返回用户信息，否则返回null</returns>
    private static JObject GetUserByMobile(string accessToken, string mobile)
    {
        string url = "https://oapi.dingtalk.com/topapi/v2/user/getbymobile?access_token=" + accessToken;
        var postData = new { mobile = mobile };
        string jsonData = JsonConvert.SerializeObject(postData);
        string response = HttpHelper.Post(url, jsonData);
        JObject result = JObject.Parse(response);
        int errcode = result["errcode"].Value<int>();
        if (errcode == 0)
        {
            // 存在用户
            return result["result"] as JObject;
        }
        else if (errcode == 60121) // 用户不存在
        {
            return null;
        }
        else
        {
            LogError($"根据手机号查询用户失败：{result["errmsg"]}，手机号：{mobile}");
            return null;
        }
    }

    #endregion

    #region 创建钉钉用户

    /// <summary>
    /// 创建钉钉用户
    /// </summary>
    /// <param name="accessToken">access_token</param>
    /// <param name="userCode">用户代码（作为钉钉userid）</param>
    /// <param name="userName">用户姓名</param>
    /// <param name="mobile">手机号</param>
    /// <param name="departmentId">部门ID（默认根部门1）</param>
    /// <param name="email">邮箱（可选）</param>
    /// <returns>是否成功</returns>
    private static bool CreateDingTalkUser(string accessToken, string userCode, string userName, string mobile, string departmentId = "1", string email = "")
    {
        string url = "https://oapi.dingtalk.com/topapi/v2/user/create?access_token=" + accessToken;

        var userObj = new
        {
            userid = userCode,
            name = userName,
            mobile = mobile,
            department = new long[] { long.Parse(departmentId) },
            email = email,
            // 可选字段：telephone, job_number, title 等
        };

        string jsonData = JsonConvert.SerializeObject(userObj);
        string response = HttpHelper.Post(url, jsonData);
        JObject result = JObject.Parse(response);
        int errcode = result["errcode"].Value<int>();
        if (errcode == 0)
        {
            return true;
        }
        else
        {
            LogError($"创建钉钉用户失败：{result["errmsg"]}，userCode：{userCode}");
            return false;
        }
    }

    #endregion

    #region 更新钉钉用户

    /// <summary>
    /// 更新钉钉用户信息
    /// </summary>
    /// <param name="accessToken">access_token</param>
    /// <param name="userCode">用户代码（钉钉userid）</param>
    /// <param name="userName">用户姓名</param>
    /// <param name="mobile">手机号</param>
    /// <param name="departmentId">部门ID</param>
    /// <param name="email">邮箱（可选）</param>
    /// <returns>是否成功</returns>
    private static bool UpdateDingTalkUser(string accessToken, string userCode, string userName, string mobile, string departmentId = "1", string email = "")
    {
        string url = "https://oapi.dingtalk.com/topapi/v2/user/update?access_token=" + accessToken;

        var userObj = new
        {
            userid = userCode,
            name = userName,
            mobile = mobile,
            department = new long[] { long.Parse(departmentId) },
            email = email
        };

        string jsonData = JsonConvert.SerializeObject(userObj);
        string response = HttpHelper.Post(url, jsonData);
        JObject result = JObject.Parse(response);
        int errcode = result["errcode"].Value<int>();
        if (errcode == 0)
        {
            return true;
        }
        else
        {
            LogError($"更新钉钉用户失败：{result["errmsg"]}，userCode：{userCode}");
            return false;
        }
    }

    #endregion

    #region 公共同步方法

    /// <summary>
    /// 同步平台用户信息到钉钉通讯录（如果用户不存在则创建，存在则更新）
    /// </summary>
    /// <param name="userCode">平台用户代码（将作为钉钉userid）</param>
    /// <param name="userName">用户姓名</param>
    /// <param name="mobilePhone">手机号</param>
    /// <param name="email">邮箱（可选）</param>
    /// <param name="departmentId">钉钉部门ID（默认1，可根据需要修改）</param>
    /// <returns>同步是否成功</returns>
    public static bool SyncUserToDingTalk(string userCode, string userName, string mobilePhone, string email = "", string departmentId = "1")
    {
        try
        {
            // 1. 获取钉钉配置
            DingTalkConfig config = GetDefaultDingTalkConfig();
            if (config == null)
            {
                LogError("未找到可用的钉钉配置，无法同步用户");
                return false;
            }

            // 2. 获取 access_token
            string accessToken = GetAccessToken(config.AppKey, config.AppSecret);
            if (string.IsNullOrEmpty(accessToken))
            {
                return false;
            }

            // 3. 根据手机号查询用户是否已存在
            JObject existingUser = GetUserByMobile(accessToken, mobilePhone);

            if (existingUser != null)
            {
                // 用户已存在，获取其userid
                string existingUserId = existingUser["userid"]?.Value<string>();
                if (!string.IsNullOrEmpty(existingUserId))
                {
                    // 如果已存在的userid与我们传入的userCode不一致，我们仍然更新，但可能需要考虑是否覆盖？
                    // 钉钉允许更新userid吗？不，userid不可变。所以如果手机号已关联其他userid，我们需要决定是否更新那个用户的信息。
                    // 这里我们选择：如果手机号已存在，则更新该用户的信息（使用原有的userid），同时不改变userid。
                    // 但为了保持一致性，我们可以使用传入的userCode作为目标userid，但可能不匹配。
                    // 更稳妥的做法：使用已有的userid进行更新。
                    return UpdateDingTalkUser(accessToken, existingUserId, userName, mobilePhone, departmentId, email);
                }
                else
                {
                    LogError($"根据手机号查询到用户但userid为空，无法更新");
                    return false;
                }
            }
            else
            {
                // 用户不存在，创建新用户，使用userCode作为userid
                return CreateDingTalkUser(accessToken, userCode, userName, mobilePhone, departmentId, email);
            }
        }
        catch (Exception ex)
        {
            LogError($"同步用户到钉钉异常：{ex.Message}");
            return false;
        }
    }

    #endregion

    #region 日志辅助

    private static void LogError(string msg)
    {
        System.Diagnostics.Debug.WriteLine("[钉钉用户同步] " + msg);
        // 可根据需要记录到文件或数据库
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