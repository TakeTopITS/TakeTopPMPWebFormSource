using Newtonsoft.Json;

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTAIHandlerByDeepSeek : System.Web.UI.Page
{
    // Store analysis results
    private class AnalysisResult
    {
        public string Summary { get; set; }
        public string Insights { get; set; }
        public List<string> Queries { get; set; } = new List<string>();
        public string Recommendations { get; set; }
        public string Error { get; set; }
    }

    // 新增：AI服务器状态
    private bool _aiServerAvailable = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        // CKEditor initialization
        CKFinder.FileBrowser _FileBrowser = new CKFinder.FileBrowser();
        _FileBrowser.BasePath = "ckfinder/";
        Session["PageName"] = "CommonPage";
        _FileBrowser.SetupCKEditor(lblGeneratedText);
        lblGeneratedText.Language = Session["LangCode"].ToString();

        if (!IsPostBack)
        {
            // Load configuration and check AI server
            LoadConfig();

            // 新增：检查AI服务器状态
            _aiServerAvailable = CheckAIServerAvailable();

            // 更新服务器状态显示
            UpdateAIServerStatusDisplay();

            txtPrompt.Focus();
        }
    }

    // 新增：更新AI服务器状态显示
    private void UpdateAIServerStatusDisplay()
    {
        if (_aiServerAvailable)
        {
            // AI服务器可用，显示成功状态
            aiServerStatusContainer.Visible = true;
            aiServerStatusContainer.Attributes["class"] = "ai-server-status success";
            lblAIServerStatus.Text = LanguageHandle.GetWord("DSeekAIServerAvailable");
        }
        else
        {
            // AI服务器不可用，显示错误状态
            aiServerStatusContainer.Visible = true;
            aiServerStatusContainer.Attributes["class"] = "ai-server-status error";
            lblAIServerStatus.Text = LanguageHandle.GetWord("DSeekNoValidAIServer");
        }
    }

    // 新增：检查AI服务器是否可用
    private bool CheckAIServerAvailable()
    {
        try
        {
            // 1. 从数据库获取配置
            string strHQL = "Select AIType, URL, Model From T_AIInterface";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

            if (ds.Tables[0].Rows.Count == 0)
            {
                return false; // 没有配置
            }

            string strAIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim();
            string strAIURL = ds.Tables[0].Rows[0]["URL"].ToString().Trim();
            string strAIModel = ds.Tables[0].Rows[0]["Model"].ToString().Trim();

            if (strAIType != "Local")
            {
                return false; // 只支持本地模式
            }

            // 2. 测试Ollama服务器连接
            return TestOllamaConnection(strAIURL, strAIModel);
        }
        catch
        {
            return false;
        }
    }

    // 新增：测试Ollama连接
    private bool TestOllamaConnection(string apiUrl, string aiModel)
    {
        try
        {
            using (HttpClient client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(10); // 较短的超时时间用于测试

                // 测试OpenAI兼容接口
                var testRequestBody = new
                {
                    model = aiModel, // 使用实际配置的模型名
                    messages = new[]
                    {
                        new { role = "user", content = "test" }
                    },
                    max_tokens = 1,
                    stream = false
                };

                string jsonContent = JsonConvert.SerializeObject(testRequestBody);
                HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                var response = client.PostAsync(apiUrl, httpContent).Result;

                // 只要服务器响应（即使是错误），就说明服务器存在
                return response != null;
            }
        }
        catch (HttpRequestException httpEx)
        {
            // HTTP请求异常，可能是服务器不存在
            return false;
        }
        catch (TaskCanceledException)
        {
            // 超时，服务器可能未响应
            return false;
        }
        catch
        {
            // 其他异常
            return false;
        }
    }

    // Load configuration
    private void LoadConfig()
    {
        try
        {
            // Load DeepSeek configuration
            string strHQL = "Select AIType, URL, Model From T_AIInterface";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtDeepSeekApi.Text = ds.Tables[0].Rows[0]["URL"].ToString().Trim();
                txtModel.Text = ds.Tables[0].Rows[0]["Model"].ToString().Trim();
            }
            else
            {
                // 修改：使用正确的Ollama OpenAI兼容接口
                txtDeepSeekApi.Text = "http://localhost:11434/v1/chat/completions";
                txtModel.Text = "deepseek-r1:1.5b"; // 请根据实际安装的模型修改
            }
        }
        catch
        {
            // 修改：使用正确的Ollama OpenAI兼容接口
            txtDeepSeekApi.Text = "http://localhost:11434/v1/chat/completions";
            txtModel.Text = "deepseek-r1:1.5b"; // 请根据实际安装的模型修改
        }
    }

    // ==================== Original Functionality ====================

    protected void BT_Simple_Click(object sender, EventArgs e)
    {
        // 检查AI服务器
        if (!_aiServerAvailable)
        {
            // 不需要弹出窗口，状态已经在页面顶端显示
        }

        divDataAnalysisMode.Visible = false;
        divSimpleMode.Visible = true;

        // Set button active state
        BT_Simple.CssClass = "mode-button active";
        BT_DataAnalysis.CssClass = "mode-button";
    }

    protected void BT_DataAnalysis_Click(object sender, EventArgs e)
    {
        // 检查AI服务器
        if (!_aiServerAvailable)
        {
            // 不需要弹出窗口，状态已经在页面顶端显示
        }

        divDataAnalysisMode.Visible = true;
        divSimpleMode.Visible = false;

        // Set button active state
        BT_DataAnalysis.CssClass = "mode-button active";
        BT_Simple.CssClass = "mode-button";
    }

    protected void btnGenerateText_Click(object sender, EventArgs e)
    {
        // 检查AI服务器
        if (!_aiServerAvailable)
        {
            lblGeneratedText.Text = LanguageHandle.GetWord("DSeekAIServerNotAvailable");
            return;
        }

        string localApiUrl, result;
        string strAIType, strAIURL;

        string strHQL;

        lblGeneratedText.Text = "";

        if (txtPrompt.Text.Trim() == "")
        {
            lblGeneratedText.Text = LanguageHandle.GetWord("DSeekPromptCantBeEmpty");
            return;
        }

        try
        {
            strHQL = "Select AIType,URL,Model From T_AIInterface";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strAIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim();
                strAIURL = ds.Tables[0].Rows[0]["URL"].ToString().Trim();

                if (strAIType == "Local")
                {
                    // 修改：直接使用配置的URL（应该是 http://localhost:11434/v1/chat/completions）
                    localApiUrl = strAIURL;

                    // 修改：调用修正后的方法
                    result = CallOllamaAPI(localApiUrl);

                    // Display result
                    lblGeneratedText.Text = result;
                }
                else
                {
                    localApiUrl = strAIURL;
                    ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "ajustHeight", "window.open('" + strAIURL + "');", true);
                }
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

    // 修改：重写这个方法以正确调用Ollama的OpenAI兼容接口
    private string CallOllamaAPI(string apiUrl)
    {
        string strAIModel;
        string strHQL;

        try
        {
            strHQL = "Select AIType,URL,Model From T_AIInterface";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");
            if (ds.Tables[0].Rows.Count > 0)
            {
                strAIModel = ds.Tables[0].Rows[0]["Model"].ToString().Trim();

                using (HttpClient client = new HttpClient())
                {
                    // 设置较长的超时时间，因为本地模型可能需要更长时间
                    client.Timeout = TimeSpan.FromSeconds(300);

                    // 修改：使用OpenAI兼容的请求格式
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

                    string jsonContent = Newtonsoft.Json.JsonConvert.SerializeObject(requestBody);
                    HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                    // Synchronous call
                    HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string jsonString = response.Content.ReadAsStringAsync().Result;

                        // 清理JSON字符串
                        jsonString = CleanJsonString(jsonString);

                        // 解析响应
                        dynamic responseData = JsonConvert.DeserializeObject(jsonString);

                        // 从OpenAI兼容格式中提取内容
                        string result = "";

                        // 方式1：优先使用 choices[0].message.content
                        if (responseData.choices != null && responseData.choices.Count > 0 &&
                            responseData.choices[0].message != null &&
                            responseData.choices[0].message.content != null)
                        {
                            result = responseData.choices[0].message.content.ToString();
                        }
                        // 方式2：尝试直接提取response字段（向后兼容）
                        else if (responseData.response != null)
                        {
                            result = responseData.response.ToString();
                        }
                        // 方式3：尝试直接提取content字段
                        else if (responseData.content != null)
                        {
                            result = responseData.content.ToString();
                        }
                        else
                        {
                            result = LanguageHandle.GetWord("DSeekCouldNotParseResponseFromOllama");
                        }

                        // 清理和格式化结果
                        result = CleanAndFormatResult(result);
                        return result;
                    }
                    else
                    {
                        return LanguageHandle.GetWord("DSeekAPICallFailedWithStatus") + $"{response.StatusCode}. " + $"{response.ReasonPhrase}";
                    }
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

    // 新增：清理JSON字符串
    private string CleanJsonString(string jsonString)
    {
        if (string.IsNullOrEmpty(jsonString))
            return jsonString;

        // 替换常见的转义字符
        return jsonString.Replace("\\u003cthink\\u003e", "")
                         .Replace("\\u003c/think\\u003e", "")
                         .Replace("\\u003c", "<")
                         .Replace("\\u003e", ">")
                         .Replace("\\\"", "\"")
                         .Replace("\\n", "\n")
                         .Replace("\\t", "\t")
                         .Replace("\\r", "\r");
    }

    // 新增：清理和格式化结果
    private string CleanAndFormatResult(string result)
    {
        if (string.IsNullOrEmpty(result))
            return result;

        // 移除多余的标记
        result = result.Replace("***", "")
                       .Replace("**", "")
                       .Replace("###", "")
                       .Replace("##", "");

        // 将换行符转换为HTML换行
        result = result.Replace("\n", "<br>")
                       .Replace("\r\n", "<br>");

        return result;
    }

    protected void btnStopAI_Click(object sender, EventArgs e)
    {
        // Stop logic - 可留空或实现停止逻辑
    }

    // ==================== New Data Analysis Functionality ====================

    // Save tables to database
    protected void btnSaveTables_Click(object sender, EventArgs e)
    {
        try
        {
            var tableNames = txtTableNames.Text.Trim();
            if (string.IsNullOrEmpty(tableNames))
            {
                ShowMessage(LanguageHandle.GetWord("DSeekPleaseEnterTableNames"), "warning");
                return;
            }

            var tables = tableNames.Split(new[] { ',', '，', ';', '；' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(t => t.Trim())
                .Where(t => !string.IsNullOrEmpty(t))
                .ToList();

            if (tables.Count == 0)
            {
                ShowMessage(LanguageHandle.GetWord("DSeekNoValidTableNamesFound"), "warning");
                return;
            }

            // Create tables if not exist
            CreateTablesIfNotExist();

            int savedCount = 0;
            string currentUser = GetCurrentUser();
            DateTime now = DateTime.Now;

            foreach (var tableName in tables)
            {
                try
                {
                    // Check if table already exists
                    string checkSql = string.Format(@"SELECT COUNT(*) FROM T_DBTablesForAI WHERE TableName = '{0}' AND IsActive = true",
                                                    EscapeSql(tableName));

                    DataSet ds = ShareClass.GetDataSetFromSql(checkSql, "TempTable");
                    int exists = 0;
                    if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        exists = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
                    }

                    if (exists == 0)
                    {
                        string insertSql = string.Format(@"
                            INSERT INTO T_DBTablesForAI (TableName, Description, CreatedBy, CreatedAt, IsActive)
                            VALUES ('{0}', '{1}', '{2}', '{3}', true)",
                            EscapeSql(tableName),
                            EscapeSql(LanguageHandle.GetWord("DSeekTableAddedThroughInterface") + " - " + $"{now:yyyy-MM-dd}"),
                            EscapeSql(currentUser),
                            now.ToString("yyyy-MM-dd HH:mm:ss"));

                        ShareClass.RunSqlCommand(insertSql);
                        savedCount++;
                    }
                }
                catch
                {
                    // Ignore errors for individual tables
                }
            }

            ShowMessage(LanguageHandle.GetWord("DSeekSaveSuccessfulSaved") + $"{savedCount} " + LanguageHandle.GetWord("DSeekTablesToDatabase"), "success");

            // Clear input box
            txtTableNames.Text = "";
        }
        catch (Exception ex)
        {
            ShowMessage(LanguageHandle.GetWord("DSeekSaveFailed") + $"{ex.Message}", "error");
        }
    }

    // Load saved tables
    protected void btnLoadTables_Click(object sender, EventArgs e)
    {
        try
        {
            // Ensure table exists
            CreateTablesIfNotExist();

            string sql = "SELECT TableName, Description FROM T_DBTablesForAI WHERE IsActive = true ORDER BY TableName";
            DataSet ds = ShareClass.GetDataSetFromSql(sql, "T_DBTablesForAI");

            cblTables.Items.Clear();

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                string tableName = row["TableName"].ToString();
                string description = row["Description"].ToString();

                string text = tableName;
                if (!string.IsNullOrEmpty(description))
                {
                    text += " - " + $"{description}";
                }

                cblTables.Items.Add(new ListItem(text, tableName));
            }

            pnlTableList.Visible = true;

            // Register script to update selection display
            string script = "updateSelectedTables();";
            ScriptManager.RegisterStartupScript(this, GetType(), "UpdateTableSelection", script, true);

           // ShowMessage(LanguageHandle.GetWord("DSeekLoadSuccessfulLoaded") + $"{ds.Tables[0].Rows.Count} " + LanguageHandle.GetWord("DSeekTables"), "success");
        }
        catch (Exception ex)
        {
            ShowMessage(LanguageHandle.GetWord("DSeekLoadFailed") + $"{ex.Message}", "error");
        }
    }

    // Start data analysis
    protected void btnStartAnalysis_Click(object sender, EventArgs e)
    {
        // 检查AI服务器
        if (!_aiServerAvailable)
        {
            litSummary.Text = "<div style='color: orange; padding: 20px; font-weight: bold;'>" + LanguageHandle.GetWord("DSeekAIServerNotAvailableContactSupplier") + "</div>";

            // 显示结果区域
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowResultSection",
                "showResultSection();", true);
            return;
        }

        try
        {
            // Get selected tables
            var selectedTables = new List<string>();
            foreach (ListItem item in cblTables.Items)
            {
                if (item.Selected)
                {
                    selectedTables.Add(item.Value);
                }
            }

            if (selectedTables.Count == 0)
            {
                ShowMessage(LanguageHandle.GetWord("DSeekPleaseSelectTablesToAnalyze"), "warning");
                return;
            }

            if (string.IsNullOrEmpty(txtAnalysisRequirement.Text.Trim()))
            {
                ShowMessage(LanguageHandle.GetWord("DSeekPleaseEnterAnalysisRequirements"), "warning");
                return;
            }

            // Execute analysis
            DateTime startTime = DateTime.Now;
            var result = ExecuteDataAnalysis(selectedTables);
            double analysisTime = (DateTime.Now - startTime).TotalSeconds;

            if (!string.IsNullOrEmpty(result.Error))
            {
                throw new Exception(result.Error);
            }

            // Display results
            DisplayAnalysisResults(result, selectedTables, analysisTime);

            // Save analysis history
            SaveAnalysisHistory(selectedTables, analysisTime);

        }
        catch (Exception ex)
        {
            litSummary.Text = LanguageHandle.GetWord("DSeekAnalysisFailed") + $"{ex.Message}";

            // Show result section
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowResultSection",
                "showResultSection();", true);
        }
    }

    // Execute data analysis
    private AnalysisResult ExecuteDataAnalysis(List<string> selectedTables)
    {
        var result = new AnalysisResult();

        try
        {
            // 1. Get AI configuration
            var aiConfig = GetAIConfig();
            if (aiConfig == null)
            {
                result.Error = LanguageHandle.GetWord("DSeekAIConfigurationNotFound");
                return result;
            }

            // 2. Get table metadata
            var metadata = GetTableMetadata(selectedTables);

            // 3. Build analysis prompt
            var prompt = BuildAnalysisPrompt(selectedTables, txtAnalysisRequirement.Text.Trim(), metadata);

            // 4. Call Ollama for analysis (修改：使用修正后的方法)
            var ollamaResponse = CallOllamaForAnalysis(aiConfig, prompt);

            // 5. Parse response
            var analysis = ParseAnalysisResponse(ollamaResponse);

            result.Summary = analysis.Summary;
            result.Insights = analysis.Insights;
            result.Recommendations = analysis.Recommendations;

            // 6. Generate SQL queries
            result.Queries = GenerateAnalysisQueries(selectedTables);

            return result;
        }
        catch (Exception ex)
        {
            result.Error = LanguageHandle.GetWord("DSeekErrorDuringAnalysis") + $"{ex.Message}";
            return result;
        }
    }

    // Get AI configuration
    private AIConfig GetAIConfig()
    {
        string strHQL = "Select AIType, URL, Model From T_AIInterface";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return new AIConfig
            {
                AIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim(),
                URL = ds.Tables[0].Rows[0]["URL"].ToString().Trim(),
                Model = ds.Tables[0].Rows[0]["Model"].ToString().Trim()
            };
        }

        return null;
    }

    // Get table metadata
    private List<TableMetadata> GetTableMetadata(List<string> tables)
    {
        var metadata = new List<TableMetadata>();

        foreach (var table in tables)
        {
            try
            {
                // Get table structure information
                string columnSql = $@"
                    SELECT 
                        column_name as Name,
                        data_type as DataType,
                        is_nullable as IsNullable
                    FROM information_schema.columns
                    WHERE table_name = '{EscapeSql(table)}'
                    AND table_schema = 'public'
                    ORDER BY ordinal_position";

                DataSet columnDs = ShareClass.GetDataSetFromSql(columnSql, "Columns");

                var columns = new List<ColumnInfo>();
                foreach (DataRow row in columnDs.Tables[0].Rows)
                {
                    columns.Add(new ColumnInfo
                    {
                        Name = row["Name"].ToString(),
                        DataType = row["DataType"].ToString(),
                        IsNullable = row["IsNullable"].ToString()
                    });
                }

                // Get row count
                long rowCount = 0;
                try
                {
                    string countSql = $"SELECT COUNT(*) FROM \"{table}\"";
                    DataSet countDs = ShareClass.GetDataSetFromSql(countSql, "Count");
                    if (countDs.Tables.Count > 0 && countDs.Tables[0].Rows.Count > 0)
                    {
                        rowCount = Convert.ToInt64(countDs.Tables[0].Rows[0][0]);
                    }
                }
                catch
                {
                    rowCount = 0;
                }

                metadata.Add(new TableMetadata
                {
                    TableName = table,
                    Columns = columns,
                    RowCount = rowCount
                });
            }
            catch (Exception ex)
            {
                // Log error but continue processing other tables
                metadata.Add(new TableMetadata
                {
                    TableName = table,
                    Error = LanguageHandle.GetWord("DSeekFailedToGetTableStructure") + $"{ex.Message}"
                });
            }
        }

        return metadata;
    }

    // Build analysis prompt
    private string BuildAnalysisPrompt(List<string> tables, string requirement, List<TableMetadata> metadata)
    {
        var metadataJson = JsonConvert.SerializeObject(metadata, Formatting.Indented);

        return LanguageHandle.GetWord("DSeekPleaseAnalyzeDatabaseTableData") + "\n\n" +
               LanguageHandle.GetWord("DSeekTablesToAnalyze") + $"{string.Join(", ", tables)}\n\n" +
               LanguageHandle.GetWord("DSeekUserAnalysisRequirements") + ":\n" +
               $"{requirement}\n\n" +
               LanguageHandle.GetWord("DSeekTableStructureInformation") + ":\n" +
               $"{metadataJson}\n\n" +
               LanguageHandle.GetWord("DSeekPleaseProvideDetailedAnalysisReport") + ":\n\n" +
               "1. **" + LanguageHandle.GetWord("DSeekDataOverviewAnalysis") + "**\n" +
               "   - " + LanguageHandle.GetWord("DSeekDataVolumeAndKeyFieldAnalysis") + "\n" +
               "   - " + LanguageHandle.GetWord("DSeekDataQualityAssessment") + "\n\n" +
               "2. **" + LanguageHandle.GetWord("DSeekBusinessInsightsDiscovery") + "**\n" +
               "   - " + LanguageHandle.GetWord("DSeekInDepthAnalysisBasedOnRequirements") + "\n" +
               "   - " + LanguageHandle.GetWord("DSeekDataPatternsAndTrendsDiscovered") + "\n" +
               "   - " + LanguageHandle.GetWord("DSeekOutliersAndPotentialIssues") + "\n\n" +
               "3. **" + LanguageHandle.GetWord("DSeekOptimizationSuggestions") + "**\n" +
               "   - " + LanguageHandle.GetWord("DSeekDataQualityImprovementSuggestions") + "\n" +
               "   - " + LanguageHandle.GetWord("DSeekBusinessOptimizationRecommendations") + "\n\n" +
               LanguageHandle.GetWord("DSeekPleaseRespondInEnglish") + ".";
    }

    // 修改：重写这个方法以正确调用Ollama
    private string CallOllamaForAnalysis(AIConfig config, string prompt)
    {
        if (config.AIType != "Local")
        {
            throw new Exception(LanguageHandle.GetWord("DSeekOnlyLocalOllamaAnalysisSupported"));
        }

        string apiUrl = config.URL; // 应该是 http://localhost:11434/v1/chat/completions

        using (HttpClient client = new HttpClient())
        {
            client.Timeout = TimeSpan.FromSeconds(300);

            // 修改：使用OpenAI兼容的请求格式
            var requestBody = new
            {
                model = config.Model,
                messages = new[]
                {
                    new { role = "user", content = prompt }
                },
                stream = false,
                temperature = 0.3, // 分析任务使用较低的温度以获得更确定的输出
                max_tokens = 4000 // 分析任务可能需要更长的输出
            };

            string jsonContent = JsonConvert.SerializeObject(requestBody);
            HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

            // Synchronous call
            HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

            if (response.IsSuccessStatusCode)
            {
                string jsonString = response.Content.ReadAsStringAsync().Result;
                jsonString = CleanJsonString(jsonString);
                dynamic responseData = JsonConvert.DeserializeObject(jsonString);

                // 从OpenAI兼容格式中提取内容
                if (responseData.choices != null && responseData.choices.Count > 0 &&
                    responseData.choices[0].message != null &&
                    responseData.choices[0].message.content != null)
                {
                    return responseData.choices[0].message.content.ToString();
                }
                else if (responseData.response != null)
                {
                    return responseData.response.ToString();
                }
                else if (responseData.content != null)
                {
                    return responseData.content.ToString();
                }
                else
                {
                    throw new Exception(LanguageHandle.GetWord("DSeekCouldNotParseResponseInvalidFormat"));
                }
            }
            else
            {
                string errorContent = response.Content.ReadAsStringAsync().Result;
                throw new Exception(LanguageHandle.GetWord("DSeekOllamaAPICallFailed") + $"{response.StatusCode}. " + LanguageHandle.GetWord("DSeekResponse") + $"{errorContent}");
            }
        }
    }

    // Parse analysis response
    private AnalysisResult ParseAnalysisResponse(string response)
    {
        var result = new AnalysisResult();

        if (string.IsNullOrEmpty(response))
        {
            result.Summary = LanguageHandle.GetWord("DSeekNoResponseReceivedFromAIAnalysis");
            result.Insights = LanguageHandle.GetWord("DSeekNoInsightsAvailable");
            result.Recommendations = LanguageHandle.GetWord("DSeekNoRecommendationsAvailable");
            return result;
        }

        // 清理响应
        response = CleanAndFormatResult(response);

        // 简单解析：提取摘要（前500字符）
        if (response.Length > 500)
        {
            // 尝试找到第一个自然段落结束
            int endIndex = response.IndexOf("。", 300);
            if (endIndex > 0)
            {
                result.Summary = response.Substring(0, endIndex + 1) + "...";
            }
            else
            {
                result.Summary = response.Substring(0, 500) + "...";
            }
        }
        else
        {
            result.Summary = response;
        }

        // 完整响应作为详细洞察
        result.Insights = response;

        // 尝试提取建议部分
        if (response.Contains("Suggestions") || response.Contains("建议"))
        {
            int startIndex = Math.Max(
                response.LastIndexOf("Suggestions"),
                response.LastIndexOf("建议")
            );
            if (startIndex > 0)
            {
                result.Recommendations = response.Substring(startIndex);
            }
            else
            {
                result.Recommendations = response;
            }
        }
        else if (response.Contains("3.") || response.Contains("三、"))
        {
            // 尝试根据序号提取第三部分（通常是建议）
            int startIndex = Math.Max(
                response.LastIndexOf("3."),
                response.LastIndexOf("三、")
            );
            if (startIndex > 0)
            {
                result.Recommendations = response.Substring(startIndex);
            }
            else
            {
                result.Recommendations = response;
            }
        }
        else
        {
            result.Recommendations = response;
        }

        return result;
    }

    // Generate SQL queries
    private List<string> GenerateAnalysisQueries(List<string> tables)
    {
        var queries = new List<string>();

        foreach (var table in tables)
        {
            try
            {
                // Basic statistics queries
                queries.Add("-- " + $"{table} " + LanguageHandle.GetWord("DSeekTableBasicStatistics"));
                queries.Add("SELECT COUNT(*) as TotalRecords FROM \"" + $"{table}" + "\";");

                // Get table field information
                string columnSql = $@"
                    SELECT column_name, data_type
                    FROM information_schema.columns
                    WHERE table_name = '{EscapeSql(table)}'";

                DataSet columnDs = ShareClass.GetDataSetFromSql(columnSql, "Columns");

                foreach (DataRow row in columnDs.Tables[0].Rows)
                {
                    string columnName = row["column_name"].ToString();
                    string dataType = row["data_type"].ToString();

                    // Check if it's a datetime field
                    if (dataType.Contains("date") || dataType.Contains("time") ||
                        columnName.Contains("date") || columnName.Contains("time") ||
                        columnName.Contains("create") || columnName.Contains("update"))
                    {
                        queries.Add("-- " + $"{table}.{columnName} " + LanguageHandle.GetWord("DSeekTimeAnalysis"));
                        queries.Add("SELECT MIN(\"" + $"{columnName}" + "\") as EarliestRecord, MAX(\"" + $"{columnName}" + "\") as LatestRecord FROM \"" + $"{table}" + "\";");
                    }

                    // Check if it's a numeric field
                    if (dataType.Contains("int") || dataType.Contains("dec") ||
                        dataType.Contains("num") || dataType.Contains("real") ||
                        dataType.Contains("float") || dataType.Contains("double"))
                    {
                        queries.Add("-- " + $"{table}.{columnName} " + LanguageHandle.GetWord("DSeekNumericStatistics"));
                        queries.Add("SELECT MIN(\"" + $"{columnName}" + "\") as MinValue, MAX(\"" + $"{columnName}" + "\") as MaxValue, AVG(\"" + $"{columnName}" + "\") as Average FROM \"" + $"{table}" + "\";");
                    }
                }
            }
            catch (Exception ex)
            {
                queries.Add("-- " + $"{table} " + LanguageHandle.GetWord("DSeekTableQueryError") + $"{ex.Message}");
            }
        }

        return queries;
    }

    // Display analysis results
    private void DisplayAnalysisResults(AnalysisResult result, List<string> selectedTables, double analysisTime)
    {
        // Update time display
        litAnalysisTime.Text = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} " + "(" + LanguageHandle.GetWord("DSeekTimeTaken") + $"{analysisTime:F1} " + LanguageHandle.GetWord("DSeekSeconds") + ")";
        litAnalyzedTables.Text = string.Join(", ", selectedTables);

        // Format and display results
        litSummary.Text = FormatAnalysisContent(result.Summary);
        litInsights.Text = FormatAnalysisContent(result.Insights);
        litQueries.Text = FormatQueries(result.Queries);
        litRecommendations.Text = FormatAnalysisContent(result.Recommendations);

        // Show result section
        ScriptManager.RegisterStartupScript(this, GetType(), "ShowResultSection",
            "showResultSection();", true);
    }

    // Save analysis history
    private void SaveAnalysisHistory(List<string> selectedTables, double analysisTime)
    {
        try
        {
            // Ensure table exists
            CreateTablesIfNotExist();

            string currentUser = GetCurrentUser();
            DateTime now = DateTime.Now;
            string requirement = EscapeSql(txtAnalysisRequirement.Text.Trim());
            string tablesString = string.Join(",", selectedTables);

            foreach (var tableName in selectedTables)
            {
                try
                {
                    // Get configuration ID for the table
                    string getTableIdSql = string.Format(@"SELECT ID FROM T_DBTablesForAI WHERE TableName = '{0}'",
                                                         EscapeSql(tableName));

                    DataSet ds = ShareClass.GetDataSetFromSql(getTableIdSql, "TempTable");
                    if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        int tableId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);

                        // Insert analysis history
                        string insertHistorySql = string.Format(@"
                            INSERT INTO T_AnalysisHistory 
                            (ConfigID, AnalysisRequirement, SelectedTables, CreatedBy, CreatedAt, AnalysisTime, Status)
                            VALUES ({0}, '{1}', '{2}', '{3}', '{4}', {5}, 'completed')",
                            tableId,
                            requirement,
                            EscapeSql(tablesString),
                            EscapeSql(currentUser),
                            now.ToString("yyyy-MM-dd HH:mm:ss"),
                            (int)analysisTime);

                        ShareClass.RunSqlCommand(insertHistorySql);

                        // Update table analysis count
                        string updateTableSql = string.Format(@"
                            UPDATE T_DBTablesForAI 
                            SET AnalysisCount = AnalysisCount + 1, LastAnalyzed = '{0}' 
                            WHERE ID = {1}",
                            now.ToString("yyyy-MM-dd HH:mm:ss"),
                            tableId);

                        ShareClass.RunSqlCommand(updateTableSql);
                    }
                }
                catch
                {
                    // Ignore errors for individual tables
                }
            }
        }
        catch
        {
            // Ignore history save errors
        }
    }

    // Create required tables if they don't exist
    private void CreateTablesIfNotExist()
    {
        try
        {
            // Create AI analysis table configuration table
            string createTable1 = @"
                CREATE TABLE IF NOT EXISTS T_DBTablesForAI (
                    ID SERIAL PRIMARY KEY,
                    TableName VARCHAR(255) NOT NULL,
                    Description TEXT,
                    CreatedBy VARCHAR(100),
                    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    IsActive BOOLEAN DEFAULT TRUE,
                    LastAnalyzed TIMESTAMP,
                    AnalysisCount INTEGER DEFAULT 0
                )";

            ShareClass.RunSqlCommand(createTable1);

            // Create analysis history table
            string createTable2 = @"
                CREATE TABLE IF NOT EXISTS T_AnalysisHistory (
                    ID SERIAL PRIMARY KEY,
                    ConfigID INTEGER,
                    AnalysisRequirement TEXT NOT NULL,
                    SelectedTables TEXT NOT NULL,
                    CreatedBy VARCHAR(100),
                    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    AnalysisTime INTEGER,
                    Status VARCHAR(50) DEFAULT 'completed'
                )";

            ShareClass.RunSqlCommand(createTable2);
        }
        catch
        {
            // If tables already exist, ignore error
        }
    }

    // Escape SQL string
    private string EscapeSql(string input)
    {
        if (string.IsNullOrEmpty(input))
            return string.Empty;

        return input.Replace("'", "''");
    }

    // Get current user
    private string GetCurrentUser()
    {
        return User.Identity?.Name ?? "System";
    }

    // Show message
    private void ShowMessage(string message, string type)
    {
        string icon = type == "warning" ? "⚠️" : type == "error" ? "❌" : "✅";
        string script = "alert('" + $"{icon} " + message.Replace("'", "\\'") + "');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage", script, true);
    }

    // Format analysis content
    private string FormatAnalysisContent(string content)
    {
        if (string.IsNullOrEmpty(content))
            return "<div style='color: #666; font-style: italic; padding: 20px;'>" + LanguageHandle.GetWord("DSeekNoContentAvailable") + "</div>";

        // Clean and format
        content = content.Replace("\\n", "<br/>")
                         .Replace("\n", "<br/>")
                         .Replace("  ", " &nbsp;");

        // Simple Markdown conversion
        content = System.Text.RegularExpressions.Regex.Replace(content, @"\*\*(.+?)\*\*", "<strong>$1</strong>");
        content = System.Text.RegularExpressions.Regex.Replace(content, @"### (.+)", "<h3>$1</h3>");
        content = System.Text.RegularExpressions.Regex.Replace(content, @"## (.+)", "<h2>$1</h2>");
        content = System.Text.RegularExpressions.Regex.Replace(content, @"- (.+)", "<li>$1</li>");
        content = System.Text.RegularExpressions.Regex.Replace(content, @"\d+\. (.+)", "<li>$1</li>");

        return "<div style='line-height: 1.6;'>" + $"{content}" + "</div>";
    }

    // Format queries
    private string FormatQueries(List<string> queries)
    {
        if (queries == null || queries.Count == 0)
            return "<div style='color: #666; font-style: italic; padding: 20px;'>" + LanguageHandle.GetWord("DSeekNoQueriesGenerated") + "</div>";

        var sb = new StringBuilder();
        sb.AppendLine("<div style='font-family: Consolas, monospace; font-size: 13px;'>");

        foreach (var query in queries)
        {
            sb.AppendLine("<div style='margin-bottom: 15px;'>");
            sb.AppendLine("<div style='background: #f8f9fa; padding: 10px; border-radius: 5px; margin-bottom: 5px; color: #666; font-size: 12px;'>");
            sb.AppendLine(HttpUtility.HtmlEncode(query.Split('\n').FirstOrDefault() ?? ""));
            sb.AppendLine("</div>");
            sb.AppendLine("<pre style='background: white; padding: 15px; border-radius: 5px; border: 1px solid #ddd; overflow-x: auto; margin: 0;'>");
            sb.AppendLine(HttpUtility.HtmlEncode(query));
            sb.AppendLine("</pre>");
            sb.AppendLine("</div>");
        }

        sb.AppendLine("</div>");
        return sb.ToString();
    }

    // Data classes
    private class AIConfig
    {
        public string AIType { get; set; }
        public string URL { get; set; }
        public string Model { get; set; }
    }

    private class TableMetadata
    {
        public string TableName { get; set; }
        public List<ColumnInfo> Columns { get; set; } = new List<ColumnInfo>();
        public long RowCount { get; set; }
        public string Error { get; set; }
    }

    private class ColumnInfo
    {
        public string Name { get; set; }
        public string DataType { get; set; }
        public string IsNullable { get; set; }
    }

    // Test configuration connection
    protected void btnTestConfig_Click(object sender, EventArgs e)
    {
        try
        {
            // Test database connection
            string sql = @"SELECT current_database() as dbname,COUNT(*) as tablecount FROM information_schema.tables WHERE table_schema = 'public'";
            DataSet ds = ShareClass.GetDataSetFromSql(sql, "TestConnection");
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                string dbName = ds.Tables[0].Rows[0]["dbname"].ToString();
                string tableCount = ds.Tables[0].Rows[0]["tablecount"].ToString();

                ShowMessage(LanguageHandle.GetWord("DSeekDatabaseConnectionSuccessfulCurrentDatabase") + $"{dbName}, " + LanguageHandle.GetWord("DSeekTableCount") + $"{tableCount}", "success");
            }
            else
            {
                ShowMessage(LanguageHandle.GetWord("DSeekDatabaseConnectionSuccessful"), "success");
            }
        }
        catch (Exception ex)
        {
            ShowMessage(LanguageHandle.GetWord("DSeekDatabaseConnectionFailed") + $"{ex.Message}", "error");
        }
    }

    // Save configuration
    protected void btnSaveConfig_Click(object sender, EventArgs e)
    {
        try
        {
            // Save Ollama configuration
            string checkSql = "SELECT COUNT(*) FROM T_AIInterface";
            DataSet ds = ShareClass.GetDataSetFromSql(checkSql, "TempTable");
            int count = 0;
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                count = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            }

            string url = EscapeSql(txtDeepSeekApi.Text.Trim());
            string model = EscapeSql(txtModel.Text.Trim());

            if (count > 0)
            {
                string updateSql = string.Format(@"UPDATE T_AIInterface SET URL = '{0}', Model = '{1}' WHERE AIType = 'Local'",
                                                url, model);
                ShareClass.RunSqlCommand(updateSql);
            }
            else
            {
                string insertSql = string.Format(@"INSERT INTO T_AIInterface (AIType, URL, Model) VALUES ('Local', '{0}', '{1}')",
                                                url, model);
                ShareClass.RunSqlCommand(insertSql);
            }

            ShowMessage(LanguageHandle.GetWord("DSeekConfigurationSavedSuccessfully"), "success");
        }
        catch (Exception ex)
        {
            ShowMessage(LanguageHandle.GetWord("DSeekSaveFailed") + $"{ex.Message}", "error");
        }
    }
}