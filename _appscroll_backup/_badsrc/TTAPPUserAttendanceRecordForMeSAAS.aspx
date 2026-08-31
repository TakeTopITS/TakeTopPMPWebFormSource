<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPUserAttendanceRecordForMeSAAS.aspx.cs" Inherits="TTAPPUserAttendanceRecordForMeSAAS" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<!DOCTYPE html>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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
            initSwipeBack();// 初始化滑动返回功能  initSwipeBack();// 初始化滑动返回功能 


            //

        });

    </script>
</head>
<body><div id="swipeFeedback" class="swipe-feedback"><asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" /></div> <!-- 滑动反馈层 -->
    <center>
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div id="AboveDiv">
                    <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                        <tr>
                            <td height="31" class="page_topbj">
                                <table width="98%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target ="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">
                                                <table width="145" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <img src="ImagesSkin/return.png" alt="" />
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titleziAPP"><asp:Label ID="Label29" runat ="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                        <td width="5">
                                                            <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style ="display :none;" />
                                                         </td> 
                                                    </tr>
                                                </table>
                                            </a>
                                        </td>
                                        <td class="ItemAlignLeft">
                                          <%--  <table>
                                                <tr>
                                                    <td>  <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,ZhuGuanDaiMa%>"></asp:Label>:</td>
                                                    <td>
                                                        <asp:TextBox ID="TB_LeaderCode" Width="170px" runat="server"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        <asp:Button ID="BT_AddLeaderCode" CssClass="auto-style1" runat="server" Text="<%$ Resources:lang,JiaRu%>" OnClick="BT_AddLeaderCode_Click" />
                                                    </td>
                                                </tr>
                                            </table>--%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                    <div id="GoodsListDivID" style="width: 100%; height: 800px; overflow: auto;">
                                    <table style="width: 100%; text-align: left;">
                                        <tr>
                                            <td>
                                                <!-- DataGrid3 - 考勤规则 -->
                                                <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False" ShowHeader="false" CellPadding="4" ForeColor="#333333"
                                                    GridLines="None" OnItemCommand="DataGrid3_ItemCommand" Width="100%" PageSize="20">
                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" />

                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                            <ItemTemplate>
                                                                <strong>ID</strong><br />
                                                                <asp:Button ID="BT_ID" runat="server" CssClass="inpu"
                                                                    Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,ZhuGuan%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("LeaderName") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,JianLiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("CreateDate", "{0:yyyy/MM/dd}") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label268" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("MCheckInStart") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label269" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanJieShuShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("MCheckInEnd") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label53" runat="server" Text="IsMust"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("MCheckInIsMust") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("MCheckOutStart") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label271" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("MCheckOutEnd") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label5" runat="server" Text="IsMust"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("MCheckOutIsMust") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label272" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("ACheckInStart") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label273" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanJieShuShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("ACheckInEnd") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label42" runat="server" Text="IsMust"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("ACheckInIsMust") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label274" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("ACheckOutStart") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label275" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("ACheckOutEnd") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label46" runat="server" Text="IsMust"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("ACheckOutIsMust") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label276" runat="server" Text="<%$ Resources:lang,WanBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("NCheckInStart") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label277" runat="server" Text="<%$ Resources:lang,WanBanShangBanJieShuShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("NCheckInEnd") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label48" runat="server" Text="IsMust"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("NCheckInIsMust") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label278" runat="server" Text="<%$ Resources:lang,WanBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("NCheckOutStart") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label279" runat="server" Text="<%$ Resources:lang,WanBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("NCheckOutEnd") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label49" runat="server" Text="IsMust"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("NCheckOutIsMust") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label2118" runat="server" Text="<%$ Resources:lang,JiaBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("OCheckInStart") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label281" runat="server" Text="<%$ Resources:lang,JiaBanShangBanJieShuShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("OCheckInEnd") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label50" runat="server" Text="IsMust"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("OCheckInIsMust") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label282" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("OCheckOutStart") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label283" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("OCheckOutEnd") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label52" runat="server" Text="IsMust"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("OCheckOutIsMust") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,YunXiZuiDaJuLi%>"></asp:Label>
                                                                </strong><br />
                                                                (<asp:Label ID="Label56" runat="server" Text="<%$ Resources:lang,Mi%>"></asp:Label>)<br />
                                                                <%# Eval("LargestDistance") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" cellpadding="3" cellspacing="0" class="formBgStyle">
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                               
                                                <asp:Label ID="Label2120" runat="server" Text="<%$ Resources:lang,WoDeKaoQinJiLu%>"></asp:Label>
                                                <asp:DropDownList ID="DL_DisplayType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DL_DisplayType_SelectedIndexChanged">
                                                    <asp:ListItem Value="DisplayAbnormal" Text="<%$ Resources:lang,XianShiYiChang%>" />
                                                    <asp:ListItem Value="DisplayAll" Text="<%$ Resources:lang,XianShiQuanBu%>" />
                                                </asp:DropDownList>
                                                 <asp:Label ID="LB_LeaderCode" runat="server" Visible="false"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <!-- DataGrid1 - 考勤记录 -->
                                                <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    ShowHeader="false" ForeColor="#333333" GridLines="None" AllowPaging="True" OnPageIndexChanged="DataGrid1_PageIndexChanged"
                                                    PageSize="100" Width="100%">
                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>ID</strong><br />
                                                                <%# Eval("ID") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,XingMing%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("UserName") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZhuGuan%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("LeaderName") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ChuQingRiQi%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("AttendanceDate", "{0:yyyy/MM/dd}") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                        </asp:TemplateColumn>
                                                         
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,ChiDao%>"></asp:Label>
                                                                </strong><br />
                                                                (<asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,Minute%>"></asp:Label>)<br />
                                                                <%# Eval("LateMinute") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,ZaoTui%>"></asp:Label>
                                                                </strong><br />
                                                                (<asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,Minute%>"></asp:Label>)<br />
                                                                <%# Eval("EarlyMinute") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:TemplateColumn>
                                                          
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,YunXiZuiDaJuLi%>"></asp:Label>
                                                                </strong><br />
                                                                (<asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,Mi%>"></asp:Label>)<br />
                                                                <%# Eval("LargestDistance") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                        </asp:TemplateColumn>
                                                        
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("MCheckIn") %>
                                                                <br />
                                                                <%# Eval("MCheckInAddress") %>
                                                                <br />
                                                                <%# Eval("MCheckInDistance") %> (m)
                                                                <br />
                                                                IsMust:<%# Eval("MCheckInIsMust") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("MCheckOut") %>
                                                                <br />
                                                                <%# Eval("MCheckOutAddress") %>
                                                                <br />
                                                                <%# Eval("MCheckOutDistance") %> (m)
                                                                <br />
                                                                IsMust:<%# Eval("MCheckOutIsMust") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("ACheckIn") %>
                                                                <br />
                                                                <%# Eval("ACheckInAddress") %>
                                                                <br />
                                                                <%# Eval("ACheckInDistance") %> (m)
                                                                <br />
                                                                IsMust:<%# Eval("ACheckInIsMust") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("ACheckOut") %>
                                                                <br />
                                                                <%# Eval("ACheckOutAddress") %>
                                                                <br />
                                                                <%# Eval("ACheckOutDistance") %> (m)
                                                                <br />
                                                                IsMust:<%# Eval("ACheckOutIsMust") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,WanBanShangBanShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("NCheckIn") %>
                                                                <br />
                                                                <%# Eval("NCheckInAddress") %>
                                                                <br />
                                                                <%# Eval("NCheckInDistance") %> (m)
                                                                <br />
                                                                IsMust:<%# Eval("NCheckInIsMust") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,WanBanXiaBanShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("NCheckOut") %>
                                                                <br />
                                                                <%# Eval("NCheckOutAddress") %>
                                                                <br />
                                                                <%# Eval("NCheckOutDistance") %> (m)
                                                                <br />
                                                                IsMust: <%# Eval("NCheckOutIsMust") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,JiaBanShangBanShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("OCheckIn") %>
                                                                <br />
                                                                <%# Eval("OCheckInAddress") %>
                                                                <br />
                                                                <%# Eval("OCheckInDistance") %> (m)
                                                                <br />
                                                                IsMust: <%# Eval("OCheckInIsMust") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <strong>
                                                                    <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanShiJian%>"></asp:Label>
                                                                </strong><br />
                                                                <%# Eval("OCheckOut") %>
                                                                <br />
                                                                <%# Eval("OCheckOutAddress") %>
                                                                <br />
                                                                <%# Eval("OCheckOutDistance") %> (m)
                                                                <br />
                                                                IsMust: <%# Eval("OCheckOutIsMust") %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                        </tr>
                                        <tr style="display :none;">
                                            <td style="width: 100%; "  class="formItemBgStyleForAlignLeft">
                                                    &nbsp; &nbsp;<asp:Label ID="Label20" runat="server" Text="<%$ Resources:lang,Di%>"></asp:Label>:<asp:Label ID="LB_PageIndex" runat="server"></asp:Label>
                                                &nbsp;<asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,YeGong%>"></asp:Label>
                                                <asp:Label ID="LB_TotalPageNumber" runat="server"></asp:Label>
                                                &nbsp;<asp:Label ID="Label27" runat="server" Text="<%$ Resources:lang,Ye%>"></asp:Label><asp:Label ID="LB_Sql" runat="server" Visible="False"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                 </div> 
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
<%--<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>--%>

</html>