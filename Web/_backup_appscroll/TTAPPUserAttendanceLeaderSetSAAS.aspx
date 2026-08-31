<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPUserAttendanceLeaderSetSAAS.aspx.cs" Inherits="TTAPPUserAttendanceLeaderSetSAAS" %>


<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />


    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();// 初始化滑动返回功能 

            //

        });

    </script>
</head>
<body>
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" />
    </div>
    <!-- 滑动反馈层 -->
    <center>
        <form id="form1" runat="server">
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">

                        <tr>
                            <td height="31" class="page_topbj" width="100%">
                                <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <a id="aAPPBackPriorPage" href="TakeTopAPPMain.aspx" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                                <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <img src="ImagesSkin/return.png" alt="" width="29" height="31" /></td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%></td>
                                                    </tr>
                                                </table>
                                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
                                            </a>
                                        </td>

                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <tr>
                            <td valign="top">


                                <div class="npb">
                                    <div class="cline"></div>
                                    <h3>

                                        <asp:TextBox ID="TB_LeaderCode" Width="70%" runat="server"></asp:TextBox>

                                        <asp:Button ID="BT_AddLeaderCode" CssClass="inpu" runat="server" Text="<%$ Resources:lang,JiaRu%>" OnClick="BT_AddLeaderCode_Click" /></h3>
                                </div>


                                <table style="width: 100%; text-align: left;">
                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                <tr>
                                                    <td width="7">
                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                                    <td>

                                                        <div class="npb">
                                                            <div class="cline"></div>
                                                            <h3>

                                                                <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,ZhuGuan%>"></asp:Label></h3>
                                                        </div>

                                                    </td>
                                                    <td width="6" align="right">
                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" /></td>
                                                </tr>
                                            </table>
                                            <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False" ShowHeader="false" CellPadding="4" ForeColor="#333333"
                                                GridLines="None" OnItemCommand="DataGrid3_ItemCommand" Width="100%" PageSize="20">
                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                <EditItemStyle BackColor="#2461BF" />
                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                <PagerStyle HorizontalAlign="center" />
                                                <ItemStyle CssClass="itemStyle" />
                                                <Columns>
                                                    <asp:BoundColumn DataField="ID" HeaderText="ID" Visible="false">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                    </asp:BoundColumn>

                                                    <asp:TemplateColumn HeaderText="ID">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="6%" />
                                                        <ItemTemplate>
                                                            <%# DataBinder.Eval(Container.DataItem,"LeaderName") %>
                                                            <br />
                                                            <%# DataBinder.Eval(Container.DataItem,"LeaderCode") %>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <%--<asp:BoundColumn DataField="LeaderName" HeaderText="主管">
                                                        <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                    </asp:BoundColumn>--%>
                                                    <asp:TemplateColumn HeaderText="ID">
                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="6%" />
                                                        <ItemTemplate>
                                                            <asp:Button ID="BT_ID" runat="server" CssClass="inpu"
                                                                Text="<%$ Resources:lang,TuiChu%>" />
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

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
    </center>
</body>
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>
</html>
