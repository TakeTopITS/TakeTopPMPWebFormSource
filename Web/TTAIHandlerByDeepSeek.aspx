<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TTAIHandlerByDeepSeek.aspx.cs" Inherits="TTAIHandlerByDeepSeek" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Intelligent Data Analysis - DeepSeek</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 20px;
            background: #f5f7fa;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            padding: 20px;
        }

        .header {
            background: linear-gradient(135deg, #4F46E5, #7C3AED);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            text-align: center;
        }

        .mode-switcher {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            justify-content: center;
        }

        .mode-button {
            padding: 12px 25px;
            background: #f8f9fa;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-weight: 600;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
        }

            .mode-button.active {
                background: #4F46E5;
                color: white;
                border-color: #4F46E5;
            }

        .content-area {
            display: block;
        }

        /* Simple Mode Styles */
        .simple-prompt-area {
            margin-bottom: 20px;
        }

            .simple-prompt-area table {
                margin: 0 auto;
            }

        /* Data Analysis Mode Styles */
        .data-analysis-area {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .config-section {
            margin-bottom: 25px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }

        .config-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .config-row {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 15px;
            margin-bottom: 15px;
            align-items: center;
        }

        .config-input {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }

        .config-textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 6px;
            min-height: 100px;
            resize: vertical;
            font-size: 14px;
        }

        .table-management {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
        }

        .table-input-area {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }

        .table-list-container {
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 15px;
            background: white;
            margin-top: 15px;
        }

        .table-checkbox-group {
            margin-bottom: 8px;
            padding: 8px;
            border-radius: 4px;
            transition: background 0.2s;
        }

            .table-checkbox-group:hover {
                background: #f0f4ff;
            }

        .selected-tables {
            background: #eef2ff;
            padding: 15px;
            border-radius: 6px;
            margin-top: 15px;
            display: none;
        }

        .selected-table-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }

        .table-tag {
            background: white;
            border: 1px solid #a5b4fc;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            color: #4F46E5;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: #4F46E5;
            color: white;
        }

            .btn-primary:hover {
                background: #4338ca;
            }

        .btn-success {
            background: #10B981;
            color: white;
        }

        .btn-warning {
            background: #F59E0B;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .result-tabs {
            display: flex;
            gap: 5px;
            margin-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }

        .result-tab {
            padding: 10px 20px;
            background: none;
            border: none;
            font-weight: 600;
            color: #666;
            cursor: pointer;
            border-bottom: 3px solid transparent;
        }

            .result-tab.active {
                color: #4F46E5;
                border-bottom-color: #4F46E5;
            }

        .analysis-result-section {
            margin-top: 25px;
            padding: 20px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            display: none;
        }

        .result-content {
            background: white;
            border-radius: 8px;
            padding: 20px;
            border: 1px solid #e0e0e0;
            max-height: 600px;
            overflow-y: auto;
            margin-top: 15px;
            display: none;
        }

            .result-content.active {
                display: block;
            }

        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.7);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }

        .loading-content {
            background: white;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            max-width: 500px;
            width: 90%;
        }

        .thinking-dots {
            display: flex;
            gap: 8px;
            justify-content: center;
            margin: 20px 0;
        }

        .thinking-dot {
            width: 10px;
            height: 10px;
            background: #4F46E5;
            border-radius: 50%;
            animation: pulse 1.5s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 0.3;
                transform: scale(0.8);
            }

            50% {
                opacity: 1;
                transform: scale(1.2);
            }
        }

        .hint-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }

        .sql-code {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            font-family: Consolas, monospace;
            font-size: 13px;
            overflow-x: auto;
            margin: 10px 0;
        }

        .analysis-tips {
            background: #f0f9ff;
            border-left: 4px solid #4F46E5;
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
        }

            .analysis-tips ul {
                margin: 10px 0 0 20px;
            }

            .analysis-tips li {
                margin-bottom: 5px;
            }

        .config-buttons {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .result-header {
            background: #eef2ff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
    <script>
        // Result tab switching
        function showResultTab(tabName, e) {
            // Hide all tab contents
            document.querySelectorAll('.result-content').forEach(content => {
                content.classList.remove('active');
                content.style.display = 'none';
            });

            // Remove active class from all tabs
            document.querySelectorAll('.result-tab').forEach(tab => {
                tab.classList.remove('active');
            });

            // Show selected tab
            var targetTab = document.getElementById(tabName);
            if (targetTab) {
                targetTab.classList.add('active');
                targetTab.style.display = 'block';
            }

            if (e && e.target) {
                e.target.classList.add('active');
            }
        }

        // Show loading overlay
        function showLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'flex';
            }

            const steps = [
                "Validating configuration parameters...",
                "Connecting to database...",
                "Reading table structure...",
                "DeepSeek analyzing...",
                "Generating analysis report..."
            ];

            let currentIndex = 0;
            const stepElement = document.getElementById('currentStep');

            const interval = setInterval(() => {
                if (currentIndex < steps.length) {
                    stepElement.textContent = steps[currentIndex];
                    currentIndex++;
                } else {
                    clearInterval(interval);
                }
            }, 2000);
        }

        // Hide loading overlay
        function hideLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'none';
            }
        }

        // Update selected tables display
        function updateSelectedTables() {
            const checkboxes = document.querySelectorAll('#<%= cblTables.ClientID %> input[type="checkbox"]');
            const selectedTags = document.getElementById('selectedTableTags');
            let selectedTables = [];

            checkboxes.forEach(checkbox => {
                if (checkbox.checked) {
                    const label = checkbox.nextElementSibling;
                    selectedTables.push(label.textContent);
                }
            });

            var panel = document.getElementById('selectedTablesPanel');
            if (selectedTables.length > 0) {
                panel.style.display = 'block';
                selectedTags.innerHTML = selectedTables.map(table =>
                    `<span class="table-tag">${table}</span>`
                ).join('');
            } else {
                panel.style.display = 'none';
            }
        }

        // Page initialization
        function initializePage() {
            // Bind table selection events
            const checkboxes = document.querySelectorAll('#<%= cblTables.ClientID %> input[type="checkbox"]');
            if (checkboxes && checkboxes.length > 0) {
                checkboxes.forEach(checkbox => {
                    checkbox.addEventListener('change', updateSelectedTables);
                });
                updateSelectedTables();
            }

            // Add Enter key functionality to textboxes
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Enter') {
                    const txtPrompt = document.getElementById('<%= txtPrompt.ClientID %>');
                    if (txtPrompt && document.activeElement === txtPrompt) {
                        document.getElementById('<%= btnGenerateText.ClientID %>').click();
                    }
                }
            });
        }

        // Initialize after page loads
        document.addEventListener('DOMContentLoaded', initializePage);

        // Show result section
        function showResultSection() {
            var resultSection = document.getElementById('analysisResultSection');
            if (resultSection) {
                resultSection.style.display = 'block';
            }

            hideLoading();

            // Default to summary tab
            showResultTab('summaryContent');

            // Scroll to result section
            setTimeout(function () {
                if (resultSection) {
                    resultSection.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }, 100);
        }

        // Export analysis report
        function exportAnalysis() {
            const summary = document.getElementById('<%= litSummary.ClientID %>');
            const insights = document.getElementById('<%= litInsights.ClientID %>');

            if (!summary || !insights) {
                alert('Analysis results not found!');
                return;
            }

            const report = "=== DeepSeek Data Analysis Report ===\n\n" +
                "Analysis Time: " + new Date().toLocaleString() + "\n\n" +
                "=== Analysis Summary ===\n" + summary.innerText + "\n\n" +
                "=== Detailed Insights ===\n" + insights.innerText;

            const blob = new Blob([report], { type: 'text/plain;charset=utf-8' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `DeepSeek_Analysis_Report_${new Date().toLocaleDateString()}.txt`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);

            alert('Report exported successfully!');
        }

        // Clear results
        function clearResults() {
            var resultSection = document.getElementById('analysisResultSection');
            if (resultSection) {
                resultSection.style.display = 'none';
            }

            // Clear analysis requirement
            const txtAnalysisRequirement = document.getElementById('<%= txtAnalysisRequirement.ClientID %>');
            if (txtAnalysisRequirement) {
                txtAnalysisRequirement.value = '';
            }

            // Deselect all tables
            const checkboxes = document.querySelectorAll('#<%= cblTables.ClientID %> input[type="checkbox"]');
            if (checkboxes) {
                checkboxes.forEach(checkbox => {
                    checkbox.checked = false;
                });
                updateSelectedTables();
            }
        }

        // ASP.NET AJAX end request handling
        if (typeof Sys !== 'undefined') {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);
        }

        function endRequest(sender, args) {
            // Rebind table selection events
            const checkboxes = document.querySelectorAll('#<%= cblTables.ClientID %> input[type="checkbox"]');
            if (checkboxes && checkboxes.length > 0) {
                checkboxes.forEach(checkbox => {
                    checkbox.removeEventListener('change', updateSelectedTables);
                    checkbox.addEventListener('change', updateSelectedTables);
                });
                updateSelectedTables();
            }

            // If there are results, show result section
            if (document.getElementById('analysisResultSection') &&
                document.getElementById('<%= litSummary.ClientID %>') &&
                document.getElementById('<%= litSummary.ClientID %>').innerHTML.trim() !== '') {
                showResultSection();
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>

        <!-- Container outside UpdatePanel -->
        <div class="container">
            <!-- Header -->
            <div class="header">
                <h1 style="margin: 0;">🤖 DeepSeek Intelligent Analysis Platform</h1>
                <p style="margin: 10px 0 0 0; opacity: 0.9;">Smart Chat + Data Analysis Dual Mode</p>
            </div>

            <!-- Mode Switcher -->
            <div class="mode-switcher">
                <asp:Button ID="BT_Simple" runat="server" CssClass="mode-button active" OnClick="BT_Simple_Click" Text="💬 Smart Chat"></asp:Button>
                <asp:Button ID="BT_DataAnalysis" runat="server" CssClass="mode-button" OnClick="BT_DataAnalysis_Click" Text="📊 Data Analysis"></asp:Button>
            </div>

            <!-- UpdatePanel contains all content areas -->
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <!-- Simple Chat Mode -->
                    <div id="divSimpleMode" class="content-area" runat="server">
                        <div class="simple-prompt-area">
                            <center>
                                <table style="text-align: center;">
                                    <tr>
                                        <td>
                                            <asp:TextBox ID="txtPrompt" runat="server" Width="250px" Height="80px"
                                                TextMode="MultiLine" placeholder="Enter your question..."></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="btnGenerateText" ImageUrl="ImagesSkin/AIGenerate.png"
                                                runat="server" Text="Generate" OnClick="btnGenerateText_Click"
                                                OnClientClick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';" />
                                        </td>
                                        <td>
                                            <img id="IMG_Waiting" src="Images/Processing.gif" alt="Loading, please wait..."
                                                style="text-align: center; display: none;" />
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="btnStopSeek" ImageUrl="ImagesSkin/AIStop.png"
                                                runat="server" Text="Stop" OnClick="btnStopAI_Click"
                                                OnClientClick="javascript:document.getElementById('IMG_Waiting').style.display = 'none';" />
                                        </td>
                                    </tr>
                                </table>
                            </center>
                        </div>

                        <CKEditor:CKEditorControl ID="lblGeneratedText" runat="server" Height="600px" Width="100%" Toolbar="" />

                        <div style="display: none;">
                            <asp:HyperLink ID="HL_AIURL" runat="server" Target="_blank"></asp:HyperLink>
                        </div>
                    </div>

                    <!-- Data Analysis Mode -->
                    <div id="divDataAnalysisMode" class="content-area" runat="server" visible="false">
                        <!-- Table Management Area -->
                        <div class="config-section">
                            <div class="config-title">📊 Analysis Table Management</div>

                            <div class="table-management">
                                <!-- Table Name Input -->
                                <div style="margin-bottom: 15px;">
                                    <div style="font-weight: 600; margin-bottom: 8px;">Add Table Names (comma separated):</div>
                                    <div class="table-input-area">
                                        <asp:TextBox ID="txtTableNames" runat="server"
                                            CssClass="config-input"
                                            placeholder="e.g.: projects, tasks, users, orders"></asp:TextBox>
                                        <asp:Button ID="btnSaveTables" runat="server"
                                            Text="Save to Database"
                                            CssClass="btn btn-success"
                                            OnClick="btnSaveTables_Click" />
                                    </div>
                                    <div class="hint-text">Table names will be saved to T_DBTablesForAI table</div>
                                </div>

                                <!-- Saved Table List -->
                                <div style="margin-top: 20px;">
                                    <div style="font-weight: 600; margin-bottom: 8px;">Select tables for analysis:</div>
                                    <asp:Button ID="btnLoadTables" runat="server"
                                        Text="🔄 Load Saved Tables"
                                        CssClass="btn btn-primary"
                                        OnClick="btnLoadTables_Click" />

                                    <asp:Panel ID="pnlTableList" runat="server" Visible="false" CssClass="table-list-container">
                                        <asp:CheckBoxList ID="cblTables" runat="server" CssClass="table-checkbox-list">
                                        </asp:CheckBoxList>
                                    </asp:Panel>

                                    <div id="selectedTablesPanel" class="selected-tables">
                                        <div style="font-weight: 600; color: #4F46E5; margin-bottom: 10px;">Selected Tables:</div>
                                        <div id="selectedTableTags" class="selected-table-tags"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Analysis Requirement Area -->
                        <div class="config-section">
                            <div class="config-title">🎯 Analysis Requirement Description</div>

                            <div class="analysis-tips">
                                <strong>💡 Analysis Requirement Examples:</strong>
                                <ul>
                                    <li>Analyze project costs and profits from these tables</li>
                                    <li>Discover anomalies and issues in the data</li>
                                </ul>
                            </div>

                            <div>
                                <asp:TextBox ID="txtAnalysisRequirement" runat="server"
                                    CssClass="config-textarea"
                                    placeholder="Describe in detail what you want to analyze..."></asp:TextBox>
                                <div class="hint-text">DeepSeek will generate customized analysis reports based on your requirements</div>
                            </div>

                            <div class="action-buttons">
                                <asp:Button ID="btnStartAnalysis" runat="server"
                                    Text="🚀 Start Intelligent Analysis"
                                    CssClass="btn btn-primary"
                                    OnClick="btnStartAnalysis_Click"
                                    OnClientClick="showLoading();" />
                                <asp:Button ID="btnClearAnalysis" runat="server"
                                    Text="🔄 Clear"
                                    CssClass="btn"
                                    Style="background: #ddd;"
                                    OnClientClick="clearResults(); return false;" />
                            </div>
                        </div>

                        <!-- Analysis Result Area -->
                        <div id="analysisResultSection" class="analysis-result-section">
                            <div class="result-header">
                                <div style="font-weight: 600; color: #4F46E5; margin-bottom: 5px;">📋 Analysis Results</div>
                                <div style="color: #666; font-size: 14px;">
                                    Analysis Time:
                                    <asp:Literal ID="litAnalysisTime" runat="server"></asp:Literal>
                                    | Analyzed Tables:
                                    <asp:Literal ID="litAnalyzedTables" runat="server"></asp:Literal>
                                </div>
                            </div>

                            <div class="result-tabs">
                                <button type="button" class="result-tab active" onclick="showResultTab('summaryContent', event)">Analysis Summary</button>
                                <button type="button" class="result-tab" onclick="showResultTab('insightsContent', event)">Detailed Insights</button>
                                <button type="button" class="result-tab" onclick="showResultTab('queriesContent', event)">Generated Queries</button>
                                <button type="button" class="result-tab" onclick="showResultTab('recommendationsContent', event)">Optimization Suggestions</button>
                            </div>

                            <div id="summaryContent" class="result-content active">
                                <asp:Literal ID="litSummary" runat="server"></asp:Literal>
                            </div>

                            <div id="insightsContent" class="result-content">
                                <asp:Literal ID="litInsights" runat="server"></asp:Literal>
                            </div>

                            <div id="queriesContent" class="result-content">
                                <asp:Literal ID="litQueries" runat="server"></asp:Literal>
                            </div>

                            <div id="recommendationsContent" class="result-content">
                                <asp:Literal ID="litRecommendations" runat="server"></asp:Literal>
                            </div>

                            <div style="text-align: right; margin-top: 20px;">
                                <button type="button" class="btn btn-primary" onclick="exportAnalysis()">📄 Export Report</button>
                                <button type="button" class="btn" style="background: #4F46E5; color: white;" onclick="clearResults()">🔄 New Analysis</button>
                            </div>
                        </div>
                    </div>

                    <div class="config-section" style="display: none;">
                        <!-- Configuration Area -->
                        <div class="config-title">⚙️ System Configuration</div>

                        <div class="config-row">
                            <div>DeepSeek API:</div>
                            <div>
                                <asp:TextBox ID="txtDeepSeekApi" runat="server"
                                    CssClass="config-input"
                                    placeholder="http://localhost:11434/v1/chat/completions"></asp:TextBox>
                            </div>
                        </div>

                        <div class="config-row">
                            <div>Model Name:</div>
                            <div>
                                <asp:TextBox ID="txtModel" runat="server"
                                    CssClass="config-input"
                                    placeholder="deepseek-chat" Text="deepseek-chat"></asp:TextBox>
                            </div>
                        </div>

                        <div class="config-buttons">
                            <asp:Button ID="btnTestConfig" runat="server"
                                Text="🔗 Test Connection"
                                CssClass="btn btn-primary"
                                OnClick="btnTestConfig_Click" />
                            <asp:Button ID="btnSaveConfig" runat="server"
                                Text="💾 Save Configuration"
                                CssClass="btn btn-success"
                                OnClick="btnSaveConfig_Click" />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <!-- Loading Overlay (outside UpdatePanel) -->
        <div class="loading-overlay" id="loadingOverlay">
            <div class="loading-content">
                <div style="font-size: 20px; color: #4F46E5; margin-bottom: 15px;">
                    🤔 DeepSeek is analyzing data
                </div>

                <div class="thinking-dots">
                    <div class="thinking-dot"></div>
                    <div class="thinking-dot"></div>
                    <div class="thinking-dot"></div>
                </div>

                <div style="margin: 20px 0;">
                    <div id="currentStep" style="font-weight: 600; color: #374151; margin-bottom: 5px;">
                        Connecting to database...
                    </div>
                    <div style="color: #6B7280; font-size: 14px;">
                        Please wait, processing your request
                    </div>
                </div>

                <div style="background: #F3F4F6; padding: 15px; border-radius: 8px; margin-top: 15px;">
                    <div style="font-size: 13px; color: #6B7280; font-style: italic;">
                        "I'm understanding your analysis requirements, thinking about the best solution..."
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</body>
</html>
