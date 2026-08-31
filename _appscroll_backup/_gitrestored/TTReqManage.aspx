<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTReqManage.aspx.cs" Inherits="TTReqManage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>项目需求申请</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 1400px;
            width: expression (document.body.clientWidth <= 1400? "1400px" : "auto" ));
        }
    </style>
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { if (top.location != self.location) { } else { CloseWebPage(); }



        });

    </script>

</head>
<body>

    <center>
        <form id="form1" runat="server">
            <%--  <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">--%>
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
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,XuQiuGuanLi%>" />
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

                            <tr>
                                <td valign="top">
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="padding-top: 5px">
                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" style="font-weight: bold; height: 24px; color: #394f66; background-image: url('ImagesSkin/titleBG.jpg')">
                                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                                <tr>
                                                                    <td style="padding-left: 20px; text-align: left; width: 510px; height: 24px;" colspan="2">
                                                                        <asp:Label ID="LB_MyQueryScope" runat="server" Text="<%$ Resources:lang,MyQueryScope%>"></asp:Label>:<asp:Label
                                                                            ID="LB_QueryScope" runat="server" Font-Names="Arial,宋体" Font-Size="9pt"></asp:Label>
                                                                    </td>
                                                                    <td style="padding-right: 5px; text-align: right; width: 300px; height: 25px;" colspan="2">
                                                                        <asp:Label ID="LB_Operator" runat="server" Text="<%$ Resources:lang,Operator%>" />:
                                                                    <asp:Label ID="LB_UserCode" runat="server" Font-Size="9pt" Text="UserCode"></asp:Label>
                                                                        &nbsp;
                                                                    <asp:Label ID="LB_UserName" runat="server" Font-Size="9pt"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">
                                                            <table width="100%" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td style="width: 100%; text-align: left; padding: 5px 5px 5px 5px;">
                                                                        <cc2:TabContainer CssClass="ajax_tab_menu" ID="TabContainer1" runat="server" ActiveTabIndex="0" Width="100%">
                                                                            <cc2:TabPanel ID="TabPanel1" runat="server" HeaderText="我要处理的需求:">
                                                                                <HeaderTemplate>
                                                                                    <asp:Label ID="Label99991" runat="server" Text="<%$ Resources:lang,WoYaoChuLiDeXuQiu%>"></asp:Label>
                                                                                </HeaderTemplate>
                                                                                <ContentTemplate>
                                                                                    <table style="width: 100%;">
                                                                                        <tr>
                                                                                            <td style="width: 100%; text-align: Left;">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                                                    <tr>
                                                                                                        <td width="7">
                                                                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td width="5%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,BianHao %>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="25%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,WoDeGongZuo %>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="8%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,XuQiuHao %>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="23%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,XuQiuMing %>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="10%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,FenPaiRen %>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="10%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,KaiShiShiJian %>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="10%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,JieShuShiJian %>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="8%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,ZhuangTai %>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="4%" class="ItemAlignLeft">
                                                                                                                        <strong></strong>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="6" align="right">
                                                                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <asp:DataGrid ID="DataGrid4" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                                                                    Font-Bold="False" Height="1px" OnPageIndexChanged="DataGrid4_PageIndexChanged"
                                                                                                    ShowHeader="False" PageSize="5" Width="100%" CellPadding="4" ForeColor="#333333"
                                                                                                    GridLines="None">
                                                                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                                                    <EditItemStyle BackColor="#2461BF" />
                                                                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                                                    <ItemStyle CssClass="itemStyle" />
                                                                                                    <Columns>
                                                                                                        <asp:BoundColumn DataField="ID" HeaderText="Number">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTReqDetail.aspx?ID={0}"
                                                                                                            DataTextField="Operation" HeaderText="受理人的工作" Target="_blank">
                                                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="25%" />
                                                                                                        </asp:HyperLinkColumn>
                                                                                                        <asp:BoundColumn DataField="ReqID" HeaderText="需求号">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:BoundColumn DataField="ReqName" HeaderText="需求名">
                                                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="23%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:BoundColumn DataField="AssignManName" HeaderText="分派人">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="StartTime">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="EndTime">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:TemplateColumn HeaderText="Status">
                                                                                                            <ItemTemplate>
                                                                                                                <%# ShareClass.GetStatusHomeNameByRequirementStatus(Eval("Status").ToString()) %>
                                                                                                            </ItemTemplate>
                                                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
                                                                                                        </asp:TemplateColumn>


                                                                                                        <asp:TemplateColumn>
                                                                                                            <ItemTemplate>
                                                                                                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ReqID", "TTDocumentTreeView.aspx?RelatedType=Req&RelatedID={0}") %>'
                                                                                                                    Target="_blank"><img src ="ImagesSkin/Doc.gif" class="noBorder" /></asp:HyperLink>
                                                                                                            </ItemTemplate>
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                                                                        </asp:TemplateColumn>
                                                                                                    </Columns>
                                                                                                    <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" Horizontalalign="left" />
                                                                                                </asp:DataGrid>
                                                                                                <asp:Label ID="LB_Sql4" runat="server" Visible="False"></asp:Label>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </ContentTemplate>
                                                                            </cc2:TabPanel>
                                                                            <cc2:TabPanel ID="TabPanel2" runat="server" HeaderText="已处理但没分派的需求">
                                                                                <HeaderTemplate>
                                                                                    <asp:Label ID="Label44" runat="server" Text="<%$ Resources:lang,YCLDMFPDXQ%>"></asp:Label>
                                                                                </HeaderTemplate>
                                                                                <ContentTemplate>
                                                                                    <table style="width: 100%;">
                                                                                        <tr>
                                                                                            <td style="width: 100%; text-align: left;">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                                                    <tr>
                                                                                                        <td width="7">
                                                                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td width="5%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="25%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,WoDeGongZuo%>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="8%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,XuQiuHao%>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="23%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,XuQiuMing%>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="10%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,FenPaiRen%>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="10%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,KaiShiShiJian%>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="10%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,JieShuShiJian%>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="8%" class="ItemAlignLeft">
                                                                                                                        <strong>
                                                                                                                            <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></strong>
                                                                                                                    </td>
                                                                                                                    <td width="4%" class="ItemAlignLeft">
                                                                                                                        <strong></strong>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="6" align="right">
                                                                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <asp:DataGrid ID="DataGrid1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                                                                    Height="1px" OnPageIndexChanged="DataGrid1_PageIndexChanged" PageSize="5" Width="100%"
                                                                                                    ShowHeader="false" CellPadding="4" ForeColor="#333333" GridLines="None">
                                                                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                                                    <EditItemStyle BackColor="#2461BF" />
                                                                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                                                    <ItemStyle CssClass="itemStyle" />
                                                                                                    <Columns>
                                                                                                        <asp:BoundColumn DataField="ID" HeaderText="Number">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTReqDetail.aspx?ID={0}"
                                                                                                            DataTextField="Operation" HeaderText="我的工作" Target="_blank">
                                                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="25%" />
                                                                                                        </asp:HyperLinkColumn>
                                                                                                        <asp:BoundColumn DataField="ReqID" HeaderText="需求号">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:BoundColumn DataField="ReqName" HeaderText="需求名">
                                                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="23%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:BoundColumn DataField="AssignManName" HeaderText="分派人">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="StartTime">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                                        </asp:BoundColumn>
                                                                                                        <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="EndTime">
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                                        </asp:BoundColumn>

                                                                                                        <asp:TemplateColumn HeaderText="Status">
                                                                                                            <ItemTemplate>
                                                                                                                <%# ShareClass.GetStatusHomeNameByRequirementStatus(Eval("Status").ToString()) %>
                                                                                                            </ItemTemplate>
                                                                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
                                                                                                        </asp:TemplateColumn>

                                                                                                        <asp:TemplateColumn>
                                                                                                            <ItemTemplate>
                                                                                                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ReqID", "TTDocumentTreeView.aspx?RelatedType=Req&RelatedID={0}") %>'
                                                                                                                    Target="_blank"><img src ="ImagesSkin/Doc.gif"  class="noBorder" /></asp:HyperLink>
                                                                                                            </ItemTemplate>
                                                                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                                                                        </asp:TemplateColumn>
                                                                                                    </Columns>
                                                                                                </asp:DataGrid>
                                                                                                <asp:Label ID="LB_Sql1" runat="server" Visible="False"></asp:Label>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </ContentTemplate>
                                                                            </cc2:TabPanel>
                                                                        </cc2:TabContainer>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="height: 15px"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="width: 100%; height: 3px; text-align: left; padding: 5px 5px 5px 5px;">
                                                                        <span style="font-size: 10pt;">
                                                                            <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,WoYiFenPaiDeXuQiu%>"></asp:Label>:</span>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="text-align: center; padding: 5px 5px 5px 5px">
                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                            <tr>
                                                                                <td width="7">
                                                                                    <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                                </td>
                                                                                <td>
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="5%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="25%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,YaoQiuChuLiDeGongZuo%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="8%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,XuQiuHao%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="23%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,XuQiuMing%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="10%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,FenPaiRen%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="10%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,KaiShiShiJian%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="10%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,JieShuShiJian%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="8%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="4%" class="ItemAlignLeft">
                                                                                                <strong></strong>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="6" align="right">
                                                                                    <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:DataGrid ID="DataGrid3" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                                            Height="1px" OnPageIndexChanged="DataGrid3_PageIndexChanged" PageSize="5" Width="100%"
                                                                            ShowHeader="false" CellPadding="4" ForeColor="#333333" GridLines="None">
                                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                            <EditItemStyle BackColor="#2461BF" />
                                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                            <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                            <ItemStyle CssClass="itemStyle" />
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="ID" HeaderText="Number">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTReqDetail.aspx?ID={0}"
                                                                                    DataTextField="Operation" HeaderText="我的工作" Target="_blank">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="25%" />
                                                                                </asp:HyperLinkColumn>
                                                                                <asp:BoundColumn DataField="ReqID" HeaderText="需求号">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ReqName" HeaderText="需求名">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="23%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="AssignManName" HeaderText="分派人">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="StartTime">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="EndTime">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <%--   <asp:TemplateColumn HeaderText="Status">
    <ItemTemplate>
        <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
    </ItemTemplate>
    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
</asp:TemplateColumn>--%>

                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <%# ShareClass.GetStatusHomeNameByRequirementStatus(Eval("Status").ToString()) %>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
                                                                                </asp:TemplateColumn>

                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ReqID", "TTDocumentTreeView.aspx?RelatedType=Req&RelatedID={0}") %>'
                                                                                            Target="_blank"><img src ="ImagesSkin/Doc.gif"  class="noBorder" /></asp:HyperLink>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <asp:Label ID="LB_Sql3" runat="server" Visible="False"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="height: 15px"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="width: 100%; height: 3px; text-align: left; padding: 5px 5px 5px 5px;">
                                                                        <span style="font-size: 10pt;">
                                                                            <asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,WYCLBYFPDXQ%>"></asp:Label>:</span>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="text-align: center; padding: 5px 5px 5px 5px">
                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                            <tr>
                                                                                <td width="7">
                                                                                    <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                                </td>
                                                                                <td>
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="5%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="25%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label29" runat="server" Text="<%$ Resources:lang,WoDeGongZuo%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="8%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label30" runat="server" Text="<%$ Resources:lang,XuQiuHao%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="23%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label31" runat="server" Text="<%$ Resources:lang,XuQiuMing%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="10%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label32" runat="server" Text="<%$ Resources:lang,FenPaiRen%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="10%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label33" runat="server" Text="<%$ Resources:lang,KaiShiShiJian%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="10%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,JieShuShiJian%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="8%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label35" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="4%" class="ItemAlignLeft">
                                                                                                <strong></strong>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="6" align="right">
                                                                                    <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:DataGrid ID="DataGrid6" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                                            Height="1px" OnPageIndexChanged="DataGrid6_PageIndexChanged" PageSize="5" Width="100%"
                                                                            ShowHeader="false" CellPadding="4" ForeColor="#333333" GridLines="None">
                                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                            <EditItemStyle BackColor="#2461BF" />
                                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                            <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                            <ItemStyle CssClass="itemStyle" />
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="ID" HeaderText="Number">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:HyperLinkColumn DataNavigateUrlField="ID" DataNavigateUrlFormatString="TTReqDetail.aspx?ID={0}"
                                                                                    DataTextField="Operation" HeaderText="我的工作" Target="_blank">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="25%" />
                                                                                </asp:HyperLinkColumn>
                                                                                <asp:BoundColumn DataField="ReqID" HeaderText="需求号">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ReqName" HeaderText="需求名">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="23%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="AssignManName" HeaderText="分派人">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="BeginDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="StartTime">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="EndDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="EndTime">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <%--  <asp:TemplateColumn HeaderText="Status">
    <ItemTemplate>
        <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
    </ItemTemplate>
    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
</asp:TemplateColumn>--%>
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <%# ShareClass.GetStatusHomeNameByRequirementStatus(Eval("Status").ToString()) %>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="8%" />
                                                                                </asp:TemplateColumn>

                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ReqID", "TTDocumentTreeView.aspx?RelatedType=Req&RelatedID={0}") %>'
                                                                                            Target="_blank"><img src ="ImagesSkin/Doc.gif"  class="noBorder" /></asp:HyperLink>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <asp:Label ID="LB_Sql6" runat="server" Visible="False"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="height: 15px"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="width: 100%; height: 3px; text-align: left; padding: 5px 5px 5px 5px;">
                                                                        <span style="font-size: 10pt;">
                                                                            <asp:Label ID="Label36" runat="server" Text="<%$ Resources:lang,WoJianLiDeXuQiu%>"></asp:Label>:</span>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="text-align: left; padding: 5px 5px 5px 5px">
                                                                        <table width="95%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                            <tr>
                                                                                <td width="7">
                                                                                    <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                                </td>
                                                                                <td>
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="6%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label37" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="38%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,XuQiuMingCheng%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="10%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label39" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="15%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label40" runat="server" Text="<%$ Resources:lang,XuQiuRiQi%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="15%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label42" runat="server" Text="<%$ Resources:lang,JianLiRiQi%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label41" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td class="ItemAlignLeft">
                                                                                                <strong>&nbsp;</strong>
                                                                                            </td>
                                                                                            <td class="ItemAlignLeft">
                                                                                                <strong>&nbsp;</strong>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="6" align="right">
                                                                                    <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:DataGrid ID="DataGrid5" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                                            ShowHeader="false" CellPadding="4" ForeColor="#333333" GridLines="None" Height="1px"
                                                                            OnPageIndexChanged="DataGrid5_PageIndexChanged" PageSize="6" Width="95%">
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="ReqID" HeaderText="Number">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:HyperLinkColumn DataNavigateUrlField="ReqID" DataNavigateUrlFormatString="TTCreateReqDetail.aspx?ReqID={0}"
                                                                                    DataTextField="ReqName" HeaderText="需求名称" Target="_blank">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="38%" />
                                                                                </asp:HyperLinkColumn>
                                                                                <asp:BoundColumn DataField="ReqType" HeaderText="Type">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ReqFinishedDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="需求日期">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="MakeDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="建立日期">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                             
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <%# ShareClass.GetStatusHomeNameByRequirementStatus(Eval("Status").ToString()) %>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" />
                                                                                </asp:TemplateColumn>
                                                                                <asp:HyperLinkColumn DataNavigateUrlField="ReqID" DataNavigateUrlFormatString="TTReqAssignRecord.aspx?ReqID={0}"
                                                                                    Text="<%$ Resources:lang,AssignRecord %>" HeaderText="分派记录" Target="_blank">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" />
                                                                                </asp:HyperLinkColumn>

                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.ReqID", "TTDocumentTreeView.aspx?RelatedType=Req&RelatedID={0}") %>'
                                                                                            Target="_blank"><img src ="ImagesSkin/Doc.gif"  class="noBorder" /></asp:HyperLink>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" />
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                            <EditItemStyle BackColor="#2461BF" />
                                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                            <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                            <ItemStyle CssClass="itemStyle" />
                                                                        </asp:DataGrid>
                                                                        <asp:Label ID="LB_Sql5" runat="server" Visible="False"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td valign="top" width="165" style="padding: 5px 5px 0px 5px; border-left: solid 1px #d0d0d0">
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td style="width: 165; text-align: center; padding-top: 5px">
                                                            <asp:Button ID="BT_AllReq" runat="server" OnClick="BT_AllReq_Click" Text="<%$ Resources:lang,WoSuoYouDeXuQiu%>"
                                                                CssClass="inpuLong" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 165; text-align: center; padding-top: 5px">
                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                <tr>
                                                                    <td width="7">
                                                                        <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                    </td>
                                                                    <td>
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td width="6%" class="ItemAlignLeft">
                                                                                    <strong>
                                                                                        <asp:Label ID="Label43" runat="server" Text="<%$ Resources:lang,AnZhuangTaiFenLei%>"></asp:Label></strong>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td width="6" align="right">
                                                                        <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False" Width="100%"
                                                                ShowHeader="false" OnItemCommand="DataGrid2_ItemCommand" CellPadding="4" ForeColor="#333333"
                                                                GridLines="None">
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                                <ItemStyle CssClass="itemStyle" />
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="按状态分类:">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_Status" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Status") %>'
                                                                                CssClass="inpuLong" Visible="false" />
                                                                            <asp:Button ID="BT_HomeName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"HomeName") %>'
                                                                                CssClass="inpuLong" />
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" Horizontalalign="left" />
                                                                        <HeaderStyle Font-Bold="True" Font-Italic="False" Font-Overline="False" Font-Size="Small"
                                                                            Font-Strikeout="False" Font-Underline="False" />
                                                                    </asp:TemplateColumn>
                                                                </Columns>
                                                            </asp:DataGrid>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
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
