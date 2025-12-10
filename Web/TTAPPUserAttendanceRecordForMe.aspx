<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPUserAttendanceRecordForMe.aspx.cs" Inherits="TTAPPUserAttendanceRecordForMe" %>

<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;  user-scalable=1" />

<!DOCTYPE html>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
     <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        body {
            /*margin-top: 5px;*/
            /*background-image: url(Images/login_bj.jpg);*/
            background-repeat: repeat-x;
            font: normal 100% Helvetica, Arial, sans-serif;
        }
    </style>

    <style type="text/css">
        #AboveDiv {
            min-width: 2180px;
            width: expression (document.body.clientWidth <= 2180? "2180px" : "auto" ));
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { initSwipeBack();// 初始化滑动返回功能  initSwipeBack();// 初始化滑动返回功能

            //

        });

    </script>
</head>
<body><div id="swipeFeedback" class="swipe-feedback"><asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYY%>" /></div> <!-- 滑动反馈层 -->
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
                                                    </tr>
                                                </table>
                                                   <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style ="display :none;" />
                                            </a>
                                        </td>
                                        <td   class="ItemAlignLeft">
                                          
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
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" /></td>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="3%"><strong>ID</strong> </td>
                                                                    <td width="4%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,ZhuGuan%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="6%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,JianLiShiJian%>"></asp:Label></strong>
                                                                    </td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label268" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label269" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="2%"><strong>
                                                                        <asp:Label ID="Label53" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label271" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="2%"><strong>
                                                                        <asp:Label ID="Label5" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label272" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label273" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="2%"><strong>
                                                                        <asp:Label ID="Label42" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label274" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label275" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="2%"><strong>
                                                                        <asp:Label ID="Label46" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label276" runat="server" Text="<%$ Resources:lang,WanBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label277" runat="server" Text="<%$ Resources:lang,WanBanShangBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="2%"><strong>
                                                                        <asp:Label ID="Label48" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label278" runat="server" Text="<%$ Resources:lang,WanBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label279" runat="server" Text="<%$ Resources:lang,WanBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="2%"><strong>
                                                                        <asp:Label ID="Label49" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label2118" runat="server" Text="<%$ Resources:lang,JiaBanShangBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label281" runat="server" Text="<%$ Resources:lang,JiaBanShangBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="2%"><strong>
                                                                        <asp:Label ID="Label50" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>

                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label282" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanKaiShiShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label283" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanJieShuShiJian%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="2%"><strong>
                                                                        <asp:Label ID="Label52" runat="server" Text="IsMust"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="4%"><strong>
                                                                        <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,YunXiZuiDaJuLi%>"></asp:Label>
                                                                    </strong>(<asp:Label ID="Label56" runat="server" Text="<%$ Resources:lang,Mi%>"></asp:Label>)</td>


                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width="6" align="right">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" /></td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" PageSize="20" ShowHeader="false" Width="100%">
                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ID" HeaderText="ID">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="3%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="CreateDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="建立时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckInStart" HeaderText="早班上班开始时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckInEnd" HeaderText="早班上班结束时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckInIsMust" HeaderText="早班上班必须">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckOutStart" HeaderText="早班下班开始时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckOutEnd" HeaderText="早班下班结束时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="MCheckOutIsMust" HeaderText="早班下班必须">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckInStart" HeaderText="中班上班开始时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckInEnd" HeaderText="中班上班结束时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckInIsMust" HeaderText="中上午上班必须">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckOutStart" HeaderText="中班下班开始时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckOutEnd" HeaderText="中班下班结束时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ACheckOutIsMust" HeaderText="中午下班必须">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckInStart" HeaderText="晚班上班开始时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckInEnd" HeaderText="晚班上班结束时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckInIsMust" HeaderText="晚班上班必须">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckOutStart" HeaderText="晚班下班开始时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckOutEnd" HeaderText="晚班下班结束时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NCheckOutIsMust" HeaderText="晚班下班必须">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckInStart" HeaderText="加班上班开始时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckInEnd" HeaderText="加班上班结束时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckInIsMust" HeaderText="加班上班必须">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckOutStart" HeaderText="加班下班开始时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckOutEnd" HeaderText="加班下班结束时间">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="OCheckOutIsMust" HeaderText="加班下班必须">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LargestDistance" HeaderText="MaximumAllowedDistance">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
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
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="formItemBgStyleForAlignLeft">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="2%" class="ItemAlignLeft">
                                                                        <strong>ID</strong>
                                                                    </td>

                                                                    <td width="5%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,XingMing%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="5%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ZhuGuan%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="6%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,ChuQingRiQi%>"></asp:Label></strong>
                                                                    </td>
                                                                    
                                                                    <td width="4%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,ChiDao%>"></asp:Label></strong>
                                                                        (<asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,Minute%>"></asp:Label>)
                                                                    </td>

                                                                    <td width="4%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,ZaoTui%>"></asp:Label></strong>
                                                                        (<asp:Label ID="Label25" runat="server" Text="<%$ Resources:lang,Minute%>"></asp:Label>)
                                                                    </td>
                                                                     <td width="6%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,YunXiZuiDaJuLi%>"></asp:Label></strong>
                                                                        (<asp:Label ID="Label26" runat="server" Text="<%$ Resources:lang,Mi%>"></asp:Label>)
                                                                    </td>
                                                                    <td width="8%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,ZaoBanShangBanShiJian%>"></asp:Label></strong>
                                                                    </td>

                                                                    <td width="8%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,ZaoBanXiaBanShiJian%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="8%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,ZhongBanShangBanShiJian%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="8%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,ZhongBanXiaBanShiJian%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="8%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,WanBanShangBanShiJian%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="8%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,WanBanXiaBanShiJian%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="8%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,JiaBanShangBanShiJian%>"></asp:Label></strong>
                                                                    </td>
                                                                    <td width="8%" class="ItemAlignLeft">
                                                                        <strong>
                                                                            <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,JiaBanXiaBanShiJian%>"></asp:Label></strong>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td width="6" align="right">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    ShowHeader="false" ForeColor="#333333" GridLines="None" AllowPaging="True" OnPageIndexChanged="DataGrid1_PageIndexChanged"
                                                    PageSize="50" Width="100%">
                                                    <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle Horizontalalign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />

                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:BoundColumn DataField="ID" HeaderText="Number">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="2%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="UserName" HeaderText="Name">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LeaderName" HeaderText="主管">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="5%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="AttendanceDate" DataFormatString="{0:yyyy/MM/dd}" HeaderText="考勤日期">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="LateMinute" HeaderText="迟到分钟">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="EarlyMinute" HeaderText="早退分钟">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="4%" />
                                                        </asp:BoundColumn>
                                                         <asp:BoundColumn DataField="LargestDistance" HeaderText="MaximumAllowedDistance">
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="6%" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <%# Eval("MCheckIn").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("MCheckInAddress").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("MCheckInDistance").ToString().Trim () %> (m)
                                                              
                                                        <br />
                                                                IsMust:<%# Eval("MCheckInIsMust").ToString().Trim () %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>


                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <%# Eval("MCheckOut").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("MCheckOutAddress").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("MCheckOutDistance").ToString().Trim () %> (m)
                                                                
                                                    <br />
                                                                IsMust:<%# Eval("MCheckOutIsMust").ToString().Trim () %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>


                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <%# Eval("ACheckIn").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("ACheckInAddress").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("ACheckInDistance").ToString().Trim () %> (m)
                                                                
                                                        <br />
                                                                IsMust:<%# Eval("ACheckInIsMust").ToString().Trim () %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <%# Eval("ACheckOut").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("ACheckOutAddress").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("ACheckOutDistance").ToString().Trim () %> (m)
                                                                 
                                                        <br />
                                                                IsMust:<%# Eval("ACheckOutIsMust").ToString().Trim () %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <%# Eval("NCheckIn").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("NCheckInAddress").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("NCheckInDistance").ToString().Trim () %> (m)
                                                                
                                                        <br />
                                                                IsMust:<%# Eval("NCheckInIsMust").ToString().Trim () %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <%# Eval("NCheckOut").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("NCheckOutAddress").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("NCheckOutDistance").ToString().Trim () %> (m)
                                                               
                                                        <br />
                                                                IsMust: <%# Eval("NCheckOutIsMust").ToString().Trim () %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <%# Eval("OCheckIn").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("OCheckInAddress").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("OCheckInDistance").ToString().Trim () %> (m)
                                                                 
                                                        <br />
                                                                IsMust: <%# Eval("OCheckInIsMust").ToString().Trim () %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" Horizontalalign="left" Width="8%" />
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <%# Eval("OCheckOut").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("OCheckOutAddress").ToString().Trim () %>
                                                                <br />
                                                                <%# Eval("OCheckOutDistance").ToString().Trim () %> (m)
                                                                  
                                                        <br />
                                                                IsMust: <%# Eval("OCheckOutIsMust").ToString().Trim () %>
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
