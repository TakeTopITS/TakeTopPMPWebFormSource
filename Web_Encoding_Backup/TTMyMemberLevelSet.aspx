<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTMyMemberLevelSet.aspx.cs" Inherits="TTMyMemberLevelSet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>直接下属设置</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 980px;
            width: expression (document.body.clientWidth <= 980? "980px" : "auto" ));
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }



        });

    </script>
</head>
<body>
    <center>
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div id="AboveDiv">
                        <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                            <tr>
                                <td height="31" class="page_topbj">
                                    <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <table width="345" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%>
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,WoDeZhiJieChengYuanSheZhi%>"></asp:Label>
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <table style="width: 100%;" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft" style="padding: 5px 5px 5px 5px; font-weight: bold; font-size: 10pt; border-left: solid 1px #D8D8D8;">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,ZhiJieChengYuanLieBiao%>"></asp:Label></strong>
                                                                    </td>

                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width="6" align="right">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    Font-Bold="true" ForeColor="#333333" GridLines="None"
                                                    Width="100%" Style="margin-top: 0px">
                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                    <ItemStyle CssClass="itemStyle" />
                                                    <HeaderStyle Horizontalalign="left" CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ID" HeaderText="Number">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                                        </asp:BoundColumn>
                                                        <asp:HyperLinkColumn DataNavigateUrlField="UserCode" DataNavigateUrlFormatString="TTUserInforSimple.aspx?UserCode={0}"
                                                            DataTextField="UserName" HeaderText="Name" Target="_blank">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                        </asp:HyperLinkColumn>
                                                        <asp:BoundColumn DataField="ProjectVisible" HeaderText="<%$ Resources:lang,XiangMuKeShi%>">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                   
                                                        <asp:BoundColumn DataField="PlanVisible" HeaderText="<%$ Resources:lang,JiHuaKeShi%>">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="KPIVisible" HeaderText="<%$ Resources:lang,JiXiaoKeShi%>">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ScheduleVisible" HeaderText="<%$ Resources:lang,RiChengKeShi%>">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="WorkloadVisible" HeaderText="<%$ Resources:lang,FuHeKeShi%>">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CustomerServiceVisible" HeaderText="<%$ Resources:lang,KeHuKeFuKeShi%>">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ConstractVisible" HeaderText="<%$ Resources:lang,HeTongKeShi%>">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="PositionVisible" HeaderText="<%$ Resources:lang,WeiZhiKeShi%>">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="<%$ Resources:lang,ShunXu%>">
                                                            <ItemTemplate>
                                                                <asp:TextBox ID="TB_SortNumber" runat="server" Width="40px" Text='<%# DataBinder.Eval(Container.DataItem,"SortNumber").ToString().Trim() %>'></asp:TextBox>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="7%" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td  style="padding: 5px 75px 5px 5px; text-align:right;">
                                                <asp:Button ID="BT_Save" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_Save_Click" />
                                                <asp:Label ID="LB_UserCode" runat="server" Visible="false"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
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
    </center>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script></html>
