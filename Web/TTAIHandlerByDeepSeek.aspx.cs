using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

public partial class TTAIHandlerByDeepSeek : System.Web.UI.Page
{
    // 会话状态
    private string _mode = "simple";
    private bool _aiServerAvailable = false;
    private string _aiServerType = "Local";
    private string _aiApiKey = "";
    private string _aiModel = "";
    private string _aiUrl = "";
    private string _currentUserCode = "";
    private string _currentLangCode = "zh-CN";

    // 简单模式
    private string _generatedTextRaw = "";
    private string _lastChartOption = null;
    private bool _isGenerating = false;

    // NL2SQL 澄清
    private bool _nl2sqlNeedClarification = false;
    private string _nl2sqlClarificationQuestion = "";
    private List<string> _nl2sqlClarificationOptions = new List<string>();
    private string _pendingNLQuery = "";

    // 架构浏览器（分析模式）
    private bool _schemaLoaded = false;
    private List<SchemaNode> _schemas = new List<SchemaNode>();

    private class SchemaNode { public string Name = ""; public bool Expanded; public List<TableNode> Tables = new List<TableNode>(); public List<TableNode> Views = new List<TableNode>(); }
    private class TableNode { public string Name = ""; public string FullName = ""; public bool IsView; public bool ColumnsExpanded; public List<ColumnNode> Columns = new List<ColumnNode>(); }
    private class ColumnNode { public string Name = ""; public string DataType = ""; public bool IsNullable; }

    // 简单本地化（找不到 key 时回退到 key 本身）
    protected string W(string key)
    {
        string v = LanguageHandle.GetWord(key);
        return string.IsNullOrEmpty(v) || v == key ? key : v;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserCode"] == null)
        {
            Response.End();
            return;
        }

        _currentUserCode = Session["UserCode"].ToString();
        _currentLangCode = Session["LangCode"] == null ? "zh-CN" : Session["LangCode"].ToString();
        hfAiDefault.Value = W("AIDefaultQuestion");

        // 恢复模式
        if (!IsPostBack)
        {
            if (!ShareClass.checkUserHasModuleRight("AIAnalyst", _currentUserCode))
            {
                BT_Simple.Visible = false;
                BT_DataAnalysis.Visible = false;
            }
            AutoLoadAllTablesAndSelect();
            txtPrompt.Focus();
        }
        else
        {
            _mode = hfMode.Value == "analysis" ? "analysis" : "simple";
        }

        // 每次请求检查 AI 服务器状态
        _aiServerAvailable = CheckAIServerAvailable();
        UpdateAIServerStatusDisplay();

        // 应用模式（渲染时保持正确显示）
        if (!IsPostBack)
        {
            divSimpleMode.Attributes["style"] = _mode == "analysis" ? "display:none;" : "display:block;";
            divAnalysisMode.Attributes["style"] = _mode == "analysis" ? "display:block;" : "display:none;";
        }
    }

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        // 确保数据分析模式正确显示
        divSimpleMode.Style["display"] = _mode == "analysis" ? "none" : "block";
        divAnalysisMode.Style["display"] = _mode == "analysis" ? "block" : "none";
        BT_Simple.CssClass = "ai-mode-btn" + (_mode == "simple" ? " active" : "");
        BT_DataAnalysis.CssClass = "ai-mode-btn" + (_mode == "analysis" ? " active" : "");
    }

    private void UpdateAIServerStatusDisplay()
    {
        if (!_aiServerAvailable)
        {
            aiServerStatusContainer.Visible = true;
            lblAIServerStatus.Text = W("DSeekNoValidAIServer");
        }
        else
        {
            aiServerStatusContainer.Visible = false;
        }
    }

    private bool CheckAIServerAvailable()
    {
        try
        {
            string sql = "Select AIType, URL, AIKey, Model From T_AIInterface Where InUse = 'YES' ";
            DataSet ds = ShareClass.GetDataSetFromSql(sql, "T_AIInterface");
            if (ds.Tables[0].Rows.Count == 0) return false;

            _aiServerType = ds.Tables[0].Rows[0]["AIType"].ToString().Trim();
            _aiUrl = ds.Tables[0].Rows[0]["URL"].ToString().Trim();
            _aiModel = ds.Tables[0].Rows[0]["Model"].ToString().Trim();
            _aiApiKey = ds.Tables[0].Rows[0]["AIKey"].ToString().Trim();

            if (_aiServerType == "Local" || _aiServerType == "Outer")
                return !string.IsNullOrEmpty(_aiUrl) && !string.IsNullOrEmpty(_aiModel);
            return false;
        }
        catch { return false; }
    }

    // ═══════════════════ 简单聊天模式 ═══════════════════

    protected void btnGenerateText_Click(object sender, EventArgs e)
    {
        if (!_aiServerAvailable)
        {
            lblSimpleMsg.Text = W("DSeekAIServerNotAvailable");
            return;
        }

        string prompt = txtPrompt.Text.Trim();
        if (string.IsNullOrEmpty(prompt))
        {
            lblSimpleMsg.Text = W("DSeekPromptCantBeEmpty");
            return;
        }

        _generatedTextRaw = "";
        _lastChartOption = null;
        lblSimpleMsg.Text = "";

        try
        {
            // 智能判断：SQL 直接执行
            if (IsSqlQuery(prompt))
            {
                ExecuteSmartSql(prompt);
                return;
            }

            // 智能判断：自然语言数据查询 → NL2SQL + 结果展示
            if (IsNaturalLanguageQuery(prompt))
            {
                RunSmartNLQuery(prompt);
                return;
            }

            // 普通聊天
            string result = CallAIAPI(prompt);
            _generatedTextRaw = result;
            litSimpleResultContent.Text = FormatAnalysisContent(result);
            divSimpleResult.Visible = true;
            RegisterChartRender(result);
        }
        catch (Exception ex)
        {
            litSimpleResultContent.Text = FormatAnalysisContent(W("DSeekError") + ex.Message);
            divSimpleResult.Visible = true;
        }
        finally
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "hideLoading", "aiHideLoading();", true);
        }
    }

    // 智能 SQL 执行（简单模式）
    private void ExecuteSmartSql(string sql)
    {
        string upper = sql.ToUpperInvariant().Trim();
        if (!upper.StartsWith("SELECT") && !upper.StartsWith("SHOW") && !upper.StartsWith("DESCRIBE") && !upper.StartsWith("EXPLAIN") && !upper.StartsWith("WITH"))
        {
            litSimpleResultContent.Text = FormatAnalysisContent("为了安全，只允许执行 SELECT、SHOW、DESCRIBE、EXPLAIN、WITH 开头的查询语句。");
            divSimpleResult.Visible = true;
            return;
        }

        try
        {
            var ds = ShareClass.GetDataSetFromSql(sql, "QueryResult");
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                litSimpleResultContent.Text = FormatDataTableAsHtml(ds.Tables[0]);
            else
                litSimpleResultContent.Text = FormatAnalysisContent("查询未返回任何数据。");
        }
        catch (Exception ex)
        {
            litSimpleResultContent.Text = FormatAnalysisContent("SQL 执行失败：" + ex.Message);
        }
        divSimpleResult.Visible = true;
    }

    // 智能自然语言查询（简单模式）→ NL2SQL
    private void RunSmartNLQuery(string query)
    {
        var result = RunNL2SQL(query);
        if (result == null)
        {
            litSimpleResultContent.Text = FormatAnalysisContent("无法连接到 AI 服务，或没有可用的数据库表。");
            divSimpleResult.Visible = true;
            return;
        }

        if (result.Action == "sql" && !string.IsNullOrEmpty(result.Sql))
        {
            string sqlResult = ExecuteAndDisplayNL2SQL(result.Sql);
            _generatedTextRaw = sqlResult;
            litSimpleResultContent.Text = sqlResult;
            divSimpleResult.Visible = true;
        }
        else if (result.Action == "ask")
        {
            // 澄清
            _nl2sqlNeedClarification = true;
            _nl2sqlClarificationQuestion = string.IsNullOrEmpty(result.Question) ? "请补充要查询的表名或查询范围（我的/成员的/所有）" : result.Question;
            _nl2sqlClarificationOptions = result.Options ?? new List<string>();
            _pendingNLQuery = query;
            ShowClarification();
        }
        else
        {
            litSimpleResultContent.Text = FormatAnalysisContent("AI 未能理解您的查询，请尝试更具体的描述，或手动输入 SQL。");
            divSimpleResult.Visible = true;
        }
    }

    private void ShowClarification()
    {
        divClarification.Visible = true;
        lblClarifyQuestion.Text = _nl2sqlClarificationQuestion;
        divClarifyOptions.Controls.Clear();

        var html = new StringBuilder();
        foreach (var opt in _nl2sqlClarificationOptions)
        {
            string safe = opt.Replace("'", "\\'");
            html.Append("<button type='button' class='ai-btn' style='background:#4F46E5;color:white;font-size:12px;padding:6px 14px;border-radius:4px;' onclick=\"aiClarifyOption('" + safe + "')\">" + HttpUtility.HtmlEncode(opt) + "</button>");
        }
        divClarifyOptions.Controls.Add(new LiteralControl(html.ToString()));
        ScriptManager.RegisterStartupScript(this, GetType(), "clarify", "document.getElementById('" + divClarification.ClientID + "').scrollIntoView({behavior:'smooth'});", true);
    }

    protected void btnClarifyOption_Click(object sender, EventArgs e)
    {
        string answer = hfClarifyOption.Value;
        hfClarifyOption.Value = "";
        if (string.IsNullOrEmpty(answer)) return;
        AnswerClarification(answer);
    }

    protected void btnClarify_Click(object sender, EventArgs e)
    {
        string answer = txtClarifyAnswer.Text.Trim();
        if (string.IsNullOrEmpty(answer)) return;
        AnswerClarification(answer);
    }

    private void AnswerClarification(string answer)
    {
        string baseQuery = string.IsNullOrEmpty(_pendingNLQuery) ? txtPrompt.Text.Trim() : _pendingNLQuery;
        _pendingNLQuery = "";
        _nl2sqlNeedClarification = false;
        divClarification.Visible = false;
        txtClarifyAnswer.Text = "";

        var enrichedQuery = baseQuery + "\n(用户明确的查询范围: " + answer + ")";
        var result = RunNL2SQL(enrichedQuery);

        if (result != null && result.Action == "sql" && !string.IsNullOrEmpty(result.Sql))
        {
            litSimpleResultContent.Text = ExecuteAndDisplayNL2SQL(result.Sql);
        }
        else
        {
            litSimpleResultContent.Text = FormatAnalysisContent("仍无法生成SQL，请尝试更具体的描述。");
        }
        divSimpleResult.Visible = true;
    }

    protected void btnSaveEdit_Click(object sender, EventArgs e)
    {
        string edited = txtEditContent.Text;
        _generatedTextRaw = edited;
        litSimpleResultContent.Text = FormatAnalysisContent(Regex.Replace(edited, @"(\r?\n\s*){2,}", "\n"));
        ScriptManager.RegisterStartupScript(this, GetType(), "hideEdit", "document.getElementById('aiEditArea').style.display='none';", true);
    }

    // ═══════════════════ 数据分析模式 ═══════════════════

    protected void btnLoadSchema_Click(object sender, EventArgs e)
    {
        // 若为预览表操作
        if (hfPreviewAction.Value == "preview")
        {
            string table = hfPreviewTable.Value;
            hfPreviewAction.Value = "";
            hfPreviewTable.Value = "";
            ShowPreviewTable(table);
            return;
        }

        LoadSchema();
        RenderSchemaTree();
    }

    private void LoadSchema()
    {
        try
        {
            _schemas.Clear();
            string sql = @"SELECT table_schema, table_name, table_type
                FROM information_schema.tables
                WHERE table_schema NOT IN ('pg_catalog','information_schema','pg_toast')
                ORDER BY table_schema, table_type DESC, table_name";
            DataSet ds = ShareClass.GetDataSetFromSql(sql, "T");

            var grouped = ds.Tables[0].Rows.Cast<DataRow>()
                .GroupBy(r => E(r["table_schema"]))
                .OrderBy(g => g.Key);

            foreach (var g in grouped)
            {
                var sn = new SchemaNode { Name = g.Key, Expanded = _schemas.Count == 0 };
                foreach (var r in g)
                {
                    var name = E(r["table_name"]);
                    var full = g.Key + "." + name;
                    bool isView = string.Equals(E(r["table_type"]), "VIEW", StringComparison.OrdinalIgnoreCase);
                    var tn = new TableNode { Name = name, FullName = full, IsView = isView };
                    if (isView) sn.Views.Add(tn); else sn.Tables.Add(tn);
                }
                _schemas.Add(sn);
            }

            // 列信息
            string colSql = @"SELECT table_schema, table_name, column_name, data_type, is_nullable
                FROM information_schema.columns
                WHERE table_schema NOT IN ('pg_catalog','information_schema','pg_toast')
                ORDER BY table_schema, table_name, ordinal_position";
            DataSet colDs = ShareClass.GetDataSetFromSql(colSql, "C");
            var colLookup = colDs.Tables[0].Rows.Cast<DataRow>()
                .GroupBy(r => E(r["table_schema"]) + "." + E(r["table_name"]))
                .ToDictionary(g => g.Key, g => g.ToList());

            foreach (var sn in _schemas)
            {
                foreach (var tn in sn.Tables.Concat(sn.Views))
                {
                    List<DataRow> rows;
                    if (colLookup.TryGetValue(tn.FullName, out rows))
                    {
                        tn.Columns = rows.Select(r => new ColumnNode
                        {
                            Name = E(r["column_name"]),
                            DataType = E(r["data_type"]),
                            IsNullable = string.Equals(E(r["is_nullable"]), "YES", StringComparison.OrdinalIgnoreCase)
                        }).ToList();
                    }
                }
            }
            _schemaLoaded = true;
        }
        catch (Exception ex)
        {
            litSchemaTree.Text = "<div class='rptd-sidebar-msg'>" + W("JiaZaiShiBai") + ": " + HttpUtility.HtmlEncode(ex.Message) + "</div>";
        }
    }

    private bool MatchesFilter(TableNode t)
    {
        if (string.IsNullOrEmpty(txtSchemaFilter.Text.Trim())) return true;
        string f = txtSchemaFilter.Text.Trim();
        return t.Name.IndexOf(f, StringComparison.OrdinalIgnoreCase) >= 0
            || t.FullName.IndexOf(f, StringComparison.OrdinalIgnoreCase) >= 0
            || t.Columns.Any(c => c.Name.IndexOf(f, StringComparison.OrdinalIgnoreCase) >= 0);
    }

    private void RenderSchemaTree()
    {
        var sb = new StringBuilder();
        sb.Append("<div class='tree-schema'>");
        foreach (var s in _schemas)
        {
            string sid = "aiSchema_" + Math.Abs(s.Name.GetHashCode());
            sb.Append("<div class='tree-schema-header' onclick=\"aiToggleTree('" + sid + "')\">");
            sb.Append("<span style='width:16px;display:inline-block;'>" + (s.Expanded ? "▼" : "▶") + "</span>");
            sb.Append("<span>📦 " + HttpUtility.HtmlEncode(s.Name) + "</span></div>");
            sb.Append("<div id='" + sid + "' class='tree-children' style='display:" + (s.Expanded ? "block" : "none") + ";'>");

            var tbs = s.Tables.Where(MatchesFilter).ToList();
            var vws = s.Views.Where(MatchesFilter).ToList();
            if (tbs.Count > 0)
            {
                sb.Append("<div class='tree-type-label'>📋 " + W("Biao") + "</div>");
                foreach (var t in tbs) sb.Append(RenderTable(t));
            }
            if (vws.Count > 0)
            {
                sb.Append("<div class='tree-type-label'>👁 " + W("ShiTu") + "</div>");
                foreach (var v in vws) sb.Append(RenderTable(v));
            }
            sb.Append("</div>");
        }
        sb.Append("</div>");
        litSchemaTree.Text = sb.ToString();
    }

    private string RenderTable(TableNode t)
    {
        var sb = new StringBuilder();
        string tid = "aiTbl_" + Math.Abs(t.FullName.GetHashCode());
        string colId = "aiCols_" + Math.Abs(t.FullName.GetHashCode());
        sb.Append("<div class='tree-table' onclick=\"aiToggleTree('" + colId + "')\">");
        sb.Append("<span style='width:16px;display:inline-block;font-size:11px;'>" + (t.ColumnsExpanded ? "▼" : "▶") + "</span>");
        sb.Append("<span style='margin-right:4px;'>" + (t.IsView ? "👁" : "📋") + "</span>");
        sb.Append("<span class='tbl-name' title='" + HttpUtility.HtmlEncode(t.FullName) + "'>" + HttpUtility.HtmlEncode(t.Name) + "</span>");
        sb.Append("<span class='tbl-actions'>");
        sb.Append("<button type='button' class='act-btn' onclick=\"event.stopPropagation();aiInsertTable('" + HttpUtility.HtmlEncode(t.FullName) + "');\">SQL</button>");
        sb.Append("<button type='button' class='act-btn' onclick=\"event.stopPropagation();aiPreviewTable('" + HttpUtility.HtmlEncode(t.FullName) + "');\">" + W("YuLan") + "</button>");
        sb.Append("</span></div>");
        sb.Append("<div id='" + colId + "' class='tree-columns' style='display:none;'>");
        foreach (var c in t.Columns)
        {
            sb.Append("<div class='tree-col' onclick=\"aiInsertColumn('" + HttpUtility.HtmlEncode(c.Name) + "')\">");
            sb.Append("<span style='flex:1;'>" + HttpUtility.HtmlEncode(c.Name) + "</span>");
            sb.Append("<span class='col-type'>" + HttpUtility.HtmlEncode(c.DataType) + (c.IsNullable ? "" : "*") + "</span></div>");
        }
        sb.Append("</div>");
        return sb.ToString();
    }

    private void ShowPreviewTable(string fullName)
    {
        try
        {
            var parts = fullName.Split('.');
            string table = parts.Length > 1 ? parts[1] : parts[0];
            var ds = ShareClass.GetDataSetFromSql("SELECT * FROM " + table + " LIMIT 50", "P");
            litPreviewContent.Text = FormatDataTableAsHtml(ds.Tables[0]);
        }
        catch (Exception ex)
        {
            litPreviewContent.Text = "<div style='color:red;'>" + W("YuLanShiBai") + ": " + HttpUtility.HtmlEncode(ex.Message) + "</div>";
        }
        ScriptManager.RegisterStartupScript(this, GetType(), "openPreview", "aiOpenPreview();", true);
    }

    protected void btnExecuteSql_Click(object sender, EventArgs e)
    {
        string sql = txtSqlCode.Text.Trim();
        if (string.IsNullOrEmpty(sql))
        {
            RegisterToast(W("QingShuRuSQL"));
            return;
        }
        if (!IsReadOnlySelectQuery(sql))
        {
            RegisterToast("数据分析模块仅允许执行 SELECT 只读查询，禁止修改数据。");
            return;
        }
        try
        {
            var ds = ShareClass.GetDataSetFromSql(sql, "R");
            litPreviewContent.Text = FormatDataTableAsHtml(ds.Tables[0]);
        }
        catch (Exception ex)
        {
            litPreviewContent.Text = "<div style='color:red;'>" + W("SQLZhiXingShiBai") + ": " + HttpUtility.HtmlEncode(ex.Message) + "</div>";
        }
        ScriptManager.RegisterStartupScript(this, GetType(), "openPreview", "aiOpenPreview();", true);
    }

    protected void btnAiPost_Click(object sender, EventArgs e)
    {
        string action = hfPostAction.Value;
        hfPostAction.Value = "";
        string input = txtAiInput.Text.Trim();

        if (string.IsNullOrEmpty(input))
        {
            RegisterToast(W("QingShuRuSQLHuoXuQiu"));
            return;
        }

        if (action == "aiSql")
        {
            GenerateSqlFromAi(input);
        }
        else if (action == "aiReport")
        {
            GenerateReportFromAi(input);
        }
        else if (action == "aiSimpleChart")
        {
            // 简单模式图表（未使用，保留）
        }

        ScriptManager.RegisterStartupScript(this, GetType(), "closeAiDlg", "aiCloseDialog();aiHideLoading();", true);
    }

    // AI 生成 SQL（分析模式对话框）
    private void GenerateSqlFromAi(string input)
    {
        string upper = input.ToUpper().TrimStart();
        string sql = "";
        if (upper.StartsWith("SELECT") || upper.StartsWith("WITH") || upper.StartsWith("INSERT") || upper.StartsWith("UPDATE") || upper.StartsWith("DELETE"))
        {
            int idx = upper.IndexOf("SELECT");
            string sqlPart = input.Substring(idx).Trim();
            int endIdx = sqlPart.Length;
            for (int i = 0; i < sqlPart.Length; i++)
            {
                char ch = sqlPart[i];
                if (ch >= 0x4e00 && ch <= 0x9fff) { endIdx = i; break; }
            }
            sql = sqlPart.Substring(0, endIdx).TrimEnd(',', ' ');
        }
        else
        {
            sql = GenerateSqlFromNaturalLanguage(input);
        }

        if (string.IsNullOrWhiteSpace(sql))
        {
            RegisterToast("未能生成SQL，请尝试更具体的描述，如：按项目类型统计项目额");
            return;
        }

        txtSqlCode.Text = sql;
        txtReportCode.Text = "";
        RegisterToast(W("SQLYiShengCheng"));
    }

    // AI 生成报表（分析模式对话框）
    private void GenerateReportFromAi(string input)
    {
        string sql = "";
        string upper = input.ToUpper();
        if (upper.Contains("SELECT") || upper.Contains("WITH"))
        {
            int idx = upper.IndexOf("SELECT");
            if (idx < 0) idx = upper.IndexOf("WITH");
            string sqlPart = input.Substring(idx).Trim();
            int endIdx = sqlPart.Length;
            for (int i = 0; i < sqlPart.Length; i++)
            {
                char ch = sqlPart[i];
                if (ch >= 0x4e00 && ch <= 0x9fff) { endIdx = i; break; }
            }
            sql = sqlPart.Substring(0, endIdx).TrimEnd(',', ' ');
        }

        if (string.IsNullOrWhiteSpace(sql))
        {
            sql = GenerateSqlFromNaturalLanguage(input);
        }
        if (string.IsNullOrWhiteSpace(sql))
        {
            RegisterToast("未能生成SQL，请尝试更具体的描述，如：按项目类型统计项目额");
            return;
        }
        if (!IsReadOnlySelectQuery(sql))
        {
            RegisterToast("数据分析模块仅允许执行 SELECT 只读查询，禁止修改数据。");
            return;
        }

        string chartType = DetectChartType(input);
        // 参考新版：输入包含 表格/明细/数据 时附加统计表格；包含 汇总/总结/分析 时附加数据汇总
        bool addTable = input.Contains("表格") || input.Contains("明细") || input.Contains("数据");
        bool addSummary = input.Contains("汇总") || input.Contains("总结") || input.Contains("分析");
        try
        {
            var ds = ShareClass.GetDataSetFromSql(sql, "R");
            var table = ds.Tables[0];
            var cols = table.Columns.Cast<DataColumn>().Select(c => c.ColumnName).ToList();
            var rows = table.Rows.Cast<DataRow>()
                .Select(r => cols.ToDictionary(c => c, c => E(r[c])))
                .ToList();

            if (rows.Count == 0) { RegisterToast(W("ChaXunJieGuoWeiKong")); return; }
            var catCol = cols[0];
            var valCol = cols.Count >= 2 ? cols[1] : cols[0];
            var values = new List<double>();
            foreach (var r in rows)
            {
                double v;
                values.Add(double.TryParse(r[valCol], out v) ? v : 0.0);
            }

            var sb = new StringBuilder();
            sb.AppendLine("<div id='chart' style='width:100%;height:400px;'></div>");
            sb.AppendLine("<script>");
            sb.AppendLine("var chart = echarts.init(document.getElementById('chart'));");
            sb.AppendLine("chart.setOption(" + BuildChartOption(chartType, rows, catCol, valCol, values) + ");");
            sb.AppendLine("</script>");

            // 统计表格（参考新版）
            if (addTable)
            {
                sb.AppendLine("<div style='margin-top:20px;'>");
                sb.AppendLine("<table style='width:100%;border-collapse:collapse;background:white;border-radius:8px;overflow:hidden;box-shadow:0 2px 10px rgba(0,0,0,0.1);'>");
                sb.AppendLine("<thead><tr class=\"aiha-hrow\">");
                sb.Append("<th style='background:#3e526c;color:white;padding:10px 15px;text-align:left;'>" + Js(catCol) + "</th>");
                sb.Append("<th style='background:#3e526c;color:white;padding:10px 15px;text-align:right;'>" + Js(valCol) + "</th>");
                sb.AppendLine("<th style='background:#3e526c;color:white;padding:10px 15px;text-align:right;'>" + W("ZhanBi") + "</th>");
                sb.AppendLine("</tr></thead><tbody>");
                double total = values.Sum();
                foreach (var r in rows)
                {
                    var cat = r[catCol] ?? "";
                    var val = r[valCol] ?? "0";
                    double dv;
                    double.TryParse(val, out dv);
                    string pct = total > 0 ? (dv / total * 100).ToString("F1") : "0";
                    sb.Append("<tr><td style='padding:8px 15px;border-bottom:1px solid #eee;'>" + Js(cat) + "</td>");
                    sb.Append("<td style='padding:8px 15px;border-bottom:1px solid #eee;text-align:right;'>" + Js(val) + "</td>");
                    sb.Append("<td style='padding:8px 15px;border-bottom:1px solid #eee;text-align:right;'>" + pct + "%</td></tr>");
                }
                sb.AppendLine("</tbody></table></div>");
            }

            // 数据汇总（参考新版）
            if (addSummary)
            {
                double total = values.Sum();
                double maxVal = values.Max();
                int maxIdx = values.IndexOf(maxVal);
                string maxCat = (maxIdx >= 0 && maxIdx < rows.Count) ? (rows[maxIdx][catCol] ?? "") : "";
                sb.AppendLine("<div style='margin-top:20px;padding:15px;background:#f0f9ff;border-left:4px solid #3e526c;border-radius:4px;'>");
                sb.AppendLine("<strong>" + W("ShuJuHuiZong") + "</strong><br/>");
                sb.AppendLine(W("ZongJi") + "：" + total + " | " + W("ZuiDaZhi") + "：" + Js(maxCat) + " (" + maxVal + ") | " + W("ShuJuTiaoShu") + "：" + rows.Count);
                sb.AppendLine("</div>");
            }

            txtSqlCode.Text = sql;
            txtReportCode.Text = sb.ToString();
            RegisterToast(W("SQLHeBaoBiaoYiShengCheng"));
        }
        catch (Exception ex)
        {
            RegisterToast(W("SQLZhiXingShiBai") + ": " + ex.Message);
        }
    }

    private void RegisterToast(string msg)
    {
        string safe = msg.Replace("'", "\\'");
        ScriptManager.RegisterStartupScript(this, GetType(), "toast_" + Guid.NewGuid().ToString("N").Substring(0, 6),
            "aiToast('" + safe + "');", true);
    }

    // ═══════════════════ NL2SQL ═══════════════════

    private class NL2SQLResult
    {
        public string Action = "";
        public string Sql = "";
        public string Explanation = "";
        public string Question = "";
        public List<string> Options = new List<string>();
    }

    private bool IsSqlQuery(string input)
    {
        if (string.IsNullOrWhiteSpace(input)) return false;
        string upper = input.ToUpperInvariant().Trim();
        return upper.StartsWith("SELECT") || upper.StartsWith("SHOW") || upper.StartsWith("DESCRIBE")
            || upper.StartsWith("EXPLAIN") || upper.StartsWith("WITH");
    }

    private bool IsNaturalLanguageQuery(string input)
    {
        if (string.IsNullOrWhiteSpace(input)) return false;
        if (input.Length > 200) return false;
        string lower = input.ToLower();
        string[] keywords = { "查", "多少", "统计", "列出", "显示", "汇总", "count", "sum", "list", "show", "find", "几个", "哪些", "总共", "总计", "平均", "最大", "最小", "数量" };
        return keywords.Any(k => lower.Contains(k));
    }

    private NL2SQLResult RunNL2SQL(string query)
    {
        if (!_aiServerAvailable) return null;

        try
        {
            string tableNames = GetAvailableTables();
            if (string.IsNullOrEmpty(tableNames)) return null;

            string schemaContext = LoadDatabaseSchemaForNL2SQL();
            string bizContext = BuildBusinessLogicContext(tableNames.Split(',').ToList(), query);

            string prompt = BuildNL2SQLPrompt(query, schemaContext, bizContext);
            string response = CallAIAPI(prompt, 0.3);

            return ParseNL2SQLResponse(response);
        }
        catch { return null; }
    }

    private string GetAvailableTables()
    {
        try
        {
            EnsureTablesExist();
            DataSet ds = ShareClass.GetDataSetFromSql(
                "SELECT TableName FROM T_DBTablesForAI WHERE IsActive = true ORDER BY TableName", "T_DBTablesForAI");
            var names = new List<string>();
            foreach (DataRow r in ds.Tables[0].Rows)
            {
                string n = r["TableName"].ToString();
                if (string.IsNullOrWhiteSpace(n)) continue;
                if (n.IndexOf("T_DBTablesForAI", StringComparison.OrdinalIgnoreCase) >= 0) continue;
                if (n.IndexOf("T_AnalysisHistory", StringComparison.OrdinalIgnoreCase) >= 0) continue;
                names.Add(n.Trim());
            }
            return string.Join(",", names);
        }
        catch { return ""; }
    }

    private string BuildNL2SQLPrompt(string query, string schemaContext, string bizContext)
    {
        var sb = new StringBuilder();
        sb.AppendLine("你是 PostgreSQL 数据库的自然语言转 SQL 助手。");
        sb.AppendLine();
        sb.AppendLine("# 数据库表结构（包含字段中文含义和业务说明）");
        if (string.IsNullOrEmpty(schemaContext)) sb.AppendLine("（未获取到完整表结构，请基于字段语义判断）");
        else sb.AppendLine(schemaContext);
        sb.AppendLine();
        if (!string.IsNullOrEmpty(bizContext)) { sb.AppendLine(bizContext); sb.AppendLine(); }
        sb.AppendLine("# 用户查询");
        sb.AppendLine(query);
        sb.AppendLine();
        sb.AppendLine("# 你的任务");
        sb.AppendLine("1. 阅读「中文含义」列理解字段用途，结合业务逻辑理解状态流转和统计口径");
        sb.AppendLine("2. 将用户查询关键词匹配到字段中文含义");
        sb.AppendLine("3. 生成正确的 SQL 语句");
        sb.AppendLine();
        sb.AppendLine("# 第一步：判断查询的业务范围（必须执行）");
        sb.AppendLine("系统内业务数据分三种查询范围：「我的/我参与的」、「成员的/部门成员的」、「所有/全部」。");
        sb.AppendLine("若用户查询未明确说明范围（如只说「项目的完成率」），则必须返回 action:\"ask\" 反问用户明确范围，options 列出三种选项。");
        sb.AppendLine("若用户已明确范围（包含「我的」「我参与」「所有」「全部」「成员」「部门」等词），直接生成 SQL。");
        sb.AppendLine();
        sb.AppendLine("# 第二步：生成 SQL（仅当范围已明确）");
        sb.AppendLine("- 只生成 SELECT 查询，列名和表名严格使用实际名称");
        sb.AppendLine("- 查询「我的/我参与的」：按业务归属字段（CreatorCode/OperatorCode/PMCode 等）过滤当前用户");
        sb.AppendLine("- 查询「所有」：不加个人归属过滤");
        sb.AppendLine();
        sb.AppendLine("# 响应格式（严格 JSON，只返回JSON）");
        sb.AppendLine("{");
        sb.AppendLine("  \"action\": \"ask\" | \"sql\",");
        sb.AppendLine("  \"question\": \"（仅当 action=ask 时）\",");
        sb.AppendLine("  \"options\": [\"我的数据\", \"部门/成员的\", \"所有数据\"],");
        sb.AppendLine("  \"sql\": \"（仅当 action=sql 时）SELECT ...\",");
        sb.AppendLine("  \"explanation\": \"说明选择的表和字段依据\"");
        sb.AppendLine("}");
        return sb.ToString();
    }

    private NL2SQLResult ParseNL2SQLResponse(string response)
    {
        var result = new NL2SQLResult();
        try
        {
            response = response.Trim();
            if (response.StartsWith("```"))
            {
                int start = response.IndexOf('\n');
                int end = response.LastIndexOf("```");
                if (start >= 0 && end > start) response = response.Substring(start + 1, end - start - 1).Trim();
            }
            // 提取 JSON 部分
            int jsStart = response.IndexOf('{');
            int jsEnd = response.LastIndexOf('}');
            if (jsStart >= 0 && jsEnd > jsStart) response = response.Substring(jsStart, jsEnd - jsStart + 1);

            var jss = new JavaScriptSerializer();
            var dict = jss.Deserialize<Dictionary<string, object>>(response);
            if (dict == null) return new NL2SQLResult { Action = "error" };

            result.Action = dict.ContainsKey("action") ? dict["action"].ToString() : "error";
            if (result.Action == "sql")
            {
                if (dict.ContainsKey("sql")) result.Sql = dict["sql"].ToString();
                if (dict.ContainsKey("explanation") && dict["explanation"] != null) result.Explanation = dict["explanation"].ToString();
            }
            else if (result.Action == "ask")
            {
                if (dict.ContainsKey("question") && dict["question"] != null) result.Question = dict["question"].ToString();
                var arr = dict.ContainsKey("options") ? dict["options"] as System.Collections.ArrayList : null;
                if (arr != null)
                {
                    foreach (var o in arr) result.Options.Add(o.ToString());
                }
            }
            return result;
        }
        catch { return new NL2SQLResult { Action = "error" }; }
    }

    private string ExecuteAndDisplayNL2SQL(string sql)
    {
        string upper = sql.ToUpperInvariant().Trim();
        if (!upper.StartsWith("SELECT") && !upper.StartsWith("SHOW") && !upper.StartsWith("DESCRIBE") && !upper.StartsWith("EXPLAIN") && !upper.StartsWith("WITH"))
        {
            return FormatAnalysisContent("安全限制：AI 生成的 SQL 不是合法的只读查询，已阻止执行。");
        }
        try
        {
            var ds = ShareClass.GetDataSetFromSql(sql, "NL2SQLResult");
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                return FormatDataTableAsHtml(ds.Tables[0]);
            return FormatAnalysisContent("查询未返回任何数据。");
        }
        catch (Exception ex)
        {
            return FormatAnalysisContent("SQL 执行失败：" + ex.Message);
        }
    }

    private string LoadDatabaseSchemaForNL2SQL()
    {
        try
        {
            string path = Server.MapPath("~/AIFile/DatabaseSchema.md");
            if (!File.Exists(path)) return "";
            string content = File.ReadAllText(path, Encoding.UTF8);

            var sb = new StringBuilder();
            sb.AppendLine("# 表字段中文含义参考");
            string[] keyTables = { "T_Project", "T_ProjectMember", "T_Task", "T_ProjectTask", "T_TaskAssignRecord",
                "T_Constract", "T_WorkFlow", "T_WorkFlowTemplate", "T_Plan", "T_Goods", "T_Asset", "T_Requirement", "T_Defectment" };
            foreach (var tn in keyTables)
            {
                string pattern = "### " + tn;
                int idx = content.IndexOf(pattern, StringComparison.OrdinalIgnoreCase);
                if (idx < 0) continue;
                int endIdx = content.IndexOf("\n### ", idx + pattern.Length);
                if (endIdx < 0) endIdx = content.IndexOf("\n---", idx + pattern.Length);
                if (endIdx < 0) endIdx = Math.Min(idx + 2000, content.Length);
                string tableDef = content.Substring(idx, endIdx - idx).Trim();
                int tableStart = tableDef.IndexOf("| 字段名");
                if (tableStart >= 0)
                {
                    int tableEnd = tableDef.IndexOf("\n\n", tableStart);
                    if (tableEnd < 0) tableEnd = tableDef.Length;
                    sb.AppendLine(tableDef.Substring(tableStart, tableEnd - tableStart));
                    sb.AppendLine();
                }
            }
            return sb.ToString();
        }
        catch { return ""; }
    }

    private string BuildBusinessLogicContext(List<string> tables, string userQuery)
    {
        try
        {
            string dir = Server.MapPath("~/Source");
            if (!Directory.Exists(dir)) return "";

            var queryLower = (userQuery ?? "").ToLowerInvariant();
            var pageNames = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            var keywordPages = new Dictionary<string[], string[]>()
            {
                { new[]{ "工作流", "审批", "workflow", "approval", "完成率" }, new[]{ "TTWLManage", "TTMyWorkDetailMain", "TTAllWorkFlow", "TTMyWorkFlowDetail", "TTWorkFlowDetailMain", "TTWorkFlowViewMain" } },
                { new[]{ "采购", "purchase", "采购单" }, new[]{ "TTGoodsPurchaseOrder", "TTGoodsPurchaseOrderDetail" } },
                { new[]{ "入库", "checkin", "收货" }, new[]{ "TTGoodsCheckInOrder", "TTGoodsCheckInOrderView" } },
                { new[]{ "项目", "project", "立项", "预算", "进度" }, new[]{ "TTProjectDetail", "TTMakeProject", "TTProjectTaskDetail", "TTProjectBudget" } },
                { new[]{ "合同", "constract", "contract" }, new[]{ "TTConstractDetail", "TTConstractManage" } },
                { new[]{ "资产", "asset" }, new[]{ "TTAssetDetail", "TTAssetManage" } },
                { new[]{ "需求", "requirement", "req" }, new[]{ "TTReqDetail", "TTProjectRelatedReqMain" } },
                { new[]{ "缺陷", "defect" }, new[]{ "TTDefectDetail", "TTProjectRelatedDefectMain" } },
            };

            foreach (var kv in keywordPages)
            {
                bool hit = kv.Key.Any(k => queryLower.Contains(k.ToLowerInvariant()))
                    || tables.Any(t => kv.Key.Any(k => t.ToLowerInvariant().Contains(k.ToLowerInvariant())));
                if (hit) foreach (var p in kv.Value) pageNames.Add(p);
            }

            if (pageNames.Count == 0)
            {
                var allPages = Directory.GetFiles(dir, "*.razor").Select(Path.GetFileNameWithoutExtension).ToList();
                foreach (var table in tables)
                {
                    string frag = table.Replace("T_", "");
                    var matched = allPages.Where(p => p.IndexOf(frag, StringComparison.OrdinalIgnoreCase) >= 0).Take(3);
                    foreach (var p in matched) pageNames.Add(p);
                }
            }

            var sb = new StringBuilder();
            sb.AppendLine("# 业务逻辑上下文（来自系统页面源码）");
            int extracted = 0;
            foreach (var page in pageNames.Take(4))
            {
                string filePath = Path.Combine(dir, page + ".razor");
                if (!File.Exists(filePath)) continue;
                string content = File.ReadAllText(filePath, Encoding.UTF8);
                if (string.IsNullOrWhiteSpace(content)) continue;

                var pageSb = new StringBuilder();
                pageSb.AppendLine("## 页面：" + page);

                var sqlRegex = new Regex(@"(?i)\b(?:SELECT|UPDATE|INSERT|DELETE|WITH)\b.{0,100}\bFROM\s+T_[A-Za-z0-9_]+.{0,220}", RegexOptions.Singleline);
                int sqlCount = 0;
                foreach (Match m in sqlRegex.Matches(content))
                {
                    if (sqlCount >= 5) break;
                    string frag = Regex.Replace(m.Value, @"\s+", " ").Trim();
                    if (frag.Length > 8 && !frag.Contains("@onclick") && !frag.Contains("@bind"))
                    { pageSb.AppendLine("  - SQL: " + frag.Substring(0, Math.Min(150, frag.Length))); sqlCount++; }
                }

                var stateRegex = new Regex(@"(?i)\b[A-Za-z][A-Za-z0-9_]*\s*==\s*[""'](?:Passed|CaseClosed|Rejected|Closed|Complete|Completed|Done|Approved|InProgress|ToHandle|New|Pause|Stop|Finished|Accepted)[^""']*[""']", RegexOptions.Singleline);
                int stCount = 0;
                foreach (Match m in stateRegex.Matches(content))
                {
                    if (stCount >= 6) break;
                    string frag = Regex.Replace(m.Value, @"\s+", " ").Trim();
                    if (frag.Length > 3) { pageSb.AppendLine("  - 状态判定: " + frag.Substring(0, Math.Min(100, frag.Length))); stCount++; }
                }

                if (sqlCount > 0 || stCount > 0) { sb.AppendLine(pageSb.ToString()); extracted++; }
                if (extracted >= 3) break;
            }
            if (sb.Length <= 10) return "";
            sb.AppendLine();
            sb.AppendLine("注意：请结合以上业务逻辑和表结构，生成符合系统实际业务规则的 SQL。");
            return sb.ToString();
        }
        catch { return ""; }
    }

    // ═══════════════════ AI 调用 ═══════════════════

    private string CallAIAPI(string prompt, double temperature = 0.7)
    {
        using (HttpClient client = new HttpClient())
        {
            client.Timeout = TimeSpan.FromSeconds(300);
            if (_aiServerType == "Outer" && !string.IsNullOrEmpty(_aiApiKey))
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " + _aiApiKey);

            var body = new
            {
                model = _aiModel,
                messages = new[] { new { role = "user", content = prompt } },
                stream = false,
                temperature = temperature,
                max_tokens = 4000
            };

            string json = JsonConvert.SerializeObject(body);
            HttpContent content = new StringContent(json, Encoding.UTF8, "application/json");
            HttpResponseMessage response = client.PostAsync(_aiUrl, content).Result;

            if (response.IsSuccessStatusCode)
            {
                string jsonString = response.Content.ReadAsStringAsync().Result;
                dynamic data = JsonConvert.DeserializeObject(jsonString);
                string result = "";
                if (data.choices != null && data.choices.Count > 0 && data.choices[0].message != null && data.choices[0].message.content != null)
                    result = data.choices[0].message.content.ToString();
                else if (data.response != null) result = data.response.ToString();
                else if (data.content != null) result = data.content.ToString();
                else result = W("DSeekCouldNotParseResponseFromAI");
                return CleanAndFormatResult(result);
            }
            else
            {
                string err = response.Content.ReadAsStringAsync().Result;
                return W("DSeekAPICallFailedWithStatus") + (int)response.StatusCode + ". " + W("DSeekResponse") + err;
            }
        }
    }

    // ═══════════════════ 确定性 NL2SQL（参考新版 AIAgentService，基于 DatabaseSchema.md 中文匹配）═══════════════════

    private class SchemaColumnInfo
    {
        public string TableName = "";
        public string ColumnName = "";
        public string Type = "";
        public string ChineseName = "";
        public string Description = "";
    }

    private class SchemaTableInfo
    {
        public string TableName = "";
        public string Description = "";
        public Dictionary<string, SchemaColumnInfo> Columns = new Dictionary<string, SchemaColumnInfo>(StringComparer.OrdinalIgnoreCase);
    }

    private static readonly object _detSchemaLock = new object();
    private static bool _detSchemaLoaded = false;
    private static Dictionary<string, SchemaTableInfo> _detSchemaCache = new Dictionary<string, SchemaTableInfo>(StringComparer.OrdinalIgnoreCase);

    private void LoadSchemaForDeterministic()
    {
        if (_detSchemaLoaded) return;
        lock (_detSchemaLock)
        {
            if (_detSchemaLoaded) return;
            try
            {
                string path = Server.MapPath("~/AIFile/DatabaseSchema.md");
                if (!File.Exists(path)) { _detSchemaLoaded = true; return; }
                string content = File.ReadAllText(path, Encoding.UTF8);
                string[] lines = content.Split('\n');
                SchemaTableInfo currentTable = null;
                foreach (string rawLine in lines)
                {
                    string line = rawLine.TrimEnd('\r');
                    Match tableMatch = Regex.Match(line, @"^###\s+(T_\w+)[（(（]([^）)]+)[）)）]");
                    if (tableMatch.Success)
                    {
                        SchemaTableInfo t = new SchemaTableInfo();
                        t.TableName = tableMatch.Groups[1].Value;
                        t.Description = tableMatch.Groups[2].Value.Trim();
                        if (_detSchemaCache.ContainsKey(t.TableName)) _detSchemaCache[t.TableName] = t;
                        else _detSchemaCache.Add(t.TableName, t);
                        currentTable = t;
                        continue;
                    }
                    if (line.Contains("|") && currentTable != null)
                    {
                        string[] parts = line.Split(new[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
                        if (parts.Length >= 3 && !parts[0].Trim().Contains("字段"))
                        {
                            string colName = parts[0].Trim();
                            string colType = parts[1].Trim();
                            string colChinese = parts[2].Trim();
                            if (!string.IsNullOrEmpty(colName) && colName != "---" && !colName.StartsWith("-"))
                            {
                                SchemaColumnInfo col = new SchemaColumnInfo();
                                col.ColumnName = colName;
                                col.Type = colType;
                                col.ChineseName = colChinese;
                                col.Description = parts.Length >= 4 ? parts[3].Trim() : "";
                                col.TableName = currentTable.TableName;
                                if (currentTable.Columns.ContainsKey(colName)) currentTable.Columns[colName] = col;
                                else currentTable.Columns.Add(colName, col);
                            }
                        }
                    }
                }
            }
            catch { }
            _detSchemaLoaded = true;
        }
    }

    private SchemaColumnInfo FindColumnByChinese(string chineseName)
    {
        LoadSchemaForDeterministic();
        // 精确匹配
        foreach (var table in _detSchemaCache.Values)
            foreach (var col in table.Columns.Values)
                if (col.ChineseName == chineseName) return col;
        // 包含匹配（优先表描述/表名含关键词）
        if (chineseName.Length >= 2)
        {
            string keyword = chineseName.Substring(0, 2);
            foreach (var table in _detSchemaCache.Values)
                foreach (var col in table.Columns.Values)
                    if (col.ChineseName.Contains(chineseName) || chineseName.Contains(col.ChineseName))
                        if (table.Description.Contains(keyword) || table.TableName.ToLower().Contains(keyword))
                            return col;
        }
        // 包含匹配（不限制表名）
        foreach (var table in _detSchemaCache.Values)
            foreach (var col in table.Columns.Values)
                if (col.ChineseName.Contains(chineseName) || chineseName.Contains(col.ChineseName))
                    return col;
        // 模糊匹配：末字/前缀评分
        if (chineseName.Length >= 2)
        {
            char lastChar = chineseName[chineseName.Length - 1];
            string prefix = chineseName.Substring(0, 2);
            SchemaColumnInfo best = null;
            int bestScore = -1;
            foreach (var table in _detSchemaCache.Values)
            {
                foreach (var col in table.Columns.Values)
                {
                    if (!col.ChineseName.StartsWith(prefix)) continue;
                    int score = 0;
                    if (col.ChineseName.Length > 0 && col.ChineseName[col.ChineseName.Length - 1] == lastChar) score += 10;
                    int lenDiff = Math.Abs(col.ChineseName.Length - chineseName.Length);
                    score += (5 - lenDiff);
                    if (score > bestScore) { bestScore = score; best = col; }
                }
            }
            if (best != null) return best;
        }
        return null;
    }

    private bool TryGenerateDeterministicSql(string input, out string sql)
    {
        sql = "";
        if (string.IsNullOrEmpty(input)) return false;
        Match match = Regex.Match(input.Trim(), @"按(.+?)(?:统计|汇总|合计)(.+)");
        if (!match.Success) return false;

        string dimRaw = match.Groups[1].Value.Trim();
        string metricRaw = match.Groups[2].Value.Trim();
        string metricClean = Regex.Replace(metricRaw, @"[，,]\s*以.+?(?:图|表).*|，.+?图.*", "").Trim();
        if (string.IsNullOrEmpty(metricClean)) metricClean = metricRaw;

        SchemaColumnInfo dim = FindColumnByChinese(dimRaw);
        if (dim == null) return false;

        SchemaColumnInfo metric = FindColumnByChinese(metricClean);
        string aggregation = "COUNT";
        string metricCol = "*";
        string metricLabel = metricClean;
        if (metric != null)
        {
            string colType = (metric.Type ?? "").ToLower();
            if (colType.Contains("numeric") || colType.Contains("integer") || colType.Contains("int") || colType.Contains("decimal"))
                aggregation = "SUM";
            metricCol = metric.ColumnName;
            metricLabel = metric.ChineseName;
            // 标签优先用业务说明中的完整词（如 "预算金额"），否则用中文名
            if (!string.IsNullOrEmpty(metric.Description) && metric.Description.Length >= 2
                && metricClean.Contains(metric.Description))
                metricLabel = metric.Description;
            if (metric.TableName != dim.TableName)
            {
                aggregation = "COUNT";
                metricCol = "*";
                metricLabel = metricClean;
            }
        }

        string selectMetric = metricCol == "*" ? "COUNT(*)" : aggregation + "(" + metricCol + ")";
        sql = "SELECT " + dim.ColumnName + " AS \"" + dim.ChineseName + "\", " + selectMetric + " AS \"" + metricLabel + "\" FROM " + dim.TableName + " GROUP BY " + dim.ColumnName + " ORDER BY " + selectMetric + " DESC";
        return true;
    }

    // AI 生成 SQL（基于 DatabaseSchema.md 中文含义匹配）
    private string GenerateSqlFromNaturalLanguage(string input)
    {
        // 优先使用确定性生成器（按X统计/汇总Y模式，避免 LLM 选错表/字段）
        try
        {
            string deterministicSql;
            if (TryGenerateDeterministicSql(input, out deterministicSql))
                return deterministicSql;
        }
        catch { }

        try
        {
            string schemaContext = LoadDatabaseSchemaForNL2SQL();
            string bizContext = BuildBusinessLogicContext(GetAvailableTables().Split(',').ToList(), input);
            var prompt = new StringBuilder();
            prompt.AppendLine("你是 PostgreSQL 数据库的 SQL 生成助手。");
            prompt.AppendLine("# 表结构（含中文含义）");
            if (!string.IsNullOrEmpty(schemaContext)) prompt.AppendLine(schemaContext);
            else prompt.AppendLine("（无完整表结构，请基于字段语义判断）");
            if (!string.IsNullOrEmpty(bizContext)) { prompt.AppendLine(bizContext); }
            prompt.AppendLine();
            prompt.AppendLine("# 用户需求");
            prompt.AppendLine(input);
            prompt.AppendLine();
            prompt.AppendLine("# 请只生成一条 PostgreSQL SELECT 语句，不要解释，不要 Markdown 代码块，直接输出 SQL。");
            prompt.AppendLine("列名和表名必须使用数据库实际名称，结合「中文含义」列匹配字段。");
            string resp = CallAIAPI(prompt.ToString(), 0.2).Trim();
            resp = Regex.Replace(resp, @"^```(sql)?", "", RegexOptions.IgnoreCase).Trim();
            resp = resp.TrimEnd('`').Trim();
            return resp;
        }
        catch { return ""; }
    }

    // ═══════════════════ 图表/格式化 ═══════════════════

    private void RegisterChartRender(string result)
    {
        string chartType = DetectChartType(result);
        if (string.IsNullOrEmpty(chartType)) return;

        // 简单模式下暂不渲染图表（无SQL数据），仅保留扩展点
    }

    private string DetectChartType(string userMessage)
    {
        var m = (userMessage ?? "").ToLower();
        if (m.Contains("圈图") || m.Contains("ring") || m.Contains("环形") || m.Contains("圆环")) return "ring";
        if (m.Contains("饼图") || m.Contains("pie")) return "pie";
        if (m.Contains("柱状") || m.Contains("bar") || m.Contains("条形")) return "bar";
        if (m.Contains("折线") || m.Contains("line") || m.Contains("曲线")) return "line";
        if (m.Contains("雷达") || m.Contains("radar")) return "radar";
        if (m.Contains("仪表盘") || m.Contains("gauge")) return "gauge";
        if (m.Contains("漏斗") || m.Contains("funnel")) return "funnel";
        if (m.Contains("树图") || m.Contains("树形") || m.Contains("treemap") || m.Contains("层级")) return "treemap";
        if (m.Contains("热力") || m.Contains("heatmap") || m.Contains("矩阵")) return "heatmap";
        if (m.Contains("散点") || m.Contains("scatter") || m.Contains("分布")) return "scatter";
        return "";
    }

    // 生成 ECharts 配置（参考新版 AIAgentService.BuildStatisticsResponseAsync，支持全部图表类型）
    private string BuildChartOption(string chartType, List<Dictionary<string, string>> rows, string catCol, string valCol, List<double> values)
    {
        var cats = rows.Select(r => Js(r[catCol] ?? "")).ToList();
        var vals = rows.Select(r => r[valCol] ?? "0").ToList();
        var sb = new StringBuilder();

        if (chartType == "pie" || chartType == "ring")
        {
            string radius = chartType == "ring" ? " radius:['40%','70%']," : "";
            sb.Append("{ tooltip:{trigger:'item',formatter:'{b}: {c} ({d}%)'},");
            sb.Append(" series:[{ type:'pie'," + radius + " data:[");
            for (int i = 0; i < rows.Count; i++)
                sb.Append("{ value:" + vals[i] + ", name:'" + cats[i] + "' }" + (i < rows.Count - 1 ? "," : ""));
            sb.Append("], label:{show:true,formatter:'{b}\\n{c}'} }] }");
        }
        else if (chartType == "bar")
        {
            sb.Append("{ tooltip:{trigger:'axis'}, grid:{left:'3%',right:'4%',bottom:'12%',containLabel:true}, xAxis:{type:'category',data:[" + string.Join(",", cats.Select(c => "'" + c + "'")) + "],axisLabel:{rotate:30}}, yAxis:{type:'value'}, series:[{type:'bar',data:[" + string.Join(",", vals) + "],itemStyle:{color:'#4F46E5'}}] }");
        }
        else if (chartType == "line")
        {
            sb.Append("{ tooltip:{trigger:'axis'}, grid:{left:'3%',right:'4%',bottom:'12%',containLabel:true}, xAxis:{type:'category',data:[" + string.Join(",", cats.Select(c => "'" + c + "'")) + "]}, yAxis:{type:'value'}, series:[{type:'line',data:[" + string.Join(",", vals) + "],smooth:true,itemStyle:{color:'#4F46E5'},areaStyle:{opacity:0.3}}] }");
        }
        else if (chartType == "scatter")
        {
            var scatterData = new List<string>();
            for (int i = 0; i < rows.Count; i++) scatterData.Add("[" + i + "," + vals[i] + "]");
            sb.Append("{ tooltip:{trigger:'item',formatter:'{b}: {c}'}, grid:{left:'3%',right:'4%',bottom:'12%',containLabel:true}, xAxis:{type:'category',data:[" + string.Join(",", cats.Select(c => "'" + c + "'")) + "]}, yAxis:{type:'value'}, series:[{type:'scatter',data:[" + string.Join(",", scatterData) + "],symbolSize:12,itemStyle:{color:'#4F46E5'}}] }");
        }
        else if (chartType == "funnel")
        {
            sb.Append("{ tooltip:{trigger:'item'}, series:[{ type:'funnel', left:'10%', width:'80%', data:[");
            for (int i = 0; i < rows.Count; i++)
                sb.Append("{ name:'" + cats[i] + "', value:" + vals[i] + " }" + (i < rows.Count - 1 ? "," : ""));
            sb.Append("], label:{show:true,formatter:'{b}: {c}'} }] }");
        }
        else if (chartType == "radar")
        {
            double maxVal = values.Max();
            double radarMax = maxVal > 0 ? maxVal * 1.2 : 100;
            var indicators = cats.Select(c => "{ name:'" + c + "', max:" + radarMax.ToString("0.#") + " }");
            sb.Append("{ tooltip:{}, radar:{ indicator:[" + string.Join(",", indicators) + "] }, series:[{ type:'radar', data:[{ value:[" + string.Join(",", vals) + "], name:'" + W("ShuJuHuiZong") + "' }] }] }");
        }
        else if (chartType == "gauge")
        {
            double gaugeVal = values.FirstOrDefault();
            double gaugeMax = values.Max() > 0 ? values.Max() * 1.2 : 100;
            string gaugeName = cats.Count > 0 ? cats[0] : "";
            sb.Append("{ series:[{ type:'gauge', min:0, max:" + gaugeMax.ToString("0.#") + ", center:['50%','50%'], radius:'40%', nameLocation:'end', nameGap:15, detail:{formatter:'{value}',offsetCenter:[0,'80%']}, data:[{ value:" + gaugeVal.ToString("0.#") + ", name:'" + gaugeName + "' }] }] }");
        }
        else if (chartType == "heatmap")
        {
            double heatMax = values.Max() > 0 ? values.Max() : 100;
            var heatData = new List<string>();
            for (int i = 0; i < rows.Count; i++) heatData.Add("[" + i + ",0," + vals[i] + "]");
            sb.Append("{ tooltip:{position:'top'}, grid:{left:'3%',right:'15%',bottom:'12%',containLabel:true}, xAxis:{type:'category',data:[" + string.Join(",", cats.Select(c => "'" + c + "'")) + "],splitArea:{show:true}}, yAxis:{type:'category',data:['" + W("Zhi") + "'],splitArea:{show:true}}, visualMap:{min:0,max:" + heatMax.ToString("0.#") + ",calculable:true,orient:'vertical',right:'0%',bottom:'10%'}, series:[{ type:'heatmap', data:[" + string.Join(",", heatData) + "], label:{show:true} }] }");
        }
        else if (chartType == "treemap")
        {
            sb.Append("{ series:[{ type:'treemap', data:[");
            for (int i = 0; i < rows.Count; i++)
                sb.Append("{ name:'" + cats[i] + "', value:" + vals[i] + " }" + (i < rows.Count - 1 ? "," : ""));
            sb.Append("], label:{show:true,formatter:'{b}\\n{c}'}, itemStyle:{borderColor:'#fff',borderWidth:2} }] }");
        }
        else
        {
            sb.Append("{ tooltip:{trigger:'item'}, series:[{ type:'pie', data:[");
            for (int i = 0; i < rows.Count; i++)
                sb.Append("{ value:" + vals[i] + ", name:'" + cats[i] + "' }" + (i < rows.Count - 1 ? "," : ""));
            sb.Append("], label:{show:true} }] }");
        }

        return sb.ToString();
    }

    private string FormatDataTableAsHtml(DataTable table)
    {
        if (table == null || table.Rows.Count == 0)
            return "<div style='color:#666;padding:20px;'>无数据</div>";

        var sb = new StringBuilder();
        sb.Append("<div style='overflow-x:auto;'>");
        sb.Append("<table style='border-collapse:collapse;width:100%;font-size:13px;'>");
        sb.Append("<thead><tr style='background:#4F46E5;color:white;'>");
        foreach (DataColumn col in table.Columns)
            sb.Append("<th style='padding:8px 12px;text-align:left;font-weight:600;'>" + HttpUtility.HtmlEncode(col.ColumnName) + "</th>");
        sb.Append("</tr></thead><tbody>");
        int rowIdx = 0;
        foreach (DataRow row in table.Rows)
        {
            string bg = rowIdx % 2 == 0 ? "#fff" : "#f8f9fa";
            sb.Append("<tr style='background:" + bg + ";'>");
            foreach (var item in row.ItemArray)
                sb.Append("<td style='padding:6px 12px;border-bottom:1px solid #e0e0e0;'>" + HttpUtility.HtmlEncode(item == null ? "" : item.ToString()) + "</td>");
            sb.Append("</tr>");
            rowIdx++;
            if (rowIdx >= 500) break;
        }
        sb.Append("</tbody></table>");
        sb.Append("<div style='margin-top:10px;color:#666;font-size:12px;'>总行数 " + table.Rows.Count + " 列数 " + table.Columns.Count + "</div>");
        if (table.Rows.Count >= 500)
            sb.Append("<div style='margin-top:5px;color:#EF4444;font-size:12px;'>注意：结果已截断，仅显示前 500 行。</div>");
        sb.Append("</div>");
        return sb.ToString();
    }

    private string FormatAnalysisContent(string content)
    {
        if (string.IsNullOrEmpty(content))
            return "<div style='color:#666;font-style:italic;padding:20px;'>" + W("DSeekNoContentAvailable") + "</div>";

        content = content.Replace("<br>", "\n").Replace("<br/>", "\n").Replace("<BR>", "\n").Replace("<BR/>", "\n");

        var titleMatch = Regex.Match(content, @"#{2,3}\s+(.+)");
        string title = titleMatch.Success ? titleMatch.Groups[1].Value.Trim() : "";

        content = ConvertMarkdownTableToHtml(content);
        content = Regex.Replace(content, @"#{2,3}\s+.+", "");

        var firstContentMatch = Regex.Match(content, @"<(table|li|ul|ol|p|div)|[^\s<]");
        if (firstContentMatch.Success)
        {
            int pos = firstContentMatch.Index;
            string prefix = pos > 2 ? "\n\n" : content.Substring(0, Math.Min(pos, 2));
            content = prefix + content.Substring(pos);
        }

        content = Regex.Replace(content, @"(\r?\n\s*){2,}", "\n");
        if (!string.IsNullOrEmpty(title))
            content = "<h3 style='text-align:center;margin:10px 0;'>" + HttpUtility.HtmlEncode(title) + "</h3>\n" + content;

        content = Regex.Replace(content, @"\*\*(.+?)\*\*", "<strong>$1</strong>");
        content = Regex.Replace(content, @"^- (.+)", "<li>$1</li>");
        content = Regex.Replace(content, @"\d+\. (.+)", "<li>$1</li>");
        content = content.Replace("\n", "<br>");

        return "<div style='line-height:1.6;'>" + content + "</div>";
    }

    private string ConvertMarkdownTableToHtml(string content)
    {
        var lines = content.Split('\n');
        var result = new StringBuilder();
        bool inTable = false;
        bool isHeader = true;
        foreach (var line in lines)
        {
            string trimmed = line.Trim();
            if (trimmed.StartsWith("|") && trimmed.EndsWith("|"))
            {
                if (!inTable)
                {
                    result.Append("<table style='width:100%;border-collapse:collapse;margin:10px 0;border:1px solid #ddd;'>");
                    inTable = true; isHeader = true;
                }
                if (trimmed.Contains("---")) continue;
                var cells = trimmed.Split(new[] { '|' }, StringSplitOptions.RemoveEmptyEntries);
                result.Append("<tr>");
                foreach (var cell in cells)
                {
                    string tag = isHeader ? "th" : "td";
                    string style = isHeader ? "padding:8px 12px;border:1px solid #ddd;background:#4F46E5;color:white;text-align:left;font-weight:bold;" : "padding:8px 12px;border:1px solid #ddd;";
                    result.Append("<" + tag + " style='" + style + "'>" + cell.Trim() + "</" + tag + ">");
                }
                result.Append("</tr>");
                isHeader = false;
            }
            else
            {
                if (inTable) { result.Append("</table>"); inTable = false; isHeader = true; }
                result.Append(line); result.Append("\n");
            }
        }
        if (inTable) result.Append("</table>");
        return result.ToString();
    }

    private string CleanAndFormatResult(string result)
    {
        if (string.IsNullOrEmpty(result)) return result;
        result = result.Replace("***", "").Replace("**", "").Replace("###", "").Replace("##", "");
        result = Regex.Replace(result, @"(\r?\n\s*){2,}", "\n");
        return result;
    }

    // ═══════════════════ 表格管理（保留旧版） ═══════════════════

    private const string CACHE_KEY_TABLES_LOADED = "AI_TablesLoaded";
    private const int CACHE_MINUTES = 5;

    private void AutoLoadAllTablesAndSelect()
    {
        try
        {
            EnsureTablesExist();
            bool alreadyLoaded = HttpRuntime.Cache[CACHE_KEY_TABLES_LOADED] != null;
            if (!alreadyLoaded)
            {
                string sql = @"SELECT table_name FROM information_schema.tables
                              WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
                                AND table_name NOT LIKE 'T_DBTablesForAI%' AND table_name NOT LIKE 'T_AnalysisHistory%'
                              ORDER BY table_name";
                DataSet ds = ShareClass.GetDataSetFromSql(sql, "AllTables");
                string currentUser = _currentUserCode;
                DateTime now = DateTime.Now;
                foreach (DataRow row in ds.Tables[0].Rows)
                {
                    string tableName = row["table_name"].ToString();
                    try
                    {
                        string checkSql = "SELECT COUNT(*) FROM T_DBTablesForAI WHERE TableName = '" + EscapeSql(tableName) + "' AND IsActive = true";
                        DataSet checkDs = ShareClass.GetDataSetFromSql(checkSql, "Check");
                        int exists = checkDs.Tables[0].Rows.Count > 0 ? Convert.ToInt32(checkDs.Tables[0].Rows[0][0]) : 0;
                        if (exists == 0)
                        {
                            string insertSql = "INSERT INTO T_DBTablesForAI (TableName, Description, CreatedBy, CreatedAt, IsActive) VALUES ('" + EscapeSql(tableName) + "', 'Auto-loaded " + now.ToString("yyyy-MM-dd") + "', '" + EscapeSql(currentUser) + "', '" + now.ToString("yyyy-MM-dd HH:mm:ss") + "', true)";
                            ShareClass.RunSqlCommand(insertSql);
                        }
                    }
                    catch { }
                }
                HttpRuntime.Cache.Insert(CACHE_KEY_TABLES_LOADED, true, null, DateTime.Now.AddMinutes(CACHE_MINUTES), System.Web.Caching.Cache.NoSlidingExpiration);
            }
        }
        catch { }
    }

    private void EnsureTablesExist()
    {
        try
        {
            ShareClass.RunSqlCommand("CREATE TABLE IF NOT EXISTS T_DBTablesForAI (ID SERIAL PRIMARY KEY, TableName VARCHAR(255) NOT NULL, Description TEXT, CreatedBy VARCHAR(100), CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, IsActive BOOLEAN DEFAULT TRUE, LastAnalyzed TIMESTAMP, AnalysisCount INTEGER DEFAULT 0)");
            ShareClass.RunSqlCommand("CREATE TABLE IF NOT EXISTS T_AnalysisHistory (ID SERIAL PRIMARY KEY, ConfigID INTEGER, AnalysisRequirement TEXT NOT NULL, SelectedTables TEXT NOT NULL, CreatedBy VARCHAR(100), CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, AnalysisTime INTEGER, Status VARCHAR(50) DEFAULT 'completed')");
        }
        catch { }
    }

    // ═══════════════════ 工具方法 ═══════════════════

    private static bool IsReadOnlySelectQuery(string sql)
    {
        if (string.IsNullOrWhiteSpace(sql)) return false;
        string trimmed = sql.TrimStart();
        string upper = trimmed.ToUpperInvariant();
        return upper.StartsWith("SELECT") || upper.StartsWith("WITH") || upper.StartsWith("SHOW") || upper.StartsWith("DESCRIBE") || upper.StartsWith("EXPLAIN");
    }

    private static string EscapeSql(string input)
    {
        if (string.IsNullOrEmpty(input)) return "";
        return input.Replace("'", "''");
    }

    private static string E(object o)
    {
        return o == null ? "" : o.ToString().Trim();
    }

    private static string Js(string s)
    {
        if (string.IsNullOrEmpty(s)) return "";
        return s.Replace("\\", "\\\\").Replace("'", "\\'").Replace("\"", "\\\"");
    }
}
