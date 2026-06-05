using Newtonsoft.Json;

using System;
using System.Data;
using System.Net.Http;
using System.Text;
using System.Web.UI;

/// <summary>
/// TTAppAIHandlerByDeepSeek - Mobile APP AI Smart Chat
/// Backend code referenced from TTAIHandlerByDeepSeek.aspx.cs chat section
/// </summary>
public partial class TTAppAIHandlerByDeepSeek : System.Web.UI.Page
{
    private bool _aiServerAvailable = false;
    string strUserCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        // CKEditor init
        CKFinder.FileBrowser _FileBrowser = new CKFinder.FileBrowser();
        _FileBrowser.BasePath = "ckfinder/";
        Session["PageName"] = "CommonPage";
        _FileBrowser.SetupCKEditor(lblGeneratedText);
        lblGeneratedText.Language = Session["LangCode"].ToString();

        strUserCode = Session["UserCode"].ToString();

        if (!IsPostBack)
        {
            txtPrompt.Focus();
        }

        // Check AI server status on every request
        _aiServerAvailable = CheckAIServerAvailable();
        UpdateAIServerStatusDisplay();
    }

    private void UpdateAIServerStatusDisplay()
    {
        if (_aiServerAvailable)
        {
            aiServerStatusContainer.Visible = false;
        }
        else
        {
            aiServerStatusContainer.Visible = true;
            aiServerStatusContainer.Attributes["class"] = "aiw-server-error";
            lblAIServerStatus.Text = LanguageHandle.GetWord("DSeekNoValidAIServer");
        }
    }

    private bool CheckAIServerAvailable()
    {
        try
        {
            string strHQL = "Select AIType, URL, AIKey, Model From T_AIInterface Where InUse = 'YES' ";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

            if (ds.Tables[0].Rows.Count == 0)
                return false;

            string strAIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim();
            string strAIURL = ds.Tables[0].Rows[0]["URL"].ToString().Trim();
            string strAIModel = ds.Tables[0].Rows[0]["Model"].ToString().Trim();

            if (strAIType == "Local" || strAIType == "Outer")
                return !string.IsNullOrEmpty(strAIURL) && !string.IsNullOrEmpty(strAIModel);
            else
                return false;
        }
        catch
        {
            return false;
        }
    }

    protected void btnGenerateText_Click(object sender, EventArgs e)
    {
        if (!_aiServerAvailable)
        {
            lblGeneratedText.Text = LanguageHandle.GetWord("DSeekAIServerNotAvailable");
            return;
        }

        string apiUrl, result;
        string strAIType, strAIURL, strAIKey;
        string strHQL;

        lblGeneratedText.Text = "";

        if (txtPrompt.Text.Trim() == "")
        {
            lblGeneratedText.Text = LanguageHandle.GetWord("DSeekPromptCantBeEmpty");
            return;
        }

        try
        {
            strHQL = "Select AIType, URL, AIKey, Model From T_AIInterface Where InUse = 'YES' ";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strAIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim();
                strAIURL = ds.Tables[0].Rows[0]["URL"].ToString().Trim();
                strAIKey = ds.Tables[0].Rows[0]["AIKey"].ToString().Trim();

                apiUrl = strAIURL;

                if (strAIType == "Local")
                    result = CallOllamaAPI(apiUrl);
                else if (strAIType == "Outer")
                    result = CallExternalAIAPI(apiUrl, strAIKey);
                else
                    result = LanguageHandle.GetWord("DSeekUnsupportedAIType");

                lblGeneratedText.Text = result;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "ajustHeight", "window.open('https://www.deepseek.com');", true);
            }
        }
        catch (Exception ex)
        {
            lblGeneratedText.Text = ex.Message;
        }
    }

    private string CallOllamaAPI(string apiUrl)
    {
        string strAIModel;
        string strHQL;

        try
        {
            strHQL = "Select Model From T_AIInterface Where InUse = 'YES'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strAIModel = ds.Tables[0].Rows[0]["Model"].ToString().Trim();

                using (HttpClient client = new HttpClient())
                {
                    client.Timeout = TimeSpan.FromSeconds(300);

                    var requestBody = new
                    {
                        model = strAIModel,
                        messages = new[]
                        {
                            new { role = "user", content = txtPrompt.Text }
                        },
                        stream = false,
                        temperature = 0.7,
                        max_tokens = 2000
                    };

                    string jsonContent = JsonConvert.SerializeObject(requestBody);
                    HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                    HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

                    return ProcessAIResponse(response, "Ollama");
                }
            }
            else
            {
                return LanguageHandle.GetWord("DSeekNoAIConfigurationFound");
            }
        }
        catch (Exception ex)
        {
            return LanguageHandle.GetWord("DSeekError") + $"{ex.Message}";
        }
    }

    private string CallExternalAIAPI(string apiUrl, string apiKey)
    {
        string strAIModel;
        string strHQL;

        try
        {
            strHQL = "Select Model From T_AIInterface Where InUse = 'YES'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strAIModel = ds.Tables[0].Rows[0]["Model"].ToString().Trim();

                using (HttpClient client = new HttpClient())
                {
                    client.Timeout = TimeSpan.FromSeconds(300);

                    if (!string.IsNullOrEmpty(apiKey))
                        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");

                    var requestBody = new
                    {
                        model = strAIModel,
                        messages = new[]
                        {
                            new { role = "user", content = txtPrompt.Text }
                        },
                        stream = false,
                        temperature = 0.7,
                        max_tokens = 2000
                    };

                    string jsonContent = JsonConvert.SerializeObject(requestBody);
                    HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                    HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

                    return ProcessAIResponse(response, "External");
                }
            }
            else
            {
                return LanguageHandle.GetWord("DSeekNoAIConfigurationFound");
            }
        }
        catch (Exception ex)
        {
            return LanguageHandle.GetWord("DSeekError") + $"{ex.Message}";
        }
    }

    private string ProcessAIResponse(HttpResponseMessage response, string aiType)
    {
        if (response.IsSuccessStatusCode)
        {
            string jsonString = response.Content.ReadAsStringAsync().Result;

            jsonString = CleanJsonString(jsonString);

            dynamic responseData = JsonConvert.DeserializeObject(jsonString);

            string result = "";

            if (responseData.choices != null && responseData.choices.Count > 0 &&
                responseData.choices[0].message != null &&
                responseData.choices[0].message.content != null)
            {
                result = responseData.choices[0].message.content.ToString();
            }
            else if (responseData.response != null)
            {
                result = responseData.response.ToString();
            }
            else if (responseData.content != null)
            {
                result = responseData.content.ToString();
            }
            else
            {
                result = LanguageHandle.GetWord("DSeekCouldNotParseResponseFromAI");
            }

            result = CleanAndFormatResult(result);
            return result;
        }
        else
        {
            string errorContent = response.Content.ReadAsStringAsync().Result;
            return LanguageHandle.GetWord("DSeekAPICallFailedWithStatus") +
                   $"{response.StatusCode}. " +
                   LanguageHandle.GetWord("DSeekResponse") +
                   $"{errorContent}";
        }
    }

    private string CleanJsonString(string jsonString)
    {
        if (string.IsNullOrEmpty(jsonString))
            return jsonString;

        return jsonString.Replace("\\u003cthink\\u003e", "")
                         .Replace("\\u003c/think\\u003e", "")
                         .Replace("<think>", "")
                         .Replace("</think>", "");
    }

    private string CleanAndFormatResult(string result)
    {
        if (string.IsNullOrEmpty(result))
            return result;

        result = result.Replace("***", "")
                       .Replace("**", "")
                       .Replace("###", "")
                       .Replace("##", "");

        result = result.Replace("\n", "<br>")
                       .Replace("\r\n", "<br>");

        return result;
    }

    protected void btnStopAI_Click(object sender, EventArgs e)
    {
    }
}
