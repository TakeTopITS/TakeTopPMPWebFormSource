<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TTAIHandlerByDeepSeek.aspx.cs" Inherits="TTAIHandlerByDeepSeek" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>
        <asp:Literal ID="LiteralTitle" runat="server" Text="<%$ Resources:lang,DSeekIntelligentDataAnalysisTitle%>"></asp:Literal>
    </title>
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" src="js/echarts.min.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 20px;
            background: #f5f7fa;
        }

        .ai-container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            padding: 20px;
        }

        .ai-header {
            background: linear-gradient(135deg, #4F46E5, #7C3AED);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            text-align: center;
        }

        .ai-mode-switcher {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            justify-content: center;
            align-items: center;
        }

        .ai-mode-btn {
            padding: 12px 25px;
            background: #f8f9fa;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-weight: 600;
            color: #666;
            cursor: pointer;
            transition: all 0.3s;
        }

            .ai-mode-btn.active {
                background: #4F46E5;
                color: white;
                border-color: #1a5cb0;
                font-size: 12px;
            }

        .ai-config-section {
            margin-bottom: 25px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }

        .ai-chat-area {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            justify-content: center;
            flex-wrap: wrap;
        }

            .ai-chat-area textarea {
                flex: 1;
                min-width: 0;
                height: 80px;
                padding: 10px;
                border: 2px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                resize: none;
                box-sizing: border-box;
            }

            .ai-chat-area img {
                width: 36px;
                height: 36px;
                cursor: pointer;
            }

        .ai-result-text {
            line-height: 1.6;
            word-wrap: break-word;
        }

        .ai-result-text strong { font-weight: bold; }
        .ai-result-text h2 { font-size: 20px; margin: 15px 0 10px; }
        .ai-result-text h3 { font-size: 17px; margin: 12px 0 8px; }
        .ai-result-text li { margin-bottom: 4px; }
        .ai-result-text table { border-collapse: collapse; width: 100%; margin: 10px 0; border: 1px solid #ddd; }
        .ai-result-text th, .ai-result-text td { border: 1px solid #ddd; padding: 8px 12px; text-align: left; }
        .ai-result-text th { background: #4F46E5; color: white; font-weight: bold; }

        .ai-btn {
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

        .ai-btn-primary { background: #4F46E5; color: white; }
        .ai-btn-primary:hover { background: #4338ca; }
        .ai-btn-success { background: #10B981; color: white; }
        .ai-btn-success:hover { background: #0da271; }
        .ai-btn-default { background: #ddd; color: #333; }

        .ai-copy-btn {
            background: none;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 4px 8px;
            cursor: pointer;
            font-size: 12px;
            color: #666;
            transition: all 0.2s;
        }

            .ai-copy-btn:hover {
                background: #4F46E5;
                color: white;
                border-color: #1a5cb0;
                font-size: 12px;
            }

        .ai-msg { font-size: 13px; margin-left: 8px; }

        .ai-server-status { margin: 10px 0; padding: 15px; border-radius: 5px; font-weight: bold; text-align: center; font-size: 14px; }
        .ai-server-status.error { background-color: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }

        .ai-loading-overlay {
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

        .ai-loading-content {
            background: white;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            max-width: 500px;
            width: 90%;
        }

        .ai-thinking-dots { display: flex; gap: 8px; justify-content: center; margin: 20px 0; }
        .ai-thinking-dot { width: 10px; height: 10px; background: #4F46E5; border-radius: 50%; animation: ai-pulse 1.5s infinite; }

        @@keyframes ai-pulse {
            0%, 100% { opacity: 0.3; transform: scale(0.8); }
            50% { opacity: 1; transform: scale(1.2); }
        }

        .ai-result-tabs { display: flex; gap: 5px; margin-bottom: 20px; border-bottom: 2px solid #e0e0e0; flex-wrap: wrap; }
        .ai-result-tab { padding: 10px 20px; background: none; border: none; font-weight: 600; color: #666; cursor: pointer; border-bottom: 3px solid transparent; }
        .ai-result-tab.active { color: #1a5cb0; font-size: 12px; border-bottom-color: #1a5cb0; font-size: 12px; }

        .ai-result-content {
            background: white;
            border-radius: 8px;
            padding: 20px;
            border: 1px solid #e0e0e0;
            max-height: 600px;
            overflow-y: auto;
            margin-top: 15px;
            display: none;
        }

        .ai-result-content.active { display: block; }
        .ai-result-header { background: #eef2ff; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .ai-hint-text { font-size: 12px; color: #666; margin-top: 5px; font-style: italic; }

        /* ── 数据分析模式（TTReportDesigner 风格） ── */
        .rptd-wrap { width: 100%; height: calc(100vh - 180px); display: flex; flex-direction: column; }
        .rptd-layout { flex: 1; display: flex; overflow: hidden; }
        .rptd-sidebar { width: 250px; background: #f5f6f8; border-right: 1px solid #d0d4da; display: flex; flex-direction: column; flex-shrink: 0; }
        .rptd-sidebar-header { padding: 8px 12px; background: #e8eaef; border-bottom: 1px solid #d0d4da; font-size: 13px; font-weight: bold; color: #333; display: flex; justify-content: space-between; align-items: center; }
        .rptd-sidebar-search { padding: 6px 10px; }
        .rptd-sidebar-search input { width: 100%; box-sizing: border-box; padding: 4px 8px; border: 1px solid #ccc; border-radius: 3px; font-size: 12px; }
        .rptd-sidebar-body { flex: 1; overflow-y: auto; padding: 4px 0; }
        .rptd-sidebar-msg { padding: 20px; text-align: center; color: #999; font-size: 12px; }
        .rptd-middle { flex: 1; display: flex; flex-direction: column; border-right: 1px solid #d0d4da; }
        .rptd-sql-panel { flex: 1; display: flex; flex-direction: column; border-bottom: 1px solid #d0d4da; }
        .rptd-code-panel { flex: 1; display: flex; flex-direction: column; }
        .rptd-panel-header { padding: 6px 12px; background: #1a1a2e; display: flex; align-items: center; justify-content: space-between; }
        .rptd-panel-header .title { font-size: 12px; font-weight: bold; color: #00d4aa; }
        .rptd-panel-header.code .title { color: #ffc107; }
        .rptd-editor { flex: 1; padding: 0; }
        .rptd-editor textarea { width: 100%; height: 100%; background: #fff; color: #333; border: 1px solid #ccc; padding: 8px 10px; font-family: 'Consolas', monospace; font-size: 12px; resize: none; outline: none; box-sizing: border-box; }
        .rptd-preview { flex: 1; display: flex; flex-direction: column; background: #fff; }
        .rptd-preview-header { padding: 6px 12px; background: #e8eaef; border-bottom: 1px solid #d0d4da; display: flex; align-items: center; justify-content: space-between; }
        .rptd-preview-header .title { font-size: 12px; font-weight: bold; color: #17a2b8; }
        .rptd-preview-body { flex: 1; overflow: auto; padding: 0; }
        .rptd-preview-body iframe { width: 100%; height: 100%; border: none; min-height: 500px; }
        .rptd-btn-sm { padding: 3px 8px; border: 1px solid #bbb; border-radius: 3px; background: #fff; cursor: pointer; font-size: 11px; color: #333; }
        .rptd-btn-sm:hover { background: #e8eaef; }
        .rptd-btn-primary { background: #4a7db5; color: #fff; border-color: #3a6a9e; }
        .rptd-btn-primary:hover { background: #3a6a9e; }
        .rptd-btn-success { background: #28a745; color: #fff; border-color: #1e7e34; }
        .rptd-btn-success:hover { background: #218838; }

        .tree-schema { user-select: none; }
        .tree-schema-header { display: flex; align-items: center; padding: 4px 8px; cursor: pointer; font-size: 12px; font-weight: bold; color: #555; border-bottom: 1px solid #e8e8e8; }
        .tree-schema-header:hover { background: #e0e4ea; }
        .tree-children { padding-left: 16px; }
        .tree-type-label { font-size: 11px; color: #888; padding: 3px 8px 3px 12px; font-weight: bold; }
        .tree-table { display: flex; align-items: center; padding: 3px 8px 3px 16px; cursor: pointer; font-size: 12px; color: #333; border-radius: 2px; }
        .tree-table:hover { background: #dce4f0; }
        .tree-table .tbl-name { flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .tree-columns { padding-left: 24px; }
        .tree-col { display: flex; align-items: center; padding: 2px 8px; font-size: 11px; color: #666; cursor: pointer; }
        .tree-col:hover { background: #f0f2f5; }
        .tree-col .col-type { color: #999; font-size: 10px; margin-left: 6px; }
        .tree-table .tbl-actions { display: none; gap: 2px; }
        .tree-table:hover .tbl-actions { display: flex; }
        .tree-table .act-btn { padding: 0 4px; cursor: pointer; font-size: 10px; color: #6c8fc7; border: none; background: none; }

        .rptd-toast {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: #333;
            color: #fff;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 12px;
            z-index: 9999;
            opacity: 0;
            transition: opacity .3s;
            pointer-events: none;
        }

        .rptd-toast.show { opacity: 1; }

        /* 弹层遮罩 */
        .ai-mask { position: fixed; inset: 0; background: rgba(0,0,0,.4); z-index: 9998; display: none; align-items: center; justify-content: center; }
        .ai-mask.show { display: flex; }
        .ai-mask-box { background: #fff; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,.3); max-width: 90vw; max-height: 80vh; overflow: auto; }
        .ai-mask-head { display: flex; align-items: center; justify-content: space-between; padding: 10px 16px; border-bottom: 1px solid #e0e0e0; font-weight: bold; font-size: 13px; }
        .ai-mask-body { padding: 10px 16px; }
        .ai-chart-chip { cursor: pointer; display: inline-flex; align-items: center; padding: 2px 9px; border: 1px solid #d0d5dd; border-radius: 11px; background: #f4f6f8; font-size: 11px; color: #1a5cb0; white-space: nowrap; user-select: none; }
        .ai-chart-chip:hover { background: #e6ecf8; border-color: #1a5cb0; }
        .aiha-hrow td { background: #3e526c; height: 35px; font-weight: bold; font-size: 11px; color: #fff; padding: 3px 4px; }
    </style>

    <script type="text/javascript">
        // 模式切换
        function aiSwitchMode(mode) {
            document.getElementById('<%= hfMode.ClientID %>').value = mode;
            document.getElementById('<%= divSimpleMode.ClientID %>').style.display = (mode == 'simple') ? 'block' : 'none';
            document.getElementById('<%= divAnalysisMode.ClientID %>').style.display = (mode == 'analysis') ? 'block' : 'none';
            var b1 = document.getElementById('<%= BT_Simple.ClientID %>');
            var b2 = document.getElementById('<%= BT_DataAnalysis.ClientID %>');
            b1.className = 'ai-mode-btn' + (mode == 'simple' ? ' active' : '');
            b2.className = 'ai-mode-btn' + (mode == 'analysis' ? ' active' : '');
            return false;
        }

        // 放大当前页面所在的弹层到最大（配合 allAHandler.js 的 maximizeLayerByFrame）
        function aiMaximizeLayer() {
            try {
                var pwin = window.parent;
                if (pwin && pwin.maximizeLayerByFrame && window.frameElement) {
                    pwin.maximizeLayerByFrame(window.frameElement);
                }
            } catch (e) { }
        }

        // 每次页面加载（含回发）后重新断言弹层最大化，防止点击按钮后缩小
        (function () {
            function aiReassertMaximized() {
                try {
                    var pwin = window.parent;
                    if (pwin && pwin.ensureLayerMaximized && window.frameElement) {
                        pwin.ensureLayerMaximized(window.frameElement);
                    }
                } catch (e) { }
            }
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', aiReassertMaximized);
            } else {
                aiReassertMaximized();
            }
            setTimeout(aiReassertMaximized, 300);
        })();

        // 显示/隐藏 loading
        function aiShowLoading() { document.getElementById('aiLoadingOverlay').style.display = 'flex'; }
        function aiHideLoading() { document.getElementById('aiLoadingOverlay').style.display = 'none'; }

        // 复制文本
        function aiCopyText(elId) {
            var el = document.getElementById(elId);
            if (!el) return;
            var content = el.getAttribute('data-content') || el.innerText || el.value || '';
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(content).then(function () { aiToast('<%= W("YiFuZhi") %>'); }).catch(function () { });
            } else {
                var ta = document.createElement('textarea');
                ta.value = content;
                document.body.appendChild(ta);
                ta.select();
                try { document.execCommand('copy'); aiToast('<%= W("YiFuZhi") %>'); } catch (e) { }
                document.body.removeChild(ta);
            }
        }

        // 打印
        function aiPrintResult(elId) {
            var el = document.getElementById(elId);
            if (!el) return;
            var html = '<div>' + el.innerHTML + '</div>';
            var d = document, i = d.createElement('iframe');
            i.style.position = 'absolute'; i.style.width = '0'; i.style.height = '0'; i.style.border = 'none';
            d.body.appendChild(i);
            var w = i.contentWindow, doc = w.document;
            doc.open();
            doc.write('<html><head><meta charset="utf-8"><style>body{font-family:sans-serif;padding:20px;line-height:1.6;} table{border-collapse:collapse;width:100%;margin:10px 0;} th,td{border:1px solid #ddd;padding:8px 12px;text-align:left;} th{background:#4F46E5;color:white;} h2,h3{margin:8px 0;} img{max-width:100%;}</style></head><body>' + html + '</body></html>');
            doc.close();
            setTimeout(function () { i.contentWindow.focus(); i.contentWindow.print(); }, 200);
            setTimeout(function () { d.body.removeChild(i); }, 2000);
        }

        // Toast
        var aiToastTimer = null;
        function aiToast(msg) {
            var t = document.getElementById('rptdToast');
            if (!t) return;
            t.textContent = msg;
            t.className = 'rptd-toast show';
            if (aiToastTimer) clearTimeout(aiToastTimer);
            aiToastTimer = setTimeout(function () { t.className = 'rptd-toast'; }, 3000);
        }

        // 结果标签页切换
        function aiShowResultTab(tabId, e) {
            document.querySelectorAll('.ai-result-content').forEach(function (c) { c.classList.remove('active'); c.style.display = 'none'; });
            document.querySelectorAll('.ai-result-tab').forEach(function (t) { t.classList.remove('active'); });
            var el = document.getElementById(tabId);
            if (el) { el.classList.add('active'); el.style.display = 'block'; }
            if (e && e.target) e.target.classList.add('active');
        }

        // ── 数据分析模式：架构树 ──
        function aiToggleTree(id) {
            var el = document.getElementById(id);
            if (!el) return;
            var expanded = el.style.display !== 'none';
            el.style.display = expanded ? 'none' : 'block';
        }

        // 插入表名到 SQL 编辑器
        function aiInsertTable(name) {
            document.getElementById('<%= txtSqlCode.ClientID %>').value = 'SELECT * FROM ' + name + ' LIMIT 100';
        }

        // 追加列到 SQL 编辑器
        function aiInsertColumn(col) {
            var ta = document.getElementById('<%= txtSqlCode.ClientID %>');
            var v = ta.value;
            ta.value = v + (v.length > 0 ? ', ' : '') + col;
        }

        // 预览表数据（PostBack）
        function aiPreviewTable(name) {
            document.getElementById('<%= hfPreviewAction.ClientID %>').value = 'preview';
            document.getElementById('<%= hfPreviewTable.ClientID %>').value = name;
            __doPostBack('<%= btnLoadSchema.ClientID %>', '');
        }

        // 执行 AI 生成 SQL（客户端提取后 PostBack）
        function aiDoPost(action) {
            document.getElementById('<%= hfPostAction.ClientID %>').value = action;
            aiShowLoading();
            __doPostBack('<%= btnAiPost.ClientID %>', '');
        }

        // AI 对话框
        function aiOpenDialog() {
            var inp = document.getElementById('<%= txtAiInput.ClientID %>');
            if (!inp.value.trim()) { inp.value = document.getElementById('<%= hfAiDefault.ClientID %>').value || ''; }
            document.getElementById('aiDialogMask').className = 'ai-mask show';
        }
        function aiCloseDialog() { document.getElementById('aiDialogMask').className = 'ai-mask'; }

        // 点击图表类型标签：追加"用X图展示"到 AI 输入框（替换已有的图表描述）
        function aiAppendChartType(typeId) {
            var map = {
                pie: '饼图', bar: '柱状图', line: '折线图', ring: '环形图',
                scatter: '散点图', radar: '雷达图', gauge: '仪表盘',
                funnel: '漏斗图', heatmap: '热力图', treemap: '树形图'
            };
            var kw = map[typeId];
            if (!kw) return;
            var inp = document.getElementById('<%= txtAiInput.ClientID %>');
            if (!inp) return;
            var cur = inp.value || '';
            // 移除已存在的图表类型描述（如"用饼图展示"），避免叠加
            cur = cur.replace(/[，,]\s*(?:用|以)?[^\s，,]+?图展示/g, '').replace(/\s*$/, '');
            inp.value = cur ? cur + '，用' + kw + '展示' : '用' + kw + '展示';
            inp.focus();
        }

        // 预览弹窗
        function aiOpenPreview() { document.getElementById('aiPreviewMask').className = 'ai-mask show'; }
        function aiClosePreview() { document.getElementById('aiPreviewMask').className = 'ai-mask'; }

        // 渲染预览（用 SQL 取数 + 报表代码生成 iframe）
        function aiRenderPreview() {
            var code = document.getElementById('<%= txtReportCode.ClientID %>').value || '';
            var sql = document.getElementById('<%= txtSqlCode.ClientID %>').value || '';
            var el = document.getElementById('rptdPreviewBody');
            if (!el) return;
            if (!code && !sql) { aiToast('<%= W("QingShuRuBaoBiao") %>'); return; }
            var iframe = document.createElement('iframe');
            el.innerHTML = '';
            el.appendChild(iframe);
            var doc = iframe.contentDocument || iframe.contentWindow.document;
            doc.open();
            var html = '<!DOCTYPE html><html><head><meta charset="utf-8"><script src="js/echarts.min.js"><\/script><style>body{font-family:sans-serif;margin:20px;} table{border-collapse:collapse;width:100%;} th,td{border:1px solid #ddd;padding:6px 10px;}</style></head><body>' + (code || '<div style="text-align:center;color:#999;padding:50px;"><%= W("QingShuRuBaoBiao") %></div>') + '</body></html>';
            doc.write(html);
            doc.close();
            // 执行报表代码中的脚本（ECharts）
            try {
                var frames = doc.querySelectorAll('script');
                frames.forEach(function (s) {
                    if (s.textContent && s.textContent.indexOf('echarts') >= 0) {
                        var newScript = doc.createElement('script');
                        newScript.textContent = s.textContent;
                        s.parentNode.replaceChild(newScript, s);
                    }
                });
            } catch (e) { }
            aiToast('<%= W("YuLan") %>');
        }

        // 打印报表预览
        function aiPrintPreview() {
            var el = document.getElementById('rptdPreviewBody');
            if (el) {
                var iframe = el.querySelector('iframe');
                if (iframe && iframe.contentWindow) { iframe.contentWindow.print(); }
            }
        }

        // 简单模式：回车发送
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                var txt = document.getElementById('<%= txtPrompt.ClientID %>');
                if (txt && document.activeElement === txt) {
                    e.preventDefault();
                    aiShowLoading();
                    __doPostBack('<%= btnGenerateText.ClientID %>', '');
                }
            }
        });

        // 双击进入编辑模式
        function aiToggleEdit() {
            var edit = document.getElementById('aiEditArea');
            if (edit) {
                edit.style.display = edit.style.display === 'none' ? 'block' : 'none';
                var ta = document.getElementById('<%= txtEditContent.ClientID %>');
                if (ta) ta.value = document.getElementById('litSimpleResult').innerText;
            }
        }

        // 澄清选项选择（设置隐藏字段并回发）
        function aiClarifyOption(opt) {
            document.getElementById('<%= hfClarifyOption.ClientID %>').value = opt;
            __doPostBack('<%= btnClarifyOption.ClientID %>', '');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:HiddenField ID="hfMode" runat="server" Value="simple" />
        <asp:HiddenField ID="hfPostAction" runat="server" />
        <asp:HiddenField ID="hfPreviewAction" runat="server" />
        <asp:HiddenField ID="hfPreviewTable" runat="server" />
        <asp:HiddenField ID="hfClarifyOption" runat="server" />
        <asp:HiddenField ID="hfAiDefault" runat="server" />

        <!-- AI服务器状态显示 -->
        <div id="aiServerStatusContainer" runat="server" visible="false" class="ai-server-status error">
            <asp:Label ID="lblAIServerStatus" runat="server"></asp:Label>
        </div>

        <div class="ai-container">
            <!-- 页头 -->
            <div class="ai-header">
                <h1 style="margin: 0;">🤖
                    <asp:Literal ID="LiteralHeaderTitle" runat="server" Text="<%$ Resources:lang,DSeekIntelligentAnalysisPlatform%>"></asp:Literal></h1>
                <p style="margin: 10px 0 0 0; opacity: 0.9;">
                    <asp:Literal ID="LiteralSubTitle" runat="server" Text="<%$ Resources:lang,DSeekSmartChatDataAnalysisDualMode%>"></asp:Literal>
                </p>
            </div>

            <!-- 模式切换器 -->
            <div class="ai-mode-switcher">
                <asp:Button ID="BT_Simple" runat="server" CssClass="ai-mode-btn active"
                    Text="<%$ Resources:lang,DSeekSmartChat%>" OnClientClick="aiSwitchMode('simple'); return false;" />
                <asp:Button ID="BT_DataAnalysis" runat="server" CssClass="ai-mode-btn"
                    Text="<%$ Resources:lang,DSeekDataAnalysis%>" OnClientClick="aiSwitchMode('analysis'); aiMaximizeLayer(); return false;" />
            </div>

            <!-- 简单聊天模式 -->
            <div id="divSimpleMode" class="ai-config-section" runat="server">
                <div class="ai-chat-area">
                    <asp:TextBox ID="txtPrompt" runat="server" TextMode="MultiLine"
                        placeholder="<%$ Resources:lang,DSeekEnterYourQuestion%>"></asp:TextBox>
                    <div style="display:flex;flex-direction:column;gap:8px;align-items:center;">
                        <asp:ImageButton ID="btnGenerateText" ImageUrl="ImagesSkin/AIGenerate.png"
                            runat="server" Text="<%$ Resources:lang,DSeekGenerate%>" OnClick="btnGenerateText_Click"
                            OnClientClick="aiShowLoading();" />
                        <asp:ImageButton ID="btnStopAI" ImageUrl="ImagesSkin/AIStop.png"
                            runat="server" Text="<%$ Resources:lang,DSeekStop%>" OnClientClick="aiHideLoading(); return false;" />
                    </div>
                </div>
                <asp:Label ID="lblSimpleMsg" runat="server" CssClass="ai-msg" Style="color:red;"></asp:Label>

                <!-- 生成结果 -->
                <div id="divSimpleResult" runat="server" visible="false" class="ai-config-section">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
                        <span style="font-weight:600;color:#1a5cb0;font-size:12px;">📝
                            <asp:Literal ID="LiteralGenerationResult" runat="server" Text="<%$ Resources:lang,DSeekGenerationResult%>"></asp:Literal></span>
                        <div style="display:flex;gap:8px;align-items:center;">
                            <button type="button" class="ai-btn" style="background:#06B6D4;color:white;font-size:12px;padding:6px 12px;border-radius:4px;" onclick="aiCopyText('litSimpleResult')">📋 <asp:Literal runat="server" Text="<%$ Resources:lang,FuZhi%>"></asp:Literal></button>
                            <button type="button" class="ai-btn" style="background:#6c757d;color:white;font-size:12px;padding:6px 12px;border-radius:4px;" onclick="aiPrintResult('litSimpleResult')">🖨️ <asp:Literal runat="server" Text="<%$ Resources:lang,DaYin%>"></asp:Literal></button>
                        </div>
                    </div>
                    <div id="aiSimpleChart" style="width:100%;height:400px;display:none;"></div>
                    <div id="litSimpleResult" class="ai-result-text" data-content="" ondblclick="aiToggleEdit()">
                        <asp:Literal ID="litSimpleResultContent" runat="server"></asp:Literal>
                    </div>
                    <div id="aiEditArea" style="display:none;margin-top:10px;">
                        <asp:TextBox ID="txtEditContent" runat="server" TextMode="MultiLine"
                            Style="width:100%;min-height:200px;padding:8px;border:1px solid #ccc;border-radius:4px;font-size:13px;"></asp:TextBox>
                        <div style="margin-top:10px;">
                            <asp:Button ID="btnSaveEdit" runat="server" CssClass="ai-btn ai-btn-primary"
                                Text="<%$ Resources:lang,BaoCun%>" OnClick="btnSaveEdit_Click" />
                        </div>
                    </div>
                </div>

                <!-- 澄清对话框 -->
                <div id="divClarification" runat="server" visible="false" class="ai-config-section"
                    style="border:1px solid #ffc107;background:#fffbe6;padding:12px 16px;border-radius:6px;margin-top:10px;">
                    <div style="display:flex;align-items:center;gap:8px;margin-bottom:8px;">
                        <span style="font-size:18px;">❓</span>
                        <strong style="color:#8a6d00;">
                            <asp:Literal ID="LiteralNeedClarification" runat="server" Text="<%$ Resources:lang,DSeekNeedClarification%>"></asp:Literal></strong>
                    </div>
                    <div style="margin-bottom:10px;color:#333;font-size:13px;">
                        <asp:Label ID="lblClarifyQuestion" runat="server"></asp:Label>
                    </div>
                    <div id="divClarifyOptions" runat="server" style="display:flex;flex-wrap:wrap;gap:8px;margin-bottom:8px;"></div>
                    <div style="display:flex;gap:8px;">
                        <asp:TextBox ID="txtClarifyAnswer" runat="server" Style="flex:1;padding:6px;border:1px solid #ccc;border-radius:4px;font-size:13px;"></asp:TextBox>
                        <asp:Button ID="btnClarify" runat="server" CssClass="ai-btn ai-btn-primary"
                            Text="<%$ Resources:lang,QueDing%>" OnClick="btnClarify_Click" />
                    </div>
                    <asp:Button ID="btnClarifyOption" runat="server" Style="display:none;" OnClick="btnClarifyOption_Click" />
                </div>
            </div>

            <!-- 数据分析模式 -->
            <div id="divAnalysisMode" runat="server" style="display:none;">
                <!-- 工具栏 -->
                <div style="display:flex;align-items:center;gap:8px;padding:6px 12px;background:#3e526c;margin-bottom:10px;border-radius:4px;">
                    <span style="font-size:13px;font-weight:bold;color:#fff;">📊
                        <asp:Literal ID="LiteralDataAnalysis" runat="server" Text="<%$ Resources:lang,ShuJuFenXi%>"></asp:Literal></span>
                    <div style="flex:1;"></div>
                    <button type="button" class="rptd-btn-sm" style="background:#ffc107;color:#333;" onclick="aiOpenDialog()">🤖 AI</button>
                    <asp:Button ID="btnExecuteSql" runat="server" CssClass="rptd-btn-sm" Style="background:#28a745;color:#fff;"
                        Text="<%$ Resources:lang,ZhiXing_2%>" OnClick="btnExecuteSql_Click" />
                    <button type="button" class="rptd-btn-sm" style="background:#17a2b8;color:#fff;" onclick="aiRenderPreview()">👁
                        <asp:Literal ID="LiteralPreviewBtn" runat="server" Text="<%$ Resources:lang,YuLan%>"></asp:Literal></button>
                    <button type="button" class="rptd-btn-sm" style="background:#6c757d;color:#fff;" onclick="aiPrintPreview()">🖨️
                        <asp:Literal ID="LiteralPrintBtn" runat="server" Text="<%$ Resources:lang,DaYin%>"></asp:Literal></button>
                    <asp:HyperLink runat="server" NavigateUrl="javascript:void(0)" ToolTip="<%$ Resources:lang,CaoZuoZhiNan%>" style="display:inline-flex;align-items:center;justify-content:center;width:24px;height:24px;border-radius:50%;background:#e94560;color:white;text-decoration:none;font-size:14px;font-weight:bold;">?</asp:HyperLink>
                </div>

                <div class="rptd-wrap">
                    <div class="rptd-layout">
                        <!-- 左侧：数据库结构 -->
                        <div class="rptd-sidebar">
                            <div class="rptd-sidebar-header">
                                <span>📁
                                    <asp:Literal ID="LiteralDbBrowser" runat="server" Text="<%$ Resources:lang,ShuJuKuLiuLanQi%>"></asp:Literal></span>
                                <asp:Button ID="btnLoadSchema" runat="server" CssClass="rptd-btn-sm"
                                    Text="<%$ Resources:lang,ShuaXin%>" OnClick="btnLoadSchema_Click" />
                            </div>
                            <div class="rptd-sidebar-search">
                                <asp:TextBox ID="txtSchemaFilter" runat="server" placeholder="<%$ Resources:lang,SouSuoBiaoShiTu%>" AutoPostBack="false"></asp:TextBox>
                            </div>
                            <div class="rptd-sidebar-body">
                                <asp:Literal ID="litSchemaTree" runat="server"></asp:Literal>
                            </div>
                        </div>

                        <!-- 中间：SQL + 报表代码 -->
                        <div class="rptd-middle">
                            <div class="rptd-sql-panel">
                                <div class="rptd-panel-header">
                                    <span class="title">📝
                                        <asp:Literal ID="LiteralSqlEditor" runat="server" Text="<%$ Resources:lang,SQLBianJiQi%>"></asp:Literal></span>
                                    <div style="display:flex;gap:6px;">
                                        <button type="button" class="rptd-btn-sm" onclick="aiCopyText('<%= txtSqlCode.ClientID %>')">📋
                                            <asp:Literal ID="LiteralCopySql" runat="server" Text="<%$ Resources:lang,FuZhi%>"></asp:Literal></button>
                                        <asp:Button ID="btnExecuteSql2" runat="server" CssClass="rptd-btn-sm rptd-btn-primary"
                                            Text="<%$ Resources:lang,ZhiXing_2%>" OnClick="btnExecuteSql_Click" />
                                    </div>
                                </div>
                                <div class="rptd-editor">
                                    <asp:TextBox ID="txtSqlCode" runat="server" TextMode="MultiLine" placeholder="<%$ Resources:lang,SqlEditorPlaceholder%>"></asp:TextBox>
                                </div>
                            </div>
                            <div class="rptd-code-panel">
                                <div class="rptd-panel-header code">
                                    <span class="title">🎨
                                        <asp:Literal ID="LiteralReportCode" runat="server" Text="<%$ Resources:lang,BaoBiaoDaiMa%>"></asp:Literal>（ECharts）</span>
                                    <div style="display:flex;gap:6px;">
                                        <button type="button" class="rptd-btn-sm" onclick="aiCopyText('<%= txtReportCode.ClientID %>')">📋
                                            <asp:Literal ID="LiteralCopyCode" runat="server" Text="<%$ Resources:lang,FuZhi%>"></asp:Literal></button>
                                        <button type="button" class="rptd-btn-sm rptd-btn-primary" onclick="aiRenderPreview()">👁
                                            <asp:Literal ID="LiteralPreviewBtn2" runat="server" Text="<%$ Resources:lang,YuLan%>"></asp:Literal></button>
                                    </div>
                                </div>
                                <div class="rptd-editor">
                                    <asp:TextBox ID="txtReportCode" runat="server" TextMode="MultiLine" placeholder="<%$ Resources:lang,ReportEditorPlaceholder%>"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <!-- 右侧：预览 -->
                        <div class="rptd-preview">
                            <div class="rptd-preview-header">
                                <span class="title">👁
                                    <asp:Literal ID="LiteralReportPreview" runat="server" Text="<%$ Resources:lang,BaoBiaoYuLan%>"></asp:Literal></span>
                                <button type="button" class="rptd-btn-sm" onclick="aiRenderPreview()">🔄
                                    <asp:Literal ID="LiteralRefreshPreview" runat="server" Text="<%$ Resources:lang,ShuaXin%>"></asp:Literal></button>
                            </div>
                            <div class="rptd-preview-body" id="rptdPreviewBody">
                                <div style="text-align:center;color:#999;padding:50px;">
                                    <p style="font-size:48px;">📊</p>
                                    <p><asp:Literal runat="server" Text="<%$ Resources:lang,PreviewHint%>"></asp:Literal></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- AI 生成占位按钮（用于 __doPostBack） -->
                <asp:Button ID="btnAiPost" runat="server" Style="display:none;" OnClick="btnAiPost_Click" />
            </div>
        </div>

        <!-- 加载遮罩层 -->
        <div class="ai-loading-overlay" id="aiLoadingOverlay">
            <div class="ai-loading-content">
                <div style="font-size: 20px; color:#1a5cb0; margin-bottom: 15px;">🤔
                    <asp:Literal ID="LiteralDeepSeekAnalyzing" runat="server" Text="<%$ Resources:lang,DSeekDeepSeekAnalyzing%>"></asp:Literal></div>
                <div class="ai-thinking-dots">
                    <div class="ai-thinking-dot"></div>
                    <div class="ai-thinking-dot"></div>
                    <div class="ai-thinking-dot"></div>
                </div>
                <div style="margin: 20px 0;">
                    <div style="font-weight: 600; color: #374151; margin-bottom: 5px;">
                        <asp:Literal ID="LiteralConnectingToDatabase" runat="server" Text="<%$ Resources:lang,DSeekConnectingToDatabase%>"></asp:Literal></div>
                    <div style="color: #6B7280; font-size: 14px;">
                        <asp:Literal ID="LiteralPleaseWaitProcessing" runat="server" Text="<%$ Resources:lang,DSeekPleaseWaitProcessing%>"></asp:Literal></div>
                </div>
                <div style="background: #F3F4F6; padding: 15px; border-radius: 8px; margin-top: 15px;">
                    <div style="font-size: 13px; color: #6B7280; font-style: italic;">
                        <asp:Literal ID="LiteralDeepSeekThinking" runat="server" Text="<%$ Resources:lang,DSeekDeepSeekThinking%>"></asp:Literal></div>
                </div>
            </div>
        </div>

        <!-- AI 对话框 -->
        <div id="aiDialogMask" class="ai-mask">
            <div class="ai-mask-box" style="width:500px;">
                <div class="ai-mask-head">
                    <span>🤖 <asp:Literal runat="server" Text="<%$ Resources:lang,AiAssistantDialog%>"></asp:Literal></span>
                    <button type="button" class="rptd-btn-sm" onclick="aiCloseDialog()">✕</button>
                </div>
                <div style="padding:10px 16px;">
                    <asp:TextBox ID="txtAiInput" runat="server" TextMode="MultiLine" Rows="5"
                        Style="width:100%;box-sizing:border-box;padding:8px;border:1px solid #ccc;border-radius:4px;font-size:12px;resize:vertical;"
                        placeholder="<%$ Resources:lang,AiPlaceholder%>"></asp:TextBox>
                    <div style="margin-top:8px;font-size:11px;color:#666;">
                        <asp:Literal ID="LiteralChartTypeLabel" runat="server" Text="<%$ Resources:lang,TuXingLeiXing%>"></asp:Literal>
                    </div>
                    <div style="margin-top:6px;display:flex;flex-wrap:wrap;gap:6px;">
                        <span class="ai-chart-chip" onclick="aiAppendChartType('pie')"><asp:Literal runat="server" Text="<%$ Resources:lang,BingTu%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('bar')"><asp:Literal runat="server" Text="<%$ Resources:lang,ZhuZhuangTu%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('line')"><asp:Literal runat="server" Text="<%$ Resources:lang,ZheXianTu%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('ring')"><asp:Literal runat="server" Text="<%$ Resources:lang,HuanXingTu%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('scatter')"><asp:Literal runat="server" Text="<%$ Resources:lang,SanDianTu%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('radar')"><asp:Literal runat="server" Text="<%$ Resources:lang,LeiDaTu%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('gauge')"><asp:Literal runat="server" Text="<%$ Resources:lang,YiBiaoPan%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('funnel')"><asp:Literal runat="server" Text="<%$ Resources:lang,LouDouTu%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('heatmap')"><asp:Literal runat="server" Text="<%$ Resources:lang,ReLiTu%>"></asp:Literal></span>
                        <span class="ai-chart-chip" onclick="aiAppendChartType('treemap')"><asp:Literal runat="server" Text="<%$ Resources:lang,ShuXingTu%>"></asp:Literal></span>
                    </div>
                    <div style="margin-top:4px;font-size:11px;color:#999;">
                        <asp:Literal ID="LiteralChartHint" runat="server" Text="<%$ Resources:lang,TuXingLeiXingZhuShi%>"></asp:Literal></div>
                    <div style="margin-top:10px;display:flex;gap:8px;justify-content:flex-end;">
                        <button type="button" class="rptd-btn-sm" onclick="aiCloseDialog()">
                            <asp:Literal ID="LiteralAiCancel" runat="server" Text="<%$ Resources:lang,QuXiao_2%>"></asp:Literal></button>
                        <button type="button" class="rptd-btn-sm rptd-btn-primary" onclick="aiDoPost('aiSql')">
                            <asp:Literal ID="LiteralAiGenSql" runat="server" Text="<%$ Resources:lang,ShengChengSQL%>"></asp:Literal></button>
                        <button type="button" class="rptd-btn-sm rptd-btn-success" onclick="aiDoPost('aiReport')">
                            <asp:Literal ID="LiteralAiGenReport" runat="server" Text="<%$ Resources:lang,ShengChengBaoBiao%>"></asp:Literal></button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 预览弹窗（SQL 结果表格） -->
        <div id="aiPreviewMask" class="ai-mask">
            <div class="ai-mask-box" style="width:80%;">
                <div class="ai-mask-head">
                    <span>
                        <asp:Literal ID="LiteralPreviewTitle" runat="server" Text="<%$ Resources:lang,YuLan%>"></asp:Literal></span>
                    <button type="button" class="rptd-btn-sm" onclick="aiClosePreview()">✕</button>
                </div>
                <div style="padding:10px 16px;overflow:auto;max-height:60vh;font-size:12px;">
                    <asp:Literal ID="litPreviewContent" runat="server"></asp:Literal>
                </div>
            </div>
        </div>

        <div id="rptdToast" class="rptd-toast"></div>
    </form>
    <script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); if (oLink) { oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css'; }</script>
</body>
</html>
