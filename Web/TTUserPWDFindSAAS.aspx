<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTUserPWDFindSAAS.aspx.cs" Inherits="TTUserPWDFindSAAS" %>

<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; minimum-scale=0.1; user-scalable=1" />

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>

   <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        body {
            background-repeat: repeat-x;
            font: normal 100% Helvetica, Arial, sans-serif;
        }

        #AboveDiv {
            max-width: 1024px;
            width: expression (document.body.clientwidth >= 1024? "1024px" : "auto" ));
            min-width: 277px;
            width: expression (document.body.clientwidth <= 277? "277px" : "auto" ));
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.8.2.min.js"></script>

    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
        });

        //检测设备是否是移动端
        function detectmob() {
            if (navigator.userAgent.match(/Android/i)
                || navigator.userAgent.match(/webOS/i)
                || navigator.userAgent.match(/iPhone/i)
                || navigator.userAgent.match(/iPad/i)
                || navigator.userAgent.match(/iPod/i)
                || navigator.userAgent.match(/BlackBerry/i)
                || navigator.userAgent.match(/Windows Phone/i)
            ) {
                return true;
            }
            else {
                return false;
            }
        }


        function redirectToTarget() {
            if (detectmob()) {

                window.open("Logo/indexSAAS.html");
            }
            else {

                window.open("Logo/indexSAAS.html", "_parent");
            }
        }

    </script>


</head>
<body bgcolor="#FFFFFF">
    <center>
        <form id="form1" runat="server">
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                    <div id="AboveDiv" style="padding-left: 25px;">
                        <table width="99%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="formItemBgStyleForAlignLeft" style="font-size: xx-large; text-align: center; border-radius: 10px 10px 0px 0px; padding-top: 30px; height: 80px; border-bottom-style: none;">
                                    <img src="ImagesSkin/ZhuCeLogo.png"> </img>
                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,ZhaoHuiMiMa%>"></asp:Label>


                                </td>
                            </tr>
                            <tr>
                                <td class="formItemBgStyleForAlignLeft" width="80px" class="ItemAlignLeft" style="vertical-align: bottom;">

                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,YongHuDaiMa%>"></asp:Label>
                                </td>
                            </tr>
                            <tr>

                                <td class="formItemBgStyleForAlignLeft">
                                    <asp:TextBox ID="TB_UserCode" runat="server" Height="25px" width="90%"></asp:TextBox>
                                    <span style="color: #ff0000">*</span> </td>

                            </tr>
                            <tr>
                                <td class="formItemBgStyleForAlignLeft" style="vertical-align: middle">
                                    <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,YanZhengMa%>"></asp:Label>

                                </td>
                            </tr>
                            <tr>
                                <td class="formItemBgStyleForAlignLeft">
                                    <table width="100%">
                                        <tr>
                                            <td width="35%">
                                                <asp:TextBox ID="TB_CheckCode" runat="server" Height="30px" width="99%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Button ID="BT_GetCheckCode" runat="server" CssClass="inpuLong" OnClick="BT_GetCheckCode_Click" Text="<%$ Resources:lang,QuDeYanZhengMa%>" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:Label ID="Label1" runat="server" Font-Size="X-Small" Text="<%$ Resources:lang,NZMJFSDNDZCYSHWXGCHTDXMB%>"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="formItemBgStyleForAlignLeft" style="vertical-align: bottom;">
                                    <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,XinMiMa%>"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="formItemBgStyleForAlignLeft">
                                    <asp:TextBox ID="TB_Password" runat="server" Height="25px" width="90%"></asp:TextBox>

                                    <span style="color: #ff0000">*<span> </span></span></td>
                            </tr>
                            <tr>
                                <td class="formItemBgStyleForAlignLeft" style="vertical-align: bottom;">
                                    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,QueRenMiMa%>"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="formItemBgStyleForAlignLeft">
                                    <asp:TextBox ID="TB_ConfirmPassword" runat="server" Height="25px" width="90%"></asp:TextBox>

                                    <span style="color: #ff0000">*<span> </span></span></td>
                            </tr>
                            <tr>
                                <td class="formItemBgStyleForAlignLeft">
                                   
                                    <br />
                                    <asp:Button ID="BT_UpdatePWD" runat="server" CssClass="inpuLongest" width="90%" Height="30px" OnClick="BT_UpdatePWD_Click" Text="<%$ Resources:lang, BaoCun%>" />
                                    <br />
                                    <br />
                                    <br />
                                    <asp:Button ID="BT_BackLoginPage" runat="server" CssClass="inpuLongest" width="90%" Height="30px" OnClientClick="redirectToTarget()" Text="<%$ Resources:lang,Back%>" />
                                </td>
                            </tr>

                        </table>
                        <br />
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
            <div class="dibupic">
            </div>
            <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <img src="Images/Processing.gif" alt="Loading,please wait..." />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </center>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
