<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTPersonalSpaceModuleSetForUser.aspx.cs" Inherits="TTPersonalSpaceModuleSetForUser" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #AboveDiv {
            min-width: 1200px;
            width: expression (document.body.clientWidth <= 1200? "1200px" : "auto" ));
        }

        input.bigcheck {
            height: 50px;
            width: 50px;
        }
    </style>

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }

        });

        //刷新父页面
        function reloadPrentPage() {

            parent.reloadPage();
        }

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
                                            <td class="ItemAlignLeft" width="245px">
                                                <table width="100%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29">
                                                            <a href="TTSuperSystemModuleSet.aspx">
                                                                <%--<img src="Logo/main_top_l.jpg" alt="" width="29" height="31" />--%></a>
                                                        </td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,GeRenKongJianLanWeiSheZhi%>"></asp:Label>
                                                        </td>
                                                        <td width="5">
                                                            <%-- <img src="ImagesSkin/main_top_r.jpg" width="5" height="31" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>

                                            <td style="text-align: right; padding-top: 5px;"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <table cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="ItemAlignLeft" style="padding: 5px 5px 0px 5px;">
                                                <table style="width: 100%;">
                                                    <tr>
                                                        <td>
                                                            <table cellpadding="0" cellspacing="0" width="100%">
                                                                <tr style="display:none;">
                                                                    <td style="text-align: left;">
                                                                        <asp:Label ID="LB_UserCode" runat="server" Style="font-weight: 700"></asp:Label>
                                                                        <asp:Label ID="LB_UserName" runat="server" Style="font-weight: 700"></asp:Label>
                                                                        <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,ZiMoZuLieBiao%>"></asp:Label>(<asp:Label ID="LB_ModuleNumber" runat="server"></asp:Label>):
                                                                    </td>
                                                                </tr>
                                                                <tr id="trNewsTypeList" runat="server" >
                                                                    <td>
                                                                        <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="" cellspacing="" width="100%">
                                                                            <tr>
                                                                                <td width="7">
                                                                                    <img height="26" src="ImagesSkin/main_n_l.jpg" width="7" />
                                                                                </td>
                                                                                <td>
                                                                                    <table border="0" cellpadding="" cellspacing="" width="100%">
                                                                                        <tr>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label71" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                                                            </strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label72" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                                                                (Home) </strong></td>
                                                                                            <td class="ItemAlignLeft" width="15%"><strong>
                                                                                                <asp:Label ID="Label73" runat="server" Text="<%$ Resources:lang,YuYan%>"></asp:Label>
                                                                                            </strong></td>
                                                                                            <td class="ItemAlignLeft" width="25%"><strong>
                                                                                                <asp:Label ID="Label68" runat="server" Text="<%$ Resources:lang,YeMian%>"></asp:Label>
                                                                                            </strong></td>

                                                                                            <td class="ItemAlignLeft" width="5%"><strong>
                                                                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,FanWei%>"></asp:Label>
                                                                                            </strong></td>
                                                                                            <td class="ItemAlignLeft" width="5%"><strong>
                                                                                                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,KeShi%>"></asp:Label>
                                                                                            </strong></td>
                                                                                            <td class="ItemAlignLeft"><strong>
                                                                                                <asp:Label ID="Label74" runat="server" Text="<%$ Resources:lang,ShunXu%>"></asp:Label>
                                                                                            </strong></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td align="right" width="6">
                                                                                    <img alt="" height="26" src="ImagesSkin/main_n_r.jpg" width="6" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:DataGrid ID="DataGrid1" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" ShowHeader="false" Width="100%">
                                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                            <EditItemStyle BackColor="#2461BF" />
                                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                            <PagerStyle HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" CssClass="notTab" />
                                                                            <ItemStyle CssClass="itemStyle" />
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="ID" HeaderText="ID" Visible="false">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Type" HeaderText="Type">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="HomeName" HeaderText="Type">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="LangCode" HeaderText="语言">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PageName" HeaderText="页面">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="24%" />
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="范围">
                                                                                    <ItemTemplate>
                                                                                        <asp:DropDownList ID="DL_NewsScope" runat="server">
                                                                                            <asp:ListItem Value="ALL" Text="<%$ Resources:lang,QuanBu%>"></asp:ListItem>
                                                                                            <asp:ListItem Value="INNER" Text="<%$ Resources:lang,NeiBu%>"></asp:ListItem>
                                                                                            <asp:ListItem Value="OUTER" Text="<%$ Resources:lang,WaiBu%>"></asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="可用">
                                                                                    <ItemTemplate>
                                                                                        <asp:CheckBox ID="CB_Visible" runat="server" />
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left"  Width="5%" />
                                                                                </asp:TemplateColumn>

                                                                                <asp:TemplateColumn HeaderText="顺序">
                                                                                    <ItemTemplate>
                                                                                        <asp:TextBox ID="TB_SortNumber" runat="server" Width="25px" Text='<%# DataBinder.Eval(Container.DataItem,"SortNumber") %>'></asp:TextBox>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                                                                </asp:TemplateColumn>

                                                                            </Columns>
                                                                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                        </asp:DataGrid>
                                                                    </td>
                                                                </tr>
                                                             
                                                                <tr>
                                                                    <td style="width: 100%">
                                                                        <table width="87%" border="0" cellpadding="0" cellspacing="0" background="ImagesSkin/main_n_bj.jpg">
                                                                            <tr>
                                                                                <td width="7">
                                                                                    <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                                                </td>
                                                                                <td>
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                          
                                                                                            <td width="15%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label17" runat="server" Text="<%$ Resources:lang,MoKuaiMingCheng%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="20%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,MingChengBenYu%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="5%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label22" runat="server" Text="<%$ Resources:lang,ShunXu%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="5%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,KeYong%>"></asp:Label></strong>
                                                                                            </td>
                                                                                            <td width="5%" class="ItemAlignLeft">
                                                                                                <strong>
                                                                                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,DuZhanYiHuang%>"></asp:Label></strong>
                                                                                            </td>

                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="6" align="right">
                                                                                    <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <asp:DataGrid ID="DataGrid4" runat="server" AutoGenerateColumns="False"
                                                                            ShowHeader="false" Height="1px"
                                                                            Width="87%" CellPadding="4" ForeColor="#333333" GridLines="None">
                                                                            <Columns>
                                                                              
                                                                                <asp:BoundColumn DataField="ModuleName" HeaderText="模块名称">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                                                </asp:BoundColumn>

                                                                                <asp:BoundColumn DataField="HomeModuleName" HeaderText="模块名称">
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                                                </asp:BoundColumn>

                                                                                <asp:TemplateColumn HeaderText="顺序">
                                                                                    <ItemTemplate>
                                                                                        <asp:TextBox ID="TB_SortNumber" runat="server" Width="40px" Text="0"></asp:TextBox>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="可用">
                                                                                    <ItemTemplate>
                                                                                        <asp:CheckBox ID="CB_ModuleVisible" runat="server" />
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                                                </asp:TemplateColumn>

                                                                                <asp:TemplateColumn HeaderText="每行列数">
                                                                                    <ItemTemplate>
                                                                                        <asp:DropDownList ID="DL_EveryRowColumnNumber" runat="server" Width="60px">
                                                                                            <asp:ListItem Value="1" Text="YES"></asp:ListItem>
                                                                                            <asp:ListItem Value="2" Selected="True" Text="NO"></asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                        <%--  <asp:TextBox ID="TB_EveryRowColumnNumber" runat="server" Width="40px" Text="2"></asp:TextBox>--%>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="5%" />
                                                                                </asp:TemplateColumn>

                                                                            </Columns>

                                                                            <ItemStyle CssClass="itemStyle" />
                                                                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                                                            <EditItemStyle BackColor="#2461BF" />
                                                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                                        </asp:DataGrid>
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td style="width: 100%; padding-right: 310px;" align="right">
                                                                        <br />
                                                                        <asp:Button ID="BT_ModuleSave" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" Enabled="false" OnClick="BT_ModuleSave_Click" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <asp:Label ID="LB_ErrorMsg" runat="server"></asp:Label>
                                                            <br />
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
<script type="text/javascript" language="javascript">var cssDirectory = '<%=Session["CssDirectory"] %>'; var oLink = document.getElementById('mainCss'); oLink.href = 'css/' + cssDirectory + '/' + 'bluelightmain.css';</script>
</html>
