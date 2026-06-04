<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTBaseDataOuter_3.aspx.cs" Inherits="TTBaseDataOuter_3" %>

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
            margin-left: 10px;
            font-size: 16px;
            padding: 4px 8px;
            border: 1px solid green;
            border-radius: 4px;
            background: #f0fff0;
            display: inline-block;
            text-align: center;
            min-width: 30px;
            float: right;
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
                                                <asp:Label ID="Label8" runat="server" Text="<%$ Resources:lang,CaiWuZhangWuLei%>"></asp:Label>
                                            </strong>
                                        </div>
                                    </div>
                                </td>
                                <td style="background-color: buttonface"></td>
                                <td colspan="2" style="background-color: buttonface"></td>
                            </tr>
                            <tr>
                                <td style="height: 19px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label448" runat="server" Text="<%$ Resources:lang,HeTongDaLei%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalConstractBigType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong><b>
                                            <asp:Label ID="Label453" runat="server" Text="<%$ Resources:lang,HeTongLeiXing%>"></asp:Label>
                                        </b></strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalConstractType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label222" runat="server" Text="<%$ Resources:lang,YinHang%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalBank', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label4118" runat="server" Text="<%$ Resources:lang,ShouFuKuanFangShi%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalReceivePay', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft" colspan="4">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label225" runat="server" Text="<%$ Resources:lang,KHXQFWRYYYWZ%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalWebSiteOperator', event)">+</span>
                                    </div>
                                    <br />
                                    (Format: TTCustomerQuestion.aspx?WebSite=WW.TAKETOPITS.COM)
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
                                                            <asp:Label ID="Label449" runat="server" Text="<%$ Resources:lang,LeiXingMingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label45" runat="server" Text="<%$ Resources:lang,PaiXu%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid37" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid37_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="类型名称">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ConstractBigType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"BigType") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="排序">
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
                                                            <asp:Label ID="Label454" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label455" runat="server" Text="<%$ Resources:lang,GuanJianCi%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label456" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="10%"><strong>
                                                            <asp:Label ID="Label45622" runat="server" Text="<%$ Resources:lang,MuBan%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid22" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid22_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ConstractType" runat="server" CssClass="tt-sms-btn" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="KeyWord" HeaderText="关键词">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:TemplateColumn>
                                                <ItemTemplate>
                                                    <asp:HyperLink ID="HL_WorkflowWFTemplate" Text="<%$ Resources:lang,LiuCheng%>" runat="server" NavigateUrl='<%# DataBinder.Eval(Container, "DataItem.Type", "TTAttachWorkFlowTemplate.aspx?RelatedType=ContractType&RelatedName={0}") %>'
                                                        Target="_blank"></asp:HyperLink>
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="10%" />
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn>
                                                <ItemStyle Width="10%" HorizontalAlign="Center" />
                                            </asp:TemplateColumn>
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
                                                            <asp:Label ID="Label226" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label227" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid39" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid39_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Name">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_BankName" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"BankName") %>' CommandName="Edit" />
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
                                                            <asp:Label ID="Label2111" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label211" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid38" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid38_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Name">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ReceivePayType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                <td colspan="4" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td>
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label235" runat="server" Text="<%$ Resources:lang,WangZhan%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label239" runat="server" Text="<%$ Resources:lang,KeFuRenYuanDaiMa%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label2114" runat="server" Text="<%$ Resources:lang,XingMing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="20%"><strong>
                                                            <asp:Label ID="Label244" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid41" runat="server" AutoGenerateColumns="False" GridLines="None" OnItemCommand="DataGrid41_ItemCommand" ShowHeader="False" Width="100%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="域名">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_WebSite" runat="server" CssClass="inpuLongest" Text='<%# DataBinder.Eval(Container.DataItem,"WebSite") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="UserCode" HeaderText="Code">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="UserName" HeaderText="Name">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="顺序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                            </asp:BoundColumn>
                                            <asp:TemplateColumn>
                                                <ItemStyle Width="10%" HorizontalAlign="Center" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="8" style="background-color: beige; height: 20px; text-align: left;">
                                    <strong>&nbsp;
                                    </strong>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 19px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,FaPiaoLiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalInvoiceType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,XiaoShouLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalSaleType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label106" runat="server" Text="<%$ Resources:lang,HeTongShouZiBiLei%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalConstractRadio', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft" colspan="4">&nbsp;</td>
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
                                                            <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,LeiXingMingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label57" runat="server" Text="<%$ Resources:lang,PaiXu%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid49" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid49_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="类型名称">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_InvoiceType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="排序">
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
                                                            <asp:Label ID="Label492283" runat="server" Text="<%$ Resources:lang,LeiXingMingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492284" runat="server" Text="<%$ Resources:lang,PaiXu%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid12" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid12_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="类型名称">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_SaleType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="排序">
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
                                                        <td class="ItemAlignLeft" width="100%"><strong>
                                                            <asp:Label ID="Label103" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid21" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid21_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="收支比例">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ConstractRadio" runat="server" CssClass="inpuLongest" Text='<%# DataBinder.Eval(Container.DataItem,"Radio") %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="100%" />
                                            </asp:TemplateColumn>

                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                                <td colspan="4" class="ItemAlignLeft">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="4" style="background-color: buttonface; text-align: left;"></td>
                                <td colspan="3" class="ItemAlignLeft" style="background-color: buttonface;">
                                    <table style="display: none;">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <asp:Label ID="Label95" runat="server" Text="<%$ Resources:lang,ChuRuKuShuanFA%>"></asp:Label>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <asp:DropDownList ID="DL_StockCountMethod" AutoPostBack="true" runat="server" OnSelectedIndexChanged="DL_StockCountMethod_SelectedIndexChanged">
                                                    <asp:ListItem Value="FIFO" Text="<%$ Resources:lang,XianJingXianChu%>" />
                                                    <asp:ListItem Value="MWAM" Text="<%$ Resources:lang,JiaQuanPingJIng%>" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 7px;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label359" runat="server" Text="<%$ Resources:lang,ZCYCLLXSD%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalAssetType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label58" runat="server" Text="<%$ Resources:lang,ZiChanWeiHuLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalMTType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label59" runat="server" Text="<%$ Resources:lang,ZiChanDiaoHuanLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalChangeType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label6" runat="server" Text="<%$ Resources:lang,BaoZhuangFangShi%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalPackingType', event)">+</span>
                                    </div>
                                </td>
                                <td class="ItemAlignLeft">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label374" runat="server" Text="<%$ Resources:lang,ChuKuLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalGoodsShipmentType', event)">+</span>
                                    </div>
                                </td>
                                <td colspan="2">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label387" runat="server" Text="<%$ Resources:lang,RuKuLeiXing%>"></asp:Label>
                                        </strong>
                                        <span class="grid-add-icon" onclick="return handleAddClick('modalGoodsCheckInType', event)">+</span>
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
                                                            <asp:Label ID="Label36" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label361" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid4" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid4_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_AssetType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                                            <asp:Label ID="Label64" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label65" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid10" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid10_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_MTType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                                            <asp:Label ID="Label66" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label67" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid11" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid11_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_ChangeType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                                            <asp:Label ID="Label492279" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label492280" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid48" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid48_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="Type">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_PackingType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"Type") %>' CommandName="Edit" />
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
                                                            <asp:Label ID="Label375" runat="server" Text="<%$ Resources:lang,LeiXingMingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label376" runat="server" Text="<%$ Resources:lang,PaiXu%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid42" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid42_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="类型名称">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_GoodsShipmentType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"TypeName").ToString().Trim() %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="排序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
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
                                                        <td class="ItemAlignLeft" width="60%"><strong>
                                                            <asp:Label ID="Label388" runat="server" Text="<%$ Resources:lang,LeiXingMingCheng%>"></asp:Label>
                                                        </strong></td>
                                                        <td class="ItemAlignLeft" width="40%"><strong>
                                                            <asp:Label ID="Label389" runat="server" Text="<%$ Resources:lang,PaiXu%>"></asp:Label>
                                                        </strong></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td align="right" width="6">
                                                <img src="ImagesSkin/main_n_r.jpg" width="6" alt="" height="26" />
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:DataGrid ID="DataGrid43" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid43_ItemCommand" ShowHeader="false" Width="98%">
                                        <FooterStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                        <EditItemStyle BackColor="#2461BF" />
                                        <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        <PagerStyle CssClass="notTab" HorizontalAlign="center" Mode="NumericPages" NextPageText="" PrevPageText="" />
                                        <ItemStyle CssClass="itemStyle" />
                                        <Columns>
                                            <asp:TemplateColumn HeaderText="类型名称">
                                                <ItemTemplate>
                                                    <asp:Button ID="BT_GoodsCheckInType" runat="server" CssClass="inpu" Text='<%# DataBinder.Eval(Container.DataItem,"TypeName").ToString().Trim() %>' CommandName="Edit" />
                                                </ItemTemplate>
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="60%" />
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="SortNumber" HeaderText="排序">
                                                <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="40%" />
                                            </asp:BoundColumn>

                                        </Columns>
                                    </asp:DataGrid>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- 所有模态框定义 -->
                    <!-- 合同大类模态框 -->
                    <div id="modalConstractBigType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalConstractBigType" runat="server" Text="<%$ Resources:lang,HeTongDaLei%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label451" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_ConstractBigType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label452" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_ConstractBigTypeSortNo" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddConstractBigType" runat="server" CssClass="inpu" OnClick="BT_AddConstractBigType_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteConstractBigType" runat="server" CssClass="inpu" OnClick="BT_DeleteConstractType_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalConstractBigType')">
                                    <asp:Label ID="LabelConstractBigTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 合同类型模态框 -->
                    <div id="modalConstractType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalConstractType" runat="server" Text="<%$ Resources:lang,HeTongLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label457" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_ConstractType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label458" runat="server" Text="<%$ Resources:lang,GuanJianCi%>"></asp:Label>
                                    <asp:TextBox ID="TB_ConstractTypeKeyWord" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label459" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_ConstractTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_ConstractAdd" runat="server" CssClass="inpu" OnClick="BT_ConstractAdd_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_ConstractDelete" runat="server" CssClass="inpu" OnClick="BT_ConstractDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalConstractType')">
                                    <asp:Label ID="LabelConstractTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 银行类型模态框 -->
                    <div id="modalBank" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalBank" runat="server" Text="<%$ Resources:lang,YinHang%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label236" runat="server" Text="<%$ Resources:lang,YinHang%>"></asp:Label>
                                    <asp:TextBox ID="TB_BankName" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label241" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_BankSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddBank" runat="server" CssClass="inpu" OnClick="BT_AddBank_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteBank" runat="server" CssClass="inpu" OnClick="BT_DeleteBank_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalBank')">
                                    <asp:Label ID="LabelBankClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 收付款方式模态框 -->
                    <div id="modalReceivePay" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalReceivePay" runat="server" Text="<%$ Resources:lang,ShouFuKuanFangShi%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label217" runat="server" Text="<%$ Resources:lang,FangShi%>"></asp:Label>
                                    <asp:TextBox ID="TB_ReceivePayType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label221" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_ReceivePayTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddReceivePayWay" runat="server" CssClass="inpu" OnClick="BT_AddReceivePayWay_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteReceivePayWay" runat="server" CssClass="inpu" OnClick="BT_DeleteReceivePayWay_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalReceivePay')">
                                    <asp:Label ID="LabelReceivePayClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 网站客服操作员模态框 -->
                    <div id="modalWebSiteOperator" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalWebSiteOperator" runat="server" Text="<%$ Resources:lang,KHXQFWRYYYWZ%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,WangZhan%>"></asp:Label>
                                    <asp:TextBox ID="TB_WebSite" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:lang,KeFuRenYuanDaiMa%>"></asp:Label>
                                    <asp:TextBox ID="TB_SiteUserCode" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:lang,XingMing%>"></asp:Label>
                                    <asp:TextBox ID="TB_SiteUserName" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label4" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_WebSiteSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddWebSiteOperator" runat="server" CssClass="inpu" OnClick="BT_AddWebSiteOperator_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteWebSiteOperator" runat="server" CssClass="inpu" OnClick="BT_DeleteWebSiteOperator_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalWebSiteOperator')">
                                    <asp:Label ID="LabelWebSiteOperatorClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 发票类型模态框 -->
                    <div id="modalInvoiceType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalInvoiceType" runat="server" Text="<%$ Resources:lang,FaPiaoLiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492285" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_InvoiceType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492286" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_InvoiceTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_InvoiceTypeNew" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_InvoiceTypeNew_Click" />
                                <asp:Button ID="BT_InvoiceTypeDelete" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ShanChu%>" OnClick="BT_InvoiceTypeDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalInvoiceType')">
                                    <asp:Label ID="LabelInvoiceTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 销售类型模态框 -->
                    <div id="modalSaleType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalSaleType" runat="server" Text="<%$ Resources:lang,XiaoShouLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label96" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_SaleType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label97" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_SaleTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_SaleTypeNew" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_SaleTypeNew_Click" />
                                <asp:Button ID="BT_SaleTypeDelete" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ShanChu%>" OnClick="BT_SaleTypeDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalSaleType')">
                                    <asp:Label ID="LabelSaleTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 合同收支比例模态框 -->
                    <div id="modalConstractRadio" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalConstractRadio" runat="server" Text="<%$ Resources:lang,HeTongShouZiBiLei%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label105" runat="server" Text="<%$ Resources:lang,MingCheng%>"></asp:Label>
                                    <asp:TextBox ID="TB_ConstractRadio" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_ConstractRadioNew" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_ConstractRadioNew_Click" />
                                <asp:Button ID="BT_ConstractRadioDelete" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ShanChu%>" OnClick="BT_ConstractRadioDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalConstractRadio')">
                                    <asp:Label ID="LabelConstractRadioClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 资产类型模态框 -->
                    <div id="modalAssetType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalAssetType" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label362" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_AssetType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label363" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_AssetTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AssetTypeNew1" runat="server" CssClass="inpu" OnClick="BT_AssetTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_AssetTypeDelete" runat="server" CssClass="inpu" OnClick="BT_AssetTypeDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalAssetType')">
                                    <asp:Label ID="LabelAssetTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 资产维护类型模态框 -->
                    <div id="modalMTType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalMTType" runat="server" Text="<%$ Resources:lang,ZiChanWeiHuLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label73" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_MTType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label78" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_MTTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_MTTypeNew" runat="server" CssClass="inpu" OnClick="BT_MTTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_MTTypeDelete" runat="server" CssClass="inpu" OnClick="BT_MTTypeDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalMTType')">
                                    <asp:Label ID="LabelMTTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 资产调换类型模态框 -->
                    <div id="modalChangeType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalChangeType" runat="server" Text="<%$ Resources:lang,ZiChanDiaoHuanLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label74" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_ChangeType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label79" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_ChangeTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_ChangeTypeNew" runat="server" CssClass="inpu" OnClick="BT_ChangeTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_ChangeTypeDelete" runat="server" CssClass="inpu" OnClick="BT_ChangeTypeDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalChangeType')">
                                    <asp:Label ID="LabelChangeTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 包装方式模态框 -->
                    <div id="modalPackingType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalPackingType" runat="server" Text="<%$ Resources:lang,BaoZhuangFangShi%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label492281" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_PackingType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label492282" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_PackingTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_PackingTypeNew" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_PackingTypeNew_Click" />
                                <asp:Button ID="BT_PackingTypeDelete" runat="server" CssClass="inpu" Text="<%$ Resources:lang,ShanChu%>" OnClick="BT_PackingTypeDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalPackingType')">
                                    <asp:Label ID="LabelPackingTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 出库类型模态框 -->
                    <div id="modalGoodsShipmentType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalGoodsShipmentType" runat="server" Text="<%$ Resources:lang,ChuKuLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label377" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_GoodsShipmentType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label378" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_GoodsShipmentSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_GoodsShipmentAdd" runat="server" CssClass="inpu" OnClick="BT_GoodsShipmentAdd_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_GoodsShipmentDelete" runat="server" CssClass="inpu" OnClick="BT_GoodsShipmentDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalGoodsShipmentType')">
                                    <asp:Label ID="LabelGoodsShipmentTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
                            </div>
                        </div>
                    </div>

                    <!-- 入库类型模态框 -->
                    <div id="modalGoodsCheckInType" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalGoodsCheckInType" runat="server" Text="<%$ Resources:lang,RuKuLeiXing%>"></asp:Label></h3>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <asp:Label ID="Label39" runat="server" Text="<%$ Resources:lang,LeiXing%>"></asp:Label>
                                    <asp:TextBox ID="TB_GoodsCheckInType" runat="server" Width="200px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label391" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_GoodsCheckInSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_GoodsCheckInAdd" runat="server" CssClass="inpu" OnClick="BT_GoodsCheckInAdd_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_GoodsCheckInDelete" runat="server" CssClass="inpu" OnClick="BT_GoodsCheckInDelete_Click" Text="<%$ Resources:lang,ShanChu%>"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  />
                                <button type="button" class="close-modal" onclick="hideModal('modalGoodsCheckInType')">
                                    <asp:Label ID="LabelGoodsCheckInTypeClose" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label></button>
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
