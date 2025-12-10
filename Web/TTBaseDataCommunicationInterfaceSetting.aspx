<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTBaseDataCommunicationInterfaceSetting.aspx.cs" Inherits="TTBaseDataCommunicationInterfaceSetting" %>

<%@ Register Assembly="NickLee.Web.UI" Namespace="NickLee.Web.UI" TagPrefix="NickLee" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1. Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="mainCss" href="css/bluelightmain.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="js/allAHandler.js"></script>
    <script type="text/javascript" src="js/SetSortTextBoxMustInputIntegerNumber.js"></script>

    <style type="text/css">
        .auto-style1 {
            width: 200px;
        }

        select {
            height: 30px;
        }


        .action-icons {
            display: flex;
            gap: 5px;
            margin: 5px 0;
        }

        .action-icon {
            cursor: pointer;
            font-size: 14px;
            padding: 4px 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            background: #f5f5f5;
            transition: all 0.3s ease;
        }

            .action-icon:hover {
                background: #e0e0e0;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }

        .action-add {
            color: green;
            border-color: green;
        }

        .action-edit {
            color: blue;
            border-color: blue;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
        }

        .modal-content {
            position: fixed;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            min-width: 400px;
            max-width: 90%;
            max-height: 80%;
            overflow-y: auto;
            border: 1px solid #ddd;
        }

        .modal-header {
            border-bottom: 2px solid #57CD1;
            padding-bottom: 10px;
            margin-bottom: 15px;
            color: #333;
        }

        .modal-footer {
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 15px;
            text-align: right;
        }

        .close-modal {
            background: #f44336;
            color: white;
            border: none;
            padding: 6px 12px;
            cursor: pointer;
            border-radius: 4px;
            margin-left: 10px;
        }

            .close-modal:hover {
                background: #d32f2f;
            }

        .form-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

            .form-group label {
                display: inline-block;
                width: 120px;
                font-weight: bold;
                margin-right: 10px;
            }

            .form-group input, .form-group select {
                flex: 1;
                padding: 6px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

        .grid-add-icon {
            cursor: pointer;
            color: green;
            font-weight: bold;
            margin-left: 10px;
            font-size: 16px;
            padding: 4px 8px;
            border: 1px solid green;
            border-radius: 4px;
            background: #f0fff0;
            display: inline-block;
            text-align: center;
            min-width: 30px;
        }

            .grid-add-icon:hover {
                background: #e0ffe0;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,255,0,0.2);
            }
    </style>
    <script type="text/javascript" language="javascript">
        $(function () {
            if (top.location != self.location) { } else { CloseWebPage(); }
        });

        function showModal(modalId, buttonElement) {
            var modal = $('#' + modalId);
            modal.show();

            // 获取按钮在视口中的位置
            var buttonRect = buttonElement.getBoundingClientRect();

            // 获取模态框元素
            var modalElement = modal.find('.modal-content')[0];
            var modalWidth = modalElement.offsetWidth;
            var modalHeight = modalElement.offsetHeight;

            // 计算在按钮上方的位置（视口相对位置）
            var topPosition = buttonRect.top - modalHeight - 10; // 按钮上方10px
            var leftPosition = buttonRect.left;

            // 确保模态框不会超出视口
            var viewportWidth = window.innerWidth;
            var viewportHeight = window.innerHeight;

            // 水平方向调整
            if (leftPosition + modalWidth > viewportWidth) {
                leftPosition = Math.max(10, viewportWidth - modalWidth - 10);
            } else if (leftPosition < 0) {
                leftPosition = 10;
            }

            // 如果上方空间不够，调整到按钮下方
            if (topPosition < 0) {
                topPosition = buttonRect.bottom + 10;

                // 如果下方空间也不够，调整到视口中间
                if (topPosition + modalHeight > viewportHeight) {
                    topPosition = Math.max(10, (viewportHeight - modalHeight) / 2);
                }
            }

            // 确保不会超出底部边界
            if (topPosition + modalHeight > viewportHeight) {
                topPosition = Math.max(10, viewportHeight - modalHeight - 10);
            }

            // 设置模态框位置（相对于视口）
            $(modalElement).css({
                'top': topPosition + 'px',
                'left': leftPosition + 'px'
            });
        }

        function hideModal(modalId) {
            $('#' + modalId).hide();
        }

        // 为所有模态框添加点击外部关闭功能
        $(document).on('click', function (e) {
            $('.modal-overlay').each(function () {
                if ($(this).is(':visible') && !$(e.target).closest('.modal-content').length) {
                    $(this).hide();
                }
            });
        });

        // 阻止模态框内容点击事件冒泡
        $(document).on('click', '.modal-content', function (e) {
            e.stopPropagation();
        });

        // 处理新增按钮点击
        function handleAddClick(modalId, event) {
            if (event) {
                event.stopPropagation();
                event.preventDefault();
            }
            showModal(modalId, event.target);
            return false; // 阻止默认行为
        }

        // 全局函数，供后端调用
        function openModal(modalId) {
            var modal = $('#' + modalId);
            modal.show();

            // 居中显示模态框
            var modalElement = modal.find('.modal-content')[0];
            var topPosition = (window.innerHeight - modalElement.offsetHeight) / 2;
            var leftPosition = (window.innerWidth - modalElement.offsetWidth) / 2;

            // 设置模态框位置
            $(modalElement).css({
                'top': Math.max(topPosition, 20) + 'px',
                'left': Math.max(leftPosition, 20) + 'px'
            });
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
                        <table cellpadding="0" cellspacing="0" width="100%" class="bian">
                            <tr>
                                <td height="31" class="page_topbj">
                                    <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <table width="345" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29"></td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,TongXunJieKouLei%>"></asp:Label>
                                                            <asp:Label ID="LB_DepartString" runat="server" Visible="false"></asp:Label>
                                                        </td>
                                                        <td width="5"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="width: 100%; text-align: left;">
                                        <tr>
                                            <td colspan="2">
                                                <strong>
                                                    <asp:Label ID="Label492257" runat="server" Text="<%$ Resources:lang,WeiXinQiYeZhangHao%>"></asp:Label>
                                                </strong>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td colspan="2"><strong>
                                                <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,WeiXinGongZhongZhangHao%>"></asp:Label>
                                            </strong>
                                                <br />
                                                <div style="font-size: x-small; color: red;">
                                                    [<asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,ZSYYWXGZHDFWHBSDYH%>"></asp:Label>]
                                                </div>
                                            </td>
                                            <td colspan="4" width="400px">
                                                <table width="100%">
                                                    <tr>
                                                        <td><b>
                                                            <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,DuanXinJieKou%>"></asp:Label>
                                                        </b></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="ItemAlignLeft">[<a href="Template/SMSServiceInterfaceFormat.pdf" target="_blank"> <span style="font-size: x-small;">
                                                            <asp:Label ID="Label96" runat="server" Text="<%$ Resources:lang,GeShiShiLi%>"></asp:Label>
                                                        </span></a>] </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="ItemAlignLeft">
                                                <br />
                                                <asp:Label ID="Label18" runat="server" Text="CorpID"></asp:Label>
                                                <br />
                                                <asp:TextBox ID="TB_WeChatQYCorpID" runat="server" Width="99%"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label492259" runat="server" Text="<%$ Resources:lang,MiMa%>"></asp:Label>
                                                <br />
                                                <asp:TextBox ID="TB_WeChatQYSecret" runat="server" Width="99%"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label492260" runat="server" Text="<%$ Resources:lang,YingYongID%>"></asp:Label>
                                                <br />
                                                <asp:TextBox ID="TB_WeChatQYApplicationID" runat="server" Width="99%"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label57" runat="server" Text="<%$ Resources:lang,QiYong%>"></asp:Label>
                                                <br />
                                                <asp:DropDownList ID="DL_WeiXinQYHStatus" runat="server">
                                                    <asp:ListItem Value="NO">NO</asp:ListItem>
                                                    <asp:ListItem Value="YES">YES</asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <br />
                                                <asp:Button ID="BT_WeChatQYSave" runat="server" CssClass="inpu" OnClick="BT_WeChatQYSave_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                            </td>
                                            <td>&nbsp;</td>
                                            <td colspan="2" class="ItemAlignLeft">
                                                <br />
                                                <asp:Label ID="Label19" runat="server" Text="AppID"></asp:Label><br />
                                                <asp:TextBox ID="TB_WeiXinNo" runat="server" Width="350px"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label214" runat="server" Text="<%$ Resources:lang,MiMa%>"></asp:Label>
                                                <br />
                                                <asp:TextBox ID="TB_PassWord" runat="server" Width="350px"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,QiYong%>"></asp:Label>
                                                <br />
                                                <asp:DropDownList ID="DL_WeiXinGZHStatus" runat="server">
                                                    <asp:ListItem Value="NO">NO</asp:ListItem>
                                                    <asp:ListItem Value="YES">YES</asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <br />
                                                <asp:Button ID="BT_WeiXinStand" runat="server" CssClass="inpu" OnClick="BT_WeiXinStand_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                            </td>
                                            <td colspan="4" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="10%"><strong>ID</strong> </td>
                                                                    <td class="ItemAlignLeft" width="20%"><strong>
                                                                        <asp:Label ID="Label97" runat="server" Text="<%$ Resources:lang,FuWuShang%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label181" runat="server" Text="<%$ Resources:lang,JieKou%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="10%"><strong>
                                                                        <asp:Label ID="Label182" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="10%"><strong>
                                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalSMSInterface', event)">+</span>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid20" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid20_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="ID">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_ID" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="SPName" HeaderText="服务商">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="SPInterface" HeaderText="接口">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Status">
                                                            <ItemTemplate>
                                                                <%# ShareClass.GetStatusHomeNameByOtherStatus(Eval("Status").ToString()) %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="Left" Width="10%" />
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="10%" HorizontalAlign="Center" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" style="background-color: beige; height: 20px;"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="ItemAlignLeft"><b>
                                                <asp:Label ID="Label179" runat="server" Text="<%$ Resources:lang,NeiBuWangDuan%>"></asp:Label>
                                            </b></td>
                                            <td>&nbsp;</td>
                                            <td colspan="3" class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label192" runat="server" Text="<%$ Resources:lang,RTXFuWuQi%>"></asp:Label>
                                                    &nbsp;</strong></td>
                                            <td colspan="3" class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label486" runat="server" Text="<%$ Resources:lang,ShiPinHuiYiURL%>"></asp:Label>
                                                </strong>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" rowspan="7" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="16%"><strong>ID</strong> </td>
                                                                    <td class="ItemAlignLeft" width="42%"><strong>
                                                                        <asp:Label ID="Label183" runat="server" Text="<%$ Resources:lang,KaiShiWangDuan%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="42%"><strong>
                                                                        <asp:Label ID="Label184" runat="server" Text="<%$ Resources:lang,JieShuWangDuan%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="10%"><strong>
                                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalNetSegment', event)">+</span>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid25" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid25_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="ID">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_ID" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="16%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="BeginSegment" HeaderText="开始网段">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="42%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="EndSegment" HeaderText="结束网段">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="42%" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="10%" HorizontalAlign="Center" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                            <td rowspan="7">&nbsp;</td>
                                            <td class="ItemAlignLeft" colspan="3" rowspan="7">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
                                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                <tr>
                                                                    <td class="ItemAlignLeft" width="15%">&nbsp;</td>
                                                                    <td class="ItemAlignLeft" width="30%"><strong>ServerIP</strong> </td>
                                                                    <td class="ItemAlignLeft" width="15%"><strong>
                                                                        <asp:Label ID="Label195" runat="server" Text="<%$ Resources:lang,DuanKou%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="40%"><strong>WebSite</strong> </td>
                                                                    <td class="ItemAlignLeft" width="10%"><strong>
                                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalRTXConfig', event)">+</span>
                                                                    </strong></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="right" width="6">
                                                            <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <asp:DataGrid ID="DataGrid31" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid31_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
                                                    <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                    <EditItemStyle BackColor="#2461BF" />
                                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                                    <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                                    <ItemStyle CssClass="itemStyle" />
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="ID">
                                                            <ItemTemplate>
                                                                <asp:Button ID="BT_ID2" runat="server" CssClass="inpu" Text="<%$ Resources:lang,XuanZe%>" CommandName="Edit" />
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="ServerIP" HeaderText="接口">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="ServerPort" HeaderText="Status">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                                        </asp:BoundColumn>
                                                        <asp:BoundColumn DataField="WebSite" HeaderText="网址">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="10%" HorizontalAlign="Center" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                            <td colspan="3" class="ItemAlignLeft">
                                                <asp:Label ID="Label487" runat="server" Text="<%$ Resources:lang,ShiPinHuiYiDiZhi%>"></asp:Label>
                                                <br />
                                                <asp:TextBox ID="TXT_MeetingSystemURL" runat="server" Width="98%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" class="ItemAlignLeft">
                                                <asp:Label ID="Label488" runat="server" Text="<%$ Resources:lang,ShiPinXiTongDiZhi%>"></asp:Label>
                                                <br />
                                                <asp:TextBox ID="TXT_MeetingURL" runat="server" Width="98%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" class="ItemAlignLeft">
                                                <asp:Label ID="Label489" runat="server" Text="<%$ Resources:lang,ShiPinDianShu%>"></asp:Label>
                                                <br />
                                                <asp:TextBox ID="TXT_MeetingCount" runat="server" Text="3" Width="98%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" class="ItemAlignLeft">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" class="ItemAlignLeft">
                                                <asp:Button ID="BT_MeetingSystem" runat="server" CssClass="inpu" OnClick="BT_MeetingSystem_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- 所有模态框定义 -->
                    <!-- 短信接口模态框 -->
                    <div id="modalSMSInterface" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalSMS" runat="server" Text="<%$ Resources:lang,DuanXinJieKou%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label186" runat="server" Text="<%$ Resources:lang,FuWuShang%>"></asp:Label>
                                    <asp:TextBox ID="TB_SPName" runat="server" Width="300px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label188" runat="server" Text="<%$ Resources:lang,JieKou%>"></asp:Label>
                                    <asp:TextBox ID="TB_SPInterface" runat="server" Height="60px" TextMode="MultiLine" Width="300px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                    <asp:DropDownList ID="DL_SPInterfaceSTatus" runat="server">
                                        <asp:ListItem Text="<%$ Resources:lang,ChuLiZhong%>" Value="InProgress" />
                                        <asp:ListItem Text="<%$ Resources:lang,BeiYong%>" Value="Backup" />
                                    </asp:DropDownList>
                                </div>
                                <asp:Label ID="LB_SMSInterfaceID" runat="server" Visible="false"></asp:Label>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddSPInterface" runat="server" CssClass="inpu" OnClick="BT_AddSPInterface_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteSPInterface" runat="server" CssClass="inpu" OnClick="BT_DeleteSPInterface_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalSMSInterface')">
                                    <asp:Label ID="Label36745675" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 内部网段模态框 -->
                    <div id="modalNetSegment" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalNetSegment" runat="server" Text="<%$ Resources:lang,NeiBuWangDuan%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label189" runat="server" Text="<%$ Resources:lang,KaiShiWangDuan%>"></asp:Label>
                                    <asp:TextBox ID="TB_BeginNetSegment" runat="server" Width="300px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label191" runat="server" Text="<%$ Resources:lang,JieShuWangDuan%>"></asp:Label>
                                    <asp:TextBox ID="TB_EndNetSegment" runat="server" Width="300px"></asp:TextBox>
                                </div>
                                <asp:Label ID="LB_NetSegmentID" runat="server" Visible="false"></asp:Label>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddNetSegment" runat="server" CssClass="inpu" OnClick="BT_AddNetSegment_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteNetSegment" runat="server" CssClass="inpu" OnClick="BT_DeleteNetSegment_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalNetSegment')">
                                    <asp:Label ID="LabelNetSegmentClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- RTX配置模态框 -->
                    <div id="modalRTXConfig" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalRTX" runat="server" Text="<%$ Resources:lang,RTXFuWuQi%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label198" runat="server" Text="<%$ Resources:lang,FuWuQiIP%>"></asp:Label>
                                    <asp:TextBox ID="TB_RTXServerIP" runat="server" Text="127...1" Width="300px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label199" runat="server" Text="<%$ Resources:lang,DuanKou%>"></asp:Label>
                                    <asp:TextBox ID="TB_RTXServerPort" runat="server" Text="86" Width="300px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label21" runat="server" Text="<%$ Resources:lang,WangZhi%>"></asp:Label>
                                    <asp:TextBox ID="TB_RTXWebSite" runat="server" Width="300px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddRTX" runat="server" CssClass="inpu" OnClick="BT_AddRTX_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteRTX" runat="server" CssClass="inpu" OnClick="BT_DeleteRTX_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalRTXConfig')">
                                    <asp:Label ID="LabelRTXClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="position: absolute; left: 5%; top: 5%;">
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
