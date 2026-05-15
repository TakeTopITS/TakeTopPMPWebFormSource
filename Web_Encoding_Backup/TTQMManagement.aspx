<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTQMManagement.aspx.cs" Inherits="TTQMManagement" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="Brettle.Web.NeatUpload" Namespace="Brettle.Web.NeatUpload" TagPrefix="Upload" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 1180px;
            width: expression (document.body.clientWidth <= 1180? "1180px" : "auto" ));
        }

        .auto-style1 {
            font-size: medium;
        }
    </style>
    <script type="text/javascript">

        var disPostion = 0;

        function SaveScroll() {
            //disPostion = AssetListDivID.scrollTop;
        }

        function RestoreScroll() {
            //Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        }

        function EndRequestHandler(sender, args) {
            //AssetListDivID.scrollTop = disPostion;
        }
    </script>
    <script src="js/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="js/allAHandler.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(function () { if (top.location != self.location) { } else { CloseWebPage(); }

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
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,ZhiLiangGuanLi%>"></asp:Label>
                                                        </td>
                                                        <td width="5">
                                                            <%--<img src="ImagesSkin/main_top_r.jpg" width="5" height="31" alt="" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="width: 100%;" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td style="width: 98%; border-right: solid 1px #D8D8D8;" valign="top">
                                                <table width="98%" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="ItemAlignLeft" style="height: 6px">
                                                            <table width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" style="font-size: x-large">
                                                                        <b><span class="auto-style1">
                                                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,XiangMuGeTongYanShouChan%>"></asp:Label></span></b></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="ItemAlignLeft">
                                                                        <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                        <tr>
                                                                                            <td class="ItemAlignLeft" width="8%"><strong>
                                                                                                <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,XiangMuHeTong%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="12%"><strong>
                                                                                                <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,GongYingShang%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="10%"><strong>
                                                                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="25%"><strong>
                                                                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,YanShouJieGuo%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,YanShouRiQi%>"></asp:Label></strong></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" Height="30px" ShowHeader="False" Width="100%">
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="Code" HeaderText="Number">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Name" HeaderText="Name">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PurchasingContractName" HeaderText="采购合同">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Supplier" HeaderText="Supplier">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="12%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <%# ShareClass. GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="InspectionResults" HeaderText="验收结果">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="25%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="InspectionDate" HeaderText="验收日期" DataFormatString="{0:yyyy-MM-dd}">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
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
                                                            <table width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" style="font-size: x-large">
                                                                        <b><span class="auto-style1">
                                                                            <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,ZhiLiangJianCha%>"></asp:Label></span></b></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="ItemAlignLeft">
                                                                        <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                        <tr>
                                                                                            <td class="ItemAlignLeft" width="8%"><strong>
                                                                                                <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,XiangMuHeTong%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="10%"><strong>
                                                                                                <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,JianChaRiQi%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="37%"><strong>
                                                                                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,JianChaNeiRong%>"></asp:Label></strong></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" Height="30px" ShowHeader="False" Width="100%">
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="Code" HeaderText="Number">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Name" HeaderText="Name">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PurchasingContractName" HeaderText="采购合同">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <%# ShareClass.GetStatusHomeNameByRequirementStatus(Eval("Status").ToString()) %>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="InspectionDate" HeaderText="检查日期" DataFormatString="{0:yyyy-MM-dd}">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ExaminationContent" HeaderText="检查内容">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="37%" />
                                                                                </asp:BoundColumn>
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
                                                            <table width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" style="font-size: x-large">
                                                                        <b><span class="auto-style1">
                                                                            <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,ManYiDuDiaoCha%>"></asp:Label></span></b></td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="ItemAlignLeft">
                                                                        <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                                        <tr>
                                                                                            <td class="ItemAlignLeft" width="10%"><strong>
                                                                                                <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,BianHao%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,XiangMuHeTong%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,GongYingShang%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="10%"><strong>
                                                                                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,ManYiChengDu%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="35%"><strong>
                                                                                                <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,DiaoChaNeiRong%>"></asp:Label></strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,DiaoChaRiQi%>"></asp:Label></strong></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" Height="30px" ShowHeader="False" Width="100%">
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="Code" HeaderText="Number">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PurchasingContractName" HeaderText="采购合同">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Supplier" HeaderText="Supplier">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="SatisfactionDegree" HeaderText="满意程度">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="10%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Remark" HeaderText="调查内容">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="35%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="EvaluationDate" HeaderText="调查日期" DataFormatString="{0:yyyy-MM-dd}">
                                                                                    <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="15%" />
                                                                                </asp:BoundColumn>
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
                                                        </td>
                                                    </tr>
                                                </table>
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
