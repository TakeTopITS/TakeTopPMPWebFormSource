using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

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
            // Load configuration
            LoadConfig();
            txtPrompt.Focus();
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
                txtDeepSeekApi.Text = "http://localhost:11434/v1/chat/completions";
                txtModel.Text = "deepseek-chat";
            }
        }
        catch
        {
            txtDeepSeekApi.Text = "http://localhost:11434/v1/chat/completions";
            txtModel.Text = "deepseek-chat";
        }
    }

    // ==================== Original Functionality ====================

    protected void BT_Simple_Click(object sender, EventArgs e)
    {
        divDataAnalysisMode.Visible = false;
        divSimpleMode.Visible = true;

        // Set button active state
        BT_Simple.CssClass = "mode-button active";
        BT_DataAnalysis.CssClass = "mode-button";
    }

    protected void BT_DataAnalysis_Click(object sender, EventArgs e)
    {
        divDataAnalysisMode.Visible = true;
        divSimpleMode.Visible = false;

        // Set button active state
        BT_DataAnalysis.CssClass = "mode-button active";
        BT_Simple.CssClass = "mode-button";
    }

    protected void btnGenerateText_Click(object sender, EventArgs e)
    {
        string localApiUrl, result;
        string strAIType, strAIURL;

        string strHQL;

        lblGeneratedText.Text = "";

        if (txtPrompt.Text.Trim() == "")
        {
            lblGeneratedText.Text = "Prompt can't be empty!";
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
                    // DeepSeek or Ollama local API URL
                    localApiUrl = strAIURL + "/api/generate"; // Ollama default API URL

                    result = CallLocalApi(localApiUrl);

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

    private string CallLocalApi(string apiUrl)
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
                    // Example request body
                    var requestBody = new
                    {
                        model = strAIModel,
                        prompt = txtPrompt.Text
                    };

                    string jsonContent = Newtonsoft.Json.JsonConvert.SerializeObject(requestBody);
                    HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                    // Synchronous call
                    HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

                    if (response.IsSuccessStatusCode)
                    {
                        string jsonString = response.Content.ReadAsStringAsync().Result;

                        jsonString = jsonString.Replace("\\u003cthink\\u003e", "").Replace("\\u003c/think\\u003e", "");
                        jsonString = jsonString.Replace("***", "");
                        jsonString = jsonString.Replace("**", "");
                        jsonString = jsonString.Replace("###", "");
                        jsonString = jsonString.Replace("##", "");
                        jsonString = jsonString.Replace("\\n", "<br>");

                        // Extract all strings after "response":
                        List<string> responses = new List<string>();
                        int index = 0;

                        while (true)
                        {
                            // Find position of "response":"
                            int startIndex = jsonString.IndexOf(@"""response"":""", index);
                            if (startIndex == -1) break;

                            // Skip length of "response":"
                            startIndex += @"""response"":""".Length;

                            // Find next double quote position
                            int endIndex = jsonString.IndexOf(@"""", startIndex);
                            if (endIndex == -1) break;

                            // Extract response value
                            string responseItem = jsonString.Substring(startIndex, endIndex - startIndex);
                            responses.Add(responseItem);

                            // Update search starting position
                            index = endIndex + 1;
                        }

                        // Join all response values with space
                        string combinedResponse = string.Join("", responses);

                        return combinedResponse;
                    }
                    else
                    {
                        return "Error";
                    }
                }
            }
            else
            {
                return "Error";
            }
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    protected void btnStopAI_Click(object sender, EventArgs e)
    {
        // Stop logic
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
                ShowMessage("Please enter table names", "warning");
                return;
            }

            var tables = tableNames.Split(new[] { ',', '，', ';', '；' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(t => t.Trim())
                .Where(t => !string.IsNullOrEmpty(t))
                .ToList();

            if (tables.Count == 0)
            {
                ShowMessage("No valid table names found", "warning");
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
                            EscapeSql($"Table added through interface - {now:yyyy-MM-dd}"),
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

            ShowMessage($"Save successful! Saved {savedCount} tables to database", "success");

            // Clear input box
            txtTableNames.Text = "";
        }
        catch (Exception ex)
        {
            ShowMessage($"Save failed: {ex.Message}", "error");
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
                    text += $" - {description}";
                }

                cblTables.Items.Add(new ListItem(text, tableName));
            }

            pnlTableList.Visible = true;

            // Register script to update selection display
            string script = "updateSelectedTables();";
            ScriptManager.RegisterStartupScript(this, GetType(), "UpdateTableSelection", script, true);

            ShowMessage($"Load successful! Loaded {ds.Tables[0].Rows.Count} tables", "success");
        }
        catch (Exception ex)
        {
            ShowMessage($"Load failed: {ex.Message}", "error");
        }
    }

    // Start data analysis
    protected void btnStartAnalysis_Click(object sender, EventArgs e)
    {
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
                ShowMessage("Please select tables to analyze", "warning");
                return;
            }

            if (string.IsNullOrEmpty(txtAnalysisRequirement.Text.Trim()))
            {
                ShowMessage("Please enter analysis requirements", "warning");
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
            litSummary.Text = $"<div style='color: red; padding: 20px;'>Analysis failed: {ex.Message}</div>";

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
                result.Error = "AI configuration not found";
                return result;
            }

            // 2. Get table metadata
            var metadata = GetTableMetadata(selectedTables);

            // 3. Build analysis prompt
            var prompt = BuildAnalysisPrompt(selectedTables, txtAnalysisRequirement.Text.Trim(), metadata);

            // 4. Call DeepSeek
            var deepSeekResponse = CallDeepSeekForAnalysis(aiConfig, prompt);

            // 5. Parse response
            var analysis = ParseAnalysisResponse(deepSeekResponse);

            result.Summary = analysis.Summary;
            result.Insights = analysis.Insights;
            result.Recommendations = analysis.Recommendations;

            // 6. Generate SQL queries
            result.Queries = GenerateAnalysisQueries(selectedTables);

            return result;
        }
        catch (Exception ex)
        {
            result.Error = $"Error during analysis: {ex.Message}";
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
                    Error = $"Failed to get table structure: {ex.Message}"
                });
            }
        }

        return metadata;
    }

    // Build analysis prompt
    private string BuildAnalysisPrompt(List<string> tables, string requirement, List<TableMetadata> metadata)
    {
        var metadataJson = JsonConvert.SerializeObject(metadata, Formatting.Indented);

        return $@"Please analyze the following database table data:

Tables to analyze: {string.Join(", ", tables)}

User analysis requirements:
{requirement}

Table structure information:
{metadataJson}

Please provide a detailed analysis report including:

1. **Data Overview Analysis**
   - Data volume and key field analysis for each table
   - Data quality assessment

2. **Business Insights Discovery**
   - In-depth analysis based on user requirements
   - Data patterns and trends discovered
   - Outliers and potential issues

3. **Optimization Suggestions**
   - Data quality improvement suggestions
   - Business optimization recommendations

Please respond in English, provide specific, actionable suggestions.";
    }

    // Call DeepSeek for analysis
    private string CallDeepSeekForAnalysis(AIConfig config, string prompt)
    {
        if (config.AIType != "Local")
        {
            throw new Exception("Only local DeepSeek analysis is supported");
        }

        string apiUrl = config.URL + "/api/generate";

        using (HttpClient client = new HttpClient())
        {
            client.Timeout = TimeSpan.FromSeconds(300);

            var requestBody = new
            {
                model = config.Model,
                prompt = prompt,
                stream = false
            };

            string jsonContent = JsonConvert.SerializeObject(requestBody);
            HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

            // Synchronous call
            HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

            if (response.IsSuccessStatusCode)
            {
                string jsonString = response.Content.ReadAsStringAsync().Result;
                dynamic responseData = JsonConvert.DeserializeObject(jsonString);

                if (responseData.response != null)
                {
                    return responseData.response.ToString();
                }
                else if (responseData.choices != null && responseData.choices.Count > 0)
                {
                    return responseData.choices[0].message.content.ToString();
                }
            }

            throw new Exception("DeepSeek API call failed");
        }
    }

    // Parse analysis response
    private AnalysisResult ParseAnalysisResponse(string response)
    {
        var result = new AnalysisResult();

        // Simple parsing: extract summary (first 500 characters)
        if (response.Length > 500)
        {
            result.Summary = response.Substring(0, 500) + "...";
        }
        else
        {
            result.Summary = response;
        }

        // Full response as detailed insights
        result.Insights = response;

        // Try to extract suggestions part
        if (response.Contains("Suggestions"))
        {
            int startIndex = response.IndexOf("Suggestions");
            result.Recommendations = response.Substring(startIndex);
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
                queries.Add($"-- {table} table basic statistics");
                queries.Add($"SELECT COUNT(*) as TotalRecords FROM \"{table}\";");

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
                        queries.Add($"-- {table}.{columnName} time analysis");
                        queries.Add($"SELECT MIN(\"{columnName}\") as EarliestRecord, MAX(\"{columnName}\") as LatestRecord FROM \"{table}\";");
                    }

                    // Check if it's a numeric field
                    if (dataType.Contains("int") || dataType.Contains("dec") ||
                        dataType.Contains("num") || dataType.Contains("real") ||
                        dataType.Contains("float") || dataType.Contains("double"))
                    {
                        queries.Add($"-- {table}.{columnName} numeric statistics");
                        queries.Add($"SELECT MIN(\"{columnName}\") as MinValue, MAX(\"{columnName}\") as MaxValue, AVG(\"{columnName}\") as Average FROM \"{table}\";");
                    }
                }
            }
            catch (Exception ex)
            {
                queries.Add($"-- {table} table query error: {ex.Message}");
            }
        }

        return queries;
    }

    // Display analysis results
    private void DisplayAnalysisResults(AnalysisResult result, List<string> selectedTables, double analysisTime)
    {
        // Update time display
        litAnalysisTime.Text = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} (Time taken: {analysisTime:F1} seconds)";
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
        string script = $"alert('{icon} {message.Replace("'", "\\'")}');";
        ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage", script, true);
    }

    // Format analysis content
    private string FormatAnalysisContent(string content)
    {
        if (string.IsNullOrEmpty(content))
            return "<div style='color: #666; font-style: italic; padding: 20px;'>No content available</div>";

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

        return $"<div style='line-height: 1.6;'>{content}</div>";
    }

    // Format queries
    private string FormatQueries(List<string> queries)
    {
        if (queries == null || queries.Count == 0)
            return "<div style='color: #666; font-style: italic; padding: 20px;'>No queries generated</div>";

        var sb = new StringBuilder();
        sb.AppendLine("<div style='font-family: Consolas, monospace; font-size: 13px;'>");

        foreach (var query in queries)
        {
            sb.AppendLine($"<div style='margin-bottom: 15px;'>");
            sb.AppendLine($"<div style='background: #f8f9fa; padding: 10px; border-radius: 5px; margin-bottom: 5px; color: #666; font-size: 12px;'>");
            sb.AppendLine(HttpUtility.HtmlEncode(query.Split('\n').FirstOrDefault() ?? ""));
            sb.AppendLine($"</div>");
            sb.AppendLine($"<pre style='background: white; padding: 15px; border-radius: 5px; border: 1px solid #ddd; overflow-x: auto; margin: 0;'>");
            sb.AppendLine(HttpUtility.HtmlEncode(query));
            sb.AppendLine($"</pre>");
            sb.AppendLine($"</div>");
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

                ShowMessage($"✅ Database connection successful! Current database: {dbName}, Table count: {tableCount}", "success");
            }
            else
            {
                ShowMessage("✅ Database connection successful!", "success");
            }
        }
        catch (Exception ex)
        {
            ShowMessage($"❌ Database connection failed: {ex.Message}", "error");
        }
    }

    // Save configuration
    protected void btnSaveConfig_Click(object sender, EventArgs e)
    {
        try
        {
            // Save DeepSeek configuration
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

            ShowMessage("✅ Configuration saved successfully!", "success");
        }
        catch (Exception ex)
        {
            ShowMessage($"❌ Save failed: {ex.Message}", "error");
        }
    }
}