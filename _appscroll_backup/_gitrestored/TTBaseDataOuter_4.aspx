<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTBaseDataOuter_4.aspx.cs" Inherits="TTBaseDataOuter_4" %>

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
            font-size: 16px;
            padding: 4px 8px;
            border: 1px solid green;
            border-radius: 4px;
            background: #f0fff0;
            display: inline-block;
            text-align: center;
            min-width: 30px;
            float: right;
            margin-left: 10px;
        }

            .grid-add-icon:hover {
                background: #e0ffe0;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,255,0,0.2);
            }

        .header-with-button {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }

        .header-title {
            flex: 1;
        }

        .header-button {
            margin-left: auto;
        }

        .table-header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
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

            // 计算在按钮上方的位置(视口相对位置)
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

            // 设置模态框位置(相对于视口)
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
                                <td colspan="5" style="background-color: buttonface; text-align: left;">
                                    <div class="header-with-button">
                                        <div class="header-title">
                                            <strong>
                                                <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,XiangMuRenWuLei%>"></asp:Label>
                                            </strong>
                                        </div>
                                    </div>
                                </td>
                                <td style="background-color: buttonface"></td>
                                <td colspan="2" style="background-color: buttonface"></td>
                            </tr>
                            <tr>
                                <td style="width: 198px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label334" runat="server" Text="<%$ Resources:lang,XiangMuRenWuLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalTaskType', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label319" runat="server" Text="<%$ Resources:lang,XuQiuLeiXingSheDing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalReqType', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,RenWuCaoZuoSheDing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalTaskOperation', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label462211" runat="server" Text="<%$ Resources:lang,RenWuFenPaiJiLuLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalTaskRecordType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label422211" runat="server" Text="<%$ Resources:lang,JiHuaLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalPlanType', event)">+</span>
                                    </div>
                                </td>
                                <td colspan="2">
                                    <div class="header-with-button">
                                        <b>
                                            <asp:Label ID="Label1811" runat="server" Text="<%$ Resources:lang,GongZuoRiZhiJiangJinCanShu%>"></asp:Label>
                                        </b>
                                        <span class="grid-add-icon">

                                            <asp:Button ID="BT_NewEveryCharPrice" runat="server" CssClass="inpu" OnClick="BT_NewEveryCharPrice_Click" Text="+" />
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label335" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label336" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid18" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid18_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_TaskType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td valign="top" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label321" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label3211" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid2" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid2_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ReqType" runat="server" CssClass="tt-sms-btn" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                                <td valign="top" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label4111" runat="server" Text="<%$ Resources:lang,CaoZuo%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label4211" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid7" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid7_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Operation">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_Operation" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Operation") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td valign="top" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label461" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label462" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid19" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid19_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_TaskRecordType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label421" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label422" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid28" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid28_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Name">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_PlanType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td colspan="2" valign="top" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="15%"><strong>
                                                            <asp:Label ID="Label113" runat="server" Text="<%$ Resources:lang,ID%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label114" runat="server" Text="<%$ Resources:lang,ZiFuDanJia%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label115" runat="server" Text="<%$ Resources:lang,ZiFuShangXian%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label116" runat="server" Text="<%$ Resources:lang,WenDangDanJia%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label117" runat="server" Text="<%$ Resources:lang,WenDangShangXian%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid23" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid23_ItemCommand" ShowHeader="false" Width="98%">
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
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="EveryCharPrice" HeaderText="字符单价">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="CharUpper" HeaderText="字符上限">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="EveryDocPrice" HeaderText="文档单价">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="DocUpper" HeaderText="文档上限">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="8" align="center" style="background-color: beige; height: 20px;">
                                    <table>
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <asp:Label ID="Label94" runat="server" Text="<%$ Resources:lang,TiaoMaLeiXing%>"></asp:Label>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <asp:DropDownList ID="DL_BarType" AutoPostBack="true" runat="server" OnSelectedIndexChanged="DL_BarType_SelectedIndexChanged">
                                                    <asp:ListItem Value="BarCode" Text="<%$ Resources:lang,TiaoXingMa%>" />
                                                    <asp:ListItem Value="NoLogoQrCode" Text="<%$ Resources:lang,ErWeiMa%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="ItemAlignLeft" colspan="3">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label4119" runat="server" Text="<%$ Resources:lang,DaiMaGuiZe%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalCodeRule', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label62" runat="server" Text="<%$ Resources:lang,ChengBaoShangDaLei%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalSupplierBigType', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label492272" runat="server" Text="<%$ Resources:lang,ChengBaoShangXiaoLei%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalSupplierSmallType', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;" colspan="2">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label81" runat="server" Text="<%$ Resources:lang,ChengBaoLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalBMBidType', event)">+</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="ItemAlignLeft" colspan="3" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="15%"><strong>
                                                            <asp:Label ID="Label491" runat="server" Text="<%$ Resources:lang,XuHao%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label492" runat="server" Text="<%$ Resources:lang,DaiMaLeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="15%"><strong>
                                                            <asp:Label ID="Label493" runat="server" Text="<%$ Resources:lang,KaiTouZiFu%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label494" runat="server" Text="<%$ Resources:lang,YuGuiZe%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label495" runat="server" Text="<%$ Resources:lang,LiuShuiHaoKuanDu%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="100%"><strong>
                                                            <asp:Label ID="Label496" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid44" runat="server" AutoGenerateColumns="False" GridLines="None" OnItemCommand="DataGrid44_ItemCommand" ShowHeader="False" Width="100%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="SerialNumber">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_CodeRuleID" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="CodeType" HeaderText="代码类型">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="HeadChar" HeaderText="开头字符">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="15%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="FieldName" HeaderText="域规则">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="FlowIDWidth" HeaderText="ID宽度">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="IsStartup" HeaderText="启动否">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="100%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                                <td valign="top" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label63" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label68" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid5" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid5_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_SupplierBigType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td valign="top" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label75" runat="server" Text="<%$ Resources:lang,XiaoLei%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label71" runat="server" Text="<%$ Resources:lang,DaLei%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label72" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid6" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid6_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_SupplierSmallType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="BigType" HeaderText="MajorCategory">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td colspan="2" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label82" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label83" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft">
                                                            <strong>
                                                                <asp:Label ID="Label87" runat="server" Text="<%$ Resources:lang,MuBan%>"></asp:Label></strong>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid8" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid8_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_BMBidType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:TemplateColumn>
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="HL_WorkflowWFTemplate" Text="<%$ Resources:lang,LiuCheng%>" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.Type", "TTAttachWorkFlowTemplate.aspx?RelatedType=BMBidType&RelatedName={0}") %>'
                                                        Target="_blank"></asp:HyperLink>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" />
                                            </asp:TemplateColumn>

                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="8" style="background-color: beige; height: 20px;"></td>
                            </tr>
                            <tr>
                                <td class="ItemAlignLeft" colspan="3">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label10" runat="server" Text="<%$ Resources:lang,TouBiaoZhuanYe%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalTenderContent', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;">
                                    <div class="header-with-button">
                                        <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,ZiJunLaiYuan%>"></asp:Label>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalFundingSource', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;">&nbsp;</td>
                                <td style="height: 7px;" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="ItemAlignLeft" colspan="3" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="100%"><strong>
                                                            <asp:Label ID="Label98" runat="server" Text="<%$ Resources:lang,ZhuanYe%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid13" runat="server" AutoGenerateColumns="False" GridLines="None" OnItemCommand="DataGrid13_ItemCommand" ShowHeader="False" Width="100%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="SerialNumber">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_TenderContent" runat="server" CssClass="inpuLongest" Width="99%" Text='<%# DataBinder.Eval(Container.DataItem,"TenderContent") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="100%" />
                                            </asp:TemplateColumn>

                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                                <td valign="top" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="100%"><strong>
                                                            <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,ZiJunLaiYuan%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid20" runat="server" AutoGenerateColumns="False" GridLines="None" OnItemCommand="DataGrid20_ItemCommand" ShowHeader="False" Width="100%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="SerialNumber">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_FundingSource" runat="server" CssClass="inpu" Width="99%" Text='<%# DataBinder.Eval(Container.DataItem,"FundingSource") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="100%" />
                                            </asp:TemplateColumn>

                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                                <td valign="top" class="ItemAlignLeft"></td>
                                <td colspan="2" class="ItemAlignLeft"></td>
                            </tr>
                        </table>
                    </div>

                    <!-- 所有模态框定义 -->
                    <!-- 项目任务类型模态框 -->
                    <div id="modalTaskType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalTaskType" runat="server" Text="<%$ Resources:lang,XiangMuRenWuLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label337" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_TaskType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492278" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_TaskTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_TaskTypeNew" runat="server" CssClass="inpu" OnClick="BT_TaskTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="TB_TaskTypeDelete" runat="server" CssClass="inpu" OnClick="BT_TaskTypeDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalTaskType')">
                                    <asp:Label ID="LabelTaskTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 需求类型模态框 -->
                    <div id="modalReqType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalReqType" runat="server" Text="<%$ Resources:lang,XuQiuLeiXingSheDing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label23" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_ReqType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label2811" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_ReqTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_ReqTypeNew" runat="server" CssClass="inpu" OnClick="BT_ReqTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_ReqTypeDelete" runat="server" CssClass="inpu" OnClick="BT_ReqTypeDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalReqType')">
                                    <asp:Label ID="LabelReqTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 任务操作模态框 -->
                    <div id="modalTaskOperation" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalTaskOperation" runat="server" Text="<%$ Resources:lang,RenWuCaoZuoSheDing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492211" runat="server" Text="<%$ Resources:lang,CaoZuo%>"></asp:Label>
                                    <asp:TextBox ID="TB_TaskOperation" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label54" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_OperationSortNumber" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_OperationNew" runat="server" CssClass="inpu" OnClick="BT_OperationNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_OperationDelete" runat="server" CssClass="inpu" OnClick="BT_OperationDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalTaskOperation')">
                                    <asp:Label ID="LabelTaskOperationClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 任务记录类型模态框 -->
                    <div id="modalTaskRecordType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalTaskRecordType" runat="server" Text="<%$ Resources:lang,RenWuFenPaiJiLuLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label463" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_TaskRecordType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label464" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_TaskRecordTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_TaskRecordNew" runat="server" CssClass="inpu" OnClick="BT_TaskRecordNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_TaskRecordDelete" runat="server" CssClass="inpu" OnClick="BT_TaskRecordDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalTaskRecordType')">
                                    <asp:Label ID="LabelTaskRecordTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 计划类型模态框 -->
                    <div id="modalPlanType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalPlanType" runat="server" Text="<%$ Resources:lang,JiHuaLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label423" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_PlanType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label424" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_PlanTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddPlanType" runat="server" CssClass="inpu" OnClick="BT_AddPlanType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeletePlanType" runat="server" CssClass="inpu" OnClick="BT_DeletePlanType_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalPlanType')">
                                    <asp:Label ID="LabelPlanTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 工作日志奖金参数模态框 -->
                    <div id="modalDailyWorkUnitBonus" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalDailyWorkUnitBonus" runat="server" Text="<%$ Resources:lang,GongZuoRiZhiJiangJinCanShu%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label124" runat="server" Text="<%$ Resources:lang,ZiFuDanJia%>"></asp:Label>
                                    <NickLee:NumberBox ID="NB_EveryCharPrice" runat="server" MaxAmount="10" Width="200px">.</NickLee:NumberBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label125" runat="server" Text="<%$ Resources:lang,ChangDuShangXian%>"></asp:Label>
                                    <NickLee:NumberBox ID="NB_CharUpper" runat="server" MaxAmount="10" Precision="0" Width="200px"></NickLee:NumberBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label129" runat="server" Text="<%$ Resources:lang,WenDangDanJia%>"></asp:Label>
                                    <NickLee:NumberBox ID="NB_EveryDocPrice" runat="server" MaxAmount="10" MinAmount="-10" Width="200px">.</NickLee:NumberBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label1311" runat="server" Text="<%$ Resources:lang,ShuLiangShangXian%>"></asp:Label>
                                    <NickLee:NumberBox ID="NB_DocUpper" runat="server" MaxAmount="10" MinAmount="-10" Precision="0" Width="200px"></NickLee:NumberBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Label ID="LB_DailyWorkUnitBonusID" runat="server" Visible="false"></asp:Label>
                                <asp:Button ID="BT_AddEveryCharPrice" runat="server" CssClass="inpu" OnClick="BT_AddEveryCharPrice_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteEveryDocPrice" runat="server" CssClass="inpu" OnClick="BT_DeleteEveryDocPrice_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalDailyWorkUnitBonus')">
                                    <asp:Label ID="LabelDailyWorkUnitBonusClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 代码规则模态框 -->
                    <div id="modalCodeRule" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalCodeRule" runat="server" Text="<%$ Resources:lang,DaiMaGuiZe%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label497" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:DropDownList ID="DL_CodeType" runat="server" Width="200px">
                                        <asp:ListItem Text="<%$ Resources:lang,XiangMuDaiMa%>" Value="ProjectCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,HeTongDaiMa%>" Value="ConstractCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,CaiGouDanHao%>" Value="PurchaseOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,FuKanShenQingDanHao%>" Value="PayApplyOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,XiaoSouBaoJiaDanHao%>" Value="QuotationOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,XiaoSouDingDanHao%>" Value="SaleOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,RuKuDanHao%>" Value="CheckInOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,ChuKuDanHao%>" Value="CheckOutOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,ShengChanDanHao%>" Value="ProductionOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,GeZhongShengQingDanHao%>" Value="ApplicationOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,SongHuoDanHao%>" Value="DeliveryOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,GongHuoDanHao%>" Value="SupplyOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,ChuHuTongZiDanHao%>" Value="OutNoticeOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,JieChuDanHao%>" Value="BorrowOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,TuiHuoHuoGuiHuanDanHao%>" Value="ReturnOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,DiaoBuDanHao%>" Value="TransferOrderCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,kehudaima%>" Value="CustomerCode" />
                                        <asp:ListItem Text="<%$ Resources:lang,gongyingshangdaima%>" Value="VendorCode" />
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label498" runat="server" Text="<%$ Resources:lang,KaiTouZiFu%>"></asp:Label>
                                    <asp:TextBox ID="TB_HeadChar" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label499" runat="server" Text="<%$ Resources:lang,YuGuiZe%>"></asp:Label>
                                    <asp:DropDownList ID="DL_FieldRule" runat="server" Width="200px">
                                        <asp:ListItem>[TAKETOPYEARMONTH]</asp:ListItem>
                                        <asp:ListItem>[TAKETOPYEARMONTHDAY]</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,LiuShuiHaoKuanDu%>"></asp:Label>
                                    <asp:TextBox ID="TB_FlowIDWidth" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label51" runat="server" Text="<%$ Resources:lang,QiYong%>"></asp:Label>
                                    <asp:DropDownList ID="DL_IsStartup" runat="server" Width="200px">
                                        <asp:ListItem Text="<%$ Resources:lang,YES%>" Value="YES" />
                                        <asp:ListItem Text="<%$ Resources:lang,NO%>" Value="NO" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Label ID="LB_CodeRuleID" runat="server" Visible="false"></asp:Label>
                                <asp:Button ID="BT_CodeRuleAdd" runat="server" CssClass="inpu" OnClick="BT_CodeRuleAdd_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_CodeRuleDelete" runat="server" CssClass="inpu" OnClick="BT_CodeRuleDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalCodeRule')">
                                    <asp:Label ID="LabelCodeRuleClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 承包商标大类模态框 -->
                    <div id="modalSupplierBigType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalSupplierBigType" runat="server" Text="<%$ Resources:lang,ChengBaoShangDaLei%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label69" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_SupplierBigType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label70" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_SupplierBigTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_SupplierBigTypeAdd" runat="server" CssClass="inpu" OnClick="BT_SupplierBigTypeAdd_Click" Text="<%$ Resources:lang,BaoCun%>" /> 
                                <asp:Button ID="BT_SupplierBigTypeDelete" runat="server" CssClass="inpu" OnClick="BT_SupplierBigTypeDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalSupplierBigType')">
                                    <asp:Label ID="LabelSupplierBigTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 承包商标小类模态框 -->
                    <div id="modalSupplierSmallType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalSupplierSmallType" runat="server" Text="<%$ Resources:lang,ChengBaoShangXiaoLei%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label80" runat="server" Text="<%$ Resources:lang,DaLei%>"></asp:Label>
                                    <asp:DropDownList ID="DL_SupplierBigType" runat="server" DataTextField="Type" DataValueField="Type" Width="200px">
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label76" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_SupplierSmallType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label77" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_SupplierSmallTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_SupplierSmallTypeAdd" runat="server" CssClass="inpu" OnClick="BT_SupplierSmallTypeAdd_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_SupplierSmallTypeDelete" runat="server" CssClass="inpu" OnClick="BT_SupplierSmallTypeDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalSupplierSmallType')">
                                    <asp:Label ID="LabelSupplierSmallTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 承包类型模态框 -->
                    <div id="modalBMBidType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalBMBidType" runat="server" Text="<%$ Resources:lang,ChengBaoLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label85" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_BMBidType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label86" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_BMBidTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_BMBidTypeAdd" runat="server" CssClass="inpu" OnClick="BT_BMBidTypeAdd_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_BMBidTypeDelete" runat="server" CssClass="inpu" OnClick="BT_BMBidTypeDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalBMBidType')">
                                    <asp:Label ID="LabelBMBidTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 投标专业模态框 -->
                    <div id="modalTenderContent" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalTenderContent" runat="server" Text="<%$ Resources:lang,TouBiaoZhuanYe%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label107" runat="server" Text="<%$ Resources:lang,XiangMuSuoSuoZhuanYe%>"></asp:Label>
                                    <asp:TextBox ID="TB_TenderContent" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_TenderContentAdd" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_TenderContentAdd_Click" />
                                <asp:Button ID="BT_TenderContentDelete" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ShanChu%>" OnClick="BT_TenderContentDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalTenderContent')">
                                    <asp:Label ID="LabelTenderContentClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 资金来源模态框 -->
                    <div id="modalFundingSource" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalFundingSource" runat="server" Text="<%$ Resources:lang,ZiJunLaiYuan%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label28" runat="server" Text="<%$ Resources:lang,ZiJunLaiYuan%>"></asp:Label>
                                    <asp:TextBox ID="TB_FundingSource" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_FundingSourceAdd" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_FundingSourceAdd_Click" />
                                <asp:Button ID="BT_FundingSourceDelete" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ShanChu%>" OnClick="BT_FundingSourceDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalFundingSource')">
                                    <asp:Label ID="LabelFundingSourceClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
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
