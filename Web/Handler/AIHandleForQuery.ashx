<%@ WebHandler Language="C#" Class="AIHandlerForQuery" %>

using System;
using System.Text;
using System.Web;
using System.Net.Http;
using System.Threading.Tasks;
using System.Data;
using Newtonsoft.Json;


////后端调用示例
//string strPromptWord = "promptWord=" + "提示词";
//string strFolderSize =ShareClass.GetPostDataPage(strSiteAppURL + @"/Handler/AIHandlerForQuery.ashx?" + strPromptWord);

////前端调用示例
//async function callAIWithFetch(promptWord) {
//    try {
//        const formData = new FormData();
//        formData.append('promptWord', promptWord);

//        const response = await fetch('Handler/AIHandlerForQuery.ashx', {
//            method: 'POST',
//            body: formData
//        });

//        if (!response.ok) {
//            throw new Error(`HTTP error! status: ${response.status}`);
//        }

//        // 明确获取text格式的响应
//        const textData = await response.text();
//        console.log("原始文本响应:", textData);

//        // 尝试解析为JSON（如果实际是JSON字符串）
//        try {
//            const jsonData = JSON.parse(textData);
//            if (jsonData && jsonData.success !== undefined) {
//                return jsonData; // 如果是JSON格式
//            }
//            return textData; // 如果不是JSON格式
//        } catch (e) {
//            return textData; // 纯文本直接返回
//        }

//    } catch (error) {
//        console.error("调用AI出错:", error);
//        throw error;
//    }
//}

//// 使用示例
//async function useFetchExample() {
//    try {
//        const result = await callAIWithFetch("请帮我生成一段文本");
//        if (typeof result === 'string') {
//            // 处理纯文本结果
//            document.getElementById("result").innerText = result;
//        } else {
//            // 处理JSON结果
//            document.getElementById("result").innerText = result.result;
//        }
//    } catch (error) {
//        document.getElementById("error").innerText = error.message;
//    }
//}


public class AIHandlerForQuery : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json"; // 设置为JSON响应

        try
        {
            // 获取POST数据
            string strPromptWord = context.Request["promptWord"] ?? string.Empty;

            if (string.IsNullOrWhiteSpace(strPromptWord))
            {
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    success = false,
                    message = "查询参数不能为空"
                }));
                return;
            }

            // 同步调用异步方法
            var result = ProcessAIRequest(strPromptWord).GetAwaiter().GetResult();

            // 返回结果
            context.Response.Write(result);
        }
        catch (Exception ex)
        {
            context.Response.Write(JsonConvert.SerializeObject(new
            {
                success = false,
                message = ex.Message
            }));
        }
    }

    private async Task<object> ProcessAIRequest(string queryText)
    {
        string strAIType, strAIURL, strAIModel;

        // 从数据库获取AI配置
        string strHQL = "Select AIType,URL,Model From T_AIInterface";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

        if (ds.Tables[0].Rows.Count == 0)
        {
            return new
            {
                success = false,
                message = "未配置AI接口"
            };
        }

        strAIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim();
        strAIURL = ds.Tables[0].Rows[0]["URL"].ToString().Trim();
        strAIModel = ds.Tables[0].Rows[0]["Model"].ToString().Trim();

        if (strAIType == "Local")
        {
            // 本地API调用
            string response = await CallLocalAPI(strAIURL + "/api/generate", strAIModel, queryText);
            return new
            {
                success = true,
                result = response,
                ProjectCode = "AI_" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                ProjectName = "AI生成内容 - " + queryText.Substring(0, Math.Min(20, queryText.Length))
            };
        }
        else
        {
            return new
            {
                success = false,
                message = $"请访问外部AI服务: {strAIURL}"
            };
        }
    }

    private async Task<string> CallLocalAPI(string apiUrl, string model, string prompt)
    {
        using (HttpClient client = new HttpClient())
        {
            client.Timeout = TimeSpan.FromSeconds(30);

            var requestBody = new
            {
                model = model,
                prompt = prompt
            };

            string jsonContent = Newtonsoft.Json.JsonConvert.SerializeObject(requestBody);
            HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

            HttpResponseMessage response = await client.PostAsync(apiUrl, httpContent);

            if (response.IsSuccessStatusCode)
            {
                string jsonString = await response.Content.ReadAsStringAsync();
                dynamic result = Newtonsoft.Json.JsonConvert.DeserializeObject(jsonString);
                return result.response?.ToString() ?? jsonString;
            }
            else
            {
                LogClass.WriteLogFile($"API请求失败: {response.StatusCode}");

                throw new Exception($"API请求失败: {response.StatusCode}");
            }
        }
    }

    public bool IsReusable
    {
        get { return false; }
    }
}