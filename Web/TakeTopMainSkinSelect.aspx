<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TakeTopMainSkinSelect.aspx.cs" Inherits="TakeTopMainSkinSelect" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />
    <title>主题与语言选择</title>
    <link href="css/liucheng.css" rel="stylesheet" type="text/css" />
    <style>
        :root {
            --primary-color: #3e526c;
            --secondary-color: #f5f7fa;
            --accent-color: #057BF9;
            --text-color: #333;
            --light-text: #fff;
            --border-color: #e0e0e0;
            --transition: all 0.2s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--text-color);
        }

        #main {
            background-color: transparent;
            padding: 30px;
            max-width: 900px;
            width: 90%;
            margin: 20px auto;
        }

        .section-title {
            text-align: center;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 30px;
            color: var(--primary-color);
            position: relative;
            padding-bottom: 15px;
        }

            .section-title:after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 2px;
                background-color: var(--primary-color);
            }

        .options-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            margin-bottom: 40px;
        }

        .option-button {
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: var(--light-text);
            position: relative;
            overflow: hidden;
        }

            .option-button:hover {
                transform: scale(1.05);
            }

            .option-button:active {
                transform: scale(0.98);
            }

        .language-button {
            width: 120px;
            height: 120px;
            font-size: 16px;
            background-color: var(--primary-color);
        }

        .theme-button {
            width: 160px;
            height: 160px;
            font-size: 18px;
            position: relative;
        }

        .theme-label {
            position: absolute;
            bottom: 15px;
            left: 0;
            right: 0;
            text-align: center;
            font-size: 16px;
            background-color: rgba(0, 0, 0, 0.7);
            padding: 5px 0;
        }

        .theme-button.gradient {
            background: linear-gradient(135deg, #4F46E5, #7C3AED);
        }

        .theme-button.grey {
            background-color: #3e526c;
        }

        .theme-button.green {
            background-color: #0E553B;
        }

        .theme-button.blue {
            background-color: #057BF9;
        }

        .theme-button.red {
            background-color: #e53935;
        }

        .theme-button.gold {
            background-color: #ffcc33;
            color: #333;
        }

        .theme-button.black {
            background-color: #000000;
        }

        .divider {
            height: 1px;
            background-color: var(--border-color);
            margin: 30px 0;
        }

        .active-outline {
            outline: 4px solid #fff;
            outline-offset: -4px;
            box-shadow: 0 0 0 4px #057BF9;
        }

        @media (max-width: 768px) {
            #main {
                padding: 20px 15px;
            }

            .language-button {
                width: 100px;
                height: 100px;
                font-size: 14px;
            }

            .theme-button {
                width: 130px;
                height: 130px;
                font-size: 16px;
            }
        }

        @media (max-width: 576px) {
            .language-button {
                width: 80px;
                height: 80px;
                font-size: 12px;
            }

            .theme-button {
                width: 100px;
                height: 100px;
                font-size: 14px;
            }

            .theme-label {
                font-size: 12px;
                bottom: 10px;
            }
        }
    </style>
    <script src="js/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="js/allAHandler.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        function redirectToInnerTopPage() {
            window.open('TakeTopLRExMDI.html' +'?Flag=<%=Session["SkinFlag"].ToString() %>', '_top')
        }

        function redirectToOuterTopPage() {
            window.open('TakeTopCSMDI.html' + '?Flag=<%=Session["SkinFlag"].ToString() %>', '_top')
        }

        function redirectToSAASTopPage() {
            window.open('TakeTopLRExMDISAAS.html' + '?Flag=<%=Session["SkinFlag"].ToString() %>', '_top')
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div id="main">
                    <div class="section-title">
                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,YuYanXuanZe%>"></asp:Label>
                    </div>

                    <div class="options-container">
                        <asp:Repeater ID="RP_Language" runat="server" OnItemCommand="RP_Language_ItemCommand">
                            <ItemTemplate>
                                <asp:Button ID="BT_Language" runat="server"
                                    ToolTip='<%# DataBinder.Eval(Container.DataItem,"LangCode") %>'
                                    CssClass="option-button language-button"
                                    Text='<%# DataBinder.Eval(Container.DataItem,"Language").ToString().Trim() %>' />
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="divider"></div>

                    <div class="section-title">
                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,ZhuTiXuanZe%>"></asp:Label>
                    </div>

                    <div class="options-container">
                       <%-- <asp:Button ID="BT_Gradient" runat="server" ToolTip="CssGradient" CssClass="option-button theme-button gradient" Text="" OnClick="BT_Gradient_Click" />--%>
                        <asp:Button ID="BT_Grey" runat="server" ToolTip="CssGrey" CssClass="option-button theme-button grey" Text="" OnClick="BT_Grey_Click" />
                        <asp:Button ID="BT_Green" runat="server" ToolTip="CssGreen" CssClass="option-button theme-button green" Text="" OnClick="BT_Green_Click" />
                        <%--<asp:Button ID="BT_Blue" runat="server" ToolTip="CssBlue" CssClass="option-button theme-button blue" Text="" OnClick="BT_Blue_Click" />--%>
                        <asp:Button ID="BT_Red" runat="server" ToolTip="CssRed" CssClass="option-button theme-button red" Text="" OnClick="BT_Red_Click" />
                    <%--    <asp:Button ID="BT_Gold" runat="server" ToolTip="CssGolden" CssClass="option-button theme-button gold" Text="" OnClick="BT_Gold_Click"/>--%>
                        <asp:Button ID="BT_Black" runat="server" ToolTip="CssBlack" CssClass="option-button theme-button black" Text="" OnClick="BT_Black_Click" />
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
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
