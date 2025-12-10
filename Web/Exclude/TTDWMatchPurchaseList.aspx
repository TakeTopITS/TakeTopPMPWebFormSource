<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTDWMatchPurchaseList.aspx.cs" Inherits="TTDWMatchPurchaseList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>原料-采购部</title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    
    <script language="javascript">

        function CalcTitle() {
            if (confirm("是否删除所有填写的数据，包括采购部原料价格记录表的数据？")) {
                document.getElementById("BT_Clear").click();
            }
        }


        function ClearMatchPrice() {
            if (confirm("确定清空所有原料价格吗？")) {
                document.getElementById("BT_ClearMatch").click();
            }
        }

    </script>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () { 

            

        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableScriptGlobalization="True" EnableScriptLocalization="True">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <div id="AboveDiv">
                        <table id="AboveTable" cellpadding="0" width="100%" cellspacing="0" class="bian">
                            <tr>
                                <td height="31" class="page_topbj">
                                    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <table width="345" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%>
                                                        </td>
                                                        <td align="center" background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,YuanLiao%>"></asp:Label>
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
                                <td style="padding: 0px 5px 5px 5px;" valign="top">
                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td valign="top" style="padding-top: 5px;">
                                                <table style="width: 100%;" cellpadding="2" cellspacing="0" class="formBgStyle">
                                                    <tr>
                                                        <td  style="width: 50%; padding: 5px 5px 5px 5px;" class="formItemBgStyleForAlignLeft" valign="top">

                                                            <table class="formBgStyle" width="100%">
                                                                <tr>
                                                                    <td  class="formItemBgStyleForAlignLeft">
                                                                        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,XuHao%>"></asp:Label>:</td>
                                                                    <td  class="formItemBgStyleForAlignLeft" colspan="3">
                                                                        <asp:TextBox ID="TXT_ID" runat="server" ReadOnly="true"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td  class="formItemBgStyleForAlignLeft">
                                                                        <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,YuanLiaoMingCheng%>"></asp:Label>:</td>
                                                                    <td  class="formItemBgStyleForAlignLeft">
                                                                        <asp:TextBox ID="TXT_MatchName" runat="server" ReadOnly="true"></asp:TextBox>
                                                                    </td>
                                                                    <td  class="formItemBgStyleForAlignLeft">
                                                                        <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,YuanLiaoLeiXing%>"></asp:Label>:</td>
                                                                    <td  class="formItemBgStyleForAlignLeft">
                                                                        <asp:DropDownList ID="DDL_RMatchType" runat="server" DataTextField="MatchType"
                                                                            DataValueField="ID">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td  class="formItemBgStyleForAlignLeft">
                                                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,YuanLiaoJiaGe%>"></asp:Label>:</td>
                                                                    <td  class="formItemBgStyleForAlignLeft">

                                                                        <asp:TextBox ID="TXT_MaterialPrice" runat="server"></asp:TextBox><br />

                                                                    </td>
                                                                    <td  class="formItemBgStyleForAlignLeft" colspan="2">
                                                                        <asp:Label ID="Label12" runat="server" Text="<%$ Resources:lang,Nian%>"></asp:Label>:
                                                                        <asp:DropDownList ID="DDL_HistoryYear" runat="server"></asp:DropDownList>
                                                                        <asp:Label ID="Label13" runat="server" Text="<%$ Resources:lang,Yue%>"></asp:Label>:
                                                                        <asp:DropDownList ID="DDL_HistoryMonth" runat="server"></asp:DropDownList>
                                                                        <font style="color:red;">
                                                                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,YuanLiaoLiShiJiaGeRiQi%>"></asp:Label></font>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td  class="formItemBgStyleForAlignLeft" colspan="4">
                                                                        <asp:Button ID="btnSave" runat="server" Text="<%$ Resources:lang,BaoCun%>" CssClass="inpu" OnClick="btnSave_Click" />
                                                                        <asp:Button ID="btnCancel" runat="server" Text="<%$ Resources:lang,QuXiao%>" CssClass="inpu" OnClick="btnCancel_Click" Visible="false" />
                                                                        <input type="button" value="清空原料价格" class="inpuLong" onclick="ClearMatchPrice();" />
                                                                        <asp:Button ID="BT_ClearMatch" CssClass="inpu" runat="server" Text="<%$ Resources:lang,QingKongYuanLiao%>" OnClick="BT_ClearMatch_Click" style="display:none;" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td  class="formItemBgStyleForAlignLeft" colspan="4">
                                                                        <asp:Repeater ID="RPT_History" runat="server">
                                                                            <HeaderTemplate>
                                                                                <table width="80%">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,ShiJian%>"></asp:Label></td>
                                                                                        <td>
                                                                                            <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,YuanLiaoJiaGe%>"></asp:Label></td>
                                                                                    </tr>
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <tr>
                                                                                    <td>
                                                                                        <%--<%# Eval("CreateTime") %>--%>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "CreateTime", "{0:yyyy}")%><asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,Nian%>"></asp:Label>
                                                                                        <%#DataBinder.Eval(Container.DataItem, "CreateTime", "{0:MM}")%><asp:Label ID="Label11" runat="server" Text="<%$ Resources:lang,Yue%>"></asp:Label>
                                                                                    </td>
                                                                                    <td><%# Eval("MaterialPrice") %></td>
                                                                                </tr>
                                                                            </ItemTemplate>
                                                                            <FooterTemplate>
                                                                                </table>
                                                                            </FooterTemplate>
                                                                        </asp:Repeater>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td  class="formItemBgStyleForAlignLeft" colspan="4">
                                                                        <input type="button" value="清空原料历史表" onclick="CalcTitle();" class="inpuLong" />
                                                                        <asp:Button ID="BT_Clear" runat="server" Text="<%$ Resources:lang,QingKongYuanLiaoLiShiBiao%>" CssClass="inpuLong" OnClick="BT_Clear_Click" style="display:none;" />
                                                                    </td>
                                                                </tr>
                                                            </table>

                                                        </td>
                                                        <td class="formItemBgStyleForAlignLeft" width="80%">
                                                            <asp:Label ID="Label9" runat="server" Text="<%$ Resources:lang,XuanZeYuanLiaoLeiXing%>"></asp:Label>:<asp:DropDownList ID="DDL_MatchType" runat="server" DataTextField="MatchType"
                                                            AutoPostBack="true" OnSelectedIndexChanged="DDL_MatchType_SelectedIndexChanged" DataValueField="ID">
                                                        </asp:DropDownList><br />
                                                            <asp:DataGrid ID="DG_Match" runat="server" AllowPaging="true" AutoGenerateColumns="False"
                                                                CellPadding="4" ForeColor="#333333" GridLines="None" Height="1px" PageSize="15" ShowHeader="True"
                                                                Width="100%" OnItemCommand="DG_Match_ItemCommand" OnPageIndexChanged="DG_Match_PageIndexChanged">
                                                                <Columns>
                                                                    <asp:TemplateColumn HeaderText="">
                                                                        <ItemTemplate>
                                                                            <asp:Button ID="BT_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'
                                                                                CommandName="edit" CommandArgument='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CssClass="inpu" />
                                                                            <%--<asp:Button ID="Button1" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ShanChu%>" CommandName="del" CommandArgument='<%# Eval("ID") %>' />--%>
                                                                        </ItemTemplate>
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" />
                                                                    </asp:TemplateColumn>
                                                                    <asp:BoundColumn DataField="MatchName" HeaderText="原料名称">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="MatchTypeName" HeaderText="原料类型">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>
                                                                    <asp:BoundColumn DataField="MaterialPrice" HeaderText="原料价格">
                                                                        <ItemStyle CssClass="itemBorder" HorizontalAlign="Center" />
                                                                    </asp:BoundColumn>
                                                                </Columns>
                                                                <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                <EditItemStyle BackColor="#2461BF" />
                                                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                <PagerStyle HorizontalAlign="Center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                                
                                                                <ItemStyle CssClass="itemStyle" />
                                                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                                                            </asp:DataGrid>
                                                            <asp:Label ID="LB_MatchSql" runat="server" Visible="False"></asp:Label>
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
                </div>
                <asp:HiddenField ID="HF_ID" runat="server" />
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btnSave" />
                <asp:PostBackTrigger ControlID="BT_Clear" />
            </Triggers>
        </asp:UpdatePanel>
    </form>
</body>
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script></html>
