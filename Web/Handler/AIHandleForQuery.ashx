<%@ WebHandler Language="C#" Class="AIHandlerForQuery" %>

using System;
using System.Text;
using System.Web;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;


public class AIHandlerForQuery : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain; charset=utf-8";

        try
        {
            string strPromptWord = context.Request["promptWord"] ?? string.Empty;

            if (string.IsNullOrWhiteSpace(strPromptWord))
            {
                context.Response.Write("请输入问题");
                return;
            }

            var result = ProcessAIRequest(strPromptWord).GetAwaiter().GetResult();
            context.Response.Write(result);
        }
        catch (Exception ex)
        {
            context.Response.Write("AI 调用失败: " + ex.Message);
        }
    }

    private async Task<string> ProcessAIRequest(string queryText)
    {
        string strHQL = "Select AIType,URL,AIKey,Model From T_AIInterface Where InUse = 'YES'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

        if (ds.Tables[0].Rows.Count == 0)
        {
            return "未配置AI接口，请在 AI 服务器配置中添加可用的 AI 服务。";
        }

        var r = ds.Tables[0].Rows[0];
        string aiType = r["AIType"].ToString().Trim();
        string aiUrl = r["URL"].ToString().Trim();
        string aiKey = r["AIKey"].ToString().Trim();
        string aiModel = r["Model"].ToString().Trim();

        using (HttpClient client = new HttpClient())
        {
            client.Timeout = TimeSpan.FromSeconds(300);

            if (aiType == "Outer" && !string.IsNullOrWhiteSpace(aiKey))
            {
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " + aiKey);
            }

            // 使用 OpenAI 兼容格式（DeepSeek / Ollama 新版均支持）
            var body = new
            {
                model = aiModel,
                messages = new[] { new { role = "user", content = queryText } },
                stream = false,
                temperature = 0.7,
                max_tokens = 2000
            };

            string jsonBody = JsonConvert.SerializeObject(body);
            HttpContent content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

            HttpResponseMessage response = await client.PostAsync(aiUrl, content);

            if (response.IsSuccessStatusCode)
            {
                string jsonString = await response.Content.ReadAsStringAsync();
                try
                {
                    JObject obj = JObject.Parse(jsonString);
                    // OpenAI 格式: choices[0].message.content
                    if (obj["choices"] != null && obj["choices"].HasValues)
                    {
                        var msg = obj["choices"][0]["message"];
                        if (msg != null && msg["content"] != null)
                            return msg["content"].ToString();
                    }
                    // Ollama 格式: response
                    if (obj["response"] != null)
                        return obj["response"].ToString();
                    // 直接 content
                    if (obj["content"] != null)
                        return obj["content"].ToString();

                    return jsonString;
                }
                catch
                {
                    return jsonString;
                }
            }
            else
            {
                string err = await response.Content.ReadAsStringAsync();
                LogClass.WriteLogFile("AI API error: " + response.StatusCode + " - " + err);
                return "AI 服务返回错误 (HTTP " + (int)response.StatusCode + ")";
            }
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}
