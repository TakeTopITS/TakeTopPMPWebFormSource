<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="TTAppAIHandlerByDeepSeek.aspx.cs" Inherits="TTAppAIHandlerByDeepSeek" %>

<%@ Import Namespace="System.Globalization" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes, shrink-to-fit=no" />
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { initSwipeBack(); });
    </script>
    <title>
     <%--   <asp:Literal ID="LiteralTitle" runat="server" Text="<%$ Resources:lang,DSeekIntelligentDataAnalysisTitle%>"></asp:Literal>--%>
    </title>
    <style>
        * {
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI',Arial,sans-serif;
            font-size: 13px;
            background: #f5f7fa;
            -webkit-user-select: text;
            user-select: text;
        }
        body * {
            -webkit-user-select: text;
            user-select: text;
        }

        .aiw-wrap {
            width: 100%;
            min-height: 100vh;
            background: #f5f7fa;
            font-size: 13px;
        }

        .aiw-input-area {
            display: flex;
            gap: 8px;
            align-items: flex-end;
            padding: 8px;
            background: #fff;
            border-bottom: 1px solid #e0e0e0;
        }

            .aiw-input-area textarea {
                flex: 1;
                height: 100px !important;
                min-height: 100px !important;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 13px;
                outline: none;
                box-sizing: border-box;
            }

                .aiw-input-area textarea:focus {
                    border-color: #4F46E5;
                }

            .aiw-input-area img {
                width: 36px;
                height: 36px;
                cursor: pointer;
            }

        .aiw-server-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 10px 12px;
            margin: 8px;
            border-radius: 6px;
            font-size: 12px;
        }
        #divResult, #divResult * {
            -webkit-user-select: text !important;
            user-select: text !important;
            -webkit-touch-callout: default !important;
        }
    </style>
</head>
<body data-disable-pullrefresh="true">
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="LabelSwipe" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" />
    </div>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>

        <div id="aiServerStatusContainer" runat="server" visible="false" class="aiw-server-error">
            <asp:Label ID="lblAIServerStatus" runat="server"></asp:Label>
        </div>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div id="DivID" style="width:100%;height:100vh;overflow-y:auto;overscroll-behavior:contain;">

                    <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                        <tr>
                            <td colspan="2" height="31" class="page_topbj">
                                <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <a id="aAPPBackPriorPage" href="TakeTopAPPMain.aspx" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';" target="_top">
                                                <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <img src="ImagesSkin/return.png" alt="" />
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                            <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>
                                                        <td width="5">
                                                            <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
                                                        </td>
                                                    </tr>
                                                </table>

                                            </a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td>
                                            <div class="aiw-input-area" style="vertical-align: top;">
                                                <asp:TextBox ID="txtPrompt" runat="server" TextMode="MultiLine"
                                                    placeholder="<%$ Resources:lang,DSeekEnterYourQuestion%>"></asp:TextBox>
                                                <div style="display: flex; flex-direction: column; align-items: center; gap: 4px;">
                                                    <asp:ImageButton ID="btnGenerateText" ImageUrl="ImagesSkin/AIGenerate.png"
                                                        runat="server" OnClick="btnGenerateText_Click"
                                                        OnClientClick="showGenerating();" />
                                                    <img id="imgStop" src="ImagesSkin/AIStop.png" width="36" height="36" style="cursor:pointer;"
                                                        onclick="stopAI();" />
                                                </div>
                                            </div>

                                            <div id="divResult" style="padding:0 8px 48px 8px;line-height:1.6;word-break:break-word;">
                                                <asp:Literal ID="lblGeneratedText" runat="server"></asp:Literal>
                                            </div>

                                            <asp:Button ID="btnStopSeek" runat="server" OnClick="btnStopAI_Click" style="display:none;" />

                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script>
    function showGenerating() {
        document.getElementById('<%=btnGenerateText.ClientID%>').src = 'Images/Processing.gif';
    }
    function stopAI() {
        document.getElementById('<%=btnGenerateText.ClientID%>').src = 'ImagesSkin/AIGenerate.png';
        __doPostBack('<%=btnStopSeek.UniqueID%>', '');
    }
    </script>
</body>
</html>
