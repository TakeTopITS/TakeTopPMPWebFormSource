<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAppReport.aspx.cs" Inherits="TTAppReport" %>


<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Import Namespace="System.Globalization" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/APP.css" rel="stylesheet" type="text/css" />
      <link id="flxappCss" href="css/APPFlx.css" rel="stylesheet" type="text/css" />
   
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { initSwipeBack();// 初始化滑动返回功能  initSwipeBack();// 初始化滑动返回功能



        });

    </script>

</head>
<body><div id="swipeFeedback" class="swipe-feedback"><asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" /></div> <!-- 滑动反馈层 -->
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                    <tr>
                        <td colspan="2" height="31" class="page_topbj">
                            <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="ItemAlignLeft">
                                        <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">

                                            <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="29">
                                                        <img src="ImagesSkin/return.png" alt="" />
                                                    </td>
                                                    <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                        <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                    </td>
                                                    <td width="5">
                                                        <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                    </td>
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
                        <td style="text-align: left;">

                            <table border="0" style="width: 100%; padding-top: 3px;">
                                <tr>
                                    <td class="ItemAlignLeft" style="width: 100%;">
                                        <asp:DataGrid ID="DataGrid1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                            PageSize="15" ShowHeader="False" Height="1px" OnItemCommand="DataGrid1_ItemCommand"
                                            OnPageIndexChanged="DataGrid1_PageIndexChanged" Width="100%" Font-Bold="False"
                                            Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False"
                                            CellPadding="4" ForeColor="#333333" GridLines="None">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" HeaderText="SerialNumber" Visible="false">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                </asp:BoundColumn>
                                                <asp:TemplateColumn HeaderText="报表文件">
                                                    <ItemTemplate>
                                                        <asp:Button ID="BT_ReportName" CommandName="Open" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ReportName") %>'
                                                            CssClass="inpuLongest" Width="99%" />
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="35%" />
                                                </asp:TemplateColumn>
                                                <%--<asp:HyperLinkColumn DataNavigateUrlField="ReportURL" DataNavigateUrlFormatString="{0}"
                                                     DataTextField="ReportName" HeaderText="报表文件" Target="_blank">
                                                     <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="35%" />
                                                 </asp:HyperLinkColumn>--%>
                                                <%--<asp:BoundColumn DataField="TemName" HeaderText="模板">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="20%" />
                                                </asp:BoundColumn>
                                                <asp:HyperLinkColumn DataNavigateUrlField="CreatorCode" DataNavigateUrlFormatString="TTUserInforSimple.aspx?UserCode={0}"
                                                    DataTextField="CreatorName" HeaderText="上传者" Target="_blank">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                </asp:HyperLinkColumn>
                                                <asp:BoundColumn DataField="CreateTime" HeaderText="CreationTime">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="18%" />
                                                </asp:BoundColumn>--%>
                                            </Columns>

                                            <ItemStyle CssClass="itemStyle" />
                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                            <EditItemStyle BackColor="#2461BF" />
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                            <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                        </asp:DataGrid>
                                    </td>
                                </tr>
                            </table>

                            <br />
                            <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,YiYueBaoBiao%>"></asp:Label>:
                            <br />

                            <table border="0" style="width: 100%; padding-top: 3px;">
                                <tr>
                                    <td class="ItemAlignLeft" style="width: 100%;">
                                        <asp:DataGrid ID="DataGrid2" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                            PageSize="15" ShowHeader="False" Height="1px" OnItemCommand="DataGrid2_ItemCommand"
                                            OnPageIndexChanged="DataGrid1_PageIndexChanged" Width="100%" Font-Bold="False"
                                            Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False"
                                            CellPadding="4" ForeColor="#333333" GridLines="None">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" HeaderText="SerialNumber" Visible="false">
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                </asp:BoundColumn>
                                                <asp:TemplateColumn HeaderText="报表文件">
                                                    <ItemTemplate>
                                                        <asp:Button ID="BT_ReportName" CommandName="Open" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ReportName") %>'
                                                            CssClass="inpuLongest" Width="99%" />
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="35%" />
                                                </asp:TemplateColumn>
                                                <%--<asp:HyperLinkColumn DataNavigateUrlField="ReportURL" DataNavigateUrlFormatString="{0}"
                               DataTextField="ReportName" HeaderText="报表文件" Target="_blank">
                               <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="35%" />
                           </asp:HyperLinkColumn>--%>
                                                <%--<asp:BoundColumn DataField="TemName" HeaderText="模板">
                              <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="20%" />
                          </asp:BoundColumn>
                          <asp:HyperLinkColumn DataNavigateUrlField="CreatorCode" DataNavigateUrlFormatString="TTUserInforSimple.aspx?UserCode={0}"
                              DataTextField="CreatorName" HeaderText="上传者" Target="_blank">
                              <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                          </asp:HyperLinkColumn>
                          <asp:BoundColumn DataField="CreateTime" HeaderText="CreationTime">
                              <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="18%" />
                          </asp:BoundColumn>--%>
                                            </Columns>

                                            <ItemStyle CssClass="itemStyle" />
                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                            <EditItemStyle BackColor="#2461BF" />
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                            <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                        </asp:DataGrid>
                                    </td>
                                </tr>
                            </table>


                            <asp:Label ID="LB_Sql1" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="LB_Sql2" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="LB_UserCode" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="LB_UserName" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="LB_Sql5" runat="server" Visible="False"></asp:Label>
                        </td>
                    </tr>
                </table>

            </ContentTemplate>
        </asp:UpdatePanel>
        <div style="position: fixed; display: none; z-index: 9999;" id="progressContainer">
            <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </form>

</body>
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>
</html>
