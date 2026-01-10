<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTAPPDailyWorkReportForCreator.aspx.cs" Inherits="TTAPPDailyWorkReportForCreator" %>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no" />

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <link id="flxappCss" href="css/flxapp.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>

    <script type="text/javascript">
        function preview() {
            bdhtml = window.document.body.innerHTML;
            sprnstr = "<!--startprint-->";
            eprnstr = "<!--endprint-->";
            prnhtml = bdhtml.substr(bdhtml.indexOf(sprnstr) + 18);
            prnhtml = prnhtml.substring(0, prnhtml.indexOf(eprnstr));
            window.document.body.innerHTML = prnhtml;
            window.print();
            document.body.innerHTML = bdhtml;
            return false;
        }

        function setValue(m_strValue) {
            if (m_strValue != null && m_strValue != undefined) {
                txtReturnValue.value = m_strValue;
            }
        }
    </script>
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            initSwipeBack();// 初始化滑动返回功能  initSwipeBack();// 初始化滑动返回功能



        });

    </script>

</head>
<body>
    <div id="swipeFeedback" class="swipe-feedback">
        <asp:Label ID="Label634424" runat="server" Text="<%$ Resources:lang,XYHDKHHSYYXXHDKSXBYM%>" /></div>
    <!-- 滑动反馈层 -->
    <center>
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
            </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>


                    <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                        <tr>
                            <td height="31" class="page_topbj">
                                <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td class="ItemAlignLeft">
                                            <a id="aAPPBackPriorPage" href="javascript:window.history.go(-1)" target="_top" onclick="javascript:document.getElementById('IMG_Waiting').style.display = 'block';">

                                                <table width="245" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <img src="ImagesSkin/return.png" alt="" />
                                                        </td>
                                                        <td width="80px" background="ImagesSkin/main_top_bj.jpg" class="titleziAPP">
                                                            <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,Back%>" />
                                                        </td>

                                                    </tr>
                                                </table>
                                                <img id="IMG_Waiting" src="Images/Processing.gif" alt="请稍候，处理中..." style="display: none;" />
                                            </a>
                                        </td>
                                        <td align="center" style="padding-top: 6px;">
                                            <asp:ImageButton ID="IB_ProPlanGanttNew" CssClass="inpu" ImageUrl="ImagesSkin/plan.png" Width="32px" Height="32px" runat="server" OnClick="IB_ProPlanGanttNew_Click"></asp:ImageButton>

                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <!--startprint-->

                                <table width="100%">
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,XiangMu%>"></asp:Label>:
                                                            <asp:Label ID="LB_ProjectID" runat="server"></asp:Label>
                                            <asp:Label ID="LB_ProjectName" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px;">
                                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,GongShi2%>"></asp:Label>: 
                                                            <asp:Label ID="LB_ConfirmManHour" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ItemAlignLeft">

                                            <asp:DataList ID="DataList1" runat="server" CellPadding="0" DataKeyField="WorkID"
                                                ShowHeader="false" Width="100%" BorderWidth="0">
                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                <ItemTemplate>

                                                    <div class="napbox">
                                                        <div class="npbx">
                                                            <div class="cline"></div>

                                                            <table cellpadding="4" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td colspan="2" class="ItemAlignLeft" style="color: Blue; font-style: italic; font-size: 10pt">
                                                                        <%#DataBinder .Eval (Container .DataItem ,"WorkID") %>
                                                                        <%#DataBinder .Eval (Container .DataItem ,"UserName") %>
                                                                        <%#DataBinder .Eval (Container .DataItem ,"WorkDate","{0:yyyy/MM/dd}") %>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="ItemAlignLeft" valign="top" style="width: 8%; padding-left: 5px" class="tdLeft">
                                                                        <span style="font-size: 10pt"><b>
                                                                            <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,MeiRiZongJie%>"></asp:Label>
                                                                        </b></span>
                                                                        <br />
                                                                        <span style="font-size: 9pt"><%#DataBinder .Eval (Container .DataItem ,"DailySummary") %></span></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="ItemAlignLeft" valign="top" style="width: 8%; padding-left: 5px" class="tdLeft">
                                                                        <span style="font-size: 10pt"><b>
                                                                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,ChengGuo%>"></asp:Label></b></span>
                                                                        <br />
                                                                        <span style="font-size: 9pt"><%#DataBinder .Eval (Container .DataItem ,"Achievement") %></span>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="ItemAlignLeft" valign="top" style="width: 8%; padding-left: 5px" class="tdLeft">
                                                                        <span style="font-size: 10pt">
                                                                            <b>
                                                                                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,DiZhi%>"></asp:Label>
                                                                            </b>
                                                                        </span>

                                                                        <span style="font-size: 9pt"><%#DataBinder .Eval (Container .DataItem ,"Address") %></span></td>
                                                                </tr>
                                                            </table>


                                                        </div>
                                                    </div>
                                                    </div>
                                                </ItemTemplate>

                                                <ItemStyle />
                                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                            </asp:DataList>

                                        </td>
                                    </tr>
                                </table>
                                <!--endprint-->



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
