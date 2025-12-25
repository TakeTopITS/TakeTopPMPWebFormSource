using Newtonsoft.Json;

using Stimulsoft.Base;

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

    // AI服务器状态
    private bool _aiServerAvailable = false;
    private string _aiServerType = "Local";
    private string _aiApiKey = "";
    string strUserCode;

    protected void Page_Load(object sender, EventArgs e)
    {
        // CKEditor initialization
        CKFinder.FileBrowser _FileBrowser = new CKFinder.FileBrowser();
        _FileBrowser.BasePath = "ckfinder/";
        Session["PageName"] = "CommonPage";
        _FileBrowser.SetupCKEditor(lblGeneratedText);
        lblGeneratedText.Language = Session["LangCode"].ToString();

        strUserCode = Session["UserCode"].ToString();

        if (!IsPostBack)
        {
            //检查用户是否可以用AI分析功能
            if (!ShareClass.checkUserHasModuleRight("AIAnalyst", strUserCode))
            {
                divModeSwitcher.Visible = false;
            }

            // 检查AI服务器状态
            _aiServerAvailable = CheckAIServerAvailable();

            // 更新服务器状态显示
            UpdateAIServerStatusDisplay();

            txtPrompt.Focus();
        }
    }

    // 更新AI服务器状态显示
    private void UpdateAIServerStatusDisplay()
    {
        if (_aiServerAvailable)
        {
            // AI服务器可用，显示成功状态
            aiServerStatusContainer.Visible = true;
            aiServerStatusContainer.Attributes["class"] = "ai-server-status success";
            lblAIServerStatus.Text = _aiServerType == "Local" ?
                LanguageHandle.GetWord("DSeekAIServerAvailable") :
                LanguageHandle.GetWord("DSeekExternalAIServerAvailable");
        }
        else
        {
            // AI服务器不可用，显示错误状态
            aiServerStatusContainer.Visible = true;
            aiServerStatusContainer.Attributes["class"] = "ai-server-status error";
            lblAIServerStatus.Text = LanguageHandle.GetWord("DSeekNoValidAIServer");
        }
    }

    // 检查AI服务器是否可用，支持本地和外部服务器
    private bool CheckAIServerAvailable()
    {
        try
        {
            // 从数据库获取配置
            string strHQL = "Select AIType, URL, AIKey, Model From T_AIInterface Where InUse = 'YES' ";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

            if (ds.Tables[0].Rows.Count == 0)
            {
                return false; // 没有配置
            }

            string strAIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim();
            string strAIURL = ds.Tables[0].Rows[0]["URL"].ToString().Trim();
            string strAIModel = ds.Tables[0].Rows[0]["Model"].ToString().Trim();
            string strAIKey = ds.Tables[0].Rows[0]["AIKey"].ToString().Trim();

            // 保存配置信息
            _aiServerType = strAIType;
            _aiApiKey = strAIKey;

            if (strAIType == "Local")
            {
                // 测试本地Ollama服务器连接
                return TestOllamaConnection(strAIURL, strAIModel);
            }
            else if (strAIType == "Outer")
            {
                // 测试外部AI服务器连接
                return TestExternalAIConnection(strAIURL, strAIKey, strAIModel);
            }
            else
            {
                // 不支持的类型
                return false;
            }
        }
        catch
        {
            return false;
        }
    }

    // 测试外部AI服务器连接
    private bool TestExternalAIConnection(string apiUrl, string apiKey, string model)
    {
        try
        {
            using (HttpClient client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(15);

                // 为外部API添加认证头
                if (!string.IsNullOrEmpty(apiKey))
                {
                    client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
                }

                // 构建测试请求
                var testRequestBody = new
                {
                    model = model,
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

                // 检查响应状态
                return response.IsSuccessStatusCode || response != null;
            }
        }
        catch
        {
            return false;
        }
    }

    // 测试Ollama连接
    private bool TestOllamaConnection(string apiUrl, string aiModel)
    {
        try
        {
            using (HttpClient client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(10);

                // 测试OpenAI兼容接口
                var testRequestBody = new
                {
                    model = aiModel,
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

                return response != null;
            }
        }
        catch
        {
            return false;
        }
    }

    // 简单模式按钮点击
    protected void BT_Simple_Click(object sender, EventArgs e)
    {
        divDataAnalysisMode.Visible = false;
        divSimpleMode.Visible = true;

        // 设置按钮活动状态
        BT_Simple.CssClass = "mode-button active";
        BT_DataAnalysis.CssClass = "mode-button";
    }

    // 数据分析模式按钮点击
    protected void BT_DataAnalysis_Click(object sender, EventArgs e)
    {
        divDataAnalysisMode.Visible = true;
        divSimpleMode.Visible = false;

        // 设置按钮活动状态
        BT_DataAnalysis.CssClass = "mode-button active";
        BT_Simple.CssClass = "mode-button";
    }

    // 生成文本按钮点击
    protected void btnGenerateText_Click(object sender, EventArgs e)
    {
        // 检查AI服务器
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
                {
                    // 调用本地Ollama API
                    result = CallOllamaAPI(apiUrl);
                }
                else if (strAIType == "Outer")
                {
                    // 调用外部AI API
                    result = CallExternalAIAPI(apiUrl, strAIKey);
                }
                else
                {
                    result = LanguageHandle.GetWord("DSeekUnsupportedAIType");
                }

                // 显示结果
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

    // 调用Ollama API
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

                    // 使用OpenAI兼容的请求格式
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

    // 调用外部AI API
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

                    // 添加认证头
                    if (!string.IsNullOrEmpty(apiKey))
                    {
                        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
                    }

                    // 使用OpenAI兼容的请求格式
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

    // 处理AI响应
    private string ProcessAIResponse(HttpResponseMessage response, string aiType)
    {
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
            // 方式2：尝试直接提取response字段
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
                result = LanguageHandle.GetWord("DSeekCouldNotParseResponseFromAI");
            }

            // 清理和格式化结果
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

    // 清理JSON字符串
    private string CleanJsonString(string jsonString)
    {
        if (string.IsNullOrEmpty(jsonString))
            return jsonString;

        return jsonString.Replace("\\u003cthink\\u003e", "")
                         .Replace("\\u003c/think\\u003e", "")
                         .Replace("\\u003c", "<")
                         .Replace("\\u003e", ">")
                         .Replace("\\\"", "\"")
                         .Replace("\\n", "\n")
                         .Replace("\\t", "\t")
                         .Replace("\\r", "\r");
    }

    // 清理和格式化结果
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
        // 停止逻辑
    }

    // 保存表格到数据库
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

            // 创建表（如果不存在）
            CreateTablesIfNotExist();

            int savedCount = 0;
            string currentUser = GetCurrentUser();
            DateTime now = DateTime.Now;

            foreach (var tableName in tables)
            {
                try
                {
                    // 检查表是否已存在
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
                    // 忽略单个表的错误
                }
            }

            ShowMessage(LanguageHandle.GetWord("DSeekSaveSuccessfulSaved") + $"{savedCount} " + LanguageHandle.GetWord("DSeekTablesToDatabase"), "success");

            // 清空输入框
            txtTableNames.Text = "";
        }
        catch (Exception ex)
        {
            ShowMessage(LanguageHandle.GetWord("DSeekSaveFailed") + $"{ex.Message}", "error");
        }
    }

    // 加载保存的表格
    protected void btnLoadTables_Click(object sender, EventArgs e)
    {
        try
        {
            // 确保表存在
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

            // 注册脚本更新选择显示
            string script = "updateSelectedTables();";
            ScriptManager.RegisterStartupScript(this, GetType(), "UpdateTableSelection", script, true);
        }
        catch (Exception ex)
        {
            ShowMessage(LanguageHandle.GetWord("DSeekLoadFailed") + $"{ex.Message}", "error");
        }
    }

    // 开始数据分析
    protected void btnStartAnalysis_Click(object sender, EventArgs e)
    {
        // 检查AI服务器
        if (!_aiServerAvailable)
        {
            litSummary.Text = "<div style='color: orange; padding: 20px; font-weight: bold;'>" +
                              LanguageHandle.GetWord("DSeekAIServerNotAvailableContactSupplier") + "</div>";

            // 显示结果区域
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowResultSection",
                "showResultSection();", true);
            return;
        }

        try
        {
            // 获取选中的表格
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

            // 执行分析
            DateTime startTime = DateTime.Now;
            var result = ExecuteDataAnalysis(selectedTables);
            double analysisTime = (DateTime.Now - startTime).TotalSeconds;

            if (!string.IsNullOrEmpty(result.Error))
            {
                throw new Exception(result.Error);
            }

            // 显示结果
            DisplayAnalysisResults(result, selectedTables, analysisTime);

            // 保存分析历史
            SaveAnalysisHistory(selectedTables, analysisTime);

        }
        catch (Exception ex)
        {
            litSummary.Text = LanguageHandle.GetWord("DSeekAnalysisFailed") + $"{ex.Message}";

            // 显示结果区域
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowResultSection",
                "showResultSection();", true);
        }
    }

    // 执行数据分析
    private AnalysisResult ExecuteDataAnalysis(List<string> selectedTables)
    {
        var result = new AnalysisResult();

        try
        {
            // 1. 获取AI配置
            var aiConfig = GetAIConfig();
            if (aiConfig == null)
            {
                result.Error = LanguageHandle.GetWord("DSeekAIConfigurationNotFound");
                return result;
            }

            // 2. 获取表格元数据
            var metadata = GetTableMetadata(selectedTables);

            // 3. 构建分析提示
            var prompt = BuildAnalysisPrompt(selectedTables, txtAnalysisRequirement.Text.Trim(), metadata);

            // 4. 调用AI进行分析
            string aiResponse = "";
            if (aiConfig.AIType == "Local")
            {
                aiResponse = CallOllamaForAnalysis(aiConfig, prompt);
            }
            else if (aiConfig.AIType == "Outer")
            {
                aiResponse = CallExternalAIForAnalysis(aiConfig, prompt);
            }
            else
            {
                result.Error = LanguageHandle.GetWord("DSeekUnsupportedAIType");
                return result;
            }

            // 5. 解析响应
            var analysis = ParseAnalysisResponse(aiResponse);

            result.Summary = analysis.Summary;
            result.Insights = analysis.Insights;
            result.Recommendations = analysis.Recommendations;

            // 6. 生成SQL查询
            result.Queries = GenerateAnalysisQueries(selectedTables);

            return result;
        }
        catch (Exception ex)
        {
            result.Error = LanguageHandle.GetWord("DSeekErrorDuringAnalysis") + $"{ex.Message}";
            return result;
        }
    }

    // 获取AI配置
    private AIConfig GetAIConfig()
    {
        string strHQL = "Select AIType, URL, AIKey, Model From T_AIInterface Where InUse = 'YES'";
        DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

        if (ds.Tables[0].Rows.Count > 0)
        {
            return new AIConfig
            {
                AIType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim(),
                URL = ds.Tables[0].Rows[0]["URL"].ToString().Trim(),
                AIKey = ds.Tables[0].Rows[0]["AIKey"].ToString().Trim(),
                Model = ds.Tables[0].Rows[0]["Model"].ToString().Trim()
            };
        }

        return null;
    }

    // 获取表格元数据
    private List<TableMetadata> GetTableMetadata(List<string> tables)
    {
        var metadata = new List<TableMetadata>();

        foreach (var table in tables)
        {
            try
            {
                // 获取表格结构信息
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

                // 获取行数
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
                metadata.Add(new TableMetadata
                {
                    TableName = table,
                    Error = LanguageHandle.GetWord("DSeekFailedToGetTableStructure") + $"{ex.Message}"
                });
            }
        }

        return metadata;
    }

    // 构建分析提示
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

    // 调用Ollama进行分析
    private string CallOllamaForAnalysis(AIConfig config, string prompt)
    {
        string apiUrl = config.URL;

        using (HttpClient client = new HttpClient())
        {
            client.Timeout = TimeSpan.FromSeconds(300);

            var requestBody = new
            {
                model = config.Model,
                messages = new[]
                {
                    new { role = "user", content = prompt }
                },
                stream = false,
                temperature = 0.3,
                max_tokens = 4000
            };

            string jsonContent = JsonConvert.SerializeObject(requestBody);
            HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

            HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

            return ProcessAnalysisResponse(response);
        }
    }

    // 调用外部AI进行分析
    private string CallExternalAIForAnalysis(AIConfig config, string prompt)
    {
        string apiUrl = config.URL;

        using (HttpClient client = new HttpClient())
        {
            client.Timeout = TimeSpan.FromSeconds(300);

            // 添加认证头
            if (!string.IsNullOrEmpty(config.AIKey))
            {
                client.DefaultRequestHeaders.Add("Authorization", $"Bearer {config.AIKey}");
            }

            var requestBody = new
            {
                model = config.Model,
                messages = new[]
                {
                    new { role = "user", content = prompt }
                },
                stream = false,
                temperature = 0.3,
                max_tokens = 4000
            };

            string jsonContent = JsonConvert.SerializeObject(requestBody);
            HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

            HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

            return ProcessAnalysisResponse(response);
        }
    }

    // 处理分析响应
    private string ProcessAnalysisResponse(HttpResponseMessage response)
    {
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
            throw new Exception(LanguageHandle.GetWord("DSeekAIAPICallFailed") +
                               $"{response.StatusCode}. " +
                               LanguageHandle.GetWord("DSeekResponse") +
                               $"{errorContent}");
        }
    }

    // 解析分析响应
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

        // 简单解析：提取摘要
        if (response.Length > 500)
        {
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

    // 生成SQL查询
    private List<string> GenerateAnalysisQueries(List<string> tables)
    {
        var queries = new List<string>();

        foreach (var table in tables)
        {
            try
            {
                // 基础统计查询
                queries.Add("-- " + $"{table} " + LanguageHandle.GetWord("DSeekTableBasicStatistics"));
                queries.Add("SELECT COUNT(*) as TotalRecords FROM \"" + $"{table}" + "\";");

                // 获取表格字段信息
                string columnSql = $@"
                    SELECT column_name, data_type
                    FROM information_schema.columns
                    WHERE table_name = '{EscapeSql(table)}'";

                DataSet columnDs = ShareClass.GetDataSetFromSql(columnSql, "Columns");

                foreach (DataRow row in columnDs.Tables[0].Rows)
                {
                    string columnName = row["column_name"].ToString();
                    string dataType = row["data_type"].ToString();

                    // 检查是否是日期时间字段
                    if (dataType.Contains("date") || dataType.Contains("time") ||
                        columnName.Contains("date") || columnName.Contains("time") ||
                        columnName.Contains("create") || columnName.Contains("update"))
                    {
                        queries.Add("-- " + $"{table}.{columnName} " + LanguageHandle.GetWord("DSeekTimeAnalysis"));
                        queries.Add("SELECT MIN(\"" + $"{columnName}" + "\") as EarliestRecord, MAX(\"" + $"{columnName}" + "\") as LatestRecord FROM \"" + $"{table}" + "\";");
                    }

                    // 检查是否是数字字段
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

    // 显示分析结果
    private void DisplayAnalysisResults(AnalysisResult result, List<string> selectedTables, double analysisTime)
    {
        // 更新时间显示
        litAnalysisTime.Text = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} " +
                               "(" + LanguageHandle.GetWord("DSeekTimeTaken") +
                               $"{analysisTime:F1} " + LanguageHandle.GetWord("DSeekSeconds") + ")";
        litAnalyzedTables.Text = string.Join(", ", selectedTables);

        // 格式化和显示结果
        litSummary.Text = FormatAnalysisContent(result.Summary);
        litInsights.Text = FormatAnalysisContent(result.Insights);
        litQueries.Text = FormatQueries(result.Queries);
        litRecommendations.Text = FormatAnalysisContent(result.Recommendations);

        // 显示结果区域
        ScriptManager.RegisterStartupScript(this, GetType(), "ShowResultSection",
            "showResultSection();", true);
    }

    // 保存分析历史
    private void SaveAnalysisHistory(List<string> selectedTables, double analysisTime)
    {
        try
        {
            // 确保表存在
            CreateTablesIfNotExist();

            string currentUser = GetCurrentUser();
            DateTime now = DateTime.Now;
            string requirement = EscapeSql(txtAnalysisRequirement.Text.Trim());
            string tablesString = string.Join(",", selectedTables);

            foreach (var tableName in selectedTables)
            {
                try
                {
                    // 获取配置ID
                    string getTableIdSql = string.Format(@"SELECT ID FROM T_DBTablesForAI WHERE TableName = '{0}'",
                                                         EscapeSql(tableName));

                    DataSet ds = ShareClass.GetDataSetFromSql(getTableIdSql, "TempTable");
                    if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        int tableId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);

                        // 插入分析历史
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

                        // 更新表格分析计数
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
                    // 忽略单个表的错误
                }
            }
        }
        catch
        {
            // 忽略历史保存错误
        }
    }

    // 创建必需的表（如果不存在）
    private void CreateTablesIfNotExist()
    {
        try
        {
            // 创建AI分析表配置表
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

            // 创建分析历史表
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
            // 如果表已存在，忽略错误
        }
    }

    // 转义SQL字符串
    private string EscapeSql(string input)
    {
        if (string.IsNullOrEmpty(input))
            return string.Empty;

        return input.Replace("'", "''");
    }

    // 获取当前用户
    private string GetCurrentUser()
    {
        return User.Identity?.Name ?? "System";
    }

    // 显示消息
    private void ShowMessage(string message, string type)
    {
        string icon = type == "warning" ? "⚠️" : type == "error" ? "❌" : "✅";
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click",
            "showAlertAtMouse('" + $"{icon} " + message.Replace("'", "\\'") + "')", true);
    }

    // 格式化分析内容
    private string FormatAnalysisContent(string content)
    {
        if (string.IsNullOrEmpty(content))
            return "<div style='color: #666; font-style: italic; padding: 20px;'>" +
                   LanguageHandle.GetWord("DSeekNoContentAvailable") + "</div>";

        // 清理和格式化
        content = content.Replace("\\n", "<br/>")
                         .Replace("\n", "<br/>")
                         .Replace("  ", " &nbsp;");

        // 简单Markdown转换
        content = System.Text.RegularExpressions.Regex.Replace(content, @"\*\*(.+?)\*\*", "<strong>$1</strong>");
        content = System.Text.RegularExpressions.Regex.Replace(content, @"### (.+)", "<h3>$1</h3>");
        content = System.Text.RegularExpressions.Regex.Replace(content, @"## (.+)", "<h2>$1</h2>");
        content = System.Text.RegularExpressions.Regex.Replace(content, @"- (.+)", "<li>$1</li>");
        content = System.Text.RegularExpressions.Regex.Replace(content, @"\d+\. (.+)", "<li>$1</li>");

        return "<div style='line-height: 1.6;'>" + $"{content}" + "</div>";
    }

    // 格式化查询
    private string FormatQueries(List<string> queries)
    {
        if (queries == null || queries.Count == 0)
            return "<div style='color: #666; font-style: italic; padding: 20px;'>" +
                   LanguageHandle.GetWord("DSeekNoQueriesGenerated") + "</div>";

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

    // 数据类
    private class AIConfig
    {
        public string AIType { get; set; }
        public string URL { get; set; }
        public string AIKey { get; set; }
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
}