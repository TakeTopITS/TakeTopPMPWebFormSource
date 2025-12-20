<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTRCJProjectFundStartPlan.aspx.cs" Inherits="TTRCJProjectFundStartPlan" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>项目资金计划和实施</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 1200px;
            width: expression (document.body.clientWidth <= 1200? "1200px" : "auto" ));
        }
    </style>


    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }

            aHandler();

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
                                                <table width="280" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%>
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">项目资金计划和实施信息列表
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>
                                                <table border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="120">
                                                            <table width="320" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td align="right" width="200">申请金额:</td>
                                                                    <td class="ItemAlignLeft" width="120">
                                                                        <asp:TextBox ID="TB_TotalApplyMoney" runat="server"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td class="ItemAlignLeft" width="120">
                                                            <table width="320" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td align="right" width="200">金额标准:</td>
                                                                    <td class="ItemAlignLeft" width="120">
                                                                        <asp:TextBox ID="TB_TotalPlanMoney" runat="server"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td class="ItemAlignLeft" width="120">
                                                            <asp:CheckBox ID="CB_CheckType" runat="server" Text="<%$ Resources:lang,AnZhongLei%>" AutoPostBack="True" />
                                                        </td>
                                                        <td class="ItemAlignLeft" width="120">
                                                            <asp:CheckBox ID="CB_CheckMonth" runat="server" Text="<%$ Resources:lang,AnYueFen%>" AutoPostBack="True" />
                                                        </td>
                                                        <td>
                                                            <table width="320" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td align="right" width="200">按费项种类或月份条件查询:</td>
                                                                    <td class="ItemAlignLeft" width="120">
                                                                        <asp:Button ID="BT_QueryRecord" runat="server" Text="<%$ Resources:lang,ChaXun %>" OnClick="BT_QueryRecord_Click" Style="height: 27px" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table width="180" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click">返回</asp:LinkButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td height="31">
                                    <table class="ItemAlignLeft" border="0" cellpadding="0" cellspacing="0" width="96%">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <table class="ItemAlignLeft" border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" class="titlezi">
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" ShowHeaderWhenEmpty="True" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" PageSize="12" OnPageIndexChanging="GridView1_PageIndexChanging" OnRowDataBound="GridView1_RowDataBound">
                                                                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                                                            <Columns>
                                                                                <asp:BoundField DataField="ID" HeaderText="序号" />
                                                                                <asp:BoundField DataField="Amount" HeaderText="申请金额" />
                                                                                <asp:BoundField DataField="Purpose" HeaderText="用途说明" />
                                                                                <asp:BoundField DataField="CostFeeID" HeaderText="大类编号" />
                                                                                <asp:BoundField DataField="Title" HeaderText="临时设施项目(大类)" />
                                                                                <asp:BoundField DataField="CostFeeSubID" HeaderText="子类编号" />
                                                                                <asp:BoundField DataField="SubTitle" HeaderText="间接费项目分类" />
                                                                                <asp:BoundField DataField="AccountName" HeaderText="会计科目" />
                                                                                <asp:BoundField DataField="BudgetTime" HeaderText="预算年月" />
                                                                                <asp:BoundField DataField="AmountLevel" HeaderText="金额标准" />
                                                                                <asp:TemplateField HeaderText="审核标记">
                                                                                    <EditItemTemplate>
                                                                                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("IsReviewed") %>'></asp:TextBox>
                                                                                    </EditItemTemplate>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("IsReviewed").ToString().Trim()=="0"?"否":"是" %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:BoundField DataField="ActualAmount" HeaderText="执行金额" />
                                                                                <asp:CommandField ShowSelectButton="True" />
                                                                            </Columns>
                                                                            <EditRowStyle BackColor="#999999" />
                                                                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                                                            <PagerSettings Mode="NextPreviousFirstLast" />
                                                                            <PagerStyle BackColor="#284775" ForeColor="White" Horizontalalign="left" />
                                                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                                                            <SortedAscendingCellStyle BackColor="#E9E7E2" />
                                                                            <SortedAscendingHeaderStyle BackColor="#506C8C" />
                                                                            <SortedDescendingCellStyle BackColor="#FFFDF8" />
                                                                            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                                                                        </asp:GridView>
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
                            <tr>
                                <td height="31">
                                    <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <table width="100%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="ItemAlignLeft" class="titlezi">
                                                            <table width="100%" border="1" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" colspan="4">
                                                                        <table width="320" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="right" width="220">序号:</td>
                                                                                <td class="ItemAlignLeft" width="120">
                                                                                    <asp:TextBox ID="tbID" runat="server" ReadOnly="True"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="ItemAlignLeft">
                                                                        <table width="320" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="right" width="220">申请金额:</td>
                                                                                <td class="ItemAlignLeft" width="120">
                                                                                    <asp:TextBox ID="TB_Amount" runat="server"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td class="ItemAlignLeft" colspan="3">
                                                                        <table width="620" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="right" width="220">用途说明:</td>
                                                                                <td class="ItemAlignLeft" width="120">
                                                                                    <asp:TextBox ID="TB_Purpose" runat="server" Width="491px"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <table width="320" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="right" width="200">成本费项大类:</td>
                                                                                <td class="ItemAlignLeft" width="120">
                                                                                    <asp:DropDownList ID="DDL_CostFee" runat="server" AutoPostBack="True" OnTextChanged="DDL_CostFee_TextChanged">
                                                                                        <asp:ListItem>1</asp:ListItem>
                                                                                        <asp:ListItem>2</asp:ListItem>
                                                                                        <asp:ListItem>3</asp:ListItem>
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td>
                                                                        <table width="240" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="right" width="120">成本费项子类:</td>
                                                                                <td class="ItemAlignLeft" width="120">
                                                                                    <asp:DropDownList ID="DDL_CostSubFee" runat="server" AutoPostBack="True">
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td colspan="2">
                                                                        <table width="240" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="right" width="120">会计科目:</td>
                                                                                <td class="ItemAlignLeft" width="120">
                                                                                    <asp:DropDownList ID="DDL_AmountClass" runat="server" AutoPostBack="True">
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="ItemAlignLeft">
                                                                        <table width="320" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="right" width="220">预算月份:</td>
                                                                                <td class="ItemAlignLeft" width="120">
                                                                                    <asp:DropDownList ID="DDL_YearList" runat="server" AutoPostBack="True" OnTextChanged="DDL_CostFee_TextChanged">
                                                                                    </asp:DropDownList>
                                                                                    <asp:DropDownList ID="DDL_MonthList" runat="server" AutoPostBack="True" OnTextChanged="DDL_CostFee_TextChanged">
                                                                                    </asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td colspan="3">
                                                                        <table width="320" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td align="right" width="200">金额标准:</td>
                                                                                <td class="ItemAlignLeft" width="120">
                                                                                    <asp:TextBox ID="TB_AmountLevel" runat="server" Width="193px"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="ItemAlignLeft" colspan="4">
                                                                        <table class="ItemAlignLeft" border="0" cellpadding="0" cellspacing="0" width="240">
                                                                            <asp:Label ID="lb_ShowMessage" runat="server" ForeColor="Red" Text=""></asp:Label>
                                                                        </table>
                                                                    </td>
                                                                    <tr>
                                                                        <td>
                                                                            <table class="ItemAlignLeft" border="0" cellpadding="0" cellspacing="0" width="240">
                                                                                <asp:Button ID="btnAddNewItem" runat="server" OnClick="btnAddNewItem_Click" Text="<%$ Resources:lang,XinZengShuJu%>" Width="146px" />
                                                                            </table>
                                                                        </td>
                                                                        <td>
                                                                            <table class="ItemAlignLeft" border="0" cellpadding="0" cellspacing="0" width="240">
                                                                                <asp:Button ID="btnEditItem" runat="server" OnClick="btnEditItem_Click" Text="<%$ Resources:lang,XiuGaiShuJu%>" Width="146px" />
                                                                            </table>
                                                                        </td>
                                                                        <td class="ItemAlignLeft">
                                                                            <table class="ItemAlignLeft" border="0" cellpadding="0" cellspacing="0" style="width: 2px">
                                                                                <asp:Button ID="btnDeleteItem" runat="server" OnClick="btnDeleteItem_Click" OnClientClick="return confirm('您确认删除该记录吗?')" Text="<%$ Resources:lang,ShanChuShuJu%>" Width="146px" />
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
                                </td>
                            </tr>
                        </table>
                    </div>


                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="position: absolute; left: 40%; top: 40%;">
                <asp:UpdateProgress ID="TakeTopUp" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <img src="Images/Processing.gif" alt="请稍候，处理中..." />
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </div>
        </form>
    </center>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
