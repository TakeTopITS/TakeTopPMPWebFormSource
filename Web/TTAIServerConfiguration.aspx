<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TTAIServerConfiguration.aspx.cs" Inherits="TTAIServerConfiguration" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>
        <asp:Literal ID="LiteralTitle" runat="server" Text="<%$ Resources:lang,AIServerConfigurationTitle%>"></asp:Literal>
    </title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f7fa;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            padding: 30px;
        }

        .header {
            background: linear-gradient(135deg, #4F46E5, #7C3AED);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            text-align: center;
        }

        h1 {
            margin: 0;
            font-size: 24px;
        }

        .subtitle {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 14px;
        }

        .config-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }

        .config-row {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 20px;
            margin-bottom: 20px;
            align-items: center;
        }

        .config-label {
            font-weight: 600;
            color: #555;
            text-align: right;
        }

            .config-label .required {
                color: #e53935;
                margin-left: 3px;
            }

        .config-input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

            .config-input:focus {
                border-color: #4F46E5;
                outline: none;
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
            }

            .config-input.select {
                background: white;
                cursor: pointer;
            }

        .radio-group {
            display: flex;
            gap: 30px;
            margin-top: 5px;
        }

        .radio-option {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

            .radio-option input[type="radio"] {
                margin: 0;
                cursor: pointer;
            }

            .radio-option label {
                cursor: pointer;
                font-weight: normal;
                margin: 0;
            }

        .hint-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            font-style: italic;
            line-height: 1.5;
        }

        .btn-group {
         /*   display: flex;
            gap: 15px;*/
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            text-align:center;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            min-width: 120px;
            justify-content: center;
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

            .btn-success:hover {
                background: #0da271;
            }

        .btn-warning {
            background: #F59E0B;
            color: white;
        }

            .btn-warning:hover {
                background: #d97706;
            }

        .btn-secondary {
            background: #6B7280;
            color: white;
        }

            .btn-secondary:hover {
                background: #4b5563;
            }

        .status-container {
            margin: 20px 0;
            padding: 15px;
            border-radius: 6px;
            font-weight: 600;
            text-align: center;
            display: none;
        }

        .status-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            display: block;
        }

        .status-error {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            display: block;
        }

        .status-warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            display: block;
        }

        .model-presets {
            display: flex;
            gap: 10px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .model-preset {
            padding: 6px 12px;
            background: #f0f4ff;
            border: 1px solid #a5b4fc;
            border-radius: 20px;
            font-size: 12px;
            color: #4F46E5;
            cursor: pointer;
            transition: all 0.3s;
        }

            .model-preset:hover {
                background: #4F46E5;
                color: white;
            }

        .preset-section {
            margin-top: 10px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 6px;
            border-left: 4px solid #4F46E5;
        }

            .preset-section h4 {
                margin: 0 0 10px 0;
                color: #4F46E5;
                font-size: 14px;
            }

        .server-info {
            background: #f0f9ff;
            padding: 15px;
            border-radius: 6px;
            margin-top: 20px;
            border-left: 4px solid #4F46E5;
        }

            .server-info h4 {
                margin: 0 0 10px 0;
                color: #4F46E5;
                font-size: 14px;
            }

        .info-grid {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 10px;
            font-size: 13px;
        }

            .info-grid .label {
                font-weight: 600;
                color: #555;
            }

            .info-grid .value {
                color: #333;
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
            max-width: 400px;
            width: 90%;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #4F46E5;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #4F46E5;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }

            .back-link:hover {
                text-decoration: underline;
            }

        .help-text {
            color: #666;
            font-size: 13px;
            line-height: 1.5;
            margin-top: 5px;
        }
    </style>
    <script type="text/javascript" src="js/jquery-1.7.2.min.js">  </script>
    <script type="text/javascript" src="js/allAHandler.js"></script>

    <script> 
        // Show loading overlay
        function showLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'flex';

                // Auto-hide after 30 seconds (safety)
                setTimeout(function () {
                    var overlay = document.getElementById('loadingOverlay');
                    if (overlay) {
                        overlay.style.display = 'none';
                    }
                }, 30000);
            }
        }

        // Hide loading overlay
        function hideLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'none';
            }
        }

        // 在页面加载完成时注册事件
        document.addEventListener('DOMContentLoaded', function () {
            // 为Test Connection按钮添加点击事件，显示加载动画
            var btnTest = document.getElementById('<%= btnTestConnection.ClientID %>');
            if (btnTest) {
                btnTest.addEventListener('click', function () {
                    showLoading();

                    // 设置一个定时器，在15秒后自动隐藏（防止AJAX错误导致一直显示）
                    setTimeout(function () {
                        hideLoading();
                    }, 15000);
                });
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
              
                <div class="container">
                    <!-- Header -->
                    <div class="header">
                        <h1>🤖
                            <asp:Literal ID="LiteralAIServerConfiguration" runat="server" Text="<%$ Resources:lang,AIServerConfiguration%>"></asp:Literal>
                        </h1>
                        <p class="subtitle">
                            <asp:Literal ID="LiteralConfigurationSubtitle" runat="server" Text="<%$ Resources:lang,AIConfigurationSubtitle%>"></asp:Literal>
                        </p>
                    </div>

                    <!-- Status Messages -->
                    <div id="statusContainer" runat="server" class="status-container"></div>

                    <!-- AI Type Selection -->
                    <div class="config-section">
                        <div class="section-title">⚙️
                            <asp:Literal ID="LiteralAIServerTypeTitle" runat="server" Text="<%$ Resources:lang,AIServerTypeTitle%>"></asp:Literal>
                        </div>

                        <div class="config-row">
                            <div class="config-label">
                                <asp:Literal ID="LiteralServerType" runat="server" Text="<%$ Resources:lang,AIServerType%>"></asp:Literal>
                                <span class="required">*</span>
                            </div>
                            <div>
                                <div class="radio-group">
                                    <div class="radio-option">
                                        <asp:RadioButton ID="rbLocal" runat="server" GroupName="AIType" Value="Local"
                                            AutoPostBack="true" OnCheckedChanged="AIType_Changed" />
                                        <label for="<%= rbLocal.ClientID %>">🏠
                                            <asp:Literal ID="LiteralLocalAI" runat="server" Text="<%$ Resources:lang,AILocalAI%>"></asp:Literal>
                                        </label>
                                    </div>
                                    <div class="radio-option">
                                        <asp:RadioButton ID="rbExternal" runat="server" GroupName="AIType" Value="Outer"
                                            AutoPostBack="true" OnCheckedChanged="AIType_Changed" />
                                        <label for="<%= rbExternal.ClientID %>">🌐
                                            <asp:Literal ID="LiteralExternalAI" runat="server" Text="<%$ Resources:lang,AIExternalAI%>"></asp:Literal>
                                        </label>
                                    </div>
                                </div>
                                <div class="hint-text">
                                    <asp:Literal ID="LiteralServerTypeHint" runat="server" Text="<%$ Resources:lang,AIServerTypeHint%>"></asp:Literal>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Server Configuration -->
                    <div class="config-section">
                        <div class="section-title">🔧
                            <asp:Literal ID="LiteralServerConfiguration" runat="server" Text="<%$ Resources:lang,AIServerConfiguration%>"></asp:Literal>
                        </div>

                        <!-- API URL -->
                        <div class="config-row">
                            <div class="config-label">
                                <asp:Literal ID="LiteralAPIURL" runat="server" Text="<%$ Resources:lang,AIAPIURL%>"></asp:Literal>
                                <span class="required">*</span>
                            </div>
                            <div>
                                <asp:TextBox ID="txtApiUrl" runat="server" CssClass="config-input"
                                    placeholder="AI API URL"></asp:TextBox>
                                <div class="hint-text">
                                    <asp:Literal ID="LiteralAPIURLExamples" runat="server" Text="<%$ Resources:lang,AIAPIURLExamples%>"></asp:Literal>
                                </div>
                            </div>
                        </div>

                        <!-- API Key (Only for External) -->
                        <div class="config-row" id="rowApiKey" runat="server">
                            <div class="config-label">
                                <asp:Literal ID="LiteralAPIKey" runat="server" Text="<%$ Resources:lang,AIAPIKey%>"></asp:Literal>
                                <span class="required">*</span>
                            </div>
                            <div>
                                <asp:TextBox ID="txtApiKey" runat="server" CssClass="config-input"
                                    placeholder="AI API Key"></asp:TextBox>
                                <div class="hint-text">
                                    <asp:Literal ID="LiteralAPIKeyHint" runat="server" Text="<%$ Resources:lang,AIAPIKeyHint%>"></asp:Literal>
                                </div>
                            </div>
                        </div>

                        <!-- Model Selection -->
                        <div class="config-row">
                            <div class="config-label">
                                <asp:Literal ID="LiteralModelName" runat="server" Text="<%$ Resources:lang,AIModelName%>"></asp:Literal>
                                <span class="required">*</span>
                            </div>
                            <div>
                                <asp:TextBox ID="txtModel" runat="server" CssClass="config-input"
                                    placeholder="AI Model"></asp:TextBox>

                                <div class="preset-section">
                                    <h4>
                                        <asp:Literal ID="LiteralQuickPresets" runat="server" Text="<%$ Resources:lang,AIQuickPresets%>"></asp:Literal>
                                    </h4>
                                    <div class="model-presets" id="localPresets" runat="server">
                                        <span class="model-preset" onclick="setModel('deepseek-r1:1.5b')">deepseek-r1:1.5b</span>
                                        <span class="model-preset" onclick="setModel('llama2')">llama2</span>
                                        <span class="model-preset" onclick="setModel('mistral')">mistral</span>
                                        <span class="model-preset" onclick="setModel('codellama')">codellama</span>
                                    </div>
                                    <div class="model-presets" id="externalPresets" runat="server" style="display: none;">
                                        <span class="model-preset" onclick="setModel('gpt-3.5-turbo')">gpt-3.5-turbo</span>
                                        <span class="model-preset" onclick="setModel('gpt-4')">gpt-4</span>
                                        <span class="model-preset" onclick="setModel('gpt-4-turbo')">gpt-4-turbo</span>
                                        <span class="model-preset" onclick="setModel('deepseek-chat')">deepseek-chat</span>
                                        <span class="model-preset" onclick="setModel('claude-3-sonnet')">claude-3-sonnet</span>
                                    </div>
                                    <div class="help-text">
                                        <asp:Literal ID="LiteralPresetHint" runat="server" Text="<%$ Resources:lang,AIPresetHint%>"></asp:Literal>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Server Information -->
                    <div class="server-info">
                        <h4>📊
                            <asp:Literal ID="LiteralCurrentStatus" runat="server" Text="<%$ Resources:lang,AICurrentStatus%>"></asp:Literal>
                        </h4>
                        <div class="info-grid">
                            <div class="label">
                                <asp:Literal ID="LiteralServerType2" runat="server" Text="<%$ Resources:lang,AIServerType%>"></asp:Literal>:
                            </div>
                            <div class="value">
                                <asp:Label ID="lblCurrentServerType" runat="server" Text="<%$ Resources:lang,AINotConfigured%>"></asp:Label>
                            </div>

                            <div class="label">
                                <asp:Literal ID="LiteralServerURL" runat="server" Text="<%$ Resources:lang,AIServerURL%>"></asp:Literal>:
                            </div>
                            <div class="value">
                                <asp:Label ID="lblCurrentServerUrl" runat="server" Text="<%$ Resources:lang,AINotConfigured%>"></asp:Label>
                            </div>

                            <div class="label">
                                <asp:Literal ID="LiteralModel" runat="server" Text="<%$ Resources:lang,AIModel%>"></asp:Literal>:
                            </div>
                            <div class="value">
                                <asp:Label ID="lblCurrentModel" runat="server" Text="<%$ Resources:lang,AINotConfigured%>"></asp:Label>
                            </div>

                            <div class="label">
                                <asp:Literal ID="LiteralStatus" runat="server" Text="<%$ Resources:lang,AIStatus%>"></asp:Literal>:
                            </div>
                            <div class="value">
                                <asp:Label ID="lblCurrentStatus" runat="server" Text="<%$ Resources:lang,AIUnknown%>"></asp:Label>
                            </div>

                            <div class="label">
                                <asp:Literal ID="LiteralLastTest" runat="server" Text="<%$ Resources:lang,AILastTest%>"></asp:Literal>:
                            </div>
                            <div class="value">
                                <asp:Label ID="lblLastTestTime" runat="server" Text="<%$ Resources:lang,AINeverTested%>"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="btn-group">
                        <asp:Button ID="btnTestConnection" runat="server" 
                            CssClass="btn btn-primary" OnClick="btnTestConnection_Click"
                            OnClientClick="showLoading();" 
                            Text="<%$ Resources:lang,AITestConnection%>" />

                        <asp:Button ID="btnSaveConfiguration" runat="server"
                            CssClass="btn btn-success" OnClick="btnSaveConfiguration_Click"
                            Text="<%$ Resources:lang,AISaveConfiguration%>" />

                        <asp:Button ID="btnLoadConfiguration" runat="server"
                            CssClass="btn btn-warning" OnClick="btnLoadConfiguration_Click"
                            Text="<%$ Resources:lang,AILoadCurrent%>" />

                        <asp:Button ID="btnReset" runat="server"
                            CssClass="btn btn-secondary" OnClick="btnReset_Click"
                            Text="<%$ Resources:lang,AIResetToDefault%>" />
                    </div>

                    <!-- Additional Information -->
                    <div class="config-section" style="margin-top: 30px;">
                        <div class="section-title">ℹ️
                            <asp:Literal ID="LiteralInformationHelp" runat="server" Text="<%$ Resources:lang,AIInformationHelp%>"></asp:Literal>
                        </div>
                        <div class="help-text">
                            <p><strong>
                                <asp:Literal ID="LiteralLocalAISetup" runat="server" Text="<%$ Resources:lang,AILocalAISetup%>"></asp:Literal></strong></p>
                            <ul>
                                <li>
                                    <asp:Literal ID="LiteralInstallOllama" runat="server" Text="<%$ Resources:lang,AIInstallOllama%>"></asp:Literal></li>
                                <li>
                                    <asp:Literal ID="LiteralOllamaCommand" runat="server" Text="<%$ Resources:lang,AIOllamaCommand%>"></asp:Literal></li>
                                <li>
                                    <asp:Literal ID="LiteralOllamaPort" runat="server" Text="<%$ Resources:lang,AIOllamaPort%>"></asp:Literal></li>
                            </ul>

                            <p><strong>
                                <asp:Literal ID="LiteralExternalAISetup" runat="server" Text="<%$ Resources:lang,AIExternalAISetup%>"></asp:Literal></strong></p>
                            <ul>
                                <li>
                                    <asp:Literal ID="LiteralGetAPIKey" runat="server" Text="<%$ Resources:lang,AIGetAPIKey%>"></asp:Literal></li>
                                <li>
                                    <asp:Literal ID="LiteralCheckCredits" runat="server" Text="<%$ Resources:lang,AICheckCredits%>"></asp:Literal></li>
                                <li>
                                    <asp:Literal ID="LiteralCheckAPIDocs" runat="server" Text="<%$ Resources:lang,AICheckAPIDocs%>"></asp:Literal></li>
                            </ul>

                            <p><strong>
                                <asp:Literal ID="LiteralNote" runat="server" Text="<%$ Resources:lang,AINote%>"></asp:Literal></strong>
                                <asp:Literal ID="LiteralConfigurationNote" runat="server" Text="<%$ Resources:lang,AIConfigurationNote%>"></asp:Literal></p>
                        </div>
                    </div>
                </div>

                <!-- Loading Overlay -->
                <div class="loading-overlay" id="loadingOverlay">
                    <div class="loading-content">
                        <div class="spinner"></div>
                        <div style="font-weight: 600; color: #374151; margin-bottom: 5px;">
                            <asp:Literal ID="LiteralTestingConnection" runat="server" Text="<%$ Resources:lang,AITestingConnection%>"></asp:Literal>
                        </div>
                        <div style="color: #6B7280; font-size: 14px;">
                            <asp:Literal ID="LiteralPleaseWaitConnection" runat="server" Text="<%$ Resources:lang,AIPleaseWaitConnection%>"></asp:Literal>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
            <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                    <img src="Images/Processing.gif" alt="Loading,please wait..." />
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </form>

    <script type="text/javascript">
        // Set model from preset
        function setModel(modelName) {
            var txtModel = document.getElementById('<%= txtModel.ClientID %>');
            if (txtModel) {
                txtModel.value = modelName;
            }
        }

        // Show loading overlay
        function showLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'flex';

                // Auto-hide after 30 seconds (safety)
                setTimeout(function () {
                    overlay.style.display = 'none';
                }, 30000);
            }
        }

        // Hide loading overlay
        function hideLoading() {
            var overlay = document.getElementById('loadingOverlay');
            if (overlay) {
                overlay.style.display = 'none';
            }
        }

        // Update preset visibility based on AI type
        function updatePresetVisibility(aiType) {
            var localPresets = document.getElementById('<%= localPresets.ClientID %>');
            var externalPresets = document.getElementById('<%= externalPresets.ClientID %>');

            if (localPresets && externalPresets) {
                if (aiType === 'Local') {
                    localPresets.style.display = 'flex';
                    externalPresets.style.display = 'none';
                } else {
                    localPresets.style.display = 'none';
                    externalPresets.style.display = 'flex';
                }
            }
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            // Initial preset visibility
            var rbLocal = document.getElementById('<%= rbLocal.ClientID %>');
            if (rbLocal && rbLocal.checked) {
                updatePresetVisibility('Local');
            } else {
                updatePresetVisibility('External');
            }

            // Bind AI type change events
            var radioButtons = document.querySelectorAll('input[name*="AIType"]');
            radioButtons.forEach(function (radio) {
                radio.addEventListener('change', function () {
                    updatePresetVisibility(this.value);
                });
            });
        });

        // ASP.NET AJAX end request handling
        if (typeof Sys !== 'undefined') {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                // Re-initialize after AJAX update
                var rbLocal = document.getElementById('<%= rbLocal.ClientID %>');
                if (rbLocal && rbLocal.checked) {
                    updatePresetVisibility('Local');
                } else {
                    updatePresetVisibility('External');
                }

                // Hide loading overlay
                hideLoading();
            });
        }
    </script>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>