<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TTBaseDataOuterSAAS.aspx.cs" Inherits="TTBaseDataOuterSAAS" %>

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

        // 为所有模态框添加点击外部  <asp:Label ID="Label3" runat ="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>   功能
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
                                <td colspan="6" height="31" class="page_topbj">
                                    <table width="96%" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <table width="345" border="0" class="ItemAlignLeft" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="29"></td>
                                                        <td background="ImagesSkin/main_top_bj.jpg" class="titlezi">
                                                            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:lang,JiChuShuJu%>"></asp:Label>
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
                                <td colspan="2" style="background-color: buttonface; text-align: left;"><strong>
                                    <asp:Label ID="Label15" runat="server" Text="<%$ Resources:lang,XiangMuRenWuLei%>"></asp:Label>
                                </strong></b></td>
                                <td style="background-color: buttonface">
                                    <asp:Label ID="Label94" runat="server" Text="<%$ Resources:lang,TiaoMaLeiXing%>"></asp:Label>
                                    <asp:DropDownList ID="DL_BarType" AutoPostBack="true" runat="server" OnSelectedIndexChanged="DL_BarType_SelectedIndexChanged">
                                        <asp:ListItem Value="BarCode" Text="<%$ Resources:lang,TiaoXingMa%>" />
                                        <asp:ListItem Value="NoLogoQrCode" Text="<%$ Resources:lang,ErWeiMa%>" />
                                    </asp:DropDownList>
                                </td>
                                <td colspan="3" style="background-color: buttonface"></td>
                            </tr>
                            <tr>
                                <td style="text-align: center;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label334" runat="server" Text="<%$ Resources:lang,XiangMuRenWuLeiXing%>"></asp:Label>
                                        </strong>
                                        <div class="header-button">
                                            <span class="grid-add-icon" onclick="return handleAddClick('modalTaskType', event)">+</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="text-align: center;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label34" runat="server" Text="<%$ Resources:lang,RenWuCaoZuoSheDing%>"></asp:Label>
                                        </strong>
                                        <div class="header-button">
                                            <span class="grid-add-icon" onclick="return handleAddClick('modalTaskOperation', event)">+</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="text-align: center;">
                                    <div class="header-with-button">
                                        <strong>
                                            <asp:Label ID="Label462211" runat="server" Text="<%$ Resources:lang,RenWuFenPaiJiLuLeiXing%>"></asp:Label>
                                        </strong>
                                        <div class="header-button">
                                            <span class="grid-add-icon" onclick="return handleAddClick('modalTaskRecord', event)">+</span>
                                        </div>
                                    </div>
                                </td>
                                <td style="text-align: center;">&nbsp;</td>
                                <td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td valign="top" rowspan="4" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td>
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
                                    <asp:DataGrid ID="DataGrid18" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid18_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
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
                                <td valign="top" rowspan="4" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td>
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
                                    <asp:DataGrid ID="DataGrid7" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid7_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
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
                                            <asp:TemplateColumn>
                                                <ItemStyle Width="20%" HorizontalAlign="Center" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>
                                <td valign="top" rowspan="4" class="ItemAlignLeft">
                                    <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                        <tr>
                                            <td width="7">
                                                <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                            </td>
                                            <td>
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
                                    <asp:DataGrid ID="DataGrid19" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid19_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
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
                                            <asp:TemplateColumn>
                                                <ItemStyle Width="20%" HorizontalAlign="Center" />
                                            </asp:TemplateColumn>
                                        </Columns>
                                        <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                    </asp:DataGrid>
                                </td>

                                <td colspan="2" valign="top">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2">&nbsp;
                                </td>
                            </tr>

                            <tr>
                                <td colspan="6" style="background-color: beige; height: 20px;"></td>
                            </tr>

                            <tr>
                                <td colspan="6" class="ItemAlignLeft">
                                    <table style="width: 100%; text-align: center;">
                                        <tr>
                                            <td colspan="8" style="background-color: buttonface; text-align: left;">
                                                <strong>
                                                    <asp:Label ID="Label492256" runat="server" Text="<%$ Resources:lang,RenShiXinZhunLei%>"></asp:Label>
                                                </strong>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label492244" runat="server" Text="<%$ Resources:lang,RiChengKeGaiQianZhiTianShu%>"></asp:Label>
                                                </strong>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <div class="header-with-button">
                                                    <strong>
                                                        <asp:Label ID="Label222" runat="server" Text="<%$ Resources:lang,YinHang%>"></asp:Label>
                                                    </strong>
                                                    <div class="header-button">
                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalBank', event)">+</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <div class="header-with-button">
                                                    <strong>
                                                        <asp:Label ID="Label4118" runat="server" Text="<%$ Resources:lang,ShouFuKuanFangShi%>"></asp:Label>
                                                    </strong>
                                                    <div class="header-button">
                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalReceivePay', event)">+</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td colspan="4" class="ItemAlignLeft">
                                                <div class="header-with-button">
                                                    <strong>
                                                        <asp:Label ID="Label4119" runat="server" Text="<%$ Resources:lang,DaiMaGuiZe%>"></asp:Label>
                                                    </strong>
                                                    <div class="header-button">
                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalCodeRule', event)">+</span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="ItemAlignLeft">
                                                <NickLee:NumberBox ID="NB_ScheduleLimitedDays" runat="server" MaxAmount="10" MinAmount="0" Precision="0" Width="50px"></NickLee:NumberBox>
                                                <asp:Button ID="BT_ScheduleLimitedDaysUpdate" runat="server" CssClass="inpu" OnClick="BT_ScheduleLimitedDaysUpdate_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                                <br />
                                                <br />

                                                <b>
                                                    <asp:Label ID="Label93" runat="server" Text="<%$ Resources:lang,MeiZouGongZuoRiSheDing%>"></asp:Label>
                                                    <br />
                                                </b>
                                                ( 1,2,3,4,5,6,0 )
                                            <br />

                                                <asp:Label ID="Label88" runat="server" Text="<%$ Resources:lang,ZhouMoKaiShiRiQi%>"></asp:Label>
                                                <br />
                                                <NickLee:NumberBox ID="NB_WeekendFirstDay" runat="server" MaxAmount="10" MinAmount="0" Precision="0" Width="50px" Amount="6">6</NickLee:NumberBox>
                                                <br />
                                                <asp:Label ID="Label89" runat="server" Text="<%$ Resources:lang,ZhouMoJieShuRiQi%>"></asp:Label>
                                                <br />
                                                <NickLee:NumberBox ID="NB_WeekendSecondDay" runat="server" MaxAmount="10" MinAmount="0" Precision="0" Width="50px"></NickLee:NumberBox>
                                                <br />
                                                <asp:Label ID="Label90" runat="server" Text="<%$ Resources:lang,ZhouMoShiHouGongZuoRi%>"></asp:Label>
                                                <br />
                                                <asp:DropDownList ID="DL_WeekendsAreWorkdays" runat="server">
                                                    <asp:ListItem Value="false" Text="NO"></asp:ListItem>
                                                    <asp:ListItem Value="true" Text="YES"></asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <asp:Button ID="BT_UpdateWeekendFirstDay" runat="server" CssClass="inpu" Text="<%$ Resources:lang,BaoCun%>" OnClick="BT_WorkingDayRuleUpdate_Click" />
                                                <br />
                                                <br />
                                                <b>
                                                    <asp:Label ID="Label492245" runat="server" Text="<%$ Resources:lang,YiTianShangBanShiJianShu%>"></asp:Label></b>
                                                <br />
                                                <asp:Label ID="Label492246" runat="server" Text="<%$ Resources:lang,KaiShiShiJian%>"></asp:Label>
                                                <asp:DropDownList ID="DL_StartHour" runat="server">
                                                    <asp:ListItem>00</asp:ListItem>
                                                    <asp:ListItem>01</asp:ListItem>
                                                    <asp:ListItem>02</asp:ListItem>
                                                    <asp:ListItem>03</asp:ListItem>
                                                    <asp:ListItem>04</asp:ListItem>
                                                    <asp:ListItem>05</asp:ListItem>
                                                    <asp:ListItem>06</asp:ListItem>
                                                    <asp:ListItem>07</asp:ListItem>
                                                    <asp:ListItem>08</asp:ListItem>
                                                    <asp:ListItem>09</asp:ListItem>
                                                    <asp:ListItem>10</asp:ListItem>
                                                    <asp:ListItem>11</asp:ListItem>
                                                    <asp:ListItem>12</asp:ListItem>
                                                    <asp:ListItem>13</asp:ListItem>
                                                    <asp:ListItem>14</asp:ListItem>
                                                    <asp:ListItem>15</asp:ListItem>
                                                    <asp:ListItem>16</asp:ListItem>
                                                    <asp:ListItem>17</asp:ListItem>
                                                    <asp:ListItem>18</asp:ListItem>
                                                    <asp:ListItem>19</asp:ListItem>
                                                    <asp:ListItem>20</asp:ListItem>
                                                    <asp:ListItem>21</asp:ListItem>
                                                    <asp:ListItem>22</asp:ListItem>
                                                    <asp:ListItem>23</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:DropDownList ID="DL_StartMin" runat="server">
                                                    <asp:ListItem>00</asp:ListItem>
                                                    <asp:ListItem>01</asp:ListItem>
                                                    <asp:ListItem>02</asp:ListItem>
                                                    <asp:ListItem>03</asp:ListItem>
                                                    <asp:ListItem>04</asp:ListItem>
                                                    <asp:ListItem>05</asp:ListItem>
                                                    <asp:ListItem>06</asp:ListItem>
                                                    <asp:ListItem>07</asp:ListItem>
                                                    <asp:ListItem>08</asp:ListItem>
                                                    <asp:ListItem>09</asp:ListItem>
                                                    <asp:ListItem>10</asp:ListItem>
                                                    <asp:ListItem>11</asp:ListItem>
                                                    <asp:ListItem>12</asp:ListItem>
                                                    <asp:ListItem>13</asp:ListItem>
                                                    <asp:ListItem>14</asp:ListItem>
                                                    <asp:ListItem>15</asp:ListItem>
                                                    <asp:ListItem>16</asp:ListItem>
                                                    <asp:ListItem>17</asp:ListItem>
                                                    <asp:ListItem>18</asp:ListItem>
                                                    <asp:ListItem>19</asp:ListItem>
                                                    <asp:ListItem>20</asp:ListItem>
                                                    <asp:ListItem>21</asp:ListItem>
                                                    <asp:ListItem>22</asp:ListItem>
                                                    <asp:ListItem>23</asp:ListItem>
                                                    <asp:ListItem>24</asp:ListItem>
                                                    <asp:ListItem>25</asp:ListItem>
                                                    <asp:ListItem>26</asp:ListItem>
                                                    <asp:ListItem>27</asp:ListItem>
                                                    <asp:ListItem>28</asp:ListItem>
                                                    <asp:ListItem>29</asp:ListItem>
                                                    <asp:ListItem>30</asp:ListItem>
                                                    <asp:ListItem>31</asp:ListItem>
                                                    <asp:ListItem>32</asp:ListItem>
                                                    <asp:ListItem>33</asp:ListItem>
                                                    <asp:ListItem>34</asp:ListItem>
                                                    <asp:ListItem>35</asp:ListItem>
                                                    <asp:ListItem>36</asp:ListItem>
                                                    <asp:ListItem>37</asp:ListItem>
                                                    <asp:ListItem>38</asp:ListItem>
                                                    <asp:ListItem>39</asp:ListItem>
                                                    <asp:ListItem>40</asp:ListItem>
                                                    <asp:ListItem>41</asp:ListItem>
                                                    <asp:ListItem>42</asp:ListItem>
                                                    <asp:ListItem>43</asp:ListItem>
                                                    <asp:ListItem>44</asp:ListItem>
                                                    <asp:ListItem>45</asp:ListItem>
                                                    <asp:ListItem>46</asp:ListItem>
                                                    <asp:ListItem>47</asp:ListItem>
                                                    <asp:ListItem>48</asp:ListItem>
                                                    <asp:ListItem>49</asp:ListItem>
                                                    <asp:ListItem>50</asp:ListItem>
                                                    <asp:ListItem>51</asp:ListItem>
                                                    <asp:ListItem>52</asp:ListItem>
                                                    <asp:ListItem>53</asp:ListItem>
                                                    <asp:ListItem>54</asp:ListItem>
                                                    <asp:ListItem>55</asp:ListItem>
                                                    <asp:ListItem>56</asp:ListItem>
                                                    <asp:ListItem>57</asp:ListItem>
                                                    <asp:ListItem>58</asp:ListItem>
                                                    <asp:ListItem>59</asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <asp:Label ID="Label492247" runat="server" Text="<%$ Resources:lang,JieShuShiJian%>"></asp:Label>
                                                <asp:DropDownList ID="DL_EndHour" runat="server">
                                                    <asp:ListItem>00</asp:ListItem>
                                                    <asp:ListItem>01</asp:ListItem>
                                                    <asp:ListItem>02</asp:ListItem>
                                                    <asp:ListItem>03</asp:ListItem>
                                                    <asp:ListItem>04</asp:ListItem>
                                                    <asp:ListItem>05</asp:ListItem>
                                                    <asp:ListItem>06</asp:ListItem>
                                                    <asp:ListItem>07</asp:ListItem>
                                                    <asp:ListItem>08</asp:ListItem>
                                                    <asp:ListItem>09</asp:ListItem>
                                                    <asp:ListItem>10</asp:ListItem>
                                                    <asp:ListItem>11</asp:ListItem>
                                                    <asp:ListItem>12</asp:ListItem>
                                                    <asp:ListItem>13</asp:ListItem>
                                                    <asp:ListItem>14</asp:ListItem>
                                                    <asp:ListItem>15</asp:ListItem>
                                                    <asp:ListItem>16</asp:ListItem>
                                                    <asp:ListItem>17</asp:ListItem>
                                                    <asp:ListItem>18</asp:ListItem>
                                                    <asp:ListItem>19</asp:ListItem>
                                                    <asp:ListItem>20</asp:ListItem>
                                                    <asp:ListItem>21</asp:ListItem>
                                                    <asp:ListItem>22</asp:ListItem>
                                                    <asp:ListItem>23</asp:ListItem>
                                                </asp:DropDownList>
                                                :<asp:DropDownList ID="DL_EndMin" runat="server">
                                                    <asp:ListItem>00</asp:ListItem>
                                                    <asp:ListItem>01</asp:ListItem>
                                                    <asp:ListItem>02</asp:ListItem>
                                                    <asp:ListItem>03</asp:ListItem>
                                                    <asp:ListItem>04</asp:ListItem>
                                                    <asp:ListItem>05</asp:ListItem>
                                                    <asp:ListItem>06</asp:ListItem>
                                                    <asp:ListItem>07</asp:ListItem>
                                                    <asp:ListItem>08</asp:ListItem>
                                                    <asp:ListItem>09</asp:ListItem>
                                                    <asp:ListItem>10</asp:ListItem>
                                                    <asp:ListItem>11</asp:ListItem>
                                                    <asp:ListItem>12</asp:ListItem>
                                                    <asp:ListItem>13</asp:ListItem>
                                                    <asp:ListItem>14</asp:ListItem>
                                                    <asp:ListItem>15</asp:ListItem>
                                                    <asp:ListItem>16</asp:ListItem>
                                                    <asp:ListItem>17</asp:ListItem>
                                                    <asp:ListItem>18</asp:ListItem>
                                                    <asp:ListItem>19</asp:ListItem>
                                                    <asp:ListItem>20</asp:ListItem>
                                                    <asp:ListItem>21</asp:ListItem>
                                                    <asp:ListItem>22</asp:ListItem>
                                                    <asp:ListItem>23</asp:ListItem>
                                                    <asp:ListItem>24</asp:ListItem>
                                                    <asp:ListItem>25</asp:ListItem>
                                                    <asp:ListItem>26</asp:ListItem>
                                                    <asp:ListItem>27</asp:ListItem>
                                                    <asp:ListItem>28</asp:ListItem>
                                                    <asp:ListItem>29</asp:ListItem>
                                                    <asp:ListItem>30</asp:ListItem>
                                                    <asp:ListItem>31</asp:ListItem>
                                                    <asp:ListItem>32</asp:ListItem>
                                                    <asp:ListItem>33</asp:ListItem>
                                                    <asp:ListItem>34</asp:ListItem>
                                                    <asp:ListItem>35</asp:ListItem>
                                                    <asp:ListItem>36</asp:ListItem>
                                                    <asp:ListItem>37</asp:ListItem>
                                                    <asp:ListItem>38</asp:ListItem>
                                                    <asp:ListItem>39</asp:ListItem>
                                                    <asp:ListItem>40</asp:ListItem>
                                                    <asp:ListItem>41</asp:ListItem>
                                                    <asp:ListItem>42</asp:ListItem>
                                                    <asp:ListItem>43</asp:ListItem>
                                                    <asp:ListItem>44</asp:ListItem>
                                                    <asp:ListItem>45</asp:ListItem>
                                                    <asp:ListItem>46</asp:ListItem>
                                                    <asp:ListItem>47</asp:ListItem>
                                                    <asp:ListItem>48</asp:ListItem>
                                                    <asp:ListItem>49</asp:ListItem>
                                                    <asp:ListItem>50</asp:ListItem>
                                                    <asp:ListItem>51</asp:ListItem>
                                                    <asp:ListItem>52</asp:ListItem>
                                                    <asp:ListItem>53</asp:ListItem>
                                                    <asp:ListItem>54</asp:ListItem>
                                                    <asp:ListItem>55</asp:ListItem>
                                                    <asp:ListItem>56</asp:ListItem>
                                                    <asp:ListItem>57</asp:ListItem>
                                                    <asp:ListItem>58</asp:ListItem>
                                                    <asp:ListItem>59</asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <asp:Label ID="Label492248" runat="server" Text="<%$ Resources:lang,XiuXiShiJianYi%>"></asp:Label>
                                                <asp:DropDownList ID="DL_RestStartTimeHour" runat="server">
                                                    <asp:ListItem>00</asp:ListItem>
                                                    <asp:ListItem>01</asp:ListItem>
                                                    <asp:ListItem>02</asp:ListItem>
                                                    <asp:ListItem>03</asp:ListItem>
                                                    <asp:ListItem>04</asp:ListItem>
                                                    <asp:ListItem>05</asp:ListItem>
                                                    <asp:ListItem>06</asp:ListItem>
                                                    <asp:ListItem>07</asp:ListItem>
                                                    <asp:ListItem>08</asp:ListItem>
                                                    <asp:ListItem>09</asp:ListItem>
                                                    <asp:ListItem>10</asp:ListItem>
                                                    <asp:ListItem>11</asp:ListItem>
                                                    <asp:ListItem>12</asp:ListItem>
                                                    <asp:ListItem>13</asp:ListItem>
                                                    <asp:ListItem>14</asp:ListItem>
                                                    <asp:ListItem>15</asp:ListItem>
                                                    <asp:ListItem>16</asp:ListItem>
                                                    <asp:ListItem>17</asp:ListItem>
                                                    <asp:ListItem>18</asp:ListItem>
                                                    <asp:ListItem>19</asp:ListItem>
                                                    <asp:ListItem>20</asp:ListItem>
                                                    <asp:ListItem>21</asp:ListItem>
                                                    <asp:ListItem>22</asp:ListItem>
                                                    <asp:ListItem>23</asp:ListItem>
                                                </asp:DropDownList>
                                                :<asp:DropDownList ID="DL_RestStartTimeMin" runat="server">
                                                    <asp:ListItem>00</asp:ListItem>
                                                    <asp:ListItem>01</asp:ListItem>
                                                    <asp:ListItem>02</asp:ListItem>
                                                    <asp:ListItem>03</asp:ListItem>
                                                    <asp:ListItem>04</asp:ListItem>
                                                    <asp:ListItem>05</asp:ListItem>
                                                    <asp:ListItem>06</asp:ListItem>
                                                    <asp:ListItem>07</asp:ListItem>
                                                    <asp:ListItem>08</asp:ListItem>
                                                    <asp:ListItem>09</asp:ListItem>
                                                    <asp:ListItem>10</asp:ListItem>
                                                    <asp:ListItem>11</asp:ListItem>
                                                    <asp:ListItem>12</asp:ListItem>
                                                    <asp:ListItem>13</asp:ListItem>
                                                    <asp:ListItem>14</asp:ListItem>
                                                    <asp:ListItem>15</asp:ListItem>
                                                    <asp:ListItem>16</asp:ListItem>
                                                    <asp:ListItem>17</asp:ListItem>
                                                    <asp:ListItem>18</asp:ListItem>
                                                    <asp:ListItem>19</asp:ListItem>
                                                    <asp:ListItem>20</asp:ListItem>
                                                    <asp:ListItem>21</asp:ListItem>
                                                    <asp:ListItem>22</asp:ListItem>
                                                    <asp:ListItem>23</asp:ListItem>
                                                    <asp:ListItem>24</asp:ListItem>
                                                    <asp:ListItem>25</asp:ListItem>
                                                    <asp:ListItem>26</asp:ListItem>
                                                    <asp:ListItem>27</asp:ListItem>
                                                    <asp:ListItem>28</asp:ListItem>
                                                    <asp:ListItem>29</asp:ListItem>
                                                    <asp:ListItem>30</asp:ListItem>
                                                    <asp:ListItem>31</asp:ListItem>
                                                    <asp:ListItem>32</asp:ListItem>
                                                    <asp:ListItem>33</asp:ListItem>
                                                    <asp:ListItem>34</asp:ListItem>
                                                    <asp:ListItem>35</asp:ListItem>
                                                    <asp:ListItem>36</asp:ListItem>
                                                    <asp:ListItem>37</asp:ListItem>
                                                    <asp:ListItem>38</asp:ListItem>
                                                    <asp:ListItem>39</asp:ListItem>
                                                    <asp:ListItem>40</asp:ListItem>
                                                    <asp:ListItem>41</asp:ListItem>
                                                    <asp:ListItem>42</asp:ListItem>
                                                    <asp:ListItem>43</asp:ListItem>
                                                    <asp:ListItem>44</asp:ListItem>
                                                    <asp:ListItem>45</asp:ListItem>
                                                    <asp:ListItem>46</asp:ListItem>
                                                    <asp:ListItem>47</asp:ListItem>
                                                    <asp:ListItem>48</asp:ListItem>
                                                    <asp:ListItem>49</asp:ListItem>
                                                    <asp:ListItem>50</asp:ListItem>
                                                    <asp:ListItem>51</asp:ListItem>
                                                    <asp:ListItem>52</asp:ListItem>
                                                    <asp:ListItem>53</asp:ListItem>
                                                    <asp:ListItem>54</asp:ListItem>
                                                    <asp:ListItem>55</asp:ListItem>
                                                    <asp:ListItem>56</asp:ListItem>
                                                    <asp:ListItem>57</asp:ListItem>
                                                    <asp:ListItem>58</asp:ListItem>
                                                    <asp:ListItem>59</asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <asp:Label ID="Label492249" runat="server" Text="<%$ Resources:lang,XiuXiShiJianEr%>"></asp:Label>
                                                <asp:DropDownList ID="DL_RestEndTimeHour" runat="server">
                                                    <asp:ListItem>00</asp:ListItem>
                                                    <asp:ListItem>01</asp:ListItem>
                                                    <asp:ListItem>02</asp:ListItem>
                                                    <asp:ListItem>03</asp:ListItem>
                                                    <asp:ListItem>04</asp:ListItem>
                                                    <asp:ListItem>05</asp:ListItem>
                                                    <asp:ListItem>06</asp:ListItem>
                                                    <asp:ListItem>07</asp:ListItem>
                                                    <asp:ListItem>08</asp:ListItem>
                                                    <asp:ListItem>09</asp:ListItem>
                                                    <asp:ListItem>10</asp:ListItem>
                                                    <asp:ListItem>11</asp:ListItem>
                                                    <asp:ListItem>12</asp:ListItem>
                                                    <asp:ListItem>13</asp:ListItem>
                                                    <asp:ListItem>14</asp:ListItem>
                                                    <asp:ListItem>15</asp:ListItem>
                                                    <asp:ListItem>16</asp:ListItem>
                                                    <asp:ListItem>17</asp:ListItem>
                                                    <asp:ListItem>18</asp:ListItem>
                                                    <asp:ListItem>19</asp:ListItem>
                                                    <asp:ListItem>20</asp:ListItem>
                                                    <asp:ListItem>21</asp:ListItem>
                                                    <asp:ListItem>22</asp:ListItem>
                                                    <asp:ListItem>23</asp:ListItem>
                                                </asp:DropDownList>
                                                :<asp:DropDownList ID="DL_RestEndTimeMin" runat="server">
                                                    <asp:ListItem>00</asp:ListItem>
                                                    <asp:ListItem>01</asp:ListItem>
                                                    <asp:ListItem>02</asp:ListItem>
                                                    <asp:ListItem>03</asp:ListItem>
                                                    <asp:ListItem>04</asp:ListItem>
                                                    <asp:ListItem>05</asp:ListItem>
                                                    <asp:ListItem>06</asp:ListItem>
                                                    <asp:ListItem>07</asp:ListItem>
                                                    <asp:ListItem>08</asp:ListItem>
                                                    <asp:ListItem>09</asp:ListItem>
                                                    <asp:ListItem>10</asp:ListItem>
                                                    <asp:ListItem>11</asp:ListItem>
                                                    <asp:ListItem>12</asp:ListItem>
                                                    <asp:ListItem>13</asp:ListItem>
                                                    <asp:ListItem>14</asp:ListItem>
                                                    <asp:ListItem>15</asp:ListItem>
                                                    <asp:ListItem>16</asp:ListItem>
                                                    <asp:ListItem>17</asp:ListItem>
                                                    <asp:ListItem>18</asp:ListItem>
                                                    <asp:ListItem>19</asp:ListItem>
                                                    <asp:ListItem>20</asp:ListItem>
                                                    <asp:ListItem>21</asp:ListItem>
                                                    <asp:ListItem>22</asp:ListItem>
                                                    <asp:ListItem>23</asp:ListItem>
                                                    <asp:ListItem>24</asp:ListItem>
                                                    <asp:ListItem>25</asp:ListItem>
                                                    <asp:ListItem>26</asp:ListItem>
                                                    <asp:ListItem>27</asp:ListItem>
                                                    <asp:ListItem>28</asp:ListItem>
                                                    <asp:ListItem>29</asp:ListItem>
                                                    <asp:ListItem>30</asp:ListItem>
                                                    <asp:ListItem>31</asp:ListItem>
                                                    <asp:ListItem>32</asp:ListItem>
                                                    <asp:ListItem>33</asp:ListItem>
                                                    <asp:ListItem>34</asp:ListItem>
                                                    <asp:ListItem>35</asp:ListItem>
                                                    <asp:ListItem>36</asp:ListItem>
                                                    <asp:ListItem>37</asp:ListItem>
                                                    <asp:ListItem>38</asp:ListItem>
                                                    <asp:ListItem>39</asp:ListItem>
                                                    <asp:ListItem>40</asp:ListItem>
                                                    <asp:ListItem>41</asp:ListItem>
                                                    <asp:ListItem>42</asp:ListItem>
                                                    <asp:ListItem>43</asp:ListItem>
                                                    <asp:ListItem>44</asp:ListItem>
                                                    <asp:ListItem>45</asp:ListItem>
                                                    <asp:ListItem>46</asp:ListItem>
                                                    <asp:ListItem>47</asp:ListItem>
                                                    <asp:ListItem>48</asp:ListItem>
                                                    <asp:ListItem>49</asp:ListItem>
                                                    <asp:ListItem>50</asp:ListItem>
                                                    <asp:ListItem>51</asp:ListItem>
                                                    <asp:ListItem>52</asp:ListItem>
                                                    <asp:ListItem>53</asp:ListItem>
                                                    <asp:ListItem>54</asp:ListItem>
                                                    <asp:ListItem>55</asp:ListItem>
                                                    <asp:ListItem>56</asp:ListItem>
                                                    <asp:ListItem>57</asp:ListItem>
                                                    <asp:ListItem>58</asp:ListItem>
                                                    <asp:ListItem>59</asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <asp:Label ID="Label492250" runat="server" Text="<%$ Resources:lang,GongZuoShiJian%>"></asp:Label>
                                                <asp:TextBox ID="TB_HourNum" runat="server" Width="85px">8</asp:TextBox>
                                                <br />
                                                <asp:Button ID="BT_DayHourNum" runat="server" CssClass="inpu" OnClick="BT_DayHourNum_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                                <br />
                                                <asp:Label ID="lbl_DayHourNumID" runat="server" Visible="False"></asp:Label>

                                            </td>
                                            <td valign="top" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
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
                                                <asp:DataGrid ID="DataGrid39" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid39_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
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
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="20%" HorizontalAlign="Center" />
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
                                                        <td>
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
                                                <asp:DataGrid ID="DataGrid38" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid38_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
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
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="20%" HorizontalAlign="Center" />
                                                        </asp:TemplateColumn>
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
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="10%" HorizontalAlign="Center" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td colspan="5" style="background-color: buttonface; text-align: left;"><strong>
                                                <asp:Label ID="Label7" runat="server" Text="<%$ Resources:lang,JiBenLeiXingLei%>"></asp:Label>
                                            </strong>
                                                </b></td>
                                            <td style="background-color: buttonface"></td>
                                            <td colspan="2" style="background-color: buttonface"></td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <div class="header-with-button">
                                                    <strong>
                                                        <asp:Label ID="Label492229" runat="server" Text="<%$ Resources:lang,JiLiangDanWei%>"></asp:Label>
                                                    </strong>
                                                    <div class="header-button">
                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalUnit', event)">+</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td colspan="3" class="ItemAlignLeft">
                                                <div class="header-with-button">
                                                    <strong>
                                                        <asp:Label ID="Label4311" runat="server" Text="<%$ Resources:lang,BiBieLeiXing%>"></asp:Label>
                                                    </strong>
                                                    <div class="header-button">
                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalCurrency', event)">+</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="ItemAlignLeft">
                                                <div class="header-with-button">
                                                    <strong>
                                                        <asp:Label ID="Label84" runat="server" Text="<%$ Resources:lang,JueSeZuLeiXing%>"></asp:Label>
                                                    </strong>
                                                    <div class="header-button">
                                                        <span class="grid-add-icon" onclick="return handleAddClick('modalActorGroup', event)">+</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                            <td class="ItemAlignLeft">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td valign="top" rowspan="5" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
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
                                                <asp:DataGrid ID="DataGrid14" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid14_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
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
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="20%" HorizontalAlign="Center" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                </asp:DataGrid>
                                            </td>
                                            <td colspan="3" rowspan="5" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
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
                                                <asp:DataGrid ID="DataGrid35" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid35_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
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
                                                        <asp:BoundColumn DataField="IsHome" HeaderText="本币">
                                                            <ItemStyle CssClass="itemBorder" HorizontalAlign="left" Width="20%" />
                                                        </asp:BoundColumn>
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="10%" HorizontalAlign="Center" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </td>
                                            <td valign="top" rowspan="5" class="ItemAlignLeft">
                                                <table background="ImagesSkin/main_n_bj.jpg" border="0" cellpadding="0" cellspacing="0" width="98%">
                                                    <tr>
                                                        <td width="7">
                                                            <img src="ImagesSkin/main_n_l.jpg" width="7" height="26" />
                                                        </td>
                                                        <td>
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
                                                <asp:DataGrid ID="DataGrid15" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" OnItemCommand="DataGrid15_ItemCommand" PageSize="2" ShowHeader="false" Width="98%">
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
                                                        <asp:TemplateColumn>
                                                            <ItemStyle Width="20%" HorizontalAlign="Center" />
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <HeaderStyle BackColor="#57CD1" Font-Bold="True" ForeColor="White" />
                                                </asp:DataGrid>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td valign="top">&nbsp;</td>
                                            <td valign="top">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td style="height: 2px;">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" style="background-color: beige; height: 20px;">&nbsp;
                                            </td>
                                        </tr>
                                    </table>
                                    <table style="width: 100%; text-align: center;">
                                        <tr>
                                            <td colspan="2" style="background-color: buttonface; text-align: left;"><strong>
                                                <asp:Label ID="Label16" runat="server" Text="<%$ Resources:lang,TongXunJieKouLei%>"></asp:Label>
                                            </strong></b></td>
                                            <td style="background-color: buttonface"></td>
                                            <td style="background-color: buttonface"></td>
                                        </tr>
                                        <tr>
                                            <td class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label492257" runat="server" Text="<%$ Resources:lang,WeiXinQiYeZhangHao%>"></asp:Label>
                                                </strong>
                                            </td>
                                            <td colspan="2" class="ItemAlignLeft">
                                                <strong>
                                                    <asp:Label ID="Label24" runat="server" Text="<%$ Resources:lang,WeiXinGongZhongZhangHao%>"></asp:Label>
                                                </strong>
                                            </td>
                                            <td rowspan="3" class="ItemAlignLeft">
                                                <div class="header-with-button">
                                                    <table width="100%">
                                                        <tr>
                                                            <td class="ItemAlignLeft">
                                                                <b>
                                                                    <asp:Label ID="Label178" runat="server" Text="<%$ Resources:lang,DuanXinJieKou%>"></asp:Label>
                                                                </b>
                                                            </td>
                                                            <td style="text-align: right;">
                                                                <span class="grid-add-icon" onclick="return handleAddClick('modalSMSInterface', event)">+</span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
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
                                                                        <asp:Label ID="Label18" runat="server" Text="<%$ Resources:lang,FuWuShang%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="60%"><strong>
                                                                        <asp:Label ID="Label181" runat="server" Text="<%$ Resources:lang,JieKou%>"></asp:Label>
                                                                    </strong></td>
                                                                    <td class="ItemAlignLeft" width="10%"><strong>
                                                                        <asp:Label ID="Label182" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
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
                                            <td class="ItemAlignLeft">
                                                <br />
                                                <asp:Label ID="Label122222" runat="server" Text="CorpID"></asp:Label>
                                                <asp:TextBox ID="TB_WeChatQYCorpID" runat="server"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label492259" runat="server" Text="<%$ Resources:lang,MiMa%>"></asp:Label>
                                                <asp:TextBox ID="TB_WeChatQYSecret" runat="server"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label492260" runat="server" Text="<%$ Resources:lang,YingYongID%>"></asp:Label>
                                                <asp:TextBox ID="TB_WeChatQYApplicationID" runat="server"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label57" runat="server" Text="<%$ Resources:lang,QiYong%>"></asp:Label>
                                                <asp:DropDownList ID="DL_WeiXinQYHStatus" runat="server">
                                                    <asp:ListItem Value="NO">NO</asp:ListItem>
                                                    <asp:ListItem Value="YES">YES</asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <br />
                                                <asp:Button ID="BT_WeChatQYSave" runat="server" CssClass="inpu" OnClick="BT_WeChatQYSave_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                            </td>
                                            <td colspan="2" class="ItemAlignLeft">
                                                <br />
                                                <asp:Label ID="Label2" runat="server" Text="AppID"></asp:Label>
                                                <asp:TextBox ID="TB_WeiXinNo" runat="server"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label214" runat="server" Text="<%$ Resources:lang,MiMa%>"></asp:Label>
                                                <asp:TextBox ID="TB_PassWord" runat="server"></asp:TextBox>
                                                <br />
                                                <asp:Label ID="Label38" runat="server" Text="<%$ Resources:lang,QiYong%>"></asp:Label>
                                                <asp:DropDownList ID="DL_WeiXinGZHStatus" runat="server">
                                                    <asp:ListItem Value="NO">NO</asp:ListItem>
                                                    <asp:ListItem Value="YES">YES</asp:ListItem>
                                                </asp:DropDownList>
                                                <br />
                                                <br />
                                                <asp:Button ID="BT_WeiXinStand" runat="server" CssClass="inpu" OnClick="BT_WeiXinStand_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                            </td>
                                        </tr>

                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <!-- 所有模态框定义 -->
                    <!-- 任务类型模态框 -->
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
                                    <asp:Label ID="Label338" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_TaskTypeSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_TaskTypeNew" runat="server" CssClass="inpu" OnClick="BT_TaskTypeNew_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="TB_TaskTypeDelete" runat="server" CssClass="inpu" OnClick="BT_TaskTypeDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalTaskType')">
                                    <asp:Label ID="BT_Close" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
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
                                <asp:Button ID="BT_OperationDelete" runat="server" CssClass="inpu" OnClick="BT_OperationDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalTaskOperation')">
                                    <asp:Label ID="Label12344345" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>


                            </div>
                        </div>
                    </div>

                    <!-- 任务记录类型模态框 -->
                    <div id="modalTaskRecord" class="modal-overlay">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3>
                                    <asp:Label ID="LabelModalTaskRecord" runat="server" Text="<%$ Resources:lang,RenWuFenPaiJiLuLeiXing%>"></asp:Label></h3>
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
                                <asp:Button ID="BT_TaskRecordDelete" runat="server" CssClass="inpu" OnClick="BT_TaskRecordDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalTaskRecord')">
                                    <asp:Label ID="Label6634533" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
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
                                    <asp:Label ID="Label492261" runat="server" Text="<%$ Resources:lang,ShunXuHao%>"></asp:Label>
                                    <asp:TextBox ID="TB_BankSort" runat="server" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddBank" runat="server" CssClass="inpu" OnClick="BT_AddBank_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteBank" runat="server" CssClass="inpu" OnClick="BT_DeleteBank_Click" OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalBank')">
                                    <asp:Label ID="Label5476753" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
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
                                    <asp:Label ID="Label492262" runat="server" Text="<%$ Resources:lang,FangShi%>"></asp:Label>
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
                                    <asp:Label ID="Label634563" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
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
                                    <asp:DropDownList ID="DL_CodeType" runat="server">
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
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label498" runat="server" Text="<%$ Resources:lang,KaiTouZiFu%>"></asp:Label>
                                    <asp:TextBox ID="TB_HeadChar" runat="server" Width="100px"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label499" runat="server" Text="<%$ Resources:lang,YuGuiZe%>"></asp:Label>
                                    <asp:DropDownList ID="DL_FieldRule" runat="server">
                                        <asp:ListItem>[TAKETOPYEARMONTH]</asp:ListItem>
                                        <asp:ListItem>[TAKETOPYEARMONTHDAY]</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:lang,LiuShuiHaoKuanDu%>"></asp:Label>
                                    <asp:TextBox ID="TB_FlowIDWidth" runat="server" Width="100px"></asp:TextBox>
                                    <asp:Label ID="Label51" runat="server" Text="<%$ Resources:lang,QiYong%>"></asp:Label>
                                    <asp:DropDownList ID="DL_IsStartup" runat="server">
                                        <asp:ListItem Text="<%$ Resources:lang,YES%>" Value="YES" />
                                        <asp:ListItem Text="<%$ Resources:lang,NO%>" Value="NO" />
                                    </asp:DropDownList>
                                </div>
                                <asp:Label ID="LB_CodeRuleID" runat="server" Visible="false"></asp:Label>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_CodeRuleAdd" runat="server" CssClass="inpu" OnClick="BT_CodeRuleAdd_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_CodeRuleDelete" runat="server" CssClass="inpu" OnClick="BT_CodeRuleDelete_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalCodeRule')">
                                    <asp:Label ID="Label3763645" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

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
                                    <asp:Label ID="Label5225235" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
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
                                    <asp:Label ID="Label3677567" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
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
                                    <asp:Label ID="Label25453543" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
                                </button>
                            </div>
                        </div>
                    </div>

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
                                    <asp:Label ID="Label19" runat="server" Text="<%$ Resources:lang,ZhuangTai%>"></asp:Label>
                                    <asp:DropDownList ID="DL_SPInterfaceSTatus" runat="server">
                                        <asp:ListItem Text="<%$ Resources:lang,ChuLiZhong%>" Value="InProgress" />
                                        <asp:ListItem Text="<%$ Resources:lang,BeiYong%>" Value="Backup" />
                                    </asp:DropDownList>
                                </div>
                                <asp:Label ID="LB_SMSInterfaceID" runat="server" Visible="false"></asp:Label>
                            </div>
                            <div class="modal-footer">
                                <asp:Button ID="BT_AddSPInterface" runat="server" CssClass="inpu" OnClick="BT_AddSPInterface_Click" Text="<%$ Resources:lang,BaoCun%>" />
                                <asp:Button ID="BT_DeleteSPInterface" runat="server" CssClass="inpu" OnClick="BT_DeleteSPInterface_Click"  OnClientClick="return confirmContinue(getDeleteMsgByLangCode(), this, event)"  Text="<%$ Resources:lang,ShanChu%>" />
                                <button type="button" class="close-modal" onclick="hideModal('modalSMSInterface')">
                                    <asp:Label ID="Label36745675" runat="server" Text="<%$ Resources:lang,GuanBi%>"></asp:Label>
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
