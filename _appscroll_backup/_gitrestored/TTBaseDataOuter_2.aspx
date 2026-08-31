<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTBaseDataOuter_2.aspx.cs" Inherits="TTBaseDataOuter_2" %>

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
                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,JiBenLeiXingLei%>"></asp:Label>
                                            </strong>
                                        </div>
                                    </div>
                                </td>
                                <td style="background-color: buttonface"></td>
                                <td style="background-color: buttonface" colspan="2"></td>
                            </tr>
                            <tr>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label492229" runat="server" Text="<%$ Resources:lang,JiLiangDanWei%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalUnit', event)">+</span>
                                    </div>
                                </td>
                                <td colspan="3">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label4311" runat="server" Text="<%$ Resources:lang,BiBieLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalCurrency', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label84" runat="server" Text="<%$ Resources:lang,JueSeZuLeiXing%>"></asp:Label><span class="style1">*</span>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalActorGroup', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <b>
                                            <asp:Label ID="Label492239" runat="server" Text="<%$ Resources:lang,HangYeLeiXing%>"></asp:Label>
                                        </b>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalIndustryType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <b>
                                            <asp:Label ID="Label492234" runat="server" Text="<%$ Resources:lang,GongYiLeiXing%>"></asp:Label>
                                        </b>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalProductProcess', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label492273" runat="server" Text="<%$ Resources:lang,QueXianLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalDefectType', event)">+</span>
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
                                                            <asp:Label ID="Label492230" runat="server" Text="<%$ Resources:lang,DanWei%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492231" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid14" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid14_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Unit">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_UnitName" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"UnitName") %>' CommandName="Edit" />
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
                                <td colspan="3" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label4411" runat="server" Text="<%$ Resources:lang,BiBie%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label4511" runat="server" Text="<%$ Resources:lang,HuiLv%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label4611" runat="server" Text="<%$ Resources:lang,PaiXu%>"></asp:Label>
                                                        </strong>
                                                        </td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label61" runat="server" Text="<%$ Resources:lang,BenBi%>"></asp:Label>
                                                        </strong>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid35" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid35_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="ID">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_CurrencyType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="ExchangeRate" HeaderText="ExchangeRate">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="SortNo" HeaderText="顺充号">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="IsHome" HeaderText="<%$ Resources:lang,BenBi%>">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
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
                                                            <asp:Label ID="Label91" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label92" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid15" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid15_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ActorGroupType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                                            <asp:Label ID="Label492240" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492241" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid26" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid26_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_IndustryType" runat="server" CssClass="tt-sms-btn" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                                            <asp:Label ID="Label492235" runat="server" Text="<%$ Resources:lang,GongYi%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492236" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid3" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid3_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="工艺">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ProcessName" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"ProcessName") %>' CommandName="Edit" />
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
                                                            <asp:Label ID="Label492274" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492275" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid47" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid47_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_DefectType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="8" style="background-color: beige; height: 20px;">&nbsp;
                                </td>
                            </tr>
                        </table>
                        <table style="width: 100%; text-align: center;">
                            <tr>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label136" runat="server" Text="<%$ Resources:lang,BaoBiaoLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalReportType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label492224" runat="server" Text="<%$ Resources:lang,CheLiangLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalCarType', event)">+</span>
                                    </div>
                                </td>
                                <td style="height: 7px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label492251" runat="server" Text="<%$ Resources:lang,ShiYouXingHaoSheDing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalOilType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label194" runat="server" Text="<%$ Resources:lang,KeHuFuWuLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalCustomerQuestionType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label393" runat="server" Text="<%$ Resources:lang,HuiYiLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalMeetingType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label492262" runat="server" Text="<%$ Resources:lang,ShangJiJieDuan%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalCustomerQuestionStage', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label492267" runat="server" Text="<%$ Resources:lang,KeHuShangJiJieDuan%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalCustomerQuestionCustomerStage', event)">+</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td rowspan="2" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label145" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label146" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid29" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid29_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Name">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ReportType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                <td rowspan="2" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label492225" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492226" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid27" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid27_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Name">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_CarType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                <td valign="top" rowspan="2" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" alt="" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="30%"><strong>
                                                            <asp:Label ID="Label492252" runat="server" Text="<%$ Resources:lang,XuHao%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="70%"><strong>
                                                            <asp:Label ID="Label492253" runat="server" Text="<%$ Resources:lang,MingChengJiXingHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid33" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid33_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="SerialNumber">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ID" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="30%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="OilName" HeaderText="名称及型号">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="70%" />
                                            </asp:BoundColumn>
                                            <asp:TemplateColumn>
                                                <ItemStyle Width="10%" HorizontalAlign="Center" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td rowspan="2" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label196" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label197" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid32" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid32_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Name">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_CustomerQuestionType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                <td valign="top" rowspan="2" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label394" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label395" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid9" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid9_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_MeetingType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                <td rowspan="2" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label492263" runat="server" Text="<%$ Resources:lang,JieDuan%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492264" runat="server" Text="<%$ Resources:lang,KeNengXing%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid45" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid45_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="<%$ Resources:lang,JieDuan%>">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_Stage" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Stage") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="Possibility" HeaderText="可能性">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td rowspan="2" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label492268" runat="server" Text="<%$ Resources:lang,JieDuan%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492269" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid46" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid46_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Name">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_Stage" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Stage") %>' CommandName="Edit" />
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
                            </tr>
                        </table>

                    </div>

                    <!-- 所有模态框定义 -->
                    <!-- 计量单位模态框 -->
                    <div id="modalUnit" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalUnit" runat="server" Text="<%$ Resources:lang,JiLiangDanWei%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492232" runat="server" Text="<%$ Resources:lang,DanWei%>"></asp:Label>
                                    <asp:TextBox ID="TB_UnitName" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492233" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_UnitSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_UnitNew" runat="server" CssClass="inpu" OnClick="BT_UnitNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_UnitDelete" runat="server" CssClass="inpu" OnClick="BT_UnitDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalUnit')">
                                    <asp:Label ID="Label5225235" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 币别类型模态框 -->
                    <div id="modalCurrency" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalCurrency" runat="server" Text="<%$ Resources:lang,BiBieLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label47" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_CurrencyType" runat="server" Width="150px"></asp:TextBox>
                                    <asp:Label ID="Label60" runat="server" Text="<%$ Resources:lang,BenBi%>"></asp:Label>
                                    <asp:DropDownList ID="DL_IsHomeCurrency" runat="server">
                                        <asp:ListItem Value="NO">NO</asp:ListItem>
                                        <asp:ListItem Value="YES">YES</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label4811" runat="server" Text="<%$ Resources:lang,HuiLv%>"></asp:Label>
                                    <asp:TextBox ID="TB_ExchangeRate" runat="server" Width="150px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label4911" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_CurrencyTypeSortNo" runat="server" Width="150px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddCurrencyType" runat="server" CssClass="inpu" OnClick="BT_AddCurrencyType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteCurrencyType" runat="server" CssClass="inpu" OnClick="BT_DeleteCurrencyType_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalCurrency')">
                                    <asp:Label ID="Label3677567" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 角色组类型模态框 -->
                    <div id="modalActorGroup" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalActorGroup" runat="server" Text="<%$ Resources:lang,JueSeZuLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label99" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_ActorGroupType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label14" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_ActorGroupTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_ActorGroupNew" runat="server" CssClass="inpu" OnClick="BT_ActorGroupNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_ActorGroupDelete" runat="server" CssClass="inpu" OnClick="BT_ActorGroupDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalActorGroup')">
                                    <asp:Label ID="Label25453543" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 行业类型模态框 -->
                    <div id="modalIndustryType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalIndustryType" runat="server" Text="<%$ Resources:lang,HangYeLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492242" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_IndustryType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492243" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_IndustryTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddIndustryType" runat="server" CssClass="inpu" OnClick="BT_AddIndustryType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteIndustryType" runat="server" CssClass="inpu" OnClick="BT_DeleteIndustryType_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalIndustryType')">
                                    <asp:Label ID="LabelIndustryTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 工艺类型模态框 -->
                    <div id="modalProductProcess" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalProductProcess" runat="server" Text="<%$ Resources:lang,GongYiLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492237" runat="server" Text="<%$ Resources:lang,GongYi%>"></asp:Label>
                                    <asp:TextBox ID="TB_ProcessName" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492238" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_ProcessSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddProductProcess" runat="server" CssClass="inpu" OnClick="BT_AddProductProcess_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteProductProcess" runat="server" CssClass="inpu" OnClick="BT_DeleteProductProcess_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalProductProcess')">
                                    <asp:Label ID="LabelProductProcessClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 缺陷类型模态框 -->
                    <div id="modalDefectType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalDefectType" runat="server" Text="<%$ Resources:lang,QueXianLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492276" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_DefectType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492277" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_DefectTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_DefectTypeNew" runat="server" CssClass="inpu" OnClick="BT_DefectTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DefectTypeDelete" runat="server" CssClass="inpu" OnClick="BT_DefectTypeDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalDefectType')">
                                    <asp:Label ID="LabelDefectTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 报表类型模态框 -->
                    <div id="modalReportType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalReportType" runat="server" Text="<%$ Resources:lang,BaoBiaoLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label151" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_ReportType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492219" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_ReportTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddReportType" runat="server" CssClass="inpu" OnClick="BT_AddReportType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteReportType" runat="server" CssClass="inpu" OnClick="BT_DeleteReportType_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalReportType')">
                                    <asp:Label ID="LabelReportTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 车辆类型模态框 -->
                    <div id="modalCarType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalCarType" runat="server" Text="<%$ Resources:lang,CheLiangLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492227" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_CarType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492228" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_CarTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddCarType" runat="server" CssClass="inpu" OnClick="BT_AddCarType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteCarType" runat="server" CssClass="inpu" OnClick="BT_DeleteCarType_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalCarType')">
                                    <asp:Label ID="LabelCarTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 石油型号模态框 -->
                    <div id="modalOilType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalOilType" runat="server" Text="<%$ Resources:lang,ShiYouXingHaoSheDing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492254" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                    <asp:TextBox ID="txt_OilName" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492255" runat="server" Text="<%$ Resources:lang,XingHao%>"></asp:Label>
                                    <asp:TextBox ID="txt_OilType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <asp:TextBox ID="txt_ID" runat="server" Visible="false" Width="1px"></asp:TextBox>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="btn_OilTypeAdd" runat="server" CssClass="inpu" OnClick="btn_OilTypeAdd_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="btn_OilTypeDelete" runat="server" CssClass="inpu" OnClick="btn_OilTypeDelete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalOilType')">
                                    <asp:Label ID="LabelOilTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 客户服务类型模态框 -->
                    <div id="modalCustomerQuestionType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalCustomerQuestionType" runat="server" Text="<%$ Resources:lang,KeHuFuWuLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_CustomerQuestionType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label2112" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_CustomerQuestionTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddCustomerQuestionType" runat="server" CssClass="inpu" OnClick="BT_AddCustomerQuestionType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteCustomerQuestionType" runat="server" CssClass="inpu" OnClick="BT_DeleteCustomerQuestionType_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalCustomerQuestionType')">
                                    <asp:Label ID="LabelCustomerQuestionTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 会议类型模态框 -->
                    <div id="modalMeetingType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalMeetingType" runat="server" Text="<%$ Resources:lang,HuiYiLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label396" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_MeetingType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label397" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_MeetingTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_MeetingTypeNew1" runat="server" CssClass="inpu" OnClick="BT_MeetingTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_MeetingTypeDelete" runat="server" CssClass="inpu" OnClick="BT_MeetingTypeDelete_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalMeetingType')">
                                    <asp:Label ID="LabelMeetingTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 商机阶段模态框 -->
                    <div id="modalCustomerQuestionStage" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalCustomerQuestionStage" runat="server" Text="<%$ Resources:lang,ShangJiJieDuan%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492265" runat="server" Text="<%$ Resources:lang,JieDuan%>"></asp:Label>
                                    <asp:TextBox ID="TB_CustomerQuestionStage" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492266" runat="server" Text="<%$ Resources:lang,KeNengXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_CustomerQuestionPossibility" runat="server" Text="0" Width="200px"></asp:TextBox>%
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddCustomerQuestionStage" runat="server" CssClass="inpu" OnClick="BT_AddCustomerQuestionStage_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteCustomerQuestionPossibility" runat="server" CssClass="inpu" OnClick="BT_DeleteCustomerQuestionPossibility_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalCustomerQuestionStage')">
                                    <asp:Label ID="LabelCustomerQuestionStageClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 客户商机阶段模态框 -->
                    <div id="modalCustomerQuestionCustomerStage" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalCustomerQuestionCustomerStage" runat="server" Text="<%$ Resources:lang,KeHuShangJiJieDuan%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492270" runat="server" Text="<%$ Resources:lang,JieDuan%>"></asp:Label>
                                    <asp:TextBox ID="TB_CustomerQuestionCustomerStage" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492271" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_CustomerQuestionCustomerStageSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddCustomerQuestionCustomerStage" runat="server" CssClass="inpu" OnClick="BT_AddCustomerQuestionCustomerStage_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteCustomerQuestionCustomerStage" runat="server" CssClass="inpu" OnClick="BT_DeleteCustomerQuestionCustomerStage_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalCustomerQuestionCustomerStage')">
                                    <asp:Label ID="LabelCustomerQuestionCustomerStageClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
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
