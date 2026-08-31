<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTPMTabSAAS.aspx.cs" Inherits="TTPMTabSAAS" %>

<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <!-- 引入 Font Awesome -->
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
</head>
<body>

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <div class="PMBTab-layout">
                    <!-- 第一个TAB：我承担的项目 -->
                    <input name="nav" type="radio" class="PMBTab-radio PMBTab-home-radio" id="PMBTab-home" checked="checked" />
                    <div class="PMBTab-page">
                        <div class="PMBTab-page-contents">
                            <h1>
                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,MyUnderTakeProject%>"></asp:Label>
                            </h1>
                        </div>
                    </div>
                    <label class="PMBTab-nav PMBTab-bg-undertake" for="PMBTab-home" onclick="JavaScript:parent.detailPMFrame.location.href='TTUndertakeProjectSAAS.aspx'">
                        <span class="PMBTab-nav-content">
                            <!-- 使用任务图标 -->
                            <div class="PMBTab-icon PMBTab-icon-undertake">
                                <i class="fas fa-tasks"></i>
                            </div>
                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,MyUnderTakeProject%>"></asp:Label>
                        </span>
                    </label>

                    <!-- 第二个TAB：我参与的项目 -->
                    <input name="nav" type="radio" class="PMBTab-radio PMBTab-about-radio" id="PMBTab-about" />
                    <div class="PMBTab-page">
                        <div class="PMBTab-page-contents">
                            <h1>
                                <asp:Label ID="LB_InvolvedProject" runat="server" Text="<%$ Resources:lang,MyInvolvedProject%>"></asp:Label>
                            </h1>
                        </div>
                    </div>
                    <label class="PMBTab-nav PMBTab-bg-involved" for="PMBTab-about" onclick="JavaScript:parent.detailPMFrame.location.href='TTInvolvedProjectSAAS.aspx'">
                        <span class="PMBTab-nav-content">
                            <!-- 使用团队图标 -->
                            <div class="PMBTab-icon PMBTab-icon-involved">
                                <i class="fas fa-users"></i>
                            </div>
                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,MyInvolvedProject%>"></asp:Label>
                        </span>
                    </label>

                    <!-- 第三个TAB：我创建的项目 -->
                    <input name="nav" type="radio" class="PMBTab-radio PMBTab-contact-radio" id="PMBTab-contact" />
                    <div class="PMBTab-page">
                        <div class="PMBTab-page-contents">
                            <h1>
                                <asp:Label ID="LB_CreatedProject" runat="server" Text="<%$ Resources:lang,MyCreatedProject%>"></asp:Label>
                            </h1>
                        </div>
                    </div>
                    <label class="PMBTab-nav PMBTab-bg-created" for="PMBTab-contact" onclick="JavaScript:parent.detailPMFrame.location.href='TTCreatedProjectSAAS.aspx'">
                        <span class="PMBTab-nav-content">
                            <!-- 使用创建图标 -->
                            <div class="PMBTab-icon PMBTab-icon-created">
                                <i class="fas fa-plus-circle"></i>
                            </div>
                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,MyCreatedProject%>"></asp:Label>
                        </span>
                    </label>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
        <div style="position: absolute; left: 40%; top: 1%;">
            <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                    <img src="Images/Processing.gif" alt="Loading,please wait..." />
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </form>
</body>
<script type="text/javascript" language="javascript">
    var cssDirectory = '<%=Session["CssDirectory"] %>';
    var oLink = document.getElementById('mainCss');
    oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';
</script>
<script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="js/forever.js"></script>
</html>